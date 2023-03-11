# QuickStart
[![Open in Gitpod](https://gitpod.io/button/open-in-gitpod.svg)](https://gitpod.io/#https://github.com/ChakshuGautam/Text2SQL)

1. Once it is open in Gitpod, all the services required by the project will be up and running as a docker container.
2. Open .env file.
3. Update the **OPENAI_API_KEY** with your own OpenAI api key.
4. Now perform following steps to install the required dependencies
```bash
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
```
5. Start the server by executing the following command
```bash
python3 src/server/app.py
```
6. Go to ports and make the 5078 as public.
6. Once a schema is onboarded you can test a prompt using the following 
```bash
curl -X POST \
  -u test:test \
  -H "Content-Type: application/json" \
  -H "Cookie: csrftoken=SWTHvaNeh4g3KImyRotjdDcMYuiW0dw4ctce3LXEkRWHJx71t7nKMLCk70wSdSSB" \
  -d '{"prompt": "<Enter your prompt>", "schema_id": "<Enter your schema id Schema_id>"}' \
  http://localhost:5078/prompt
```