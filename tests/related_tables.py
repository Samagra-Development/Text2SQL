import unittest
from src.related_tables import get_related_tables_and_columns, create_subset_schema

class SimpleQueries(unittest.TestCase):

    def test_create_subset_schema():
         # First, create a temporary schema file to use for testing
        with open('test_schema.sql', 'w') as f:
            f.write("""CREATE TABLE student (
                        id INTEGER PRIMARY KEY autoincrement,
                        name text
                    );

                    CREATE TABLE subject (
                        id INTEGER PRIMARY KEY autoincrement,
                        name text,
                        passingMarks INTEGER
                    );

                    CREATE TABLE midDayMealRecieved (
                        id INTEGER PRIMARY KEY autoincrement,
                        date DATETIME,
                        student_id INTEGER,
                        FOREIGN KEY (student_id) REFERENCES student(id)
                    );

                    CREATE TABLE examMarks (
                        id INTEGER PRIMARY KEY autoincrement,
                        subject_id INTEGER,
                        FOREIGN KEY (subject_id) REFERENCES subject(id),
                        student_id INTEGER,
                        FOREIGN KEY (student_id) REFERENCES student(id),
                        marks INTEGER
                    );""")

        # Define the expected output for the 'subject' table
        expected_output = """CREATE TABLE subject (
                            id INTEGER PRIMARY KEY autoincrement,
                            name text,
                            passingMarks INTEGER
                        );"""

        # Create the subset schema for the 'subject' table
        related_tables_and_columns = get_related_tables_and_columns('test_schema.sql', 'subject')
        create_subset_schema('subject', related_tables_and_columns, 'test_subset_schema.sql')

        # Read the output file and check that it matches the expected output
        with open('test_subset_schema.sql', 'r') as f:
            output = f.read().strip()

        assert output == expected_output

        # Delete the temporary files created for testing
        os.remove('test_schema.sql')
        os.remove('test_subset_schema.sql')


    def test_get_related_tables_and_columns(self):
        schema_file = 'schema.sql'

        # Test for 'subject' table
        table_name = 'subject'
        expected_output = {
            'subject': ['id', 'name'],
            'passingMarks': ['subject', 'passingMarks'],
            'examMarks': ['id', 'subject', 'student']
        }
        assert get_related_tables_and_columns(schema_file, table_name) == expected_output

        # Test for 'student' table
        table_name = 'student'
        expected_output = {
            'student': ['id', 'name'],
            'midDayMealRecieved': ['id', 'date', 'student']
        }
        assert get_related_tables_and_columns(schema_file, table_name) == expected_output

        # Test for 'passingMarks' table
        table_name = 'passingMarks'
        expected_output = {
            'passingMarks': ['subject', 'passingMarks'],
            'subject': ['id', 'name']
        }
        assert get_related_tables_and_columns(schema_file, table_name) == expected_output

        # Test for 'midDayMealRecieved' table
        table_name = 'midDayMealRecieved'
        expected_output = {
            'midDayMealRecieved': ['id', 'date', 'student'],
            'student': ['id', 'name']
        }
        assert get_related_tables_and_columns(schema_file, table_name) == expected_output

        # Test for 'examMarks' table
        table_name = 'examMarks'
        expected_output = {
            'examMarks': ['id', 'subject', 'student'],
            'student': ['id', 'name'],
            'subject': ['id', 'name']
        }
        assert get_related_tables_and_columns(schema_file, table_name) == expected_output


    def test_create_subset_schema(self):
        schema_file = 'schema.sql'

        # Test for 'subject' table
        table_name = 'subject'
        related_tables = {
            'subject': ['id', 'name'],
            'passingMarks': ['subject', 'passingMarks'],
            'examMarks': ['id', 'subject', 'student']
        }
        expected_output = '''CREATE TABLE subject (
            id INTEGER PRIMARY KEY autoincrement,
            name text
        );

        CREATE TABLE passingMarks (
            subject id,
            passingMarks INTEGER,
            FOREIGN KEY (subject) REFERENCES subject(id)
        );

        CREATE TABLE examMarks (
            id INTEGER PRIMARY KEY autoincrement,
            subject id,
            student id,
            FOREIGN KEY (subject) REFERENCES subject(id),
            FOREIGN KEY (student) REFERENCES student(id)
        );
        '''
        assert create_subset_schema(schema_file, table_name, related_tables) == expected_output

        # Test for 'student' table
        table_name = 'student'
        related_tables = {
            'student': ['id', 'name'],
            'midDayMealRecieved': ['id', 'date', 'student']
        }
        expected_output = '''
        CREATE TABLE student (
            id INTEGER PRIMARY KEY autoincrement,
            name text
        );

        CREATE TABLE midDayMealRecieved (
            id INTEGER PRIMARY KEY autoincrement,
            date DATETIME,
            student id,
            FOREIGN KEY (student) REFERENCES student(id)
        );
        '''
        assert create_subset_schema(schema_file, table_name, related_tables) == expected_output

        # Test for 'passingMarks' table
        table_name = 'passingMarks'
        related_tables = {
            'passingMarks': ['subject', 'passingMarks'],
            'subject': ['id', 'name']
        }
        expected_output = '''
        CREATE TABLE subject (
            id INTEGER PRIMARY KEY autoincrement,
            name text
        );

        CREATE TABLE passingMarks (
            subject id,
            passingMarks INTEGER,
            FOREIGN KEY (subject) REFERENCES subject(id)
        );
        '''
        assert create_subset_schema(schema_file, table_name, related_tables) == expected_output

        # Test for 'midDayMealRecieved' table
        table_name = 'midDayMealRecieved'
        related_tables = {
            'midDayMealRecieved': ['id', 'date', 'student'],
            'student': ['id', 'name']
        }
        expected_output = '''
        CREATE TABLE student (
            id INTEGER PRIMARY KEY autoincrement,
            name text
        );

        CREATE TABLE midDayMealRecieved (
            id INTEGER PRIMARY KEY autoincrement,
            date DATETIME,
            student id,
            FOREIGN KEY (student) REFERENCES student(id)
        );
        '''
        assert create_subset_schema(schema_file, table_name, related_tables) == expected_output

        # Test for 'examMarks' table
        table_name = 'examMarks'
        related_tables = {
            'examMarks': ['id', 'subject', 'student'],
            'student': ['id', 'name'],
            'subject': ['id', 'name']
        }
        expected_output = '''
        CREATE TABLE student (
            id INTEGER PRIMARY KEY autoincrement,
            name text
        );

        CREATE TABLE subject (
            id INTEGER PRIMARY KEY autoincrement,
            name text
        );

        CREATE TABLE examMarks (
            id INTEGER PRIMARY KEY autoincrement,
            subject id,
            student id,
            FOREIGN KEY (subject) REFERENCES subject(id),
            FOREIGN KEY (student) REFERENCES student(id)
        );
        '''
        assert create_subset_schema(schema_file, table_name, related_tables) == expected_output