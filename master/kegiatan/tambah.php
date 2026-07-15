<?php
require_once "../../config/koneksi.php";
require_once "../../config/function.php";
require_once "../../includes/auth_dashboard.php";

cek_role_dashboard("PIC Kemahasiswaan");

$page_title = "Tambah Kegiatan";
$active_menu = "kegiatan";

require_once "../../includes/dashboard_header.php";
require_once "../../includes/sidebar.php";
?>

<main class="main-content">
    <div class="topbar">
        <h1 class="page-title">Tambah Kegiatan</h1>

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
            <div class="alert alert-danger">
                <?= aman($_GET['error']); ?>
            </div>
        <?php } ?>

        <div class="card border-0 shadow-sm rounded-4">
            <div class="card-body p-4">
                <h4 class="fw-bold mb-4">Form Tambah Kegiatan</h4>

                <form action="proses_tambah.php" method="post">
                    <?= csrf_input(); ?>
                    <div class="mb-3">
                        <label class="form-label">Nama Kegiatan <span class="text-danger">*</span>
</label>
                        <input type="text" name="nama_kegiatan" class="form-control" maxlength="50" required>
                    </div>

                    <div class="mb-3">
                        <label class="form-label">Penyelenggara <span class="text-danger">*</span>
</label>
                        <select name="penyelenggara" class="form-select" required>
                            <option value="">Pilih Penyelenggara</option>
                            <option value="ASTRAtech">ASTRAtech</option>
                            <option value="BEM">BEM</option>
                            <option value="MPM">MPM</option>
                            <option value="HIMMA">HIMMA</option>
                            <option value="UKM">UKM</option>
                            <option value="Prodi">Prodi</option>
                        </select>
                    </div>

                    <div class="mb-4">
                        <label class="form-label">Tanggal Kegiatan</label>
                        <input type="date" name="tanggal_kegiatan" class="form-control">
                        <small class="text-muted">
                            Boleh dikosongkan jika tanggal kegiatan belum ditentukan.
                        </small>
                    </div>

                    <div class="d-flex gap-2">
                        <button type="submit" name="simpan" class="btn btn-primary">
                            <i class="fa-solid fa-floppy-disk me-1"></i>
                            Simpan
                        </button>

                        <a href="index.php" class="btn btn-secondary">
                            Kembali
                        </a>
                    </div>
                </form>
            </div>
        </div>
    </div>
</main>

<?php require_once "../../includes/dashboard_footer.php"; ?>