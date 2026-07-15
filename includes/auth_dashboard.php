<?php
require_once __DIR__ . '/../config/function.php';
if (session_status() === PHP_SESSION_NONE) {
    ini_set('session.cookie_httponly', '1');
    ini_set('session.cookie_samesite', 'Lax');
    if (!empty($_SERVER['HTTPS']) && $_SERVER['HTTPS'] !== 'off') {
        ini_set('session.cookie_secure', '1');
    }
    session_start();
}

$waktu_sekarang = time();
$batas_idle = 7200;

if (
    !isset($_SESSION['id_pengguna']) ||
    (isset($_SESSION['aktivitas_terakhir']) && $waktu_sekarang - (int) $_SESSION['aktivitas_terakhir'] > $batas_idle)
) {
    $_SESSION = [];
    session_destroy();
    header("Location: /SIMAT/login.php");
    exit;
}

$_SESSION['aktivitas_terakhir'] = $waktu_sekarang;

/* Status akun dan identitas diperiksa ulang agar session lama tidak dapat
 * dipakai setelah akun/mahasiswa/pengajar dinonaktifkan atau role diubah. */
$stmt_session = mysqli_prepare($koneksi, "CALL usp_validasi_session_pengguna(?)");
$data_session = null;
if ($stmt_session) {
    $id_session = (int) $_SESSION['id_pengguna'];
    mysqli_stmt_bind_param($stmt_session, 'i', $id_session);
    if (mysqli_stmt_execute($stmt_session)) {
        $hasil_session = mysqli_stmt_get_result($stmt_session);
        $data_session = $hasil_session ? mysqli_fetch_assoc($hasil_session) : null;
        if ($hasil_session) {
            mysqli_free_result($hasil_session);
        }
    }
    mysqli_stmt_close($stmt_session);
    while (mysqli_more_results($koneksi) && mysqli_next_result($koneksi)) {
        $sisa_session = mysqli_store_result($koneksi);
        if ($sisa_session) {
            mysqli_free_result($sisa_session);
        }
    }
}

if (!$data_session) {
    $_SESSION = [];
    session_destroy();
    header("Location: /SIMAT/login.php");
    exit;
}

$_SESSION['id_mahasiswa'] = $data_session['id_mahasiswa'];
$_SESSION['id_pengajar'] = $data_session['id_pengajar'];
$_SESSION['username'] = $data_session['username'];
$_SESSION['role'] = $data_session['role'];



function cek_role_dashboard($role_diizinkan)
{
    if (($_SESSION['role'] ?? '') !== $role_diizinkan) {
        header("Location: /SIMAT/index.php");
        exit;
    }
}

function cek_role_bukan_mahasiswa()
{
    if (!isset($_SESSION['role']) || $_SESSION['role'] === '' || $_SESSION['role'] === 'Mahasiswa') {
        header("Location: /SIMAT/index.php");
        exit;
    }
}

function boleh_membuat_jobdesc($role)
{
    return in_array($role, [
        'Pengajar',
        'Kepala Prodi',
        'PIC Tata Tertib',
        'PIC Aset Fasilitas',
        'PIC Kemahasiswaan'
    ], true);
}

function cek_role_pembuat_jobdesc()
{
    if (!boleh_membuat_jobdesc($_SESSION['role'] ?? '')) {
        header("Location: /SIMAT/index.php");
        exit;
    }
}
?>
