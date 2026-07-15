<?php
require_once "../../config/koneksi.php";
require_once "../../config/function.php";
require_once "../../includes/auth_dashboard.php";

cek_role_dashboard("PIC Aset Fasilitas");

if (!isset($_POST['simpan'])) {
    header("Location: index.php");
    exit;
}

$nama_fasilitas = trim($_POST['nama_fasilitas'] ?? '');
$harga = (float) ($_POST['harga'] ?? 0);
$id_kelas = array_values(array_unique(array_filter(array_map('intval', $_POST['id_kelas'] ?? []), fn($id) => $id > 0)));

if ($nama_fasilitas === '' || $harga < 0) {
    header("Location: tambah.php?error=" . urlencode("Nama fasilitas dan harga wajib valid."));
    exit;
}
if (count($id_kelas) < 1) {
    header("Location: tambah.php?error=" . urlencode("Minimal satu kelas wajib dipilih."));
    exit;
}

$duplikat = ambil_satu_procedure_prepared($koneksi, "CALL usp_cek_nama_fasilitas_aktif(?, NULL)", "s", [$nama_fasilitas]);
if ((int) ($duplikat['jumlah'] ?? 0) > 0) {
    header("Location: tambah.php?error=" . urlencode("Nama fasilitas sudah digunakan oleh fasilitas yang masih aktif."));
    exit;
}

$kelas_csv = implode(',', $id_kelas);
$stmt = mysqli_prepare($koneksi, "CALL usp_insert_fasilitas(?, ?, ?)");
mysqli_stmt_bind_param($stmt, "sds", $nama_fasilitas, $harga, $kelas_csv);
if (mysqli_stmt_execute($stmt)) {
    mysqli_stmt_close($stmt);
    header("Location: index.php?status=berhasil_tambah");
    exit;
}
$error = pesan_error_statement($stmt, "Data fasilitas gagal ditambahkan.");
mysqli_stmt_close($stmt);
header("Location: tambah.php?error=" . urlencode($error));
exit;
?>