<?php
require_once "../config/koneksi.php";
require_once "../config/function.php";
require_once "../includes/auth_dashboard.php";

cek_role_dashboard("PIC Tata Tertib");

$page_title = "Dashboard";
$active_menu = "dashboard";

$id_pengguna = (int) ($_SESSION['id_pengguna'] ?? 0);
$ringkasan = ambil_satu_procedure_prepared(
    $koneksi,
    "CALL usp_dashboard_ringkasan(?)",
    "i",
    [$id_pengguna]
) ?? [];

$jobdesc_dikerjakan_saya = (int) ($ringkasan['jobdesc_dikerjakan_saya'] ?? 0);
$total_pengajuan_jam_plus_menunggu = (int) ($ringkasan['total_pengajuan_jam_plus_menunggu'] ?? 0);
$total_mahasiswa_jam_negatif = (int) ($ringkasan['total_mahasiswa_jam_negatif'] ?? 0);
$total_mahasiswa_jam_positif = (int) ($ringkasan['total_mahasiswa_jam_positif'] ?? 0);

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
                    Kelola Bursa Jobdesc, pengajuan jam plus, pemberian jam minus, dan total jam mahasiswa melalui sistem ini.
                </p>
            </div>

            <div class="row g-3">
                <div class="col-md-4">
                    <div class="stat-card">
                        <div class="stat-icon">
                            <i class="fa-solid fa-clipboard-check"></i>
                        </div>
                        <div class="stat-label">Bursa Jobdesc Dikerjakan</div>
                        <h3 class="stat-value"><?= $jobdesc_dikerjakan_saya; ?></h3>
                        <div class="stat-desc">Jobdesc yang saya buat dan sedang dikerjakan</div>
                    </div>
                </div>

                <div class="col-md-4">
                    <div class="stat-card">
                        <div class="stat-icon">
                            <i class="fa-solid fa-clock"></i>
                        </div>
                        <div class="stat-label">Pengajuan Jam Plus Menunggu</div>
                        <h3 class="stat-value"><?= $total_pengajuan_jam_plus_menunggu; ?></h3>
                        <div class="stat-desc">Pengajuan berstatus Menunggu Verifikasi</div>
                    </div>
                </div>

                <div class="col-md-4">
                    <div class="stat-card">
                        <div class="stat-icon">
                            <i class="fa-solid fa-arrow-trend-down"></i>
                        </div>
                        <div class="stat-label">Mahasiswa dengan Total Jam &lt; 0</div>
                        <h3 class="stat-value"><?= $total_mahasiswa_jam_negatif; ?></h3>
                        <div class="stat-desc">Mahasiswa aktif dengan total jam negatif</div>
                    </div>
                </div>

                <div class="col-md-4">
                    <div class="stat-card">
                        <div class="stat-icon">
                            <i class="fa-solid fa-arrow-trend-up"></i>
                        </div>
                        <div class="stat-label">Mahasiswa dengan Total Jam &gt; 0</div>
                        <h3 class="stat-value"><?= $total_mahasiswa_jam_positif; ?></h3>
                        <div class="stat-desc">Mahasiswa aktif dengan total jam positif</div>
                    </div>
                </div>
            </div>
        </div>
    </main>
</div>

<?php require_once "../includes/dashboard_footer.php"; ?>
