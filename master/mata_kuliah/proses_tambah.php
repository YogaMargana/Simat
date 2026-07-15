<?php
require_once "../../config/koneksi.php";
require_once "../../includes/auth_dashboard.php";

cek_role_dashboard("Kepala Prodi");

if ($_SERVER['REQUEST_METHOD'] !== 'POST' || !isset($_POST['simpan'])) {
    header("Location: index.php");
    exit;
}

$nama_mata_kuliah = strtoupper(trim($_POST['nama_mata_kuliah'] ?? ''));
$kode_mata_kuliah = strtoupper(trim($_POST['kode_mata_kuliah'] ?? ''));
$sks = (int) ($_POST['sks'] ?? 0);
$semester = (int) ($_POST['semester'] ?? 0);
$id_kelas = array_values(array_unique(array_filter(array_map('intval', (array) ($_POST['id_kelas'] ?? [])), static fn($id) => $id > 0)));

if ($nama_mata_kuliah === '' || $kode_mata_kuliah === '' || $sks <= 0 || $semester <= 0 || count($id_kelas) < 1) {
    header("Location: tambah.php?error=" . urlencode("Semua field wajib diisi dan minimal satu kelas aktif harus dipilih."));
    exit;
}

$id_kelas_csv = implode(',', $id_kelas);
$stmt = mysqli_prepare($koneksi, "CALL usp_insert_mata_kuliah(?, ?, ?, ?, ?)");
if (!$stmt) {
    error_log('Prepare tambah mata kuliah gagal: ' . mysqli_error($koneksi));
    header("Location: tambah.php?error=" . urlencode("Gagal menyiapkan penyimpanan data."));
    exit;
}

mysqli_stmt_bind_param($stmt, 'ssiis', $nama_mata_kuliah, $kode_mata_kuliah, $sks, $semester, $id_kelas_csv);
if (!mysqli_stmt_execute($stmt)) {
    error_log('Tambah mata kuliah gagal: ' . mysqli_stmt_error($stmt));
    mysqli_stmt_close($stmt);
    header("Location: tambah.php?error=" . urlencode("Mata kuliah gagal disimpan. Periksa kode mata kuliah."));
    exit;
}

mysqli_stmt_close($stmt);
header("Location: index.php?status=berhasil_tambah");
exit;
