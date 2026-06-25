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



function ambil_data_procedure($koneksi, $sql)
{
    $data = [];

    $query = mysqli_query($koneksi, $sql);

    if ($query) {
        while ($row = mysqli_fetch_assoc($query)) {
            $data[] = $row;
        }

        mysqli_free_result($query);
        mysqli_next_result($koneksi);
    }

    return $data;
}
?>