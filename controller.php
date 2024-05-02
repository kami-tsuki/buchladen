<?php
header('Content-Type: application/json');
global $conn;
include 'credentials.php';

try {
    if ($conn->connect_error) {
        throw new Exception("Connection failed: " . $conn->connect_error);
    }

    if (isset($_POST["action"])) {
        error_log("Received action: " . $_POST["action"]);
        switch ($_POST["action"]) {
            case 'get_databases':
                error_log("Getting database names");
                echo json_encode(getDatabaseNames());
                break;
            case 'get_tables':
                if (isset($_POST["database"])) {
                    error_log("Getting table names for database: " . $_POST["database"]);
                    echo json_encode(getTableNames($_POST["database"]));
                }
                break;
            case 'get_table_data':
                if (isset($_POST["database"]) && isset($_POST["table"])) {
                    error_log("Getting table data for table: " . $_POST["table"] . " in database: " . $_POST["database"]);
                    echo json_encode(getTable($_POST["database"], $_POST["table"]));
                }
                break;
            case 'delete_row_sql':
                if (isset($_POST["sql"])) {
                    error_log("Executing SQL: " . $_POST["sql"]);
                    $result = $conn->query($_POST["sql"]);
                    if ($conn->error) {
                        throw new Exception("SQL error: " . $conn->error);
                    }
                    $data = array();
                    if ($result->num_rows > 0) {
                        while ($row = $result->fetch_assoc()) {
                            $data[] = $row;
                        }
                    }
                    echo json_encode($data);
                } else {
                    throw new Exception("Missing parameters for query action");
                }
                break;
            case 'delete_row':
                if (isset($_POST["sql"])) {
                    error_log("Executing SQL: " . $_POST["sql"]);
                    $result = $conn->query($_POST["sql"]);
                    if ($conn->error) {
                        throw new Exception("SQL error: " . $conn->error);
                    }
                } else {
                    throw new Exception("Missing parameters for query action");
                }
                break;
            case 'reset_database':
                if (isset($_POST["database"])) {
                    error_log("Resetting database: " . $_POST["database"]);
                    $success = resetDatabase($_POST["database"]);
                    echo json_encode(array('status' => $success ? 'success' : 'error'));
                } else {
                    throw new Exception("Missing parameters for reset_database action");
                }
                break;
            case 'update_row':
                if (isset($_POST["database"]) && isset($_POST["table"]) && isset($_POST["id"])&& isset($_POST["column"]) && isset($_POST["data"])) {
                    error_log("Updating row with: ". $_POST["column"] ."=" . $_POST["id"] . " in table: " . $_POST["table"] . " in database: " . $_POST["database"]);
                    $success = updateRow($_POST["database"], $_POST["table"], $_POST["id"], $_POST["column"], $_POST["data"]);
                    echo json_encode(array('status' => 'success'));
                } else {
                    throw new Exception("Missing parameters for update_row action");
                }
                break;
            case 'add_row':
                if (isset($_POST["database"]) && isset($_POST["table"]) && isset($_POST["data"])) {
                    error_log("Adding row to table: " . $_POST["table"] . " in database: " . $_POST["database"]);
                    $data = json_decode($_POST["data"], true);
                    $columns = implode(", ", array_keys($data));
                    $values = implode(", ", array_map(function($value) {
                        return "'" . $value . "'";
                    }, array_values($data)));

                    $sql = "INSERT INTO " . $_POST["database"] . "." . $_POST["table"] . " (" . $columns . ") VALUES (" . $values . ")";
                    $conn->query($sql);
                    if ($conn->error) {
                        throw new Exception("SQL error: " . $conn->error);
                    }
                    echo json_encode(array('status' => 'success'));
                } else {
                    throw new Exception("Missing parameters for add_row action");
                }
                break;
            case 'send_sql_query':
                if (isset($_POST["sql"])) {
                    error_log("Executing SQL: " . $_POST["sql"]);
                    $result = $conn->query($_POST["sql"]);
                    if ($conn->error) {
                        throw new Exception("SQL error: " . $conn->error);
                    }
                    $data = array();
                    if ($result->num_rows > 0) {
                        while ($row = $result->fetch_assoc()) {
                            $data[] = $row;
                        }
                    }
                    echo json_encode($data);
                } else {
                    throw new Exception("Missing parameters for query action");
                }
            default:
                throw new Exception("Invalid action: " . $_POST["action"]);
        }
    }
} catch (Exception $e) {
    error_log($e->getMessage());
    echo json_encode(array('status' => 'error', 'message' => $e->getMessage()));
}

