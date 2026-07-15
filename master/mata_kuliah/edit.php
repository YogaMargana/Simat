<?php
require_once "../../config/koneksi.php";
require_once "../../config/function.php";
require_once "../../includes/auth_dashboard.php";

// /** @var mysqli $koneksi */

cek_role_dashboard("Kepala Prodi");

$page_title = "Edit Mata Kuliah";
$active_menu = "mata_kuliah";

$id_matakuliah = $_GET['id'] ?? '';

if ($id_matakuliah == '') {
    header("Location: index.php?error=" . urlencode("ID mata kuliah tidak ditemukan."));
    exit;
}

$matakuliah = ambil_satu_procedure_prepared(
    $koneksi,
    "CALL usp_select_mata_kuliah_by_id(?)",
    "i",
    [(int) $id_matakuliah]
);

if (!$matakuliah) {
    header("Location: index.php?error=" . urlencode("Data mata kuliah tidak ditemukan."));
    exit;
}

if ($matakuliah['status_mata_kuliah'] === "Tidak Aktif") {
    header("Location: index.php?error=" . urlencode("Data mata kuliah tidak aktif tidak dapat diedit."));
    exit;
}

$data_kelas = ambil_data_procedure($koneksi, "CALL usp_select_kelas_aktif()");
$data_kelas_terpilih = ambil_data_procedure_prepared(
    $koneksi,
    "CALL usp_select_kelas_mata_kuliah_by_id(?)",
    "i",
    [(int) $id_matakuliah]
);
$id_kelas_terpilih = array_map('intval', array_column($data_kelas_terpilih, 'id_kelas'));

require_once "../../includes/dashboard_header.php";
require_once "../../includes/sidebar.php";
?>

<main class="main-content">
    <div class="topbar">
        <h1 class="page-title">Edit Mata Kuliah</h1>

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
                <h4 class="fw-bold mb-4">Form Edit Mata Kuliah</h4>

                <form action="proses_edit.php" method="post">
                                        <input type="hidden" name="id_matakuliah" value="<?= aman($matakuliah['id_matakuliah']); ?>">

                    <div class="mb-3">
                        <label class="form-label">Nama Mata Kuliah <span class="text-danger">*</span>
</label>
                        <input type="text" name="nama_mata_kuliah" class="form-control" value="<?= aman($matakuliah['nama_mata_kuliah']); ?>" required>
                    </div>

                    <div class="mb-3">
                        <label class="form-label">Kode Mata Kuliah <span class="text-danger">*</span>
</label>
                        <input type="text" name="kode_mata_kuliah" class="form-control" maxlength="10" value="<?= aman($matakuliah['kode_mata_kuliah']); ?>" required>
                    </div>

                    <div class="mb-3">
                        <label class="form-label">SKS <span class="text-danger">*</span>
</label>
                        <input type="number" name="sks" class="form-control" min="1" max="6" value="<?= aman($matakuliah['sks']); ?>" required>
                    </div>

                    <div class="mb-4">
                        <label class="form-label">Semester <span class="text-danger">*</span>
</label>
                        <select name="semester" class="form-select" required>
                            <option value="">Pilih Semester</option>
                            <option value="1" <?= $matakuliah['semester'] == "1" ? "selected" : ""; ?>>Semester 1</option>
                            <option value="2" <?= $matakuliah['semester'] == "2" ? "selected" : ""; ?>>Semester 2</option>
                            <option value="3" <?= $matakuliah['semester'] == "3" ? "selected" : ""; ?>>Semester 3</option>
                            <option value="4" <?= $matakuliah['semester'] == "4" ? "selected" : ""; ?>>Semester 4</option>
                        </select>
                    </div>

                    <div class="mb-4">
                        <label class="form-label">Status Mata Kuliah <span class="text-danger">*</span>
</label>
                        <select name="status_mata_kuliah" class="form-select" required>
                            <option value="">Pilih Status Mata Kuliah</option>
                            <option value="Aktif" <?= $matakuliah['status_mata_kuliah'] == "Aktif" ? "selected" : ""; ?>>Aktif</option>
                            <option value="Tidak Aktif" <?= $matakuliah['status_mata_kuliah'] == "Tidak Aktif" ? "selected" : ""; ?>>Tidak Aktif</option>
                        </select>
                    </div>

                    <div class="mb-4">
                        <label class="form-label">Kelas Aktif <span class="text-danger">*</span></label>
                        <div class="border rounded p-3">
                            <?php if (count($data_kelas) > 0) { ?>
                                <div class="row g-2">
                                    <?php foreach ($data_kelas as $kelas) { ?>
                                        <?php $dipilih = in_array((int) $kelas['id_kelas'], $id_kelas_terpilih, true); ?>
                                        <div class="col-md-6 col-lg-4">
                                            <div class="form-check">
                                                <input
                                                    class="form-check-input kelas-checkbox"
                                                    type="checkbox"
                                                    name="id_kelas[]"
                                                    value="<?= (int) $kelas['id_kelas']; ?>"
                                                    id="kelas_<?= (int) $kelas['id_kelas']; ?>"
                                                    <?= $dipilih ? 'checked' : ''; ?>
                                                >
                                                <label class="form-check-label" for="kelas_<?= (int) $kelas['id_kelas']; ?>">
                                                    <?= aman($kelas['nama_kelas']); ?> - Tingkat <?= aman($kelas['tingkat']); ?>
                                                </label>
                                            </div>
                                        </div>
                                    <?php } ?>
                                </div>
                                <small class="text-muted d-block mt-2">Pilih minimal satu kelas aktif. Relasi yang sudah dipakai transaksi jam minus tidak dapat dilepas.</small>
                            <?php } else { ?>
                                <div class="text-danger">Belum ada kelas aktif.</div>
                            <?php } ?>
                        </div>
                    </div>

                    <div class="d-flex gap-2">
                        <button type="submit" name="update" class="btn btn-primary" <?= count($data_kelas) === 0 ? 'disabled' : ''; ?>>
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

<script>
document.querySelector('form').addEventListener('submit', function (event) {
    if (document.querySelectorAll('.kelas-checkbox:checked').length < 1) {
        event.preventDefault();
        Swal.fire({
            icon: 'warning',
            title: 'Kelas Wajib Dipilih',
            text: 'Pilih minimal satu kelas aktif.',
            confirmButtonColor: '#0d6efd'
        });
    }
});
</script>

<?php require_once "../../includes/dashboard_footer.php"; ?>