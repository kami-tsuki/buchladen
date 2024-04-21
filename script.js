
$(document).ready(function () {
    console.log("Document is ready");
    getDatabases();
    $("#sidebar").on("click", "a", function (e) {
        e.preventDefault();
        $("#sidebar a").removeClass("active");
        $(this).addClass("active");
        var database = $(this).text();

        console.log("Clicked on database " + database);
        getTables(database);
    });
    $("#nav-tabContent").on("click", "a", function (e) {
        e.preventDefault();
        $("#nav-tabContent a").removeClass("active");
        $(this).addClass("active");
        let database = $("#sidebar a.active").text();
        let table = $(this).text();
        console.log("Clicked on table " + table);
        getTableData(database, table);
    });
    console.log("Document is loaded");
});

function inferInputType(values) {
    if (values.every(value => !isNaN(value))) {
        return 'number';
    } else if (values.every(value => !isNaN(Date.parse(value)))) {
        return 'date';
    } else {
        return 'text';
    }
}

function buildTableHtml(data, readonly) {
    let html =
        '<input id="db-table-search" type="text" oninput="filterTable(document.getElementById(\'db-table\'), this.value)" placeholder="Search...">';
    html += '<table id="db-table">';
    html += '<thead  id="db-table-header"><tr id="db-table-header-row">';
    data.columns.forEach((column, index) => {
        html += `<th id="db-table-header-cell-${column}" onclick="sortTable(document.getElementById('db-table'), ${index})" draggable="true" ondragend="reorderColumn(event, ${index})">${column}</th>`;
    });
    html += "</tr></thead>";
    html += '<tbody id="db-table-body">';
    data.data.forEach((row, rowIndex) => {
        let rowClass = rowIndex % 2 === 0 ? "row-even" : "row-odd";
        html += `<tr id="db-table-row-${row.id}" class="${rowClass} db-table-row">`;
        data.columns.forEach((column) => {
            html += `<td id="db-table-cell-${row.id}-${column}" class="db-table-cell column-${column}" ${readonly ? '' : `contenteditable="true" onblur="saveCellChanges('${row.id}', '${column}', this.innerText)"`}>${row[column]}</td>`;
            });
        if (!readonly) {
            html += `<td><button onclick="deleteRow('${row.id}')">Delete</button></td>`;
        }
        html += "</tr>";
    });
    html += "</tbody>";
    html += "<tfoot></tfoot>";
    html += "</table>";
    return html;
}

function saveCellChanges(rowId, columnName, newValue) {
    let database = $("#sidebar a.active").text();
    let table = $("#nav-tabContent a.active").text();
    let data = {};
    data[columnName] = newValue;

    $.ajax({
        url: "controller.php",
        type: "post",
        data: { action: "update_row", database: database, table: table, id: rowId, data: data },
        success: function (response) {
            console.log("Server response: ", response);
            if (response.status !== "success") {
                showIssueBanner("Failed to update row");
            }
        },
        error: function (response) {
            console.log("AJAX error: ", response);
            showIssueBanner(`Error ${response.status}: ${response.statusText}\n ${response.responseText}`);
        },
    });
}

function getDatabases() {
    console.log("Getting databases");
    $("#loading-banner").show();
    $.ajax({
        url: "controller.php",
        type: "post",
        data: { action: "get_databases" },
        success: function (response) {
            console.log(response);
            var databases = response;
            databases.forEach(function (database) {
                $("#sidebar").append(
                    '<a id="action-database-' +
                    database +
                    '" href="#' +
                    database +
                    '" class="list-group-item list-group-item-action">' +
                    database +
                    "</a>"
                );
            });
            $("#loading-banner").hide();
        },
        error: function (response) {
            console.log(response);
            showIssueBanner(response.responseText);
            $("#loading-banner").hide();
        },
    });
}

