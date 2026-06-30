<?php
require_once "../../config/koneksi.php";
require_once "../../includes/auth_dashboard.php";

cek_role_dashboard("Mahasiswa");

if (!isset($_POST['verifikasi'])) {
    header("Location: index.php");
    exit;
}

$id_pengaduan = $_POST['id_pengaduan_kerusakan_fasilitas'] ?? '';
$status_pengaduan = $_POST['status_pengaduan'] ?? '';

if ($id_pengaduan == '' || $status_pengaduan == '') {
    header("Location: index.php?error=" . urlencode("Data verifikasi tidak lengkap."));
    exit;
}

if (!in_array($status_pengaduan, ["Diterima", "Ditolak"])) {
    header("Location: verifikasi.php?id=" . urlencode($id_pengaduan) . "&error=" . urlencode("Status pengaduan tidak valid."));
    exit;
}

$stmt = mysqli_prepare($koneksi, "CALL usp_update_status_pengaduan_kerusakan_fasilitas(?, ?, ?)");
mysqli_stmt_bind_param(
    $stmt,
    "iis",
    $id_pengaduan,
    $_SESSION['id_pengguna'],
    $status_pengaduan
);

if (mysqli_stmt_execute($stmt)) {
    mysqli_stmt_close($stmt);

    header("Location: index.php?status=berhasil_verifikasi");
    exit;
} else {
    $error = mysqli_error($koneksi);
    mysqli_stmt_close($stmt);

    header("Location: verifikasi.php?id=" . urlencode($id_pengaduan) . "&error=" . urlencode($error));
    exit;
}
?>