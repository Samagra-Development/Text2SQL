### Text2SQL
A simple python library for converting text to SQL queries.
There are two inputs
1. schema.sql - The schema of the database
2. text/prompt - The text to be converted to SQL. Example - "Number of students in class 5?"

The process is
- Figure out the subject of the query (Could be a query to ChatGPT) - "students"; Map it to a table - "students" -> "student"; Map relevant query params to either table or columns; using ChatGPT;
    - [A sample prompt](./prompt/related_tables.md)
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
- Verify the query on a mock DB - `validate_SQL(sql)`

### APIs
- Assuming this system is single tenant and single database query tool
- Onboard a Schema using the `/onboard` API => schema.sql => already onboarded to the database | P2
- `/prompt` => takes in a two param, `prompt` and `schema_id` and based on that prompt return the SQL if ChatGPT provides a valid SQL.

### Installation

```bash
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
pip install -r src/server/sql_graph/requirements.txt
docker compose -f docker-compose.gitpod.yml up -d
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
curl --location 'https://localhost:5078/prompt/v3' \
--header 'Content-Type: application/json' \
--header 'Authorization: Basic dGVzdDp0ZXN0' \
--data '{
    "schema_id": "<Schema ID>",
    "prompt": "How many Primary School are there?"
}'
```

### Setting up dummy education database

```bash
cd src/server/db/mock-data
sudo sh init_mock_data.sh 
```

Note down the Schema_ID that gets printed on the terminal. This will have to be sent as param in the prompt api.

### pygraphviz installation

This will be required for sql_graph.

#### Linux
```bash
sudo apt-get install libgraphviz-dev
pip install --global-option=build_ext --global-option="-I/usr/include/graphviz" --global-option="-L/usr/lib/x86_64-linux-gnu/" --install-option="--library-path=/usr/lib/x86_64-linux-gnu/graphviz" pygraphviz
```

#### Mac OS
```bash
sudo apt-get install libgraphviz-dev
pip install --global-option=build_ext --global-option="-I/opt/homebrew/Cellar/graphviz/8.0.5/include/" --global-option="-L/opt/homebrew/Cellar/graphviz/8.0.5/lib/" pygraphviz
```

# Contribution
Check our [QuickStart guide](./contribution.md) if you want to contribute to this project.
