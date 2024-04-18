<?php

$servername = "mariadb";
$username = "root";
$password = "password";
$conn = new mysqli($servername, $username, $password);

if ($conn->connect_error) die("Connection failed: " . $conn->connect_error);

if (!empty($_POST['Button'])) {
    echo buildHtml(getTableData($_POST['filterattribut']));
    return;
}

if (!empty($_POST['Reset'])) resetDB();

if (!empty($_POST['add'])) {
    addBuch($_POST['titel'], $_POST['verkaufspreis'], $_POST['einkaufspreis'], $_POST['erscheinungsjahr'], $_POST['verlage_verlage_id']);
}

if (!empty($_POST['edit'])) {
    editBuch($_POST['buecher_id'], $_POST['titel'], $_POST['verkaufspreis'], $_POST['einkaufspreis'], $_POST['erscheinungsjahr'], $_POST['verlage_verlage_id']);
}

if (!empty($_POST['remove'])) {
    removeBuch($_POST['buecher_id']);
}

if (!empty($_POST['search'])) {
    $buecher = searchBuch($_POST['titel']);
    foreach ($buecher as $buch) {
        echo "ID: " . $buch['buecher_id'] . "<br>";
        echo "Titel: " . $buch['titel'] . "<br>";
        echo "Verkaufspreis: " . $buch['verkaufspreis'] . "<br>";
        echo "Einkaufspreis: " . $buch['einkaufspreis'] . "<br>";
        echo "Erscheinungsjahr: " . $buch['erscheinungsjahr'] . "<br>";
        echo "Verlage ID: " . $buch['verlage_verlage_id'] . "<br>";
        echo "<hr>";
    }
}

if (!empty($_POST['fetch'])) {
    $buch = getBuch($_POST['buecher_id']);
    ?>
    <form action="" method="post" class="dumme-get-form">
        <h2 style="text-align: center">Buch bearbeiten</h2>
        <label for="buecher_id">Buch ID: </label>
        <label>
            <input type="number" name="buecher_id" value="<?php echo $buch['buecher_id']; ?>" readonly>
        </label>

        <label for="titel">Titel: </label>
        <label>
            <input type="text" name="titel" value="<?php echo $buch['titel']; ?>">
        </label>

        <label for="verkaufspreis">Verkaufspreis: </label>
        <label>
            <input type="number" step="0.01" name="verkaufspreis" value="<?php echo $buch['verkaufspreis']; ?>">
        </label>

        <label for="einkaufspreis">Einkaufspreis: </label>
        <label>
            <input type="number" step="0.01" name="einkaufspreis" value="<?php echo $buch['einkaufspreis']; ?>">
        </label>

        <label for="erscheinungsjahr">Erscheinungsjahr: </label>
        <label>
            <input type="number" name="erscheinungsjahr" value="<?php echo $buch['erscheinungsjahr']; ?>">
        </label>

        <label for="verlage_verlage_id">Verlag ID: </label>
        <label>
            <input type="number" name="verlage_verlage_id" value="<?php echo $buch['verlage_verlage_id']; ?>">
        </label>

        <button type="submit" name="edit" class="button" value="edit">Bearbeiten</button>
    </form>
    <?php
}


function getTableData($sortBy): array
{
    global $conn;
    $sort = match ($sortBy) {
        "verkaufspreis" => "ORDER BY verkaufspreis DESC",
        "einkaufspreis" => "ORDER BY einkaufspreis DESC",
        "verlage_verlage_id" => "ORDER BY verlage_verlage_id DESC",
        default => "ORDER BY buecher_id DESC",
    };
    $result = $conn->query("SELECT * FROM buchladen.buecher " . $sort);
    while ($row = $result->fetch_assoc()) $tableData[] = $row;
    return $tableData ?? [];
}

function addBuch(string $titel, float $verkaufspreis, float $einkaufspreis, int $erscheinungsjahr, int $verlage_verlage_id): void
{
    global $conn;
    $stmt = $conn->prepare("INSERT INTO buchladen.buecher (titel, verkaufspreis, einkaufspreis, erscheinungsjahr, verlage_verlage_id) VALUES (?, ?, ?, ?, ?)");
    $stmt->bind_param("sddii", $titel, $verkaufspreis, $einkaufspreis, $erscheinungsjahr, $verlage_verlage_id);
    $result = $stmt->execute();
    echo $result ? sprintf("Einfügen des Buches %s war erfolgreich.", $titel) : "Etwas ist schief gegangen";
}

function editBuch(int $buecher_id, string $titel, float $verkaufspreis, float $einkaufspreis, int $erscheinungsjahr, int $verlage_verlage_id): void
{
    global $conn;
    $stmt = $conn->prepare("UPDATE buchladen.buecher SET titel = ?, verkaufspreis = ?, einkaufspreis = ?, erscheinungsjahr = ?, verlage_verlage_id = ? WHERE buecher_id = ?");
    $stmt->bind_param("sddiii", $titel, $verkaufspreis, $einkaufspreis, $erscheinungsjahr, $verlage_verlage_id, $buecher_id);
    $result = $stmt->execute();
    echo $result ? sprintf("Bearbeiten des Buches %s war erfolgreich.", $titel) : "Etwas ist schief gegangen";
}

function getBuch(int $buecher_id): array
{
    global $conn;
    $stmt = $conn->prepare("SELECT * FROM buchladen.buecher WHERE buecher_id = ?");
    $stmt->bind_param("i", $buecher_id);
    $stmt->execute();
    $result = $stmt->get_result();
    $buch = $result->fetch_assoc();
    return $buch ? $buch : [];
}

function removeBuch(int $buecher_id): void
{
    global $conn;
    $stmt = $conn->prepare("DELETE FROM buchladen.buecher WHERE buecher_id = ?");
    $stmt->bind_param("i", $buecher_id);
    $result = $stmt->execute();
    echo $result ? "Das Buch wurde erfolgreich entfernt." : "Etwas ist schief gelaufen";
}

function searchBuch(string $titel): array
{
    global $conn;
    $stmt = $conn->prepare("SELECT * FROM buchladen.buecher WHERE titel LIKE ?");
    $titel = "%" . $titel . "%"; // Add wildcard characters for a partial match
    $stmt->bind_param("s", $titel);
    $stmt->execute();
    $result = $stmt->get_result();
    return $result->fetch_all(MYSQLI_ASSOC);
}

function buildHtml($data): string
{
    $htmlString = '<table><tr><th>Buch ID</th><th>Titel</th><th>Verkaufspreis</th><th>Einkaufspreis</th><th>Erscheinungsjahr</th><th>Verlag ID</th></tr>';
    if ($data) {
        foreach ($data as $row) {
            $htmlString .= '<tr>';
            foreach ($row as $value) $htmlString .= '<td>' . $value . '</td>';
            $htmlString .= '</tr>';
        }
    }
    $htmlString .= '</table>';
    return "<div class='database-table'>$htmlString</div>";
}

function resetDB(): void
{
    global $conn;
    $lines = file('buchladen.sql');
    $tempLine = '';
    foreach ($lines as $line) {
        if (str_starts_with($line, '--') || $line == '') continue;
        $tempLine .= $line;
        if (str_ends_with(trim($line), ';')) {
            mysqli_query($conn, $tempLine) or print("Error in " . $tempLine . ":" . mysqli_error($conn));
            $tempLine = '';
        }
    }
    echo "Tables imported successfully";
}