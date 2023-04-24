import { useState, createRef, Component } from 'react';
import MonacoEditor from '@monaco-editor/react';
import 'react-app-polyfill/ie11';
import { shouldRender } from '@rjsf/utils';
import ClipLoader from "react-spinners/ClipLoader";
import DataTable from "./DataTable";
import { Button, Modal, Box, Typography, TextField, FormControl, InputLabel, Select, MenuItem } from '@material-ui/core';
import Alert from '@mui/material/Alert';
import Backdrop from '@mui/material/Backdrop';
import Fade from '@mui/material/Fade';

const monacoEditorOptions = {
  minimap: {
    enabled: false,
  },
  automaticLayout: true,
};

class OnboardSchema extends Component {
  constructor(props) {
    super(props)
    this.state = { open: this.props.open, handleClose: this.props.handleClose, loading: false, message: null, formData: { file: '', email: '', schemaType: '', schemaName: '' } }
  }

  handleSchemaTypeChange = (event) => {
    this.setState({ formData: { ...this.state.formData, schemaType: event.target.value } })
  };

  handleFileChange = (event) => {
    this.setState({ formData: { ...this.state.formData, file: event.target.files[0] } })
  };

  handleEmailChange = (event) => {
    this.setState({ formData: { ...this.state.formData, email: event.target.value } })
  };

  handleSchemaNameChange = (event) => {
    this.setState({ formData: { ...this.state.formData, schemaName: event.target.value } })
  }

  startLoading = () => {
    this.setState({ loading: true })
  }

  endLoading = () => {
    this.setState({ loading: false })
  }

  handleClose = () => {
    this.setState({ message: null })
    this.props.handleClose()
  }

