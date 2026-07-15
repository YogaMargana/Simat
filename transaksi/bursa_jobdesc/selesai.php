<?php
require_once "../../config/koneksi.php";
require_once "../../config/function.php";
require_once "../../includes/auth_dashboard.php";

$role = $_SESSION['role'] ?? '';

if ($role != "Mahasiswa") {
    header("Location: /SIMAT/index.php");
    exit;
}

$id_bursa_jobdesc = $_GET['id'] ?? '';

if ($id_bursa_jobdesc == '') {
    header("Location: index.php?error=" . urlencode("ID bursa jobdesc tidak ditemukan."));
    exit;
}

$data_jobdesc = ambil_satu_procedure_prepared(
    $koneksi,
    "CALL usp_select_bursa_jobdesc_penerima_by_id(?, ?)",
    "ii",
    [(int) $id_bursa_jobdesc, (int) ($_SESSION['id_pengguna'] ?? 0)]
);

if (!$data_jobdesc) {
    header("Location: index.php?error=" . urlencode("Kamu bukan penerima jobdesc ini."));
    exit;
}

$page_title = "Kirim Bukti Selesai Jobdesc";
$active_menu = "bursa_jobdesc";

require_once "../../includes/dashboard_header.php";
require_once "../../includes/sidebar.php";
?>

<main class="main-content">
    <div class="topbar">
        <h1 class="page-title">Kirim Bukti Selesai</h1>

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
        <div class="card border-0 shadow-sm rounded-4">
            <div class="card-body p-4">
                <h4 class="fw-bold mb-3">Form Bukti Selesai Jobdesc</h4>

                <div class="mb-4">
                    <label class="form-label">Deskripsi Jobdesc</label>
                    <div class="form-control bg-light">
                        <?= aman($data_jobdesc['deskripsi_jobdesc']); ?>
                    </div>
                </div>

                <div class="mb-3">
                    <label class="form-label">Status Jobdesc</label><br>

                    <?php if ($data_jobdesc['status_jobdesc'] == "Dikerjakan") { ?>
                        <span class="badge bg-warning text-dark">Dikerjakan</span>
                    <?php } elseif ($data_jobdesc['status_jobdesc'] == "Selesai") { ?>
                        <span class="badge bg-primary">Selesai</span>
                    <?php } else { ?>
                        <span class="badge bg-success">Dibuka</span>
                    <?php } ?>
                </div>

                <?php if (!empty($data_jobdesc['bukti_selesai_url'])) { ?>
                    <div class="alert alert-info">
                        Bukti selesai untuk jobdesc ini sudah dikirim.
                        <br>
                        <a href="<?= aman($data_jobdesc['bukti_selesai_url']); ?>" target="_blank" rel="noopener noreferrer">
                            Lihat Bukti
                        </a>
                    </div>

                    <a href="index.php" class="btn btn-secondary">
                        Kembali
                    </a>

                <?php } elseif ($data_jobdesc['status_jobdesc'] != "Dikerjakan") { ?>
                    <div class="alert alert-warning">
                        Bukti selesai hanya dapat dikirim jika status jobdesc sudah Dikerjakan.
                    </div>

                    <a href="index.php" class="btn btn-secondary">
                        Kembali
                    </a>

                <?php } else { ?>
                    <form action="proses_selesai.php" method="post">
                    <?= csrf_input(); ?>
                        <input type="hidden" name="id_bursa_jobdesc" value="<?= aman($data_jobdesc['id_bursa_jobdesc']); ?>">

                        <div class="mb-4">
                            <label class="form-label">Link Foto Bukti Selesai <span class="text-danger">*</span>
</label>
                            <input type="url" name="bukti_selesai_url" class="form-control" placeholder="Contoh: link Google Drive foto bukti" required>
                            <small class="text-muted">
                                Masukkan link foto bukti selesai, misalnya link Google Drive atau link gambar.
                            </small>
                        </div>

                        <div class="d-flex gap-2">
                            <button type="submit" name="simpan" class="btn btn-primary">
                                <i class="fa-solid fa-floppy-disk me-1"></i>
                                Kirim Bukti
                            </button>

                            <a href="index.php" class="btn btn-secondary">
                                Kembali
                            </a>
                        </div>
                    </form>
                <?php } ?>
            </div>
        </div>
    </div>
</main>

<?php require_once "../../includes/dashboard_footer.php"; ?>