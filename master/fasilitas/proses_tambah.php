<?php
require_once "../../config/koneksi.php";
require_once "../../includes/auth_dashboard.php";

cek_role_dashboard("PIC Aset Fasilitas");

if (!isset($_POST['simpan'])) {
    header("Location: index.php");
    exit;
}

$nama_fasilitas = trim($_POST['nama_fasilitas'] ?? '');
$harga = (float) ($_POST['harga'] ?? 0);

if ($nama_fasilitas == '') {
    header("Location: tambah.php?error=" . urlencode("Nama fasilitas wajib diisi."));
    exit;
}

if ($harga < 0) {
    header("Location: tambah.php?error=" . urlencode("Harga fasilitas tidak boleh kurang dari 0."));
    exit;
}

$stmt = mysqli_prepare($koneksi, "CALL usp_insert_fasilitas(?, ?)");
mysqli_stmt_bind_param($stmt, "sd", $nama_fasilitas, $harga);

if (mysqli_stmt_execute($stmt)) {
    mysqli_stmt_close($stmt);

    header("Location: index.php?status=berhasil_tambah");
    exit;
} else {
    $error = mysqli_error($koneksi);
    mysqli_stmt_close($stmt);

    header("Location: tambah.php?error=" . urlencode($error));
    exit;
}
?>