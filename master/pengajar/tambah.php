<?php
require_once "../../config/koneksi.php";
require_once "../../config/function.php";
require_once "../../includes/auth_dashboard.php";

cek_role_dashboard("Kepala Prodi");

$page_title = "Tambah Pengajar";
$active_menu = "pengajar";

require_once "../../includes/dashboard_header.php";
require_once "../../includes/sidebar.php";
?>

<main class="main-content">
    <div class="topbar">
        <h1 class="page-title">Tambah Pengajar</h1>

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
                <h4 class="fw-bold mb-4">Form Tambah Pengajar</h4>

                <form action="proses_tambah.php" method="post">
                                        <div class="mb-3">
                        <label class="form-label">NIP <span class="text-danger">*</span>
</label>
                        <input type="text" inputmode="numeric" pattern="[0-9A-Za-z]+" name="nip" class="form-control" maxlength="20" required>
                    </div>

                    <div class="mb-3">
                        <label class="form-label">Nama Pengajar <span class="text-danger">*</span>
</label>
                        <input type="text" name="nama_pengajar" class="form-control" maxlength="50" required>
                    </div>

                    <div class="mb-3">
                        <label class="form-label">Email</label>
                        <input type="email" name="email" class="form-control" maxlength="50">
                    </div>

                    <div class="mb-4">
                        <label class="form-label">No HP</label>
                        <input type="text" inputmode="numeric" pattern="[0-9]{10,13}" name="no_hp" class="form-control" minlength="10" maxlength="13">
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