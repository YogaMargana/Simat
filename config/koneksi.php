<?php
date_default_timezone_set('Asia/Jakarta');

$host = getenv('DB_HOST') ?: 'localhost';
$user = getenv('DB_USER') ?: 'root';
$pass = getenv('DB_PASSWORD') !== false ? getenv('DB_PASSWORD') : '';
$db = getenv('DB_NAME') ?: 'db_simat';
$port = (int) (getenv('DB_PORT') ?: 3306);

$koneksi = mysqli_connect($host, $user, $pass, $db, $port);

if (!$koneksi) {
    error_log('Koneksi database gagal: ' . mysqli_connect_error());
    http_response_code(500);
    exit('Aplikasi tidak dapat terhubung ke database. Silakan hubungi administrator.');
}

mysqli_set_charset($koneksi, 'utf8mb4');
mysqli_query($koneksi, "SET time_zone = '+07:00'");
?>
