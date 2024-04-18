// Function to fetch data from credentials.json
async function fetchCredentials() {
    const response = await fetch('credentials.json');
    const credentials = await response.json();
    return credentials;
}

// Function to fetch list of tables from the selected database
async function fetchTables(database) {
    const credentials = await fetchCredentials();
    const { servername, username, password } = credentials;

    const response = await fetch('getTables.php', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify({
            servername,
            username,
            password,
            database
        })
    });

    const tables = await response.json();
    return tables;
}

// Function to handle tab click event
function handleTabClick(event) {
    const database = event.target.dataset.database;
    fetchTables(database)
        .then(tables => {
            // Handle tables data
            console.log(`Tables for ${database}:`, tables);
            // You can update UI with tables data here
        })
        .catch(error => {
            console.error('Error fetching tables:', error);
        });
}

// Attach event listeners to tab links
document.addEventListener('DOMContentLoaded', function () {
    const tabLinks = document.querySelectorAll('.nav-link');
    tabLinks.forEach(link => {
        link.addEventListener('click', handleTabClick);
    });
});
