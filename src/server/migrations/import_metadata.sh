HASURA_URL='http://localhost:8084'

cd src/server/migrations

cat hasura_metadata.json | curl --location ''$HASURA_URL'/v1/metadata' \
--header 'x-hasura-admin-secret: 4GeEB2JCU5rBdLvQ4AbeqqrPGu7kk9SZDhJUZm7A' \
--header 'Content-Type: application/json' \
--data @-