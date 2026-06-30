<?php
require_once "../../config/koneksi.php";
require_once "../../config/function.php";
require_once "../../includes/auth_dashboard.php";

cek_role_dashboard("PIC Aset Fasilitas");

$page_title = "Edit Fasilitas";
$active_menu = "fasilitas";

$id_fasilitas = $_GET['id'] ?? '';

if ($id_fasilitas == '') {
    header("Location: index.php?error=" . urlencode("ID fasilitas tidak ditemukan."));
    exit;
}

$stmt = mysqli_prepare($koneksi, "
    SELECT
        f.id_fasilitas,
        f.nama_fasilitas,
        f.harga,
        f.status_fasilitas,
        dfpk.id_kelas,
        dfpk.jumlah_fasilitas,
        dfpk.status_detail_fasilitas_pada_kelas
    FROM fasilitas f
    LEFT JOIN detail_fasilitas_pada_kelas dfpk
        ON f.id_fasilitas = dfpk.id_fasilitas
    WHERE f.id_fasilitas = ?
    LIMIT 1
");

$stmt = mysqli_prepare($koneksi, "CALL usp_select_fasilitas_by_id(?)");
mysqli_stmt_bind_param($stmt, "i", $id_fasilitas);
mysqli_stmt_execute($stmt);

$result = mysqli_stmt_get_result($stmt);
$fasilitas = mysqli_fetch_assoc($result);

mysqli_stmt_close($stmt);
mysqli_next_result($koneksi);

if (!$fasilitas) {
    header("Location: index.php?error=" . urlencode("Data fasilitas tidak ditemukan."));
    exit;
}

if ($fasilitas['status_fasilitas'] == "Tidak Aktif") {
    header("Location: index.php?error=" . urlencode("Data fasilitas tidak aktif tidak dapat diedit."));
    exit;
}

$data_kelas = [];

$query_kelas = mysqli_query($koneksi, "
    SELECT id_kelas, nama_kelas, tingkat 
    FROM kelas 
    WHERE status_kelas = 'Aktif' 
    ORDER BY nama_kelas ASC
");

while ($row = mysqli_fetch_assoc($query_kelas)) {
    $data_kelas[] = $row;
}

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
                <h4 class="fw-bold mb-4">Form Edit Fasilitas</h4>

                <form action="proses_edit.php" method="post">
                    <input type="hidden" name="id_fasilitas" value="<?= aman($fasilitas['id_fasilitas']); ?>">

                    <div class="mb-3">
                        <label class="form-label">Nama Fasilitas</label>
                        <input type="text" name="nama_fasilitas" class="form-control" maxlength="50" value="<?= aman($fasilitas['nama_fasilitas']); ?>" required>
                    </div>

                    <div class="mb-4">
                        <label class="form-label">Harga</label>
                        <input type="number" name="harga" class="form-control" min="0" step="1000" value="<?= aman($fasilitas['harga']); ?>" required>
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