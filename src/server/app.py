import sys
sys.path.append('./sql_graph')

import os

from quart import Quart, request, abort, current_app
from sql_formatter.core import format_sql
from quart_cors import cors

from utils import detect_lang, chatGPT, chatGPT4, chatGPT4WithContext, get_response, validate_schema_file, clean_sql_query, clean_json_response, clean_validate_query_response, extract_sql_query
from http import HTTPStatus
from response_codes import ResponseCodes
from prompts import SUBJECT_QUERY_PROMPT, SQL_QUERY_PROMPT, VERSION2_PROMPT, QUERY_FIX_PROMPT, VALIDATE_QUERY_PROMPT, VERSION3_PROMPT
from db_utils import insert_into_schema_holder, add_prompts, get_schema_type_by_schema_id
import json
import aiohttp
import time
import logging
from dotenv import load_dotenv
from pathlib import Path
from db.db_helper import database_factory
from functools import wraps

import json_repair
from sql_graph.src.graph_modified import *

from werkzeug.utils import secure_filename

file = Path(__file__).resolve()
parent, ROOT_FOLDER = file.parent, file.parents[2]
load_dotenv(dotenv_path=f"{ROOT_FOLDER}/.env")

app = Quart(__name__)
# app = cors(app)

# Check if the logs directory exists, and if not, create it
log_dir = './src/server/logs/'
os.makedirs(log_dir, exist_ok=True)

# Set up a formatter for the log messages
formatter = logging.Formatter('%(asctime)s - %(levelname)s - %(message)s')

# Create a handler for the INFO level logs
info_handler = logging.FileHandler('./src/server/logs/info.log')
info_handler.setLevel(logging.INFO)
info_handler.setFormatter(formatter)

# Create a handler for the ERROR level logs
error_handler = logging.FileHandler('./src/server/logs/error.log')
error_handler.setLevel(logging.ERROR)
error_handler.setFormatter(formatter)

# Configure the root logger
logger = logging.getLogger()
logger.setLevel(logging.INFO)  # Set the lowest logging level you want to capture
logger.addHandler(info_handler)
logger.addHandler(error_handler)

chat_prompt = [
    {
        "role": "system",
        "content": "You are now an excellent SQL writer, first I'll give you some tips and examples, and I need you to remember the tips, and do not make same mistakes."
    },
    {
        "role": "user",
        "content": """Tips 1: 
Question: Which A has most number of B?
Gold SQL: select A from B group by A order by count ( * ) desc limit 1;
Notice that the Gold SQL doesn't select COUNT(*) because the question only wants to know the A and the number should be only used in ORDER BY clause, there are many questions asks in this way, and I need you to remember this in the the following questions."""
    },
    {
        "role": "assistant",
        "content": "Thank you for the tip! I'll keep in mind that when the question only asks for a certain field, I should not include the COUNT(*) in the SELECT statement, but instead use it in the ORDER BY clause to sort the results based on the count of that field."
    },
    {
        "role": "user",
        "content": """Tips 2: 
Don't use "IN", "OR", "LEFT JOIN" as it might cause extra results, use "INTERSECT" or "EXCEPT" instead, and remember to use "DISTINCT" or "LIMIT" when necessary.
For example, 
Question: Who are the A who have been nominated for both B award and C award?
Gold SQL should be: select A from X where award = 'B' intersect select A from X where award = 'C';"""
    },
    {
        "role": "assistant",
        "content": "Thank you for the tip! I'll remember to use \"INTERSECT\" or \"EXCEPT\" instead of \"IN\", \"OR\", or \"LEFT JOIN\" when I want to find records that match or don't match across two tables. Additionally, I'll make sure to use \"DISTINCT\" or \"LIMIT\" when necessary to avoid repetitive results or limit the number of results returned."
    },
    {
        "role": "user",
        "content": """Tips 3:
Dont Select unnecessary column which are not asked in the NLQ,
For example,
NLQ - What is the A in B?
In this case only fetch only A since NLQ is only asking for A column and nothing else."""
    },
    {
        "role": "assistant",
        "content": "Got it. I'll ensure to select only the necessary columns that are explicitly asked for in the natural language query (NLQ)."
    }
]

