<?php
require_once "../../config/koneksi.php";
require_once "../../config/function.php";
require_once "../../includes/auth_dashboard.php";

// /** @var mysqli $koneksi */ anjing

cek_role_dashboard("Kepala Prodi");

$page_title = "Edit Pengajar";
$active_menu = "pengajar";

$id_pengajar = $_GET['id'] ?? '';

if ($id_pengajar == '') {
    header("Location: index.php?error=" . urlencode("ID pengajar tidak ditemukan."));
    exit;
}

$stmt = mysqli_prepare($koneksi, "SELECT * FROM pengajar WHERE id_pengajar = ? LIMIT 1");
mysqli_stmt_bind_param($stmt, "i", $id_pengajar);
mysqli_stmt_execute($stmt);

$result = mysqli_stmt_get_result($stmt);
$pengajar = mysqli_fetch_assoc($result);

mysqli_stmt_close($stmt);

if (!$pengajar) {
    header("Location: index.php?error=" . urlencode("Data pengajar tidak ditemukan."));
    exit;
}

require_once "../../includes/dashboard_header.php";
require_once "../../includes/sidebar.php";
?>

<main class="main-content">
    <div class="topbar">
        <h1 class="page-title">Edit Pengajar</h1>

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
                <h4 class="fw-bold mb-4">Form Edit Pengajar</h4>

                <form action="proses_edit.php" method="post">
                    <input type="hidden" name="id_pengajar" value="<?= aman($pengajar['id_pengajar']); ?>">

                    <div class="mb-3">
                        <label class="form-label">NIP</label>
                        <input type="number" name="nip" class="form-control" maxlength="20" value="<?= aman($pengajar['nip']); ?>" required>
                    </div>

                    <div class="mb-3">
                        <label class="form-label">Nama Pengajar</label>
                        <input type="text" name="nama_pengajar" class="form-control" maxlength="50" value="<?= aman($pengajar['nama_pengajar']); ?>" required>
                    </div>

                    <div class="mb-3">
                        <label class="form-label">Email</label>
                        <input type="email" name="email" class="form-control" maxlength="50" value="<?= aman($pengajar['email'] ?? ''); ?>">
                    </div>

                    <div class="mb-4">
                        <label class="form-label">No HP</label>
                        <input type="number" name="no_hp" class="form-control" maxlength="20" value="<?= aman($pengajar['no_hp'] ?? ''); ?>">
                    </div>

                    <div class="d-flex gap-2">
                        <button type="submit" name="update" class="btn btn-primary">
                            <i class="fa-solid fa-floppy-disk me-1"></i>
                            Simpan Perubahan
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