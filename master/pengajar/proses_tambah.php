<?php
require_once "../../config/koneksi.php";
require_once "../../includes/auth_dashboard.php";

// /** @var mysqli $koneksi */

cek_role_dashboard("Kepala Prodi");

if (!isset($_POST['simpan'])) {
    header("Location: index.php");
    exit;
}

$nip = trim($_POST['nip'] ?? '');
$nama_pengajar = trim($_POST['nama_pengajar'] ?? '');
$email = trim($_POST['email'] ?? '');
$no_hp = trim($_POST['no_hp'] ?? '');

if ($nip == '' || $nama_pengajar == '') {
    header("Location: tambah.php?error=" . urlencode("NIP dan nama pengajar wajib diisi."));
    exit;
}

$stmt = mysqli_prepare($koneksi, "CALL usp_insert_pengajar(?, ?, ?, ?)");
mysqli_stmt_bind_param($stmt, "ssss", $nip, $nama_pengajar, $email, $no_hp);

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