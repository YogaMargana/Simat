<?php
require_once "../../config/koneksi.php";
require_once "../../config/function.php";
require_once "../../includes/auth_dashboard.php";

// Memastikan hanya Kepala Prodi yang memiliki akses
cek_role_dashboard("Kepala Prodi");

$page_title = "Data Periode Akademik";
$active_menu = "periode_akademik";

$data_periode = [];

$query = mysqli_query($koneksi, "CALL usp_select_periode_akademik()");

if ($query) {
    while ($row = mysqli_fetch_assoc($query)) {
        $data_periode[] = $row;
    }

    mysqli_free_result($query);
    mysqli_next_result($koneksi);
}

require_once "../../includes/dashboard_header.php";
require_once "../../includes/sidebar.php";
?>

<main class="main-content">
    <div class="topbar">
        <h1 class="page-title">Periode Akademik</h1>

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
        <!-- Notifikasi Alert -->
        <?php if (isset($_GET['status']) && $_GET['status'] == "berhasil_tambah") { ?>
            <div class="alert alert-success">Data periode akademik berhasil ditambahkan.</div>
        <?php } ?>

        <?php if (isset($_GET['status']) && $_GET['status'] == "berhasil_edit") { ?>
            <div class="alert alert-success">Data periode akademik berhasil diperbarui.</div>
        <?php } ?>

        <?php if (isset($_GET['status']) && $_GET['status'] == "berhasil_hapus") { ?>
            <div class="alert alert-success">Data periode akademik berhasil dinonaktifkan.</div>
        <?php } ?>

        <?php if (isset($_GET['error'])) { ?>
            <div class="alert alert-danger"><?= aman($_GET['error']); ?></div>
        <?php } ?>

        <div class="card border-0 shadow-sm rounded-4">
            <div class="card-body p-4">
                <div class="d-flex flex-column flex-md-row justify-content-between align-items-md-center mb-4 gap-3">
                    <div>
                        <h4 class="fw-bold mb-1">Daftar Periode</h4>
                        <p class="text-muted mb-0">Kelola setting tahun ajaran dan semester aktif.</p>
                    </div>

                    <a href="tambah.php" class="btn btn-primary">
                        <i class="fa-solid fa-plus me-1"></i>
                        Tambah Periode
                    </a>
                </div>

                <div class="table-responsive">
                    <table class="table table-hover align-middle">
                        <thead class="table-light">
                            <tr>
                                <th style="width: 60px;">No</th>
                                <th>Tahun Akademik</th>
                                <th>Semester</th>
                                <th>Tanggal Mulai</th>
                                <th>Tanggal Selesai</th>
                                <th>Status</th>
                                <th style="width: 150px;" class="text-center">Aksi</th>
                            </tr>
                        </thead>
                        <tbody>
                            <?php if (count($data_periode) > 0) { ?>
                                <?php $no = 1; ?>
                                <?php foreach ($data_periode as $periode) { ?>
                                    <tr>
                                        <td><?= $no++; ?></td>
                                        <td class="fw-bold"><?= aman($periode['tahun_akademik']); ?></td>
                                        <td>
                                            <?php if ($periode['semester'] == "Ganjil") { ?>
                                                <span class="badge rounded-pill bg-info text-dark">Ganjil</span>
                                            <?php } else { ?>
                                                <span class="badge rounded-pill bg-warning text-dark">Genap</span>
                                            <?php } ?>
                                        </td>
                                        <td><?= date('d M Y', strtotime($periode['tanggal_mulai'])); ?></td>
                                        <td><?= date('d M Y', strtotime($periode['tanggal_selesai'])); ?></td>
                                        <td>
                                            <?php if ($periode['status_periode'] == "Aktif") { ?>
                                                <span class="badge bg-success">Aktif</span>
                                            <?php } else { ?>
                                                <span class="badge bg-secondary">Tidak Aktif</span>
                                            <?php } ?>
                                        </td>
                                        <td class="text-center">
                                            <!-- Tombol Edit selalu aktif -->
                                            <a href="edit.php?id=<?= $periode['id_periode_akademik']; ?>" class="btn btn-warning btn-sm me-1">
                                                <i class="fa-solid fa-pen-to-square"></i>
                                            </a>

                                            <?php if ($periode['status_periode'] == "Aktif") { ?>
                                                <a href="hapus.php?id=<?= $periode['id_periode_akademik']; ?>"
                                                class="btn btn-danger btn-sm btn-konfirmasi"
                                                data-title="Nonaktifkan Periode?"
                                                data-text="Data periode akademik akan dinonaktifkan."
                                                data-icon="warning"
                                                data-confirm-text="Ya, nonaktifkan"
                                                data-cancel-text="Batal">
                                                    <i class="fa-solid fa-trash"></i>
                                                </a>
                                            <?php } else { ?>
                                                <button type="button" class="btn btn-secondary btn-sm" disabled title="Periode sudah tidak aktif">
                                                    <i class="fa-solid fa-trash"></i>
                                                </button>
                                            <?php } ?>
                                        </td>
                                    </tr>
                                <?php } ?>
                            <?php } else { ?>
                                <tr>
                                    <td colspan="7" class="text-center text-muted py-4">
                                        Data periode akademik belum tersedia.
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