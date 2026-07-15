<?php
require_once "../../config/koneksi.php";
require_once "../../config/function.php";
require_once "../../includes/auth_dashboard.php";

cek_role_dashboard("PIC Aset Fasilitas");

$page_title = "Edit Fasilitas";
$active_menu = "fasilitas";
$id_fasilitas = (int) ($_GET['id'] ?? 0);

if ($id_fasilitas <= 0) {
    header("Location: index.php?error=" . urlencode("ID fasilitas tidak ditemukan."));
    exit;
}

$fasilitas = ambil_satu_procedure_prepared(
    $koneksi,
    "CALL usp_select_fasilitas_by_id(?)",
    "i",
    [$id_fasilitas]
);

if (!$fasilitas) {
    header("Location: index.php?error=" . urlencode("Data fasilitas tidak ditemukan."));
    exit;
}

if ($fasilitas['status_fasilitas'] !== 'Aktif') {
    header("Location: index.php?error=" . urlencode("Data fasilitas tidak aktif tidak dapat diedit."));
    exit;
}

$data_kelas = ambil_data_procedure_prepared(
    $koneksi,
    "CALL usp_select_kelas_dengan_status_fasilitas(?)",
    "i",
    [$id_fasilitas]
);

require_once "../../includes/dashboard_header.php";
require_once "../../includes/sidebar.php";
?>

<main class="main-content">
    <div class="topbar">
        <h1 class="page-title">Edit Fasilitas</h1>
        <div class="user-info">
            <div class="user-detail">
                <div class="user-name"><?= aman($_SESSION['username']); ?></div>
                <div class="user-role"><?= aman($_SESSION['role']); ?></div>
            </div>
            <div class="user-avatar"><?= strtoupper(substr($_SESSION['username'], 0, 1)); ?></div>
        </div>
    </div>

    <div class="content-wrapper">
        <?php if (isset($_GET['status']) && $_GET['status'] === 'berhasil_pulihkan') { ?>
            <div class="alert alert-success">Kondisi fasilitas kelas berhasil dipulihkan menjadi aktif.</div>
        <?php } ?>
        <?php if (isset($_GET['error'])) { ?>
            <div class="alert alert-danger"><?= aman($_GET['error']); ?></div>
        <?php } ?>

        <div class="card border-0 shadow-sm rounded-4">
            <div class="card-body p-4">
                <h4 class="fw-bold mb-4">Form Edit Fasilitas</h4>

                <form action="proses_edit.php" method="post" id="form-fasilitas">
                                        <input type="hidden" name="id_fasilitas" value="<?= (int) $fasilitas['id_fasilitas']; ?>">

                    <div class="mb-3">
                        <label class="form-label">Nama Fasilitas <span class="text-danger">*</span>
</label>
                        <input type="text" name="nama_fasilitas" class="form-control" maxlength="50" value="<?= aman($fasilitas['nama_fasilitas']); ?>" required>
                    </div>

                    <div class="mb-3">
                        <label class="form-label">Harga <span class="text-danger">*</span>
</label>
                        <input type="number" name="harga" class="form-control" min="0" step="1000" value="<?= aman($fasilitas['harga']); ?>" required>
                    </div>

                    <div class="mb-4">
                        <label class="form-label fw-bold">Kelas Pengguna Fasilitas <span class="text-danger">*</span>
</label>
                        <div class="form-text mb-2">Pilih minimal satu kelas aktif. Fasilitas berstatus rusak harus dipulihkan sebelum dapat dilepas dari kelas.</div>
                        <div class="row g-2">
                            <?php foreach ($data_kelas as $kelas) { ?>
                                <?php
                                $status_detail = $kelas['status_detail_fasilitas_pada_kelas'] ?? null;
                                $terpilih = in_array($status_detail, ['Aktif', 'Rusak'], true);
                                $rusak = $status_detail === 'Rusak';
                                ?>
                                <div class="col-md-6 col-lg-4">
                                    <div class="border rounded-3 p-3 h-100">
                                        <label class="d-flex align-items-center gap-2 mb-0">
                                            <input type="checkbox" class="form-check-input kelas-checkbox" name="id_kelas[]" value="<?= (int) $kelas['id_kelas']; ?>" <?= $terpilih ? 'checked' : ''; ?> <?= $rusak ? 'disabled' : ''; ?>>
                                            <span><?= aman($kelas['nama_kelas'] . ' - Tingkat ' . $kelas['tingkat']); ?></span>
                                        </label>

                                        <?php if ($rusak) { ?>
                                            <input type="hidden" name="id_kelas[]" value="<?= (int) $kelas['id_kelas']; ?>">
                                            <div class="mt-2 d-flex align-items-center justify-content-between gap-2">
                                                <span class="badge bg-danger">Rusak</span>
                                                <button type="submit" form="pulihkan-<?= (int) $kelas['id_detail_fasilitas_pada_kelas']; ?>" class="btn btn-success btn-sm">
                                                    <i class="fa-solid fa-rotate-left me-1"></i>Pulihkan
                                                </button>
                                            </div>
                                        <?php } elseif ($status_detail === 'Aktif') { ?>
                                            <div class="mt-2"><span class="badge bg-success">Aktif</span></div>
                                        <?php } ?>
                                    </div>
                                </div>
                            <?php } ?>
                        </div>
                    </div>

                    <div class="d-flex gap-2">
                        <button type="submit" name="update" class="btn btn-primary">
                            <i class="fa-solid fa-floppy-disk me-1"></i> Simpan Perubahan
                        </button>
                        <a href="index.php" class="btn btn-secondary">Kembali</a>
                    </div>
                </form>

                <?php foreach ($data_kelas as $kelas) { ?>
                    <?php if (($kelas['status_detail_fasilitas_pada_kelas'] ?? null) === 'Rusak') { ?>
                        <form id="pulihkan-<?= (int) $kelas['id_detail_fasilitas_pada_kelas']; ?>" action="pulihkan_kondisi.php" method="post" onsubmit="return confirm('Yakin fasilitas pada kelas ini sudah diperbaiki?');">
                                                        <input type="hidden" name="id_fasilitas" value="<?= (int) $id_fasilitas; ?>">
                            <input type="hidden" name="id_detail_fasilitas_pada_kelas" value="<?= (int) $kelas['id_detail_fasilitas_pada_kelas']; ?>">
                        </form>
                    <?php } ?>
                <?php } ?>
            </div>
        </div>
    </div>
</main>

<script>
document.getElementById('form-fasilitas').addEventListener('submit', function (event) {
    const checked = document.querySelectorAll('.kelas-checkbox:checked').length;
    const hiddenRusak = this.querySelectorAll('input[type="hidden"][name="id_kelas[]"]').length;
    if (checked + hiddenRusak < 1) {
        event.preventDefault();
        alert('Pilih minimal satu kelas untuk fasilitas.');
    }
});
</script>

<?php require_once "../../includes/dashboard_footer.php"; ?>
