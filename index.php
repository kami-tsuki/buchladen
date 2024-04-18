<?php include 'credentials.php'; ?>
<?php
global $conn;
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}
if (isset($_POST['Reset'])) {
    unset($_POST['database']);
    unset($_POST['table']);
}

$databases = getDatabaseNames($conn);
?>


<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Database Selector</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    <link rel="stylesheet" href="https://cdn.datatables.net/1.11.5/css/jquery.dataTables.min.css">
</head>
<body>
div class="container">
<ul class="nav nav-tabs" id="databaseTab" role="tablist">
    <?php foreach ($databases as $index => $database): ?>
        <li class="nav-item" role="presentation">
            <a class="nav-link <?php if ($index === 0) echo 'active' ?>" id="tab-<?php echo $database ?>" data-toggle="tab" href="#<?php echo $database ?>" role="tab" aria-controls="<?php echo $database ?>" aria-selected="true"><?php echo $database ?></a>
        </li>
    <?php endforeach; ?>
</ul>
<div class="tab-content" id="databaseTabContent">
    <!-- Database tables will be loaded here with AJAX -->

    <form action="" method="post" class="dumme-get-form">
        <h2 style="text-align: center">Buch bearbeiten</h2>
        <label for="buecher_id">Buch ID: </label>
        <label>
            <input type="number" name="buecher_id" placeholder="Buch ID">
        </label>
        <button type="submit" name="fetch" class="button" value="fetch">Buchdetails abrufen</button>
    </form>

    <form action="" method="post" class="dumme-get-form">
        <h2 style="text-align: center">Buch entfernen</h2>
        <label for="buecher_id">Buch ID: </label>
        <label>
            <input type="number" name="buecher_id" placeholder="Buch ID">
        </label>
        <button type="submit" name="remove" class="button danger" value="remove">Entfernen</button>
    </form>

    <form action="" method="post" class="dumme-get-form">
        <h2 style="text-align: center">Buch suchen</h2>
        <label for="titel">Titel: </label>
        <label>
            <input type="text" name="titel" placeholder="Buchtitel">
        </label>
        <button type="submit" name="search" class="button" value="search">Suchen</button>
    </form>
</div>
</div>


<!-- Required libraries -->
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://cdn.datatables.net/1.11.5/js/jquery.dataTables.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/prism/1.24.1/components/prism-core.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/prism/1.24.1/plugins/autoloader/prism-autoloader.min.js"></script>


<script>
    $(document).ready(function() {
        $('#databaseTab a').on('click', function (e) {
            e.preventDefault();
            let database = $(this).attr('href').substring(1);
            $.ajax({
                url: 'controller.php',
                type: 'post',
                data: {database: database},
                success: function(response) {
                    $('#databaseTabContent').html(response);
                    $('#databaseTabContent table').DataTable();
                }
            });

            $(this).tab('show');
        });

        // Trigger click event on the first tab to load the first database tables
        $('#databaseTab a:first').trigger('click');
    });
</script>
</body>
</html>
