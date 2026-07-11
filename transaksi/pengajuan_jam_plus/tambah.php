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
$data_kegiatan = ambil_data_procedure($koneksi, "CALL usp_select_kegiatan_aktif()");

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
                        <div class="col-md-6">
                            <div class="mb-3">
                                <label class="form-label fw-bold">Jumlah Jam Plus</label>
                                <div class="input-group">
                                    <input type="number" name="jumlah_jam_plus" class="form-control" step="0.1" min="0.1" max="100.0" placeholder="0.0" required>
                                    <span class="input-group-text">Jam</span>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="mb-3">
                                <label class="form-label fw-bold">Jenis Jam</label>
                                <select name="jenis_jam" class="form-select" required>
                                    <option value="Murni">Murni (Menambah Saldo Plus)</option>
                                    <option value="Kompensasi">Kompensasi (Mengurangi Jam Minus)</option>
                                </select>
                            </div>
                        </div>
                    </div>

                    <div class="row">
                        <div class="col-md-6">
                            <div class="mb-3">
                                <label class="form-label fw-bold">Sumber Jam</label>
                                <select name="sumber_jam" id="sumber_jam" class="form-select" required>
                                    <option value="">-- Pilih Sumber Jam --</option>
                                    <option value="Prodi">Prodi - Tidak perlu memilih kegiatan</option>
                                    <option value="Luar">Luar - Wajib memilih kegiatan</option>
                                </select>
                                <div class="form-text">
                                    Jika sumber jam berasal dari Prodi, kegiatan tidak perlu dipilih. 
                                    Jika sumber jam berasal dari luar, kegiatan wajib dipilih.
                                </div>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="mb-3 d-none" id="wrapper_kegiatan">
                                <label class="form-label fw-bold">Kegiatan</label>
                                <select name="id_kegiatan" id="id_kegiatan" class="form-select">
                                    <option value="">-- Pilih Kegiatan --</option>
                                    <?php foreach ($data_kegiatan as $kegiatan) { ?>
                                        <option value="<?= $kegiatan['id_kegiatan']; ?>">
                                            <?= aman($kegiatan['nama_kegiatan']); ?>
                                            - <?= aman($kegiatan['penyelenggara']); ?>
                                            <?= !empty($kegiatan['tanggal_kegiatan']) ? ' - ' . date('d/m/Y', strtotime($kegiatan['tanggal_kegiatan'])) : ''; ?>
                                        </option>
                                    <?php } ?>
                                </select>
                                <div class="form-text">
                                    Kegiatan hanya wajib dipilih jika sumber jam berasal dari luar.
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

<script>
document.addEventListener('DOMContentLoaded', function () {
    const sumberJam = document.getElementById('sumber_jam');
    const wrapperKegiatan = document.getElementById('wrapper_kegiatan');
    const idKegiatan = document.getElementById('id_kegiatan');

    function aturKegiatan() {
        if (sumberJam.value === 'Luar') {
            wrapperKegiatan.classList.remove('d-none');
            idKegiatan.setAttribute('required', 'required');
            idKegiatan.disabled = false;
        } else {
            wrapperKegiatan.classList.add('d-none');
            idKegiatan.removeAttribute('required');
            idKegiatan.value = '';
            idKegiatan.disabled = true;
        }
    }

    sumberJam.addEventListener('change', aturKegiatan);
    aturKegiatan();
});
</script>

<?php require_once "../../includes/dashboard_footer.php"; ?>