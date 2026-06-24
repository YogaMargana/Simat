<?php
session_start();
require_once "config/function.php";

if(!isset($_SESSION['id_pengguna'])) {
    header("Location: login.php");
    exit;
}

$dashboard = arahkan_dashboard($_SESSION['role']);
header("Location: " . $dashboard);
exit;
?>