import styles from './index.module.scss';
import { useEffect, useState } from 'react';
import availableDatabase from '../../configs/default/availableDatabase.json';
import { getPromptResponse, getSchemaFromHasura } from '../../api';
import { transformDatabaseArray } from '../../utils';
import 'animate.css';
import { useRouter } from 'next/router'
import Lottie from 'react-lottie';
import * as loader from '../../public/lotties/loader.json';
import CommonModal from '../../components/CommonModal';

const defaultOptions = {
    loop: true,
    autoplay: true,
    animationData: loader,
    rendererSettings: {
        preserveAspectRatio: 'xMidYMid slice'
    }
};

const schemaMenu = [{ name: 'My SQL', value: 'mysql' }, { name: 'PostgreSQL', value: 'postgresql' }]

const BasicInterface = () => {
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
    const [queryData, setQueryData] = useState('');
    const [error, setError] = useState('');
    const [modal, setModal] = useState(false);
    const [newSchemaName, setNewSchemaName] = useState('');
    const [newSchemaEmail, setNewSchemaEmail] = useState('');
    const [newSchemaType, setNewSchemaType] = useState('');
    const [newSchemaFile, setNewSchemaFile] = useState<any>(null);

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
        console.log(tempData)
        setData(tempData)
    }

    const handleDbSelection = (e) => {
        setSelectedDb(e.target.value)
        setSchemaOptions(['Choose one of the following', ...data?.[e.target.value]?.schemas])
    }

    const handleSchemaSelection = (sc) => {
        setSchema(sc)
        setPrompts(['Choose one of the following', ...data?.[selectedDb]?.details?.[sc]?.samplePrompts])

    }

    const handleSearch = async () => {
        if (!searchQuery || loading) return;
        setLoading(true);
        const searchResponse = await getPromptResponse(searchQuery, data?.[selectedDb]?.details?.[schema]?.schemaId)
        console.log(searchResponse)
        setLoading(false);
        setQuery(searchResponse?.result?.data?.query)
        if (typeof searchResponse?.result?.data?.query_data == 'string')
            setError(searchResponse?.result?.data?.query_data)
        else
            setQueryData(searchResponse?.result?.data?.query_data)
    }

    const addNewSchema = async () => {
        if (!newSchemaEmail || !newSchemaName || !newSchemaFile || !newSchemaType) return;

    }

    // Fetching relevant schema data from Hasura
    useEffect(() => {
        getSchemaData();
    }, [])

    useEffect(() => {
        if (!modal) {
            setNewSchemaEmail('')
            setNewSchemaType('')
            setNewSchemaName('')
            setNewSchemaFile(null)
        }
    }, [modal])

    console.log(selectedDb, schema)

    return (
        <div className={styles.container}>
            <div className={styles.leftContainer + ` animate__animated animate__fadeIn`}>
                <div style={{ display: 'flex', width: '100%', justifyContent: 'space-between' }}>
                    <div className={styles.goback} onClick={() => router.back()}>Go Back</div>
                    <div className={styles.goback} onClick={() => openModal()}>Add New Schema</div>
                </div>
                <div className={styles.reqCont}                >
                    <div className={styles.title}>Select a Database Type</div>
                    <select onChange={(e: any) => { handleDbSelection(e) }}>{dbTypes?.map((el, i) => <option disabled={el == 'Choose one of the following'} selected={el == 'Choose one of the following'} key={`${el}_${i}`} value={el}>{el}</option>)}</select>
                </div>
                <div className={styles.reqCont + " " + (!selectedDb ? styles.disabled : '')}
                >
                    <div className={styles.title}>Choose a schema</div>
                    <select onChange={(e: any) => { handleSchemaSelection(e.target.value) }}>{schemaOptions?.map((el, i) => <option disabled={el == 'Choose one of the following'} selected={el == 'Choose one of the following'} key={`${el}_${i}`} value={el}>{el}</option>)}</select>
                </div>
                <div className={styles.reqCont + " " + (!schema ? styles.disabled : '')}>
                    <div className={styles.title}>Enter your query 📝</div>
                    <input value={searchQuery} onChange={e => setSearchQuery(e.target.value)} placeholder={'Total number of students in grade 8 ...'}></input>
                </div>
                <div className={styles.orSeparator}>
                    <div className={styles.separator}></div>
                    <p>OR</p>
                    <div className={styles.separator}></div>
                </div>
                <div className={styles.reqCont + " " + (!schema ? styles.disabled : '')}>
                    <div className={styles.title}>Select a Prompt</div>
                    <select onChange={(e: any) => { setSearchQuery(e.target.value) }}>{prompts?.map((el, i) => <option disabled={el == 'Choose one of the following'} selected={el == 'Choose one of the following'} key={`${el}_${i}`} value={el}>{el}</option>)}</select>
                </div>
                <div className={styles.searchBtn + " " + (!searchQuery ? styles.disabled : '')} onClick={handleSearch}>Perform Search</div>
            </div>
            <div className={styles.rightContainer + ` animate__animated animate__fadeInRight animate__faster`}
            >
                <div>
                    <div className={styles.queryHeader}>
                        <p>Generated Query</p>
                        <div className={styles.blueLine}></div>
                        <textarea value={query} />
                        <p>Query Results</p>
                        <div className={styles.blueLine}></div>
                        <div className={styles.queryResult}>
                            {loading && <Lottie options={defaultOptions}
                                height={300}
                                width={300}
                                isPaused={false}
                                style={{ margin: 'auto' }}
                            />}
                            <span className='animate__animated animate__headShake' style={{ color: 'red' }}>{queryData}</span>
                        </div>
                    </div>
                </div>
            </div>
            {modal &&
                <CommonModal closeModal={closeModal} customStyle={{ width: '30vw' }}>
                    <div className={styles.modalContent}>
                        <p>Onboard New Schema</p>
                        <div className={styles.modalQuestion}>
                            <p>Schema Name</p>
                            <input value={newSchemaName} onChange={e => setNewSchemaName(e.target.value)} placeholder={'Provide a schema name here ...'}></input>
                        </div>
                        <div className={styles.modalQuestion}>
                            <p>Email Address</p>
                            <input value={newSchemaEmail} onChange={e => setNewSchemaEmail(e.target.value)} placeholder={'Enter your email here ...'}></input>
                        </div>
                        <div className={styles.modalQuestion}>
                            <p>Schema Type</p>
                            <select onChange={(e: any) => { setNewSchemaType(e.target.value) }}>{[{ name: 'Choose one of the following', value: '' }, ...schemaMenu]?.map((el, i) => <option disabled={el.name == 'Choose one of the following'} selected={el.name == 'Choose one of the following'} key={`${el.name}_${i}`} value={el.value}>{el.name}</option>)}</select>
                        </div>
                        <div className={styles.modalQuestion}>
                            <p>Upload Schema File</p>
                            <input type="file" onChange={e => setNewSchemaFile(e.target.files[0])}></input>
                        </div>
                        <div className={styles.submitBtn + ` ${(!newSchemaEmail || !newSchemaName || !newSchemaFile || !newSchemaType) ? styles.disabled : ''}`} onClick={addNewSchema}>Add Schema</div>
                    </div>
                </CommonModal>
            }
        </div>
    )
}

export default BasicInterface;