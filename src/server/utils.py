import time
import os
from pathlib import Path
import json
import json
from dotenv import load_dotenv
import logging
import re

from openai import AsyncOpenAI

file = Path(__file__).resolve()
parent, ROOT_FOLDER = file.parent, file.parents[2]
load_dotenv(dotenv_path=f"{ROOT_FOLDER}/.env")

client = AsyncOpenAI(api_key=os.getenv('OPENAI_API_KEY'))


async def chatGPT(prompt, context):
    print("Sending prompt to ChatGPT")
    response = ""
    completion = await client.chat.completions.create(model="gpt-3.5-turbo-1106", messages=[{"role": "user", "content": prompt}], temperature=1)
    response = completion.choices[0].message.content
    if (response == ""):
        # return await chatGPT(prompt, word, context)
        logging.error("Empty response received from chatGPT")
        return None
    else:
        logging.info(response)
        return response

async def chatGPT4(prompt, context):
    print("Sending prompt to ChatGPT")
    response = ""
    completion = await client.chat.completions.create(model="gpt-4", messages=[{"role": "user", "content": prompt}], temperature=1)
    response = completion.choices[0].message.content
    if (response == ""):
        # return await chatGPT(prompt, word, context)
        logging.error("Empty response received from chatGPT")
        return None
    else:
        logging.info(response)
        return response

async def chatGPT4WithContext(messages, context):
    print("Sending prompt to ChatGPT")
    response = ""
    completion = await client.chat.completions.create(model="gpt-4", messages=messages, temperature=1)
    response = completion.choices[0].message.content
    if (response == ""):
        # return await chatGPT(prompt, word, context)
        logging.error("Empty response received from chatGPT")
        return None
    else:
        logging.info(response)
        return response

async def detect_lang(text, context):
    url = "https://meity-auth.ulcacontrib.org/ulca/apis/v0/model/compute"

    payload = json.dumps({
        "modelId": "631736990154d6459973318e",
        "task": "txt-lang-detection",
        "input": [
            {
                "source": text
            }
        ],
        "userId": None
    })
    headers = {
        'authority': 'meity-auth.ulcacontrib.org',
        'accept': '*/*',
        'content-type': 'application/json',
        'origin': 'https://bhashini.gov.in'
    }

    response = await context.client.post(url, headers=headers, data=payload)
    # response = requests.request("POST", url, headers=headers, data=payload)

    # {
    #     "output": [
    #         {
    #             "source": "महात्मा गांधी का जन्म कहाँ हुआ था?",
    #             "langPrediction": [
    #                 {
    #                     "langCode": "hi",
    #                     "ScriptCode": null,
    #                     "langScore": 100
    #                 }
    #             ]
    #         }
    #     ],
    #     "config": null
    # }
    resp = await response.json()
    print(resp)
    return resp["output"][0]["langPrediction"][0]["langCode"]

async def translate_online(prompt_text, source_lang, target_lang, context):
    url = "https://nmt-api.ai4bharat.org/translate_sentence"
    payload = json.dumps({
        "text": prompt_text,
        "source_language": source_lang,
        "target_language": target_lang
    })
    print("--------")
    print(payload)
    print("----------")
    headers = {
        'authority': 'nmt-api.ai4bharat.org',
        'accept': '*/*',
        'accept-language': 'en-GB,en-US;q=0.9,en;q=0.8',
        'content-type': 'application/json',
        'origin': 'https://models.ai4bharat.org',
        'referer': 'https://models.ai4bharat.org/',
        'sec-ch-ua': '"Not_A Brand";v="99", "Google Chrome";v="109", "Chromium";v="109"',
        'sec-ch-ua-mobile': '?0',
        'sec-ch-ua-platform': '"macOS"',
        'sec-fetch-dest': 'empty',
        'sec-fetch-mode': 'cors',
        'sec-fetch-site': 'same-site',
        'user-agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/109.0.0.0 Safari/537.36'
    }

    response = await context.client.post(url, headers=headers, data=payload)
    # response = requests.request("POST", url, headers=headers, data=payload)
    resp = await response.json()
    return resp["text"]


async def get_response(response, status_code, http_status_code=200, err_msg="", data=""):
    if err_msg == "" or err_msg is None:
        response["query_data"] = data
        return {"result": {"code": status_code, "data": response}, "error": {}}, http_status_code
    else:
        http_status_code = 400 if http_status_code == 200 else http_status_code
        return {"result": {}, "error": {"code": status_code, "errMsg": response, "reason": err_msg if err_msg is not None else response}}, http_status_code


