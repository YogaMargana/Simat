<?php
require_once "../../config/koneksi.php";
require_once "../../includes/auth_dashboard.php";

$role = $_SESSION['role'] ?? '';

if ($role != "Mahasiswa") {
    header("Location: /SIMAT/index.php");
    exit;
}

if (!isset($_POST['simpan'])) {
    header("Location: index.php");
    exit;
}

$id_bursa_jobdesc = $_POST['id_bursa_jobdesc'] ?? '';
$bukti_selesai_url = trim($_POST['bukti_selesai_url'] ?? '');

if ($id_bursa_jobdesc == '' || $bukti_selesai_url == '') {
    header("Location: index.php?error=" . urlencode("Data bukti selesai belum lengkap."));
    exit;
}

if ($bukti_selesai_url == '') {
    header("Location: selesai.php?id=" . urlencode($id_bursa_jobdesc) . "&error=" . urlencode("Format link bukti selesai tidak valid."));
    exit;
}

$stmt = mysqli_prepare($koneksi, "CALL usp_update_bukti_selesai_url_bursa_jobdesc(?, ?, ?)");

mysqli_stmt_bind_param(
    $stmt,
    "iis",
    $id_bursa_jobdesc,
    $_SESSION['id_pengguna'],
    $bukti_selesai_url
);

if (mysqli_stmt_execute($stmt)) {
    mysqli_stmt_close($stmt);

    header("Location: index.php?status=berhasil_selesai");
    exit;
} else {
    $error = mysqli_error($koneksi);
    mysqli_stmt_close($stmt);

    header("Location: selesai.php?id=" . urlencode($id_bursa_jobdesc) . "&error=" . urlencode($error));
    exit;
}
?>