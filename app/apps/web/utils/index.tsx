/*
* Utility file to hold helper functions
*/

export const transformDatabaseArray = (schemaData, tempData) => {
    schemaData.schema_holder.forEach((obj: any) => {
        const schemaType = obj.schema_type;
        const schemaId = obj.schema_id;
        const schemaName = obj.schema_name || 'default';
        const prompts = obj.prompts.map(p => p.prompt.toLowerCase());

        //@ts-ignore
        const samplePrompts = [...new Set(prompts)];

        if (!tempData[schemaType].schemas.includes(schemaName)) {
            tempData[schemaType].schemas.push(schemaName);
        }

        if (!tempData[schemaType].details[schemaName]) {
            tempData[schemaType].details[schemaName] = {
                schemaId: schemaId,
                samplePrompts: []
            };
        }

        tempData[schemaType].details[schemaName].samplePrompts = samplePrompts

    });
}