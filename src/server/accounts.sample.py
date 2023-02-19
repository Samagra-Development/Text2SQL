from revChatGPT.V1 import Chatbot

accounts = [
    {
        "email": "put-your-account",
        "password": "put-your-password"
    },
]


def init_accounts():
    initialized_accounts = []
    for account in accounts:
        cGPT_account = Chatbot(config=account)
        initialized_accounts.append(cGPT_account)
    return initialized_accounts
