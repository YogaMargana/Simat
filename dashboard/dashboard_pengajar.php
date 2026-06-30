<?php
require_once "../config/koneksi.php";
require_once "../config/function.php";
require_once "../includes/auth_dashboard.php";

cek_role_dashboard("Pengajar");

$page_title = "Dashboard";
$active_menu = "dashboard";

$id_pengguna = $_SESSION['id_pengguna'];
$jobdesc_saya = mysqli_fetch_assoc(mysqli_query($koneksi,
    "SELECT COUNT(DISTINCT bj.id_bursa_jobdesc) AS total FROM bursa_jobdesc bj
     JOIN detail_pengguna_pada_bursa_jobdesc dpbj
     ON bj.id_bursa_jobdesc = dpbj.id_bursa_jobdesc
     WHERE dpbj.id_pengguna = '$id_pengguna'
     AND dpbj.peran_pengguna = 'Pemberi'"
))['total'];
$bursa_jobdesc_tersedia = mysqli_fetch_assoc(mysqli_query($koneksi,
    "SELECT COUNT(*) AS total
     FROM bursa_jobdesc
     WHERE status_jobdesc='Dibuka'"
))['total'];


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
            <h2 class="fw-bold mb-2">Selamat Datang, <?= $_SESSION['username']; ?> 🎓</h2>
            <p class="text-muted mb-0">
                Kelola aktivitas Bursa Jobdesc melalui sistem ini.
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
        </div>
    </div>  
</main>     


<?php require_once "../includes/dashboard_footer.php"; ?>