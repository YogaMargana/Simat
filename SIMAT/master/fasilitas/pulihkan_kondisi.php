<?php
require_once "../../config/koneksi.php";
require_once "../../includes/auth_dashboard.php";

$role = $_SESSION['role'] ?? '';

if (!in_array($role, ["Kepala Prodi", "PIC Aset Fasilitas"])) {
    header("Location: /SIMAT/index.php");
    exit;
}

$id_detail_fasilitas_pada_kelas = $_GET['id'] ?? '';

if ($id_detail_fasilitas_pada_kelas == '') {
    header("Location: index.php?error=" . urlencode("ID detail fasilitas tidak ditemukan."));
    exit;
}

$stmt = mysqli_prepare($koneksi, "
    UPDATE detail_fasilitas_pada_kelas
    SET status_detail_fasilitas_pada_kelas = 'Aktif'
    WHERE id_detail_fasilitas_pada_kelas = ?
    AND status_detail_fasilitas_pada_kelas = 'Rusak'
");

mysqli_stmt_bind_param($stmt, "i", $id_detail_fasilitas_pada_kelas);
mysqli_stmt_execute($stmt);

$jumlah_data_berubah = mysqli_stmt_affected_rows($stmt);

mysqli_stmt_close($stmt);

if ($jumlah_data_berubah > 0) {
    header("Location: index.php?status=berhasil_pulihkan");
    exit;
} else {
    header("Location: index.php?error=" . urlencode("Fasilitas tidak dapat dipulihkan karena statusnya bukan Rusak atau data tidak ditemukan."));
    exit;
}
?>