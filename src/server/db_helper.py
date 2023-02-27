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


async def create_database_and_schema(db_name):
    try:
        con = psycopg2.connect(
            user=os.getenv('POSTGRES_USER'),
            password=os.getenv('POSTGRES_PASSWORD'),
            port=os.getenv('POSTGRES_PORT'),
            host=os.getenv('POSTGRES_HOST'),
            dbname=os.getenv('POSTGRES_DB')
        )
        con.set_isolation_level(ISOLATION_LEVEL_AUTOCOMMIT)
        cursor = con.cursor()
        query = f'create database "{db_name}";'
        cursor.execute(query)
        cursor.close()
        con.close()
        return True, ""
    except Exception as e:
        print(f"ERROR: {e}, {traceback.print_exc()}")
        return False, str(e)


async def insert_into_schema_holder(schema_file):
    cursor, con = await get_connection()
    try:
        new_db_name = str(uuid4())
        query = f""" INSERT INTO schema_holder (schema_id, schema) VALUES (%s, %s)"""
        cursor.execute(query, (new_db_name, schema_file))
        print(f"{new_db_name}: inserted successfully")
        return new_db_name, ""
    except Exception as e:
        print(f"ERROR: {e}, {traceback.print_exc()}")
        return None, str(e)
    finally:
        cursor.close()
        con.close()


async def create_schema_in_db(db_name, schema):
    try:
        con = psycopg2.connect(
            user=os.getenv('POSTGRES_USER'),
            password=os.getenv('POSTGRES_PASSWORD'),
            port=os.getenv('POSTGRES_PORT'),
            host=os.getenv('POSTGRES_HOST'),
            dbname=db_name
        )
        con.autocommit = True
        # con.set_isolation_level(ISOLATION_LEVEL_AUTOCOMMIT)
        cursor = con.cursor()
        # Split the SQL dump into separate statements
        schema = schema.decode('UTF-8')
        # Remove comments from the SQL dump
        schema = re.sub(r'(--[^\n]*|/\*.*?\*/)', '', schema)
        sql_commands = schema.split(';')

        # Execute each statement
        for command in sql_commands:
            # Skip empty statements
            if not command.strip():
                continue

            # Skip CREATE SCHEMA statement if schema already exists
            if 'CREATE SCHEMA' in command:
                try:
                    cursor.execute(command)
                except psycopg2.errors.DuplicateSchema:
                    continue
            else:
                print("comm", command)
                try:
                    cursor.execute(command)
                except psycopg2.errors.SyntaxError:
                    pass
                except psycopg2.errors.UndefinedFunction:
                    pass
                except psycopg2.errors.UndefinedTable:
                    pass
                except psycopg2.errors.InvalidSchemaName:
                    pass
                except psycopg2.errors.UndefinedObject:
                    pass
                except psycopg2.ProgrammingError as e:
                    if 'role' in str(e) and 'does not exist' in str(e):
                        # The user specified in the schema dump does not exist in the database,
                        # so ignore the error and continue
                        pass
                    else:
                        # The error is not related to the missing role, so raise it
                        raise e
        cursor.close()
        con.close()
        return True, ""
    except Exception as e:
        print(f"ERROR: {e}, {traceback.print_exc()}")
        return False, str(e)


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


async def get_tables_from_schema_id(schema_id):
    try:
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
        cursor.close()
        con.close()
        return table_list, ""
    except Exception as e:
        print(f"ERROR: {e}, {traceback.print_exc()}")
        return None, str(e)


async def get_schema_by_schema_id(schema_id):
    cursor, con = await get_connection()
    try:
        query = """select schema from schema_holder where schema_id = %s"""
        cursor.execute(query, (schema_id,))
        schema = cursor.fecthone()
        return schema, ""
    except Exception as e:
        print(f"ERROR: {e}, {traceback.print_exc()}")
        return None, str(e)
    finally:
        cursor.close()
        con.close()


async def get_table_info(db_name, table_name):
    try:
        con = psycopg2.connect(
            user=os.getenv('POSTGRES_USER'),
            password=os.getenv('POSTGRES_PASSWORD'),
            port=os.getenv('POSTGRES_PORT'),
            host=os.getenv('POSTGRES_HOST'),
            dbname=db_name
        )
        cur = con.cursor()
        cur.execute(f"SELECT column_name, data_type FROM information_schema.columns WHERE table_name='{table_name}';")
        columns = cur.fetchall()
        cur.execute(
            f"SELECT tc.table_name, kcu.column_name, ccu.table_name AS referenced_table_name, ccu.column_name AS referenced_column_name FROM information_schema.table_constraints tc JOIN information_schema.key_column_usage kcu ON tc.constraint_name = kcu.constraint_name JOIN information_schema.constraint_column_usage ccu ON ccu.constraint_name = tc.constraint_name WHERE tc.constraint_type = 'FOREIGN KEY' AND tc.table_name='{table_name}';")
        related_tables = cur.fetchall()
        table_info = {table_name: {'columns': columns, 'references': {}}}
        for row in related_tables:
            related_table_name = row[2]
            related_table_column_name = row[3]
            if 'references' not in table_info:
                table_info['references'] = {}
            if related_table_name not in table_info['references']:
                cur.execute(
                    f"SELECT column_name, data_type FROM information_schema.columns WHERE table_name='{related_table_name}';")
                related_table_columns = cur.fetchall()
                table_info['references'][related_table_name] = {'columns': related_table_columns, 'referenced_by': []}
            table_info['references'][related_table_name]['referenced_by'].append(
                {'table_name': table_name, 'column_name': related_table_column_name})
        cur.close()
        con.close()
        return table_info, ""
    except Exception as e:
        print(f"ERROR: {e}, {traceback.print_exc()}")
        return None, str(e)


async def get_create_table_statements(schema, table_name):
    table_names = [table_name]
    table_queries = set()
    # Get create table statement for the given table name
    pattern = f'CREATE TABLE public.{table_name}.*?;'
    match = re.search(pattern, schema, re.DOTALL)
    if match:
        table_queries.add(match.group())
        # Get foreign key related tables
        pattern = f'ALTER TABLE ONLY public.{table_name}\n.*?REFERENCES public.(\w+).*?;'
        fk_matches = re.findall(pattern, schema)
        for fk_match in fk_matches:
            if fk_match not in table_names:
                table_names.append(fk_match)
    else:
        return None
    # Get create table statements for foreign key related tables
    for table_name in table_names:
        pattern = f'CREATE TABLE public.{table_name}.*?;'
        match = re.search(pattern, schema, re.DOTALL)
        if match:
            table_queries.add(match.group())
    return table_queries

