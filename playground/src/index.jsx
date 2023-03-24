import { render } from 'react-dom';
import { Theme as MuiV4Theme } from '@rjsf/material-ui';
import { Theme as MuiV5Theme } from '@rjsf/mui';
import { Theme as FluentUITheme } from '@rjsf/fluent-ui';
import { Theme as SuiTheme } from '@rjsf/semantic-ui';
import { Theme as AntdTheme } from '@rjsf/antd';
import { Theme as Bootstrap4Theme } from '@rjsf/bootstrap-4';
import { Theme as ChakraUITheme } from '@rjsf/chakra-ui';
import v8Validator, { customizeValidator } from '@rjsf/validator-ajv8';
import v6Validator from '@rjsf/validator-ajv6';
import localize_es from 'ajv-i18n/localize/es';
import Ajv2019 from 'ajv/dist/2019.js';
import Ajv2020 from 'ajv/dist/2020.js';

import Playground from './app';
import './index.css'

const databases = {
  "default": {
    "schemas": ["esamwad"],
    "details": {
      "esamwad": {
        "schemaId": "",
        "sql": "./samples/esamwad.sql",
        "samplePrompts": ["Get me the top 10 students"]
      }
    }
  },
  "mssql": {
    "schemas": [],
    "details": {}
  },
  // "mysql": {
  //   "schemas": ["alimento"],
  //   "details": {
  //     "alimento": {
  //       "schemaId": "",
  //       "sql": "src/samples/alimento.sql",
  //       "samplePrompts": ["Get me all the customers", "Get me all the orders made for restaurant name Dominos"]
  //     }
  //   }
  // },
  "postgresql": {
    "schemas": ["esamwad"],
    "details": {
      "esamwad": {
        "schemaId": "",
        "sql": "./samples/esamwad.sql",
        "samplePrompts": ["Number of students in grade 8 from District KINNAUR", "Get all students in grade 8 from District KINNAUR with their school name and father name"]
      }
    }
  }
}

render(<Playground databases={databases} />, document.getElementById('app'));
