<?php
require_once "../../config/koneksi.php";
require_once "../../config/function.php";
require_once "../../includes/auth_dashboard.php";

$role = $_SESSION['role'] ?? '';

if (!in_array($role, ["Mahasiswa", "PIC Aset Fasilitas", "Kepala Prodi"])) {
    header("Location: /SIMAT/index.php");
    exit;
}

$page_title = "Pengaduan Kerusakan Fasilitas";
$active_menu = "pengaduan_fasilitas";

$data_pengaduan = [];

$query = mysqli_query($koneksi, "CALL usp_select_pengaduan_kerusakan_fasilitas()");

if ($query) {
    while ($row = mysqli_fetch_assoc($query)) {
        if ($role == "Mahasiswa" && $row['id_pelapor'] != $_SESSION['id_pengguna']) {
            continue;
        }

        $data_pengaduan[] = $row;
    }

    mysqli_free_result($query);
    mysqli_next_result($koneksi);
}

require_once "../../includes/dashboard_header.php";
require_once "../../includes/sidebar.php";
?>

<main class="main-content">
    <div class="topbar">
        <h1 class="page-title">Pengaduan Fasilitas</h1>

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
        <?php if (isset($_GET['status']) && $_GET['status'] == "berhasil_tambah") { ?>
            <div class="alert alert-success">Pengaduan kerusakan fasilitas berhasil dikirim.</div>
        <?php } ?>

        <?php if (isset($_GET['status']) && $_GET['status'] == "berhasil_verifikasi") { ?>
            <div class="alert alert-success">Pengaduan kerusakan fasilitas berhasil diverifikasi.</div>
        <?php } ?>

        <?php if (isset($_GET['error'])) { ?>
            <div class="alert alert-danger"><?= aman($_GET['error']); ?></div>
        <?php } ?>

        <div class="card border-0 shadow-sm rounded-4">
            <div class="card-body p-4">
                <div class="d-flex flex-column flex-md-row justify-content-between align-items-md-center mb-4 gap-3">
                    <div>
                        <h4 class="fw-bold mb-1">Daftar Pengaduan Kerusakan Fasilitas</h4>
                        <p class="text-muted mb-0">
                            Mahasiswa melaporkan fasilitas rusak, lalu PIC Aset Fasilitas melakukan verifikasi.
                        </p>
                    </div>

                    <?php if ($role == "Mahasiswa") { ?>
                        <a href="tambah.php" class="btn btn-primary">
                            <i class="fa-solid fa-plus me-1"></i>
                            Buat Pengaduan
                        </a>
                    <?php } ?>
                </div>

                <div class="table-responsive">
                    <table class="table table-hover align-middle">
                        <thead class="table-light">
                            <tr>
                                <th style="width: 60px;">No</th>
                                <th>Pelapor</th>
                                <th>Fasilitas</th>
                                <th>Deskripsi</th>
                                <th>Bukti</th>
                                <th>Tanggal</th>
                                <th>Status</th>
                                <th>Verifikator</th>
                                <th style="width: 150px;" class="text-center">Aksi</th>
                            </tr>
                        </thead>
                        <tbody>
                            <?php if (count($data_pengaduan) > 0) { ?>
                                <?php $no = 1; ?>
                                <?php foreach ($data_pengaduan as $pengaduan) { ?>
                                    <tr>
                                        <td><?= $no++; ?></td>

                                        <td>
                                            <?= aman($pengaduan['nama_pelapor'] ?? '-'); ?><br>
                                            <small class="text-muted"><?= aman($pengaduan['username_pelapor'] ?? '-'); ?></small>
                                        </td>

                                        <td><?= aman($pengaduan['nama_fasilitas']); ?></td>

                                        <td><?= aman($pengaduan['deskripsi_kerusakan']); ?></td>

                                        <td>
                                            <?php if (!empty($pengaduan['bukti_kerusakan_url'])) { ?>
                                                <a href="<?= aman($pengaduan['bukti_kerusakan_url']); ?>" target="_blank" class="btn btn-outline-primary btn-sm">
                                                    Lihat
                                                </a>
                                            <?php } else { ?>
                                                <span class="text-muted">-</span>
                                            <?php } ?>
                                        </td>

                                        <td><?= aman($pengaduan['tanggal_pengaduan']); ?></td>

                                        <td>
                                            <?php if ($pengaduan['status_pengaduan'] == "Menunggu Verifikasi") { ?>
                                                <span class="badge bg-warning text-dark">Menunggu Verifikasi</span>
                                            <?php } elseif ($pengaduan['status_pengaduan'] == "Diterima") { ?>
                                                <span class="badge bg-success">Diterima</span>
                                            <?php } else { ?>
                                                <span class="badge bg-danger">Ditolak</span>
                                            <?php } ?>
                                        </td>

                                        <td><?= aman($pengaduan['nama_verifikator'] ?? '-'); ?></td>

                                        <td class="text-center">
                                            <?php if ($role == "PIC Aset Fasilitas" && $pengaduan['status_pengaduan'] == "Menunggu Verifikasi") { ?>
                                                <a href="verifikasi.php?id=<?= $pengaduan['id_pengaduan_kerusakan_fasilitas']; ?>" class="btn btn-primary btn-sm">
                                                    Verifikasi
                                                </a>
                                            <?php } else { ?>
                                                <button type="button" class="btn btn-secondary btn-sm" disabled>
                                                    -
                                                </button>
                                            <?php } ?>
                                        </td>
                                    </tr>
                                <?php } ?>
                            <?php } else { ?>
                                <tr>
                                    <td colspan="9" class="text-center text-muted py-4">
                                        Data pengaduan kerusakan fasilitas belum tersedia.
                                    </td>
                                </tr>
                            <?php } ?>
                        </tbody>
                    </table>
                </div>

            </div>
        </div>
    </div>
</main>

<?php require_once "../../includes/dashboard_footer.php"; ?>