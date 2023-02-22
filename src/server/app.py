import os

from quart import Quart
from quart import request
from sql_formatter.core import format_sql

from utils import detect_lang, chatGPT, get_response
from http import HTTPStatus
from response_codes import ResponseCodes
from prompts import SUBJECT_QUERY_PROMPT
from db_helper import insert_into_schema_holder, create_schema_in_db, add_prompts, get_tables_from_schema_id
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
    schema_id = data['schemaId']
    status, err = add_prompts(schema_id, prompt)
    if status is True:
        tables_list, err = await get_tables_from_schema_id(schema_id)
        if tables_list is not None:
            tables = ",".join(tables_list)
        chat_gpt_prompt = prompt % (tables, prompt)
        chat_gpt_response = await chatGPT(chat_gpt_prompt, app)
        # todo: add validators for chatgpt responses

    else:
        response = "failed to insert prompt"
        status_code = ResponseCodes.INSERT_PROMPT_ERROR
        http_status_code = HTTPStatus.INTERNAL_SERVER_ERROR
        end = time.time()
        err_msg = err
    print(end - start)
    return get_response(response=response, status_code=status_code, http_status_code=http_status_code, err_msg=err_msg)


# todo: add option for getting schema via post body too
@app.route('/onboard', methods=['POST'])
async def onboard():
    response = status_code = err_msg = http_status_code = ""
    start = time.time()
    # data = (await request.form).get('prompt')
    # print(data)
    uploaded_file = (await request.files)['schema']
    if uploaded_file.filename != '':
        print(uploaded_file.read())
        schema_file = uploaded_file.read()
        # todo: save schema in local db
        schema_id, schema_err = await insert_into_schema_holder(schema_file)
        if schema_id is not None:
            resp, db_error = await create_database(schema_id)
            if resp is True:
                create_schema, onboarding_error = await create_schema_in_db(schema_id, schema_file)
                if create_schema is True:
                    response = "schema onboarded"
                    status_code = ResponseCodes.SCHEMA_ONBOARDED
                    http_status_code = HTTPStatus.OK
                else:
                    response = "failed to load schema file"
                    status_code = ResponseCodes.SCHEMA_LOAD_ERROR
                    http_status_code = HTTPStatus.INTERNAL_SERVER_ERROR
                    err_msg = onboarding_error
            else:
                response = "failed to create database"
                status_code = ResponseCodes.CREATE_DB_ERROR
                http_status_code = HTTPStatus.INTERNAL_SERVER_ERROR
                err_msg = db_error
        else:
            response = "failed to insert schema meta"
            status_code = ResponseCodes.SCHEMA_LOAD_ERROR
            http_status_code = HTTPStatus.INTERNAL_SERVER_ERROR
            err_msg = schema_err
        # await uploaded_file.save(uploaded_file.filename)
    end = time.time()
    print(end - start)
    return get_response(response=response, status_code=status_code, http_status_code=http_status_code, err_msg=err_msg)


@ app.before_serving
async def startup():
    app.client = aiohttp.ClientSession()


if __name__ == "__main__":
    app.run(host='0.0.0.0', port=5078)
