# QuickStart
[![Open in Gitpod](https://gitpod.io/button/open-in-gitpod.svg)](https://gitpod.io/#https://github.com/ChakshuGautam/Text2SQL)

## Gitpod Setup Tutorial
[<img src="https://i.ytimg.com/vi/JaM_m_VMWaM/maxresdefault.jpg" width="50%">](https://www.youtube.com/watch?v=JaM_m_VMWaM "Text2SQL Gitpod Setup Tutorial")

1. Once it is open in Gitpod, all the services required by the project will be up and running as a docker container.
2. Open .env file.
3. Update the **OPENAI_API_KEY** with your own OpenAI api key.
4. Go to ports and make 8084 as public.
5. Now perform following steps to install the required dependencies
```bash
sudo sh ./setup.sh
```
6. Start the server by executing the following command
```bash
sudo python3 src/server/app.py
```
7. Go to ports and make the 5078 as public and copy the address.
8. Open src/server/db/mock-data/init_mock_data.sh and replace the API_ENDPOINT with the address you copied in previous step. Remember to have **/onboard** in the url.
9. If you want a smaller dataset then go to src/server/db/mock-data/Education_Data.py and change generateSchoolData(50) to the desired number of schools.
10. Execute the following command to push dummy education data. This will take few minutes to complete
```bash
cd src/server/db/mock-data/
sudo sh ./init_mock_data.sh
```
11. Open src/server/db/mock-data/schema_id.txt and copy the schema_id.
12. Once a schema is onboarded you can test a prompt using the following 
```bash
curl -X POST \
  -u test:test \
  -H "Content-Type: application/json" \
  -H "Cookie: csrftoken=SWTHvaNeh4g3KImyRotjdDcMYuiW0dw4ctce3LXEkRWHJx71t7nKMLCk70wSdSSB" \
  -d '{"prompt": "<Enter your prompt>", "schema_id": "<Paste your schema id>"}' \
  https://<Paste the same url as of step 8>/prompt/v3
```
