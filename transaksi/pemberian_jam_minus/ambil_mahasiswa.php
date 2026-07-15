<?php
require_once "../../config/koneksi.php";
require_once "../../includes/auth_dashboard.php";
header("Content-Type: application/json; charset=UTF-8");

if (($_SESSION['role'] ?? '') !== 'PIC Tata Tertib') {
    http_response_code(403);
    echo json_encode(['success' => false, 'message' => 'Akses ditolak.']);
    exit;
}

$id_kelas = (int) ($_GET['id_kelas'] ?? 0);
if ($id_kelas <= 0) {
    http_response_code(422);
    echo json_encode(['success' => false, 'message' => 'Kelas tidak valid.']);
    exit;
}

$stmt = mysqli_prepare($koneksi, "CALL usp_select_mahasiswa_aktif_by_kelas(?)");
if (!$stmt) {
    error_log('Prepare mahasiswa per kelas gagal: ' . mysqli_error($koneksi));
    http_response_code(500);
    echo json_encode(['success' => false, 'message' => 'Gagal menyiapkan permintaan.']);
    exit;
}

mysqli_stmt_bind_param($stmt, 'i', $id_kelas);
if (!mysqli_stmt_execute($stmt)) {
    error_log('Execute mahasiswa per kelas gagal: ' . mysqli_stmt_error($stmt));
    mysqli_stmt_close($stmt);
    http_response_code(500);
    echo json_encode(['success' => false, 'message' => 'Gagal mengambil mahasiswa.']);
    exit;
}

$result = mysqli_stmt_get_result($stmt);
$data = [];
if ($result) {
    while ($row = mysqli_fetch_assoc($result)) {
        $data[] = $row;
    }
    mysqli_free_result($result);
}
mysqli_stmt_close($stmt);
while (mysqli_more_results($koneksi)) {
    mysqli_next_result($koneksi);
    $sisa = mysqli_store_result($koneksi);
    if ($sisa) mysqli_free_result($sisa);
}

echo json_encode(['success' => true, 'data' => $data], JSON_UNESCAPED_UNICODE);
