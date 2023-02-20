### Text2SQL
A simple python library for converting text to SQL queries.
There are two inputs
1. schema.sql - The schema of the database
2. text/prompt - The text to be converted to SQL. Example - "Number of students in class 5?"

The process is
- Onboard a Schema using the `/onboard` API. Store it in a cache with 
- Figure out the subject of the query (Could be a query to ChatGPT) - "students"; Map it to a table - "students" -> "student"; Map relevant query params to either table or columns; using ChatGPT;
    - [A sample prompt](./prompt/related_tables.txt)
    - A sample response -
    ```json
        {
            "subject": "student",
            "relatedTables": ["subject", "midDayMealRecieved", "examMarks"]
        }
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

### Installation

```bash
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
```

### Running Tests

```bash
python -m unittest tests.related_tables
```

### Running the app

```bash
python src/server/app.py
```

### Testing the prompt

```bash
curl --location 'http://localhost:5078/prompt' \
--header 'Content-Type: application/json' \
--header 'Cookie: csrftoken=SWTHvaNeh4g3KImyRotjdDcMYuiW0dw4ctce3LXEkRWHJx71t7nKMLCk70wSdSSB' \
--data '{
    "prompt": "Hey how are you?"
}'
```
