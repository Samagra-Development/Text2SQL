import { useState, createRef, Component } from 'react';
import MonacoEditor from '@monaco-editor/react';
import 'react-app-polyfill/ie11';
import { shouldRender } from '@rjsf/utils';
import ClipLoader from "react-spinners/ClipLoader";
import DataTable from "./DataTable";

const monacoEditorOptions = {
  minimap: {
    enabled: false,
  },
  automaticLayout: true,
};

class ChatGPTResponse extends Component {
  constructor(props) {
    super(props)
    this.state = { ...props }
  }
  render() {
    const query_data = JSON.stringify(this.props.query_data)
    return (
      <div className='w-full'>
        <div>
          {/* <h3>
      Query
    </h3> */}
          {/* <div>
      <p>{this.props.query}</p>
    </div> */}
        </div>
        <div className="w-full">
          <h3 className="text-xl font-bold mb-4 text-left">
            Query Data
          </h3>
          <DataTable data={JSON.parse(query_data)} />
          {/* <div style={{width: '100%'}}>
      <p className='query-data'>{query_data}</p>
    </div> */}
        </div>
      </div>
    )
  }
}

class Editor extends Component {
  constructor(props) {
    super(props);
    this.state = { valid: true, code: props.code, readOnly: props.readOnly, langauge: props.language };
  }

  UNSAFE_componentWillReceiveProps(props) {
    this.setState({ valid: true, code: props.code });
  }

  shouldComponentUpdate(nextProps, nextState) {
    if (this.state.valid) {
      return JSON.stringify(nextProps.code) !== JSON.stringify(this.state.code);
    }
    return false;
  }

  onCodeChange = (code) => {
    try {
      const parsedCode = code;
      this.setState({ valid: true, code }, () => this.props.onChange(parsedCode));
    } catch (err) {
      this.setState({ valid: false, code });
    }
  };

  render() {
    const { title } = this.props;
    const icon = this.state.valid ? 'ok' : 'remove';
    const cls = this.state.valid ? 'valid' : 'invalid';
    console.log(this.state.code)
    return (
      <div className='panel panel-default'>
        <div className='panel-heading'>
          <span className={`${cls} glyphicon glyphicon-${icon}`} />
          {' ' + title}
        </div>
        <MonacoEditor
          language={this.state.langauge}
          value={this.state.code}
          theme='vs-light'
          onChange={this.onCodeChange}
          height={400}
          options={{ monacoEditorOptions, readOnly: this.state.readOnly }}
        />
      </div>
    );
  }
}

class Selector extends Component {
  constructor(props) {
    super(props);
    this.state = { current: '', databases: this.props.databases, dbtype: this.props.dbtype }
  }

  onLabelClick = (schema) => {
    return (event) => {
      event.preventDefault();
      this.setState({ current: schema });
      this.props.onChange(schema)
    };
  };

  render() {
    const allschemas = this.props.schemas

    return (
      <ul className='nav nav-pills'>
        {allschemas.map((schema, i) => {
          return (
            <li key={i} role='presentation' className={this.state.current === schema ? 'active' : ''}>
              <a href='#' onClick={this.onLabelClick(schema)}>
                {schema}
              </a>
            </li>
          );
        })}
      </ul>
    );
  }
}

