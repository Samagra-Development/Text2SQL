sh ./src/server/migrations/import_metadata.sh

# Make the curl request and store the response in a variable
response=$(curl --location 'http://localhost:5078/onboard' \
--header 'Cookie: csrftoken=SWTHvaNeh4g3KImyRotjdDcMYuiW0dw4ctce3LXEkRWHJx71t7nKMLCk70wSdSSB' \
--header 'Authorization: Basic dGVzdDp0ZXN0' \
--form 'schema=@"./playground/src/samples/esamwad.sql"' \
--form 'schema_type="postgresql"' \
--form 'schema_name="esamwad"')

echo $response

# Extract the schema_id value using jq and store it in a variable
schema_id=$(echo $response | jq -r '.result.data.schema_id')

#Make a post request to prompt endpoint using the schema id we got in previous step
curl --location 'http://localhost:5078/prompt' \
--header 'Authorization: Basic dGVzdDp0ZXN0' \
--header 'Content-Type: application/json' \
--data '{
    "schema_id": "'$schema_id'",
    "prompt": "Number of students in class 8 from District KINNAUR"
}'

curl --location 'http://localhost:5078/prompt' \
--header 'Authorization: Basic dGVzdDp0ZXN0' \
--header 'Content-Type: application/json' \
--data '{
    "schema_id": "'$schema_id'",
    "prompt": "Get all students in grade 8 from District KINNAUR with their school name and father name"
}'