<?php
require_once "../../config/koneksi.php";
require_once "../../includes/auth_dashboard.php";

// /** @var mysqli $koneksi */

cek_role_dashboard("Kepala Prodi");

if (!isset($_POST['simpan'])) {
    header("Location: index.php");
    exit;
}

$nama_kelas = strtoupper(trim($_POST['nama_kelas'] ?? ''));
$tingkat = trim($_POST['tingkat'] ?? '');

if ($nama_kelas == '' || $tingkat == '') {
    header("Location: tambah.php?error=" . urlencode("Nama kelas dan tingkat wajib diisi."));
    exit;
}

$stmt = mysqli_prepare($koneksi, "CALL usp_insert_kelas(?, ?)");
mysqli_stmt_bind_param($stmt, "ss", $nama_kelas, $tingkat);

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