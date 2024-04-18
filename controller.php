<?php
header('Content-Type: application/json');
global $conn;
include 'credentials.php';

if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

if (isset($_POST["action"])) {
    switch ($_POST["action"]) {
        case 'get_databases':
            echo json_encode(getDatabaseNames());
            break;
        case 'get_tables':
            if (isset($_POST["database"])) {
                echo json_encode(getTableNames($_POST["database"]));
            }
            break;
        case 'get_table_data':
            if (
                isset($_POST["database"])
                && isset($_POST["table"])
            ) {
                echo json_encode(getTable($_POST["database"], $_POST["table"]));
            }
            break;
        case 'delete_row':
            if (
                isset($_POST["database"])
                && isset($_POST["table"])
                && isset($_POST["id"])
            ) {
                $sql = "DELETE FROM " . $_POST["database"] . "." . $_POST["table"] . " WHERE id=" . $_POST["id"];
                $conn->query($sql);
                echo json_encode(array('status' => 'success'));
            } else {
                echo json_encode(array('status' => 'error'));
            }
            break;
        case 'reset_database':
            if (isset($_POST["database"])) {
                $success = resetDatabase($_POST["database"]);
                echo json_encode(array('status' => $success ? 'success' : 'error'));
            } else {
                echo json_encode(array('status' => 'error'));
            }
            break;
        case 'update_row':
            if (
                isset($_POST["database"])
                && isset($_POST["table"])
                && isset($_POST["id"])
                && isset($_POST["data"])
            ) {
                $success = updateRow($_POST["database"], $_POST["table"], $_POST["id"], $_POST["data"]);
                echo json_encode(array('status' => 'success'));
            }
            break;
        case 'add_row':
            if (
                isset($_POST["database"])
                && isset($_POST["table"])
                && isset($_POST["data"])
            ) {
                $data = $_POST["data"];
                $columns = implode(", ", array_keys($data));
                $values = implode("', '", array_values($data));
                $sql = "INSERT INTO " . $_POST["database"] . "." . $_POST["table"] . " ($columns) VALUES ('$values')";
                $conn->query($sql);
                echo json_encode(array('status' => 'success'));
            }
            break;

    }
}

$buchladenPath = '/buchladen.sql';
$lager_path = '/lager.sql';
function resetDatabase($database)
{
    global $buchladenPath, $lager_path;
    if ($database == 'buchladen') {
        $sql = file_get_contents($buchladenPath);
    } else if ($database == 'lager') {
        $sql = file_get_contents($lager_path);
    } else {
        return false;
    }

    global $conn;
    $conn->multi_query($sql);
    return true;
}

function updateRow($database, $table, $id, $data)
{
    global $conn;
    $sql = "UPDATE $database.$table SET ";
    foreach ($data as $key => $value) {
        $sql .= "$key='$value',";
    }
    $sql = rtrim($sql, ',');
    $sql .= " WHERE id=$id";
    $conn->query($sql);
    return true;
}

function getDatabaseNames()
{
    global $conn;
    $sql = "SHOW DATABASES";
    $result = $conn->query($sql);
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
    $result = $conn->query($sql);
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
    $result = $conn->query($sql);
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
    $result = $conn->query($sql);
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
    $result = $conn->query($sql);
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
    $result = $conn->query($sql);
    $fields = $result->fetch_fields();
    $columns = array();
    foreach ($fields as $field) {
        $columns[] = $field->name;
    }
    return $columns;
}