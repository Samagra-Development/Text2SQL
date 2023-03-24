import re
import sqlite3

def get_related_tables(schema_file, subject):
    # Open a connection to the database
    conn = sqlite3.connect(':memory:')
    cursor = conn.cursor()

    # Load the schema from the file
    with open(schema_file, 'r') as f:
        schema = f.read()

    # Execute the schema to create the tables in the database
    cursor.executescript(schema)

    # Get a list of all tables in the schema
    cursor.execute("SELECT name FROM sqlite_master WHERE type='table'")
    tables = [row[0] for row in cursor.fetchall()]

    print(tables)

    # Identify the tables that are related to the given subject
    related_tables = []
    for table in tables:
        # Check if the table has a foreign key that references the subject table
        cursor.execute(f"PRAGMA foreign_key_list({table})")
        fk_list = cursor.fetchall()
        for fk in fk_list:
            if fk[2] == subject:
                related_tables.append(table)

        # Check if the subject table has a foreign key that references this table
        cursor.execute(f"PRAGMA foreign_key_list({subject})")
        fk_list = cursor.fetchall()
        for fk in fk_list:
            if fk[2] == table:
                related_tables.append(table)

    return related_tables


def get_columns_for_table(table_name, schema):
    """
    Get the list of column names for a given table from a SQL schema string.

    Args:
        table_name (str): The name of the table to get columns for.
        schema (str): The SQL schema string.

    Returns:
        List[str]: A list of column names for the given table.
    """
    columns = []
    match = re.search(f"CREATE TABLE {table_name} \((.*?)\);", schema, re.DOTALL)
    if match:
        column_defs = match.group(1).split(",\n")
        for column_def in column_defs:
            column_name = column_def.strip().split()[0]
            if column_name != 'FOREIGN':
                columns.append(column_name)
    return columns


def get_related_tables_and_columns(schema_file, table_name):
    related_tables = set()
    related_columns = set()

    with open(schema_file, 'r') as f:
        schema = f.read()

    # Look for foreign key constraints that reference the given table
    pattern = r"FOREIGN KEY\s*\(\s*([^)]+)\s*\)\s*REFERENCES\s+{}\s*\(".format(table_name)
    for match in re.finditer(pattern, schema, re.IGNORECASE):
        # Get the name of the column in the foreign key constraint
        column_name = match.group(1).strip()

        # Add the column to the list of related columns
        related_columns.add(column_name)

        # Get the name of the table that contains the foreign key constraint
        table_pattern = r"CREATE TABLE\s+([^\s(]+)"
        table_match = re.findall(table_pattern, schema[:match.start()])[-1]

        if table_match:
            related_tables.add(table_match)

    # Look for tables that have foreign key constraints that reference the related tables
    for related_table in related_tables.copy():
        pattern = r"FOREIGN KEY\s*\(\s*([^)]+)\s*\)\s*REFERENCES\s+{}\s*\(".format(related_table)
        for match in re.finditer(pattern, schema, re.IGNORECASE):
            # Get the name of the column in the foreign key constraint
            column_name = match.group(1).strip()

            # Add the column to the list of related columns
            related_columns.add(column_name)

            # Get the name of the table that contains the foreign key constraint
            table_pattern = r"CREATE TABLE\s+([^\s(]+)"
            table_match = re.findall(table_pattern, schema[:match.start()])[-1]
            if table_match:
                related_tables.add(table_match)

    # Add the original table to the list of related tables
    related_tables.add(table_name)

    return {table: get_columns_for_table(table, schema) for table in related_tables}


def create_subset_schema(schema_file, subject, related_tables_and_columns):

    with open(schema_file, 'r') as f:
        sql = f.read()
    
    create_table_regex = r'CREATE TABLE ([^\s(]+)'
    table_names = re.findall(create_table_regex, sql)

    table_list = list(related_tables_and_columns.keys())
    
    tables = []
    for table_name in table_names:
        if table_name in table_list:
            table_regex = rf'CREATE TABLE {table_name} .*?(?=CREATE TABLE|\Z)'
            table_match = re.search(table_regex, sql, flags=re.DOTALL)
            if table_match:
                tables.append(table_match.group(0))
    sql = ''.join(tables)
    return sql


def get_create_table_statements(schema_file, table_name):
    table_names = [table_name]
    table_queries = set()
    with open(schema_file, 'r') as f:
        schema = f.read()
        # Get create table statement for the given table name
        pattern = f'CREATE TABLE public.{table_name}.*?;'
        match = re.search(pattern, schema, re.DOTALL)
        if match:
            table_queries.add(match.group())
            # Get foreign key related tables
            pattern = f'ALTER TABLE ONLY public.{table_name}\n.*?REFERENCES public.(\w+).*?;'
            fk_matches = re.findall(pattern, schema)
            for fk_match in fk_matches:
                if fk_match not in table_names:
                    table_names.append(fk_match)
        else:
            return None
        # Get create table statements for foreign key related tables
        for table_name in table_names:
            pattern = f'CREATE TABLE public.{table_name}.*?;'
            match = re.search(pattern, schema, re.DOTALL)
            if match:
                table_queries.add(match.group())
        return table_queries


if __name__ == "__main__":
    res = get_create_table_statements('src/sample-schema.sql', 'assessment')
    for r in res:
        print(r)
