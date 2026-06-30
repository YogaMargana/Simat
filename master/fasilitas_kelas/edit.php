<?php
require_once "../../config/koneksi.php";
require_once "../../config/function.php";
require_once "../../includes/auth_dashboard.php";

cek_role_dashboard("PIC Aset Fasilitas");

$page_title = "Tambah Fasilitas Kelas";
$active_menu = "fasilitas_kelas";

$id_detail = (int) ($_GET['id'] ?? 0);

if ($id_detail <= 0) {
    header("Location: index.php?error=" . urlencode("ID fasilitas kelas tidak valid."));
    exit;
}

$stmt = mysqli_prepare($koneksi, "CALL usp_select_fasilitas_kelas_by_id(?)");
mysqli_stmt_bind_param($stmt, "i", $id_detail);
mysqli_stmt_execute($stmt);

$result = mysqli_stmt_get_result($stmt);
$detail = mysqli_fetch_assoc($result);

mysqli_stmt_close($stmt);
mysqli_next_result($koneksi);

if (!$detail) {
    header("Location: index.php?error=" . urlencode("Data fasilitas kelas tidak ditemukan."));
    exit;
}

$data_kelas = ambil_data_procedure($koneksi, "CALL usp_select_kelas_aktif()");
$data_fasilitas = ambil_data_procedure($koneksi, "CALL usp_select_fasilitas_aktif()");

require_once "../../includes/dashboard_header.php";
require_once "../../includes/sidebar.php";
?>

<main class="main-content">
    <div class="topbar">
        <h1 class="page-title">Tambah Fasilitas Kelas</h1>

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
                <h4 class="fw-bold mb-4">Form Tambah Fasilitas Kelas</h4>

                <form action="proses_edit.php" method="post">
                    <input type="hidden" name="id_detail_fasilitas_pada_kelas" value="<?= $detail['id_detail_fasilitas_pada_kelas']; ?>">

                    <div class="mb-3">
                        <label class="form-label">Kelas</label>
                        <select name="id_kelas" class="form-select" required>
                            <option value="">Pilih Kelas</option>
                            <?php foreach ($data_kelas as $kelas) { ?>
                                <option value="<?= $kelas['id_kelas']; ?>" <?= $kelas['id_kelas'] == $detail['id_kelas'] ? 'selected' : ''; ?>>
                                    <?= aman($kelas['nama_kelas'] . " - Tingkat " . $kelas['tingkat']); ?>
                                </option>
                            <?php } ?>
                        </select>
                    </div>

                    <div class="mb-3">
                        <label class="form-label">Fasilitas</label>
                        <select name="id_fasilitas" class="form-select" required>
                            <option value="">Pilih Fasilitas</option>
                            <?php foreach ($data_fasilitas as $fasilitas) { ?>
                                <option value="<?= $fasilitas['id_fasilitas']; ?>" <?= $fasilitas['id_fasilitas'] == $detail['id_fasilitas'] ? 'selected' : ''; ?>>
                                    <?= aman($fasilitas['nama_fasilitas']); ?>
                                </option>
                            <?php } ?>
                        </select>
                    </div>

                    <div class="mb-4">
                        <label class="form-label">Jumlah Fasilitas</label>
                        <input type="number" name="jumlah_fasilitas" class="form-control" min="1" value="<?= aman($detail['jumlah_fasilitas']); ?>" required>
                    </div>

                    <div class="mb-4">
                        <label class="form-label">Kondisi Saat Ini</label>
                        <input type="text" class="form-control" value="<?= aman($detail['status_detail_fasilitas_pada_kelas']); ?>" disabled>
                        <small class="text-muted">
                            Status Aktif menjadi Rusak hanya berubah melalui pengaduan fasilitas. Menu ini hanya bisa memulihkan Rusak menjadi Aktif.
                        </small>
                    </div>

                    <div class="d-flex gap-2">
                        <button type="submit" name="update" class="btn btn-primary">
                            <i class="fa-solid fa-floppy-disk me-1"></i>
                            Ubah
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