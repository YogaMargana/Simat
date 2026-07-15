<?php
require_once "../../config/koneksi.php";
require_once "../../config/function.php";
require_once "../../includes/auth_dashboard.php";

cek_role_dashboard("Kepala Prodi");
if (!isset($_POST['update'])) { header("Location: index.php"); exit; }

$id_pengguna = (int) ($_POST['id_pengguna'] ?? 0);
$role = trim($_POST['role'] ?? '');
$id_mahasiswa = $_POST['id_mahasiswa'] ?? null;
$id_pengajar = $_POST['id_pengajar'] ?? null;
$username = trim($_POST['username'] ?? '');
$password_baru = (string) ($_POST['password'] ?? '');
$kembali = "edit.php?id=" . urlencode($id_pengguna);

if ($id_pengguna <= 0 || $role === '' || $username === '') { header("Location: index.php?error=" . urlencode("Data edit tidak lengkap.")); exit; }
if (mb_strlen($username) > 20) { header("Location: {$kembali}&error=" . urlencode("Username maksimal 20 karakter.")); exit; }

$duplikat = ambil_satu_procedure_prepared($koneksi, "CALL usp_cek_username_pengguna(?, ?)", "si", [$username, $id_pengguna]);
if ((int) ($duplikat['jumlah'] ?? 0) > 0) { header("Location: {$kembali}&error=" . urlencode("Username sudah digunakan oleh pengguna lain.")); exit; }

if ($role === "Mahasiswa") {
    if ($id_mahasiswa === null || $id_mahasiswa === '') { header("Location: {$kembali}&error=" . urlencode("Data mahasiswa wajib dipilih.")); exit; }
    $id_mahasiswa = (int) $id_mahasiswa; $id_pengajar = null;
} else {
    if ($id_pengajar === null || $id_pengajar === '') { header("Location: {$kembali}&error=" . urlencode("Data pengajar wajib dipilih.")); exit; }
    $id_pengajar = (int) $id_pengajar; $id_mahasiswa = null;
}

$password_baru = $password_baru === '' ? null : $password_baru;
$stmt = mysqli_prepare($koneksi, "CALL usp_update_pengguna(?, ?, ?, ?, ?, ?)");
mysqli_stmt_bind_param($stmt, "iiisss", $id_pengguna, $id_mahasiswa, $id_pengajar, $username, $password_baru, $role);
if (mysqli_stmt_execute($stmt)) { mysqli_stmt_close($stmt); header("Location: index.php?status=berhasil_edit"); exit; }
$error = pesan_error_statement($stmt, "Data pengguna gagal diubah."); mysqli_stmt_close($stmt);
header("Location: {$kembali}&error=" . urlencode($error)); exit;
?>
