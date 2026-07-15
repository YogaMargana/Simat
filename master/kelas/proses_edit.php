<?php
require_once "../../config/koneksi.php";
require_once "../../config/function.php";
require_once "../../includes/auth_dashboard.php";

cek_role_dashboard("Kepala Prodi");

if (!isset($_POST['update'])) {
    header("Location: index.php");
    exit;
}

$id_kelas = (int) ($_POST['id_kelas'] ?? 0);
$nama_kelas = strtoupper(trim($_POST['nama_kelas'] ?? ''));
$tingkat = trim($_POST['tingkat'] ?? '');
$kembali = "edit.php?id=" . urlencode($id_kelas);

if ($id_kelas <= 0 || $nama_kelas === '' || $tingkat === '') {
    header("Location: index.php?error=" . urlencode("Data edit tidak lengkap."));
    exit;
}

if (strlen($nama_kelas) > 5 || !in_array($tingkat, ['1', '2', '3', '4'], true)) {
    header("Location: {$kembali}&error=" . urlencode("Nama kelas maksimal 5 karakter dan tingkat harus valid."));
    exit;
}

$duplikat = ambil_satu_procedure_prepared(
    $koneksi,
    "CALL usp_cek_nama_kelas_aktif(?, ?)",
    "si",
    [$nama_kelas, $id_kelas]
);

if ((int) ($duplikat['jumlah'] ?? 0) > 0) {
    header("Location: {$kembali}&error=" . urlencode("Nama kelas sudah digunakan oleh kelas aktif lain."));
    exit;
}

$stmt = mysqli_prepare($koneksi, "CALL usp_update_kelas(?, ?, ?)");
mysqli_stmt_bind_param($stmt, "iss", $id_kelas, $nama_kelas, $tingkat);

if (mysqli_stmt_execute($stmt)) {
    mysqli_stmt_close($stmt);
    header("Location: index.php?status=berhasil_edit");
    exit;
}

$error = pesan_error_statement($stmt, "Data kelas gagal diubah.");
mysqli_stmt_close($stmt);
header("Location: {$kembali}&error=" . urlencode($error));
exit;
?>
