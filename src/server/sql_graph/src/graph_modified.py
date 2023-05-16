import re
import networkx as nx
import sqlalchemy
from sqlalchemy import MetaData, text
from sqlalchemy.schema import ForeignKeyConstraint
from testcontainers.mysql import MySqlContainer
import pygraphviz as pgv
from sqlalchemy import inspect
from sqlalchemy.schema import UniqueConstraint

def parse_check_constraints(metadata):
    check_constraints = {}
    
    for table in metadata.tables.values():
        table_check_constraints = []
        
        for constraint in table.constraints:
            if isinstance(constraint, sqlalchemy.schema.CheckConstraint):
                table_check_constraints.append(str(constraint.sqltext).strip())
                
        if table_check_constraints:
            check_constraints[table.name] = table_check_constraints
    
    return check_constraints

def parse_unique_constraints(metadata, inspector):
    unique_constraints = {}
    for table in metadata.sorted_tables:
        table_unique_constraints = {}
        
        # Extract single column unique constraints
        for column in table.columns:
            if column.unique:
                table_unique_constraints[column.name] = [column.name]

        # Extract multi-column unique constraints from UniqueConstraint objects
        for constraint in table.constraints:
            if isinstance(constraint, UniqueConstraint):
                table_unique_constraints[constraint.name] = [column.name for column in constraint.columns]
        
        # Extract multi-column unique constraints from CONSTRAINT statements in CREATE TABLE
        for constraint in inspector.get_unique_constraints(table.name):
            if not constraint['name'] in table_unique_constraints:
                table_unique_constraints[constraint['name']] = constraint['column_names']

        if table_unique_constraints:
            unique_constraints[table.name] = table_unique_constraints

    return unique_constraints


def parse_not_null_constraints(metadata):
    not_null_constraints = {}
    for table in metadata.sorted_tables:
        table_not_null_columns = []
        for column in table.columns:
            if not column.nullable:
                table_not_null_columns.append(column.name)

        if table_not_null_columns:
            not_null_constraints[table.name] = table_not_null_columns

    return not_null_constraints


def parse_primary_keys(metadata):
    primary_keys = {}
    if metadata.tables:
        for table in metadata.tables.values():
            primary_key_columns = [col.name for col in table.primary_key.columns]
            primary_keys[table.name] = primary_key_columns
    return primary_keys

# def parse_foreign_key_constraints(metadata, engine):
#     foreign_keys = {}
#     inspector = sqlalchemy.inspect(engine)
#     for table in metadata.tables.values():
#         foreign_key_list = []
#         for fk in inspector.get_foreign_keys(table.name):
#             ref_table = fk['referred_table']
#             for column, ref_column in zip(fk['constrained_columns'], fk['referred_columns']):
#                 foreign_key_list.append({
#                     "parent_column": column,
#                     "ref_table": ref_table,
#                     "ref_column": ref_column,
#                 })

#         # Handle inline foreign keys with REFERENCES keyword
#         for column in table.columns:
#             for fk in column.foreign_keys:
#                 ref_table = fk.column.table.name
#                 ref_column = fk.column.name
#                 ondelete = f"ON DELETE {fk.ondelete}" if fk.ondelete else ""
#                 onupdate = f"ON UPDATE {fk.onupdate}" if fk.onupdate else ""
#                 deferrable = "DEFERRABLE" if fk.deferrable else ""
#                 initially = f"INITIALLY {fk.initially}" if fk.initially else ""
#                 foreign_key_list.append({
#                     "parent_column": column.name,
#                     "ref_table": ref_table,
#                     "ref_column": ref_column,
#                     "ondelete": ondelete,
#                     "onupdate": onupdate,
#                     "deferrable": deferrable,
#                     "initially": initially,
#                 })

#         foreign_keys[table.name] = foreign_key_list
#     return foreign_keys

def parse_inline_foreign_keys(sql_statements):
    inline_foreign_keys = {}
    current_table = None
    for statement in sql_statements:
        if "CREATE TABLE" in statement:
            match = re.search(r"CREATE TABLE (\w+)", statement)
            if match:
                current_table = match.group(1)
        if "REFERENCES" in statement and "FOREIGN KEY" not in statement:
            matches = re.finditer(r"\b(\w+)\b\s+(\w+)(?:\((\d+)\))?\s+NOT NULL REFERENCES\s+(\w+)\s*\((\w+)\)", statement)
            if matches:
                for match in matches:
                    parent_column = match.group(1)
                    parent_datatype = match.group(2)
                    ref_table = match.group(4)
                    ref_column = match.group(5)
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

def parse_foreign_key_constraints(metadata, engine, sql_statements):
    foreign_keys = {}
    inspector = sqlalchemy.inspect(engine)
    
    # Parse inline foreign keys
    inline_foreign_keys = parse_inline_foreign_keys(sql_statements)
    
    for table in metadata.tables.values():
        foreign_key_list = []
        
        # Add parsed inline foreign keys
        if table.name in inline_foreign_keys:
            foreign_key_list.extend(inline_foreign_keys[table.name])

        # Add explicit foreign keys
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

