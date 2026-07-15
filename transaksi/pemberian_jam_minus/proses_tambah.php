<?php

require_once "../../config/koneksi.php";
require_once "../../config/function.php";
require_once "../../includes/auth_dashboard.php";

function kembali_dengan_error($pesan)
{
    header(
        "Location: tambah.php?error=" .
        urlencode($pesan)
    );
    exit;
}

function ambil_jumlah_jam($nilai_input, $nama_field)
{
    $nilai_input = str_replace(
        ',',
        '.',
        trim($nilai_input)
    );

    if ($nilai_input === '') {
        kembali_dengan_error(
            $nama_field . " wajib diisi."
        );
    }

    if (
        !preg_match(
            '/^\d{1,4}(\.\d)?$/',
            $nilai_input
        )
    ) {
        kembali_dengan_error(
            $nama_field .
            " hanya boleh memiliki satu angka " .
            "di belakang koma."
        );
    }

    $jumlah_jam = (float) $nilai_input;

    if (
        $jumlah_jam < 0.1 ||
        $jumlah_jam > 1000.0
    ) {
        kembali_dengan_error(
            $nama_field .
            " harus antara 0,1 sampai 1000,0."
        );
    }

    return $jumlah_jam;
}

/* ===================================
   OTORISASI
   =================================== */
if (
    ($_SESSION['role'] ?? '')
    !==
    'PIC Tata Tertib'
) {
    header(
        "Location: /SIMAT/index.php"
    );

    exit;
}

/* ===================================
   WAJIB POST
   =================================== */
if (
    $_SERVER['REQUEST_METHOD']
    !==
    'POST'
) {
    header(
        "Location: index.php"
    );

    exit;
}

if (!isset($_POST['simpan'])) {

    header(
        "Location: index.php"
    );

    exit;
}

/* ===================================
   DATA UMUM
   =================================== */
$id_pemberi =
    (int) $_SESSION['id_pengguna'];

$id_kelas = (int) ($_POST['id_kelas'] ?? 0);

$id_penerima =
    (int) (
        $_POST['id_pengguna_mahasiswa']
        ?? 0
    );

$kategori =
    trim(
        $_POST['kategori_pelanggaran']
        ?? ''
    );

/* ===================================
   NILAI DEFAULT
   =================================== */
$id_detail_mata_kuliah = 0;

$keterangan_absensi = '';

$id_fasilitas = 0;

$deskripsi = '';

$jenis_jam_input = '';

$jumlah_jam_minus_input = 0.0;

/* ===================================
   VALIDASI UMUM
   =================================== */
if ($id_kelas <= 0) {
    kembali_dengan_error("Kelas wajib dipilih.");
}

if ($id_penerima <= 0) {

    header(
        "Location: tambah.php?error="
        . urlencode(
            "Mahasiswa wajib dipilih."
        )
    );

    exit;
}

if (
    !in_array(
        $kategori,
        [
            'Akademik',
            'Fasilitas',
            'Lainnya'
        ],
        true
    )
) {
    header(
        "Location: tambah.php?error="
        . urlencode(
            "Kategori tidak valid."
        )
    );

    exit;
}

/* ===================================
   AKADEMIK
   =================================== */
if ($kategori === 'Akademik') {

    $id_detail_mata_kuliah =
        (int) (
            $_POST[
                'id_detail_kelas_pada_mata_kuliah'
            ]
            ?? 0
        );

    $keterangan_absensi =
        trim(
            $_POST['keterangan_absensi']
            ?? ''
        );

    $jumlah_jam_minus_input =
        ambil_jumlah_jam(
            $_POST['jumlah_jam_minus_akademik'] ?? '',
            'Jumlah jam minus Akademik'
        );

    if ($id_detail_mata_kuliah <= 0) {

        header(
            "Location: tambah.php?error="
            . urlencode(
                "Mata kuliah wajib dipilih."
            )
        );

        exit;
    }

    if (
        !in_array(
            $keterangan_absensi,
            [
                'Izin',
                'Sakit',
                'Alpa'
            ],
            true
        )
    ) {
        header(
            "Location: tambah.php?error="
            . urlencode(
                "Keterangan absensi tidak valid."
            )
        );

        exit;
    }
}

