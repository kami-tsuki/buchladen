<!DOCTYPE html>
<html data-bs-theme="dark" lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Cyber My Admin</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com/" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Rajdhani:wght@300;400;500;600;700&display=swap"
        rel="stylesheet">
    <link rel="stylesheet" href="/style.css">
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    <link rel="stylesheet" href="https://cdn.datatables.net/1.11.5/css/jquery.dataTables.min.css">
</head>

<body class>
    <div class="db-page">
        <div class="row">
            <div class="col-3">
                <div class="list-group" id="sidebar" name="database-select">
                    <!-- Databases to select will be loaded here -->
                </div>
            </div>
            <div class="col-9">
                <div class="tab-content" id="nav-tabContent">
                    <div class="row" id="topbar" name="table-select">
                        <!-- Table names to select  will be loaded here -->
                    </div>
                    <div class="" id="db-table-container">
                        <div class="table" id="nav-tabContent-table">
                            <!-- Table data will be loaded here -->
                        </div>
                    </div>
                </div>
                <div id="loading-banner">
                    <div class="alert alert-info" role="alert">
                        <i class="fas fa-spinner fa-spin"></i> Loading...
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div id="issue-banner">
        <span id="issue-message"><i class="fas fa-exclamation-triangle"></i></span>
        <button id="issue-copy"><i class="fas fa-copy"></i></button>
        <button id="issue-close"><i class="fas fa-times-circle"></i></button>
    </div>
    <div id="success-banner">
        <span id="success-message"><i class="fas fa-check-circle"></i></span>
        <button id="success-close"><i class="fas fa-times-circle"></i></button>
    </div>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
    <script src="https://cdn.datatables.net/1.11.5/js/jquery.dataTables.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/prism/1.24.1/components/prism-core.min.js"></script>
    <script
        src="https://cdnjs.cloudflare.com/ajax/libs/prism/1.24.1/plugins/autoloader/prism-autoloader.min.js"></script>
    <script src="/script.js"></script>
</body>

</html>