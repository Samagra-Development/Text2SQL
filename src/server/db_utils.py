import traceback
from pathlib import Path
import psycopg2
import os
import re
from uuid import uuid4
from psycopg2.extensions import ISOLATION_LEVEL_AUTOCOMMIT
from dotenv import load_dotenv

file = Path(__file__).resolve()
parent, ROOT_FOLDER = file.parent, file.parents[2]
load_dotenv(dotenv_path=f"{ROOT_FOLDER}/.env")


async def get_connection():
    try:
        con = psycopg2.connect(os.getenv('PSQL_DB_URL'))
        con.autocommit = True
        cursor = con.cursor()
        return cursor, con
    except Exception as e:
        print(f"ERROR: {e}, {traceback.print_exc()}")
        raise Exception("Failed to connect to db")


async def insert_into_schema_holder(schema_file, schema_type, schema_name):
    cursor, con = await get_connection()
    try:
        new_db_name = str(uuid4())
        query = f""" INSERT INTO schema_holder (schema_id, schema, schema_type, schema_name) VALUES (%s, %s, %s, %s)"""
        cursor.execute(query, (new_db_name, schema_file, schema_type, schema_name))
        print(f"{new_db_name}: inserted successfully")
        return new_db_name, ""
    except Exception as e:
        print(f"ERROR: {e}, {traceback.print_exc()}")
        return None, str(e)
    finally:
        cursor.close()
        con.close()


async def add_prompts(schema_id, prompt):
    cursor, con = await get_connection()
    try:
        new_db_name = uuid4()
        query = f""" INSERT INTO prompts (schema_id, prompt) VALUES (%s, %s)"""
        cursor.execute(query, (schema_id, prompt))
        print(f"{new_db_name}: inserted successfully")
        return True, ""
    except Exception as e:
        print(f"ERROR: {e}, {traceback.print_exc()}")
        return False, str(e)
    finally:
        cursor.close()
        con.close()


async def get_schema_type_by_schema_id(schema_id):
    cursor, con = await get_connection()
    try:
        query = """select schema_type from schema_holder where schema_id = %s"""
        cursor.execute(query, (schema_id,))
        schema_type = cursor.fetchone()
        schema_type = schema_type[0]
        return schema_type
    except Exception as e:
        print(f"ERROR: {e}, {traceback.print_exc()}")
        return None, str(e)
    finally:
        cursor.close()
        con.close()
