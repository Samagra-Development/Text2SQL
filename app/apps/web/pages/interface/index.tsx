import styles from './index.module.scss';
import { useEffect, useState } from 'react';
import availableDatabase from '../../configs/default/availableDatabase.json';
import { getPromptResponse, getSchemaFromHasura, onboardSchema } from '../../api';
import { transformDatabaseArray } from '../../utils';
import 'animate.css';
import { useRouter } from 'next/router'
import Lottie from 'react-lottie';
import * as loader from '../../public/lotties/loader.json';
import CommonModal from '../../components/CommonModal';
import DataTable from '../../components/DataTable';
import { CSVLink } from "react-csv";
import Autocomplete from '@mui/material/Autocomplete';
import TextField from '@mui/material/TextField';

const defaultOptions = {
    loop: true,
    autoplay: true,
    animationData: loader,
    rendererSettings: {
        preserveAspectRatio: 'xMidYMid slice'
    }
};

const schemaMenu = [{ name: 'My SQL', value: 'mysql' }, { name: 'PostgreSQL', value: 'postgresql' }]

const CommonInterface = () => {
    const router = useRouter()
    const [data, setData] = useState<any>();
    const [dbTypes, setDbTypes] = useState(['Choose one of the following', ...availableDatabase]);
    const [selectedDb, setSelectedDb] = useState('');
    const [schemaOptions, setSchemaOptions] = useState([]);
    const [schema, setSchema] = useState('')
    const [searchQuery, setSearchQuery] = useState('');
    const [prompts, setPrompts] = useState([]);
    const [loading, setLoading] = useState(false);
    const [query, setQuery] = useState('');
    const [queryData, setQueryData] = useState<any>('');
    const [error, setError] = useState('');
    const [modal, setModal] = useState(false);
    const [newSchemaName, setNewSchemaName] = useState('');
    const [newSchemaEmail, setNewSchemaEmail] = useState('');
    const [newSchemaType, setNewSchemaType] = useState('');
    const [newSchemaFile, setNewSchemaFile] = useState<any>(null);
    const [onboardingSchema, setOnboardingSchema] = useState(false);
    const [dataTable, setDataTable] = useState([]);
    const [onboardingMsg, setOnboardingMsg] = useState<any>({});

    const openModal = () => setModal(true);
    const closeModal = () => setModal(false);


    const getSchemaData = async () => {
        let schemaData = await getSchemaFromHasura();
        let tempData = {};
        dbTypes.forEach(type => {
            tempData[type] = {
                "schemas": [],
                "details": {}
            }
        })
        transformDatabaseArray(schemaData, tempData);
        setData(tempData)
        handleDbSelection(process.env.NEXT_PUBLIC_DB)
        handleSchemaSelection(process.env.NEXT_PUBLIC_SCHEMA, process.env.NEXT_PUBLIC_DB, tempData)
    }

    const handleDbSelection = (e) => {
        setSelectedDb(e)
    }

    const handleSchemaSelection = (sc, db, data) => {
        setSchema(sc)
        setPrompts([...data?.[db]?.details?.[sc]?.samplePrompts])

    }

    const handleSearch = async () => {
        if (!searchQuery || loading) return;
        setLoading(true);
        setQueryData('')
        setQuery('')
        setError('');
        setDataTable([]);
        const searchResponse = await getPromptResponse(searchQuery, data?.[selectedDb]?.details?.[schema]?.schemaId)
        setLoading(false);
        setQuery(searchResponse?.result?.data?.query)
        const queryData = searchResponse?.result?.data?.query_data;
        if (queryData == undefined || queryData == null || !queryData) {
            setError('An unknown error occured. Please try again.')
            return;
        }
        if (typeof queryData == 'string') {
            setError(queryData)
            return
        }
        else {
            if (queryData.length == 0) {
                setQueryData("No results found")
            }
            if (queryData?.length) {
                if (Object.keys(queryData[0]).includes('error') || Object.keys(queryData[0]).includes('count')) {
                    if (queryData[0].error) {
                        setError(queryData[0].error)
                        return;
                    }
                    setQueryData(queryData?.[0])
                } else {
                    setDataTable(queryData);
                }
            }

        }
    }
    // Fetching relevant schema data from Hasura
    useEffect(() => {
        getSchemaData();
    }, [])


    console.log(data);

    return (
        <div className={styles.container}>
            <div className={styles.searchContainer}>
                <Autocomplete
                    freeSolo
                    disableClearable
                    options={prompts.map((el, i) => { return { label: el, id: i } })}
                    style={{ width: '100%' }}
                    onInputChange={(event, newInputValue) => {
                        setSearchQuery(newInputValue);
                    }}
                    renderInput={(params) => (
                        <TextField
                            {...params}
                            label="Search your query here ..."
                            value={searchQuery}
                            onChange={e => console.log(e.target.value)}
                            InputProps={{
                                ...params.InputProps,
                                type: 'search',
                            }}
                        />
                    )}
                />
                <div className={styles.searchBtn + " " + (!searchQuery ? styles.disabled : '')} onClick={handleSearch}>Perform Search</div>
            </div>
            {/* Container for query results and generated query */}
            <div className={styles.results + ` animate__animated animate__fadeIn`}
            >
                <div>
                    <div className={styles.queryHeader}>
                        <p>Generated Query</p>
                        <div className={styles.blueLine}></div>
                        <textarea value={query} />
                        <div style={{ display: 'flex', flexDirection: 'row', width: '100%', alignItems: 'center', justifyContent: 'space-between' }}>
                            <p>Query Results</p>
                            {dataTable?.length > 0 && <CSVLink data={dataTable} filename={"data.csv"}><div className={styles.exportBtn + " animate__animated animate__fadeInDown"}>Export</div></CSVLink>}
                        </div>
                        <div className={styles.blueLine}></div>
                        <div className={styles.queryResult}>
                            {loading && <Lottie options={defaultOptions}
                                height={300}
                                width={300}
                                isPaused={false}
                                style={{ margin: 'auto' }}
                            />}
                            <span className='animate__animated animate__headShake' style={{ color: 'red' }}>{error}</span>
                            {queryData == 'No results found' && <span>{queryData}</span>}
                            {(queryData?.count == 0 || queryData?.count) && <span>{queryData.count}</span>}
                            {dataTable?.length > 0 && <DataTable data={dataTable} />}
                        </div>
                    </div>
                </div>
            </div>
            <style>
                {`
                    body {
                        margin: 0 !important;
                    }
                `}
            </style>
        </div >
    )
}

export default CommonInterface;