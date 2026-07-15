<?php
require_once "../../config/koneksi.php";
require_once "../../config/function.php";
require_once "../../includes/auth_dashboard.php";

cek_role_dashboard("PIC Kemahasiswaan");

$page_title = "Edit Kegiatan";
$active_menu = "kegiatan";

$id_kegiatan = (int) ($_GET['id'] ?? 0);

if ($id_kegiatan <= 0) {
    header("Location: index.php?error=" . urlencode("ID kegiatan tidak valid."));
    exit;
}

$stmt = mysqli_prepare($koneksi, "CALL usp_select_kegiatan_by_id(?)");
mysqli_stmt_bind_param($stmt, "i", $id_kegiatan);
mysqli_stmt_execute($stmt);

$result = mysqli_stmt_get_result($stmt);
$kegiatan = mysqli_fetch_assoc($result);

mysqli_stmt_close($stmt);
mysqli_next_result($koneksi);

if (!$kegiatan || $kegiatan['status_kegiatan'] != 'Aktif') {
    header("Location: index.php?error=" . urlencode("Data kegiatan tidak ditemukan atau sudah tidak aktif."));
    exit;
}

require_once "../../includes/dashboard_header.php";
require_once "../../includes/sidebar.php";
?>

<main class="main-content">
    <div class="topbar">
        <h1 class="page-title">Edit Kegiatan</h1>

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
                <h4 class="fw-bold mb-4">Form Edit Kegiatan</h4>

                <form action="proses_edit.php" method="post">
                    <?= csrf_input(); ?>
                    <input type="hidden" name="id_kegiatan" value="<?= aman($kegiatan['id_kegiatan']); ?>">

                    <div class="mb-3">
                        <label class="form-label">Nama Kegiatan <span class="text-danger">*</span>
</label>
                        <input type="text" name="nama_kegiatan" class="form-control" maxlength="50" value="<?= aman($kegiatan['nama_kegiatan']); ?>" required>
                    </div>

                    <div class="mb-3">
                        <label class="form-label">Penyelenggara <span class="text-danger">*</span>
</label>
                        <select name="penyelenggara" class="form-select" required>
                            <option value="">Pilih Penyelenggara</option>
                            <option value="ASTRAtech" <?= $kegiatan['penyelenggara'] == 'ASTRAtech' ? 'selected' : ''; ?>>ASTRAtech</option>
                            <option value="BEM" <?= $kegiatan['penyelenggara'] == 'BEM' ? 'selected' : ''; ?>>BEM</option>
                            <option value="MPM" <?= $kegiatan['penyelenggara'] == 'MPM' ? 'selected' : ''; ?>>MPM</option>
                            <option value="HIMMA" <?= $kegiatan['penyelenggara'] == 'HIMMA' ? 'selected' : ''; ?>>HIMMA</option>
                            <option value="UKM" <?= $kegiatan['penyelenggara'] == 'UKM' ? 'selected' : ''; ?>>UKM</option>
                            <option value="Prodi" <?= $kegiatan['penyelenggara'] == 'Prodi' ? 'selected' : ''; ?>>Prodi</option>
                        </select>
                    </div>

                    <div class="mb-4">
                        <label class="form-label">Tanggal Kegiatan</label>
                        <input type="date" name="tanggal_kegiatan" class="form-control" value="<?= aman($kegiatan['tanggal_kegiatan']); ?>">
                        <small class="text-muted">
                            Boleh dikosongkan jika tanggal kegiatan belum ditentukan.
                        </small>
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