def save_uploaded_file(uploaded_file, target_folder, new_filename):
    if not os.path.exists(target_folder):
        os.makedirs(target_folder)

    target_file_path = os.path.join(target_folder, secure_filename(new_filename))
    with open(target_file_path, 'wb') as f:
        f.write(uploaded_file)

    return target_file_path

def read_file(file_path):
    try:
        print(os.getcwd(), file_path)
        with open(file_path, 'r') as file:
            content = file.read()
            return content
    except Exception as e:
        logging.error("ERROR: {e}")
        print(f"ERROR: {e}, {e.print_exc()}")
    return ""


def get_tables_from_schema_id(G):
    tables_list = []
    for node, attrs in G.nodes(data=True):
        if attrs.get('type') == 'table':
            tables_list.append(node)
    print(tables_list)
    return tables_list

def auth_required(func):
    @wraps(func)
    async def wrapper(*args, **kwargs):
        auth = request.authorization
        if (
            auth is not None and 
            auth.type == "basic" and
            auth.username == os.getenv("BASIC_AUTH_USERNAME") and
            auth.password == os.getenv("BASIC_AUTH_PASSWORD")
        ):
            return await func(*args, **kwargs)
        else:
            abort(401)

    return wrapper

def read_file(file_path):
    try:
        with open(file_path, 'r') as file:
            content = file.read()
    except Exception as e:
        print(f"ERROR: {e}, {e.print_exc()}")
    return content

@app.route('/')
async def home():
    return {'status': 'WE ARE LIVE'}

@app.route('/prompt', methods=['POST'])
@auth_required
async def prompt():
    response = status_code = err_msg = http_status_code = ""
    start = time.time()
    data = await request.get_json()
    prompt = data['prompt']
    schema_id = data['schema_id']
    schema_type = await get_schema_type_by_schema_id(schema_id)
    factory = database_factory()
    db = factory.get_database_connection(schema_type=schema_type)    
    status, err = await add_prompts(schema_id, prompt)
    if status is True:
        tables_list, err = await db.get_tables_from_schema_id(schema_id)
        if tables_list is not None:
            tables = ', '.join([f"'{elem}'" for elem in tables_list])
        chat_gpt_prompt = SUBJECT_QUERY_PROMPT % (tables, prompt)
        logging.info(f"Query Prompt : {chat_gpt_prompt}")
        chat_gpt_response = await chatGPT(chat_gpt_prompt, app)
        logging.info(f"ChatGpt response : {chat_gpt_response}")
        # todo: add validators for chatgpt responses
        chat_gpt_response = json.loads(chat_gpt_response)
        table_list = list()
        res, err_msg = await db.get_table_info(schema_id, chat_gpt_response['subject'])
        table_list.append(res)
        for table in chat_gpt_response['relatedTables']:
            res_sub_query, err_msg_sub_query = await db.get_table_info(schema_id, table)
            table_list.append(res_sub_query)
        query_prompt = SQL_QUERY_PROMPT % (schema_type, prompt, table_list)
        logging.info("Prompt : %s", str(query_prompt))
        chat_gpt_query_response = await chatGPT(query_prompt, app)
        query = chat_gpt_query_response.replace('\n', ' ').replace("'''", '').replace('```', '')
        validate_flag, data = await db.validate_sql(schema_id, query)
        if(validate_flag == False):
            data = [{"error": data}]
        response = {"query": chat_gpt_query_response.replace('\n', ' ').replace("'''", '').replace('```', '')}
        status_code = ResponseCodes.QUERY_GENERATED.value
        http_status_code = HTTPStatus.OK
    else:
        response = "failed to insert prompt"
        status_code = ResponseCodes.INSERT_PROMPT_ERROR.value
        http_status_code = HTTPStatus.INTERNAL_SERVER_ERROR
        err_msg = err
        data=err_msg
    end = time.time()
    print(end - start)
    response = await get_response(response=response, status_code=status_code, http_status_code=http_status_code, err_msg=err_msg, data=data)
    logging.info(response)
    return response

