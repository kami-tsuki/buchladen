<?php
function getCredentialsByName($name) {
    $credentialsFile = './credentials.json';
    if (!file_exists($credentialsFile) || ctype_space(file_get_contents($credentialsFile))) {
        $defaultCredentials = [
            'servername' => 'localhost',
            'username' => 'root',
            'password' => ''
        ];
        file_put_contents($credentialsFile, json_encode($defaultCredentials));
    }
    $credentials = json_decode(file_get_contents($credentialsFile), true);
    return $credentials[$name];
}
$servername = getCredentialsByName("servername");
$username = getCredentialsByName("username");
$password = getCredentialsByName("password");
$conn = new mysqli($servername, $username, $password);
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}
