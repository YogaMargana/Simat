<?php
require_once "../../config/koneksi.php";
require_once "../../config/function.php";
require_once "../../includes/auth_dashboard.php";

cek_role_dashboard("Kepala Prodi");

$page_title = "Tambah Pengajar Mata Kuliah";
$active_menu = "pengajar_mata_kuliah";

$id = (int) ($_GET['id'] ?? 0);

if ($id <= 0) {
    header("Location: index.php?error=" . urlencode("ID tidak valid."));
    exit;
}

$stmt = mysqli_prepare($koneksi, "CALL usp_select_pengajar_mata_kuliah_kelas_by_id(?)");
mysqli_stmt_bind_param($stmt, "i", $id);
mysqli_stmt_execute($stmt);

$result = mysqli_stmt_get_result($stmt);
$detail = mysqli_fetch_assoc($result);

mysqli_stmt_close($stmt);
mysqli_next_result($koneksi);

if (!$detail) {
    header("Location: index.php?error=" . urlencode("Data tidak ditemukan."));
    exit;
}

$data_kelas = ambil_data_procedure($koneksi, "CALL usp_select_kelas_aktif()");
$data_mata_kuliah = ambil_data_procedure($koneksi, "CALL usp_select_mata_kuliah_aktif()");
$data_pengajar = ambil_data_procedure($koneksi, "CALL usp_select_pengajar_aktif()");

require_once "../../includes/dashboard_header.php";
require_once "../../includes/sidebar.php";
?>

<main class="main-content">
    <div class="topbar">
        <h1 class="page-title">Edit Pengajar Mata Kuliah</h1>

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
                <h4 class="fw-bold mb-4">Form Edit Pengajar Mata Kuliah</h4>

                <form action="proses_edit.php" method="post">
                    <input type="hidden" name="id_detail_kelas_pada_mata_kuliah" value="<?= $detail['id_detail_kelas_pada_mata_kuliah']; ?>">

                    <div class="mb-3">
                        <label class="form-label">Kelas</label>
                        <select name="id_kelas" class="form-select" required>
                            <option value="">Pilih Kelas</option>
                            <?php foreach ($data_kelas as $kelas) { ?>
                                <option value="<?= $kelas['id_kelas']; ?>" <?= $kelas['id_kelas'] == $detail['id_kelas'] ? 'selected' : ''; ?>>
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
                                <option value="<?= $mk['id_mata_kuliah']; ?>" <?= $mk['id_mata_kuliah'] == $detail['id_mata_kuliah'] ? 'selected' : ''; ?>>
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
                                <option value="<?= $pengajar['id_pengajar']; ?>" <?= $pengajar['id_pengajar'] == $detail['id_pengajar_1'] ? 'selected' : ''; ?>>
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
                                <option value="<?= $pengajar['id_pengajar']; ?>" <?= $pengajar['id_pengajar'] == $detail['id_pengajar_2'] ? 'selected' : ''; ?>>
                                    <?= aman($pengajar['nama_pengajar']); ?>
                                </option>
                            <?php } ?>
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