<?php
require_once "../../config/koneksi.php";
require_once "../../config/function.php";
require_once "../../includes/auth_dashboard.php";

cek_role_dashboard("Kepala Prodi");

if (!isset($_POST['simpan'])) {
    header("Location: index.php");
    exit;
}

$nip = trim($_POST['nip'] ?? '');
$nama_pengajar = trim($_POST['nama_pengajar'] ?? '');
$email = nilai_nullable($_POST['email'] ?? null);
$no_hp = nilai_nullable($_POST['no_hp'] ?? null);

if ($nip === '' || $nama_pengajar === '') {
    header("Location: tambah.php?error=" . urlencode("NIP dan nama pengajar wajib diisi."));
    exit;
}
if ($email !== null && filter_var($email, FILTER_VALIDATE_EMAIL) === false) {
    header("Location: tambah.php?error=" . urlencode("Format email tidak valid."));
    exit;
}
if (!nomor_hp_valid($no_hp)) {
    header("Location: tambah.php?error=" . urlencode("No HP harus terdiri dari 10 sampai 13 digit angka."));
    exit;
}

$duplikat = ambil_satu_procedure_prepared($koneksi, "CALL usp_cek_nip_pengajar(?, NULL)", "s", [$nip]);
if ((int) ($duplikat['jumlah'] ?? 0) > 0) {
    header("Location: tambah.php?error=" . urlencode("NIP sudah digunakan."));
    exit;
}

$stmt = mysqli_prepare($koneksi, "CALL usp_insert_pengajar(?, ?, ?, ?)");
mysqli_stmt_bind_param($stmt, "ssss", $nip, $nama_pengajar, $email, $no_hp);
if (mysqli_stmt_execute($stmt)) {
    mysqli_stmt_close($stmt);
    header("Location: index.php?status=berhasil_tambah");
    exit;
}
$error = pesan_error_statement($stmt, "Data pengajar gagal ditambahkan.");
mysqli_stmt_close($stmt);
header("Location: tambah.php?error=" . urlencode($error));
exit;
?>
