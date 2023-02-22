SUBJECT_QUERY_PROMPT = """"Subject" is defined as the table about which a "natural language statement" query is expressed. "Query params" includes all the tables that need to be joined/queried for the selection of the subject.
Assuming a database has the following tables - "%s". You can assume any linkage between the above tables and generate a SQL Schema that can be inserted in a Postgresql DB. Store the value as "schema.sql"
Given this query in natural language - "%s", and the "schema.sql" generated above, return the "subject" and query params.
-----------------------------
Format the answer in JSON code as follows
{ subject: <name of the table containing subject>
relatedTables: <comma separated query params as an array>}
-----------------------------
Don't include anything else."""