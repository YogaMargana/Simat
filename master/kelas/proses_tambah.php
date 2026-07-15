<?php
require_once "../../config/koneksi.php";
require_once "../../config/function.php";
require_once "../../includes/auth_dashboard.php";

cek_role_dashboard("Kepala Prodi");

if (!isset($_POST['simpan'])) {
    header("Location: index.php");
    exit;
}

$nama_kelas = strtoupper(trim($_POST['nama_kelas'] ?? ''));
$tingkat = trim($_POST['tingkat'] ?? '');

if ($nama_kelas === '' || $tingkat === '') {
    header("Location: tambah.php?error=" . urlencode("Nama kelas dan tingkat wajib diisi."));
    exit;
}

if (strlen($nama_kelas) > 5 || !in_array($tingkat, ['1', '2', '3', '4'], true)) {
    header("Location: tambah.php?error=" . urlencode("Nama kelas maksimal 5 karakter dan tingkat harus valid."));
    exit;
}

$duplikat = ambil_satu_procedure_prepared(
    $koneksi,
    "CALL usp_cek_nama_kelas_aktif(?, NULL)",
    "s",
    [$nama_kelas]
);

if ((int) ($duplikat['jumlah'] ?? 0) > 0) {
    header("Location: tambah.php?error=" . urlencode("Nama kelas sudah digunakan oleh kelas yang masih aktif."));
    exit;
}

$stmt = mysqli_prepare($koneksi, "CALL usp_insert_kelas(?, ?)");
mysqli_stmt_bind_param($stmt, "ss", $nama_kelas, $tingkat);

if (mysqli_stmt_execute($stmt)) {
    mysqli_stmt_close($stmt);
    header("Location: index.php?status=berhasil_tambah");
    exit;
}

$error = pesan_error_statement($stmt, "Data kelas gagal disimpan.");
mysqli_stmt_close($stmt);
header("Location: tambah.php?error=" . urlencode($error));
exit;
?>
