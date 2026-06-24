<?php
require_once "../../config/koneksi.php";
require_once "../../includes/auth_dashboard.php";

// /** @var mysqli $koneksi */

cek_role_dashboard("Kepala Prodi");

if (!isset($_POST['update'])) {
    header("Location: index.php");
    exit;
}

$id_pengguna = $_POST['id_pengguna'] ?? '';
$role = $_POST['role'] ?? '';
$id_mahasiswa = $_POST['id_mahasiswa'] ?? null;
$id_pengajar = $_POST['id_pengajar'] ?? null;
$username = trim($_POST['username'] ?? '');
$password_baru = trim($_POST['password'] ?? '');
$password_lama = trim($_POST['password_lama'] ?? '');
$foto_profil_url = trim($_POST['foto_profil_url'] ?? '');

if ($id_pengguna == '' || $role == '' || $username == '') {
    header("Location: index.php?error=" . urlencode("Data edit tidak lengkap."));
    exit;
}

$password = $password_baru == '' ? $password_lama : $password_baru;

if ($role == "Mahasiswa") {
    if ($id_mahasiswa == '') {
        header("Location: edit.php?id=" . urlencode($id_pengguna) . "&error=" . urlencode("Data mahasiswa wajib dipilih."));
        exit;
    }

    $id_pengajar = null;
} else {
    if ($id_pengajar == '') {
        header("Location: edit.php?id=" . urlencode($id_pengguna) . "&error=" . urlencode("Data pengajar wajib dipilih."));
        exit;
    }

    $id_mahasiswa = null;
}

if ($foto_profil_url == '') {
    $foto_profil_url = null;
}

$stmt = mysqli_prepare($koneksi, "CALL usp_update_pengguna(?, ?, ?, ?, ?, ?)");
mysqli_stmt_bind_param(
    $stmt,
    "iiisss",
    $id_pengguna,
    $id_mahasiswa,
    $id_pengajar,
    $username,
    $password,
    $role
);

if (mysqli_stmt_execute($stmt)) {
    mysqli_stmt_close($stmt);

    header("Location: index.php?status=berhasil_edit");
    exit;
} else {
    $error = mysqli_error($koneksi);
    mysqli_stmt_close($stmt);

    header("Location: edit.php?id=" . urlencode($id_pengguna) . "&error=" . urlencode($error));
    exit;
}
?>