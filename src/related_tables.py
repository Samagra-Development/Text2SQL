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
        table_match = re.search(table_pattern, schema[match.start():])
        if table_match:
            related_tables.add(table_match.group(1))

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
            table_match = re.search(table_pattern, schema[match.start():])
            if table_match:
                related_tables.add(table_match.group(1))

    # Add the original table to the list of related tables
    related_tables.add(table_name)

    return {table: get_columns_for_table(schema, table, related_columns) for table in related_tables}


def create_subset_schema(subject, related_tables_and_columns, output_file):
    # Add the subject table and all related tables to a set
    tables_to_include = set()
    tables_to_include.add(subject)

    # Create a new schema that includes only the relevant tables and columns
    schema_lines = []
    with open('schema.sql', 'r') as f:
        for line in f:
            if line.startswith('CREATE TABLE '):
                table_name = line.split()[2]
                if table_name in tables_to_include:
                    schema_lines.append(line)
                    for column in related_tables_and_columns[table_name]:
                        schema_lines.append(f'  {column},\n')
                    # Replace the last comma with a closing parenthesis
                    schema_lines[-1] = schema_lines[-1].rstrip(',\n') + ')'

    # Write the new schema to the output file
    with open(output_file, 'w') as f:
        f.write(''.join(schema_lines))
