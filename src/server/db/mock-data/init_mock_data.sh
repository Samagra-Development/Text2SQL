#!/bin/bash

# Set the API endpoint URL
API_ENDPOINT="https://api.t2s.samagra.io/onboard"

# Set the path to the schema file
SCHEMA_FILE="./school.sql"

# Set the schema type and name
SCHEMA_TYPE="mysql"
SCHEMA_NAME="Up School"

# Set the CSRF token and credentials
CSRF_TOKEN="SWTHvaNeh4g3KImyRotjdDcMYuiW0dw4ctce3LXEkRWHJx71t7nKMLCk70wSdSSB"
AUTH_HEADER="Authorization: Basic dGVzdDp0ZXN0"

# Make the curl request and save the response
RESPONSE=$(curl --location "${API_ENDPOINT}" \
    --header "Cookie: csrftoken=${CSRF_TOKEN}" \
    --header "${AUTH_HEADER}" \
    --form "schema=@\"${SCHEMA_FILE}\"" \
    --form "schema_type=\"${SCHEMA_TYPE}\"" \
    --form "schema_name=\"${SCHEMA_NAME}\"")

# Extract the schema ID from the response
SCHEMA_ID=$(echo "${RESPONSE}" | jq -r '.result.data.schema_id')

echo "Schema ID: ${SCHEMA_ID}" > schema_id.txt

pip install -r requirements.txt

python3 Education_Data.py
python3 dbpush.py ${SCHEMA_ID}
