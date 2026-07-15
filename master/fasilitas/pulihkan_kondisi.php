<?php
require_once "../../config/koneksi.php";
require_once "../../includes/auth_dashboard.php";

cek_role_dashboard("PIC Aset Fasilitas");

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    header("Location: index.php?error=" . urlencode("Metode permintaan tidak valid."));
    exit;
}

$id_fasilitas = (int) ($_POST['id_fasilitas'] ?? 0);
$id_detail = (int) ($_POST['id_detail_fasilitas_pada_kelas'] ?? 0);
$kembali = "edit.php?id=" . urlencode($id_fasilitas);

if ($id_fasilitas <= 0 || $id_detail <= 0) {
    header("Location: index.php?error=" . urlencode("Data fasilitas kelas tidak valid."));
    exit;
}

$stmt = mysqli_prepare($koneksi, "CALL usp_pulihkan_fasilitas_kelas(?, ?)");
mysqli_stmt_bind_param($stmt, "ii", $id_detail, $id_fasilitas);
if (mysqli_stmt_execute($stmt)) {
    mysqli_stmt_close($stmt);
    header("Location: {$kembali}&status=berhasil_pulihkan");
    exit;
}
$error = pesan_error_statement($stmt, "Kondisi fasilitas kelas gagal dipulihkan.");
mysqli_stmt_close($stmt);
header("Location: {$kembali}&error=" . urlencode($error));
exit;
?>
