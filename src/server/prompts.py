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
Given the following list, Give a SQL query for %s database as a code snippet to "%s" and don't share anything else. Share only the query dont include any explanation or header.
--------------------------------------
List: %s
----------------------------------
Share only the query dont include anything else"""


VERSION2_PROMPT = """You are an AI that converts natural language query to %s sql statements.
You will be provided with Natual language query and you need to provide the sql statement for the same, You can use the following schema to answer the queries. Add meaningful aliases to the COLUMNS since they are going to be directly used to tabulate data

```sql

%s

```

Input - How many students are there in Lucknow who has first name as "Rahul"
Output - SELECT COUNT(*) as student_count FROM student where Name like "Rahul"

Input - What is the average passing marks for Hindi subject.
Output - SELECT AVG(pass_marks) as passing_marks FROM subject WHERE name = "Hindi";

Input - %s
"""

TEST_CASE_GENERATION = """Based on the following SQL schema
```sql
%s
```
I am building an NLQ builder that needs to have an autocomplete. I need to generate 100 autocomplete suggestions for the NLQ that users would input. Also ensure the a NLQ is sufficient enough to actually get a SQL.
The NLQ should be such that it allows for join between multiple table or tries to summarize data in some format. This is going to be used by data analyst. Avoid queries that return too much data - either summarize this or be very specific. Assume they would be verbose and would be speaking in a conversation mode with this being the first message to initiate conversation with a bot to figure out data.
"""