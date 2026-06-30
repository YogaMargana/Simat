<?php
require_once "../../config/koneksi.php";
require_once "../../includes/auth_dashboard.php";

cek_role_dashboard("PIC Aset Fasilitas");

if (!isset($_POST['update'])) {
    header("Location: index.php");
    exit;
}

$id_fasilitas = (int) ($_POST['id_fasilitas'] ?? 0);
$nama_fasilitas = trim($_POST['nama_fasilitas'] ?? '');
$harga = (float) ($_POST['harga'] ?? 0);

if ($id_fasilitas <= 0 || $nama_fasilitas == '') {
    header("Location: index.php?error=" . urlencode("Data edit tidak lengkap."));
    exit;
}

if ($harga < 0) {
    header("Location: edit.php?id=" . urlencode($id_fasilitas) . "&error=" . urlencode("Harga fasilitas tidak boleh kurang dari 0."));
    exit;
}

$stmt = mysqli_prepare($koneksi, "CALL usp_update_fasilitas(?, ?, ?)");
mysqli_stmt_bind_param($stmt, "isd", $id_fasilitas, $nama_fasilitas, $harga);

if (mysqli_stmt_execute($stmt)) {
    mysqli_stmt_close($stmt);

    header("Location: index.php?status=berhasil_edit");
    exit;
} else {
    $error = mysqli_error($koneksi);
    mysqli_stmt_close($stmt);

    header("Location: edit.php?id=" . urlencode($id_fasilitas) . "&error=" . urlencode($error));
    exit;
}
?>