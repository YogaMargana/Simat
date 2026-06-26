<?php
require_once "../../config/koneksi.php";
require_once "../../includes/auth_dashboard.php";

$role = $_SESSION['role'] ?? '';

if ($role != "Mahasiswa") {
    header("Location: /SIMAT/index.php");
    exit;
}

if (!isset($_POST['simpan'])) {
    header("Location: index.php");
    exit;
}

$id_fasilitas = $_POST['id_fasilitas'] ?? '';
$deskripsi_kerusakan = trim($_POST['deskripsi_kerusakan'] ?? '');
$bukti_kerusakan_url = trim($_POST['bukti_kerusakan_url'] ?? '');
$pelaku_kerusakan = trim($_POST['pelaku_kerusakan'] ?? '');

if ($id_fasilitas == '' || $deskripsi_kerusakan == '') {
    header("Location: tambah.php?error=" . urlencode("Fasilitas dan deskripsi kerusakan wajib diisi."));
    exit;
}

if ($bukti_kerusakan_url == '') {
    $bukti_kerusakan_url = null;
}

if ($pelaku_kerusakan == '') {
    $pelaku_kerusakan = "Tidak diketahui";
}

$stmt = mysqli_prepare($koneksi, "CALL usp_insert_pengaduan_kerusakan_fasilitas(?, ?, ?, ?, ?)");
mysqli_stmt_bind_param(
    $stmt,
    "iisss",
    $id_fasilitas,
    $_SESSION['id_pengguna'],
    $deskripsi_kerusakan,
    $bukti_kerusakan_url,
    $pelaku_kerusakan
);

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