import pytest
import sqlalchemy
from sqlalchemy import MetaData, text, inspect
from sqlalchemy.schema import ForeignKeyConstraint
from testcontainers.mysql import MySqlContainer

from src.graph_modified import (
    sql_to_graph,
    get_sub_graph,
    graph_to_sql,
    parse_not_null_constraints,
    parse_check_constraints,
    parse_unique_constraints,
    parse_primary_keys,
    parse_foreign_key_constraints
)

@pytest.fixture(scope="function")
def mysql_db():
    def _mysql_db(sql_statements):
        container = MySqlContainer("mysql:8.0")
        container.start()
        engine = sqlalchemy.create_engine(container.get_connection_url())
        metadata = MetaData()
        metadata.bind = engine
        inspector = inspect(engine)

        with engine.connect() as conn:
            for statement in sql_statements:
                conn.execute(text(statement))

        metadata.reflect(bind=engine)

        return metadata, inspector, engine, container

    return _mysql_db

def test_sql_to_graph():
    schema = """
    CREATE TABLE student (id INT NOT NULL PRIMARY KEY, name VARCHAR(255) NOT NULL);
    CREATE TABLE course (id INT NOT NULL PRIMARY KEY, name VARCHAR(255) NOT NULL);
    CREATE TABLE enrollment (student_id INT NOT NULL, course_id INT NOT NULL, FOREIGN KEY (student_id) REFERENCES student(id) ON DELETE CASCADE, FOREIGN KEY (course_id) REFERENCES course(id) ON DELETE CASCADE
    );
    """

    G = sql_to_graph(schema)

    assert len(G.nodes) == 9
    assert len(G.edges) == 8
    assert G.nodes["student"]["type"] == "table"
    assert G.nodes["student__id"]["type"] == "column"
    assert G.nodes["student__name"]["type"] == "column"


def test_get_sub_graph():
    schema = """
    CREATE TABLE student (id INT NOT NULL PRIMARY KEY, name VARCHAR(255) NOT NULL);
    CREATE TABLE course (id INT NOT NULL PRIMARY KEY, name VARCHAR(255) NOT NULL);
    CREATE TABLE enrollment (student_id INT NOT NULL, course_id INT NOT NULL, FOREIGN KEY (student_id) REFERENCES student(id) ON DELETE CASCADE, FOREIGN KEY (course_id) REFERENCES course(id) ON DELETE CASCADE
    );
    """

    G = sql_to_graph(schema)
    subgraph = get_sub_graph(G, "student", 2)

    assert len(subgraph.nodes) == 6
    assert len(subgraph.edges) == 5

def normalize_sql_string(sql_string):
    sql_string = sql_string.lower()
    sql_string = sql_string.replace(" ", "")
    sql_string = sql_string.replace(";", "")
    return sql_string


def test_graph_to_sql():
    schema = """
    CREATE TABLE student (id INT NOT NULL PRIMARY KEY, name VARCHAR(255) NOT NULL);
    CREATE TABLE course (id INT NOT NULL PRIMARY KEY, name VARCHAR(255) NOT NULL);
    CREATE TABLE enrollment (student_id INT NOT NULL, course_id INT NOT NULL, FOREIGN KEY (student_id) REFERENCES student(id) ON DELETE CASCADE, FOREIGN KEY (course_id) REFERENCES course(id) ON DELETE CASCADE);
    """

    G = sql_to_graph(schema)
    sql_result = graph_to_sql(G)

    expected_sql_result = (
        "CREATE TABLE student (\n"
        "  id INTEGER PRIMARY KEY NOT NULL,\n"
        "  name VARCHAR(255) NOT NULL\n);"
        "\n"
        "CREATE TABLE course (\n"
        "  id INTEGER PRIMARY KEY NOT NULL,\n"
        "  name VARCHAR(255) NOT NULL\n);"
        "\n"
        "CREATE TABLE enrollment (\n"
        "  student_id INTEGER NOT NULL,\n"
        "  course_id INTEGER NOT NULL,\n"
        "  FOREIGN KEY (course_id) REFERENCES course(id) ON DELETE CASCADE,\n"
        "  FOREIGN KEY (student_id) REFERENCES student(id) ON DELETE CASCADE\n);")
    
    sql_result = sql_result.strip().split(";")
    sql_result = [stmt.strip() for stmt in sql_result if stmt.strip()]
    sql_result = sorted(sql_result)

    expected_sql_result = expected_sql_result.strip().split(";")
    expected_sql_result = [stmt.strip() for stmt in expected_sql_result if stmt.strip()]
    expected_sql_result = sorted(expected_sql_result)

    print(sql_result, expected_sql_result)

    assert sql_result == expected_sql_result


