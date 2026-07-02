<?php
require_once "../../config/koneksi.php";
require_once "../../includes/auth_dashboard.php";

cek_role_dashboard("PIC Kemahasiswaan");

if (!isset($_POST['update'])) {
    header("Location: index.php");
    exit;
}

$id_kegiatan = (int) ($_POST['id_kegiatan'] ?? 0);
$nama_kegiatan = trim($_POST['nama_kegiatan'] ?? '');
$penyelenggara = $_POST['penyelenggara'] ?? '';
$tanggal_kegiatan = $_POST['tanggal_kegiatan'] ?? null;

if ($id_kegiatan <= 0) {
    header("Location: index.php?error=" . urlencode("ID kegiatan tidak valid."));
    exit;
}

if ($nama_kegiatan == '') {
    header("Location: edit.php?id=" . urlencode($id_kegiatan) . "&error=" . urlencode("Nama kegiatan wajib diisi."));
    exit;
}

if (!in_array($penyelenggara, ['ASTRAtech', 'BEM', 'MPM', 'HIMMA', 'UKM'])) {
    header("Location: edit.php?id=" . urlencode($id_kegiatan) . "&error=" . urlencode("Penyelenggara tidak valid."));
    exit;
}

if ($tanggal_kegiatan == '') {
    $tanggal_kegiatan = null;
}

$stmt = mysqli_prepare($koneksi, "CALL usp_update_kegiatan(?, ?, ?, ?)");
mysqli_stmt_bind_param($stmt, "isss", $id_kegiatan, $nama_kegiatan, $penyelenggara, $tanggal_kegiatan);

if (mysqli_stmt_execute($stmt)) {
    mysqli_stmt_close($stmt);

    header("Location: index.php?status=berhasil_edit");
    exit;
} else {
    $error = mysqli_error($koneksi);
    mysqli_stmt_close($stmt);

    header("Location: edit.php?id=" . urlencode($id_kegiatan) . "&error=" . urlencode($error));
    exit;
}