import unittest
import os


class Tests(unittest.TestCase):

    # Write a function to setup tests
    def setUp(self):
     # First, create a temporary schema file to use for testing
        pass

    def text_to_sql(NL_text,Schema_ID):
      # write the code to run the query with given natural language code and schema id
        pass

    def test_for_incorrect_spelling():
        # execute the test
        # text_input = "Number of stnts in class 5?"
        # generated_query = text_to_sql(text_input, schema)
    
        # validate the results
        # expected_query = "SELECT COUNT(*) FROM students WHERE class_id = 5"
        # assert generated_query == expected_query
        pass
    
    def test_for_rank():
        pass

    def test_for_nested_queries():
        pass

    def deprecate_schema():
        # delete the schema once the tests are over 
        pass

if __name__ == "__main__":
    # run tests
    pass