const Search = ({ schemaId, prompts, handleSearch, startLoading }) => {
  const [text, setText] = useState("Number of students in grade 8 from District KINNAUR");
  const onSubmit = evt => {
    evt.preventDefault();
    startLoading()
    if (text === "" || schemaId == "") {
      alert("Please enter something or select a schema!");
    } else {
      const options = {
        method: 'POST', // Replace with the desired HTTP method (e.g. GET, PUT, DELETE, etc.)
        headers: {
          'Content-Type': 'application/json', // Replace with the desired content type
          'Authorization': 'Basic ' + btoa(`test:test`), // Encode username and password as base64
          'Cookie': 'csrftoken=SWTHvaNeh4g3KImyRotjdDcMYuiW0dw4ctce3LXEkRWHJx71t7nKMLCk70wSdSSB'
        },
        body: JSON.stringify({ // Replace with the desired request body
          schema_id: schemaId,
          prompt: text
        })
      };
      fetch('https://api.t2s.samagra.io/prompt', options).then(response => response.text()).then(response => handleSearch(response));
    }
  };

  const handleClick = (prompt) => {
    console.log({ prompt });
    setText(prompt)
  }

  const onChange = evt => setText(evt.target.value);
  const allPrompts = (
    <select
      className="w-full py-2 px-3 border border-gray-300 bg-white text-gray-700 rounded-md shadow-sm focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent"
      onChange={(e) => handleClick(e.target.value)}
    >
      {prompts.map((prompt) => (
        <option key={prompt} value={prompt}>
          {prompt}
        </option>
      ))}
    </select>
  );
  // const allPrompts = prompts.map(prompt => <div className="card" onClick={() => handleClick(prompt)}>
  //   <p>{prompt}</p>
  // </div>)
  return (
    <div className='mb-4'>
      <div className="flex justify-center mb-4">
        <form onSubmit={onSubmit} className="bg-gray-200 p-3 flex items-center w-full rounded">
          <input
            type="text"
            name="text"
            placeholder="Enter prompt..."
            value={text}
            defaultValue="Number of students in grade 8 from District KINNAUR"
            onChange={onChange}
            className="bg-white p-2 w-10/12 outline-none h-full rounded-l"
          />
          <button
            type="submit"
            className="ml-1 text-center bg-white text-blue-600 border-l border-blue-600 py-2 px-4 flex items-center justify-center rounded-r"
          >
            <svg xmlns="http://www.w3.org/2000/svg" className="h-5 w-5" viewBox="0 0 20 20" fill="currentColor">
              <path d="M8 4a4 4 0 100 8 4 4 0 000-8zM2 8a6 6 0 1110.89 3.476l5.364 5.363a1 1 0 11-1.414 1.414l-5.364-5.363A6 6 0 012 8z" />
            </svg>
            Search
          </button>
        </form>
      </div >

      <div className="card-container">
        <div className="card-container">
          <h3 className="text-lg font-semibold">Prompts</h3>
          <hr className="border-gray-400"></hr>
          {allPrompts}
        </div>
      </div>
    </div >
  );
};

class DbSelector extends Component {
  constructor(props) {
    super(props);
    this.state = { current: '', databases: this.props.databases, allschemas: [], schemaId: '', schema: '', query: '', query_data: '', prompts: [], loading: false };
  }

  handleChange = (event) => {
    const allschemas = this.props.databases[event.target.value]["schemas"]
    this.setState({ allschemas: allschemas, current: event.target.value })
  }

  handleSchemaChange = (schemVal) => {
    const schemaId = this.props.databases[this.state.current]["details"][schemVal]["schemaId"]
    const prompts = this.props.databases[this.state.current]["details"][schemVal]["samplePrompts"]
    let sqlfile = ''
    fetch('/' + this.state.databases[this.state.current]["details"][schemVal]["sql"])
      .then(response => response.text())
      .then(data => {
        sqlfile = data // do something with the SQL string
        console.log(sqlfile);
        this.setState({ schemaId: schemaId, schema: sqlfile, prompts: prompts })
      });
  }

  handleSearch = (apiresponse) => {
    const apiresponseParsed = JSON.parse(apiresponse)
    console.log(apiresponseParsed, typeof apiresponseParsed);
    this.setState({ query: apiresponseParsed.result.data.query, query_data: apiresponseParsed.result.data.query_data })
    this.setState({ loading: false })
  }

  startLoading = () => {
    this.setState({ loading: true })
  }

  onSchemaEdited = (schema) => this.setState({ schema, shareURL: null });

