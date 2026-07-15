<?php
require_once "../../config/koneksi.php";
require_once "../../config/function.php";
require_once "../../includes/auth_dashboard.php";

cek_role_dashboard("PIC Kemahasiswaan");

if (!isset($_POST['simpan'])) {
    header("Location: index.php");
    exit;
}

$nama_kegiatan = trim($_POST['nama_kegiatan'] ?? '');
$penyelenggara = trim($_POST['penyelenggara'] ?? '');
$tanggal_kegiatan = trim($_POST['tanggal_kegiatan'] ?? '');
$tanggal_kegiatan = $tanggal_kegiatan === '' ? null : $tanggal_kegiatan;

if ($nama_kegiatan === '') {
    header("Location: tambah.php?error=" . urlencode("Nama kegiatan wajib diisi."));
    exit;
}
if (!in_array($penyelenggara, ['ASTRAtech', 'BEM', 'MPM', 'HIMMA', 'UKM', 'Prodi'], true)) {
    header("Location: tambah.php?error=" . urlencode("Penyelenggara tidak valid."));
    exit;
}

$duplikat = ambil_satu_procedure_prepared(
    $koneksi,
    "CALL usp_cek_kegiatan_aktif(?, ?, ?, NULL)",
    "sss",
    [$nama_kegiatan, $penyelenggara, $tanggal_kegiatan]
);
if ((int) ($duplikat['jumlah'] ?? 0) > 0) {
    header("Location: tambah.php?error=" . urlencode("Kegiatan aktif dengan seluruh input yang sama sudah tersedia."));
    exit;
}

$stmt = mysqli_prepare($koneksi, "CALL usp_insert_kegiatan(?, ?, ?)");
mysqli_stmt_bind_param($stmt, "sss", $nama_kegiatan, $penyelenggara, $tanggal_kegiatan);
if (mysqli_stmt_execute($stmt)) {
    mysqli_stmt_close($stmt);
    header("Location: index.php?status=berhasil_tambah");
    exit;
}
$error = pesan_error_statement($stmt, "Data kegiatan gagal ditambahkan.");
mysqli_stmt_close($stmt);
header("Location: tambah.php?error=" . urlencode($error));
exit;
?>
