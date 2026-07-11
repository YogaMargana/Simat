<?php
require_once "../../config/koneksi.php";
require_once "../../includes/auth_dashboard.php";

if ($_SESSION['role'] != "Mahasiswa") {
    header("Location: index.php");
    exit;
}

if (!isset($_POST['simpan'])) {
    header("Location: index.php");
    exit;
}

$id_pengguna        = (int) $_SESSION['id_pengguna'];
$jumlah_jam_plus    = round((float) ($_POST['jumlah_jam_plus'] ?? 0), 1);
$jenis_jam          = $_POST['jenis_jam'] ?? '';
$sumber_jam         = $_POST['sumber_jam'] ?? '';
$deskripsi          = trim($_POST['deskripsi_pekerjaan'] ?? '');
$nama_pemberi       = trim($_POST['nama_pemberi'] ?? '');
$dokumen_url        = trim($_POST['dokumen_url'] ?? '');

if (!in_array($sumber_jam, ['Prodi', 'Luar'])) {
    header("Location: tambah.php?error=" . urlencode("Sumber jam wajib dipilih."));
    exit;
}

if ($sumber_jam == 'Luar') {
    $id_kegiatan = (int) ($_POST['id_kegiatan'] ?? 0);

    if ($id_kegiatan <= 0) {
        header("Location: tambah.php?error=" . urlencode("Kegiatan wajib dipilih jika sumber jam berasal dari luar."));
        exit;
    }
} else {
    $id_kegiatan = null;
}

if ($jumlah_jam_plus <= 0) {
    header("Location: tambah.php?error=" . urlencode("Jumlah jam plus harus lebih dari 0."));
    exit;
}

if (fmod($jumlah_jam_plus * 10, 1) != 0.0) {
    header("Location: tambah.php?error=" . urlencode("Jumlah jam plus hanya boleh memiliki 1 angka di belakang koma."));
    exit;
}

if ($jumlah_jam_plus > 100) {
    header("Location: tambah.php?error=" . urlencode("Jumlah jam plus harus lebih kecil sama dengan 100."));
    exit;
}

if (!in_array($jenis_jam, ['Murni', 'Kompensasi'])) {
    header("Location: tambah.php?error=" . urlencode("Jenis jam tidak valid."));
    exit;
}

if ($deskripsi == '' || $nama_pemberi == '' || $dokumen_url == '') {
    header("Location: tambah.php?error=" . urlencode("Semua field wajib diisi."));
    exit;
}

$stmt = mysqli_prepare($koneksi, "CALL usp_insert_pengajuan_jam_plus(?, ?, ?, ?, ?, ?, ?, ?)");

mysqli_stmt_bind_param(
    $stmt,
    "iidsssss",
    $id_pengguna,
    $id_kegiatan,
    $jumlah_jam_plus,
    $jenis_jam,
    $sumber_jam,
    $deskripsi,
    $nama_pemberi,
    $dokumen_url
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