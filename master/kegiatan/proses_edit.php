<?php
require_once "../../config/koneksi.php";
require_once "../../config/function.php";
require_once "../../includes/auth_dashboard.php";

cek_role_dashboard("PIC Kemahasiswaan");

if (!isset($_POST['update'])) {
    header("Location: index.php");
    exit;
}

$id_kegiatan = (int) ($_POST['id_kegiatan'] ?? 0);
$nama_kegiatan = trim($_POST['nama_kegiatan'] ?? '');
$penyelenggara = trim($_POST['penyelenggara'] ?? '');
$tanggal_kegiatan = trim($_POST['tanggal_kegiatan'] ?? '');
$tanggal_kegiatan = $tanggal_kegiatan === '' ? null : $tanggal_kegiatan;
$kembali = "edit.php?id=" . urlencode($id_kegiatan);

if ($id_kegiatan <= 0 || $nama_kegiatan === '') {
    header("Location: index.php?error=" . urlencode("Data kegiatan tidak lengkap."));
    exit;
}
if (!in_array($penyelenggara, ['ASTRAtech', 'BEM', 'MPM', 'HIMMA', 'UKM', 'Prodi'], true)) {
    header("Location: {$kembali}&error=" . urlencode("Penyelenggara tidak valid."));
    exit;
}

$duplikat = ambil_satu_procedure_prepared(
    $koneksi,
    "CALL usp_cek_kegiatan_aktif(?, ?, ?, ?)",
    "sssi",
    [$nama_kegiatan, $penyelenggara, $tanggal_kegiatan, $id_kegiatan]
);
if ((int) ($duplikat['jumlah'] ?? 0) > 0) {
    header("Location: {$kembali}&error=" . urlencode("Kegiatan aktif dengan seluruh input yang sama sudah tersedia."));
    exit;
}

$stmt = mysqli_prepare($koneksi, "CALL usp_update_kegiatan(?, ?, ?, ?)");
mysqli_stmt_bind_param($stmt, "isss", $id_kegiatan, $nama_kegiatan, $penyelenggara, $tanggal_kegiatan);
if (mysqli_stmt_execute($stmt)) {
    mysqli_stmt_close($stmt);
    header("Location: index.php?status=berhasil_edit");
    exit;
}
$error = pesan_error_statement($stmt, "Data kegiatan gagal diubah.");
mysqli_stmt_close($stmt);
header("Location: {$kembali}&error=" . urlencode($error));
exit;
?>
