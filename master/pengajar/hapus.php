<?php
require_once "../../config/koneksi.php";
require_once "../../includes/auth_dashboard.php";

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    header("Location: index.php");
    exit;
}


// /** @var mysqli $koneksi */

cek_role_dashboard("Kepala Prodi");

$id_pengajar = $_GET['id'] ?? '';

if ($id_pengajar == '') {
    header("Location: index.php?error=" . urlencode("ID pengajar tidak ditemukan."));
    exit;
}

$stmt = mysqli_prepare($koneksi, "CALL usp_soft_delete_pengajar(?)");
mysqli_stmt_bind_param($stmt, "i", $id_pengajar);

if (mysqli_stmt_execute($stmt)) {
    mysqli_stmt_close($stmt);
    header("Location: index.php?status=berhasil_hapus");
    exit;
} else {
    $error = pesan_error_koneksi($koneksi, 'Proses database gagal dijalankan.');
    mysqli_stmt_close($stmt);

    header("Location: index.php?error=" . urlencode($error));
    exit;
}
?>
