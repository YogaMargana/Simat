<?php
require_once "../../config/koneksi.php";
require_once "../../config/function.php";
require_once "../../includes/auth_dashboard.php";

cek_role_dashboard("Kepala Prodi");

if (!isset($_POST['simpan'])) {
    header("Location: index.php");
    exit;
}

$id_kelas = (int) ($_POST['id_kelas'] ?? 0);
$id_periode_akademik = (int) ($_POST['id_periode_akademik'] ?? 0);
$nim = trim($_POST['nim'] ?? '');
$nama_mahasiswa = trim($_POST['nama_mahasiswa'] ?? '');
$email = nilai_nullable($_POST['email'] ?? null);
$no_hp = nilai_nullable($_POST['no_hp'] ?? null);

if ($id_kelas <= 0 || $id_periode_akademik <= 0 || $nim === '' || $nama_mahasiswa === '') {
    header("Location: tambah.php?error=" . urlencode("Kelas, periode akademik, NIM, dan nama mahasiswa wajib diisi."));
    exit;
}
if ($email !== null && filter_var($email, FILTER_VALIDATE_EMAIL) === false) {
    header("Location: tambah.php?error=" . urlencode("Format email tidak valid."));
    exit;
}
if (!nomor_hp_valid($no_hp)) {
    header("Location: tambah.php?error=" . urlencode("No HP harus terdiri dari 10 sampai 13 digit angka."));
    exit;
}

$referensi = ambil_satu_procedure_prepared($koneksi, "CALL usp_validasi_referensi_mahasiswa(?, ?)", "ii", [$id_kelas, $id_periode_akademik]);
if ((int) ($referensi['kelas_valid'] ?? 0) !== 1 || (int) ($referensi['periode_valid'] ?? 0) !== 1) {
    header("Location: tambah.php?error=" . urlencode("Kelas harus aktif dan periode akademik harus aktif serta belum berakhir."));
    exit;
}

$duplikat = ambil_satu_procedure_prepared($koneksi, "CALL usp_cek_nim_mahasiswa(?, NULL)", "s", [$nim]);
if ((int) ($duplikat['jumlah'] ?? 0) > 0) {
    header("Location: tambah.php?error=" . urlencode("NIM sudah digunakan."));
    exit;
}

$stmt = mysqli_prepare($koneksi, "CALL usp_insert_mahasiswa(?, ?, ?, ?, ?, ?)");
mysqli_stmt_bind_param($stmt, "iissss", $id_kelas, $id_periode_akademik, $nim, $nama_mahasiswa, $email, $no_hp);
if (mysqli_stmt_execute($stmt)) {
    mysqli_stmt_close($stmt);
    header("Location: index.php?status=berhasil_tambah");
    exit;
}
$error = pesan_error_statement($stmt, "Data mahasiswa gagal ditambahkan.");
mysqli_stmt_close($stmt);
header("Location: tambah.php?error=" . urlencode($error));
exit;
?>
