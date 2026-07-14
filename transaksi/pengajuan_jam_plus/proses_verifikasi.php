<?php
require_once "../../config/koneksi.php";
require_once "../../includes/auth_dashboard.php";

if (($_SESSION['role'] ?? '') !== "PIC Tata Tertib") {
    header("Location: /SIMAT/index.php");
    exit;
}

if (!isset($_POST['verifikasi'])) {
    header("Location: index.php");
    exit;
}

$id_pengajuan = (int) ($_POST['id_pengajuan_jam_plus'] ?? 0);
$id_verifikator = (int) ($_SESSION['id_pengguna'] ?? 0);
$status_baru = trim($_POST['status_pengajuan'] ?? '');
$alasan_penolakan = trim($_POST['alasan_penolakan'] ?? '');

if ($id_pengajuan <= 0) {
    header(
        "Location: index.php?error=" .
        urlencode("ID pengajuan tidak valid.")
    );
    exit;
}

if (!in_array($status_baru, ['Disetujui', 'Ditolak'], true)) {
    header(
        "Location: verifikasi.php?id=$id_pengajuan&error=" .
        urlencode("Pilih keputusan yang valid.")
    );
    exit;
}

if ($status_baru === 'Ditolak' && $alasan_penolakan === '') {
    header(
        "Location: verifikasi.php?id=$id_pengajuan&error=" .
        urlencode("Alasan penolakan wajib diisi.")
    );
    exit;
}

if (strlen($alasan_penolakan) > 255) {
    header(
        "Location: verifikasi.php?id=$id_pengajuan&error=" .
        urlencode("Alasan penolakan maksimal 255 karakter.")
    );
    exit;
}

if ($status_baru === 'Disetujui') {
    $alasan_penolakan = null;
}

$stmt = mysqli_prepare(
    $koneksi,
    "CALL usp_update_status_pengajuan_jam_plus(?, ?, ?, ?)"
);

if (!$stmt) {
    header(
        "Location: verifikasi.php?id=$id_pengajuan&error=" .
        urlencode("Gagal menyiapkan proses verifikasi.")
    );
    exit;
}

mysqli_stmt_bind_param(
    $stmt,
    "iiss",
    $id_pengajuan,
    $id_verifikator,
    $status_baru,
    $alasan_penolakan
);

if (mysqli_stmt_execute($stmt)) {
    mysqli_stmt_close($stmt);

    header(
        "Location: index.php?status=" .
        urlencode("berhasil_verifikasi")
    );
    exit;
}

$error = mysqli_stmt_error($stmt);
mysqli_stmt_close($stmt);

header(
    "Location: verifikasi.php?id=$id_pengajuan&error=" .
    urlencode($error)
);
exit;