<?php

require_once "../../config/koneksi.php";
require_once "../../includes/auth_dashboard.php";

header(
    "Content-Type: application/json; charset=UTF-8"
);

/* Hanya PIC Tata Tertib */
if (
    ($_SESSION['role'] ?? '')
    !==
    'PIC Tata Tertib'
) {
    http_response_code(403);

    echo json_encode([
        'success' => false,
        'message' => 'Akses ditolak.'
    ]);

    exit;
}

$id_pengguna_mahasiswa =
    (int) (
        $_GET['id_pengguna_mahasiswa']
        ?? 0
    );

if ($id_pengguna_mahasiswa <= 0) {

    http_response_code(422);

    echo json_encode([
        'success' => false,
        'message' => 'Mahasiswa tidak valid.'
    ]);

    exit;
}

$stmt = mysqli_prepare(
    $koneksi,

    "CALL
     usp_select_mata_kuliah_mahasiswa_untuk_jam_minus(?)"
);

if (!$stmt) {

    error_log(
        "Prepare mata kuliah jam minus gagal: "
        . mysqli_error($koneksi)
    );

    http_response_code(500);

    echo json_encode([
        'success' => false,
        'message' => 'Gagal menyiapkan permintaan.'
    ]);

    exit;
}

mysqli_stmt_bind_param(
    $stmt,
    "i",
    $id_pengguna_mahasiswa
);

if (!mysqli_stmt_execute($stmt)) {

    error_log(
        "Execute mata kuliah jam minus gagal: "
        . mysqli_stmt_error($stmt)
    );

    mysqli_stmt_close($stmt);

    http_response_code(500);

    echo json_encode([
        'success' => false,
        'message' => 'Gagal mengambil mata kuliah.'
    ]);

    exit;
}

$result =
    mysqli_stmt_get_result($stmt);

$data = [];

if ($result) {

    while (
        $row = mysqli_fetch_assoc($result)
    ) {
        $data[] = $row;
    }

    mysqli_free_result($result);
}

mysqli_stmt_close($stmt);

/* Bersihkan result set SP */
while (mysqli_more_results($koneksi)) {

    mysqli_next_result($koneksi);

    $sisa_result =
        mysqli_store_result($koneksi);

    if ($sisa_result) {
        mysqli_free_result($sisa_result);
    }
}

echo json_encode(
    [
        'success' => true,
        'data' => $data
    ],
    JSON_UNESCAPED_UNICODE
);