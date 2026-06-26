<?php
require_once "../../config/koneksi.php";
require_once "../../includes/auth_dashboard.php";

// /** @var mysqli $koneksi */

cek_role_dashboard("Kepala Prodi");

if (!isset($_POST['simpan'])) {
    header("Location: index.php");
    exit;
}

$id_kelas = $_POST['id_kelas'] ?? '';
$id_periode_akademik = $_POST['id_periode_akademik'] ?? '';
$nim = trim($_POST['nim'] ?? '');
$nama_mahasiswa = trim($_POST['nama_mahasiswa'] ?? '');
$email = trim($_POST['email'] ?? '');
$no_hp = trim($_POST['no_hp'] ?? '');

if ($id_kelas == '' || $id_periode_akademik == '' || $nim == '' || $nama_mahasiswa == '') {
    header("Location: tambah.php?error=" . urlencode("Kelas, periode akademik, NIM, dan nama mahasiswa wajib diisi."));
    exit;
}

$stmt = mysqli_prepare($koneksi, "CALL usp_insert_mahasiswa(?, ?, ?, ?, ?, ?)");
mysqli_stmt_bind_param($stmt, "iissss", $id_kelas, $id_periode_akademik, $nim, $nama_mahasiswa, $email, $no_hp);

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