  render() {
    let databaseTypes = Object.keys(this.state.databases)
    databaseTypes = databaseTypes.filter(element => element != 'default')
    let options = databaseTypes.map(element => <option value={element}>{element}</option>)
    let loading = this.state.loading
    return (
      <div className='container mx-auto px-4'>
        <div className='page-header'>
          <h1 className="text-3xl font-bold mb-8">
            Natural Language Data Query
          </h1>
          <div className='flex flex-col sm:flex-row sm:space-x-6 items-center'>
            <div className='w-full sm:w-1/2'>
              <form className="form_rjsf_themeSelector">
                <div className="form-group field field-string">
                  <select id="rjsf_themeSelector" name="rjsf_themeSelector" className="w-full py-2 px-3 border border-gray-300 bg-white text-gray-700 rounded-md shadow-sm focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent" aria-describedby="rjsf_themeSelector__error rjsf_themeSelector__description rjsf_themeSelector__help" onChange={this.handleChange}>
                    <option value="default">Select database type</option>
                    {options}
                  </select>
                </div>
              </form>
            </div>
            <div className='w-full sm:w-1/2'>
              <Selector schemas={this.state.allschemas} onChange={this.handleSchemaChange} />
            </div>
          </div>
        </div>
        <div className='w-full sm:w-7/12'>
          {/* <Editor title='DB Schema' code={this.state.schema} onChange={this.onSchemaEdited} readOnly={true} langauge='sql' /> */}
          <div>
            <div className='w-full'>
              <Search schemaId={this.state.schemaId} prompts={this.state.prompts} handleSearch={this.handleSearch} startLoading={this.startLoading} />
            </div>
          </div>
        </div>
        <div className='w-full sm:w-7/12'>
          <div className="flex justify-start w-full">
            {loading ? (
              <div className='flex justify-center items-center'>
                <div className='text-center'>
                  <ClipLoader
                    loading={loading}
                    size={80}
                    aria-label="Loading Spinner"
                    data-testid="loader"
                  />
                </div>
              </div>
            ) : (
              <ChatGPTResponse query={this.state.query} query_data={this.state.query_data} />
            )}
          </div>
        </div>
        <div className='w-full'>
          <p className='text-center'>
            {import.meta.env.VITE_SHOW_NETLIFY_BADGE === 'true' && (
              <div className='float-right'>
                <a href='https://www.netlify.com'>
                  <img src='https://www.netlify.com/img/global/badges/netlify-color-accent.svg' />
                </a>
              </div>
            )}
          </p>
        </div>
      </div>
    )
  }
}

class Playground extends Component {
  constructor(props) {
    super(props);

    // set default theme
    const databases = this.props.databases
    // initialize state with Simple data sample
    this.playGroundForm = createRef();
    this.state = {
      databases,
    };
  }

  componentWillMount() {
    var databases = this.state.databases
    var dbTypes = Object.keys(databases)

    dbTypes.forEach((dbType, index) => {
      var schemas = databases[dbType]["schemas"]
      schemas.forEach((schema, index) => {
        var filePath = databases[dbType]["details"][schema]["sql"];
        // create a new XMLHttpRequest object
        var xhr = new XMLHttpRequest();

        // define the function to be executed when the file has been loaded
        xhr.onload = function (event) {
          // get the SQL file data as a blob
          var sqlBlob = new Blob([xhr.response], { type: 'application/sql' });

          // do something with the SQL blob data
          const formData = new FormData();
          formData.append('schema', sqlBlob, "alimento.sql");
          formData.append('schema_type', dbType);

          const options = {
            method: 'POST',
            body: formData,
            headers: {
              'Authorization': 'Basic ' + btoa('test:test'),
            }
          };

          fetch('https://api.t2s.samagra.io/onboard', options)
            .then(response => response.json())
            .then(data => { databases[dbType]["details"][schema]["schemaId"] = data["result"]["data"]["schema_id"] })
            .catch(error => console.error(error));
        };

        // open the file using the GET method
        xhr.open('GET', filePath);

        // set the response type to 'blob'
        xhr.responseType = 'blob';

        // send the request
        xhr.send();
      })
    })
    console.log(databases)
    this.setState({ databases: databases })
  }


  shouldComponentUpdate(nextProps, nextState) {
    return shouldRender(this, nextProps, nextState);
  }

  render() {
    const {
      databases,
    } = this.state;

    return (
      <DbSelector databases={databases} />
    );
  }
}

export default Playground;
