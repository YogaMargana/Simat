<?php
require_once "../../config/koneksi.php";
require_once "../../includes/auth_dashboard.php";

// /** @var mysqli $koneksi */

cek_role_dashboard("Kepala Prodi");

if (!isset($_POST['update'])) {
    header("Location: index.php");
    exit;
}

$id_pengajar = $_POST['id_pengajar'] ?? '';
$nip = trim($_POST['nip'] ?? '');
$nama_pengajar = trim($_POST['nama_pengajar'] ?? '');
$email = trim($_POST['email'] ?? '');
$no_hp = trim($_POST['no_hp'] ?? '');

if ($id_pengajar == '' || $nip == '' || $nama_pengajar == '') {
    header("Location: index.php?error=" . urlencode("Data edit tidak lengkap."));
    exit;
}

$stmt = mysqli_prepare($koneksi, "CALL usp_update_pengajar(?, ?, ?, ?, ?)");
mysqli_stmt_bind_param($stmt, "issss", $id_pengajar, $nip, $nama_pengajar, $email, $no_hp);

if (mysqli_stmt_execute($stmt)) {
    mysqli_stmt_close($stmt);
    header("Location: index.php?status=berhasil_edit");
    exit;
} else {
    $error = mysqli_error($koneksi);
    mysqli_stmt_close($stmt);

    header("Location: edit.php?id=" . urlencode($id_pengajar) . "&error=" . urlencode($error));
    exit;
}
?>