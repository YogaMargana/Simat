<?php
require_once "../../config/koneksi.php";
require_once "../../config/function.php";
require_once "../../includes/auth_dashboard.php";

// /** @var mysqli $koneksi */

cek_role_dashboard("Kepala Prodi");

$page_title = "Edit Kelas";
$active_menu = "kelas";

$id_kelas = $_GET['id'] ?? '';

if ($id_kelas == '') {
    header("Location: index.php?error=" . urlencode("ID kelas tidak ditemukan."));
    exit;
}

$stmt = mysqli_prepare($koneksi, "SELECT * FROM kelas WHERE id_kelas = ? LIMIT 1");
mysqli_stmt_bind_param($stmt, "i", $id_kelas);
mysqli_stmt_execute($stmt);

$result = mysqli_stmt_get_result($stmt);
$kelas = mysqli_fetch_assoc($result);

mysqli_stmt_close($stmt);

if (!$kelas) {
    header("Location: index.php?error=" . urlencode("Data kelas tidak ditemukan."));
    exit;
}

if ($kelas['status_kelas'] == "Tidak Aktif") {
    header("Location: index.php?error=" . urlencode("Data kelas tidak aktif tidak dapat diedit."));
    exit;
}

require_once "../../includes/dashboard_header.php";
require_once "../../includes/sidebar.php";
?>

<main class="main-content">
    <div class="topbar">
        <h1 class="page-title">Edit Kelas</h1>

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
                <h4 class="fw-bold mb-4">Form Edit Kelas</h4>

                <form action="proses_edit.php" method="post">
                    <input type="hidden" name="id_kelas" value="<?= aman($kelas['id_kelas']); ?>">

                    <div class="mb-3">
                        <label class="form-label">Nama Kelas</label>
                        <input type="text" name="nama_kelas" class="form-control" maxlength="5" value="<?= aman($kelas['nama_kelas']); ?>" required>
                    </div>

                    <div class="mb-4">
                        <label class="form-label">Tingkat</label>
                        <select name="tingkat" class="form-select" required>
                            <option value="">Pilih Tingkat</option>
                            <option value="1" <?= $kelas['tingkat'] == "1" ? "selected" : ""; ?>>Tingkat 1</option>
                            <option value="2" <?= $kelas['tingkat'] == "2" ? "selected" : ""; ?>>Tingkat 2</option>
                            <option value="3" <?= $kelas['tingkat'] == "3" ? "selected" : ""; ?>>Tingkat 3</option>
                            <option value="4" <?= $kelas['tingkat'] == "4" ? "selected" : ""; ?>>Tingkat 4</option>
                        </select>
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