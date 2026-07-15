<?php
require_once "../../config/koneksi.php";
require_once "../../config/function.php";
require_once "../../includes/auth_dashboard.php";

cek_role_dashboard("Kepala Prodi");

$page_title = "Tambah Mata Kuliah";
$active_menu = "mata_kuliah";

$data_kelas = ambil_data_procedure($koneksi, "CALL usp_select_kelas_aktif()");

require_once "../../includes/dashboard_header.php";
require_once "../../includes/sidebar.php";
?>

<main class="main-content">
    <div class="topbar">
        <h1 class="page-title">Tambah Mata Kuliah</h1>

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
                <h4 class="fw-bold mb-4">Form Tambah Mata Kuliah</h4>

                <form action="proses_tambah.php" method="post">
                                        <div class="mb-3">
                        <label class="form-label">Nama Mata Kuliah <span class="text-danger">*</span>
</label>
                        <input type="text" name="nama_mata_kuliah" class="form-control"placeholder="Contoh: Pemograman Web" required>
                    </div>

                    <div class="mb-3">
                        <label class="form-label">Kode Mata Kuliah <span class="text-danger">*</span>
</label>
                        <input type="text" name="kode_mata_kuliah" class="form-control" maxlength="10" placeholder="Contoh: PW001" required>
                    </div>

                    <div class="mb-3">
                        <label class="form-label">SKS <span class="text-danger">*</span>
</label>
                        <input type="number" name="sks" class="form-control" min="1" max="6" placeholder="Contoh: 3" required>
                    </div>

                    <div class="mb-3">
                        <label class="form-label">Semester <span class="text-danger">*</span>
</label>
                        <select name="semester" class="form-control" required>
                            <option value="">Pilih Semester</option>
                            <option value="1">Semester 1</option>
                            <option value="2">Semester 2</option>
                            <option value="3">Semester 3</option>
                            <option value="4">Semester 4</option>
                            <option value="5">Semester 5</option>
                            <option value="6">Semester 6</option>
                            <option value="7">Semester 7</option>
                            <option value="8">Semester 8</option>
                        </select>
                    </div>

                    <div class="mb-4">
                        <label class="form-label">Kelas Aktif <span class="text-danger">*</span></label>
                        <div class="border rounded p-3">
                            <?php if (count($data_kelas) > 0) { ?>
                                <div class="row g-2">
                                    <?php foreach ($data_kelas as $kelas) { ?>
                                        <div class="col-md-6 col-lg-4">
                                            <div class="form-check">
                                                <input
                                                    class="form-check-input kelas-checkbox"
                                                    type="checkbox"
                                                    name="id_kelas[]"
                                                    value="<?= (int) $kelas['id_kelas']; ?>"
                                                    id="kelas_<?= (int) $kelas['id_kelas']; ?>"
                                                >
                                                <label class="form-check-label" for="kelas_<?= (int) $kelas['id_kelas']; ?>">
                                                    <?= aman($kelas['nama_kelas']); ?> - Tingkat <?= aman($kelas['tingkat']); ?>
                                                </label>
                                            </div>
                                        </div>
                                    <?php } ?>
                                </div>
                                <small class="text-muted d-block mt-2">Pilih minimal satu kelas aktif untuk mata kuliah ini.</small>
                            <?php } else { ?>
                                <div class="text-danger">Belum ada kelas aktif. Tambahkan atau aktifkan kelas terlebih dahulu.</div>
                            <?php } ?>
                        </div>
                    </div>

                    <div class="d-flex gap-2">
                        <button type="submit" name="simpan" class="btn btn-primary" <?= count($data_kelas) === 0 ? 'disabled' : ''; ?>>
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