def test_sql_to_graph_empty_schema():
    schema = ""

    G = sql_to_graph(schema)

    assert len(G.nodes) == 0
    assert len(G.edges) == 0


def test_sql_to_graph_self_referencing_table():
    schema = """
    CREATE TABLE employee (
        id INT NOT NULL PRIMARY KEY,
        name VARCHAR(255) NOT NULL,
        manager_id INT REFERENCES employee(id)
    );
    """

    G = sql_to_graph(schema)

    assert len(G.nodes) == 4
    assert len(G.edges) == 3
    assert G.nodes["employee"]["type"] == "table"
    assert G.nodes["employee__id"]["type"] == "column"
    assert G.nodes["employee__name"]["type"] == "column"
    assert G.nodes["employee__manager_id"]["type"] == "column"


def test_get_sub_graph_empty():
    schema = """
    CREATE TABLE student (id INT NOT NULL PRIMARY KEY, name VARCHAR(255) NOT NULL);
    CREATE TABLE course (id INT NOT NULL PRIMARY KEY, name VARCHAR(255) NOT NULL);
    """

    G = sql_to_graph(schema)
    subgraph = get_sub_graph(G, "student", 0)

    assert len(subgraph.nodes) == 1
    assert len(subgraph.edges) == 0


def test_graph_to_sql_self_referencing_table():
    schema = """
    CREATE TABLE employee (
        id INT NOT NULL PRIMARY KEY,
        name VARCHAR(255) NOT NULL,
        manager_id INT NOT NULL,
        FOREIGN KEY (manager_id) REFERENCES employee(id)
    );
    """

    G = sql_to_graph(schema)
    sql_result = graph_to_sql(G)

    expected_sql_result = (
        "CREATE TABLE employee (\n"
        "  id INTEGER PRIMARY KEY NOT NULL,\n"
        "  name VARCHAR(255) NOT NULL,\n"
        "  manager_id INTEGER NOT NULL,\n"
        "  FOREIGN KEY (manager_id) REFERENCES employee(id)\n);"
    )

    assert sql_result == expected_sql_result

def test_parse_not_null_constraints(mysql_db):
    sql_statements = [
        "CREATE TABLE student (id INT NOT NULL PRIMARY KEY, name VARCHAR(255) NOT NULL);",
        "CREATE TABLE course (id INT NOT NULL PRIMARY KEY, name VARCHAR(255) NOT NULL);",
        "CREATE TABLE enrollment (student_id INT NOT NULL REFERENCES student(id), course_id INT NOT NULL REFERENCES course(id), FOREIGN KEY (student_id) REFERENCES student(id) ON DELETE CASCADE, FOREIGN KEY (course_id) REFERENCES course(id) ON DELETE CASCADE);"
    ]

    # Creating metadata and engine
    metadata, inspector, engine, container = mysql_db(sql_statements)

    expected_not_null_constraints = {
        "student": ["id", "name"],
        "course": ["id", "name"],
        "enrollment": ["student_id", "course_id"],
    }

    result = parse_not_null_constraints(metadata)
    assert result == expected_not_null_constraints


def test_sql_to_graph_unique_constraints(mysql_db):
    # Test individual unique constraint
    schema = [
    "CREATE TABLE student (id INT NOT NULL PRIMARY KEY, name VARCHAR(255) NOT NULL UNIQUE);"
    ]

    # Creating metadata and engine
    metadata, inspector, engine, container = mysql_db(schema)


    expected_unique_constraints = {
        "student": {
            "name": ["name"]
        }
    }
    result = parse_unique_constraints(metadata, inspector)
    assert result == expected_unique_constraints

    # Test composite unique constraint
    schema = [
    "CREATE TABLE student (id INT NOT NULL PRIMARY KEY, name VARCHAR(255) NOT NULL, age INT NOT NULL, UNIQUE (name, age));"
    ]

    # Creating metadata and engine
    metadata, inspector, engine, container = mysql_db(schema)

    expected_unique_constraints = {
        "student": {
            "name": ["name", "age"]
        }
    }
    result = parse_unique_constraints(metadata, inspector)
    assert result == expected_unique_constraints



def test_sql_to_graph_primary_key_constraints(mysql_db):
    
    schema = [
    "CREATE TABLE student (id INT NOT NULL PRIMARY KEY, name VARCHAR(255) NOT NULL);"
    ]

    # Creating metadata and engine
    metadata, inspector, engine, container = mysql_db(schema)

    expected_primary_keys = {
        "student": ["id"]
    }
    result = parse_primary_keys(metadata)
    assert result == expected_primary_keys


