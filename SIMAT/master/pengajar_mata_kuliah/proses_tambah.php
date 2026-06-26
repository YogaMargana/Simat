<?php
require_once "../../config/koneksi.php";
require_once "../../includes/auth_dashboard.php";

cek_role_dashboard("Kepala Prodi");

if (!isset($_POST['simpan'])) {
    header("Location: index.php");
    exit;
}

$id_kelas = (int) ($_POST['id_kelas'] ?? 0);
$id_mata_kuliah = (int) ($_POST['id_mata_kuliah'] ?? 0);
$id_pengajar_1 = (int) ($_POST['id_pengajar_1'] ?? 0);
$id_pengajar_2 = (int) ($_POST['id_pengajar_2'] ?? 0);

if ($id_kelas <= 0 || $id_mata_kuliah <= 0 || $id_pengajar_1 <= 0 || $id_pengajar_2 <= 0) {
    header("Location: tambah.php?error=" . urlencode("Semua field wajib diisi."));
    exit;
}

if ($id_pengajar_1 == $id_pengajar_2) {
    header("Location: tambah.php?error=" . urlencode("Pengajar 1 dan Pengajar 2 tidak boleh sama."));
    exit;
}

$stmt = mysqli_prepare($koneksi, "CALL usp_insert_pengajar_mata_kuliah_kelas(?, ?, ?, ?)");
mysqli_stmt_bind_param($stmt, "iiii", $id_kelas, $id_mata_kuliah, $id_pengajar_1, $id_pengajar_2);

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