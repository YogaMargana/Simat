<?php
require_once "../../config/koneksi.php";
require_once "../../includes/auth_dashboard.php";
cek_role_dashboard("PIC Aset Fasilitas");
header("Location: index.php?error=" . urlencode("Menu Fasilitas Kelas hanya dapat digunakan untuk melihat data. Kelola kelas fasilitas melalui menu Data Fasilitas."));
exit;
?>
