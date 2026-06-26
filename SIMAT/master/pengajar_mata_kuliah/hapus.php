<?php
require_once "../../config/koneksi.php";
require_once "../../includes/auth_dashboard.php";

cek_role_dashboard("Kepala Prodi");

$id = (int) ($_GET['id'] ?? 0);

if ($id <= 0) {
    header("Location: index.php?error=" . urlencode("ID tidak valid."));
    exit;
}

$stmt = mysqli_prepare($koneksi, "CALL usp_delete_pengajar_mata_kuliah_kelas(?)");
mysqli_stmt_bind_param($stmt, "i", $id);

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