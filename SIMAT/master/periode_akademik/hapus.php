<?php
require_once "../../config/koneksi.php";
require_once "../../includes/auth_dashboard.php";

$role = $_SESSION['role'] ?? '';

if (!in_array($role, ["Kepala Prodi", "PIC Kemahasiswaan"])) {
    header("Location: /SIMAT/index.php");
    exit;
}

$id_periode_akademik = $_GET['id'] ?? '';

if ($id_periode_akademik == '') {
    header("Location: index.php?error=" . urlencode("ID periode akademik tidak ditemukan."));
    exit;
}

$stmt = mysqli_prepare($koneksi, "CALL usp_soft_delete_periode_akademik(?)");
mysqli_stmt_bind_param($stmt, "i", $id_periode_akademik);

if (mysqli_stmt_execute($stmt)) {
    mysqli_stmt_close($stmt);

    header("Location: index.php?status=berhasil_hapus");
    exit;
} else {
    $error = mysqli_error($koneksi);
    mysqli_stmt_close($stmt);

    header("Location: index.php?error=" . urlencode($error));
    exit;
}
?>