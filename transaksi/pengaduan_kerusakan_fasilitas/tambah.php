<?php
require_once "../../config/koneksi.php";
require_once "../../config/function.php";
require_once "../../includes/auth_dashboard.php";

cek_role_dashboard("PIC Aset Fasilitas");

$page_title = "Tambah Pengaduan Fasilitas";
$active_menu = "pengaduan_fasilitas";

$data_fasilitas = [];

$stmt = mysqli_prepare($koneksi, "
    SELECT 
        f.id_fasilitas,
        f.nama_fasilitas,
        k.nama_kelas,
        dfpk.jumlah_fasilitas,
        dfpk.status_detail_fasilitas_pada_kelas
    FROM pengguna p
    JOIN mahasiswa m 
        ON p.id_mahasiswa = m.id_mahasiswa
    JOIN kelas k 
        ON m.id_kelas = k.id_kelas
    JOIN detail_fasilitas_pada_kelas dfpk 
        ON m.id_kelas = dfpk.id_kelas
    JOIN fasilitas f 
        ON dfpk.id_fasilitas = f.id_fasilitas
    WHERE p.id_pengguna = ?
    AND f.status_fasilitas = 'Aktif'
    AND dfpk.status_detail_fasilitas_pada_kelas = 'Aktif'
    ORDER BY f.nama_fasilitas ASC
");

mysqli_stmt_bind_param($stmt, "i", $_SESSION['id_pengguna']);
mysqli_stmt_execute($stmt);

$result = mysqli_stmt_get_result($stmt);

while ($row = mysqli_fetch_assoc($result)) {
    $data_fasilitas[] = $row;
}

mysqli_stmt_close($stmt);

require_once "../../includes/dashboard_header.php";
require_once "../../includes/sidebar.php";
?>

<main class="main-content">
    <div class="topbar">
        <h1 class="page-title">Buat Pengaduan</h1>

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
                <h4 class="fw-bold mb-4">Form Pengaduan Kerusakan Fasilitas</h4>

                <form action="proses_tambah.php" method="post">
                    <div class="mb-3">
                        <label class="form-label">Fasilitas</label>
                        <select name="id_fasilitas" class="form-select" required>
                            <option value="">Pilih Fasilitas</option>
                            <?php foreach ($data_fasilitas as $fasilitas) { ?>
                                <option value="<?= $fasilitas['id_fasilitas']; ?>">
                                    <?= aman($fasilitas['nama_fasilitas'] . " - " . $fasilitas['nama_kelas']); ?>
                                </option>
                            <?php } ?>
                        </select>
                        <small class="text-muted">
                            Fasilitas yang tampil hanya fasilitas aktif di kelas kamu.
                        </small>
                    </div>

                    <div class="mb-3">
                        <label class="form-label">Deskripsi Kerusakan</label>
                        <textarea name="deskripsi_kerusakan" class="form-control" rows="4" required></textarea>
                    </div>

                    <div class="mb-3">
                        <label class="form-label">Bukti Kerusakan URL</label>
                        <input type="text" name="bukti_kerusakan_url" class="form-control" maxlength="2048" placeholder="Contoh: link Google Drive foto kerusakan">
                    </div>

                    <div class="mb-4">
                        <label class="form-label">Pelaku Kerusakan</label>
                        <input type="text" name="pelaku_kerusakan" class="form-control" maxlength="50" placeholder="Isi jika diketahui, jika tidak kosongkan">
                    </div>

                    <div class="d-flex gap-2">
                        <button type="submit" name="simpan" class="btn btn-primary">
                            <i class="fa-solid fa-paper-plane me-1"></i>
                            Kirim Pengaduan
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