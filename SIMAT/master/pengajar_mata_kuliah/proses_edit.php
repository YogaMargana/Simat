<?php
require_once "../../config/koneksi.php";
require_once "../../includes/auth_dashboard.php";

cek_role_dashboard("Kepala Prodi");

if (!isset($_POST['update'])) {
    header("Location: index.php");
    exit;
}

$id_detail = (int) ($_POST['id_detail_kelas_pada_mata_kuliah'] ?? 0);
$id_kelas = (int) ($_POST['id_kelas'] ?? 0);
$id_mata_kuliah = (int) ($_POST['id_mata_kuliah'] ?? 0);
$id_pengajar_1 = (int) ($_POST['id_pengajar_1'] ?? 0);
$id_pengajar_2 = (int) ($_POST['id_pengajar_2'] ?? 0);

if ($id_detail <= 0 || $id_kelas <= 0 || $id_mata_kuliah <= 0 || $id_pengajar_1 <= 0 || $id_pengajar_2 <= 0) {
    header("Location: edit.php?id=" . $id_detail . "&error=" . urlencode("Semua field wajib diisi."));
    exit;
}

if ($id_pengajar_1 == $id_pengajar_2) {
    header("Location: edit.php?id=" . $id_detail . "&error=" . urlencode("Pengajar 1 dan Pengajar 2 tidak boleh sama."));
    exit;
}

$stmt = mysqli_prepare($koneksi, "CALL usp_update_pengajar_mata_kuliah_kelas(?, ?, ?, ?, ?)");
mysqli_stmt_bind_param($stmt, "iiiii", $id_detail, $id_kelas, $id_mata_kuliah, $id_pengajar_1, $id_pengajar_2);

if (mysqli_stmt_execute($stmt)) {
    mysqli_stmt_close($stmt);

    header("Location: index.php?status=berhasil_edit");
    exit;
} else {
    $error = mysqli_error($koneksi);
    mysqli_stmt_close($stmt);

    header("Location: edit.php?id=" . $id_detail . "&error=" . urlencode($error));
    exit;
}
?>