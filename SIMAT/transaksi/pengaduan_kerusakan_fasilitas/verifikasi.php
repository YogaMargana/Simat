<?php
require_once "../../config/koneksi.php";
require_once "../../config/function.php";
require_once "../../includes/auth_dashboard.php";

$role = $_SESSION['role'] ?? '';

if ($role != "PIC Aset Fasilitas") {
    header("Location: /SIMAT/index.php");
    exit;
}

$page_title = "Verifikasi Pengaduan";
$active_menu = "pengaduan_fasilitas";

$id_pengaduan = $_GET['id'] ?? '';

if ($id_pengaduan == '') {
    header("Location: index.php?error=" . urlencode("ID pengaduan tidak ditemukan."));
    exit;
}

$stmt = mysqli_prepare($koneksi, "
    SELECT
        pkf.id_pengaduan_kerusakan_fasilitas,
        pkf.id_fasilitas,
        f.nama_fasilitas,
        pkf.deskripsi_kerusakan,
        pkf.tanggal_pengaduan,
        pkf.bukti_kerusakan_url,
        pkf.status_pengaduan,

        dp.id_pengguna AS id_pelapor,
        p.username AS username_pelapor,
        COALESCE(m.nama_mahasiswa, pg.nama_pengajar) AS nama_pelapor
    FROM pengaduan_kerusakan_fasilitas pkf
    JOIN fasilitas f 
        ON pkf.id_fasilitas = f.id_fasilitas
    LEFT JOIN detail_pengguna_pada_pengaduan_kerusakan_fasilitas dp
        ON pkf.id_pengaduan_kerusakan_fasilitas = dp.id_pengaduan_kerusakan_fasilitas
        AND dp.peran_pengguna = 'Pelapor'
    LEFT JOIN pengguna p
        ON dp.id_pengguna = p.id_pengguna
    LEFT JOIN mahasiswa m
        ON p.id_mahasiswa = m.id_mahasiswa
    LEFT JOIN pengajar pg
        ON p.id_pengajar = pg.id_pengajar
    WHERE pkf.id_pengaduan_kerusakan_fasilitas = ?
    LIMIT 1
");

mysqli_stmt_bind_param($stmt, "i", $id_pengaduan);
mysqli_stmt_execute($stmt);

$result = mysqli_stmt_get_result($stmt);
$pengaduan = mysqli_fetch_assoc($result);

mysqli_stmt_close($stmt);

if (!$pengaduan) {
    header("Location: index.php?error=" . urlencode("Data pengaduan tidak ditemukan."));
    exit;
}

require_once "../../includes/dashboard_header.php";
require_once "../../includes/sidebar.php";
?>

<main class="main-content">
    <div class="topbar">
        <h1 class="page-title">Verifikasi Pengaduan</h1>

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
        <?php if (isset($_GET['error'])) { ?>
            <div class="alert alert-danger"><?= aman($_GET['error']); ?></div>
        <?php } ?>

        <div class="card border-0 shadow-sm rounded-4">
            <div class="card-body p-4">
                <h4 class="fw-bold mb-4">Detail Pengaduan</h4>

                <div class="mb-3">
                    <strong>Pelapor</strong>
                    <div><?= aman($pengaduan['nama_pelapor'] ?? '-'); ?></div>
                    <small class="text-muted"><?= aman($pengaduan['username_pelapor'] ?? '-'); ?></small>
                </div>

                <div class="mb-3">
                    <strong>Fasilitas</strong>
                    <div><?= aman($pengaduan['nama_fasilitas']); ?></div>
                </div>

                <div class="mb-3">
                    <strong>Deskripsi Kerusakan</strong>
                    <div><?= aman($pengaduan['deskripsi_kerusakan']); ?></div>
                </div>

                <div class="mb-3">
                    <strong>Tanggal Pengaduan</strong>
                    <div><?= aman($pengaduan['tanggal_pengaduan']); ?></div>
                </div>

                <div class="mb-4">
                    <strong>Bukti Kerusakan</strong>
                    <div>
                        <?php if (!empty($pengaduan['bukti_kerusakan_url'])) { ?>
                            <a href="<?= aman($pengaduan['bukti_kerusakan_url']); ?>" target="_blank">
                                Lihat Bukti
                            </a>
                        <?php } else { ?>
                            <span class="text-muted">Tidak ada bukti.</span>
                        <?php } ?>
                    </div>
                </div>

                <?php if ($pengaduan['status_pengaduan'] == "Menunggu Verifikasi") { ?>
                    <form action="proses_verifikasi.php" method="post">
                        <input type="hidden" name="id_pengaduan_kerusakan_fasilitas" value="<?= aman($pengaduan['id_pengaduan_kerusakan_fasilitas']); ?>">

                        <div class="mb-4">
                            <label class="form-label">Status Verifikasi</label>
                            <select name="status_pengaduan" class="form-select" required>
                                <option value="">Pilih Status</option>
                                <option value="Diterima">Diterima</option>
                                <option value="Ditolak">Ditolak</option>
                            </select>
                            <small class="text-muted">
                                Jika Diterima, kondisi fasilitas otomatis berubah menjadi Rusak.
                            </small>
                        </div>

                        <div class="d-flex gap-2">
                            <button type="submit" name="verifikasi" class="btn btn-primary">
                                <i class="fa-solid fa-check me-1"></i>
                                Simpan Verifikasi
                            </button>

                            <a href="index.php" class="btn btn-secondary">
                                Kembali
                            </a>
                        </div>
                    </form>
                <?php } else { ?>
                    <div class="alert alert-info">
                        Pengaduan ini sudah diverifikasi dengan status:
                        <strong><?= aman($pengaduan['status_pengaduan']); ?></strong>
                    </div>

                    <a href="index.php" class="btn btn-secondary">
                        Kembali
                    </a>
                <?php } ?>
            </div>
        </div>
    </div>
</main>

<?php require_once "../../includes/dashboard_footer.php"; ?>