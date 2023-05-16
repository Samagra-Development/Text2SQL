import re
import networkx as nx
import sqlalchemy
from sqlalchemy import MetaData, text
from sqlalchemy.schema import ForeignKeyConstraint
from testcontainers.mysql import MySqlContainer
import pygraphviz as pgv

def parse_check_constraints(sql_statements):
    check_constraints = {}
    current_table = None
    for statement in sql_statements:
        if "CREATE TABLE" in statement:
            match = re.search(r"CREATE TABLE (\w+)", statement)
            if match:
                current_table = match.group(1)
        if "CHECK" in statement:
            match = re.search(r"CHECK\s*\((.+?)\)", statement)
            if match:
                check_constraint = match.group(1)
                if current_table not in check_constraints:
                    check_constraints[current_table] = [check_constraint]
                else:
                    check_constraints[current_table].append(check_constraint)
    return check_constraints


def parse_unique_constraints(sql_statements):
    unique_constraints = {}
    current_table = None
    for statement in sql_statements:
        if "CREATE TABLE" in statement:
            match = re.search(r"CREATE TABLE (\w+)", statement)
            if match:
                current_table = match.group(1)
        if "UNIQUE" in statement:
            matches = re.finditer(r"UNIQUE\s*\((.+?)\)", statement)
            matches = re.finditer(r"(\w+)\s+(\w+\s*\(\s*\w+\s*\))\s+UNIQUE", statement)
            if matches:
                for match in matches:
                    unique_columns = match.group(1).split(",")
                    unique_columns = [column.strip() for column in unique_columns]
                    if current_table not in unique_constraints:
                        unique_constraints[current_table] = [unique_columns]
                    else:
                        unique_constraints[current_table].append(unique_columns)
            matches = re.finditer(r"UNIQUE\s*\((.+?)\)", statement)
            if matches:
                for match in matches:
                    unique_columns = match.group(1).split(",")
                    unique_columns = [column.strip() for column in unique_columns]
                    if current_table not in unique_constraints:
                        unique_constraints[current_table] = [unique_columns]
                    else:
                        unique_constraints[current_table].append(unique_columns)
    return unique_constraints

def parse_inline_foreign_keys(sql_statements):
    inline_foreign_keys = {}
    current_table = None
    for statement in sql_statements:
        if "CREATE TABLE" in statement:
            match = re.search(r"CREATE TABLE (\w+)", statement)
            if match:
                current_table = match.group(1)
        if "REFERENCES" in statement and "FOREIGN KEY" not in statement:
            matches = re.finditer(r"\b(\w+)\b\s+(\w+)(?:\((\d+)\))?\s+NOT NULL REFERENCES\s+(\w+)\s*\((\w+)\)", str(statement))
            if matches:
                for match in matches:
                    parent_column = match.group(1)
                    parent_datatype = match.group(2)
                    ref_table = match.group(4)
                    ref_column = match.group(5)
                    # inline_foreign_key = {parent_column: ref_table, "table": ref_column}
                    inline_foreign_key = {
                        "parent_column": parent_column,
                        "parent_datatype": parent_datatype,
                        "ref_table": ref_table,
                        "ref_column": ref_column,
                    }
                    if current_table not in inline_foreign_keys:
                        inline_foreign_keys[current_table] = [inline_foreign_key]
                    else:
                        inline_foreign_keys[current_table].append(inline_foreign_key)
    return inline_foreign_keys

def parse_not_null_constraints(sql_statements):
    not_null_constraints = {}
    current_table = None
    for statement in sql_statements:
        if "CREATE TABLE" in statement:
            match = re.search(r"CREATE TABLE (\w+)", statement)
            if match:
                current_table = match.group(1)
        if "NOT NULL" in statement:
            matches = re.finditer(r"\b(\w+)\b\s+(\w+)(?:\((\d+)\))?\s+NOT NULL", str(statement))
            if matches:
                for match in matches:
                    column_name = match.group(1)
                    if current_table not in not_null_constraints:
                        not_null_constraints[current_table] = [column_name]
                    else:
                        not_null_constraints[current_table].append(column_name)
    return not_null_constraints

