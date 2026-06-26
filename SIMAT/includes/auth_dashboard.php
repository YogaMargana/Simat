<?php
if (session_status() === PHP_SESSION_NONE) {
    session_start();
}

if (!isset($_SESSION['id_pengguna'])) {
    header("Location: /SIMAT/login.php");
    exit;
}

function cek_role_dashboard($role_diizinkan)
{
    if ($_SESSION['role'] != $role_diizinkan) {
        header("Location: /SIMAT/index.php");
        exit;
    }
}
?>