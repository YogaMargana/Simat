<?php
require_once "../../config/koneksi.php";
require_once "../../config/function.php";
require_once "../../includes/auth_dashboard.php";

// Pastikan hanya Kepala Prodi yang bisa akses
cek_role_dashboard("Kepala Prodi");

$page_title = "Tambah Periode Akademik";
$active_menu = "periode_akademik";

require_once "../../includes/dashboard_header.php";
require_once "../../includes/sidebar.php";
?>

<main class="main-content">
    <div class="topbar">
        <h1 class="page-title">Tambah Periode Akademik</h1>

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
                <form action="proses_tambah.php" method="POST">
                    <div class="mb-3">
                        <label class="form-label fw-bold">Tahun Akademik</label>
                        <input type="text" name="tahun_akademik" class="form-control" 
                               placeholder="Contoh: 2025/2026" maxlength="10" required>
                    </div>

                    <div class="mb-3">
                        <label class="form-label fw-bold">Semester</label>
                        <select name="semester" class="form-select" required>
                            <option value="" selected disabled>-- Pilih Semester --</option>
                            <option value="Ganjil">Ganjil</option>
                            <option value="Genap">Genap</option>
                        </select>
                    </div>

                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label class="form-label fw-bold">Tanggal Mulai</label>
                            <input type="date" name="tanggal_mulai" class="form-control" required>
                        </div>

                        <div class="col-md-6 mb-3">
                            <label class="form-label fw-bold">Tanggal Selesai</label>
                            <input type="date" name="tanggal_selesai" class="form-control" required>
                        </div>
                    </div>

                    <hr class="mb-4">
                    <div class="d-flex gap-2">
                        <button type="submit" name="simpan" class="btn btn-primary px-4">
                            <i class="fa-solid fa-floppy-disk me-1"></i> Simpan
                        </button>
                        <a href="index.php" class="btn btn-light px-4 border">Batal</a>
                    </div>
                </form>
            </div>
        </div>
    </div>
</main>

<?php require_once "../../includes/dashboard_footer.php"; ?>