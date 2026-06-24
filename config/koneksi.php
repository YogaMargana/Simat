<?php 
$host = "localhost";
$user = "root";
$pass = "";
$db = "db_simat";

$koneksi = mysqli_connect($host, $user, $pass, $db);

if (!$koneksi) {
    die("Koneksi database error: " . mysqli_connect_error());
}

mysqli_set_charset($koneksi, "utf8mb4");
?>