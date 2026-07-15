<?php
function arahkan_dashboard($role)
{
    if ($role == "Mahasiswa") {
        return "dashboard/dashboard_mahasiswa.php";
    }

    if ($role == "Pengajar") {
        return "dashboard/dashboard_pengajar.php";
    }

    if ($role == "PIC Tata Tertib") {
        return "dashboard/dashboard_pic_tata_tertib.php";
    }

    if ($role == "PIC Aset Fasilitas") {
        return "dashboard/dashboard_pic_aset_fasilitas.php";
    }

    if ($role == "PIC Kemahasiswaan") {
        return "dashboard/dashboard_pic_kemahasiswaan.php";
    }

    if ($role == "Kepala Prodi") {
        return "dashboard/dashboard_kepala_prodi.php";
    }

    return "login.php";
}

function aman($data)
{
    return htmlspecialchars($data ?? '', ENT_QUOTES, 'UTF-8');
}

/**
 * Mengembalikan pesan validasi dari SIGNAL SQLSTATE 45000, tetapi tidak
 * membocorkan detail teknis database untuk kegagalan lain.
 */
function pesan_error_statement($stmt, $pesan_umum)
{
    $pesan = trim((string) mysqli_stmt_error($stmt));
    $sqlstate = (string) mysqli_stmt_sqlstate($stmt);

    if ($pesan !== '') {
        error_log('Database statement error [' . $sqlstate . ']: ' . $pesan);
    }

    return $sqlstate === '45000' && $pesan !== ''
        ? $pesan
        : $pesan_umum;
}

function pesan_error_koneksi($koneksi, $pesan_umum)
{
    $pesan = trim((string) mysqli_error($koneksi));
    if ($pesan !== '') {
        error_log('Database connection/query error: ' . $pesan);
    }
    return $pesan_umum;
}

function ambil_data_procedure($koneksi, $sql)
{
    $data = [];

    $query = mysqli_query($koneksi, $sql);

    if ($query) {
        while ($row = mysqli_fetch_assoc($query)) {
            $data[] = $row;
        }

        mysqli_free_result($query);
        bersihkan_hasil_procedure($koneksi);
    }

    return $data;
}


function url_http_valid($url, $maksimal_panjang = 2048)
{
    $url = trim((string) $url);
    if ($url === '' || mb_strlen($url) > $maksimal_panjang) {
        return false;
    }

    if (filter_var($url, FILTER_VALIDATE_URL) === false) {
        return false;
    }

    $skema = strtolower((string) parse_url($url, PHP_URL_SCHEME));
    return in_array($skema, ['http', 'https'], true);
}

function format_jam($nilai)
{
    $hasil = number_format((float) $nilai, 2, ',', '.');
    $hasil = rtrim($hasil, '0');
    return rtrim($hasil, ',');
}

function bersihkan_hasil_procedure($koneksi)
{
    while (mysqli_more_results($koneksi) && mysqli_next_result($koneksi)) {
        if ($hasil = mysqli_store_result($koneksi)) {
            mysqli_free_result($hasil);
        }
    }
}

function ambil_satu_procedure_prepared($koneksi, $sql, $types = '', array $params = [])
{
    $stmt = mysqli_prepare($koneksi, $sql);
    if (!$stmt) {
        return null;
    }

    if ($types !== '') {
        $referensi = [];
        foreach ($params as $key => $value) {
            $params[$key] = $value;
            $referensi[$key] = &$params[$key];
        }
        mysqli_stmt_bind_param($stmt, $types, ...$referensi);
    }

    if (!mysqli_stmt_execute($stmt)) {
        mysqli_stmt_close($stmt);
        bersihkan_hasil_procedure($koneksi);
        return null;
    }

    $result = mysqli_stmt_get_result($stmt);
    $row = $result ? mysqli_fetch_assoc($result) : null;
    if ($result) {
        mysqli_free_result($result);
    }
    mysqli_stmt_close($stmt);
    bersihkan_hasil_procedure($koneksi);
    return $row;
}

function ambil_data_procedure_prepared($koneksi, $sql, $types = '', array $params = [])
{
    $stmt = mysqli_prepare($koneksi, $sql);
    if (!$stmt) {
        return [];
    }

    if ($types !== '') {
        $referensi = [];
        foreach ($params as $key => $value) {
            $params[$key] = $value;
            $referensi[$key] = &$params[$key];
        }
        mysqli_stmt_bind_param($stmt, $types, ...$referensi);
    }

    if (!mysqli_stmt_execute($stmt)) {
        mysqli_stmt_close($stmt);
        bersihkan_hasil_procedure($koneksi);
        return [];
    }

    $data = [];
    $result = mysqli_stmt_get_result($stmt);
    if ($result) {
        while ($row = mysqli_fetch_assoc($result)) {
            $data[] = $row;
        }
        mysqli_free_result($result);
    }

    mysqli_stmt_close($stmt);
    bersihkan_hasil_procedure($koneksi);
    return $data;
}