def add_nodes_and_edges(G, table, not_null_constraints, check_constraints, unique_constraints, foreign_keys, primary_keys):
    G.add_node(table.name, type="table", primary_key=primary_keys[table.name], unique_constraints=unique_constraints.get(table.name, {}))
    for column in table.columns:
        column_node = f"{table.name}__{column.name}"
        G.add_node(
            column_node,
            type="column",
            data_type=str(column.type),
            constraints=[],
        )
        G.add_edge(table.name, column_node)

        if column.name in not_null_constraints.get(table.name, []):
            G.nodes[column_node]["constraints"].append("NOT NULL")

        if column.name in unique_constraints.get(table.name, {}):
            for constraint_name, columns in unique_constraints.get(table.name, {}).items():
                if column.name in columns:
                    constraint_info = {
                        "type": "unique",
                        "name": constraint_name,
                        "columns": columns
                    }
                    G.nodes[column_node]["constraints"].append(constraint_info)
 

        if table.name in check_constraints:
            for check in check_constraints[table.name]:
                constraint_info = {
                    "type": "check",
                    "expression": check
                }
                G.nodes[column_node]["constraints"].append(constraint_info)

        for fk in foreign_keys[table.name]:
            if column.name == fk["parent_column"]:
                ref_table = fk["ref_table"]
                ref_column = fk["ref_column"]
                ondelete = fk.get("ondelete")
                onupdate = fk.get("onupdate")
                deferrable = fk.get("deferrable")
                initially = fk.get("initially")

                constraints = [f"REFERENCES {ref_table}({ref_column})"]
                if ondelete:
                    constraints.append(ondelete)
                if onupdate:
                    constraints.append(onupdate)
                if deferrable:
                    constraints.append(deferrable)
                if initially:
                    constraints.append(initially)

                G.nodes[column_node]["constraints"].append(" ".join(constraints))
                G.add_edge(f"{table.name}__{column.name}", f"{ref_table}__{ref_column}", relationship="foreign_key")

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


def sql_to_graph(schema):
    try:
        # with MySqlContainer("mysql:latest", MYSQL_USER="root", MYSQL_ROOT_PASSWORD="password",use_docker_client=True) as mysql:
        engine = sqlalchemy.create_engine('sqlite:///:memory:')
        metadata = MetaData()
        sql_statements = schema.strip().split(";")
        sql_statements = [stmt.strip() for stmt in sql_statements if stmt.strip()]

        with engine.connect() as conn:
            for statement in sql_statements:
                conn.execute(text(statement))

        metadata.reflect(bind=engine)
        inspector = inspect(engine)
        not_null_constraints = parse_not_null_constraints(metadata)
        primary_keys = parse_primary_keys(metadata)
        foreign_keys = parse_foreign_key_constraints(metadata, engine, sql_statements)
        check_constraints = parse_check_constraints(metadata)
        unique_constraints = parse_unique_constraints(metadata, inspector)

        G = nx.DiGraph()

        for table in metadata.sorted_tables:
            add_nodes_and_edges(G, table, not_null_constraints, check_constraints, unique_constraints, foreign_keys, primary_keys)

        return G, None
    
    except Exception as e:
        return None, f"An error occurred while parsing the schema: {str(e)}"

def graph_to_sql(G):
    tables = []

    for node, attrs in G.nodes(data=True):
        if attrs.get('type') == 'table':
            table_sql = f"CREATE TABLE {node} (\n"
            primary_keys = attrs.get("primary_key", [])
            composite_unique_constraints = attrs.get("unique_constraints", {})
            check_constraints = set()
            foreign_key_constraints = set()

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
                        # if isinstance(constraint, dict) and constraint["type"] == "unique":
                        #     if len(constraint["columns"]) == 1:
                        #         col_sql += " UNIQUE"

                    if 'NOT NULL' in col_attrs.get('constraints', []):
                        col_sql += " NOT NULL"

                    # for edge in G.edges(col_node, data=True):
                    #     if edge[2].get("relationship") == "foreign_key":
                    #         ref_table, ref_col = edge[1].split("__")
                    #         foreign_key_constraints.add(f"FOREIGN KEY ({col_name}) REFERENCES {ref_table}({ref_col})")
                    foreign_key_string = None
                    for constraint in col_attrs.get('constraints', []):
                        if isinstance(constraint, str) and "REFERENCES" in constraint:
                            foreign_key_string = constraint

                    if foreign_key_string:
                        foreign_key_constraints.add(f"FOREIGN KEY ({col_name}) {foreign_key_string}")

                    table_sql += f"  {col_sql},\n"

            # Add composite unique constraints
            for constraint_name, columns in composite_unique_constraints.items():
                table_sql += f"  CONSTRAINT {constraint_name} UNIQUE ({', '.join(columns)}),\n"

            # Add check constraints
            for check in check_constraints:
                table_sql += f"  CHECK {check},\n"

            # Add foreign key constraints
            for fk_constraint in foreign_key_constraints:
                table_sql += f"  {fk_constraint},\n"

            table_sql = table_sql.rstrip(",\n") + "\n);"
            tables.append(table_sql)

    return "\n\n".join(tables)




def load(x):
    with open(x) as f:
        ret = f.read()
    return ret


# # Read the file /tests/schema/ed.sql
# sql_string = load("./tests/schemas/ed.sql")

# G = sql_to_graph(sql_string)
# nx.draw(G)

# AG = nx.nx_agraph.to_agraph(G)

# # Save the AGraph graph as a PNG image
# AG.draw("graph1.png", prog="dot")

# print(graph_to_sql(G))