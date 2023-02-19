### Text2SQL
A simple python library for converting text to SQL queries.
There are two inputs
1. schema.sql - The schema of the database
2. text/prompt - The text to be converted to SQL. Example - "Number of students in class 5?"

The process is
- Figure out the subject of the query (Could be a query to ChatGPT) - "students"; Map it to a table - "students" -> "student"; Map relevant query params to either table or columns; using ChatGPT;
    - A sample query to ChatGPT - 
    ```txt
        Given this query in natural language "Get all students who passed the maths exam and got the mid day meal today?" return the subject of the query by table name and query params assuming the system has the following table - "student, subject, midDayMealRecieved and examMarks
    ```
    - A sample response -
    ```txt
        Table name: student

        Query params:

            subject: maths
            examMarks: passed
            midDayMealRecieved: today
    ```
- Find out all the tables relevant to the subject - "student" -> ["student", "class", "teacher"]; This could a second level linkage as well.
    - Setup a mock database for that schema (flavour wise - PSQL, SQLite, MySQL, etc.)
    - Insert the schema into the mock database
    - Run a query like this for the relevant flavour - `SELECT name FROM sqlite_master WHERE type='table'` to the tables having the subject in it.
    - Return the tables
- Find out all the columns relevant to the tables in the above step.
    - Currently return all columns for a table
- Create a `schema-relevant.sql` file with the relevant tables and columns
- Create a prompt for the query - "Given this SQL Schema - {schema-relevant.sql}, Can you give a SQL query as a code snippet to "{NL SQL Query}" and don't share with me anything else."
- Send a prompt to ChatGPT
- Return SQL query
- Verify the query on a mock DB

### Running Tests

```bash
python -m unittest tests.related_tables
```