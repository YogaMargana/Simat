<?php
require_once "../../config/koneksi.php";
require_once "../../includes/auth_dashboard.php";

// /** @var mysqli $koneksi */

cek_role_dashboard("Kepala Prodi");

if (!isset($_POST['update'])) {
    header("Location: index.php");
    exit;
}

$id_kelas = $_POST['id_kelas'] ?? '';
$nama_kelas = strtoupper(trim($_POST['nama_kelas'] ?? ''));
$tingkat = trim($_POST['tingkat'] ?? '');

if ($id_kelas == '' || $nama_kelas == '' || $tingkat == '') {
    header("Location: index.php?error=" . urlencode("Data edit tidak lengkap."));
    exit;
}

$stmt = mysqli_prepare($koneksi, "CALL usp_update_kelas(?, ?, ?)");
mysqli_stmt_bind_param($stmt, "iss", $id_kelas, $nama_kelas, $tingkat);

if (mysqli_stmt_execute($stmt)) {
    mysqli_stmt_close($stmt);

    header("Location: index.php?status=berhasil_edit");
    exit;
} else {
    $error = mysqli_error($koneksi);
    mysqli_stmt_close($stmt);

    header("Location: edit.php?id=" . urlencode($id_kelas) . "&error=" . urlencode($error));
    exit;
}
?>