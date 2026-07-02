<?php
require_once "../../config/koneksi.php";
require_once "../../includes/auth_dashboard.php";

cek_role_dashboard("PIC Kemahasiswaan");

if (!isset($_POST['simpan'])) {
    header("Location: index.php");
    exit;
}

$nama_kegiatan = trim($_POST['nama_kegiatan'] ?? '');
$penyelenggara = $_POST['penyelenggara'] ?? '';
$tanggal_kegiatan = $_POST['tanggal_kegiatan'] ?? null;

if ($nama_kegiatan == '') {
    header("Location: tambah.php?error=" . urlencode("Nama kegiatan wajib diisi."));
    exit;
}

if (!in_array($penyelenggara, ['ASTRAtech', 'BEM', 'MPM', 'HIMMA', 'UKM'])) {
    header("Location: tambah.php?error=" . urlencode("Penyelenggara tidak valid."));
    exit;
}

if ($tanggal_kegiatan == '') {
    $tanggal_kegiatan = null;
}

$stmt = mysqli_prepare($koneksi, "CALL usp_insert_kegiatan(?, ?, ?)");
mysqli_stmt_bind_param($stmt, "sss", $nama_kegiatan, $penyelenggara, $tanggal_kegiatan);

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