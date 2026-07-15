<?php
require_once "../../config/koneksi.php";
require_once "../../config/function.php";
require_once "../../includes/auth_dashboard.php";

cek_role_dashboard("Kepala Prodi");

if (!isset($_POST['update'])) {
    header("Location: index.php");
    exit;
}

$id_periode_akademik = (int) ($_POST['id_periode_akademik'] ?? 0);
$tahun_akademik = trim($_POST['tahun_akademik'] ?? '');
$semester = trim($_POST['semester'] ?? '');
$tanggal_mulai = trim($_POST['tanggal_mulai'] ?? '');
$tanggal_selesai = trim($_POST['tanggal_selesai'] ?? '');
$kembali = "edit.php?id=" . urlencode($id_periode_akademik);

if ($id_periode_akademik <= 0 || $tahun_akademik === '' || $semester === '' || $tanggal_mulai === '' || $tanggal_selesai === '') {
    header("Location: index.php?error=" . urlencode("Data periode akademik belum lengkap."));
    exit;
}

if (!in_array($semester, ['Ganjil', 'Genap'], true)) {
    header("Location: {$kembali}&error=" . urlencode("Semester tidak valid."));
    exit;
}

$pesan_error = '';
if (!periode_akademik_valid($tahun_akademik, $tanggal_mulai, $tanggal_selesai, $pesan_error)) {
    header("Location: {$kembali}&error=" . urlencode($pesan_error));
    exit;
}

$duplikat = ambil_satu_procedure_prepared(
    $koneksi,
    "CALL usp_cek_periode_akademik(?, ?, ?)",
    "ssi",
    [$tahun_akademik, $semester, $id_periode_akademik]
);

if ((int) ($duplikat['jumlah'] ?? 0) > 0) {
    header("Location: {$kembali}&error=" . urlencode("Tahun akademik dan semester tersebut sudah digunakan oleh data lain."));
    exit;
}

$stmt = mysqli_prepare($koneksi, "CALL usp_update_periode_akademik(?, ?, ?, ?, ?)");
mysqli_stmt_bind_param($stmt, "issss", $id_periode_akademik, $tahun_akademik, $semester, $tanggal_mulai, $tanggal_selesai);

if (mysqli_stmt_execute($stmt)) {
    mysqli_stmt_close($stmt);
    header("Location: index.php?status=berhasil_edit");
    exit;
}

$error = pesan_error_statement($stmt, "Periode akademik gagal diubah.");
mysqli_stmt_close($stmt);
header("Location: {$kembali}&error=" . urlencode($error));
exit;
?>
