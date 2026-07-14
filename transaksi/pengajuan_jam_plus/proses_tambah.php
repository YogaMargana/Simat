<?php
require_once "../../config/koneksi.php";
require_once "../../includes/auth_dashboard.php";

// Hanya Mahasiswa yang boleh mengirim pengajuan jam plus
if (($_SESSION['role'] ?? '') !== "Mahasiswa") {
    header("Location: /SIMAT/index.php");
    exit;
}

// Proses hanya dijalankan melalui tombol Kirim Pengajuan
if (
    $_SERVER['REQUEST_METHOD'] !== 'POST' ||
    !isset($_POST['simpan'])
) {
    header("Location: index.php");
    exit;
}

$id_pengguna = (int) ($_SESSION['id_pengguna'] ?? 0);

$jumlah_jam_input = str_replace(
    ',',
    '.',
    trim($_POST['jumlah_jam_plus'] ?? '')
);

$jenis_jam = trim($_POST['jenis_jam'] ?? '');
$sumber_jam = trim($_POST['sumber_jam'] ?? '');

$deskripsi = trim(
    $_POST['deskripsi_pekerjaan'] ?? ''
);

$nama_pemberi = trim(
    $_POST['nama_pemberi'] ?? ''
);

$dokumen_url = trim(
    $_POST['dokumen_url'] ?? ''
);

/*
|--------------------------------------------------------------------------
| Validasi pengguna
|--------------------------------------------------------------------------
*/

if ($id_pengguna <= 0) {
    header(
        "Location: tambah.php?error=" .
        urlencode("Data pengguna tidak valid.")
    );
    exit;
}

/*
|--------------------------------------------------------------------------
| Validasi jumlah jam plus
|--------------------------------------------------------------------------
*/

if ($jumlah_jam_input === '') {
    header(
        "Location: tambah.php?error=" .
        urlencode("Jumlah jam plus wajib diisi.")
    );
    exit;
}

if (!preg_match('/^\d{1,4}(\.\d)?$/', $jumlah_jam_input)) {
    header(
        "Location: tambah.php?error=" .
        urlencode(
            "Jumlah jam plus hanya boleh memiliki satu angka " .
            "di belakang koma."
        )
    );
    exit;
}

$jumlah_jam_plus = (float) $jumlah_jam_input;

if (
    $jumlah_jam_plus < 0.1 ||
    $jumlah_jam_plus > 1000.0
) {
    header(
        "Location: tambah.php?error=" .
        urlencode(
            "Jumlah jam plus harus antara 0,1 sampai 1000,0."
        )
    );
    exit;
}

/*
|--------------------------------------------------------------------------
| Validasi jenis jam
|--------------------------------------------------------------------------
*/

if (
    !in_array(
        $jenis_jam,
        ['Murni', 'Kompensasi'],
        true
    )
) {
    header(
        "Location: tambah.php?error=" .
        urlencode("Jenis jam wajib dipilih.")
    );
    exit;
}

/*
|--------------------------------------------------------------------------
| Validasi sumber jam
|--------------------------------------------------------------------------
*/

if (
    !in_array(
        $sumber_jam,
        ['Prodi', 'Luar'],
        true
    )
) {
    header(
        "Location: tambah.php?error=" .
        urlencode("Sumber jam wajib dipilih.")
    );
    exit;
}

/*
|--------------------------------------------------------------------------
| Validasi kegiatan
|--------------------------------------------------------------------------
*/

if ($sumber_jam === 'Luar') {
    $id_kegiatan = (int) (
        $_POST['id_kegiatan'] ?? 0
    );

    if ($id_kegiatan <= 0) {
        header(
            "Location: tambah.php?error=" .
            urlencode(
                "Kegiatan wajib dipilih jika sumber jam " .
                "berasal dari luar Prodi."
            )
        );
        exit;
    }
} else {
    $id_kegiatan = null;
}

/*
|--------------------------------------------------------------------------
| Validasi data pekerjaan
|--------------------------------------------------------------------------
*/

if ($nama_pemberi === '') {
    header(
        "Location: tambah.php?error=" .
        urlencode("Nama pemberi tugas wajib diisi.")
    );
    exit;
}

if (strlen($nama_pemberi) > 50) {
    header(
        "Location: tambah.php?error=" .
        urlencode(
            "Nama pemberi tugas maksimal 50 karakter."
        )
    );
    exit;
}

if ($deskripsi === '') {
    header(
        "Location: tambah.php?error=" .
        urlencode("Deskripsi pekerjaan wajib diisi.")
    );
    exit;
}

/*
|--------------------------------------------------------------------------
| Validasi dokumen bukti
|--------------------------------------------------------------------------
*/

if ($dokumen_url === '') {
    header(
        "Location: tambah.php?error=" .
        urlencode("Tautan dokumen bukti wajib diisi.")
    );
    exit;
}

if (strlen($dokumen_url) > 2048) {
    header(
        "Location: tambah.php?error=" .
        urlencode(
            "Tautan dokumen bukti maksimal 2048 karakter."
        )
    );
    exit;
}

if (
    filter_var(
        $dokumen_url,
        FILTER_VALIDATE_URL
    ) === false
) {
    header(
        "Location: tambah.php?error=" .
        urlencode(
            "Format tautan dokumen bukti tidak valid."
        )
    );
    exit;
}

/*
|--------------------------------------------------------------------------
| Menjalankan stored procedure
|--------------------------------------------------------------------------
*/

$sql = "
    CALL usp_insert_pengajuan_jam_plus(
        ?,
        ?,
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
    header(
        "Location: tambah.php?error=" .
        urlencode(
            "Gagal menyiapkan proses penyimpanan data."
        )
    );
    exit;
}

mysqli_stmt_bind_param(
    $stmt,
    "iidsssss",
    $id_pengguna,
    $id_kegiatan,
    $jumlah_jam_plus,
    $jenis_jam,
    $sumber_jam,
    $deskripsi,
    $nama_pemberi,
    $dokumen_url
);

if (mysqli_stmt_execute($stmt)) {
    mysqli_stmt_close($stmt);

    header(
        "Location: index.php?status=berhasil_tambah"
    );
    exit;
}

$error = mysqli_stmt_error($stmt);

mysqli_stmt_close($stmt);

header(
    "Location: tambah.php?error=" .
    urlencode(
        $error !== ''
            ? $error
            : "Pengajuan jam plus gagal disimpan."
    )
);
exit;