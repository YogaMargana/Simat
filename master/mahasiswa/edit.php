<?php
require_once "../../config/koneksi.php";
require_once "../../config/function.php";
require_once "../../includes/auth_dashboard.php";

// /** @var mysqli $koneksi */

cek_role_dashboard("Kepala Prodi");

$page_title = "Edit Mahasiswa";
$active_menu = "mahasiswa";

$id_mahasiswa = $_GET['id'] ?? '';

if ($id_mahasiswa == '') {
    header("Location: index.php?error=" . urlencode("ID mahasiswa tidak ditemukan."));
    exit;
}

$mahasiswa = ambil_satu_procedure_prepared(
    $koneksi,
    "CALL usp_select_mahasiswa_by_id(?)",
    "i",
    [(int) $id_mahasiswa]
);

if (!$mahasiswa) {
    header("Location: index.php?error=" . urlencode("Data mahasiswa tidak ditemukan."));
    exit;
}

if ($mahasiswa['status_mahasiswa'] === "Tidak Aktif") {
    header("Location: index.php?error=" . urlencode("Data mahasiswa tidak aktif tidak dapat diedit."));
    exit;
}

$data_kelas = ambil_data_procedure($koneksi, "CALL usp_select_kelas_aktif()");
$data_periode = ambil_data_procedure($koneksi, "CALL usp_select_periode_tersedia_mahasiswa()");

require_once "../../includes/dashboard_header.php";
require_once "../../includes/sidebar.php";
?>

<main class="main-content">
    <div class="topbar">
        <h1 class="page-title">Edit Mahasiswa</h1>

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
                <h4 class="fw-bold mb-4">Form Edit Mahasiswa</h4>

                <form action="proses_edit.php" method="post">
                                        <input type="hidden" name="id_mahasiswa" value="<?= aman($mahasiswa['id_mahasiswa']); ?>">

                    <div class="mb-3">
                        <label class="form-label">Kelas <span class="text-danger">*</span>
</label>
                        <select name="id_kelas" class="form-select" required>
                            <option value="">Pilih Kelas</option>
                            <?php foreach ($data_kelas as $kelas) { ?>
                                <option value="<?= $kelas['id_kelas']; ?>" <?= $kelas['id_kelas'] == $mahasiswa['id_kelas'] ? 'selected' : ''; ?>>
                                    <?= aman($kelas['nama_kelas'] . " - Tingkat " . $kelas['tingkat']); ?>
                                </option>
                            <?php } ?>
                        </select>
                    </div>

                    <div class="mb-3">
                        <label class="form-label">Periode Akademik <span class="text-danger">*</span>
</label>
                        <select name="id_periode_akademik" class="form-select" required>
                            <option value="">Pilih Periode Akademik</option>
                            <?php foreach ($data_periode as $periode) { ?>
                                <option value="<?= $periode['id_periode_akademik']; ?>" <?= $periode['id_periode_akademik'] == $mahasiswa['id_periode_akademik'] ? 'selected' : ''; ?>>
                                    <?= aman($periode['tahun_akademik'] . " - " . $periode['semester']); ?>
                                </option>
                            <?php } ?>
                        </select>
                        <small class="text-warning d-block mt-1">Perubahan periode akademik akan mereset saldo jam plus murni dan jam plus kompensasi menjadi 0.</small>
                    </div>

                    <div class="mb-3">
                        <label class="form-label">NIM <span class="text-danger">*</span>
</label>
                        <input type="text" inputmode="numeric" pattern="[0-9]+" name="nim" class="form-control" maxlength="20" value="<?= aman($mahasiswa['nim']); ?>" required>
                    </div>

                    <div class="mb-3">
                        <label class="form-label">Nama Mahasiswa <span class="text-danger">*</span>
</label>
                        <input type="text" name="nama_mahasiswa" class="form-control" maxlength="50" value="<?= aman($mahasiswa['nama_mahasiswa']); ?>" required>
                    </div>

                    <div class="mb-3">
                        <label class="form-label">Email</label>
                        <input type="email" name="email" class="form-control" maxlength="50" value="<?= aman($mahasiswa['email'] ?? ''); ?>">
                    </div>

                    <div class="mb-3">
                        <label class="form-label">No HP</label>
                        <input type="text" inputmode="numeric" pattern="[0-9]{10,13}" name="no_hp" class="form-control" minlength="10" maxlength="13" value="<?= aman($mahasiswa['no_hp'] ?? ''); ?>">
                    </div>

                    <div class="mb-4">
                        <label class="form-label">Status Mahasiswa <span class="text-danger">*</span>
</label>
                        <select name="status_mahasiswa" class="form-select" required>
                            <option value="Aktif" <?= $mahasiswa['status_mahasiswa'] == "Aktif" ? 'selected' : ''; ?>>Aktif</option>
                            <option value="Lulus" <?= $mahasiswa['status_mahasiswa'] == "Lulus" ? 'selected' : ''; ?>>Lulus</option>
                            <option value="Cuti" <?= $mahasiswa['status_mahasiswa'] == "Cuti" ? 'selected' : ''; ?>>Cuti</option>
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