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
?>