def test_get_sub_graph_no_neighbors():
    schema = """
    CREATE TABLE student (id INT NOT NULL PRIMARY KEY, name VARCHAR(255) NOT NULL);
    CREATE TABLE course (id INT NOT NULL PRIMARY KEY, name VARCHAR(255) NOT NULL);
    """

    G = sql_to_graph(schema)
    subgraph = get_sub_graph(G, "student", 1)

    assert len(subgraph.nodes) == 3
    assert len(subgraph.edges) == 2

def test_parse_check_constraints(mysql_db):
    sql_statements = [
        "CREATE TABLE student (id INT PRIMARY KEY, age INT NOT NULL, CHECK (age >= 18));"
    ]

    # Creating metadata and engine
    metadata, inspector, engine, container = mysql_db(sql_statements)

    expected_check_constraints = {
        "student": ["(`age` >= 18)"]
    }

    result = parse_check_constraints(metadata)
    assert result == expected_check_constraints


def test_parse_foreign_key_constraints(mysql_db):

    schema = [
    "CREATE TABLE student (id INT PRIMARY KEY, age INT NOT NULL);",
    "CREATE TABLE enrollment (id INT PRIMARY KEY, student_id INT, FOREIGN KEY (student_id) REFERENCES student(id));"
    ]

    # Creating metadata and engine
    metadata, inspector, engine, container = mysql_db(schema)

    expected_foreign_key_constraints = {'enrollment': [{'parent_column': 'student_id', 'ref_table': 'student', 'ref_column': 'id'}, 
                                                        {'parent_column': 'student_id', 'ref_table': 'student', 'ref_column': 'id', 'ondelete': '', 'onupdate': '', 'deferrable': '', 'initially': ''}], 
                                                        'student': []}

    result = parse_foreign_key_constraints(metadata, engine)
    assert result == expected_foreign_key_constraints



def test_sql_to_graph_check_constraints():
    schema = """
    CREATE TABLE student (id INT PRIMARY KEY, age INT NOT NULL, CHECK (age >= 18));
    """

    G = sql_to_graph(schema)

    assert {'expression': '(`age` >= 18)', 'type': 'check'} in G.nodes["student__age"]["constraints"]


def test_sql_to_graph_foreign_key_constraints():
    schema = """
    CREATE TABLE student (id INT PRIMARY KEY, age INT NOT NULL);
    CREATE TABLE enrollment (id INT PRIMARY KEY, student_id INT, FOREIGN KEY (student_id) REFERENCES student(id));
    """

    G = sql_to_graph(schema)

    assert ("enrollment__student_id", "student__id") in G.edges


def test_graph_to_sql_check_constraints():
    schema = """
    CREATE TABLE student (id INT PRIMARY KEY, age INT NOT NULL, CHECK (age >= 18));
    """

    G = sql_to_graph(schema)
    sql_result = graph_to_sql(G)

    expected_sql_result = (
        "CREATE TABLE student (\n"
        "  id INTEGER PRIMARY KEY NOT NULL,\n"
        "  age INTEGER NOT NULL,\n"
        "  CHECK (`age` >= 18)\n);"
    )

    sql_result = normalize_sql_string(sql_result)
    expected_sql_result = normalize_sql_string(expected_sql_result)

    assert sql_result == expected_sql_result


def test_graph_to_sql_foreign_key_constraints():
    schema = """
    CREATE TABLE student (id INT PRIMARY KEY, age INT NOT NULL);
    CREATE TABLE enrollment (id INT PRIMARY KEY, student_id INT, FOREIGN KEY (student_id) REFERENCES student(id));
    """

    G = sql_to_graph(schema)
    sql_result = graph_to_sql(G)

    expected_sql_result = (
        "CREATE TABLE student (\n"
        "  id INTEGER PRIMARY KEY NOT NULL,\n"
        "  age INTEGER NOT NULL\n);\n\n"
        "CREATE TABLE enrollment (\n"
        "  id INTEGER PRIMARY KEY NOT NULL,\n"
        "  student_id INTEGER,\n"
        "  FOREIGN KEY (student_id) REFERENCES student(id)\n);"
    )

    # sql_result = normalize_sql_string(sql_result)
    # expected_sql_result = normalize_sql_string(expected_sql_result)
    sql_result = sql_result.strip().split(";")
    sql_result = [stmt.strip() for stmt in sql_result if stmt.strip()]

    expected_sql_result = expected_sql_result.strip().split(";")
    expected_sql_result = [stmt.strip() for stmt in expected_sql_result if stmt.strip()]

    sql_result = sorted(sql_result)
    expected_sql_result = sorted(expected_sql_result)
    assert sql_result == expected_sql_result

