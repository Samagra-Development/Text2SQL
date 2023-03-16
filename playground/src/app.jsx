import { useState, createRef, Component } from 'react';
import MonacoEditor from '@monaco-editor/react';
import 'react-app-polyfill/ie11';
import { shouldRender } from '@rjsf/utils';

const monacoEditorOptions = {
  minimap: {
    enabled: false,
  },
  automaticLayout: true,
};


class ChatGPTResponse extends Component {
  constructor(props) {
    super(props)
    this.state = { ...props.response }
  }
  render() {
    return (
      <div className='col-sm-6'>
        <h3>
          Query
        </h3>
        <div>
          <p>{this.props.response}</p>
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
          options={{monacoEditorOptions, readOnly: this.state.readOnly}}
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

const Search = ({schemaId, prompts, handleSearch}) => {
  const [text, setText] = useState("");
  const onSubmit = evt => {
    evt.preventDefault();
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
      fetch('http://localhost:5078/prompt', options).then(response => response.text()).then(response => handleSearch(response));
    }
  };

  const handleClick = (prompt) => {
    setText(prompt)
  }

  const onChange = evt => setText(evt.target.value);
  const allPrompts = prompts.map(prompt => <div className="card" onClick={() => handleClick(prompt)}>
                                              <p>{prompt}</p>
                                           </div>)
  return (
    <div>
      <div className="d-flex justify-content-center">
        <form onSubmit={onSubmit} className="bg-gray-200 p-5">
          <input
            type="text"
            name="text"
            placeholder="Enter prompt..."
            value={text}
            onChange={onChange}
            className="bg-white p-2 col-sm-9 outline-none h-100"
          />
          <button type="submit" className="ml-20 text-center btn btn-primary bg-white border-l">
            Generate Query
          </button>
        </form>
      </div>

      <div className="card-container card-group">
        <div className="card-container">
        <h3>Prompts</h3> 
        <hr></hr>
        {allPrompts}
        </div>
      </div>
    </div>
  );
};

class DbSelector extends Component {
  constructor(props) {
    super(props);
    this.state = { current: '', databases: this.props.databases, allschemas: [], schemaId: '', schema: '', apiresponse: '', prompts: [] };
  }

  handleChange = (event) => {
    const allschemas = this.props.databases[event.target.value]["schemas"]
    this.setState({allschemas: allschemas, current: event.target.value })
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
      this.setState({schemaId: schemaId, schema: sqlfile, prompts: prompts})
    });
  }

  handleSearch = (apiresponse) => {
    const apiresponseParsed = JSON.parse(apiresponse)
    console.log(apiresponseParsed, typeof apiresponseParsed);
    this.setState({apiresponse: apiresponseParsed.result.data.query})
  }

  onSchemaEdited = (schema) => this.setState({ schema, shareURL: null });

  render() {
    let databaseTypes = Object.keys(this.state.databases)
    databaseTypes = databaseTypes.filter(element => element != 'default')
    let options = databaseTypes.map(element => <option value={element}>{element}</option>)
    return (
      <div className='container-fluid'>
      <div className='page-header'>
        <h1>Text2SQL Playground</h1>
        <div className='row'>
          <div className='col-sm-6'>
            <form className="form_rjsf_themeSelector">
              <div className="form-group field field-string">
                  <select id="rjsf_themeSelector" name="rjsf_themeSelector" className="form-control" aria-describedby="rjsf_themeSelector__error rjsf_themeSelector__description rjsf_themeSelector__help" onChange={this.handleChange}>
                      <option value="default">Select database type</option>
                      {options}
                  </select>
              </div>
            </form>
          </div>
          <div className='col-sm-6'>
            <Selector schemas={this.state.allschemas} onChange={this.handleSchemaChange}/> 
          </div>
        </div>
        </div>
        <div className='col-sm-7'>
          <Editor title='DB Schema' code={this.state.schema} onChange={this.onSchemaEdited} readOnly={true} langauge='sql' />
          <div>
            <div className='col-sm-12'>
              <Search schemaId={this.state.schemaId} prompts={this.state.prompts} handleSearch={this.handleSearch}/>
            </div>
          </div>
        </div>
        <div className='col-sm-5'>
          <ChatGPTResponse response = {this.state.apiresponse}></ChatGPTResponse>
        </div>
        <div className='col-sm-12'>
          <p style={{ textAlign: 'center' }}>
            Made with love by Suyash.
            {import.meta.env.VITE_SHOW_NETLIFY_BADGE === 'true' && (
              <div style={{ float: 'right' }}>
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
        xhr.onload = function(event) {
          // get the SQL file data as a blob
          var sqlBlob = new Blob([xhr.response], {type: 'application/sql'});

          // do something with the SQL blob data
          const formData = new FormData();
          formData.append('schema', sqlBlob, "alimento.sql");
          formData.append('schema_type', 'mysql');

          const options = {
            method: 'POST',
            body: formData,
            headers: {
              'Authorization': 'Basic ' + btoa('test:test'),
            }
          };

          fetch('http://localhost:5078/onboard', options)
            .then(response => response.json())
            .then(data => {databases[dbType]["details"][schema]["schemaId"] = data["result"]["data"]["schema_id"]})
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
    this.setState({databases: databases})
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
