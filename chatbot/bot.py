import streamlit as st
from streamlit_chat import message
import requests
import json
import pandas as pd

st.set_page_config(
    page_title="Text2SQL",
    layout="centered",
    initial_sidebar_state="auto",
    menu_items={
        'Report a bug': "https://github.com/Samagra-Development/Text2SQL",
        'About': '''Text2SQL is a chatbot designed to help you with SQL Database. It is built using OpenAI's GPT-4 and Streamlit. 
            Go to the GitHub repo to learn more about the project. https://github.com/Samagra-Development/Text2SQL
            '''
    }
)

# Storing the chat
if 'generated' not in st.session_state:
    st.session_state['generated'] = []

if 'past' not in st.session_state:
    st.session_state['past'] = []

def fetch_query(prompt):
    API_ENDPOINT = "https://api.t2s.samagra.io/prompt/v3"

    payload = json.dumps({
    "schema_id": "a96bdef5-3e7e-411b-9e51-89bc47b4fa62",
    "prompt": prompt
    })
    headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Basic dGVzdDp0ZXN0'
    }

    response = requests.request("POST", API_ENDPOINT, headers=headers, data=payload)

    data = response.json()
    print(data["result"]["data"]["query"], data["result"]["data"]["query_data"])

    return data["result"]["data"]["query"], data["result"]["data"]["query_data"]

def read_file(path):
    with open(path) as f:
        ret = f.read()
    return ret

def add_sidebar():
    # Using object notation
    st.sidebar.title("Text2SQL - Chat with you're SQL Data")
    st.sidebar.markdown("Text2SQL is an intuitive and user-friendly application that allows you to interact with your SQL data using natural language queries. Type in your questions or requests, and Text2SQL will generate the appropriate SQL query and return the data you need. No more complex SQL queries or digging through tables - Text2SQL makes it easy to access your data!")

    st.sidebar.header("Features")
    st.sidebar.markdown("- " + "**Natural Language Processing:**" +  " Understands your text queries and converts them into SQL queries.")
    st.sidebar.markdown("- " + "**Instant Results:**" + " Fetches the data from your Snowflake database and displays the results quickly.")
    st.sidebar.markdown("- " + "**GEN AI models:**" + " Uses OpenAI's GPT-4 to generate SQL queries.")


    st.sidebar.markdown("""<style>
        section[data-testid="stSidebar"][aria-expanded="true"]{
        height: 100% !important;
        }
        section[data-testid="stSidebar"][aria-expanded="false"]{
        height: 100% !important;
        }
    </style>""", unsafe_allow_html=True)
    st.sidebar.code(body=read_file("./sql/education.sql"), language="sql")

def add_body():
    c = st.container()
    st.header("Text2SQL")

    if st.session_state['generated']:
        for i in range(len(st.session_state['generated'])):
            message(st.session_state['past'][i], is_user=True, key=str(i) + '_user')
            message(st.session_state["generated"][i], key=str(i))

            # If the returned data is not empty, format it as a pandas DataFrame and display it
            if st.session_state["data"][i]:
                df = pd.DataFrame(st.session_state["data"][i])
                st.dataframe(df.head(10))

    # Placeholder for the text input
    user_input_placeholder = st.empty()

    # Placeholder for the submit button
    submit_button_placeholder = st.empty()

    option = st.selectbox(
        'Sample Prompts',
        ('', 'Count primary schools in Uttar Pradesh?', 'Show me all schools?', 'Get all students who scored more than in UT-1 and who are in class 8.'))

    if option and option != st.session_state.get('selected_option', ''):
        st.session_state['selected_option'] = option
        st.session_state['user_input'] = option  # update the user_input immediately when a new option is selected

    # Check if 'user_input' exists in the session state and use its value, else use the selected option.
    user_input = user_input_placeholder.text_input("You: ", st.session_state.get('user_input', st.session_state.get('selected_option', "")), key="input", placeholder="Enter prompt")

    # Save the typed input in session state
    st.session_state['user_input'] = user_input

    # Define a button for submitting the query
    submit_button = submit_button_placeholder.button("Submit Query")

    if submit_button and user_input != '':
        query, data = fetch_query(user_input)
        # store the output 
        st.session_state.past.append(user_input)
        st.session_state.generated.append(query)

        # Store the data
        if 'data' not in st.session_state:
            st.session_state['data'] = []
        st.session_state['data'].append(data)

        # Empty the user_input session state and update the text input placeholder
        st.session_state['user_input'] = ''
        user_input_placeholder.text_input("You: ", st.session_state.get('user_input', st.session_state.get('selected_option', "")))

        # Empty the selected option session state
        st.session_state['selected_option'] = ''
        
        # Force a rerun to immediately reflect the changes in the chat
        st.experimental_rerun()

add_sidebar()
add_body()
