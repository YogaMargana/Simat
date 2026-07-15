<?php
require_once "../../config/koneksi.php";
require_once "../../includes/auth_dashboard.php";

cek_role_dashboard("PIC Aset Fasilitas");

if ($_SERVER['REQUEST_METHOD'] !== 'POST' || !isset($_POST['verifikasi'])) {
    header("Location: index.php");
    exit;
}

$id_pengaduan = (int) ($_POST['id_pengaduan_kerusakan_fasilitas'] ?? 0);
$status_pengaduan = trim($_POST['status_pengaduan'] ?? '');
$alsan_penolakan = trim($_POST['alsan_penolakan'] ?? '');
$kembali = "verifikasi.php?id=" . urlencode($id_pengaduan);

if ($id_pengaduan <= 0 || !in_array($status_pengaduan, ['Diterima', 'Ditolak'], true)) {
    header("Location: index.php?error=" . urlencode("Data verifikasi tidak lengkap atau tidak valid."));
    exit;
}
if ($status_pengaduan === 'Ditolak' && $alsan_penolakan === '') {
    header("Location: {$kembali}&error=" . urlencode("Alasan penolakan wajib diisi ketika pengaduan ditolak."));
    exit;
}
if (mb_strlen($alsan_penolakan) > 255) {
    header("Location: {$kembali}&error=" . urlencode("Alasan penolakan maksimal 255 karakter."));
    exit;
}

$stmt = mysqli_prepare($koneksi, "CALL usp_update_status_pengaduan_kerusakan_fasilitas(?, ?, ?, ?)");
mysqli_stmt_bind_param($stmt, "iiss", $id_pengaduan, $_SESSION['id_pengguna'], $status_pengaduan, $alsan_penolakan);
if (mysqli_stmt_execute($stmt)) {
    mysqli_stmt_close($stmt);
    header("Location: index.php?status=berhasil_verifikasi");
    exit;
}
$error = pesan_error_statement($stmt, "Pengaduan gagal diverifikasi.");
mysqli_stmt_close($stmt);
header("Location: {$kembali}&error=" . urlencode($error));
exit;
?>
