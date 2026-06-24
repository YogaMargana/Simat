<?php
require_once "../../config/koneksi.php";
require_once "../../config/function.php";
require_once "../../includes/auth_dashboard.php";

$role = $_SESSION['role'] ?? '';

if ($role == "Mahasiswa" || $role == '') {
    header("Location: /SIMAT/index.php");
    exit;
}

$page_title = "Tambah Bursa Jobdesc";
$active_menu = "bursa_jobdesc";

require_once "../../includes/dashboard_header.php";
require_once "../../includes/sidebar.php";
?>

<main class="main-content">
    <div class="topbar">
        <h1 class="page-title">Tambah Bursa Jobdesc</h1>

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
        <div class="card border-0 shadow-sm rounded-4">
            <div class="card-body p-4">
                <h4 class="fw-bold mb-4">Form Tambah Bursa Jobdesc</h4>

                <form action="proses_tambah.php" method="post">
                    <div class="mb-3">
                        <label class="form-label">Deskripsi Jobdesc</label>
                        <textarea name="deskripsi_jobdesc" class="form-control" rows="4" required></textarea>
                    </div>

                    <div class="mb-3">
                        <label class="form-label">Penerima Jobdesc</label>
                        <select name="penerima_jobdesc" class="form-select" required>
                            <option value="">-- Pilih Penerima Jobdesc --</option>
                            <option value="Semua mahasiswa">Semua mahasiswa</option>
                            <option value="Yang memiliki jam minus">Yang memiliki jam minus</option>
                        </select>
                        <small class="text-muted">
                            Pilih siapa saja yang boleh mengambil jobdesc ini.
                        </small>
                    </div>

                    <div class="mb-3">
                        <label class="form-label">Jam Plus</label>
                        <input type="number" name="jam_plus" class="form-control" min="0.5" step="0.5" required>
                    </div>

                    <div class="mb-3">
                        <label class="form-label">Tanggal Pemberian Jobdesc</label>
                        <input type="datetime-local" name="tanggal_pemberian_jobdesc" class="form-control" required>
                    </div>

                    <div class="mb-3">
                        <label class="form-label">Jumlah Mahasiswa Diperlukan</label>
                        <input type="number" name="jumlah_mahasiswa_diperlukan" class="form-control" min="1" required>
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