  handleSubmit = (event) => {
    event.preventDefault();
    this.startLoading()
    console.log(this.state.formData);
    // Call API or perform other actions here with form data and schema type

    // do something with the SQL blob data
    const formData = new FormData();
    formData.append('schema', this.state.formData.file, "alimento.sql");
    formData.append('schema_type', this.state.formData.schemaType);
    formData.append('schema_name', this.state.formData.schemaName);

    const options = {
      method: 'POST',
      body: formData,
      headers: {
        'Authorization': 'Basic ' + btoa('test:test'),
      }
    };

    fetch('http://localhost:5078/onboard', options)
      .then(response => response.json())
      .then(data => {
        console.log("data value", data);
        const message = Object.keys(data.error).length === 0 ? 'Schema onboarded successfully' : 'Error onboarding schema';
        this.endLoading()
        this.setState({ open: this.props.open, handleClose: this.props.handleClose, message: message, formData: { file: null, email: '', schemaType: '', schemaName: '' } })
        // this.state.handleClose();
        this.props.updateDatabase()
      })
      .catch(error => console.error(error));
  };
  render() {
    const style = {
      position: 'absolute',
      top: '50%',
      left: '50%',
      transform: 'translate(-50%, -50%)',
      width: 400,
      bgcolor: 'background.paper',
      border: '2px solid #000',
      boxShadow: 24,
      p: 4,
    };
    return (
      <Modal
        aria-labelledby="transition-modal-title"
        onClose={this.handleClose}
        aria-describedby="transition-modal-description"
        open={this.props.open}
        closeAfterTransition
        slots={{ backdrop: Backdrop }}
        slotProps={{
          backdrop: {
            timeout: 500,
          },
        }}
      >
        <Fade in={this.props.open}>
          <Box sx={style}>
            <Typography id="modal-modal-title" variant="h6" component="h2" align='center' sx={{ fontWeight: 'bold' }}>
              Onboard a Schema
            </Typography>
            {this.state.loading ? (
              <div style={{ display: 'flex', justifyContent: 'center', alignItems: 'center' }}>
                <ClipLoader
                  loading={this.state.loading}
                  size={80}
                  aria-label="Loading Spinner"
                  data-testid="loader"
                />
              </div>)
              :
              (
                this.state.message ? (
                  <Alert severity={this.state.message.includes('Error') ? 'error' : 'success'} sx={{ mt: 2 }}>
                    {this.state.message}
                  </Alert>
                ) :
                  <form onSubmit={this.handleSubmit}>
                    <TextField
                      id="schemaName"
                      label="Schema Name"
                      type="text"
                      value={this.state.formData.schemaName}
                      onChange={this.handleSchemaNameChange}
                      fullWidth
                      sx={{ mt: 2 }}
                    />
                    <TextField
                      id="file"
                      label="File"
                      type="file"
                      inputProps={{ accepts: '.sql', onChange: this.handleFileChange }}
                      fullWidth
                      sx={{ mt: 2 }}
                    />
                    <TextField
                      id="email"
                      label="Email"
                      type="email"
                      value={this.state.formData.email}
                      onChange={this.handleEmailChange}
                      fullWidth
                      sx={{ mt: 2 }}
                    />
                    <FormControl fullWidth sx={{ mt: 2 }}>
                      <InputLabel id="schema-type-label">Schema Type</InputLabel>
                      <Select
                        labelId="schema-type-label"
                        id="schema-type"
                        value={this.state.schemaType}
                        label="Schema Type"
                        onChange={this.handleSchemaTypeChange}
                      >
                        <MenuItem value={'mysql'}>MS SQL</MenuItem>
                        <MenuItem value={'postgresql'}>PostgreSQL</MenuItem>
                      </Select>
                    </FormControl>
                    <Button type="submit" variant="contained" sx={{ mt: 2 }}>
                      Submit
                    </Button>
                  </form>
              )
            }
          </Box>
        </Fade>
      </Modal>
    )
  }
}

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
    this.state = { current: '', databases: this.props.databases, allschemas: [], schemaId: '', schema: '', query: '', query_data: '', prompts: [], loading: false, open: false };
  }

  handleChange = (event) => {
    const allschemas = this.props.databases[event.target.value]["schemas"]
    console.log(allschemas)
    this.setState({ allschemas: allschemas, current: event.target.value })
  }

  handleSchemaChange = (schemVal) => {
    const schemaId = this.props.databases[this.state.current]["details"][schemVal]["schemaId"]
    const prompts = this.props.databases[this.state.current]["details"][schemVal]["samplePrompts"]
    this.setState({ schemaId: schemaId, prompts: prompts })
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

  handleOpen = () => {
    this.setState({ open: true })
    console.log(this.state)
  }

  handleClose = () => {
    this.setState({ open: false })
  }

  render() {
    let databaseTypes = Object.keys(this.state.databases)
    databaseTypes = databaseTypes.filter(element => element != 'default')
    let options = databaseTypes.map(element => <option value={element}>{element}</option>)
    let loading = this.state.loading
    return (
      <div className='container mx-auto px-4'>
        <div className='page-header'>
          <div style={{ display: 'flex', justifyContent: 'space-between' }}>
            <div>
              <h1 className="text-3xl font-bold mb-8">
                Natural Language Data Query
              </h1>
            </div>
            <div>
              <Button onClick={this.handleOpen} color='primary' variant='contained'>Onboard a Schema</Button>
              <OnboardSchema open={this.state.open} handleClose={this.handleClose} updateDatabase={this.props.updateDatabase} />
            </div>
          </div>
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
    const hasura_secret = '4GeEB2JCU5rBdLvQ4AbeqqrPGu7kk9SZDhJUZm7A'
    var myHeaders = new Headers();
    myHeaders.append("x-hasura-admin-secret", hasura_secret);

    var requestOptions = {
      method: 'GET',
      headers: myHeaders,
      redirect: 'follow'
    };
    fetch('http://localhost:8084/api/rest/schemas', requestOptions)
      .then(response => response.json())
      .then(response => {
        const transformedArray = {
          "default": {
            "schemas": [],
            "details": {}
          },
          "mssql": {
            "schemas": [],
            "details": {}
          },
          "mysql": {
            "schemas": [],
            "details": {}
          },
          "postgresql": {
            "schemas": [],
            "details": {}
          }
        };

        console.log("response value = ", response);
        response.schema_holder.forEach(obj => {
          const schemaType = obj.schema_type;
          const schemaId = obj.schema_id;
          const schemaName = obj.schema_name || 'default';
          const samplePrompts = [...new Set(obj.prompts.map(p => p.prompt.toLowerCase()))];

          if (!transformedArray[schemaType].schemas.includes(schemaName)) {
            transformedArray[schemaType].schemas.push(schemaName);
          }

          if (!transformedArray[schemaType].details[schemaName]) {
            transformedArray[schemaType].details[schemaName] = {
              schemaId: schemaId,
              samplePrompts: []
            };
          }

          transformedArray[schemaType].details[schemaName].samplePrompts = samplePrompts

        });
        console.log("transformedArray", transformedArray)
        this.setState({ databases: transformedArray })
      })
      .catch(error => console.error(error))
  }

  updateDatabase = () => {
    const hasura_secret = '4GeEB2JCU5rBdLvQ4AbeqqrPGu7kk9SZDhJUZm7A'
    var myHeaders = new Headers();
    myHeaders.append("x-hasura-admin-secret", hasura_secret);

    var requestOptions = {
      method: 'GET',
      headers: myHeaders,
      redirect: 'follow'
    };
    fetch('http://localhost:8084/api/rest/schemas', requestOptions)
      .then(response => response.json())
      .then(response => {
        const transformedArray = {
          "default": {
            "schemas": [],
            "details": {}
          },
          "mssql": {
            "schemas": [],
            "details": {}
          },
          "mysql": {
            "schemas": [],
            "details": {}
          },
          "postgresql": {
            "schemas": [],
            "details": {}
          }
        };

        console.log("response value = ", response);
        response.schema_holder.forEach(obj => {
          const schemaType = obj.schema_type;
          const schemaId = obj.schema_id;
          const schemaName = obj.schema_name || 'default';
          const samplePrompts = [...new Set(obj.prompts.map(p => p.prompt.toLowerCase()))];

          if (!transformedArray[schemaType].schemas.includes(schemaName)) {
            transformedArray[schemaType].schemas.push(schemaName);
          }

          if (!transformedArray[schemaType].details[schemaName]) {
            transformedArray[schemaType].details[schemaName] = {
              schemaId: schemaId,
              samplePrompts: []
            };
          }

          transformedArray[schemaType].details[schemaName].samplePrompts = samplePrompts

        });
        console.log("transformedArray", transformedArray)
        this.setState({ databases: transformedArray })
      })
      .catch(error => console.error(error))
  }

  shouldComponentUpdate(nextProps, nextState) {
    return shouldRender(this, nextProps, nextState);
  }

  render() {
    const {
      databases,
    } = this.state;

    return (
      <DbSelector databases={databases} updateDatabase={this.updateDatabase} />
    );
  }
}

export default Playground;
