import React from "react";
import Header from "./Header";
import Table from "./Table";
//import Filter from "./Filter";

function View() {
    return (
    <div class = "view">
        <Header />
        <div class = "view__body">
            <h1>Student Records</h1>
            <Table />
        </div>
    </div>
    );
}

export default View;