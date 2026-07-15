<?php
require_once "../config/koneksi.php";
require_once "../config/function.php";
require_once "../includes/auth_dashboard.php";

cek_role_dashboard("PIC Aset Fasilitas");

$page_title = "Dashboard";
$active_menu = "dashboard";


$id_pengguna = (int) ($_SESSION['id_pengguna'] ?? 0);
$ringkasan = ambil_satu_procedure_prepared($koneksi, "CALL usp_dashboard_ringkasan(?)", "i", [$id_pengguna]) ?? [];
$total_pengguna = (int) ($ringkasan['total_pengguna'] ?? 0);
$total_mahasiswa = (int) ($ringkasan['total_mahasiswa'] ?? 0);
$total_pengajar = (int) ($ringkasan['total_pengajar'] ?? 0);
$total_fasilitas = (int) ($ringkasan['total_fasilitas'] ?? 0);
$total_pengaduan = (int) ($ringkasan['total_pengaduan'] ?? 0);
$pengaduan_menunggu = (int) ($ringkasan['pengaduan_menunggu'] ?? 0);
$jobdesc_saya = (int) ($ringkasan['jobdesc_saya'] ?? 0);
$bursa_jobdesc_tersedia = (int) ($ringkasan['jobdesc_tersedia'] ?? 0);
$fasilitas_rusak = (int) ($ringkasan['fasilitas_rusak'] ?? 0);

require_once "../includes/dashboard_header.php";
?>

<div class="outer-container">
    <?php require_once "../includes/sidebar.php"; ?>
    <main class="main-content">
        <div class="topbar">
            <h1 class="page-title">Dashboard</h1>

            <div class="user-info">
                <div class="user-detail">
                    <div class="user-name"><?= aman($_SESSION['username']); ?></div>
                    <div class="user-role"><?= aman($_SESSION['role']); ?></div>
                </div>
                <div class="user-avatar">
                    <?= strtoupper(substr($_SESSION['username'], 0, 1)); ?>
                </div>
            </div>
        </div>

        <div class="content-wrapper">
            <div class="welcome-card">
                <h2 class="fw-bold mb-2">Selamat Datang, <?= aman($_SESSION['username']); ?> 🎓</h2>
                <p class="text-muted mb-0">
                    Kelola aktivitas Bursa Jobdesc, Pengaduan Fasilitas dan Pengajuan Jam Plus melalui sistem ini.
                </p>
            </div>

            <div class="row g-3">
                <div class="col-md-4">
                    <div class="stat-card">
                        <div class="stat-icon">
                            <i class="fa-solid fa-clipboard-list"></i>
                        </div>
                        <div class="stat-label">Jobdesc Saya</div>
                        <h3 class="stat-value"><?= $jobdesc_saya; ?></h3>
                        <div class="stat-desc">Data jobdesc yang saya buat</div>
                    </div>
                </div>

                <div class="col-md-4">
                    <div class="stat-card">
                        <div class="stat-icon">
                            <i class="fa-solid fa-briefcase"></i>
                        </div>
                        <div class="stat-label">Jobdesc Tersedia</div>
                        <h3 class="stat-value"><?= $bursa_jobdesc_tersedia; ?></h3>
                        <div class="stat-desc">Data jobdesc yang tersedia</div>
                    </div>
                </div>

                <div class="col-md-4">
                    <div class="stat-card">
                        <div class="stat-icon">
                            <i class="fa-solid fa-boxes-stacked"></i>
                        </div>
                        <div class="stat-label">Total Fasilitas</div>
                        <h3 class="stat-value"><?= $total_fasilitas; ?></h3>
                        <div class="stat-desc">Fasilitas yang tercatat di sistem</div>

                    </div>
                </div>

                <div class="col-md-4">
                    <div class="stat-card">
                        <div class="stat-icon">
                            <i class="fa-solid fa-wrench"></i>
                        </div>
                        <div class="stat-label">Fasilitas Rusak</div>
                        <h3 class="stat-value"><?= $fasilitas_rusak; ?></h3>
                        <div class="stat-desc">Fasilitas yang dalam kondisi rusak</div>
                    </div>
                </div>

                <div class="col-md-4">
                    <div class="stat-card">
                        <div class="stat-icon">
                            <i class="fa-solid fa-clock"></i>
                        </div>
                        <div class="stat-label">Menunggu Verifikasi</div>
                        <h3 class="stat-value"><?= $pengaduan_menunggu; ?></h3>
                        <div class="stat-desc">Pengaduan yang belum diverifikasi</div>
                    </div>
                </div>
            </div>
        </div>
    </main>
</div>



<?php require_once "../includes/dashboard_footer.php"; ?>