def parse_primary_keys(metadata):
    primary_keys = {}
    if metadata.tables:
        for table in metadata.tables.values():
            primary_key_columns = [col.name for col in table.primary_key.columns]
            primary_keys[table.name] = primary_key_columns
    return primary_keys


def parse_foreign_key_constraints(metadata, engine):
    foreign_keys = {}
    inspector = sqlalchemy.inspect(engine)
    for table in metadata.tables.values():
        foreign_key_list = []
        for fk in inspector.get_foreign_keys(table.name):
            ref_table = fk['referred_table']
            for column, ref_column in zip(fk['constrained_columns'], fk['referred_columns']):
                foreign_key_list.append({
                    "parent_column": column,
                    "ref_table": ref_table,
                    "ref_column": ref_column,
                })
        foreign_keys[table.name] = foreign_key_list
    return foreign_keys

def sql_to_graph(schema):
    with MySqlContainer("mysql:latest", MYSQL_USER="root", MYSQL_ROOT_PASSWORD="password") as mysql:
        metadata = MetaData()
        engine = sqlalchemy.create_engine(mysql.get_connection_url())
        sql_statements = schema.strip().split(";")
        sql_statements = [stmt.strip() for stmt in sql_statements if stmt.strip()]

        with engine.connect() as conn:
            for statement in sql_statements:
                conn.execute(text(statement))

        inline_foreign_keys = parse_inline_foreign_keys(sql_statements)
        not_null_constraints = parse_not_null_constraints(sql_statements)
        metadata.reflect(bind=engine)
        primary_keys = parse_primary_keys(metadata)
        foreign_keys = parse_foreign_key_constraints(metadata, engine)
        check_constraints = parse_check_constraints(sql_statements)

        G = nx.DiGraph()

        for table in metadata.tables.values():
            #primary_key_columns = [col.name for col in table.primary_key.columns]
            primary_key_columns = primary_keys[table.name]
            G.add_node(table.name, type="table", primary_key=primary_key_columns)

            inspector = sqlalchemy.inspect(engine)
            unique_constraints = inspector.get_unique_constraints(table.name)
            table_unique_columns = {}
            for uc in unique_constraints:
                table_unique_columns.update({col: uc["name"] for col in uc["column_names"]})

            for column in inspector.get_columns(table.name):
                column_node = f"{table.name}__{column['name']}"
                G.add_node(
                    column_node,
                    type="column",
                    data_type=str(column['type']),
                    constraints=[],
                )
                G.add_edge(table.name, column_node)

                if table.name in not_null_constraints:
                    if column['name'] in not_null_constraints[table.name]:
                        G.nodes[column_node]["constraints"].append("NOT NULL")

                inline_fks = foreign_keys[table.name]
                
                for uc in unique_constraints:
                    if column["name"] in uc["column_names"]:
                        constraint_info = {
                            "type": "unique",
                            "name": uc["name"],
                            "columns": uc["column_names"]
                        }
                        G.nodes[column_node]["constraints"].append(constraint_info)

                if table.name in check_constraints:
                    for check in check_constraints[table.name]:
                        constraint_info = {
                            "type": "check",
                            "expression": check
                        }
                        G.nodes[column_node]["constraints"].append(constraint_info)

                column_def = f"{column['name']} {column['type']}"
                if table.name in inline_foreign_keys:
                    for fk in inline_foreign_keys[table.name]:
                        if(fk["parent_column"] == column['name']):
                            ref_table = fk["ref_table"]
                            ref_column = fk["ref_column"]
                            column_def += f" REFERENCES {ref_table}({ref_column})"
                            G.nodes[column_node]["constraints"].append(column_def)
                            G.add_edge(f"{table.name}__{column['name']}", f"{ref_table}__{ref_column}", relationship="foreign_key")


                for fk in inline_fks:
                    ref_table = fk["ref_table"]
                    ref_column = fk["ref_column"]
                    column_def += f" REFERENCES {ref_table}({ref_column})"
                    G.nodes[column_node]["constraints"].append(column_def)
                    G.add_edge(f"{table}__{column_node}", f"{ref_table}__{ref_column}", relationship="foreign_key")


            for constraint in table.constraints:
                if isinstance(constraint, ForeignKeyConstraint):
                    for fk_element in constraint.elements:
                        col = fk_element.parent
                        ref_col = fk_element.column

                        if G.has_edge(
                            f"{table.name}__{col.name}", f"{ref_col.table.name}__{ref_col.name}"
                        ):
                            continue

                        G.add_edge(
                            f"{table.name}__{col.name}",
                            f"{ref_col.table.name}__{ref_col.name}",
                            relationship="foreign_key",
                        )
    return G


