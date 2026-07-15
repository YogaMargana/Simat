<?php
require_once "../../config/koneksi.php";
require_once "../../includes/auth_dashboard.php";

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    header("Location: index.php");
    exit;
}


cek_role_dashboard("PIC Kemahasiswaan");

$id_kegiatan = (int) ($_GET['id'] ?? 0);

if ($id_kegiatan <= 0) {
    header("Location: index.php?error=" . urlencode("ID kegiatan tidak valid."));
    exit;
}

$stmt = mysqli_prepare($koneksi, "CALL usp_soft_delete_kegiatan(?)");
mysqli_stmt_bind_param($stmt, "i", $id_kegiatan);

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
