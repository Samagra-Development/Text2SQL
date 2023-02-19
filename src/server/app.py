from quart import Quart
from quart import request
from utils import detect_lang, chatGPT
import json
import aiohttp
import time

app = Quart(__name__)


@app.route('/')
async def home():
    return {'status': 'WE ARE LIVE'}


@app.route('/prompt', methods=['POST'])
async def prompt():
    start = time.time()
    data = await request.get_json()
    prompt = data['prompt']
    response = await chatGPT(prompt, app)
    end = time.time()
    print(end - start)
    return {"response": response, "time": end - start}


@ app.before_serving
async def startup():
    app.client = aiohttp.ClientSession()


if __name__ == "__main__":
    app.run(host='0.0.0.0', port=5078)
