<?php
require_once "../../config/koneksi.php";
require_once "../../includes/auth_dashboard.php";

$role = $_SESSION['role'] ?? '';

if (!in_array($role, ["Kepala Prodi", "PIC Kemahasiswaan"])) {
    header("Location: /SIMAT/index.php");
    exit;
}

if (!isset($_POST['simpan'])) {
    header("Location: index.php");
    exit;
}

$id_periode_akademik = $_POST['id_periode_akademik'] ?? '';
$tahun_akademik = trim($_POST['tahun_akademik'] ?? '');
$semester = $_POST['semester'] ?? '';
$tanggal_mulai = $_POST['tanggal_mulai'] ?? '';
$tanggal_selesai = $_POST['tanggal_selesai'] ?? '';
$status_periode = $_POST['status_periode'] ?? '';

if (
    $id_periode_akademik == '' ||
    $tahun_akademik == '' ||
    $semester == '' ||
    $tanggal_mulai == '' ||
    $tanggal_selesai == '' ||
    $status_periode == ''
) {
    header("Location: index.php?error=" . urlencode("Data periode akademik belum lengkap."));
    exit;
}

if (!in_array($semester, ["Ganjil", "Genap"])) {
    header("Location: edit.php?id=" . urlencode($id_periode_akademik) . "&error=" . urlencode("Semester tidak valid."));
    exit;
}

if (!in_array($status_periode, ["Aktif", "Tidak Aktif"])) {
    header("Location: edit.php?id=" . urlencode($id_periode_akademik) . "&error=" . urlencode("Status periode tidak valid."));
    exit;
}

$tanggal_mulai = str_replace("T", " ", $tanggal_mulai);
$tanggal_selesai = str_replace("T", " ", $tanggal_selesai);

if (strlen($tanggal_mulai) == 16) {
    $tanggal_mulai .= ":00";
}

if (strlen($tanggal_selesai) == 16) {
    $tanggal_selesai .= ":00";
}

$stmt = mysqli_prepare($koneksi, "CALL usp_update_periode_akademik(?, ?, ?, ?, ?, ?)");

mysqli_stmt_bind_param(
    $stmt,
    "isssss",
    $id_periode_akademik,
    $tahun_akademik,
    $semester,
    $tanggal_mulai,
    $tanggal_selesai,
    $status_periode
);

if (mysqli_stmt_execute($stmt)) {
    mysqli_stmt_close($stmt);

    header("Location: index.php?status=berhasil_edit");
    exit;
} else {
    $error = mysqli_error($koneksi);
    mysqli_stmt_close($stmt);

    header("Location: edit.php?id=" . urlencode($id_periode_akademik) . "&error=" . urlencode($error));
    exit;
}
?>