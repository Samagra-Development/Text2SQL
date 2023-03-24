import React, { useState, useEffect } from "react";
import ReactPaginate from "react-paginate";

const DataTable = ({ data }) => {
    const [columns, setColumns] = useState([]);
    const [currentPage, setCurrentPage] = useState(0);
    const rowsPerPage = 10;

    if (data === "" || data === '""') data = [];

    useEffect(() => {
        if (data.length > 0) {
            const columnNames = Object.keys(data[0]);
            setColumns(columnNames);
        }
    }, [data]);

    const handlePageClick = (selectedPage) => {
        setCurrentPage(selectedPage.selected);
    };

    console.log("DATA Table", data)
    const displayData = data.slice(
        currentPage * rowsPerPage,
        (currentPage + 1) * rowsPerPage
    );

    console.log("displayData", displayData);

    return (
        <div>
            <table className="min-w-full divide-y divide-gray-200">
                <thead className="bg-gray-50">
                    <tr>
                        {columns.map((column) => (
                            <th key={column} className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                {column}
                            </th>
                        ))}
                    </tr>
                </thead>
                <tbody className="bg-white divide-y divide-gray-200">
                    {displayData ? displayData.map((row, index) => (
                        <tr key={index} className={index % 2 === 0 ? 'bg-white' : 'bg-gray-50'}>
                            {columns.map((column) => (
                                <td key={`${index}-${column}`} className="px-6 py-4 whitespace-nowrap">
                                    {row[column]}
                                </td>
                            ))}
                        </tr>
                    )) : ""}
                </tbody>
            </table>
            <ReactPaginate
                previousLabel={"previous"}
                nextLabel={"next"}
                breakLabel={"..."}
                pageCount={Math.ceil(data.length / rowsPerPage)}
                marginPagesDisplayed={2}
                pageRangeDisplayed={5}
                onPageChange={handlePageClick}
                // activeClassName={"active"}
                containerClassName={"container mx-auto px-4 pagination flex mt-4 justify-center space-x-2"}
                pageClassName={"mx-1 px-2 py-1 border border-gray-300 rounded-md cursor-pointer"}
                activeClassName={"active bg-blue-500 text-white border-transparent"}
                disabledClassName={"opacity-50 cursor-not-allowed"}
                breakLinkClassName={"px-2 py-1"}
                previousClassName={"border border-gray-300 rounded-md cursor-pointer"}
                nextClassName={"border border-gray-300 rounded-md cursor-pointer"}
            />
        </div>
    );
};

export default DataTable;
