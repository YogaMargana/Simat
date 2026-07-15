<?php
require_once "../../config/koneksi.php";
require_once "../../config/function.php";
require_once "../../includes/auth_dashboard.php";

cek_role_dashboard("Kepala Prodi");

if (!isset($_POST['simpan'])) {
    header("Location: index.php");
    exit;
}

$tahun_akademik = trim($_POST['tahun_akademik'] ?? '');
$semester = trim($_POST['semester'] ?? '');
$tanggal_mulai = trim($_POST['tanggal_mulai'] ?? '');
$tanggal_selesai = trim($_POST['tanggal_selesai'] ?? '');

if ($tahun_akademik === '' || $semester === '' || $tanggal_mulai === '' || $tanggal_selesai === '') {
    header("Location: tambah.php?error=" . urlencode("Semua field wajib diisi."));
    exit;
}

if (!in_array($semester, ['Ganjil', 'Genap'], true)) {
    header("Location: tambah.php?error=" . urlencode("Semester tidak valid."));
    exit;
}

$pesan_error = '';
if (!periode_akademik_valid($tahun_akademik, $tanggal_mulai, $tanggal_selesai, $pesan_error)) {
    header("Location: tambah.php?error=" . urlencode($pesan_error));
    exit;
}

$duplikat = ambil_satu_procedure_prepared(
    $koneksi,
    "CALL usp_cek_periode_akademik(?, ?, NULL)",
    "ss",
    [$tahun_akademik, $semester]
);

if ((int) ($duplikat['jumlah'] ?? 0) > 0) {
    header("Location: tambah.php?error=" . urlencode("Tahun akademik dan semester tersebut sudah tersedia."));
    exit;
}

$stmt = mysqli_prepare($koneksi, "CALL usp_insert_periode_akademik(?, ?, ?, ?)");
mysqli_stmt_bind_param($stmt, "ssss", $tahun_akademik, $semester, $tanggal_mulai, $tanggal_selesai);

if (mysqli_stmt_execute($stmt)) {
    mysqli_stmt_close($stmt);
    header("Location: index.php?status=berhasil_tambah");
    exit;
}

$error = pesan_error_statement($stmt, "Periode akademik gagal ditambahkan.");
mysqli_stmt_close($stmt);
header("Location: tambah.php?error=" . urlencode($error));
exit;
?>
