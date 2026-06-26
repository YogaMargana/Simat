<?php
require_once "../../config/koneksi.php";
require_once "../../config/function.php";
require_once "../../includes/auth_dashboard.php";

$role = $_SESSION['role'] ?? '';

// Hanya Mahasiswa yang boleh mengakses halaman tambah pengajuan
if ($role != "Mahasiswa") {
    header("Location: /SIMAT/index.php");
    exit;
}

$page_title = "Buat Pengajuan Jam Plus";
$active_menu = "pengajuan_jam_plus";

// Mengambil data kegiatan yang aktif untuk pilihan di form
$data_kegiatan = [];
$query_kegiatan = mysqli_query($koneksi, "SELECT id_kegiatan, nama_kegiatan FROM kegiatan WHERE status_kegiatan = 'Aktif' ORDER BY nama_kegiatan ASC");

while ($row = mysqli_fetch_assoc($query_kegiatan)) {
    $data_kegiatan[] = $row;
}

require_once "../../includes/dashboard_header.php";
require_once "../../includes/sidebar.php";
?>

<main class="main-content">
    <div class="topbar">
        <h1 class="page-title">Tambah Pengajuan</h1>

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
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <?= aman($_GET['error']); ?>
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        <?php } ?>

        <div class="card border-0 shadow-sm rounded-4">
            <div class="card-body p-4">
                <h4 class="fw-bold mb-4">Form Pengajuan Jam Plus</h4>

                <form action="proses_tambah.php" method="post">
                    <div class="row">
                        <div class="col-md-8">
                            <div class="mb-3">
                                <label class="form-label fw-bold">Kegiatan</label>
                                <select name="id_kegiatan" class="form-select" required>
                                    <option value="">-- Pilih Kegiatan --</option>
                                    <?php foreach ($data_kegiatan as $kegiatan) { ?>
                                        <option value="<?= $kegiatan['id_kegiatan']; ?>">
                                            <?= aman($kegiatan['nama_kegiatan']); ?>
                                        </option>
                                    <?php } ?>
                                </select>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="mb-3">
                                <label class="form-label fw-bold">Jumlah Jam Plus</label>
                                <div class="input-group">
                                    <input type="number" name="jumlah_jam_plus" class="form-control" step="0.01" min="0.01" placeholder="0.00" required>
                                    <span class="input-group-text">Jam</span>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="row">
                        <div class="col-md-6">
                            <div class="mb-3">
                                <label class="form-label fw-bold">Jenis Jam</label>
                                <select name="jenis_jam" class="form-select" required>
                                    <option value="Murni">Murni (Menambah Saldo Plus)</option>
                                    <option value="Kompensasi">Kompensasi (Mengurangi Jam Minus)</option>
                                </select>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="mb-3">
                                <label class="form-label fw-bold">Sumber Jam</label>
                                <select name="sumber_jam" class="form-select" required>
                                    <option value="">-- Pilih Sumber Jam --</option>
                                    <option value="Prodi">Prodi - Jam masuk utuh</option>
                                    <option value="Luar">Luar - Jam masuk 50%</option>
                                </select>
                                <div class="form-text">
                                    Jika sumber dari luar prodi, jam yang disetujui akan dihitung 50%.
                                </div>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="mb-3">
                                <label class="form-label fw-bold">Nama Pemberi Tugas</label>
                                <input type="text" name="nama_pemberi" class="form-control" placeholder="Nama Dosen/Staf Pemberi Tugas" required>
                            </div>
                        </div>
                    </div>

                    <div class="mb-3">
                        <label class="form-label fw-bold">Deskripsi Pekerjaan</label>
                        <textarea name="deskripsi_pekerjaan" class="form-control" rows="3" placeholder="Jelaskan detail pekerjaan yang dilakukan..." required></textarea>
                    </div>

                    <div class="mb-4">
                        <label class="form-label fw-bold">URL Dokumen Bukti (Sertifikat/Foto)</label>
                        <input type="text" name="dokumen_url" class="form-control" maxlength="2048" placeholder="https://link-google-drive-atau-dropbox.com/bukti" required>
                        <div class="form-text">Pastikan link dapat diakses oleh verifikator (Public/Anyone with the link).</div>
                    </div>

                    <div class="d-flex gap-2">
                        <button type="submit" name="simpan" class="btn btn-primary px-4">
                            <i class="fa-solid fa-paper-plane me-1"></i>
                            Kirim Pengajuan
                        </button>

                        <a href="index.php" class="btn btn-secondary px-4">
                            Kembali
                        </a>
                    </div>
                </form>
            </div>
        </div>
    </div>
</main>

<?php require_once "../../includes/dashboard_footer.php"; ?>