<?php
require_once "../../config/koneksi.php";
require_once "../../includes/auth_dashboard.php";

if ($_SESSION['role'] != "Mahasiswa") {
    header("Location: index.php");
    exit;
}

if (isset($_POST['simpan'])) {
    $id_pengguna        = (int) $_SESSION['id_pengguna'];
    $id_kegiatan        = (int) ($_POST['id_kegiatan'] ?? 0);
    $jumlah_jam_plus    = (float) ($_POST['jumlah_jam_plus'] ?? 0);
    $jenis_jam          = $_POST['jenis_jam'] ?? '';
    $sumber_jam         = $_POST['sumber_jam'] ?? '';
    $deskripsi          = $_POST['deskripsi_pekerjaan'] ?? '';
    $nama_pemberi       = $_POST['nama_pemberi'] ?? '';
    $dokumen_url        = $_POST['dokumen_url'] ?? '';

    if ($id_kegiatan <= 0) {
        header("Location: tambah.php?error=" . urlencode("Kegiatan wajib dipilih."));
        exit;
    }

    if ($jumlah_jam_plus <= 0) {
        header("Location: tambah.php?error=" . urlencode("Jumlah jam plus harus lebih dari 0."));
        exit;
    }

    if (!in_array($jenis_jam, ['Murni', 'Kompensasi'])) {
        header("Location: tambah.php?error=" . urlencode("Jenis jam tidak valid."));
        exit;
    }

    if (!in_array($sumber_jam, ['Prodi', 'Luar'])) {
        header("Location: tambah.php?error=" . urlencode("Sumber jam wajib dipilih."));
        exit;
    }

    if (trim($deskripsi) == '' || trim($nama_pemberi) == '' || trim($dokumen_url) == '') {
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
    } else {
        $error = mysqli_error($koneksi);
        mysqli_stmt_close($stmt);
        header("Location: tambah.php?error=" . urlencode($error));
    }

    exit;
}

header("Location: index.php");
exit;