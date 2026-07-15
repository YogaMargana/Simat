<?php
require_once "../../config/koneksi.php";
require_once "../../config/function.php";
require_once "../../includes/auth_dashboard.php";

cek_role_dashboard("Kepala Prodi");

if (!isset($_POST['simpan'])) { header("Location: index.php"); exit; }

$role = trim($_POST['role'] ?? '');
$id_mahasiswa = $_POST['id_mahasiswa'] ?? null;
$id_pengajar = $_POST['id_pengajar'] ?? null;
$username = trim($_POST['username'] ?? '');
$password = (string) ($_POST['password'] ?? '');

if ($role === '' || $username === '' || $password === '') {
    header("Location: tambah.php?error=" . urlencode("Role, username, dan password wajib diisi.")); exit;
}
if (mb_strlen($username) > 20) {
    header("Location: tambah.php?error=" . urlencode("Username maksimal 20 karakter.")); exit;
}

$duplikat = ambil_satu_procedure_prepared($koneksi, "CALL usp_cek_username_pengguna(?, NULL)", "s", [$username]);
if ((int) ($duplikat['jumlah'] ?? 0) > 0) {
    header("Location: tambah.php?error=" . urlencode("Username sudah digunakan.")); exit;
}

if ($role === "Mahasiswa") {
    if ($id_mahasiswa === null || $id_mahasiswa === '') { header("Location: tambah.php?error=" . urlencode("Data mahasiswa wajib dipilih.")); exit; }
    $id_mahasiswa = (int) $id_mahasiswa; $id_pengajar = null;
} else {
    if ($id_pengajar === null || $id_pengajar === '') { header("Location: tambah.php?error=" . urlencode("Data pengajar wajib dipilih.")); exit; }
    $id_pengajar = (int) $id_pengajar; $id_mahasiswa = null;
}

$password_hash = password_hash($password, PASSWORD_DEFAULT);
$stmt = mysqli_prepare($koneksi, "CALL usp_insert_pengguna(?, ?, ?, ?, ?)");
mysqli_stmt_bind_param($stmt, "iisss", $id_mahasiswa, $id_pengajar, $username, $password_hash, $role);
if (mysqli_stmt_execute($stmt)) { mysqli_stmt_close($stmt); header("Location: index.php?status=berhasil_tambah"); exit; }
$error = pesan_error_statement($stmt, "Data pengguna gagal ditambahkan."); mysqli_stmt_close($stmt);
header("Location: tambah.php?error=" . urlencode($error)); exit;
?>
