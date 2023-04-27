import time
import os
from pathlib import Path
import json
import json
from dotenv import load_dotenv
import logging

import openai

file = Path(__file__).resolve()
parent, ROOT_FOLDER = file.parent, file.parents[2]
load_dotenv(dotenv_path=f"{ROOT_FOLDER}/.env")

openai.api_key = os.getenv('OPENAI_API_KEY')


async def chatGPT(prompt, context):
    print("Sending prompt to ChatGPT")
    response = ""
    completion = openai.ChatCompletion.create(model="gpt-3.5-turbo", messages=[{"role": "user", "content": prompt}], temperature=0)
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
