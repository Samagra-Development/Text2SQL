from enum import Enum


class ResponseCodes(Enum):
    SCHEMA_ONBOARDED = "TS_001"
    QUERY_GENERATED = "TS_002"
    CHATGPT_ERROR = "TE_001"
    SCHEMA_LOAD_ERROR = "TE_002"
    INSERT_PROMPT_ERROR = "TE_003"
    CREATE_DB_ERROR = "TE_004"

