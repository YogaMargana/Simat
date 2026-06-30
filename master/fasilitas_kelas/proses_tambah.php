<?php
require_once "../../config/koneksi.php";
require_once "../../includes/auth_dashboard.php";

cek_role_dashboard("PIC Aset Fasilitas");

if (!isset($_POST['simpan'])) {
    header("Location: index.php");
    exit;
}

$id_kelas = (int) ($_POST['id_kelas'] ?? 0);
$id_fasilitas = (int) ($_POST['id_fasilitas'] ?? 0);
$jumlah_fasilitas = (int) ($_POST['jumlah_fasilitas'] ?? 0);

if ($id_kelas <= 0 || $id_fasilitas <= 0 || $jumlah_fasilitas <= 0) {
    header("Location: tambah.php?error=" . urlencode("Semua data wajib diisi dengan benar."));
    exit;
}

$stmt = mysqli_prepare($koneksi, "CALL usp_insert_detail_fasilitas_pada_kelas(?, ?, ?)");
mysqli_stmt_bind_param($stmt, "iii", $id_kelas, $id_fasilitas, $jumlah_fasilitas);

if (mysqli_stmt_execute($stmt)) {
    mysqli_stmt_close($stmt);

    header("Location: index.php?status=berhasil_tambah");
    exit;
} else {
    $error = mysqli_error($koneksi);
    mysqli_stmt_close($stmt);

    header("Location: tambah.php?error=" . urlencode($error));
    exit;
}
?>