@app.route('/prompt/v3', methods=['POST'])
@auth_required
async def promptv3():
    response = status_code = err_msg = http_status_code = ""
    start = time.time()
    try:
        data = await request.get_json()
        prompt = data['prompt']
        schema_id = data['schema_id']
        prompt_response = {"Step1":{"Subject": {"Prompt": "", "Response": ""}}, "Step2":{"Query": {"Prompt": "", "Response": ""}}, "Step3":{"ValidateQuery": {"Prompt": "", "Response": ""}}, "Query Fix": {"Prompt": "", "Response": ""}}
        schema_type = await get_schema_type_by_schema_id(schema_id)
        factory = database_factory()
        db = factory.get_database_connection(schema_type=schema_type)    
        status, err = await add_prompts(schema_id, prompt)
        if status is True:
            tables_list, err = await db.get_tables_from_schema_id(schema_id)
            schema_file = read_file(f"./files/{schema_id}.sql")
            G, err = sql_to_graph(schema_file)
            tables_list = get_tables_from_schema_id(G)
            if tables_list is not None:
                tables = ', '.join([f"'{elem}'" for elem in tables_list])
            chat_gpt_prompt = SUBJECT_QUERY_PROMPT % (tables, prompt, schema_file)
            logging.info(f"Query Prompt : {chat_gpt_prompt}")
            chat_gpt_response = await chatGPT(chat_gpt_prompt, app)
            prompt_response["Step1"]["Subject"]["Prompt"] = chat_gpt_prompt
            prompt_response["Step1"]["Subject"]["Response"] = chat_gpt_response
            logging.info(f"ChatGpt response : {chat_gpt_response}")
            # todo: add validators for chatgpt responses
            chat_gpt_response = clean_json_response(chat_gpt_response)
            print(chat_gpt_response)
            # chat_gpt_response = json.loads(chat_gpt_response)
            chat_gpt_response = json_repair.repair_json(chat_gpt_response, return_objects=True)
            # Sub_G = get_sub_graph(G, chat_gpt_response['subject'], 1)
            # sub_schema = graph_to_sql(Sub_G)
            # for table in chat_gpt_response['relatedTables']:
            #     if table in tables_list:
            #         Sub_G = get_sub_graph(G, table, 1)
            #         sub_schema += graph_to_sql(Sub_G)
            # steps = chat_gpt_response['stepsToFollow']
            schemaExplanation = chat_gpt_response['schemaExplanation']
            # nlqExplanation = chat_gpt_response['nlqExplanation']
            # query_prompt = VERSION2_PROMPT % (schema_type, schema_type, schemaExplanation, schema_file, prompt, nlqExplanation)

            messages = chat_prompt.copy()
            query_prompt = VERSION3_PROMPT % (schemaExplanation, schema_file, prompt)
            messages.append({"role": "user", "content": query_prompt})
            logging.info("prompt: %s", messages)
            chat_gpt_query_response = await chatGPT4WithContext(messages, app)
            logging.info("response: %s", chat_gpt_query_response)
            prompt_response["Step2"]["Query"]["Prompt"] = query_prompt
            prompt_response["Step2"]["Query"]["Response"] = chat_gpt_query_response

            if(clean_validate_query_response(chat_gpt_query_response) != None):
                query = clean_sql_query(clean_validate_query_response(chat_gpt_query_response))
            else:
                query = clean_sql_query(chat_gpt_query_response)

            if not query.strip().upper().startswith("SELECT"):
                query = "SELECT " + query

            validate_sql_prompt = VALIDATE_QUERY_PROMPT % (schemaExplanation, schema_file, prompt, query)
            logging.info("prompt: %s", validate_sql_prompt)
            chat_gpt_query_response = await chatGPT4(validate_sql_prompt, app)
            prompt_response["Step3"]["ValidateQuery"]["Prompt"] = validate_sql_prompt
            prompt_response["Step3"]["ValidateQuery"]["Response"] = chat_gpt_query_response
            query = clean_validate_query_response(chat_gpt_query_response)

            validate_flag = False
            counter = 0
            temp_query = query
            while validate_flag == False and counter < 3:
                validate_flag, data = await db.validate_sql(schema_id, query)
                if(validate_flag == False):
                    query_fix_prompt = QUERY_FIX_PROMPT % (schema_type, schema_type, schema_type, schema_file, data, prompt)
                    logging.info(f"Query Fix Prompt : {query_fix_prompt}")
                    chat_gpt_query_response = await chatGPT(query_fix_prompt, app)
                    prompt_response["Query Fix"]["Prompt"] = query_fix_prompt
                    prompt_response["Query Fix"]["Response"] = chat_gpt_query_response
                    print("Original - ", chat_gpt_query_response)
                    temp_query = clean_sql_query(chat_gpt_query_response)
                    print("Cleaned - ", query)
                counter += 1
            
            if(validate_flag == False):
                data = [{"error": data}]
            if(validate_flag == True):
                query = temp_query
            response = {"query": query}
            status_code = ResponseCodes.QUERY_GENERATED.value
            http_status_code = HTTPStatus.OK
        else:
            response = "failed to insert prompt"
            status_code = ResponseCodes.INSERT_PROMPT_ERROR.value
            http_status_code = HTTPStatus.INTERNAL_SERVER_ERROR
            err_msg = err
            data=err_msg
    except Exception as e:
        # Log the exception for debugging purposes
        logging.error(f"An error occurred: {str(e)}")
        response = "An error occurred while processing the request"
        status_code = ResponseCodes.INTERNAL_SERVER_ERROR.value
        http_status_code = HTTPStatus.INTERNAL_SERVER_ERROR
        err_msg = str(e)
        data = err_msg
    end = time.time()
    print(end - start)
    # response = await get_response(response=response, status_code=status_code, http_status_code=http_status_code, err_msg=err_msg, data=data, prompt=prompt_response)
    response = await get_response(response=response, status_code=status_code, http_status_code=http_status_code, err_msg=err_msg, data=data)
    logging.info(response)
    return response

