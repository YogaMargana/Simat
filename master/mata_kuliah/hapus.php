<?php
require_once "../../config/koneksi.php";
require_once "../../includes/auth_dashboard.php";

// /** @var mysqli $koneksi */

cek_role_dashboard("Kepala Prodi");

$id_matakuliah = $_GET['id'] ?? '';

if ($id_matakuliah == '') {
    header("Location: index.php?error=" . urlencode("ID mata kuliah tidak ditemukan."));
    exit;
}

$stmt = mysqli_prepare($koneksi,"UPDATE mata_kuliah SET status_mata_kuliah = 'Tidak Aktif' WHERE id_matakuliah = ?");
mysqli_stmt_bind_param($stmt, "i", $id_matakuliah);

if (mysqli_stmt_execute($stmt)) {
    mysqli_stmt_close($stmt);

    header("Location: index.php?status=berhasil_hapus");
    exit;
} else {
    $error = mysqli_error($koneksi);
    mysqli_stmt_close($stmt);

    header("Location: index.php?error=" . urlencode($error));
    exit;
}
?>