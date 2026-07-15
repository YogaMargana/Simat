<?php
require_once "../../config/koneksi.php";
require_once "../../config/function.php";
require_once "../../includes/auth_dashboard.php";

// Pastikan hanya Kepala Prodi yang bisa akses
cek_role_dashboard("Kepala Prodi");

$page_title = "Edit Periode Akademik";
$active_menu = "periode_akademik";

$id_periode_akademik = $_GET['id'] ?? '';

if ($id_periode_akademik == '') {
    header("Location: index.php?error=" . urlencode("ID periode akademik tidak ditemukan."));
    exit;
}

$stmt = mysqli_prepare($koneksi, "CALL usp_select_periode_akademik_by_id(?)");
mysqli_stmt_bind_param($stmt, "i", $id_periode_akademik);
mysqli_stmt_execute($stmt);

$result = mysqli_stmt_get_result($stmt);
$periode = mysqli_fetch_assoc($result);

mysqli_stmt_close($stmt);
mysqli_next_result($koneksi);

if (!$periode) {
    header("Location: index.php?error=" . urlencode("Data periode akademik tidak ditemukan."));
    exit;
}

// Format tanggal agar sesuai dengan input type="date" (YYYY-MM-DD)
$tgl_mulai = date('Y-m-d', strtotime($periode['tanggal_mulai']));
$tgl_selesai = date('Y-m-d', strtotime($periode['tanggal_selesai']));

require_once "../../includes/dashboard_header.php";
require_once "../../includes/sidebar.php";
?>

<main class="main-content">
    <div class="topbar">
        <h1 class="page-title">Edit Periode Akademik</h1>

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

        <div class="card border-0 shadow-sm rounded-4" style="max-width: 650px;">
            <div class="card-body p-4">
                <h4 class="fw-bold mb-4">Form Edit Periode</h4>

                <form action="proses_edit.php" method="post">
                                        <input type="hidden" name="id_periode_akademik" value="<?= aman($periode['id_periode_akademik']); ?>">

                    <div class="mb-3">
                        <label class="form-label fw-bold">Tahun Akademik <span class="text-danger">*</span></label>
                        <input type="text" name="tahun_akademik" class="form-control"
                               value="<?= aman($periode['tahun_akademik']); ?>"
                               placeholder="Contoh: 2025/2026" maxlength="9" pattern="[0-9]{4}/[0-9]{4}" required>
                    </div>

                    <div class="mb-3">
                        <label class="form-label fw-bold">Semester <span class="text-danger">*</span></label>
                        <select name="semester" class="form-select" required>
                            <option value="Ganjil" <?= $periode['semester'] == "Ganjil" ? 'selected' : ''; ?>>Ganjil</option>
                            <option value="Genap" <?= $periode['semester'] == "Genap" ? 'selected' : ''; ?>>Genap</option>
                        </select>
                    </div>

                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label class="form-label fw-bold">Tanggal Mulai <span class="text-danger">*</span></label>
                            <input type="date" name="tanggal_mulai" class="form-control"
                                   value="<?= $tgl_mulai; ?>" required>
                        </div>
                        <div class="col-md-6 mb-3">
                            <label class="form-label fw-bold">Tanggal Selesai <span class="text-danger">*</span></label>
                            <input type="date" name="tanggal_selesai" class="form-control"
                                   value="<?= $tgl_selesai; ?>" required>
                        </div>
                    </div>
                    <div class="alert alert-info mb-4">Status periode tetap <strong>Aktif</strong>. Penonaktifan hanya dapat dilakukan melalui tombol soft delete pada daftar periode.</div>

                    <hr class="my-4">

                    <div class="d-flex gap-2">
                        <button type="submit" name="update" class="btn btn-primary px-4">
                            <i class="fa-solid fa-floppy-disk me-1"></i>
                            Simpan Perubahan
                        </button>

                        <a href="index.php" class="btn btn-light px-4 border">
                            Batal
                        </a>
                    </div>
                </form>
            </div>
        </div>
    </div>
</main>

<?php require_once "../../includes/dashboard_footer.php"; ?>