def test_parse_unique_constraints(mysql_db):
    sql_statements = [
        "CREATE TABLE student (id INT PRIMARY KEY, email VARCHAR(255) UNIQUE);"
    ]

    metadata, inspector, engine, container = mysql_db(sql_statements)
    
    expected_unique_constraints = {
        "student": {"email": ["email"]}
    }

    result = parse_unique_constraints(metadata, inspector)
    assert result == expected_unique_constraints

    engine.dispose()
    container.stop()


def test_parse_multiple_constraints(mysql_db):
    sql_statements = [
        "CREATE TABLE student (id INT PRIMARY KEY, email VARCHAR(255) UNIQUE, age INT NOT NULL, CHECK (age >= 18));"
    ]

    expected_primary_keys = {"student": ["id"]}
    expected_unique_constraints = {"student": {'email': ["email"]}}
    expected_not_null_constraints = {"student": ["id", "age"]}
    expected_check_constraints = {"student": ["(`age` >= 18)"]}

    metadata, inspector, engine, container = mysql_db(sql_statements)

    result_primary_keys = parse_primary_keys(metadata)
    result_unique_constraints = parse_unique_constraints(metadata, inspector)
    result_not_null_constraints = parse_not_null_constraints(metadata)
    result_check_constraints = parse_check_constraints(metadata)

    assert result_primary_keys == expected_primary_keys
    assert result_unique_constraints == expected_unique_constraints
    assert result_not_null_constraints == expected_not_null_constraints
    assert result_check_constraints == expected_check_constraints


def test_graph_to_sql_unique_constraints():
    schema = """
    CREATE TABLE student (id INT PRIMARY KEY, email VARCHAR(255) UNIQUE);
    """

    G = sql_to_graph(schema)
    sql_result = graph_to_sql(G)

    expected_sql_result = (
        "CREATE TABLE student (\n"
        "  id INTEGER PRIMARY KEY NOT NULL,\n"
        "  email VARCHAR(255),\n"
        "CONSTRAINT email UNIQUE(email)\n);"
    )

    sql_result = normalize_sql_string(sql_result)
    expected_sql_result = normalize_sql_string(expected_sql_result)
    print(sql_result) 
    print(expected_sql_result)
    assert sql_result == expected_sql_result


def test_graph_to_sql_multiple_constraints():
    schema = """
    CREATE TABLE student (id INT PRIMARY KEY, email VARCHAR(255) UNIQUE, age INT NOT NULL, CHECK (age >= 18));
    """

    G = sql_to_graph(schema)
    sql_result = graph_to_sql(G)

    expected_sql_result = (
        "CREATE TABLE student (\n"
        "  id INTEGER PRIMARY KEY NOT NULL,\n"
        "  email VARCHAR(255),\n"
        "  age INTEGER NOT NULL,\n"
        "  CONSTRAINT email UNIQUE (email),\n"
        "  CHECK (`age` >= 18)\n);"
    )

    sql_result = normalize_sql_string(sql_result)
    expected_sql_result = normalize_sql_string(expected_sql_result)

    assert sql_result == expected_sql_result

def test_empty_input(mysql_db):
    sql_statements = []

    # Creating metadata and engine
    metadata, inspector, engine, container = mysql_db(sql_statements)

    expected_primary_keys = {}
    expected_unique_constraints = {}
    expected_not_null_constraints = {}
    expected_check_constraints = {}

    result_primary_keys = parse_primary_keys(metadata)
    result_unique_constraints = parse_unique_constraints(metadata, inspector)
    result_not_null_constraints = parse_not_null_constraints(metadata)
    result_check_constraints = parse_check_constraints(metadata)

    assert result_primary_keys == expected_primary_keys
    assert result_unique_constraints == expected_unique_constraints
    assert result_not_null_constraints == expected_not_null_constraints
    assert result_check_constraints == expected_check_constraints


def test_no_constraints(mysql_db):
    sql_statements = [
        "CREATE TABLE student (id INT, name VARCHAR(255));"
    ]

    # Creating metadata and engine
    metadata, inspector, engine, container = mysql_db(sql_statements)

    expected_primary_keys = {'student': []}
    expected_unique_constraints = {}
    expected_not_null_constraints = {}
    expected_check_constraints = {}

    result_primary_keys = parse_primary_keys(metadata)
    result_unique_constraints = parse_unique_constraints(metadata, inspector)
    result_not_null_constraints = parse_not_null_constraints(metadata)
    result_check_constraints = parse_check_constraints(metadata)

    assert result_primary_keys == expected_primary_keys
    assert result_unique_constraints == expected_unique_constraints
    assert result_not_null_constraints == expected_not_null_constraints
    assert result_check_constraints == expected_check_constraints


