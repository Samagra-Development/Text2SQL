from pathlib import Path
import psycopg2
import os
from uuid import uuid4
from psycopg2.extensions import ISOLATION_LEVEL_AUTOCOMMIT
from dotenv import load_dotenv

file = Path(__file__).resolve()
parent, ROOT_FOLDER = file.parent, file.parents[2]
load_dotenv(dotenv_path=f"{ROOT_FOLDER}/.env")


async def get_connection():
    con = psycopg2.connect(os.getenv('PSQL_DB_URL'))
    con.autocommit = True
    cursor = con.cursor()
    return cursor


async def create_database_and_schema(db_name):
    try:
        con = psycopg2.connect(
            user=os.getenv('POSTGRES_USER'),
            password=os.getenv('POSTGRES_PASSWORD'),
            port=os.getenv('POSTGRES_PORT'),
            host=os.getenv('POSTGRES_HOST')
        )
        con.set_isolation_level(ISOLATION_LEVEL_AUTOCOMMIT)
        cursor = con.cursor()
        query = "create database " + db_name + ";"
        cursor.execute(query)
        return True, ""
    except Exception as e:
        print(f"ERROR: {e}")
        return False, str(e)


async def insert_into_schema_holder():
    try:
        cursor = get_connection()
        new_db_name = uuid4()
        query = f""" INSERT INTO schema_holder (db_name) VALUES ({new_db_name})"""
        cursor.execute(query)
        print(f"{new_db_name}: inserted successfully")
        return new_db_name, ""
    except Exception as e:
        print(f"ERROR: {e}")
        return None, str(e)


async def create_schema_in_db(db_name, schema):
    try:
        con = psycopg2.connect(
            user=os.getenv('POSTGRES_USER'),
            password=os.getenv('POSTGRES_PASSWORD'),
            port=os.getenv('POSTGRES_PORT'),
            host=os.getenv('POSTGRES_HOST'),
            dbname=db_name
        )
        con.autocommit=True
        # con.set_isolation_level(ISOLATION_LEVEL_AUTOCOMMIT)
        cursor = con.cursor()
        cursor.execute(schema)
        return True, ""
    except Exception as e:
        print(f"ERROR: {e}")
        return False, str(e)


async def add_prompts(schema_id, prompt):
    try:
        cursor = get_connection()
        new_db_name = uuid4()
        query = f""" INSERT INTO prompts (schema_id, prompt) VALUES (%s, %s)"""
        cursor.execute(query, (schema_id, prompt))
        print(f"{new_db_name}: inserted successfully")
        return True, ""
    except Exception as e:
        print(f"ERROR: {e}")
        return False, str(e)


async def get_tables_from_schema_id(schema_id):
    try:
        print("ROOOT", ROOT_FOLDER, os.getenv('POSTGRES_PORT'))
        con = psycopg2.connect(
            user=os.getenv('POSTGRES_USER'),
            password=os.getenv('POSTGRES_PASSWORD'),
            port=os.getenv('POSTGRES_PORT'),
            host=os.getenv('POSTGRES_HOST'),
            dbname=schema_id
        )
        con.autocommit = True
        cursor = con.cursor()
        cursor.execute("select * from pg_tables where schemaname = 'public';")
        table_meta = cursor.fetchall()
        table_list = [x[1] for x in table_meta]
        return table_list, ""
    except Exception as e:
        print(f"ERROR: {e}")
        return None, str(e)
