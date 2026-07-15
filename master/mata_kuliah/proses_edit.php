<?php
require_once "../../config/koneksi.php";
require_once "../../includes/auth_dashboard.php";

cek_role_dashboard("Kepala Prodi");

if ($_SERVER['REQUEST_METHOD'] !== 'POST' || !isset($_POST['update'])) {
    header("Location: index.php");
    exit;
}

$id_matakuliah = (int) ($_POST['id_matakuliah'] ?? 0);
$nama_mata_kuliah = strtoupper(trim($_POST['nama_mata_kuliah'] ?? ''));
$kode_mata_kuliah = strtoupper(trim($_POST['kode_mata_kuliah'] ?? ''));
$sks = (int) ($_POST['sks'] ?? 0);
$semester = (int) ($_POST['semester'] ?? 0);
$status_mata_kuliah = trim($_POST['status_mata_kuliah'] ?? '');
$id_kelas = array_values(array_unique(array_filter(array_map('intval', (array) ($_POST['id_kelas'] ?? [])), static fn($id) => $id > 0)));

if ($id_matakuliah <= 0 || $nama_mata_kuliah === '' || $kode_mata_kuliah === '' || $sks <= 0 || $semester <= 0 || !in_array($status_mata_kuliah, ['Aktif', 'Tidak Aktif'], true) || count($id_kelas) < 1) {
    header("Location: index.php?error=" . urlencode("Data edit tidak lengkap, tidak valid, atau belum memilih kelas aktif."));
    exit;
}

$id_kelas_csv = implode(',', $id_kelas);
$stmt = mysqli_prepare($koneksi, "CALL usp_update_mata_kuliah(?, ?, ?, ?, ?, ?, ?)");
if (!$stmt) {
    error_log('Prepare ubah mata kuliah gagal: ' . mysqli_error($koneksi));
    header("Location: edit.php?id={$id_matakuliah}&error=" . urlencode("Gagal menyiapkan perubahan data."));
    exit;
}

mysqli_stmt_bind_param($stmt, 'issiiss', $id_matakuliah, $nama_mata_kuliah, $kode_mata_kuliah, $sks, $semester, $status_mata_kuliah, $id_kelas_csv);
if (!mysqli_stmt_execute($stmt)) {
    error_log('Ubah mata kuliah gagal: ' . mysqli_stmt_error($stmt));
    mysqli_stmt_close($stmt);
    header("Location: edit.php?id={$id_matakuliah}&error=" . urlencode("Mata kuliah gagal diubah. Periksa kembali datanya."));
    exit;
}

mysqli_stmt_close($stmt);
header("Location: index.php?status=berhasil_edit");
exit;