def test_graph_to_sql_no_constraints():
    schema = """
    CREATE TABLE student (id INT, name VARCHAR(255));
    """

    G = sql_to_graph(schema)
    sql_result = graph_to_sql(G)

    expected_sql_result = (
        "CREATE TABLE student (\n"
        "  id INTEGER,\n"
        "  name VARCHAR(255)\n);"
    )

    sql_result = normalize_sql_string(sql_result)
    expected_sql_result = normalize_sql_string(expected_sql_result)

    assert sql_result == expected_sql_result


def test_invalid_sql_input(mysql_db):
    sql_statements = [
        "INVALID SQL STATEMENT"
    ]

    result, error_message = sql_to_graph(sql_statements)

    assert result is None
    assert "An error occurred while parsing the schema:" in error_message

def test_single_column_table(mysql_db):
    sql_statements = [
        "CREATE TABLE single_column (id INT PRIMARY KEY);"
    ]

    # Creating metadata and engine
    metadata, inspector, engine, container = mysql_db(sql_statements)

    expected_primary_keys = {"single_column": ["id"]}
    expected_unique_constraints = {}
    expected_not_null_constraints = {"single_column": ["id"]}
    expected_check_constraints = {}

    result_primary_keys = parse_primary_keys(metadata)
    result_unique_constraints = parse_unique_constraints(metadata, inspector)
    result_not_null_constraints = parse_not_null_constraints(metadata)
    result_check_constraints = parse_check_constraints(metadata)

    assert result_primary_keys == expected_primary_keys
    assert result_unique_constraints == expected_unique_constraints
    assert result_not_null_constraints == expected_not_null_constraints
    assert result_check_constraints == expected_check_constraints


def test_all_constraints_no_columns():
    sql_statements = [
        "CREATE TABLE no_columns ();",
        "ALTER TABLE no_columns ADD PRIMARY KEY ();",
        "ALTER TABLE no_columns ADD UNIQUE ();",
        "ALTER TABLE no_columns ADD CHECK ();",
    ]

    # Creating metadata and engine
    result, error_message = sql_to_graph(sql_statements)

    assert result is None
    assert "An error occurred while parsing the schema:" in error_message


def test_only_whitespace_input():
    sql_statements = [
        "   \t \n  "
    ]

    result, error_message = sql_to_graph(sql_statements)

    assert result is None
    assert "An error occurred while parsing the schema:" in error_message


def test_missing_semicolon(mysql_db):
    sql_statements = [
        "CREATE TABLE student (id INT, name VARCHAR(255))"
    ]

    result, error_message = sql_to_graph(sql_statements)
    
    assert result is None
    assert "An error occurred while parsing the schema:" in error_message

def test_invalid_sql_statement():
    sql_statements = [
        "CREATE TABL students (id INT PRIMARY KEY, name VARCHAR(255) NOT NULL);"
    ]

    result, error_message = sql_to_graph(sql_statements)

    assert result is None
    assert "An error occurred while parsing the schema:" in error_message


def test_commented_lines(mysql_db):
    sql_statements = ["""
    -- This is a commented line,
    CREATE TABLE students (id INT PRIMARY KEY, name VARCHAR(255) NOT NULL);
    /* This is a multiline,
    comment block */
    """]

    # Creating metadata and engine
    metadata, inspector, engine, container = mysql_db(sql_statements)

    expected_primary_keys = {"students": ["id"]}
    expected_unique_constraints = {}
    expected_not_null_constraints = {"students": ["id", "name"]}
    expected_check_constraints = {}

    result_primary_keys = parse_primary_keys(metadata)
    result_unique_constraints = parse_unique_constraints(metadata, inspector)
    result_not_null_constraints = parse_not_null_constraints(metadata)
    result_check_constraints = parse_check_constraints(metadata)

    assert result_primary_keys == expected_primary_keys
    assert result_unique_constraints == expected_unique_constraints
    assert result_not_null_constraints == expected_not_null_constraints
    assert result_check_constraints == expected_check_constraints


def test_non_string_input():
    sql_statements = [1, 2, 3]

    result, error_message = sql_to_graph(sql_statements)

    assert result is None
    assert "An error occurred while parsing the schema: 'list' object has no attribute 'strip'" in error_message
