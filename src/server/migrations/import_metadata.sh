curl -d'{"type":"replace_metadata", "args":'$(cat hasura_metadata.json)'}' 'X-Hasura-Admin-Secret: ${HASURA_SECRET}' ${HASURA_URL}/v1/metadata