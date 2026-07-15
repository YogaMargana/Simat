<?php
require_once "../../config/koneksi.php";
require_once "../../includes/auth_dashboard.php";

cek_role_dashboard("Mahasiswa");

if ($_SERVER['REQUEST_METHOD'] !== 'POST' || !isset($_POST['simpan'])) {
    header("Location: index.php");
    exit;
}

$id_fasilitas = (int) ($_POST['id_fasilitas'] ?? 0);
$deskripsi_kerusakan = trim($_POST['deskripsi_kerusakan'] ?? '');
$bukti_kerusakan_url = trim($_POST['bukti_kerusakan_url'] ?? '');
$pelaku_kerusakan = trim($_POST['pelaku_kerusakan'] ?? '');

if ($id_fasilitas <= 0 || $deskripsi_kerusakan === '') {
    header("Location: tambah.php?error=" . urlencode("Fasilitas dan deskripsi kerusakan wajib diisi."));
    exit;
}

if ($bukti_kerusakan_url === '') {
    $bukti_kerusakan_url = null;
} elseif (!url_http_valid($bukti_kerusakan_url)) {
    header("Location: tambah.php?error=" . urlencode("Tautan bukti harus berupa URL HTTP atau HTTPS yang valid."));
    exit;
}

if ($pelaku_kerusakan == '') {
    $pelaku_kerusakan = "Tidak diketahui";
}

$stmt = mysqli_prepare($koneksi, "CALL usp_insert_pengaduan_kerusakan_fasilitas(?, ?, ?, ?, ?)");
if (!$stmt) {
    header("Location: tambah.php?error=" . urlencode("Gagal menyiapkan penyimpanan pengaduan."));
    exit;
}
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
    $error = pesan_error_statement($stmt, 'Pengaduan gagal disimpan.');
    error_log('Tambah pengaduan gagal: ' . $error);
    mysqli_stmt_close($stmt);

    header("Location: tambah.php?error=" . urlencode("Pengaduan gagal disimpan. Periksa kembali data."));
    exit;
}
?>