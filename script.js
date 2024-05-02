const CONTROLLER_URL = "controller.php";
const LOADING_BANNER = $("#loading-banner");
const ISSUE_BANNER = $("#issue-banner");
const ISSUE_MESSAGE = $("#issue-message");
var URL = new URL(window.location.href);
var database = URL.searchParams.get("database");
var table = URL.searchParams.get("table");
var tableData = null;
const SUCCESS_BANNER = $("#success-banner");
const SUCCESS_MESSAGE = $("#success-message");

function showIssueBanner(message) {
    if (message.length >1){
    ISSUE_MESSAGE.text(message);
    ISSUE_BANNER.show();
    setTimeout(function () {
        ISSUE_BANNER.fadeOut();
    }, 10000);
    }
}

function showSuccessBanner(message) {
    SUCCESS_MESSAGE.text(message);
    SUCCESS_BANNER.show();
    setTimeout(function () {
        SUCCESS_BANNER.fadeOut();
    }, 10000);
}

function log(message) {
    console.log(message);
}

function ajaxRequest(type, data, successCallback, errorCallback) {
    LOADING_BANNER.show();
    $.ajax({
        url: CONTROLLER_URL,
        type: type,
        data: data,
        success: function (response) {
            log(response);
            successCallback(response);
            LOADING_BANNER.hide();
        },
        error: function (response) {
            log(response);
            showIssueBanner(response.responseText);
            if (errorCallback) errorCallback(response);
            LOADING_BANNER.hide();
        },
    });
}

function executeSqlQuery() {
    let sqlQuery = $("#sql-input").val();
    sendSqlQuery(sqlQuery);
}

function sendSqlQuery(sqlQuery) {
    console.log('Sending SQL query:', sqlQuery);
    ajaxRequest("post", {action: "send_sql_query", sql: sqlQuery}, function (response) {
        console.log('Received response:', response);
        tableData = response;
        let html = buildTableHtml(response, true);
        console.log('Built HTML:', html);
        $("#nav-tabContent-table").empty();
        $("#nav-tabContent-table").append(html);
    });
}


function buildTableHeader(columns) {
    let html = '<thead  id="db-table-header"><tr id="db-table-header-row">';
    console.log('columns in buildTableHeader:', columns);
    columns.forEach((column, index) => {
        html += `<th id="db-table-header-cell-${column}" onclick="sortTable(document.getElementById('db-table'), ${index})" draggable="true" ondragend="reorderColumn(event, ${index})">${column}</th>`;
    });
    html += "</tr></thead>";
    return html;
}

function buildTableRow(row, columns, readonly, rowNumber) {
    let html = `<tr id="db-table-row-${rowNumber}" class="db-table-row">`;
    let count = rowNumber;
    let columndel = columns[0];
    let colid = row[columndel];
    let columndelsec = columns[1];
    let colidsec = row[columndelsec];
    columns.forEach((column) => {
        html += `<td id="db-table-cell-${count}-${column}" class="db-table-cell column-${column}" ${readonly ? '' : `contenteditable="true" onblur="saveCellChanges(this.innerText, '${column}', this.innerText, '${row[column]}')"`}>${row[column]}</td>`;
    });
    if (!readonly) {
        console.log("td#db-table-cell-"+count+"-"+columndel);
        console.log("Count "+count+" col "+columndel+" colid "+colid);
        html += `<td ><button class="btn btn-danger button button-delete" id="delete-button-${count}" onclick="deleteRow(${colid},'${colidsec}')"><i class="fa fa-trash" aria-hidden="true"></i></button></td>`;
    }
    html += "</tr>";
    return html;
}

function buildTableBody(data, readonly) {
    let html = '<tbody id="db-table-body">';
    let rowNumber = 1;
    console.log('data in buildTableBody:', data);
    data.data.forEach((row) => {
        html += buildTableRow(row, data.columns, readonly, rowNumber);
        rowNumber++;
    });
    html += "</tbody>";
    return html;
}

function reorderColumn(event, index) {
    console.log('event in reorderColumn:', event);
    let newIndex = event.target.cellIndex;
    if (newIndex !== index) {
        [tableData.columns[index], tableData.columns[newIndex]] = [tableData.columns[newIndex], tableData.columns[index]];
        tableData.data.forEach(row => {
            [row[tableData.columns[index]], row[tableData.columns[newIndex]]] = [row[tableData.columns[newIndex]], row[tableData.columns[index]]];
        });
        let html = buildTableHtml(tableData, false);
        $("#nav-tabContent-table").empty();
        $("#nav-tabContent-table").append(html);
    }
}

function inferInputType(columnValues) {
    let isNumber = true;
    let isDate = true;

    for (let i = 0; i < columnValues.length; i++) {
        if (isNaN(columnValues[i])) {
            isNumber = false;
        }
        if (isNaN(Date.parse(columnValues[i]))) {
            isDate = false;
        }
    }

    if (isNumber) {
        return "number";
    } else if (isDate) {
        return "date";
    } else {
        return "text";
    }
}

