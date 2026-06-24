<?php
require_once "../../config/koneksi.php";
require_once "../../includes/auth_dashboard.php";

$role = $_SESSION['role'] ?? '';

if (!in_array($role, ["Kepala Prodi", "PIC Aset Fasilitas"])) {
    header("Location: /SIMAT/index.php");
    exit;
}

if (!isset($_POST['simpan'])) {
    header("Location: index.php");
    exit;
}

$id_kelas = $_POST['id_kelas'] ?? '';
$nama_fasilitas = trim($_POST['nama_fasilitas'] ?? '');
$harga = $_POST['harga'] ?? '';
$jumlah_fasilitas = $_POST['jumlah_fasilitas'] ?? '';

if ($id_kelas == '' || $nama_fasilitas == '' || $harga == '' || $jumlah_fasilitas == '') {
    header("Location: tambah.php?error=" . urlencode("Semua data wajib diisi."));
    exit;
}

$stmt = mysqli_prepare($koneksi, "CALL usp_insert_fasilitas(?, ?, ?, ?)");
mysqli_stmt_bind_param($stmt, "isdi", $id_kelas, $nama_fasilitas, $harga, $jumlah_fasilitas);

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