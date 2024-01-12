SUBJECT_QUERY_PROMPT = """"Subject" is defined as the table about which a "natural language statement" query is expressed. "Query params" includes only the relevant tables excluding cache tables that need to be joined/queried for the selection of the subject.
Assuming a database has the following tables in the form of "schema_name.table_name" - "%s". You can assume any linkage between the above tables and generate a SQL Schema with minimal number of tables (top 5) that can be inserted in a sqlite DB.
Given this query in natural language - "%s", and the "schema.sql" generated above, and the schema of the database return the "subject", query params where "subject" is the complete table name, Also add you explanation of all the tables and the schema and also give the step by step guide as to how to create a query to fetch the relevant data for the NLQ.
Understand the NLQ and its requirements then understand the schema and then generate the solution based on the understanding.
Dont add unnecessary join also in the explanation look closely on the columns of each table and then decide upon the steps to follow. Dont fetch unnecessary columns.

Note - Make the schema explanation about what each column means in the table. For example what data it stores and what each columns means as json.
For ex - "table" : {
"column1" : It stores this information
}

```sql
%s
```

-----------------------------
Format the answer in JSON code as follows
{ "subject": <name of the table containing subject>
"relatedTables": <comma separated query params as an array>,
"schemaExplanation": <Explain the meaning of each table and what data it stores. Keep it short and crisp>}
-----------------------------
Don't include anything else."""

SQL_QUERY_PROMPT = """A database schema is given as a list of dictionary where the keys of dictionary are table names, and the values are dictionaries with two keys: "columns" and "references". The "columns" key maps to a list of tuples representing the columns in the table and their data type, and the "references" key maps to a dictionary where the keys are the names of related tables, and the values are dictionaries with two keys: "columns" and "referenced_by". The "columns" key maps to a list of tuples representing the columns in the related table, and the "referenced_by" key maps to a list of dictionaries representing the columns in the current table that reference the related table.
Given the following list, Give a SQL query for %s database as a code snippet to "%s" and don't share anything else. Share only the query dont include any explanation or header.
--------------------------------------
List: %s
----------------------------------
Share only the query dont include anything else"""


VERSION2_PROMPT = """You are an AI that converts natural language query to "%s" sql statements.
You will be provided with Natual language query and you need to provide the sql statement for the same, You can use the following schema to answer the queries and the explanation of the schema. Add meaningful aliases to the COLUMNS since they are going to be directly used to tabulate data. I will also give you the steps that will help you in forming the sql.
Dont add unnecessary join in the explanation look closely on the columns of each table and then decide upon the steps to follow. Also understand the NLQ completely as to what the NLQ is asking, dont fetch unnecessary columns.
NOTE - From the sql_explanation and also looking at the schema sql deduce if the joins will be required and what the NLQ expects and then create a query.
Look at the column names and understand the schema and nlqExplanation before creating the query.

NOTE - Remmeber to only generate sql statement for "%s" only. Use INTERSECT, UNION, JOIN, EXCEPT etc.

```sql

/*
SCHEMA EXPLANATION

%s

*/

%s

```

Input - How many students are there in Lucknow who has first name as "Rahul"
Output - SELECT COUNT(*) as student_count FROM student where Name like "Rahul"

Input - What is the average passing marks for Hindi subject.
Output - SELECT AVG(pass_marks) as passing_marks FROM subject WHERE name = "Hindi";

Input - %s (%s)
"""

VERSION3_PROMPT = """
### Complete sqlite SQL query only and with no explanation, and do not select extra columns that are not
explicitly requested in the query.
### Sqlite SQL schema for the database

%s

%s

###

### %s

```sql
SELECT
```


"""


TEST_CASE_GENERATION = """Based on the following SQL schema
```sql
%s
```
I am building an NLQ builder that needs to have an autocomplete. I need to generate 100 autocomplete suggestions for the NLQ that users would input. Also ensure the a NLQ is sufficient enough to actually get a SQL.
The NLQ should be such that it allows for join between multiple table or tries to summarize data in some format. This is going to be used by data analyst. Avoid queries that return too much data - either summarize this or be very specific. Assume they would be verbose and would be speaking in a conversation mode with this being the first message to initiate conversation with a bot to figure out data.
"""

QUERY_FIX_PROMPT = """You are an AI that converts natural language query to "%s" sql statements.
You will be provided with Natual language query, the current "%s" sql statement, the "error" it is producing while fetching the data and the schema. You need to provide the fixed sql statement for the same, You can use the following schema to answer the query. Add meaningful aliases to the COLUMNS since they are going to be directly used to tabulate data. I will also give you the steps that will help you in forming the sql.
NOTE - Remmeber to only generate sql statement for "%s" only. Share only the query and nothing else. Please fix the sql statement. Your task is to understand the error then look at the schema and NLQ and give a new fixed query according to the sql schema.
### Dont share anything else.

```sql schema

%s

%s

```

```error

%s
```

### Use join in place of IN
For Ex 
Query - SELECT A FROM B WHERE C IN (SELECT D FROM E)
It should be like this
SELECT DISTINCT T1.A FROM B AS T1 JOIN E AS T2 ON T1.A = T2.D

### Share the query in the following format and dont share anything else.

```sql

<Corrected SQL query>

```

"""

VALIDATE_QUERY_PROMPT="""
### You are now an excellent SQL writer. I will give you the schema, its explanation and the query that i have generated for a NLQ. You need to perform the analysis and check if the generated query is correct or not. If not provide the correct query based on the analysis.
Given this schema and its explanation in the form of json where parent key denotes table name and child key denotes the column name. 
### Share only the corrected query if it is wrong or else share the original query if it is correct, dont share any explanation or analysis.

```
%s

%s
```

### This natural language query for which I need the SQL - "%s" 

### This is the query that I have come up with - "%s"

### Verify if this SQL if it is correct or not by following the below process. 

Analyse the NLQ first on what it is asking and then analyse the query. Explain in a table how every NER is mapped to the natural language query. Divide this into as small parts as needed. Keep them in separate rows in a markdown table. Remove parts of the query that are not needed at all. Make no implicit assumptions. Analyse JOINS too and see if those are required or not and remove them if not. 
And do not select extra columns that are not explicitly requested in the query. 
Analyse each column which is being asked and check if the NLQ is asking for it or not, if not then dont include it in query.

Example

<Part of the query> |  Schema Property in English |<Relevant Part of the Natural Language Query> | <Recheck>
s.Age | "Age of the singer" | "Show the name and the release year of the song" | Not correct as this is not required in the query as we need name of the song not singer
s. Song_release_year | "Release Year of the song" | "Show the name and the release year of the song" | Correct
s.Song_release_year | ....

Make no implicit assumptions. Share the correct query based on the above analysis. And do not select extra columns that are not explicitly requested in the query. Also do not cast the column into any other format.

### If the query is wrong Only share the corrected query dont share the old query in the response. if it is correct then share only the query.

### This is very important - Use join in place of IN
For Ex 
Query - SELECT A FROM B WHERE C IN (SELECT D FROM E)
It should be like this
SELECT DISTINCT T1.A FROM B AS T1 JOIN E AS T2 ON T1.A = T2.D

```sql

<Corrected SQL Query>

```

"""
