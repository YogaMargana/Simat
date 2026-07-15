<?php
require_once "../../config/koneksi.php";
require_once "../../config/function.php";
require_once "../../includes/auth_dashboard.php";

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    header("Location: index.php");
    exit;
}


cek_role_dashboard("Kepala Prodi");

$id_periode_akademik = (int) ($_GET['id'] ?? 0);

if ($id_periode_akademik <= 0) {
    header("Location: index.php?error=" . urlencode("ID periode akademik tidak ditemukan."));
    exit;
}

$periode = ambil_satu_procedure_prepared(
    $koneksi,
    "CALL usp_select_periode_akademik_by_id(?)",
    "i",
    [$id_periode_akademik]
);

if (!$periode) {
    header("Location: index.php?error=" . urlencode("Data periode akademik tidak ditemukan."));
    exit;
}

if (tanggal_sekarang_dalam_periode($periode['tanggal_mulai'], $periode['tanggal_selesai'])) {
    header("Location: index.php?error=" . urlencode("Periode akademik yang sedang berlangsung tidak dapat dinonaktifkan."));
    exit;
}

$stmt = mysqli_prepare($koneksi, "CALL usp_soft_delete_periode_akademik(?)");
mysqli_stmt_bind_param($stmt, "i", $id_periode_akademik);

if (mysqli_stmt_execute($stmt)) {
    mysqli_stmt_close($stmt);
    header("Location: index.php?status=berhasil_hapus");
    exit;
}

$error = pesan_error_statement($stmt, 'Periode akademik gagal dinonaktifkan.');
mysqli_stmt_close($stmt);
header("Location: index.php?error=" . urlencode($error));
exit;
?>
