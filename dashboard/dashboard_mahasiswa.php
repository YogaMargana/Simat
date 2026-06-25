<?php
require_once "../config/koneksi.php";
require_once "../config/function.php";
require_once "../includes/auth_dashboard.php";

cek_role_dashboard("Mahasiswa");

$page_title = "Dashboard";
$active_menu = "dashboard";

$id_pengguna = $_SESSION['id_pengguna'];
$pengaduan_saya = mysqli_fetch_assoc(mysqli_query(
    $koneksi,
    "SELECT COUNT(*) AS total
     FROM pengaduan_kerusakan_fasilitas pkf
     JOIN detail_pengguna_pada_pengaduan_kerusakan_fasilitas dppkf
     ON pkf.id_pengaduan_kerusakan_fasilitas = dppkf.id_pengaduan_kerusakan_fasilitas
     WHERE dppkf.id_pengguna = '$id_pengguna'
     AND dppkf.peran_pengguna = 'Pelapor'"
))['total'];
$id_pengguna = $_SESSION['id_pengguna'];
$pengaduan_menunggu_saya = mysqli_fetch_assoc(mysqli_query(
    $koneksi,
    "SELECT COUNT(*) AS total
     FROM pengaduan_kerusakan_fasilitas pkf
     JOIN detail_pengguna_pada_pengaduan_kerusakan_fasilitas dppkf
     ON pkf.id_pengaduan_kerusakan_fasilitas = dppkf.id_pengaduan_kerusakan_fasilitas
     WHERE dppkf.id_pengguna = '$id_pengguna'
     AND dppkf.peran_pengguna = 'Pelapor'
     AND pkf.status_pengaduan = 'Menunggu Verifikasi'"
))['total'];
$jobdesc_tersedia = mysqli_fetch_assoc(mysqli_query($koneksi, "SELECT COUNT(*) AS total FROM bursa_jobdesc WHERE status_jobdesc = 'Dibuka'"))['total'];

require_once "../includes/dashboard_header.php";
require_once "../includes/sidebar.php"; 
?>

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
                Kelola aktivitas Bursa Jobdesc dan Pengaduan Fasilitas melalui sistem ini.
            </p>
        </div>

        <div class="row g-3">
            <div class="col-md-4">
                <div class="stat-card">
                    <div class="stat-icon">
                        <span class="fs-1">📋</span>
                    </div>
                    <div class="stat-label">Jobdesc Tersedia</div>
                    <h3 class="stat-value"><?= $jobdesc_tersedia; ?></h3>
                    <div class="stat-desc">Tugas yang tersedia</div>
                </div>
            </div>

            <div class="col-md-4">
                <div class="stat-card">
                    <div class="stat-icon">
                        <span class="fs-1">⚠️</span>
                    </div>
                    <div class="stat-label">Pengaduan Saya</div>
                    <h3 class="stat-value"><?= $pengaduan_saya; ?></h3>
                    <div class="stat-desc">Pengaduan yang diajukan oleh saya</div>
                </div>
            </div>    

            <div class="col-md-4">
                <div class="stat-card">
                    <div class="stat-icon">
                        <span class="fs-1">⏳</span>
                    </div>
                    <div class="stat-label">Menunggu Verifikasi</div>
                    <h3 class="stat-value"><?= $pengaduan_menunggu_saya; ?></h3>
                    <div class="stat-desc">Pengaduan yang belum diverifikasi</div>
                </div>
            </div>    
        </div>
    </div>       
</main>

       
<?php require_once "../includes/dashboard_footer.php"; ?> 