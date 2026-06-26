<?php
require_once "../../config/koneksi.php";
require_once "../../includes/auth_dashboard.php";

// /** @var mysqli $koneksi */

cek_role_dashboard("Kepala Prodi");

if (!isset($_POST['update'])) {
    header("Location: index.php");
    exit;
}

$id_mahasiswa = $_POST['id_mahasiswa'] ?? '';
$id_kelas = $_POST['id_kelas'] ?? '';
$id_periode_akademik = $_POST['id_periode_akademik'] ?? '';
$nim = trim($_POST['nim'] ?? '');
$nama_mahasiswa = trim($_POST['nama_mahasiswa'] ?? '');
$email = trim($_POST['email'] ?? '');
$no_hp = trim($_POST['no_hp'] ?? '');
$status_mahasiswa = $_POST['status_mahasiswa'] ?? '';

if ($id_mahasiswa == '' || $id_kelas == '' || $id_periode_akademik == '' || $nim == '' || $nama_mahasiswa == '' || $status_mahasiswa == '') {
    header("Location: index.php?error=" . urlencode("Data edit tidak lengkap."));
    exit;
}

$stmt = mysqli_prepare($koneksi, "CALL usp_update_mahasiswa(?, ?, ?, ?, ?, ?, ?, ?)");
mysqli_stmt_bind_param(
    $stmt,
    "iiisssss",
    $id_mahasiswa,
    $id_kelas,
    $id_periode_akademik,
    $nim,
    $nama_mahasiswa,
    $email,
    $no_hp,
    $status_mahasiswa
);

if (mysqli_stmt_execute($stmt)) {
    mysqli_stmt_close($stmt);

    header("Location: index.php?status=berhasil_edit");
    exit;
} else {
    $error = mysqli_error($koneksi);
    mysqli_stmt_close($stmt);

    header("Location: edit.php?id=" . urlencode($id_mahasiswa) . "&error=" . urlencode($error));
    exit;
}
?>