@app.route('/prompt/v2', methods=['POST'])
@auth_required
async def promptv2():
    response = status_code = err_msg = http_status_code = ""
    start = time.time()
    data = await request.get_json()
    prompt = data['prompt']
    schema_id = data['schema_id']
    schema_type = await get_schema_type_by_schema_id(schema_id)
    schema_file = read_file(f"./files/{schema_id}.sql")
    factory = database_factory()
    db = factory.get_database_connection(schema_type=schema_type)   
    status, err = await add_prompts(schema_id, prompt)
    if status is True:
        chat_gpt_prompt = VERSION2_PROMPT % (schema_type, schema_file, prompt)
        chat_gpt_response = await chatGPT(chat_gpt_prompt, app)
        logging.info(f"ChatGpt response : {chat_gpt_response}")
        query = chat_gpt_response.split('-')[1].replace("\\", "")
        validate_flag, data = await db.validate_sql(schema_id, query)
        response = {"query": query}
        status_code = ResponseCodes.QUERY_GENERATED.value
        http_status_code = HTTPStatus.OK
    else:
        response = "failed to insert prompt"
        status_code = ResponseCodes.INSERT_PROMPT_ERROR.value
        http_status_code = HTTPStatus.INTERNAL_SERVER_ERROR
        err_msg = err
        data=err_msg
    end = time.time()
    print(end - start)
    print(data)
    response = await get_response(response=response, status_code=status_code, http_status_code=http_status_code, err_msg=err_msg, data=data)
    logging.info(response)
    return response


