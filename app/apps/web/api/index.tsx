/*
Utility file to hold all the relevant apis
*/

import axios from 'axios';

export const getSchemaFromHasura = async () => {
    try {
        const res = await axios.get('https://hasura.t2s.samagra.io/api/rest/schemas', {
            headers: {
                'x-hasura-admin-secret': '4GeEB2JCU5rBdLvQ4AbeqqrPGu7kk9SZDhJUZm7A'
            }
        });

        return res.data;

    } catch (err) {
        console.log(err);
        return err;
    }
}

export const getPromptResponse = async (prompt, schemaId) => {
    try {
        const res = await axios.post('https://api.t2s.samagra.io/prompt/v3',
            {
                prompt,
                schema_id: schemaId
            },
            {
                headers: {
                    'Content-Type': 'application/json',
                    'Authorization': 'Basic ' + btoa(`test:test`),
                    'Cookie': 'csrftoken=SWTHvaNeh4g3KImyRotjdDcMYuiW0dw4ctce3LXEkRWHJx71t7nKMLCk70wSdSSB'
                },
            }
        )
        return res.data;
    } catch (err) {
        console.log(err);
        return err;
    }
}

export const onboardSchema = async (schema, schemaType, schemaName) => {
    try {
        let formData = new FormData();
        formData.append('schema', schema, "alimento.sql");
        formData.append('schema_type', schemaType);
        formData.append('schema_name', schemaName);


        const res = await axios.post('https://api.t2s.samagra.io/onboard',
            {
                formData: formData
            },
            {
                headers: {
                    'Authorization': 'Basic ' + btoa(`test:test`),
                },
            }
        )
        return res.data;
    } catch (err) {
        console.log(err);
        return err;
    }
}
