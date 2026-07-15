<?php
require_once "../config/koneksi.php";
require_once "../config/function.php";
require_once "../includes/auth_dashboard.php";

cek_role_dashboard("Mahasiswa");

$page_title = "Dashboard";
$active_menu = "dashboard";

$id_pengguna = (int) ($_SESSION['id_pengguna'] ?? 0);
$ringkasan = ambil_satu_procedure_prepared(
    $koneksi,
    "CALL usp_dashboard_ringkasan(?)",
    "i",
    [$id_pengguna]
) ?? [];

$pengaduan_saya = (int) ($ringkasan['pengaduan_saya'] ?? 0);
$pengaduan_menunggu_saya = (int) ($ringkasan['pengaduan_menunggu_saya'] ?? 0);
$jobdesc_tersedia = (int) ($ringkasan['jobdesc_tersedia'] ?? 0);
$jam_plus_menunggu = (int) ($ringkasan['jam_plus_menunggu'] ?? 0);
$total_jam_kompensasi = (float) ($ringkasan['total_jam_kompensasi_mahasiswa'] ?? 0);
$total_jam_murni = (float) ($ringkasan['total_jam_murni_mahasiswa'] ?? 0);
$total_jam_mahasiswa = (float) ($ringkasan['total_jam_mahasiswa'] ?? 0);

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
                            <i class="fa-solid fa-scale-balanced"></i>
                        </div>
                        <div class="stat-label">Total Jam Kompensasi</div>
                        <h3 class="stat-value"><?= format_jam($total_jam_kompensasi); ?> Jam</h3>
                        <div class="stat-desc">Selisih jam plus dan minus kompensasi</div>
                    </div>
                </div>

                <div class="col-md-4">
                    <div class="stat-card">
                        <div class="stat-icon">
                            <i class="fa-solid fa-clock-rotate-left"></i>
                        </div>
                        <div class="stat-label">Total Jam Murni</div>
                        <h3 class="stat-value"><?= format_jam($total_jam_murni); ?> Jam</h3>
                        <div class="stat-desc">Selisih jam plus dan minus murni</div>
                    </div>
                </div>

                <div class="col-md-4">
                    <div class="stat-card">
                        <div class="stat-icon">
                            <i class="fa-solid fa-hourglass-half"></i>
                        </div>
                        <div class="stat-label">Total Jam</div>
                        <h3 class="stat-value"><?= format_jam($total_jam_mahasiswa); ?> Jam</h3>
                        <div class="stat-desc">Total jam yang dimiliki mahasiswa</div>
                    </div>
                </div>

                <div class="col-md-4">
                    <div class="stat-card">
                        <div class="stat-icon">
                            <i class="fa-solid fa-clipboard-list"></i>
                        </div>
                        <div class="stat-label">Jobdesc Tersedia</div>
                        <h3 class="stat-value"><?= $jobdesc_tersedia; ?></h3>
                        <div class="stat-desc">Tugas yang tersedia</div>
                    </div>
                </div>

                <div class="col-md-4">
                    <div class="stat-card">
                        <div class="stat-icon">
                            <i class="fa-solid fa-exclamation-triangle"></i>
                        </div>
                        <div class="stat-label">Pengaduan Saya</div>
                        <h3 class="stat-value"><?= $pengaduan_saya; ?></h3>
                        <div class="stat-desc">Pengaduan yang diajukan oleh saya</div>
                    </div>
                </div>

                <div class="col-md-4">
                    <div class="stat-card">
                        <div class="stat-icon">
                            <i class="fa-solid fa-clock"></i>
                        </div>
                        <div class="stat-label">Menunggu Verifikasi</div>
                        <h3 class="stat-value"><?= $pengaduan_menunggu_saya; ?></h3>
                        <div class="stat-desc">Pengaduan yang belum diverifikasi</div>
                    </div>
                </div>

                <div class="col-md-4">
                    <div class="stat-card">
                        <div class="stat-icon">
                            <i class="fa-solid fa-check-circle"></i>
                        </div>
                        <div class="stat-label">Jam Plus Menunggu Persetujuan</div>
                        <h3 class="stat-value"><?= $jam_plus_menunggu; ?></h3>
                        <div class="stat-desc">Pengajuan jam plus yang belum diverifikasi</div>
                    </div>
                </div>
            </div>
        </div>
    </main>
</div>

<?php require_once "../includes/dashboard_footer.php"; ?>
