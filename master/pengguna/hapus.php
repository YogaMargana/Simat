<?php
require_once "../../config/koneksi.php";
require_once "../../includes/auth_dashboard.php";

// /** @var mysqli $koneksi */

cek_role_dashboard("Kepala Prodi");

$id_pengguna = $_GET['id'] ?? '';

if ($id_pengguna == '') {
    header("Location: index.php?error=" . urlencode("ID pengguna tidak ditemukan."));
    exit;
}

if ($id_pengguna == $_SESSION['id_pengguna']) {
    header("Location: index.php?error=" . urlencode("Akun yang sedang digunakan tidak boleh dinonaktifkan."));
    exit;
}

$stmt = mysqli_prepare($koneksi, "CALL usp_soft_delete_pengguna(?)");
mysqli_stmt_bind_param($stmt, "i", $id_pengguna);

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