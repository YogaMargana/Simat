<?php
require_once "../../config/koneksi.php";
require_once "../../config/function.php";
require_once "../../includes/auth_dashboard.php";

cek_role_dashboard("Kepala Prodi");

$page_title = "Tambah Pengajar Mata Kuliah";
$active_menu = "pengajar_mata_kuliah";

$data_kelas = ambil_data_procedure($koneksi, "CALL usp_select_kelas_aktif()");
$data_mata_kuliah = ambil_data_procedure($koneksi, "CALL usp_select_mata_kuliah_aktif()");
$data_pengajar = ambil_data_procedure($koneksi, "CALL usp_select_pengajar_aktif()");

require_once "../../includes/dashboard_header.php";
require_once "../../includes/sidebar.php";
?>

<main class="main-content">
    <div class="topbar">
        <h1 class="page-title">Tambah Pengajar Mata Kuliah</h1>

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
                <h4 class="fw-bold mb-4">Form Tambah Pengajar Mata Kuliah</h4>

                <form action="proses_tambah.php" method="post">
                    <div class="mb-3">
                        <label class="form-label">Kelas</label>
                        <select name="id_kelas" class="form-select" required>
                            <option value="">Pilih Kelas</option>
                            <?php foreach ($data_kelas as $kelas) { ?>
                                <option value="<?= $kelas['id_kelas']; ?>">
                                    <?= aman($kelas['nama_kelas']); ?> - Tingkat <?= aman($kelas['tingkat']); ?>
                                </option>
                            <?php } ?>
                        </select>
                    </div>

                    <div class="mb-3">
                        <label class="form-label">Mata Kuliah</label>
                        <select name="id_mata_kuliah" class="form-select" required>
                            <option value="">Pilih Mata Kuliah</option>
                            <?php foreach ($data_mata_kuliah as $mk) { ?>
                                <option value="<?= $mk['id_mata_kuliah']; ?>">
                                    <?= aman($mk['kode_mata_kuliah']); ?> - <?= aman($mk['nama_mata_kuliah']); ?>
                                </option>
                            <?php } ?>
                        </select>
                    </div>

                    <div class="mb-3">
                        <label class="form-label">Pengajar 1</label>
                        <select name="id_pengajar_1" class="form-select" required>
                            <option value="">Pilih Pengajar 1</option>
                            <?php foreach ($data_pengajar as $pengajar) { ?>
                                <option value="<?= $pengajar['id_pengajar']; ?>">
                                    <?= aman($pengajar['nama_pengajar']); ?>
                                </option>
                            <?php } ?>
                        </select>
                    </div>

                    <div class="mb-4">
                        <label class="form-label">Pengajar 2</label>
                        <select name="id_pengajar_2" class="form-select" required>
                            <option value="">Pilih Pengajar 2</option>
                            <?php foreach ($data_pengajar as $pengajar) { ?>
                                <option value="<?= $pengajar['id_pengajar']; ?>">
                                    <?= aman($pengajar['nama_pengajar']); ?>
                                </option>
                            <?php } ?>
                        </select>
                    </div>

                    <div class="d-flex gap-2">
                        <button type="submit" name="simpan" class="btn btn-primary">
                            <i class="fa-solid fa-floppy-disk me-1"></i>
                            Simpan
                        </button>

                        <a href="index.php" class="btn btn-secondary">Kembali</a>
                    </div>
                </form>
            </div>
        </div>
    </div>
</main>

<?php require_once "../../includes/dashboard_footer.php"; ?>