async def validate_schema_file(schema):
    schema = schema.decode('UTF-8')
    schema = await delete_lines_with_substring(schema, "schema public")
    return schema


async def delete_lines_with_substring(input_string, substring):
    lines = input_string.split('\n')
    filtered_lines = [line for line in lines if substring.lower() not in line.lower()]
    result = '\n'.join(filtered_lines)
    return result

def clean_json_response(input_string):
    cleaned_query = input_string.strip()
    cleaned_query = cleaned_query.lstrip('\n').rstrip('\n')

    if cleaned_query.startswith("```json"):
        cleaned_query = cleaned_query[7:].strip()

    if cleaned_query.startswith("```"):
        cleaned_query = cleaned_query[3:].strip()
    
    if cleaned_query.endswith("```"):
        cleaned_query = cleaned_query[:-3].strip()

    if cleaned_query.startswith("JSON"):
        cleaned_query = cleaned_query[4:].strip()

    if cleaned_query.startswith("json"):
        cleaned_query = cleaned_query[4:].strip()

    return cleaned_query

def clean_sql_query(input_string):
    # Remove leading and trailing whitespaces
    cleaned_query = input_string.strip()
    # Strip newline characters from the start and end of the query
    cleaned_query = cleaned_query.lstrip('\n').rstrip('\n')

    cleaned_query = input_string.strip()

    # Remove leading 'Output -' if present
    cleaned_query = cleaned_query.replace("Output -", "").strip()

    # Check if the query is surrounded by "```sql" and "```"
    # if cleaned_query.startswith("```sql") and cleaned_query.endswith("```"):
    #     cleaned_query = cleaned_query[6:-3].strip()

    if cleaned_query.startswith("```sql"):
        cleaned_query = cleaned_query[6:].strip()
    
    if cleaned_query.endswith("```"):
        cleaned_query = cleaned_query[:-3].strip()

    # Check for common prefixes like 'sql' or '```' and remove them
    prefixes = ["sql", "```"]
    for prefix in prefixes:
        if cleaned_query.startswith(prefix):
            cleaned_query = cleaned_query[len(prefix):].lstrip()

    # Remove leading 'Output -' if present
    cleaned_query = cleaned_query.replace("Output -", "").strip()

    cleaned_query = cleaned_query.replace('\n', " ")

    return cleaned_query

def clean_validate_query_response(input_string):
    # Define the regex pattern to match the SQL query
    sql_pattern = r'```sql\n(.*?)```'
    
    # Find the match using re.DOTALL to match across multiple lines
    match = re.search(sql_pattern, input_string, re.DOTALL)
    
    if match:
        # Extract and return the matched SQL query
        sql_query = match.group(1).strip()
        sql_query = sql_query.replace('\n', " ")
        # Remove any leading or trailing whitespaces
        return sql_query
    else:
        # Return None if no match is found
        return None
    
def extract_sql_query(input_text):
    # Define a regular expression pattern to match SQL queries
    sql_pattern = r'```sql(.*?)```|\bSELECT\b(.*?)(?:\bFROM\b|\bJOIN\b|\bWHERE\b|\bGROUP BY\b|\bORDER BY\b|\bLIMIT\b)'

    # Use re.findall to find all matches in the input text
    matches = re.findall(sql_pattern, input_text, re.DOTALL)

    # Extract the matched SQL queries from the groups
    sql_queries = [match[0].strip() if match[0] else match[1].strip() for match in matches]

    # Join multiple SQL queries into a single string
    result = ' '.join(sql_queries)

    return result

def remove_insert_statements(sql_content):

    # Split the SQL content into statements
    statements = sql_content.split(b';')

    # Filter out INSERT INTO statements
    filtered_statements = [statement.strip() for statement in statements if not statement.strip().startswith(b'INSERT INTO')]
    
    # Join the filtered statements back into a single string
    filtered_content = b';\n\n'.join(filtered_statements)
    
    return filtered_content

def save_uploaded_file(schema_file, target_folder, new_filename):

    if not os.path.exists(target_folder):
        os.makedirs(target_folder)

    filtered_content = remove_insert_statements(schema_file)

    target_file_path = os.path.join(target_folder, secure_filename(new_filename))
    with open(target_file_path, 'wb') as f:
        f.write(filtered_content)

    return target_file_path