function buildTableFooter(data, readonly) {
    let html = "<tfoot id='db-table-footer'>";
    console.log('data in buildTableFooter:', data);
    if (!readonly) {
        html += "<tr class='footer-row add-row'>";
        data.columns.forEach((column) => {
            if (column !== "id") {
                let columnValues = data.data.map(row => row[column]);
                let inputType = inferInputType(columnValues);
                html += `<td class="input-cell footer-cell input-cell-${column}"><input type="${inputType}" id="new-${column}" placeholder="${column}" name="${column}" class="form-control input input-${column}"></td>`;
            }
        });
        html += `<td class="button-cell footer-cell button-cell-add"><button id="addRowButton" class="btn btn-primary button add-button"><i class="fa fa-plus" aria-hidden="true"></i></button></td>`;
        html += "</tr>";
    }
    html += "</tfoot>";
    return html;
}

function buildTableHtml(data, readonly) {
    let html = '<input id="db-table-search" type="text" oninput="filterTable(document.getElementById(\'db-table\'), this.value)" placeholder="Search...">';
    html += '<table id="db-table">';
    console.log('data in buildTableHtml:', data);
    html += buildTableHeader(data.columns);
    html += buildTableBody(data, readonly);
    html += buildTableFooter(data, readonly);
    html += "</table>";
    return html;
}

function saveCellChanges(rowId, columnName, newValue, oldValue) {
    let database = $("#sidebar a.active").text();
    let table = $("#nav-tabContent a.active").text();
    let data = {};
    data[columnName] = newValue;
    console.log("Old value:", oldValue);
    console.log("New value:", newValue);
    if (oldValue === newValue) {
        console.log("No changes to save");
        return;
    }
    ajaxRequest("post", {
        action: "update_row",
        database: database,
        table: table,
        id: oldValue,
        column: columnName,
        data: data
    }, function (response) {
        if (response.status !== "success") {
            showIssueBanner("Failed to update row");
        } else {
            showSuccessBanner("Row updated successfully");
        }
    });
}

function getDatabases() {
    log("Getting databases");
    return new Promise(function (resolve, reject) {
        ajaxRequest("post", {action: "get_databases"}, function (response) {
            let databases = response;
            databases.forEach(function (database) {
                $("#sidebar").append(
                    `<a id="action-database-${database}" href="#${database}" class="list-group-item list-group-item-action">${database}</a>`
                );
            });
            resolve();
            if (response.status !== "success" && response.length === 0) {
                console.log("Failed to get databases", response);
                showIssueBanner("Failed to get databases");
            } else {
                console.log("Databases loaded successfully", response);
                showSuccessBanner("Databases loaded successfully");
            }
        });
    });
}

function getTables(database) {
    log("Getting tables for " + database);
    return new Promise(function (resolve, reject) {
        ajaxRequest("post", {action: "get_tables", database: database}, function (response) {
            var tables = response;
            tables.unshift("dashboard");
            $("#topbar").empty();
            tables.forEach(function (table) {
                $("#topbar").append(
                    `<a id="action-table-${database}-${table}" href="#${database}-${table}" class="list-group-item list-group-item-action">${table}</a>`
                );
            });
            resolve();
        });
    });
}

function getTableData(database, table) {
    log("Getting table data for " + database + "." + table);
    ajaxRequest("post", {action: "get_table_data", database: database, table: table}, function (response) {
        console.log(response);
        tableData = response;
        let html = buildTableHtml(response, table === "dashboard");
        $("#nav-tabContent-table").empty();
        $("#nav-tabContent-table").append(html);
    });
}

let sortDirection = {};

function sortTable(table, colIndex) {
    let tbody = table.querySelector('tbody');
    let rows = Array.from(tbody.rows);
    let direction = sortDirection[colIndex] || 1;
    rows.sort(
        (rowA, rowB) =>
            direction *
            (rowA.cells[colIndex].innerText > rowB.cells[colIndex].innerText ? 1 : -1)
    );
    tbody.innerHTML = "";
    tbody.append(...rows);
    sortDirection[colIndex] = -direction;
    let header = table.querySelector('thead tr');
    for (let i = 0; i < header.cells.length; i++) {
        let tempDiv = document.createElement("div");
        tempDiv.innerHTML = header.cells[i].innerHTML;
        let sortArrows = tempDiv.getElementsByClassName("sort-arrow");
        while (sortArrows[0]) {
            sortArrows[0].parentNode.removeChild(sortArrows[0]);
        }
        header.cells[i].innerHTML = tempDiv.innerHTML;
    }
    let arrowSpan = document.createElement("span");
    arrowSpan.className = "sort-arrow";
    arrowSpan.style.float = "right";
    arrowSpan.textContent = direction === 1 ? "▲" : "▼";
    header.cells[colIndex].appendChild(arrowSpan);
}

function filterTable(table, query) {
    let tbody = table.querySelector('tbody');
    let rows = Array.from(tbody.rows);
    if (query === "") {
        rows.forEach((row) => (row.style.display = ""));
        return;
    }
    if (query === "RICK")
        window.location.href = "https://www.youtube.com/watch?v=dQw4w9WgXcQ";
    for (let row of rows) {
        let shouldHide = Array.from(row.cells).every(
            (cell) => !cell.innerText.includes(query)
        );
        row.style.display = shouldHide ? "none" : "";
    }
}