# todo: add option for getting schema via post body too
@app.route('/onboard', methods=['POST'])
@auth_required
async def onboard():
    response = status_code = err_msg = http_status_code = ""
    start = time.time()
    # data = (await request.form).get('prompt')
    # print(data)
    schema_type = (await request.form).get('schema_type')
    uploaded_file = (await request.files)['schema']
    schema_name = (await request.form).get('schema_name')
    if uploaded_file.filename != '' and schema_type != '':
        schema_file = uploaded_file.read()
        # todo: save schema in local db
        # schema_file = await validate_schema_file(schema_file)
        schema_id, schema_err = await insert_into_schema_holder(schema_file, schema_type, schema_name)
        if schema_id is not None:
            factory = database_factory()
            db = factory.get_database_connection(schema_type=schema_type)
            resp, db_error = await db.create_database_and_schema(db_name=schema_id)
            if resp is True:
                create_schema, onboarding_error = await db.create_schema_in_db(schema_id, schema_file)
                print(create_schema, onboarding_error)
                if create_schema is True:
                    target_folder = './files'
                    new_filename = f"{schema_id}.sql"
                    saved_file_path = save_uploaded_file(schema_file, target_folder, new_filename)
                    response = {"schema_id": schema_id, "message": "schema onboarded"}
                    status_code = ResponseCodes.SCHEMA_ONBOARDED.value
                    http_status_code = HTTPStatus.OK
                else:
                    response = "failed to load schema file"
                    status_code = ResponseCodes.SCHEMA_LOAD_ERROR.value
                    http_status_code = HTTPStatus.INTERNAL_SERVER_ERROR
                    err_msg = onboarding_error
            else:
                response = "failed to create database"
                status_code = ResponseCodes.CREATE_DB_ERROR.value
                http_status_code = HTTPStatus.INTERNAL_SERVER_ERROR
                err_msg = db_error
        else:
            response = "failed to insert schema meta"
            status_code = ResponseCodes.SCHEMA_LOAD_ERROR.value
            http_status_code = HTTPStatus.INTERNAL_SERVER_ERROR
            err_msg = schema_err
        # await uploaded_file.save(uploaded_file.filename)
    end = time.time()
    logging.info("Time elapsed: %s", end - start)
    response = await get_response(response=response, status_code=status_code, http_status_code=http_status_code, err_msg=err_msg)
    logging.info(response)
    return response

@app.route('/data', methods=['GET'])
@auth_required
async def getData():
    response = status_code = err_msg = http_status_code = ""
    start = time.time()
    data = await request.get_json()
    query = data['query']
    schema_id = data['schema_id']
    schema_type = await get_schema_type_by_schema_id(schema_id)
    factory = database_factory()
    db = factory.get_database_connection(schema_type=schema_type)
    validate_flag, data = await db.validate_sql(schema_id, query)
    if(validate_flag == False):
            data = [{"error": data}]
    response = {"query": query}
    status_code = ResponseCodes.QUERY_GENERATED.value
    http_status_code = HTTPStatus.OK
    response = await get_response(response=response, status_code=status_code, http_status_code=http_status_code, err_msg=err_msg, data=data)
    logging.info(response)
    return response

@app.route('/schema', methods=['GET'])
@auth_required
async def getSchema():
    response = status_code = err_msg = http_status_code = ""
    start = time.time()
    args = request.args
    schema_id = args.get("schema_id", default="", type=str)

    if schema_id:
        file_path = f'./files/{schema_id}.sql'
        if os.path.isfile(file_path):
            schema_content = read_file(file_path)
            response = {"schema": schema_content}
            status_code = ResponseCodes.SCHEMA_RETRIEVED.value
            http_status_code = HTTPStatus.OK
        else:
            response = "Schema file not found"
            status_code = ResponseCodes.SCHEMA_NOT_FOUND.value
            http_status_code = HTTPStatus.NOT_FOUND
            err_msg = "File not found"
    else:
        response = "Schema ID not provided"
        status_code = ResponseCodes.SCHEMA_ID_NOT_PROVIDED.value
        http_status_code = HTTPStatus.BAD_REQUEST
        err_msg = "Schema ID not provided"

    end = time.time()
    logging.info("Time elapsed: %s", end - start)
    response = await get_response(response=response, status_code=status_code, http_status_code=http_status_code, err_msg=err_msg)
    logging.info(response)
    return response


@ app.before_serving
async def startup():
    app.client = aiohttp.ClientSession()


if __name__ == "__main__":
    app.run(host='0.0.0.0', port=5078)