function getTables(database) {
    console.log("Getting tables for " + database);
    $("#loading-banner").show();
    $.ajax({
        url: "controller.php",
        type: "post",
        data: { action: "get_tables", database: database },
        success: function (response) {
            console.log(response);
            var tables = response;
            tables.unshift("dashboard");
            $("#topbar").empty();
            tables.forEach(function (table) {
                $("#topbar").append(
                    '<a id="action-table-' +
                    database +
                    "-" +
                    table +
                    '" href="#' +
                    database +
                    "-" +
                    table +
                    '" class="list-group-item list-group-item-action">' +
                    table +
                    "</a>"
                );
            });
            $("#loading-banner").hide();
        },
        error: function (response) {
            console.log(response);
            showIssueBanner(response.responseText);
            $("#loading-banner").hide();
        },
    });
}
function getTableData(database, table) {
    console.log("Getting table data for " + database + "." + table);
    $("#loading-banner").show();
    $.ajax({
        url: "controller.php",
        type: "post",
        data: { action: "get_table_data", database: database, table: table },
        success: function (response) {
            console.log(response);
            var data = response;
            var html = buildTableHtml(data, table === "dashboard");
            $("#nav-tabContent-table").empty();
            $("#nav-tabContent-table").append(html);
            if (table != "dashboard") {
                $("#nav-tabContent-table").append(
                    '<button id="addRowButton" class="btn btn-primary">Add Row</button>'
                );
                $("#nav-tabContent-table").on("click", "#addRowButton", function () {
                    $("#addRowModal").modal("show");
                });
            }
            $("#addRowForm").empty();
            data.columns.forEach((column) => {
                if (column !== "id") {
                    let columnValues = data.data.map(row => row[column]);
                    let inputType = inferInputType(columnValues);
                    $("#addRowForm").append(
                        `<label for="${column}">${column}</label><input type="${inputType}" id="${column}" name="${column}" class="form-control">`
                    );
                }
            });
            $("#loading-banner").hide();
        },
        error: function (response) {
            console.log(response);
            showIssueBanner(response.responseText);
            $("#loading-banner").hide();
        },
    });
}
let sortDirection = {};
function sortTable(table, colIndex) {
    let rows = Array.from(table.rows);
    let header = rows.shift();
    let direction = sortDirection[colIndex] || 1;
    rows.sort(
        (rowA, rowB) =>
            direction *
            (rowA.cells[colIndex].innerText > rowB.cells[colIndex].innerText ? 1 : -1)
    );
    table.innerHTML = "";
    table.append(header);
    table.append(...rows);
    sortDirection[colIndex] = -direction;
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
    let rows = Array.from(table.rows);
    if (query === "") {
        rows.forEach((row) => (row.style.display = ""));
        return;
    }
    if (query === "RICK")
        window.location.href = "https://www.youtube.com/watch?v=dQw4w9WgXcQ";
    let header = rows.shift();
    for (let row of rows) {
        let shouldHide = Array.from(row.cells).every(
            (cell) => !cell.innerText.includes(query)
        );
        row.style.display = shouldHide ? "none" : "";
    }
}
function showIssueBanner(message) {
    $("#issue-message").text(message);
    $("#issue-banner").show();
}
$("#issue-close").click(function () {
    $("#issue-banner").hide();
});
$("#issue-copy").click(function () {
    var tempInput = document.createElement("input");
    tempInput.value = $("#issue-message").text();
    document.body.appendChild(tempInput);
    tempInput.select();
    document.execCommand("copy");
    document.body.removeChild(tempInput);
    alert("Issue message copied to clipboard");
});

$("#saveRow").click(function () {
    let database = $("#sidebar a.active").text();
    let table = $("#nav-tabContent a.active").text();
    let newRowData = {};
    $("#addRowForm input").each(function() {
        let input = $(this);
        newRowData[input.attr('name')] = input.val();
    });
    let data = {
        action: "add_row",
        database: database,
        table: table,
        data: JSON.stringify(newRowData)
    };
    console.log("Adding row: ", data);
    $.ajax({
        url: "controller.php",
        type: "post",
        data: data,
        dataType: 'json',
        success: function (response) {
            console.log("Server response: ", response);
            if (response.status !== "success") {
                showIssueBanner("Failed to add row");
            } else {
                getTableData(database, table);
            }
        },
        error: function (response) {
            console.log("AJAX error: ", response);
            showIssueBanner(`Error ${response.status}: ${response.statusText}\n ${response.responseText}`);
        },
    });
});

function deleteRow(rowId) {
    let database = $("#sidebar a.active").text();
    let table = $("#nav-tabContent a.active").text();

    $.ajax({
        url: "controller.php",
        type: "post",
        data: { action: "delete_row", database: database, table: table, id: rowId },
        success: function (response) {
            console.log("Server response: ", response);
            if (response.status !== "success") {
                showIssueBanner("Failed to delete row");
            } else {
                getTableData(database, table);  // Refresh the table
            }
        },
        error: function (response) {
            console.log("AJAX error: ", response);
            showIssueBanner(`Error ${response.status}: ${response.statusText}\n ${response.responseText}`);
        },
    });
}

showIssueBanner("still a test lol");
