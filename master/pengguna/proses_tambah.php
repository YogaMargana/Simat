<?php
require_once "../../config/koneksi.php";
require_once "../../includes/auth_dashboard.php";

// /** @var mysqli $koneksi */

cek_role_dashboard("Kepala Prodi");

if (!isset($_POST['simpan'])) {
    header("Location: index.php");
    exit;
}

$role = $_POST['role'] ?? '';
$id_mahasiswa = $_POST['id_mahasiswa'] ?? null;
$id_pengajar = $_POST['id_pengajar'] ?? null;
$username = trim($_POST['username'] ?? '');
$password = trim($_POST['password'] ?? '');

if ($role == '' || $username == '' || $password == '') {
    header("Location: tambah.php?error=" . urlencode("Role, username, dan password wajib diisi."));
    exit;
}

if ($role == "Mahasiswa") {
    if ($id_mahasiswa == '') {
        header("Location: tambah.php?error=" . urlencode("Data mahasiswa wajib dipilih."));
        exit;
    }

    $id_pengajar = null;
} else {
    if ($id_pengajar == '') {
        header("Location: tambah.php?error=" . urlencode("Data pengajar wajib dipilih."));
        exit;
    }

    $id_mahasiswa = null;
}

$stmt = mysqli_prepare($koneksi, "CALL usp_insert_pengguna(?, ?, ?, ?, ?)");
mysqli_stmt_bind_param(
    $stmt,
    "iisss",
    $id_mahasiswa,
    $id_pengajar,
    $username,
    $password,
    $role
);

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