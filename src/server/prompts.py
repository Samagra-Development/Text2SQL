SUBJECT_QUERY_PROMPT = """"Subject" is defined as the table about which a "natural language statement" query is expressed. "Query params" includes only the relevant tables excluding cache tables that need to be joined/queried for the selection of the subject.
Assuming a database has the following tables in the form of "schema_name.table_name" - "%s". You can assume any linkage between the above tables and generate a SQL Schema with minimal number of tables (top 5) that can be inserted in a Postgresql DB. Store the value as "schema.sql"
Given this query in natural language - "%s", and the "schema.sql" generated above, return the "subject" and query params where "subject" is the complete table name.
-----------------------------
Format the answer in JSON code as follows
{ subject: <name of the table containing subject>
relatedTables: <comma separated query params as an array>}
-----------------------------
Don't include anything else."""

SQL_QUERY_PROMPT = """A database schema is given as a list of dictionary where the keys of dictionary are table names, and the values are dictionaries with two keys: "columns" and "references". The "columns" key maps to a list of tuples representing the columns in the table and their data type, and the "references" key maps to a dictionary where the keys are the names of related tables, and the values are dictionaries with two keys: "columns" and "referenced_by". The "columns" key maps to a list of tuples representing the columns in the related table, and the "referenced_by" key maps to a list of dictionaries representing the columns in the current table that reference the related table.
Given the following list, Give a SQL query as a code snippet to "%s" and don't share anything else. Share only the query dont include any explanation or header.
--------------------------------------
List: %s
----------------------------------
Share only the query dont include anything else"""
