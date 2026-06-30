<?php
require_once "../../config/koneksi.php";
require_once "../../includes/auth_dashboard.php";

if ($_SESSION['role'] != "PIC Tata Tertib") {
    header("Location: index.php");
    exit;
}

if (isset($_POST['verifikasi'])) {
    $id_pengajuan    = (int) ($_POST['id_pengajuan_jam_plus'] ?? 0);
    $id_verifikator  = (int) $_SESSION['id_pengguna'];
    $status_baru     = $_POST['status_pengajuan'] ?? '';

    if (empty($status_baru)) {
        header("Location: verifikasi.php?id=$id_pengajuan&error=Pilih keputusan terlebih dahulu.");
        exit;
    }

    if (!in_array($status_baru, ['Disetujui', 'Ditolak'])) {
        header("Location: verifikasi.php?id=$id_pengajuan&error=" . urlencode("Status verifikasi tidak valid."));
        exit;
    }

    // Memanggil Stored Procedure Update Status & Saldo
    $stmt = mysqli_prepare($koneksi, "CALL usp_update_status_pengajuan_jam_plus(?, ?, ?)");
    mysqli_stmt_bind_param($stmt, "iis", $id_pengajuan, $id_verifikator, $status_baru);

    if (mysqli_stmt_execute($stmt)) {
        mysqli_stmt_close($stmt);
        header("Location: index.php?status=berhasil_verifikasi");
    } else {
        $error = mysqli_error($koneksi);
        mysqli_stmt_close($stmt);
        header("Location: verifikasi.php?id=$id_pengajuan&error=" . urlencode($error));
    }
    exit;
}
header("Location: index.php");