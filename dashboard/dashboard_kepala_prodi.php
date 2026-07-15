<?php
require_once "../config/koneksi.php";
require_once "../config/function.php";
require_once "../includes/auth_dashboard.php";

cek_role_dashboard("Kepala Prodi");

$page_title = "Dashboard";
$active_menu = "dashboard";

$id_pengguna = (int) ($_SESSION['id_pengguna'] ?? 0);
$ringkasan = ambil_satu_procedure_prepared(
    $koneksi,
    "CALL usp_dashboard_ringkasan(?)",
    "i",
    [$id_pengguna]
) ?? [];

$total_pengguna = (int) ($ringkasan['total_pengguna'] ?? 0);
$total_mahasiswa_aktif = (int) ($ringkasan['total_mahasiswa'] ?? 0);
$total_pengajar = (int) ($ringkasan['total_pengajar'] ?? 0);
$total_kelas = (int) ($ringkasan['total_kelas'] ?? 0);
$total_mata_kuliah_aktif = (int) ($ringkasan['total_mata_kuliah_aktif'] ?? 0);
$jobdesc_dikerjakan_saya = (int) ($ringkasan['jobdesc_dikerjakan_saya'] ?? 0);

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
                <h2>Selamat Datang di SIMAT</h2>
                <p>Kelola data pengguna, mahasiswa, pengajar, kelas, mata kuliah, dan aktivitas akademik melalui sistem ini.</p>
            </div>

            <div class="row g-3">
                <div class="col-md-4">
                    <div class="stat-card">
                        <div class="stat-icon">
                            <i class="fa-solid fa-users"></i>
                        </div>
                        <div class="stat-label">Total Pengguna</div>
                        <h3 class="stat-value"><?= $total_pengguna; ?></h3>
                        <div class="stat-desc">Akun aktif yang terdaftar di sistem</div>
                    </div>
                </div>

                <div class="col-md-4">
                    <div class="stat-card">
                        <div class="stat-icon">
                            <i class="fa-solid fa-user-graduate"></i>
                        </div>
                        <div class="stat-label">Total Mahasiswa</div>
                        <h3 class="stat-value"><?= $total_mahasiswa_aktif; ?></h3>
                        <div class="stat-desc">Data mahasiswa aktif</div>
                    </div>
                </div>

                <div class="col-md-4">
                    <div class="stat-card">
                        <div class="stat-icon">
                            <i class="fa-solid fa-chalkboard-user"></i>
                        </div>
                        <div class="stat-label">Total Pengajar</div>
                        <h3 class="stat-value"><?= $total_pengajar; ?></h3>
                        <div class="stat-desc">Data pengajar aktif</div>
                    </div>
                </div>

                <div class="col-md-4">
                    <div class="stat-card">
                        <div class="stat-icon">
                            <i class="fa-solid fa-school"></i>
                        </div>
                        <div class="stat-label">Total Kelas</div>
                        <h3 class="stat-value"><?= $total_kelas; ?></h3>
                        <div class="stat-desc">Kelas aktif yang terdaftar di sistem</div>
                    </div>
                </div>

                <div class="col-md-4">
                    <div class="stat-card">
                        <div class="stat-icon">
                            <i class="fa-solid fa-book-open"></i>
                        </div>
                        <div class="stat-label">Total Mata Kuliah Aktif</div>
                        <h3 class="stat-value"><?= $total_mata_kuliah_aktif; ?></h3>
                        <div class="stat-desc">Mata kuliah yang berstatus aktif</div>
                    </div>
                </div>

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
            </div>
        </div>
    </main>
</div>

<?php require_once "../includes/dashboard_footer.php"; ?>
