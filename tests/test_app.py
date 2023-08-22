import requests
import json
import base64
import os

def upload_schema(schema_type,schema_file_path,schema_name):
    # Set the API endpoint URL
    API_ENDPOINT = "<link here>/onboard"

    # Set the path to the schema file
    SCHEMA_FILE = schema_file_path

    # Set the schema type and name
    SCHEMA_TYPE = schema_type
    SCHEMA_NAME = schema_name

    # Set the CSRF token and credentials
    CSRF_TOKEN = "SWTHvaNeh4g3KImyRotjdDcMYuiW0dw4ctce3LXEkRWHJx71t7nKMLCk70wSdSSB"
    USERNAME = "test"
    PASSWORD = "test"

    # Prepare the payload
    payload = {
        "schema_type": SCHEMA_TYPE,
        "schema_name": SCHEMA_NAME
    }

    # Prepare the files for upload (schema file)
    files = {"schema": open(SCHEMA_FILE, "rb")}

    # Set the headers
    headers = {
        "Cookie": f"csrftoken={CSRF_TOKEN}",
        "Authorization": "Basic " + base64.b64encode(f"{USERNAME}:{PASSWORD}".encode()).decode()
    }

    try:
        # Make the POST request
        response = requests.post(API_ENDPOINT, data=payload, files=files, headers=headers)

        # Check if the request was successful
        response.raise_for_status()

        # Parse the response JSON
        response_json = response.json()

        # Extract the schema ID from the response
        schema_id = response_json["result"]["data"]["schema_id"]
        print("Request was successful!")
        print(f"Schema ID: {schema_id}")
        print(schema_name)
        return schema_id
    except requests.exceptions.HTTPError as errh:
        print("Http Error:", errh)
        print(schema_name)
    except requests.exceptions.ConnectionError as errc:
        print("Error Connecting:", errc)
        print(schema_name)
    except requests.exceptions.Timeout as errt:
        print("Timeout Error:", errt)
        print(schema_name)
    except requests.exceptions.RequestException as err:
        print(schema_name)
        print("OOps: Something Else", err)

def run_prompt(prompt, schema_id):
    url = "<link here>/prompt/v3"
    prompt = prompt
    schema_id = schema_id
    headers = {
        "Content-Type": "application/json",
        "Cookie": "csrftoken=SWTHvaNeh4g3KImyRotjdDcMYuiW0dw4ctce3LXEkRWHJx71t7nKMLCk70wSdSSB"
    }
    auth = ("test", "test")
    data = {
        "prompt": prompt,
        "schema_id": schema_id
    }

    try:
        response = requests.post(url, json=data, headers=headers, auth=auth)
        response.raise_for_status()
        json_response = response.json()
        query_data = json_response.get('result', {}).get('data', {}).get('query', [])
        return query_data
        print("Request was successful!")
        print("Response:")
        print(response.json())  # If the response is in JSON format
    except requests.exceptions.HTTPError as errh:
        print("Http Error:", errh)
        print(schema_id)
    except requests.exceptions.ConnectionError as errc:
        print("Error Connecting:", errc)
        print(schema_id)
    except requests.exceptions.Timeout as errt:
        print("Timeout Error:", errt)
        print(schema_id)
    except requests.exceptions.RequestException as err:
        print("OOps: Something Else", err)
        print(schema_id)

def find_schema_files(directory):
    schema_dictionary = {}
    for root, _, files in os.walk(directory):
        for file in files:
            if file == "schema.sql":
                schema_type = 'sqlite'
                schema_file_path = os.path.join(root, file)
                schema_name = os.path.basename(os.path.dirname(schema_file_path))
                schema_id = upload_schema(schema_type, schema_file_path, schema_name)
                schema_dictionary[schema_name] = schema_id
    return schema_dictionary

def load_test_file():
    with open('test_list.json') as file:
        loaded_list = json.load(file)
    return loaded_list

preds_ = []

schema_results = find_schema_files("{PATH_OF_DATABASE}")
# prompt = "How many tables are there?"
# schema_id = schema_results['academic']
# query_response = run_prompt(prompt, schema_id)
# print(query_response)
# for schema_name, result in schema_results.items():
#         print(f"Schema: {schema_name} Result: {result}")


test_list = load_test_file()
for i in range(len(test_list)):
    prompt = test_list[i][1]
    schema_id = schema_results[test_list[i][0]]
    query_response = run_prompt(prompt, schema_id)
    preds_.append(query_response)
    # return the response from run_prompt and store that in a list and that list is the preds file

print(preds_)

with open('result.txt', 'w') as file:
    for item in preds_:
        file.write(str(item) + '\n')

print("List has been stored in 'result.txt'")