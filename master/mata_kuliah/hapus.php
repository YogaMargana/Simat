<?php
require_once "../../config/koneksi.php";
require_once "../../includes/auth_dashboard.php";

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    header("Location: index.php");
    exit;
}


cek_role_dashboard("Kepala Prodi");

$id_matakuliah = (int) ($_POST['id'] ?? $_GET['id'] ?? 0);
if ($id_matakuliah <= 0) {
    header("Location: index.php?error=" . urlencode("ID mata kuliah tidak ditemukan."));
    exit;
}

$stmt = mysqli_prepare($koneksi, "CALL usp_soft_delete_mata_kuliah(?)");
if (!$stmt) {
    error_log('Prepare hapus mata kuliah gagal: ' . mysqli_error($koneksi));
    header("Location: index.php?error=" . urlencode("Gagal menyiapkan penghapusan data."));
    exit;
}

mysqli_stmt_bind_param($stmt, 'i', $id_matakuliah);
if (!mysqli_stmt_execute($stmt)) {
    error_log('Hapus mata kuliah gagal: ' . mysqli_stmt_error($stmt));
    mysqli_stmt_close($stmt);
    header("Location: index.php?error=" . urlencode("Mata kuliah gagal dinonaktifkan."));
    exit;
}

mysqli_stmt_close($stmt);
header("Location: index.php?status=berhasil_hapus");
exit;