/* ===================================
   FASILITAS
   =================================== */
if ($kategori === 'Fasilitas') {

    $id_fasilitas =
        (int) (
            $_POST['id_fasilitas']
            ?? 0
        );

    if ($id_fasilitas <= 0) {

        header(
            "Location: tambah.php?error="
            . urlencode(
                "Fasilitas wajib dipilih."
            )
        );

        exit;
    }

    /*
     * Jangan menerima:
     *
     * harga
     * jumlah hasil perhitungan
     * jenis jam
     *
     * dari browser.
     *
     * Stored procedure menentukan semuanya.
     */
}

/* ===================================
   LAINNYA
   =================================== */
if ($kategori === 'Lainnya') {

    $deskripsi =
        trim(
            $_POST[
                'deskripsi_pelanggaran'
            ]
            ?? ''
        );

    $jenis_jam_input =
        trim(
            $_POST[
                'jenis_jam_lainnya'
            ]
            ?? ''
        );

    $jumlah_jam_minus_input =
        ambil_jumlah_jam(
            $_POST['jumlah_jam_minus_lainnya'] ?? '',
            'Jumlah jam minus'
        );

    if ($deskripsi === '') {

        header(
            "Location: tambah.php?error="
            . urlencode(
                "Deskripsi pelanggaran "
                . "wajib diisi."
            )
        );

        exit;
    }

    if (
        !in_array(
            $jenis_jam_input,
            [
                'Murni',
                'Kompensasi'
            ],
            true
        )
    ) {
        header(
            "Location: tambah.php?error="
            . urlencode(
                "Jenis jam minus tidak valid."
            )
        );

        exit;
    }
}

/* ===================================
   PANGGIL STORED PROCEDURE
   =================================== */
$stmt = mysqli_prepare(
    $koneksi,

    "CALL usp_insert_pemberian_jam_minus(
        ?,
        ?,
        ?,
        ?,
        ?,
        ?,
        ?,
        ?,
        ?,
        ?
    )"
);

if (!$stmt) {

    error_log(
        "Prepare pemberian jam minus gagal: "
        . mysqli_error($koneksi)
    );

    header(
        "Location: tambah.php?error="
        . urlencode(
            "Gagal menyiapkan penyimpanan data."
        )
    );

    exit;
}

/*
 * Parameter:
 *
 * i = id pemberi
 * i = id penerima
 * i = id kelas
 * s = kategori
 * i = id detail mata kuliah
 * s = absensi
 * i = id fasilitas
 * s = deskripsi
 * s = jenis input
 * d = jumlah input
 */
mysqli_stmt_bind_param(
    $stmt,
    "iiisisissd",

    $id_pemberi,

    $id_penerima,

    $id_kelas,

    $kategori,

    $id_detail_mata_kuliah,

    $keterangan_absensi,

    $id_fasilitas,

    $deskripsi,

    $jenis_jam_input,

    $jumlah_jam_minus_input
);

if (!mysqli_stmt_execute($stmt)) {

    $pesan_error = pesan_error_statement(
        $stmt,
        "Pemberian jam minus gagal disimpan. Periksa kembali data."
    );

    mysqli_stmt_close($stmt);

    header(
        "Location: tambah.php?error="
        . urlencode($pesan_error)
    );

    exit;
}

/* ===================================
   TUTUP STATEMENT
   =================================== */
mysqli_stmt_close($stmt);

/* Bersihkan seluruh result SP */
while (mysqli_more_results($koneksi)) {

    mysqli_next_result($koneksi);

    $sisa_result =
        mysqli_store_result($koneksi);

    if ($sisa_result) {
        mysqli_free_result($sisa_result);
    }
}

/* Token lama tidak dipakai ulang */

/* ===================================
   REDIRECT SUKSES
   =================================== */
header(
    "Location: index.php?status=berhasil_tambah"
);

exit;