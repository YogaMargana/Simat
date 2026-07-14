<?php
$active_menu = $active_menu ?? "";
$role = $_SESSION['role'] ?? "";

$dashboard_link = "/SIMAT/dashboard/dashboard_mahasiswa.php";

if ($role == "Pengajar") {
    $dashboard_link = "/SIMAT/dashboard/dashboard_pengajar.php";
} elseif ($role == "PIC Tata Tertib") {
    $dashboard_link = "/SIMAT/dashboard/dashboard_pic_tata_tertib.php";
} elseif ($role == "PIC Aset Fasilitas") {
    $dashboard_link = "/SIMAT/dashboard/dashboard_pic_aset_fasilitas.php";
} elseif ($role == "PIC Kemahasiswaan") {
    $dashboard_link = "/SIMAT/dashboard/dashboard_pic_kemahasiswaan.php";
} elseif ($role == "Kepala Prodi") {
    $dashboard_link = "/SIMAT/dashboard/dashboard_kepala_prodi.php";
}
?>

<aside class="sidebar">

    <div class="sidebar-brand">
        <div class="brand-title">SIM<span>A</span>T</div>
    </div>

    <nav class="sidebar-menu">
        <a href="<?= $dashboard_link; ?>" class="menu-link <?= $active_menu == 'dashboard' ? 'active' : ''; ?>">
            <i class="fa-solid fa-house"></i>
            <span>Dashboard</span>
        </a>

        <?php if ($role != "") { ?>

            <a href="/SIMAT/transaksi/bursa_jobdesc/index.php" class="menu-link <?= $active_menu == 'bursa_jobdesc' ? 'active' : ''; ?>">
                <i class="fa-solid fa-briefcase"></i>
                <span>Bursa Jobdesc</span>
            </a>

        <?php } ?>

        <?php if ($role != "" && $role != "Mahasiswa") { ?>

            <a href="/SIMAT/laporan/bursa_jobdesc/index.php" class="menu-link <?= $active_menu == 'laporan_bursa_jobdesc' ? 'active' : ''; ?>">
                <i class="fa-solid fa-file-lines"></i>
                <span>Laporan Bursa Jobdesc</span>
            </a>

        <?php } ?>

        <?php if ($role == "Kepala Prodi") { ?>

            <a href="/SIMAT/master/pengguna/index.php" class="menu-link <?= $active_menu == 'pengguna' ? 'active' : ''; ?>">
                <i class="fa-solid fa-users"></i>
                <span>Data Pengguna</span>
            </a>

            <a href="/SIMAT/master/pengajar/index.php" class="menu-link <?= $active_menu == 'pengajar' ? 'active' : ''; ?>">
                <i class="fa-solid fa-chalkboard-user"></i>
                <span>Data Pengajar</span>
            </a>

            <a href="/SIMAT/master/mahasiswa/index.php" class="menu-link <?= $active_menu == 'mahasiswa' ? 'active' : ''; ?>">
                <i class="fa-solid fa-user-graduate"></i>
                <span>Data Mahasiswa</span>
            </a>

            <a href="/SIMAT/master/kelas/index.php" class="menu-link <?= $active_menu == 'kelas' ? 'active' : ''; ?>">
                <i class="fa-solid fa-door-open"></i>
                <span>Data Kelas</span>
            </a>

            <a href="/SIMAT/master/periode_akademik/index.php" class="menu-link <?= $active_menu == 'periode_akademik' ? 'active' : ''; ?>">
                <i class="fa-solid fa-calendar-days"></i>
                <span>Periode Akademik</span>
            </a>

            <a href="/SIMAT/master/mata_kuliah/index.php" class="menu-link <?= $active_menu == 'mata_kuliah' ? 'active' : ''; ?>">
                <i class="fa-solid fa-calendar-days"></i>
                <span>Mata Kuliah</span>
            </a>

        <!-- Sidebar Penentuan 2 Pengajar Pada Suatu Mata Kuliah Pada Suatu Kelas -->
            <a href="/SIMAT/master/pengajar_mata_kuliah/index.php" class="menu-link <?= $active_menu == 'pengajar_mata_kuliah' ? 'active' : ''; ?>">
                <i class="fa-solid fa-book-open-reader"></i>
                <span>Pengajar Mata Kuliah</span>
            </a>
        <!-- Sidebar Penentuan 2 Pengajar Pada Suatu Mata Kuliah Pada Suatu Kelas -->

        <?php } ?>

        <?php if ($role == "PIC Aset Fasilitas") { ?>

            <a href="/SIMAT/master/fasilitas/index.php" class="menu-link <?= $active_menu == 'fasilitas' ? 'active' : ''; ?>">
                <i class="fa-solid fa-boxes-stacked"></i>
                <span>Data Fasilitas</span>
            </a>
            
            <a href="/SIMAT/transaksi/pengaduan_kerusakan_fasilitas/index.php" class="menu-link <?= $active_menu == 'pengaduan_fasilitas' ? 'active' : ''; ?>">
                <i class="fa-solid fa-triangle-exclamation"></i>
                <span>Pengaduan Fasilitas</span>
            </a>

        <!-- Sidebar Fasilitas Kelas -->
            <a href="/SIMAT/master/fasilitas_kelas/index.php" class="menu-link <?= $active_menu == 'fasilitas_kelas' ? 'active' : ''; ?>">
                <i class="fa-solid fa-school"></i>
                <span>Fasilitas Kelas</span>
            </a>
        <!-- Sidebar Fasilitas Kelas -->

            <a href="/SIMAT/laporan/pengaduan_fasilitas/index.php" class="menu-link <?= $active_menu == 'laporan_pengaduan_fasilitas' ? 'active' : ''; ?>">
                <i class="fa-solid fa-file-lines"></i>
                <span>Laporan Pengaduan</span>
            </a>

        <?php } ?>

        <?php if ($role == "PIC Tata Tertib") { ?>

            <!-- Pengajuan Jam Plus -->
            <a
                href="/SIMAT/transaksi/pengajuan_jam_plus/index.php"

                class="menu-link
                <?= $active_menu == 'pengajuan_jam_plus'
                    ? 'active'
                    : ''; ?>"
            >
                <i class="fa-solid fa-circle-plus"></i>

                <span>Pengajuan Jam Plus</span>
            </a>

            <!-- Pemberian Jam Minus -->
            <a
                href="/SIMAT/transaksi/pemberian_jam_minus/index.php"

                class="menu-link
                <?= $active_menu == 'pemberian_jam_minus'
                    ? 'active'
                    : ''; ?>"
            >
                <i class="fa-solid fa-circle-minus"></i>

                <span>Pemberian Jam Minus</span>
            </a>

            <!-- Laporan Total Jam Mahasiswa -->
            <a
                href="/SIMAT/laporan/total_jam_mahasiswa/index.php"
                class="menu-link
                <?= $active_menu == 'laporan_total_jam_mahasiswa'
                    ? 'active'
                    : ''; ?>"
            >
                <i class="fa-solid fa-file-pdf"></i>

                <span>Laporan Total Jam</span>
            </a>

        <?php } ?>

        <?php if ($role == "PIC Kemahasiswaan") { ?>

            <a href="/SIMAT/master/kegiatan/index.php" class="menu-link <?= $active_menu == 'kegiatan' ? 'active' : ''; ?>">
                <i class="fa-solid fa-calendar-days"></i>
                <span>Data Kegiatan</span>
            </a>

        <?php } ?>

        <?php if ($role == "Mahasiswa") { ?>

            <a href="/SIMAT/transaksi/pengaduan_kerusakan_fasilitas/index.php" class="menu-link <?= $active_menu == 'pengaduan_fasilitas' ? 'active' : ''; ?>">
                <i class="fa-solid fa-triangle-exclamation"></i>
                <span>Pengaduan Saya</span>
            </a>

        <!-- Sidebar Penentuan 2 Pengajar Pada Suatu Mata Kuliah Pada Suatu Kelas -->
            <a href="/SIMAT/transaksi/mata_kuliah_saya/index.php" class="menu-link <?= $active_menu == 'mata_kuliah_saya' ? 'active' : ''; ?>">
                <i class="fa-solid fa-book"></i>
                <span>Mata Kuliah Saya</span>
            </a>
        <!-- Sidebar Penentuan 2 Pengajar Pada Suatu Mata Kuliah Pada Suatu Kelas -->
            
        <!-- Sidebar Pengajuan Jam Plus -->
            <a href="/SIMAT/transaksi/pengajuan_jam_plus/index.php" class="menu-link <?= $active_menu == 'pengajuan_jam_plus' ? 'active' : ''; ?>">
                <i class="fa-solid fa-circle-plus"></i>
                <span>Pengajuan Jam Plus</span>
            </a>
        <!-- Sidebar Pengajuan Jam Plus -->

        <?php } ?>
    </nav>

    <div class="sidebar-footer">
        <a href="/SIMAT/logout.php" class="logout-btn">
            <i class="fa-solid fa-right-from-bracket"></i>
            <span>Keluar</span>
        </a>
    </div>
</aside>