$buchladenPath = '/buchladen.sql';
$lager_path = '/lager.sql';

function resetDatabase($database)
{
    global $conn, $buchladenPath, $lager_path;
    error_log("Resetting database: " . $database);
    if ($database == 'buchladen') {
        $sql = file_get_contents($buchladenPath);
    } else if ($database == 'lager') {
        $sql = file_get_contents($lager_path);
    } else {
        throw new Exception("Invalid database name: " . $database);
    }

    $conn->multi_query($sql);
    if ($conn->error) {
        throw new Exception("SQL error: " . $conn->error);
    }
    return true;
}

function updateRow($database, $table, $oldValue, $column, $data)
{
    global $conn;
    $sql = "UPDATE $database.$table SET ";
    foreach ($data as $key => $value) {
        if (strtotime($value)) {
            $value = date('Y-m-d', strtotime($value));
        }
        $sql .= "$key='$value',";
    }
    $sql = rtrim($sql, ',');
    $sql .= " WHERE $column='$oldValue'";
    error_log("Executing SQL: " . $sql);
    $conn->query($sql);
    if ($conn->error) {
        throw new Exception("SQL error: " . $conn->error);
    }
    return true;
}

function getDatabaseNames()
{
    global $conn;
    $sql = "SHOW DATABASES";
    error_log("Executing SQL: " . $sql);
    $result = $conn->query($sql);
    if ($conn->error) {
        throw new Exception("SQL error: " . $conn->error);
    }
    $databases = array();
    $systemDatabases = array('information_schema', 'mysql', 'performance_schema', 'sys');
    if ($result->num_rows > 0) {
        while ($row = $result->fetch_assoc()) {
            if (!in_array($row['Database'], $systemDatabases)) {
                $databases[] = $row['Database'];
            }
        }
    }
    return $databases;
}

function getTableNames($database)
{
    global $conn;
    $sql = "SHOW TABLES FROM $database";
    error_log("Executing SQL: " . $sql);
    $result = $conn->query($sql);
    if ($conn->error) {
        throw new Exception("SQL error: " . $conn->error);
    }
    $tables = array();
    if ($result->num_rows > 0) {
        while ($row = $result->fetch_assoc()) {
            $tables[] = $row["Tables_in_$database"];
        }
    }
    return $tables;
}

function getTableData($database, $table)
{
    global $conn;
    $sql = "SELECT * FROM $database.$table";
    error_log("Executing SQL: " . $sql);
    $result = $conn->query($sql);
    if ($conn->error) {
        throw new Exception("SQL error: " . $conn->error);
    }
    $data = array();
    if ($result->num_rows > 0) {
        while ($row = $result->fetch_assoc()) {
            $data[] = $row;
        }
    }
    return $data;
}

function getTableColumns($database, $table)
{
    global $conn;
    if ($table == 'dashboard') {
        return getTableStatusColumns($database);
    }
    $sql = "SHOW COLUMNS FROM $database.$table";
    error_log("Executing SQL: " . $sql);
    $result = $conn->query($sql);
    if ($conn->error) {
        throw new Exception("SQL error: " . $conn->error);
    }
    $columns = array();
    if ($result->num_rows > 0) {
        while ($row = $result->fetch_assoc()) {
            $columns[] = $row['Field'];
        }
    }
    return $columns;
}

function getTable($database, $table)
{
    $columns = getTableColumns($database, $table);
    $data = $table == 'dashboard'
        ? getDatabaseStatus($database)
        : getTableData($database, $table);
    return array('columns' => $columns, 'data' => $data);
}

function getDatabaseStatus($database)
{
    global $conn;
    $statusTable = array();
    $sql = "SHOW TABLE STATUS FROM $database";
    error_log("Executing SQL: " . $sql);
    $result = $conn->query($sql);
    if ($conn->error) {
        throw new Exception("SQL error: " . $conn->error);
    }
    if ($result->num_rows > 0) {
        while ($row = $result->fetch_assoc()) {
            $statusTable[] = $row;
        }
    }
    return $statusTable;
}

function getTableStatusColumns($database)
{
    global $conn;
    $sql = "SHOW TABLE STATUS FROM $database";
    error_log("Executing SQL: " . $sql);
    $result = $conn->query($sql);
    if ($conn->error) {
        throw new Exception("SQL error: " . $conn->error);
    }
    $fields = $result->fetch_fields();
    $columns = array();
    foreach ($fields as $field) {
        $columns[] = $field->name;
    }
    return $columns;
}
