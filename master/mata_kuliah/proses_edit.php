<<<<<<< HEAD
<?php
require_once "../../config/koneksi.php";
require_once "../../includes/auth_dashboard.php";

// /** @var mysqli $koneksi */

cek_role_dashboard("Kepala Prodi");

if (!isset($_POST['update'])) {
    header("Location: index.php");
    exit;
}

$id_matakuliah = $_POST['id_matakuliah'] ?? '';
$nama_mata_kuliah = strtoupper(trim($_POST['nama_mata_kuliah'] ?? ''));
$kode_mata_kuliah = trim($_POST['kode_mata_kuliah'] ?? '');
$sks = intval($_POST['sks'] ?? 0);
$semester = trim($_POST['semester'] ?? '');
$status_mata_kuliah = trim($_POST['status_mata_kuliah'] ?? '');

if ($id_matakuliah == '' || $nama_mata_kuliah == '' || $kode_mata_kuliah == '' || $sks < 0 || $semester == '' || $status_mata_kuliah == '') {
    header("Location: index.php?error=" . urlencode("Data edit tidak lengkap."));
    exit;
}

$stmt = mysqli_prepare($koneksi,"UPDATE mata_kuliah SET nama_mata_kuliah = ?, kode_mata_kuliah = ?, sks = ?, semester = ?, status_mata_kuliah = ? WHERE id_matakuliah = ?");
mysqli_stmt_bind_param($stmt, "ssissi", $nama_mata_kuliah, $kode_mata_kuliah, $sks, $semester, $status_mata_kuliah, $id_matakuliah);

if (mysqli_stmt_execute($stmt)) {
    mysqli_stmt_close($stmt);

    header("Location: index.php?status=berhasil_edit");
    exit;
} else {
    $error = mysqli_error($koneksi);
    mysqli_stmt_close($stmt);

    header("Location: edit.php?id=" . urlencode($id_matakuliah) . "&error=" . urlencode($error));
    exit;
}
=======
<?php
require_once "../../config/koneksi.php";
require_once "../../includes/auth_dashboard.php";

// /** @var mysqli $koneksi */

cek_role_dashboard("Kepala Prodi");

if (!isset($_POST['update'])) {
    header("Location: index.php");
    exit;
}

$id_matakuliah = $_POST['id_matakuliah'] ?? '';
$nama_mata_kuliah = strtoupper(trim($_POST['nama_mata_kuliah'] ?? ''));
$kode_mata_kuliah = trim($_POST['kode_mata_kuliah'] ?? '');
$sks = intval($_POST['sks'] ?? 0);
$semester = trim($_POST['semester'] ?? '');
$status_mata_kuliah = trim($_POST['status_mata_kuliah'] ?? '');

if ($id_matakuliah == '' || $nama_mata_kuliah == '' || $kode_mata_kuliah == '' || $sks < 0 || $semester == '' || $status_mata_kuliah == '') {
    header("Location: index.php?error=" . urlencode("Data edit tidak lengkap."));
    exit;
}

$stmt = mysqli_prepare($koneksi,"UPDATE mata_kuliah SET nama_mata_kuliah = ?, kode_mata_kuliah = ?, sks = ?, semester = ?, status_mata_kuliah = ? WHERE id_matakuliah = ?");
mysqli_stmt_bind_param($stmt, "ssissi", $nama_mata_kuliah, $kode_mata_kuliah, $sks, $semester, $status_mata_kuliah, $id_matakuliah);

if (mysqli_stmt_execute($stmt)) {
    mysqli_stmt_close($stmt);

    header("Location: index.php?status=berhasil_edit");
    exit;
} else {
    $error = mysqli_error($koneksi);
    mysqli_stmt_close($stmt);

    header("Location: edit.php?id=" . urlencode($id_matakuliah) . "&error=" . urlencode($error));
    exit;
}
>>>>>>> 3dcb8fe0c7c8e43656d54631680baf01eeeadcf4
?>