<?php
require_once "../../config/koneksi.php";
require_once "../../includes/auth_dashboard.php";

cek_role_pembuat_jobdesc();

function kembali_dengan_error($pesan)
{
    header(
        "Location: tambah.php?error=" .
        urlencode($pesan)
    );
    exit;
}

if (
    $_SERVER['REQUEST_METHOD'] !== 'POST' ||
    !isset($_POST['simpan'])
) {
    header("Location: index.php");
    exit;
}

$id_pengguna = (int) (
    $_SESSION['id_pengguna'] ?? 0
);

$deskripsi_jobdesc = trim(
    $_POST['deskripsi_jobdesc'] ?? ''
);

$penerima_jobdesc = trim(
    $_POST['penerima_jobdesc'] ?? ''
);

$jam_plus_input = str_replace(
    ',',
    '.',
    trim($_POST['jam_plus'] ?? '')
);

$tanggal_input = trim(
    $_POST['tanggal_pemberian_jobdesc'] ?? ''
);

$jumlah_mahasiswa_input = trim(
    $_POST['jumlah_mahasiswa_diperlukan'] ?? ''
);

/*
|--------------------------------------------------------------------------
| Validasi pengguna
|--------------------------------------------------------------------------
*/

if ($id_pengguna <= 0) {
    kembali_dengan_error("Data pengguna tidak valid.");
}

/*
|--------------------------------------------------------------------------
| Validasi deskripsi
|--------------------------------------------------------------------------
*/

if ($deskripsi_jobdesc === '') {
    kembali_dengan_error("Deskripsi jobdesc wajib diisi.");
}

/*
|--------------------------------------------------------------------------
| Validasi sasaran mahasiswa
|--------------------------------------------------------------------------
*/

$penerima_valid = [
    'Semua Mahasiswa',
    'Mahasiswa dengan Jam Minus'
];

if (
    !in_array(
        $penerima_jobdesc,
        $penerima_valid,
        true
    )
) {
    kembali_dengan_error("Sasaran mahasiswa tidak valid.");
}

/*
|--------------------------------------------------------------------------
| Validasi jam plus
|--------------------------------------------------------------------------
*/

if ($jam_plus_input === '') {
    kembali_dengan_error("Jam plus wajib diisi.");
}

if (
    !preg_match(
        '/^\d{1,4}(\.\d)?$/',
        $jam_plus_input
    )
) {
    kembali_dengan_error("Jam plus hanya boleh memiliki satu angka di belakang koma.");
}

$jam_plus = (float) $jam_plus_input;

if (
    $jam_plus < 0.1 ||
    $jam_plus > 1000.0
) {
    kembali_dengan_error("Jam plus harus antara 0,1 sampai 1000,0.");
}

/*
|--------------------------------------------------------------------------
| Validasi tanggal
|--------------------------------------------------------------------------
*/

if ($tanggal_input === '') {
    kembali_dengan_error("Tanggal pemberian jobdesc wajib diisi.");
}

$tanggal_jobdesc = DateTime::createFromFormat(
    'Y-m-d\TH:i',
    $tanggal_input
);

$format_tanggal_valid =
    $tanggal_jobdesc !== false &&
    $tanggal_jobdesc->format('Y-m-d\TH:i')
        === $tanggal_input;

if (!$format_tanggal_valid) {
    kembali_dengan_error("Format tanggal pemberian jobdesc tidak valid.");
}

$waktu_sekarang = new DateTime();

$waktu_sekarang->setTime(
    (int) $waktu_sekarang->format('H'),
    (int) $waktu_sekarang->format('i'),
    0
);

if ($tanggal_jobdesc < $waktu_sekarang) {
    kembali_dengan_error("Tanggal pemberian jobdesc tidak boleh menggunakan tanggal atau waktu lampau.");
}

$tanggal_pemberian_jobdesc =
    $tanggal_jobdesc->format('Y-m-d H:i:s');

/*
|--------------------------------------------------------------------------
| Validasi jumlah mahasiswa
|--------------------------------------------------------------------------
*/

if (
    $jumlah_mahasiswa_input === '' ||
    !ctype_digit($jumlah_mahasiswa_input)
) {
    kembali_dengan_error("Jumlah mahasiswa harus berupa angka bulat.");
}

$jumlah_mahasiswa_diperlukan =
    (int) $jumlah_mahasiswa_input;

if ($jumlah_mahasiswa_diperlukan < 1) {
    kembali_dengan_error("Jumlah mahasiswa minimal 1.");
}

/*
|--------------------------------------------------------------------------
| Simpan melalui stored procedure
|--------------------------------------------------------------------------
*/

$sql = "
    CALL usp_insert_bursa_jobdesc(
        ?,
        ?,
        ?,
        ?,
        ?,
        ?
    )
";

$stmt = mysqli_prepare($koneksi, $sql);

if (!$stmt) {
    kembali_dengan_error("Gagal menyiapkan penyimpanan jobdesc.");
}

mysqli_stmt_bind_param(
    $stmt,
    "issdsi",
    $id_pengguna,
    $deskripsi_jobdesc,
    $penerima_jobdesc,
    $jam_plus,
    $tanggal_pemberian_jobdesc,
    $jumlah_mahasiswa_diperlukan
);

if (!mysqli_stmt_execute($stmt)) {
    $pesan_error = pesan_error_statement($stmt, 'Bursa jobdesc gagal disimpan.');

    mysqli_stmt_close($stmt);

    kembali_dengan_error(
        $pesan_error !== '' ? $pesan_error : "Bursa jobdesc gagal disimpan."
    );
}

mysqli_stmt_close($stmt);

header("Location: index.php?status=berhasil_tambah");
exit;