import time
import os
import json
import json
from accounts import init_accounts
import random

initialized_accounts = init_accounts()


async def chatGPT(prompt, context):
    print("Sending prompt to ChatGPT")
    chatbot = random.choice(initialized_accounts)
    response = ""
    async for data in chatbot.ask(prompt, conversation_id=None, parent_id=None, context=context):
        response = data["message"]
    if (response == ""):
        return await chatGPT(prompt, word, context)
    else:
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


async def get_response(response, status_code, http_status_code=200, err_msg=""):
    if err_msg != "" and err_msg is not None:
        return {"result": {"code": status_code, "data": response}, "error": {}}, http_status_code
    else:
        http_status_code = 400 if http_status_code == 200 else http_status_code
        return {"result": {}, "error": {"code": status_code, "errMsg": response, "reason": response if response is not None else response}}, http_status_code
