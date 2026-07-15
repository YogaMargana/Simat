<?php
require_once "../../config/koneksi.php";
require_once "../../config/function.php";
require_once "../../includes/auth_dashboard.php";

cek_role_dashboard("PIC Aset Fasilitas");

$page_title = "Tambah Fasilitas";
$active_menu = "fasilitas";

$data_kelas = ambil_data_procedure($koneksi, "CALL usp_select_kelas_aktif()");

require_once "../../includes/dashboard_header.php";
require_once "../../includes/sidebar.php";
?>

<main class="main-content">
    <div class="topbar">
        <h1 class="page-title">Tambah Fasilitas</h1>
        <div class="user-info">
            <div class="user-detail">
                <div class="user-name"><?= aman($_SESSION['username']); ?></div>
                <div class="user-role"><?= aman($_SESSION['role']); ?></div>
            </div>
            <div class="user-avatar"><?= strtoupper(substr($_SESSION['username'], 0, 1)); ?></div>
        </div>
    </div>

    <div class="content-wrapper">
        <?php if (isset($_GET['error'])) { ?>
            <div class="alert alert-danger"><?= aman($_GET['error']); ?></div>
        <?php } ?>

        <div class="card border-0 shadow-sm rounded-4">
            <div class="card-body p-4">
                <h4 class="fw-bold mb-4">Form Tambah Fasilitas</h4>

                <form action="proses_tambah.php" method="post" id="form-fasilitas">
                                        <div class="mb-3">
                        <label class="form-label">Nama Fasilitas <span class="text-danger">*</span>
</label>
                        <input type="text" name="nama_fasilitas" class="form-control" maxlength="50" required>
                    </div>

                    <div class="mb-3">
                        <label class="form-label">Harga <span class="text-danger">*</span>
</label>
                        <input type="number" name="harga" class="form-control" min="0" step="1000" required>
                    </div>

                    <div class="mb-4">
                        <label class="form-label fw-bold">Kelas Pengguna Fasilitas <span class="text-danger">*</span>
</label>
                        <div class="form-text mb-2">Pilih minimal satu kelas aktif.</div>
                        <?php if (count($data_kelas) > 0) { ?>
                            <div class="row g-2">
                                <?php foreach ($data_kelas as $kelas) { ?>
                                    <div class="col-md-6 col-lg-4">
                                        <label class="border rounded-3 p-3 w-100 h-100">
                                            <input type="checkbox" class="form-check-input me-2 kelas-checkbox" name="id_kelas[]" value="<?= (int) $kelas['id_kelas']; ?>">
                                            <?= aman($kelas['nama_kelas'] . ' - Tingkat ' . $kelas['tingkat']); ?>
                                        </label>
                                    </div>
                                <?php } ?>
                            </div>
                        <?php } else { ?>
                            <div class="alert alert-warning mb-0">Belum ada kelas aktif. Tambahkan atau aktifkan kelas terlebih dahulu.</div>
                        <?php } ?>
                    </div>

                    <div class="d-flex gap-2">
                        <button type="submit" name="simpan" class="btn btn-primary" <?= count($data_kelas) === 0 ? 'disabled' : ''; ?>>
                            <i class="fa-solid fa-floppy-disk me-1"></i> Simpan
                        </button>
                        <a href="index.php" class="btn btn-secondary">Kembali</a>
                    </div>
                </form>
            </div>
        </div>
    </div>
</main>

<script>
document.getElementById('form-fasilitas').addEventListener('submit', function (event) {
    if (document.querySelectorAll('.kelas-checkbox:checked').length < 1) {
        event.preventDefault();
        alert('Pilih minimal satu kelas untuk fasilitas.');
    }
});
</script>

<?php require_once "../../includes/dashboard_footer.php"; ?>
