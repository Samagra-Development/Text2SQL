import styles from './index.module.scss';
import { useEffect, useState } from 'react';
import availableDatabase from '../../configs/default/availableDatabase.json';
import { getPromptResponse, getSchemaFromHasura } from '../../api';
import { transformDatabaseArray } from '../../utils';
import 'animate.css';
import { useRouter } from 'next/router'
import Lottie from 'react-lottie';
import * as loader from '../../public/lotties/loader.json';
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

const CommonInterface = () => {
    let isMobile = false;
    const router = useRouter()
    const [data, setData] = useState<any>();
    const [dbTypes, setDbTypes] = useState(['Choose one of the following', ...availableDatabase]);
    const [selectedDb, setSelectedDb] = useState('');
    const [schema, setSchema] = useState('')
    const [searchQuery, setSearchQuery] = useState('');
    const [prompts, setPrompts] = useState([]);
    const [loading, setLoading] = useState(false);
    const [query, setQuery] = useState('');
    const [queryData, setQueryData] = useState<any>('');
    const [error, setError] = useState('');
    const [dataTable, setDataTable] = useState([]);


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
        handleSchemaSelection(process.env.NEXT_PUBLIC_SCHEMA)
        fetch('/autocompleteSuggestions.txt').then(r => r.text()).then(text => {
            setPrompts(text.split(/\n/));
        });

    }

    const handleDbSelection = (e) => {
        setSelectedDb(e)
    }

    const handleSchemaSelection = (sc) => {
        setSchema(sc)

    }

    const handleSearch = async (newQuery) => {
        if (!searchQuery || loading) return;
        let searchResponse = null;
        setLoading(true);
        setQueryData('')
        setQuery('')
        setError('');
        setDataTable([]);
        if (newQuery?.length)
            searchResponse = await getPromptResponse(newQuery, data?.[selectedDb]?.details?.[schema]?.schemaId)
        else searchResponse = await getPromptResponse(searchQuery, data?.[selectedDb]?.details?.[schema]?.schemaId)
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
        if (window.innerWidth < 769)
            isMobile = true;
    }, [])


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
                <div className={styles.searchBtn + " " + (!searchQuery ? styles.disabled : '')} onClick={handleSearch}>{isMobile ? 'Search' : 'Perform Search'}</div>
            </div>
            {/* Container for query results and generated query */}
            <div className={styles.results + ` animate__animated animate__fadeIn`}
            >
                <div>
                    <div className={styles.queryHeader}>
                        <div style={{ display: 'flex', flexDirection: 'row', width: '100%', alignItems: 'center', justifyContent: 'space-between' }}>
                            <p>Query Results</p>
                            {query?.length > 0 && <div onClick={() => { handleSearch(query) }} className={styles.exportBtn + " animate__animated animate__fadeInDown"}>Search Query</div>}
                        </div>
                        <div className={styles.blueLine}></div>
                        <textarea value={query} onChange={e => setQuery(e.target.value)} />
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