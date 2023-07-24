import abc
import traceback
from pathlib import Path
import psycopg2
import mysql.connector
import os
from psycopg2.extensions import ISOLATION_LEVEL_AUTOCOMMIT
import re
from uuid import uuid4
import logging
from dotenv import load_dotenv
import sqlite3

from testcontainers.postgres import PostgresContainer

file = Path(__file__).resolve()
parent, ROOT_FOLDER = file.parent, file.parents[3]
load_dotenv(dotenv_path=f"{ROOT_FOLDER}/.env")

class Database(abc.ABC):
    @abc.abstractclassmethod
    async def get_connection():
        pass

    @abc.abstractclassmethod
    async def create_database_and_schema(self, schema_id):
        pass

    @abc.abstractclassmethod
    async def create_schema_in_db(schema_id, schema_file):
        pass
    
    @abc.abstractclassmethod
    async def get_tables_from_schema_id(self, schema_id):
        pass
    
    @abc.abstractclassmethod
    async def get_table_info(self, db_name, table_name):
        pass

    @abc.abstractclassmethod
    async def get_create_table_statements(self, schema, table_name):
        pass

    @abc.abstractclassmethod
    async def validate_sql(self, db_name, query):
        pass


class mysql_database(Database):
    async def get_connection():
        try:
            con = mysql.connector.connect(user='root',
                password=os.getenv('MYSQL_ROOT_PASSWORD'),
                host=os.getenv('MYSQL_HOST'),
                port=os.getenv('MYSQL_PORT'))
            con.autocommit = True
            cursor = con.cursor()
            return cursor, con
        except Exception as e:
            logging.error(f"ERROR: {e}, {traceback.print_exc()}")
            raise Exception("Failed to connect to db")

    async def create_database_and_schema(self, db_name):
        try:
            con = mysql.connector.connect(
                user='root',
                password=os.getenv('MYSQL_ROOT_PASSWORD'),
                host=os.getenv('MYSQL_HOST'),
                port=os.getenv('MYSQL_PORT')
            )
            #con.set_isolation_level(ISOLATION_LEVEL_AUTOCOMMIT)
            cursor = con.cursor()
            query = f'create database `{db_name}`;'
            cursor.execute(query)
            cursor.close()
            con.close()
            return True, ""
        except Exception as e:
            logging.error(f"ERROR: {e}, {traceback.print_exc()}")
            return False, str(e) 
    
    async def create_schema_in_db(self, db_name, schema):
        try:
            con = mysql.connector.connect(
                user='root',
                password=os.getenv('MYSQL_ROOT_PASSWORD'),
                port=os.getenv('MYSQL_PORT'),
                host=os.getenv('MYSQL_HOST'),
                database=db_name
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
                    except mysql.connector.Error as err:
                        logging.error(f"Error creating schema in database {db_name}: {err}")
                else:
                    logging.info("Command : %s", command)
                    try:
                        cursor.execute(command)
                    except mysql.connector.Error as err:
                        logging.error(f"Error creating schema in database {db_name}: {err}")
                        cursor.close()
                        con.close()
                        return False, str(e)
            cursor.close()
            con.close()
            return True, ""
        except Exception as e:
            logging.error(f"ERROR: {e}, {traceback.print_exc()}")
            return False, str(e)

    async def get_tables_from_schema_id(self, schema_id):
        try:
            con = mysql.connector.connect(
                user='root',
                password=os.getenv('MYSQL_ROOT_PASSWORD'),
                port=os.getenv('MYSQL_PORT'),
                host=os.getenv('MYSQL_HOST'),
                database=schema_id
            )
            con.autocommit = True
            cursor = con.cursor()
            # cursor.execute("SELECT table_name FROM information_schema.tables WHERE table_type = 'BASE TABLE' AND table_schema='public'")
            cursor.execute(f"SELECT table_name AS table_name FROM information_schema.tables WHERE table_type = 'BASE TABLE' AND table_schema='{schema_id}';")
            table_meta = cursor.fetchall()
            print(table_meta)
            table_list = [x[0] for x in table_meta]
            cursor.close()
            con.close()
            return table_list, ""
        except Exception as e:
            logging.error(f"ERROR: {e}, {traceback.print_exc()}")
            return None, str(e)
    
    async def get_table_info(self, db_name, table_name):
        try:
            con = mysql.connector.connect(
                user='root',
                password=os.getenv('MYSQL_ROOT_PASSWORD'),
                port=os.getenv('MYSQL_PORT'),
                host=os.getenv('MYSQL_HOST'),
                database=db_name
            )
            # table_schema = table_name.split('.')[0]
            table_second_name = table_name
            cur = con.cursor()
            cur.execute(f"SELECT column_name, data_type FROM information_schema.columns WHERE table_name='{table_second_name}' and table_schema = '{db_name}';")
            columns = cur.fetchall()
            cur.execute(
                f"SELECT TABLE_NAME,COLUMN_NAME,TABLE_SCHEMA,CONSTRAINT_NAME, REFERENCED_TABLE_NAME,REFERENCED_COLUMN_NAME FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE WHERE REFERENCED_TABLE_NAME = '{table_second_name}' and REFERENCED_TABLE_SCHEMA = '{db_name}';")
            related_tables = cur.fetchall()
            table_info = {table_name: {'columns': columns, 'references': {}}}
            for row in related_tables:
                related_table_name = row[2] + '.' + row[0]
                related_table_column_name = row[1]
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
            logging.error(f"ERROR: {e}, {traceback.print_exc()}")
            return None, str(e)

    async def get_create_table_statements(self, schema, table_name):
        table_names = [table_name]
        table_queries = set()
        # Get create table statement for the given table name
        pattern = f'CREATE TABLE {table_name}.*?;'
        match = re.search(pattern, schema, re.DOTALL)
        if match:
            table_queries.add(match.group())
            # Get foreign key related tables
            pattern = f'ALTER TABLE ONLY {table_name}\n.*?REFERENCES (\w+).*?;'
            fk_matches = re.findall(pattern, schema)
            for fk_match in fk_matches:
                if fk_match not in table_names:
                    table_names.append(fk_match)
        else:
            return None
        # Get create table statements for foreign key related tables
        for table_name in table_names:
            pattern = f'CREATE TABLE {table_name}.*?;'
            match = re.search(pattern, schema, re.DOTALL)
            if match:
                table_queries.add(match.group())
        return table_queries
    
    async def validate_sql(self, db_name, query):
        try:
            con = mysql.connector.connect(
                user='root',
                password=os.getenv('MYSQL_ROOT_PASSWORD'),
                port=os.getenv('MYSQL_PORT'),
                host=os.getenv('MYSQL_HOST'),
                database=str(db_name)
            )
            cur = con.cursor()
            cur.execute(query)
            metadata = []
            rows = cur.fetchall()
            for row in rows:
                metadata_dict = dict(zip(cur.column_names, row))
                metadata.append(metadata_dict)
            con.close()
            cur.close()
            return True, metadata
        except Exception as e:
            logging.error(f"ERROR: {e}, {traceback.print_exc()}")
            return False, str(e)
            # return False


class postgresql_database(Database):
    async def get_connection():
        try:
            con = psycopg2.connect(os.getenv('PSQL_DB_URL'))
            con.autocommit = True
            cursor = con.cursor()
            return cursor, con
        except Exception as e:
            logging.error(f"ERROR: {e}, {traceback.print_exc()}")
            raise Exception("Failed to connect to db")
        
    async def create_database_and_schema(self, db_name):
        try:
            con = psycopg2.connect(
                database="postgres",
                user=os.getenv('POSTGRES_USER'),
                password=os.getenv('POSTGRES_PASSWORD'),
                port=os.getenv('POSTGRES_PORT'),
                host=os.getenv('POSTGRES_HOST'),
            )
            con.set_isolation_level(ISOLATION_LEVEL_AUTOCOMMIT)
            cursor = con.cursor()
            query = f'create database "{db_name}";'
            cursor.execute(query)
            cursor.close()
            con.close()
            return True, ""
        except Exception as e:
            logging.error(f"ERROR: {e}, {traceback.print_exc()}")
            return False, str(e)
    
    async def create_schema_in_db(self, db_name, schema):
        try:
            con = psycopg2.connect(
                database=db_name,
                user=os.getenv('POSTGRES_USER'),
                password=os.getenv('POSTGRES_PASSWORD'),
                port=os.getenv('POSTGRES_PORT'),
                host=os.getenv('POSTGRES_HOST'),
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
                        logging.error("Duplicate Schema")
                        continue
                else:
                    logging.info("Command : %s", command)
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
                            logging.error(e)
                            raise e
            cursor.close()
            con.close()
            return True, ""
        except Exception as e:
            logging.error(f"ERROR: {e}, {traceback.print_exc()}")
            return False, str(e)

    async def get_tables_from_schema_id(self, schema_id):
        try:
            con = psycopg2.connect(
                database=schema_id,
                user=os.getenv('POSTGRES_USER'),
                password=os.getenv('POSTGRES_PASSWORD'),
                port=os.getenv('POSTGRES_PORT'),
                host=os.getenv('POSTGRES_HOST'),
            )
            con.autocommit = True
            cursor = con.cursor()
            cursor.execute("SELECT table_schema || '.' || table_name as table_name FROM information_schema.tables WHERE table_type = 'BASE TABLE' AND table_schema NOT IN ('pg_catalog', 'information_schema') ORDER BY table_schema, table_name;")
            table_meta = cursor.fetchall()
            table_list = [x[0] for x in table_meta]
            print(table_list)
            cursor.close()
            con.close()
            return table_list, ""
        except Exception as e:
            logging.error(f"ERROR: {e}, {traceback.print_exc()}")
            return None, str(e)


    async def get_table_info(self, db_name, table_name):
        try:
            con = psycopg2.connect(
                database=db_name,
                user=os.getenv('POSTGRES_USER'),
                password=os.getenv('POSTGRES_PASSWORD'),
                port=os.getenv('POSTGRES_PORT'),
                host=os.getenv('POSTGRES_HOST'),
            )
            cur = con.cursor()
            table_schema = table_name.split('.')[0]
            table_second_name = table_name.split('.')[1]
            cur.execute(f"SELECT column_name, data_type FROM information_schema.columns WHERE table_schema = '{table_schema}' AND table_name = '{table_second_name}';")
            columns = cur.fetchall()
            cur.execute(
                f"SELECT tc.table_name, kcu.column_name, ccu.table_name AS referenced_table_name, ccu.column_name AS referenced_column_name, ccu.table_schema as reference_table_schema FROM information_schema.table_constraints tc JOIN information_schema.key_column_usage kcu ON tc.constraint_name = kcu.constraint_name JOIN information_schema.constraint_column_usage ccu ON ccu.constraint_name = tc.constraint_name WHERE tc.constraint_type = 'FOREIGN KEY' AND tc.table_name='{table_second_name}' AND tc.table_schema='{table_schema}';")
            related_tables = cur.fetchall()
            table_info = {table_name: {'columns': columns, 'references': {}}}
            for row in related_tables:
                related_table_name = row[2]
                related_table_column_name = row[3]
                related_table_schema = row[4]
                if 'references' not in table_info:
                    table_info['references'] = {}
                if (related_table_schema + '.' + related_table_name) not in table_info['references']:
                    cur.execute(
                        f"SELECT column_name, data_type FROM information_schema.columns WHERE table_name='{related_table_name}' and table_schema = '{related_table_schema}';")
                    related_table_columns = cur.fetchall()
                    table_info['references'][related_table_schema + '.' + related_table_name] = {'columns': related_table_columns, 'referenced_by': []}
                table_info['references'][related_table_schema + '.' + related_table_name]['referenced_by'].append(
                    {'table_name': table_name, 'column_name': related_table_column_name})
            cur.close()
            con.close()
            return table_info, ""
        except Exception as e:
            logging.error(f"ERROR: {e}, {traceback.print_exc()}")
            return None, str(e)


    async def get_create_table_statements(self, schema, table_name):
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
    
    async def validate_sql(self, db_name, query):
        try:
            con = psycopg2.connect(
                database="postgres",
                user=os.getenv('POSTGRES_QUERY_USER'),
                password=os.getenv('POSTGRES_QUERY_PASSWORD'),
                port=os.getenv('POSTGRES_QUERY_PORT'),
                host=os.getenv('POSTGRES_QUERY_HOST'),
            )
            cur = con.cursor()
            cur.execute(query)
            rows = cur.fetchall()
            metadata = []
            for row in rows:
                metadata_dict = dict(zip([desc[0] for desc in cur.description], row))
                metadata.append(metadata_dict)
            con.close()
            cur.close()
            return True, metadata
        except Exception as e:
            logging.error(f"ERROR: {e}, {traceback.print_exc()}")
            return False, str(e)
            # return False

class sqlite_database(Database):
    async def get_connection(self):
        try:
            con = sqlite3.connect("temp.db")
            cursor = con.cursor()
            return cursor, con
        except Exception as e:
            logging.error(f"ERROR: {e}, {traceback.print_exc()}")
            raise Exception("Failed to connect to db")

    async def create_database_and_schema(self, db_name):
        try:
            con = sqlite3.connect(f'{db_name}.db')
            cursor = con.cursor()
            con.commit()
            return True, ""
        except Exception as e:
            logging.error(f"ERROR: {e}, {traceback.print_exc()}")
            return False, str(e)
    
    async def create_schema_in_db(self, db_name, schema):
        try:
            con = sqlite3.connect(f'{db_name}.db')
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

                try:
                    cursor.execute(command)
                except sqlite3.Error as err:
                    logging.error(f"Error creating schema in database {db_name}: {err}")
                    cursor.close()
                    con.close()
                    return False, str(err)
            con.commit()
            return True, ""
        except Exception as e:
            logging.error(f"ERROR: {e}, {traceback.print_exc()}")
            return False, str(e)

    async def get_tables_from_schema_id(self, schema_id):
        try:
            con = sqlite3.connect(f'{db_name}.db')
            cursor = con.cursor()
            cursor.execute(f"SELECT name FROM sqlite_master WHERE type='table';")
            table_meta = cursor.fetchall()
            table_list = [x[0] for x in table_meta]
            return table_list, ""
        except Exception as e:
            logging.error(f"ERROR: {e}, {traceback.print_exc()}")
            return None, str(e)
    
    async def get_table_info(self, db_name, table_name):
        try:
            con = sqlite3.connect(f'{db_name}.db')
            cur = con.cursor()
            cur.execute(f"PRAGMA table_info({table_name});")
            columns = cur.fetchall()
            cur.execute(f"PRAGMA foreign_key_list({table_name});")
            related_tables = cur.fetchall()
            table_info = {table_name: {'columns': columns, 'references': {}}}
            for row in related_tables:
                related_table_name = row[2]
                related_table_column_name = row[3]
                if 'references' not in table_info:
                    table_info['references'] = {}
                if related_table_name not in table_info['references']:
                    cur.execute(f"PRAGMA table_info({related_table_name});")
                    related_table_columns = cur.fetchall()
                    table_info['references'][related_table_name] = {'columns': related_table_columns, 'referenced_by': []}
                table_info['references'][related_table_name]['referenced_by'].append(
                    {'table_name': table_name, 'column_name': related_table_column_name})
            cur.close()
            con.close()
            return table_info, ""
        except Exception as e:
            logging.error(f"ERROR: {e}, {traceback.print_exc()}")
            return None, str(e)

    async def get_create_table_statements(self, schema, table_name):
        table_queries = set()
        # Get create table statement for the given table name
        pattern = f'CREATE TABLE {table_name}.*?;'
        match = re.search(pattern, schema, re.DOTALL)
        if match:
            table_queries.add(match.group())
            # Get foreign key related tables
            pattern = f'FOREIGN KEY .*?REFERENCES (\w+).*?;'
            fk_matches = re.findall(pattern, schema)
            for fk_match in fk_matches:
                if fk_match not in table_queries:
                    table_queries.add(f'CREATE TABLE {fk_match}.*?;')
        else:
            return None
        return table_queries
    
    async def validate_sql(self, db_name, query):
        try:
            con = sqlite3.connect(f'{db_name}.db')
            cur = con.cursor()
            cur.execute(query)
            metadata = []
            rows = cur.fetchall()
            for row in rows:
                metadata_dict = dict(zip([d[0] for d in cur.description], row))
                metadata.append(metadata_dict)
            cur.close()
            con.close()
            return True, metadata
        except Exception as e:
            logging.error(f"ERROR: {e}, {traceback.print_exc()}")
            return False, str(e)

class database_factory:
    def get_database_connection(self, schema_type):
        if(schema_type == 'postgresql'):
            db = postgresql_database()
            return db
        elif schema_type == 'mysql':
            db = mysql_database()
            return db
        elif schema_type == 'sqlite':
            db = sqlite_database()
            return db