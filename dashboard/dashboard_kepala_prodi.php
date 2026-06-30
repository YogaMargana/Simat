<?php
require_once "../config/koneksi.php";
require_once "../config/function.php";
require_once "../includes/auth_dashboard.php";

cek_role_dashboard("Kepala Prodi");

$page_title = "Dashboard";
$active_menu = "dashboard";

$total_pengguna = mysqli_fetch_assoc(mysqli_query($koneksi, "SELECT COUNT(*) AS total FROM pengguna"))['total'];
$total_mahasiswa_aktif = mysqli_fetch_assoc(mysqli_query($koneksi, "SELECT COUNT(*) AS total FROM mahasiswa WHERE status_mahasiswa = 'Aktif'"))['total'];
$total_pengajar = mysqli_fetch_assoc(mysqli_query($koneksi, "SELECT COUNT(*) AS total FROM pengajar"))['total'];
$total_fasilitas = mysqli_fetch_assoc(mysqli_query($koneksi, "SELECT COUNT(*) AS total FROM fasilitas"))['total'];
$total_kelas = mysqli_fetch_assoc(mysqli_query($koneksi, "SELECT COUNT(*) AS total FROM kelas"))['total'];
$total_pengaduan = mysqli_fetch_assoc(mysqli_query($koneksi, "SELECT COUNT(*) AS total FROM pengaduan_kerusakan_fasilitas"))['total'];
$pengaduan_menunggu = mysqli_fetch_assoc(mysqli_query($koneksi, "SELECT COUNT(*) AS total FROM pengaduan_kerusakan_fasilitas WHERE status_pengaduan = 'Menunggu Verifikasi'"))['total'];
$fasilitas_rusak = mysqli_fetch_assoc(mysqli_query($koneksi, "SELECT COUNT(*) AS total FROM detail_fasilitas_pada_kelas  d JOIN fasilitas f ON d.id_fasilitas = f.id_fasilitas WHERE status_detail_fasilitas_pada_kelas = 'Rusak'"))['total'];

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
                <p>Kelola data pengguna, mahasiswa, pengajar, fasilitas, dan pengaduan kerusakan fasilitas melalui sistem ini.</p>
            </div>

            <div class="row g-3">
                <div class="col-md-4">
                    <div class="stat-card">
                        <div class="stat-icon">
                            <i class="fa-solid fa-users"></i>
                        </div>
                        <div class="stat-label">Total Pengguna</div>
                        <h3 class="stat-value"><?= $total_pengguna; ?></h3>
                        <div class="stat-desc">Akun yang terdaftar di sistem</div>
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
                        <div class="stat-desc">Pengajar dan PIC yang terdaftar</div>
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
                            <i class="fa-solid fa-school"></i>
                        </div>
                        <div class="stat-label">Total Kelas</div>
                        <h3 class="stat-value"><?= $total_kelas; ?></h3>
                        <div class="stat-desc">Kelas yang terdaftar di sistem</div>
                    </div>
                </div>

                <div class="col-md-4">
                    <div class="stat-card">
                        <div class="stat-icon">
                            <i class="fa-solid fa-file-circle-exclamation"></i>
                        </div>
                        <div class="stat-label">Total Pengaduan</div>
                        <h3 class="stat-value"><?= $total_pengaduan; ?></h3>
                        <div class="stat-desc">Seluruh pengaduan fasilitas</div>
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

                <div class="col-md-4">
                    <div class="stat-card">
                        <div class="stat-icon">
                            <i class="fa-solid fa-clock"></i>
                        </div>
                        <div class="stat-label">Fasilitas Rusak</div>
                        <h3 class="stat-value"><?= $fasilitas_rusak; ?></h3>
                        <div class="stat-desc">Fasilitas yang dalam kondisi rusak</div>
                    </div>
                </div>
            </div>
        </div>
    </main>
</div>

<?php require_once "../includes/dashboard_footer.php"; ?>