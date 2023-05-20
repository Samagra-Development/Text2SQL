import styles from './index.module.scss';
import 'animate.css';

const DataTable = (props) => {
    const { data } = props;
    const tableHeaders = Object.keys(data[0]);
    return (
        <div className={`${styles.container}`}>
            <table className={styles.tableMain}>
                <thead>
                    <tr>
                        {tableHeaders?.map(el => <th key={el}>{el}</th>)}
                    </tr>
                </thead>
                <tbody>
                    {data?.map((el, idx) => <tr key={`${idx}_${idx*idx}`}>
                        {Object.keys(el)?.map((dataKey, i) => <td key={dataKey}>{el[dataKey]}</td>)}
                    </tr>)}
                </tbody>
            </table>
        </div>
    )
}

export default DataTable;