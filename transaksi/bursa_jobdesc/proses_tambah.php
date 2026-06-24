<?php
require_once "../../config/koneksi.php";
require_once "../../includes/auth_dashboard.php";

$role = $_SESSION['role'] ?? '';

if ($role == "Mahasiswa" || $role == '') {
    header("Location: /SIMAT/index.php");
    exit;
}

if (!isset($_POST['simpan'])) {
    header("Location: index.php");
    exit;
}

$id_pengguna = $_SESSION['id_pengguna'];
$deskripsi_jobdesc = trim($_POST['deskripsi_jobdesc'] ?? '');
$penerima_jobdesc = trim($_POST['penerima_jobdesc'] ?? '');
$jam_plus = $_POST['jam_plus'] ?? '';
$tanggal_pemberian_jobdesc = $_POST['tanggal_pemberian_jobdesc'] ?? '';
$jumlah_mahasiswa_diperlukan = $_POST['jumlah_mahasiswa_diperlukan'] ?? '';

if (
    $deskripsi_jobdesc == '' ||
    $penerima_jobdesc == '' ||
    $jam_plus == '' ||
    $tanggal_pemberian_jobdesc == '' ||
    $jumlah_mahasiswa_diperlukan == ''
) {
    header("Location: tambah.php?error=" . urlencode("Deskripsi, penerima jobdesc, jam plus, tanggal, dan jumlah mahasiswa wajib diisi."));
    exit;
}

if (!in_array($penerima_jobdesc, ['Semua mahasiswa', 'Yang memiliki jam minus'])) {
    header("Location: tambah.php?error=" . urlencode("Pilihan penerima jobdesc tidak valid."));
    exit;
}

$tanggal_pemberian_jobdesc = str_replace("T", " ", $tanggal_pemberian_jobdesc);

if (strlen($tanggal_pemberian_jobdesc) == 16) {
    $tanggal_pemberian_jobdesc .= ":00";
}

$stmt = mysqli_prepare($koneksi, "CALL usp_insert_bursa_jobdesc(?, ?, ?, ?, ?, ?)");

mysqli_stmt_bind_param(
    $stmt,
    "issdsi",
    $id_pengguna,
    $deskripsi_jobdesc,
    $penerima_jobdesc,
    $jam_plus,
    $tanggal_pemberian_jobdesc,
    $jumlah_mahasiswa_diperlukan,
);

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