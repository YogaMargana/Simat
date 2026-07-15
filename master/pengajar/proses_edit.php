<?php
require_once "../../config/koneksi.php";
require_once "../../config/function.php";
require_once "../../includes/auth_dashboard.php";

cek_role_dashboard("Kepala Prodi");

if (!isset($_POST['update'])) {
    header("Location: index.php");
    exit;
}

$id_pengajar = (int) ($_POST['id_pengajar'] ?? 0);
$nip = trim($_POST['nip'] ?? '');
$nama_pengajar = trim($_POST['nama_pengajar'] ?? '');
$email = nilai_nullable($_POST['email'] ?? null);
$no_hp = nilai_nullable($_POST['no_hp'] ?? null);
$kembali = "edit.php?id=" . urlencode($id_pengajar);

if ($id_pengajar <= 0 || $nip === '' || $nama_pengajar === '') {
    header("Location: index.php?error=" . urlencode("Data edit tidak lengkap."));
    exit;
}
if ($email !== null && filter_var($email, FILTER_VALIDATE_EMAIL) === false) {
    header("Location: {$kembali}&error=" . urlencode("Format email tidak valid."));
    exit;
}
if (!nomor_hp_valid($no_hp)) {
    header("Location: {$kembali}&error=" . urlencode("No HP harus terdiri dari 10 sampai 13 digit angka."));
    exit;
}

$duplikat = ambil_satu_procedure_prepared($koneksi, "CALL usp_cek_nip_pengajar(?, ?)", "si", [$nip, $id_pengajar]);
if ((int) ($duplikat['jumlah'] ?? 0) > 0) {
    header("Location: {$kembali}&error=" . urlencode("NIP sudah digunakan oleh pengajar lain."));
    exit;
}

$stmt = mysqli_prepare($koneksi, "CALL usp_update_pengajar(?, ?, ?, ?, ?)");
mysqli_stmt_bind_param($stmt, "issss", $id_pengajar, $nip, $nama_pengajar, $email, $no_hp);
if (mysqli_stmt_execute($stmt)) {
    mysqli_stmt_close($stmt);
    header("Location: index.php?status=berhasil_edit");
    exit;
}
$error = pesan_error_statement($stmt, "Data pengajar gagal diubah.");
mysqli_stmt_close($stmt);
header("Location: {$kembali}&error=" . urlencode($error));
exit;
?>