def get_sub_graph(G, node, level=1):
    connected_table_nodes = set([node])
    connected_column_nodes = set()

    current_level_table_nodes = set([node])

    for _ in range(level):
        next_level_table_nodes = set()
        for current_table_node in current_level_table_nodes:
            connected_table_nodes.add(current_table_node)
            column_nodes = set(G.successors(current_table_node))
            connected_column_nodes |= column_nodes

            for column_node in column_nodes:
                for neighbor in G.successors(column_node):
                    edge_data = G.get_edge_data(column_node, neighbor)
                    if edge_data.get("relationship") == "foreign_key":
                        ref_table = neighbor.split("__")[0]
                        next_level_table_nodes.add(ref_table)

                for predecessor in G.predecessors(column_node):
                    ref_table = predecessor.split("__")[0]
                    next_level_table_nodes.add(ref_table)

        current_level_table_nodes = next_level_table_nodes

    connected_nodes = connected_table_nodes | connected_column_nodes
    subgraph = G.subgraph(connected_nodes).copy()

    return subgraph

def graph_to_sql(G):
    tables = []

    for node, attrs in G.nodes(data=True):
        if attrs.get('type') == 'table':
            table_sql = f"CREATE TABLE {node} (\n"
            primary_keys = attrs.get("primary_key", [])
            composite_unique_constraints = set()
            check_constraints = set()

            for col_node in G.successors(node):
                col_attrs = G.nodes[col_node]
                if col_attrs.get('type') == 'column':
                    col_name = col_node.split('__')[1]
                    col_sql = f"{col_name} {col_attrs['data_type']}"

                    if col_name in primary_keys:
                        col_sql += " PRIMARY KEY"

                    for constraint in col_attrs.get('constraints', []):
                        if isinstance(constraint, dict) and constraint["type"] == "check":
                            check_constraints.add(constraint["expression"])
                        if isinstance(constraint, dict) and constraint["type"] == "unique":
                            if len(constraint["columns"]) == 1:
                                col_sql += " UNIQUE"
                            else:
                                composite_unique_constraints.add(tuple(constraint["columns"]))


                    if 'unique' in col_attrs.get('constraints', []):
                        col_sql += " UNIQUE"

                    if 'NOT NULL' in col_attrs.get('constraints', []):
                        col_sql += " NOT NULL"

                    foreign_key_constraint = ""
                    for edge in G.edges(col_node, data=True):
                        if edge[2].get("relationship") == "foreign_key":
                            if not foreign_key_constraint:
                                ref_table, ref_col = edge[1].split("__")
                                foreign_key_constraint = f" REFERENCES {ref_table}({ref_col})"
                            else:
                                continue  # If the foreign key constraint is already added, we don't need to add it again.

                    col_sql += foreign_key_constraint
                    table_sql += f"  {col_sql},\n"

            # Add composite unique constraints
            for columns in composite_unique_constraints:
                table_sql += f"  UNIQUE ({', '.join(columns)}),\n"

            # Add check constraints
            for check in check_constraints:
                table_sql += f"  CHECK ({check}),\n"

            table_sql = table_sql.rstrip(",\n") + "\n);"
            tables.append(table_sql)

    return "\n\n".join(tables)


def load(x):
    with open(x) as f:
        ret = f.read()
    return ret


# Read the file /tests/schema/ed.sql
sql_string = load("./tests/schemas/ed.sql")

G = sql_to_graph(sql_string)
nx.draw(G)

AG = nx.nx_agraph.to_agraph(G)

# Save the AGraph graph as a PNG image
AG.draw("graph.png", prog="dot")

print(graph_to_sql(G))

G1 = get_sub_graph(G, 'student', 3)

nx.draw(G1)
AG1 = nx.nx_agraph.to_agraph(G1)

# Save the PyDot graph as a PNG image
AG1.draw("sub-graph.png", prog="dot")

print(graph_to_sql(G1))