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
    async def get_connection(self):
        try:
            con = mysql.connector.connect(user='root',
                password=os.getenv('MYSQL_ROOT_PASSWORD'),
                host=os.getenv('MYSQL_HOST'),
                port=os.getenv('MYSQL_PORT'))
            con.autocommit = True
            cursor = con.cursor()
            return con, cursor
        except Exception as e:
            logging.error(f"ERROR: {e}, {traceback.print_exc()}")
            raise Exception("Failed to connect to db")

    async def create_database_and_schema(self, db_name):
        try:
            con, cursor = await self.get_connection()
            #con.set_isolation_level(ISOLATION_LEVEL_AUTOCOMMIT)
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
            con, cursor = await self.get_connection()
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
                        return False, str(err)
            cursor.close()
            con.close()
            return True, ""
        except Exception as e:
            logging.error(f"ERROR: {e}, {traceback.print_exc()}")
            return False, str(e)

    async def get_tables_from_schema_id(self, schema_id):
        try:
            con, cursor = await self.get_connection()
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
            con, cursor = await self.get_connection()
            cursor.execute(f"SELECT column_name, data_type FROM information_schema.columns WHERE table_name='{table_second_name}' and table_schema = '{db_name}';")
            columns = cursor.fetchall()
            cursor.execute(
                f"SELECT TABLE_NAME,COLUMN_NAME,TABLE_SCHEMA,CONSTRAINT_NAME, REFERENCED_TABLE_NAME,REFERENCED_COLUMN_NAME FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE WHERE REFERENCED_TABLE_NAME = '{table_second_name}' and REFERENCED_TABLE_SCHEMA = '{db_name}';")
            related_tables = cursor.fetchall()
            table_info = {table_name: {'columns': columns, 'references': {}}}
            for row in related_tables:
                related_table_name = row[2] + '.' + row[0]
                related_table_column_name = row[1]
                if 'references' not in table_info:
                    table_info['references'] = {}
                if related_table_name not in table_info['references']:
                    cursor.execute(
                        f"SELECT column_name, data_type FROM information_schema.columns WHERE table_name='{related_table_name}';")
                    related_table_columns = cursor.fetchall()
                    table_info['references'][related_table_name] = {'columns': related_table_columns, 'referenced_by': []}
                table_info['references'][related_table_name]['referenced_by'].append(
                    {'table_name': table_name, 'column_name': related_table_column_name})
            cursor.close()
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
            con, cursor = await self.get_connection()
            cursor.execute(query)
            metadata = []
            rows = cursor.fetchall()
            for row in rows:
                metadata_dict = dict(zip(cursor.column_names, row))
                metadata.append(metadata_dict)
            con.close()
            cursor.close()
            return True, metadata
        except Exception as e:
            logging.error(f"ERROR: {e}, {traceback.print_exc()}")
            return False, str(e)
            # return False


class postgresql_database(Database):
    async def get_connection(self):
        try:
            con = psycopg2.connect(os.getenv('PSQL_DB_URL'))
            con.autocommit = True
            cursor = con.cursor()
            return con, cursor
        except Exception as e:
            logging.error(f"ERROR: {e}, {traceback.print_exc()}")
            raise Exception("Failed to connect to db")
        
    async def create_database_and_schema(self, db_name):
        try:
            con, cursor = await self.get_connection()
            con.set_isolation_level(ISOLATION_LEVEL_AUTOCOMMIT)
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
            con, cursor = await self.get_connection()
            con.autocommit = True
            # con.set_isolation_level(ISOLATION_LEVEL_AUTOCOMMIT)
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
            con, cursor = await self.get_connection()
            con.autocommit = True
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
            con, cursor = await self.get_connection()
            table_schema = table_name.split('.')[0]
            table_second_name = table_name.split('.')[1]
            cursor.execute(f"SELECT column_name, data_type FROM information_schema.columns WHERE table_schema = '{table_schema}' AND table_name = '{table_second_name}';")
            columns = cursor.fetchall()
            cursor.execute(
                f"SELECT tc.table_name, kcu.column_name, ccu.table_name AS referenced_table_name, ccu.column_name AS referenced_column_name, ccu.table_schema as reference_table_schema FROM information_schema.table_constraints tc JOIN information_schema.key_column_usage kcu ON tc.constraint_name = kcu.constraint_name JOIN information_schema.constraint_column_usage ccu ON ccu.constraint_name = tc.constraint_name WHERE tc.constraint_type = 'FOREIGN KEY' AND tc.table_name='{table_second_name}' AND tc.table_schema='{table_schema}';")
            related_tables = cursor.fetchall()
            table_info = {table_name: {'columns': columns, 'references': {}}}
            for row in related_tables:
                related_table_name = row[2]
                related_table_column_name = row[3]
                related_table_schema = row[4]
                if 'references' not in table_info:
                    table_info['references'] = {}
                if (related_table_schema + '.' + related_table_name) not in table_info['references']:
                    cursor.execute(
                        f"SELECT column_name, data_type FROM information_schema.columns WHERE table_name='{related_table_name}' and table_schema = '{related_table_schema}';")
                    related_table_columns = cursor.fetchall()
                    table_info['references'][related_table_schema + '.' + related_table_name] = {'columns': related_table_columns, 'referenced_by': []}
                table_info['references'][related_table_schema + '.' + related_table_name]['referenced_by'].append(
                    {'table_name': table_name, 'column_name': related_table_column_name})
            cursor.close()
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
            con, cursor = await self.get_connection()
            cursor.execute(query)
            rows = cursor.fetchall()
            metadata = []
            for row in rows:
                metadata_dict = dict(zip([desc[0] for desc in cursor.description], row))
                metadata.append(metadata_dict)
            con.close()
            cursor.close()
            return True, metadata
        except Exception as e:
            logging.error(f"ERROR: {e}, {traceback.print_exc()}")
            return False, str(e)
            # return False


class database_factory:
    def get_database_connection(self, schema_type):
        if(schema_type == 'postgresql'):
            db = postgresql_database()
            return db
        elif schema_type == 'mysql':
            db = mysql_database()
            return db