<?php
require_once "../../config/koneksi.php";
require_once "../../includes/auth_dashboard.php";

cek_role_dashboard("PIC Aset Fasilitas");

if (!isset($_POST['update'])) {
    header("Location: index.php");
    exit;
}

$id_detail = (int) ($_POST['id_detail_fasilitas_pada_kelas'] ?? 0);
$id_kelas = (int) ($_POST['id_kelas'] ?? 0);
$id_fasilitas = (int) ($_POST['id_fasilitas'] ?? 0);
$jumlah_fasilitas = (int) ($_POST['jumlah_fasilitas'] ?? 0);

if ($id_detail <= 0 || $id_kelas <= 0 || $id_fasilitas <= 0 || $jumlah_fasilitas <= 0) {
    header("Location: index.php?error=" . urlencode("Data edit tidak lengkap."));
    exit;
}

$stmt = mysqli_prepare($koneksi, "CALL usp_update_detail_fasilitas_pada_kelas(?, ?, ?, ?)");
mysqli_stmt_bind_param($stmt, "iiii", $id_detail, $id_kelas, $id_fasilitas, $jumlah_fasilitas);

if (mysqli_stmt_execute($stmt)) {
    mysqli_stmt_close($stmt);

    header("Location: index.php?status=berhasil_edit");
    exit;
} else {
    $error = mysqli_error($koneksi);
    mysqli_stmt_close($stmt);

    header("Location: edit.php?id=" . urlencode($id_detail) . "&error=" . urlencode($error));
    exit;
}
?>