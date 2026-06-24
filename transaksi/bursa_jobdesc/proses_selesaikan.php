<?php
require_once "../../config/koneksi.php";
require_once "../../includes/auth_dashboard.php";

$role = $_SESSION['role'] ?? '';

if ($role == "Mahasiswa" || $role == '') {
    header("Location: /SIMAT/index.php");
    exit;
}

$id_bursa_jobdesc = $_GET['id'] ?? '';

if ($id_bursa_jobdesc == '') {
    header("Location: index.php?error=" . urlencode("ID bursa jobdesc tidak ditemukan."));
    exit;
}

$stmt = mysqli_prepare($koneksi, "CALL usp_selesaikan_bursa_jobdesc(?, ?)");

mysqli_stmt_bind_param(
    $stmt,
    "ii",
    $id_bursa_jobdesc,
    $_SESSION['id_pengguna']
);

if (mysqli_stmt_execute($stmt)) {
    mysqli_stmt_close($stmt);

    header("Location: index.php?status=berhasil_selesaikan_jobdesc");
    exit;
} else {
    $error = mysqli_error($koneksi);
    mysqli_stmt_close($stmt);

    header("Location: index.php?error=" . urlencode($error));
    exit;
}
?>