/**
 * Mengubah string kosong menjadi NULL agar UNIQUE constraint tetap dapat
 * menerima lebih dari satu data tanpa email/no HP.
 */
function nilai_nullable($nilai)
{
    $nilai = trim((string) ($nilai ?? ''));
    return $nilai === '' ? null : $nilai;
}

/**
 * Nomor HP bersifat opsional. Jika diisi, hanya angka dan panjangnya 10-13 digit.
 */
function nomor_hp_valid($nomor_hp)
{
    if ($nomor_hp === null || $nomor_hp === '') {
        return true;
    }

    return preg_match('/^[0-9]{10,13}$/', (string) $nomor_hp) === 1;
}

/**
 * Format tahun akademik yang diterima: YYYY/YYYY, dengan tahun kedua
 * sama dengan tahun pertama + 1.
 */
function pecah_tahun_akademik($tahun_akademik)
{
    $tahun_akademik = trim((string) $tahun_akademik);

    if (preg_match('/^(\d{4})\/(\d{4})$/', $tahun_akademik, $cocok) !== 1) {
        return null;
    }

    $tahun_awal = (int) $cocok[1];
    $tahun_akhir = (int) $cocok[2];

    if ($tahun_akhir !== $tahun_awal + 1) {
        return null;
    }

    return [$tahun_awal, $tahun_akhir];
}

/**
 * Memastikan rentang tanggal valid dan kedua tanggal masih berada di dalam
 * dua tahun yang dinyatakan oleh tahun akademik.
 */
function periode_akademik_valid($tahun_akademik, $tanggal_mulai, $tanggal_selesai, &$pesan_error = null)
{
    $tahun = pecah_tahun_akademik($tahun_akademik);

    if ($tahun === null) {
        $pesan_error = 'Tahun akademik harus menggunakan format YYYY/YYYY dan tahun kedua harus satu tahun setelah tahun pertama.';
        return false;
    }

    $mulai = DateTime::createFromFormat('!Y-m-d', (string) $tanggal_mulai);
    $selesai = DateTime::createFromFormat('!Y-m-d', (string) $tanggal_selesai);
    $mulai_valid = $mulai && $mulai->format('Y-m-d') === $tanggal_mulai;
    $selesai_valid = $selesai && $selesai->format('Y-m-d') === $tanggal_selesai;

    if (!$mulai_valid || !$selesai_valid) {
        $pesan_error = 'Tanggal mulai dan tanggal selesai harus berupa tanggal yang valid.';
        return false;
    }

    if ($mulai >= $selesai) {
        $pesan_error = 'Tanggal mulai harus lebih kecil dari tanggal selesai.';
        return false;
    }

    [$tahun_awal, $tahun_akhir] = $tahun;
    $tahun_mulai = (int) $mulai->format('Y');
    $tahun_selesai = (int) $selesai->format('Y');

    if (
        $tahun_mulai < $tahun_awal || $tahun_mulai > $tahun_akhir ||
        $tahun_selesai < $tahun_awal || $tahun_selesai > $tahun_akhir
    ) {
        $pesan_error = 'Tanggal mulai dan tanggal selesai harus berada di dalam tahun akademik yang dipilih.';
        return false;
    }

    return true;
}

function rentang_filter_tanggal($jenis, $nilai, &$pesan_error = null)
{
    $jenis = (string) $jenis;
    $nilai = trim((string) $nilai);
    if ($jenis === '' || $jenis === 'semua') {
        return [null, null];
    }
    if ($jenis === 'tanggal' && preg_match('/^\d{4}-\d{2}-\d{2}$/', $nilai)) {
        $tanggal = DateTime::createFromFormat('!Y-m-d', $nilai);
        if ($tanggal && $tanggal->format('Y-m-d') === $nilai) {
            return [$nilai, $nilai];
        }
    }
    if ($jenis === 'bulan' && preg_match('/^(\d{4})-(\d{2})$/', $nilai, $cocok)) {
        $awal = DateTime::createFromFormat('!Y-m-d', $nilai . '-01');
        if ($awal && $awal->format('Y-m') === $nilai) {
            return [$awal->format('Y-m-01'), $awal->format('Y-m-t')];
        }
    }
    if ($jenis === 'tahun' && preg_match('/^\d{4}$/', $nilai)) {
        return [$nilai . '-01-01', $nilai . '-12-31'];
    }
    $pesan_error = 'Nilai filter tanggal, bulan, atau tahun tidak valid.';
    return false;
}

function tanggal_sekarang_dalam_periode($tanggal_mulai, $tanggal_selesai)
{
    $hari_ini = date('Y-m-d');
    return $hari_ini >= $tanggal_mulai && $hari_ini <= $tanggal_selesai;
}
?>
