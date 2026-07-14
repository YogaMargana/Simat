<?php
require_once "../../config/koneksi.php";
require_once "../../includes/auth_dashboard.php";

// /** @var mysqli $koneksi */

cek_role_dashboard("Kepala Prodi");

if (!isset($_POST['simpan'])) {
    header("Location: index.php");
    exit;
}

$nama_mata_kuliah = strtoupper(trim($_POST['nama_mata_kuliah'] ?? ''));
$kode_mata_kuliah = trim($_POST['kode_mata_kuliah'] ?? '');
$sks = intval($_POST['sks'] ?? 0);
$semester = intval($_POST['semester'] ?? 0);

/* =========================
   VALIDASI INPUT KOSONG
========================= */
// if (
//     $nama_mata_kuliah == '' ||
//     $kode_mata_kuliah == '' ||
//     $sks <= 0 ||
//     $semester <= 0
// ) {
//     header("Location: tambah.php?error=" . urlencode("Semua field wajib diisi."));
//     exit;
// }

/* =========================
   CEK DUPLIKAT KODE
========================= */
// $cek = mysqli_prepare(
//     $koneksi,
//     "SELECT id_matakuliah FROM mata_kuliah WHERE kode_mata_kuliah = ? LIMIT 1"
// );

// mysqli_stmt_bind_param($cek, "s", $kode_mata_kuliah);
// mysqli_stmt_execute($cek);
// $result = mysqli_stmt_get_result($cek);

// if (mysqli_fetch_assoc($result)) {
//     mysqli_stmt_close($cek);
//     header("Location: tambah.php?error=" . urlencode("Kode mata kuliah sudah digunakan!"));
//     exit;
// }

// mysqli_stmt_close($cek);


if ($nama_mata_kuliah == '' || $kode_mata_kuliah == '' || $sks <= 0 || $semester <= 0) {
    header("Location: tambah.php?error=" . urlencode("Semua field wajib diisi."));
    exit;
}


$stmt = mysqli_prepare($koneksi, "
    INSERT INTO mata_kuliah
    (nama_mata_kuliah, kode_mata_kuliah, sks, semester)
    VALUES (?, ?, ?, ?)
");
mysqli_stmt_bind_param($stmt, "ssis", $nama_mata_kuliah, $kode_mata_kuliah, $sks, $semester);

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