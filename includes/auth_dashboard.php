<?php
if (session_status() === PHP_SESSION_NONE) {
    session_start();
}

if (!isset($_SESSION['id_pengguna'])) {
    header("Location: /SIMAT/login.php");
    exit;
}

function cek_role_dashboard($role_diizinkan)
{
    if ($_SESSION['role'] != $role_diizinkan) {
        header("Location: /SIMAT/index.php");
        exit;
    }
}

function cek_role_bukan_mahasiswa()
{
    if (
        !isset($_SESSION['role']) ||
        $_SESSION['role'] == '' ||
        $_SESSION['role'] == 'Mahasiswa'
    ) {
        header("Location: /SIMAT/index.php");
        exit;
    }
}

function boleh_membuat_jobdesc($role) {
    $role_pembuat_jobdesc = [
        'Pengajar',
        'Kepala Prodi',
        'PIC Tata Tertib',
        'PIC Aset Fasilitas',
        'PIC Kemahasiswaan'
    ];
    return in_array($role, $role_pembuat_jobdesc, true);
}

function cek_role_pembuat_jobdesc() {
    $role = $_SESSION['role'] ?? '';

    if (!boleh_membuat_jobdesc($role)) {
        header("Location: /SIMAT/index.php");
        exit;
    }
}
?>