function deleteRow(value,valuesec) {
    let database = $("#sidebar a.active").text();
    let table = $("#nav-tabContent a.active").text();
    let sql = `SHOW COLUMNS FROM ${database}.${table} LIKE '%id%';`;
    let rowNumber = value;
    let rowNumbersec = valuesec;
    ajaxRequest("post", { action: "delete_row_sql", sql: sql }, function (response) {
        let primaryKeys = [];
        response.forEach(function (column) {
            if (column.Key === 'PRI') {
                primaryKeys.push(column.Field);
            }
        });
        console.log('Primary keys:', primaryKeys);
        sqldel = `DELETE FROM ${database}.${table} WHERE ${table}.${primaryKeys[0]} = ${rowNumber}`;
        if (primaryKeys[1]!=null){
            sqldel += ` AND ${table}.${primaryKeys[1]} = ${rowNumbersec}`;
        }
        console.log(sqldel);
        ajaxRequest("post", { action: "delete_row", sql: sqldel }, function (response) {
        console.log('Deleting:'+response);
        showSuccessBanner("Deleted");
    });
    });
}

$(document).ready(function () {
    log("Document is ready");
    getDatabases().then(function () {
        if (database) {
            $(`#action-database-${database}`).addClass("active");
            getTables(database).then(function () {
                if (table) {
                    $(`#action-table-${database}-${table}`).addClass("active");
                    getTableData(database, table);
                }
            });
        }
    });
    $("#sidebar").on("click", "a", sidebarOnClick);
    $("#nav-tabContent").on("click", "a", navTabContentOnClick);
    $("#nav-tabContent-table").on("click", "#addRowButton", addRowButtonOnClick);
    $("#issue-close").click(issueCloseOnClick);
    $("#issue-copy").click(issueCopyOnClick);
    $("#saveRow").click(saveRowOnClick);
    $("#success-close").click(successCloseOnClick);
    $("#execute-sql").click(executeSqlQuery);
    log("Document is loaded");
});

function sidebarOnClick(e) {
    e.preventDefault();
    $("#sidebar a").removeClass("active");
    $(this).addClass("active");
    let selected = $(this).text();
    if (selected === "Console") {
        $("#console").show();
        $("#db-table-container").hide();
        $("#topbar").hide();
        LOADING_BANNER.hide();
        window.history.pushState({}, '', window.location.pathname);
    } else {
        $("#console").hide();
        $("#db-table-container").show();
        $("#topbar").show();
        database = selected;
        log("Clicked on database " + database);
        getTables(database);
        window.history.pushState({}, '', `?database=${database}`);
        LOADING_BANNER.hide();
    }
}

function navTabContentOnClick(e) {
    e.preventDefault();
    let database = $("#sidebar a.active").text();
    if (!database) {
        showIssueBanner("Please select a database first");
        return;
    }
    $("#nav-tabContent a").removeClass("active");
    $(this).addClass("active");
    table = $(this).text();
    log("Clicked on table " + table);
    getTableData(database, table);
    window.history.pushState({}, '', `?database=${database}&table=${table}`);
}

function addRowButtonOnClick() {
    let database = $("#sidebar a.active").text();
    let table = $("#nav-tabContent a.active").text();
    let newRowData = {};
    $("#db-table-footer input").each(function () {
        let input = $(this);
        newRowData[input.attr('name')] = input.val();
    });
    let data = {
        action: "add_row",
        database: database,
        table: table,
        data: JSON.stringify(newRowData)
    };
    log("Adding row: ", data);
    ajaxRequest("post", data, function (response) {
        if (response.status !== "success") {
            showIssueBanner("Failed to add row");
        } else {
            getTableData(database, table);
            $("#db-table-footer input").val(''); // clear the input fields
        }
    });
}

function issueCloseOnClick() {
    ISSUE_BANNER.fadeOut();
}

function successCloseOnClick() {
    SUCCESS_BANNER.fadeOut();
}

function issueCopyOnClick() {
    var tempInput = document.createElement("input");
    tempInput.value = ISSUE_MESSAGE.text();
    document.body.appendChild(tempInput);
    tempInput.select();
    document.execCommand("copy");
    document.body.removeChild(tempInput);
    alert("Issue message copied to clipboard");
}

function saveRowOnClick() {
    let database = $("#sidebar a.active").text();
    let table = $("#nav-tabContent a.active").text();
    let newRowData = {};
    $("#addRowForm input").each(function () {
        let input = $(this);
        newRowData[input.attr('name')] = input.val();
    });
    let data = {
        action: "add_row",
        database: database,
        table: table,
        data: JSON.stringify(newRowData)
    };
    log("Adding row: ", data);
    ajaxRequest("post", data, function (response) {
        if (response.status !== "success") {
            showIssueBanner("Failed to add row");
        } else {
            getTableData(database, table);
        }
    });
}
