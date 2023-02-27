import os

from quart import Quart
from quart import request
from sql_formatter.core import format_sql

from utils import detect_lang, chatGPT, get_response, validate_schema_file
from http import HTTPStatus
from response_codes import ResponseCodes
from prompts import SUBJECT_QUERY_PROMPT, SQL_QUERY_PROMPT
from db_helper import insert_into_schema_holder, create_schema_in_db, add_prompts, get_tables_from_schema_id, \
    get_schema_by_schema_id, get_table_info, create_database_and_schema
import json
import aiohttp
import time

app = Quart(__name__)


@app.route('/')
async def home():
    return {'status': 'WE ARE LIVE'}


@app.route('/prompt', methods=['POST'])
async def prompt():
    response = status_code = err_msg = http_status_code = ""
    start = time.time()
    data = await request.get_json()
    prompt = data['prompt']
    schema_id = data['schema_id']
    status, err = await add_prompts(schema_id, prompt)
    if status is True:
        tables_list, err = await get_tables_from_schema_id(schema_id)
        if tables_list is not None:
            tables = ",".join(tables_list)
        chat_gpt_prompt = SUBJECT_QUERY_PROMPT % (tables, prompt)
        chat_gpt_response = await chatGPT(chat_gpt_prompt, app)
        # todo: add validators for chatgpt responses
        chat_gpt_response = json.loads(chat_gpt_response)
        # schema = get_schema_by_schema_id(schema_id)
        table_list = list()
        res, err_msg = await get_table_info(schema_id, chat_gpt_response['subject'])
        table_list.append(res)
        for table in chat_gpt_response['relatedTables']:
            res_sub_query, err_msg_sub_query = await get_table_info(schema_id, table)
            table_list.append(res_sub_query)
        query_prompt = SQL_QUERY_PROMPT % (table_list, prompt)
        print("prompt ", query_prompt)
        chat_gpt_query_response = await chatGPT(query_prompt, app)
        print(chat_gpt_query_response)
        response = {"query": chat_gpt_query_response.replace('\n', ' ')}
        status_code = ResponseCodes.QUERY_GENERATED.value
        http_status_code = HTTPStatus.OK
    else:
        response = "failed to insert prompt"
        status_code = ResponseCodes.INSERT_PROMPT_ERROR.value
        http_status_code = HTTPStatus.INTERNAL_SERVER_ERROR
        err_msg = err
    end = time.time()
    print(end - start)
    return await get_response(response=response, status_code=status_code, http_status_code=http_status_code, err_msg=err_msg)


# todo: add option for getting schema via post body too
@app.route('/onboard', methods=['POST'])
async def onboard():
    response = status_code = err_msg = http_status_code = ""
    start = time.time()
    # data = (await request.form).get('prompt')
    # print(data)
    uploaded_file = (await request.files)['schema']
    if uploaded_file.filename != '':
        schema_file = uploaded_file.read()
        # todo: save schema in local db
        # schema_file = await validate_schema_file(schema_file)
        schema_id, schema_err = await insert_into_schema_holder(schema_file)
        if schema_id is not None:
            resp, db_error = await create_database_and_schema(schema_id)
            if resp is True:
                create_schema, onboarding_error = await create_schema_in_db(schema_id, schema_file)
                if create_schema is True:
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
    print(end - start)
    return await get_response(response=response, status_code=status_code, http_status_code=http_status_code, err_msg=err_msg)


@ app.before_serving
async def startup():
    app.client = aiohttp.ClientSession()


if __name__ == "__main__":
    app.run(host='0.0.0.0', port=5078)
