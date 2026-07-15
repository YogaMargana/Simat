<?php
require_once "../../config/koneksi.php";
require_once "../../config/function.php";
require_once "../../includes/auth_dashboard.php";

cek_role_dashboard("PIC Aset Fasilitas");

if (!isset($_POST['update'])) {
    header("Location: index.php");
    exit;
}

$id_fasilitas = (int) ($_POST['id_fasilitas'] ?? 0);
$nama_fasilitas = trim($_POST['nama_fasilitas'] ?? '');
$harga = (float) ($_POST['harga'] ?? 0);
$id_kelas = array_values(array_unique(array_filter(array_map('intval', $_POST['id_kelas'] ?? []), fn($id) => $id > 0)));
$kembali = "edit.php?id=" . urlencode($id_fasilitas);

if ($id_fasilitas <= 0 || $nama_fasilitas === '' || $harga < 0) {
    header("Location: index.php?error=" . urlencode("Data fasilitas tidak valid."));
    exit;
}
if (count($id_kelas) < 1) {
    header("Location: {$kembali}&error=" . urlencode("Minimal satu kelas wajib dipilih."));
    exit;
}

$duplikat = ambil_satu_procedure_prepared($koneksi, "CALL usp_cek_nama_fasilitas_aktif(?, ?)", "si", [$nama_fasilitas, $id_fasilitas]);
if ((int) ($duplikat['jumlah'] ?? 0) > 0) {
    header("Location: {$kembali}&error=" . urlencode("Nama fasilitas sudah digunakan oleh fasilitas aktif lain."));
    exit;
}

$kelas_csv = implode(',', $id_kelas);
$stmt = mysqli_prepare($koneksi, "CALL usp_update_fasilitas(?, ?, ?, ?)");
mysqli_stmt_bind_param($stmt, "isds", $id_fasilitas, $nama_fasilitas, $harga, $kelas_csv);
if (mysqli_stmt_execute($stmt)) {
    mysqli_stmt_close($stmt);
    header("Location: index.php?status=berhasil_edit");
    exit;
}
$error = pesan_error_statement($stmt, "Data fasilitas gagal diubah.");
mysqli_stmt_close($stmt);
header("Location: {$kembali}&error=" . urlencode($error));
exit;
?>
