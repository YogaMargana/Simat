<?php
require_once "../../config/koneksi.php";
require_once "../../config/function.php";
require_once "../../includes/auth_dashboard.php";

cek_role_dashboard("PIC Kemahasiswaan");

$page_title = "Data Kegiatan";
$active_menu = "kegiatan";

$data_kegiatan = ambil_data_procedure($koneksi, "CALL usp_select_kegiatan()");

require_once "../../includes/dashboard_header.php";
require_once "../../includes/sidebar.php";
?>

<main class="main-content">
    <div class="topbar">
        <h1 class="page-title">Data Kegiatan</h1>

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
            <div class="alert alert-danger">
                <?= aman($_GET['error']); ?>
            </div>
        <?php } ?>

        <?php if (isset($_GET['status'])) { ?>
            <div class="alert alert-success">
                <?php
                if ($_GET['status'] == 'berhasil_tambah') {
                    echo "Data kegiatan berhasil ditambahkan.";
                } elseif ($_GET['status'] == 'berhasil_edit') {
                    echo "Data kegiatan berhasil diperbarui.";
                } elseif ($_GET['status'] == 'berhasil_hapus') {
                    echo "Data kegiatan berhasil dinonaktifkan.";
                }
                ?>
            </div>
        <?php } ?>

        <div class="card border-0 shadow-sm rounded-4">
            <div class="card-body p-4">
                <div class="d-flex flex-column flex-md-row justify-content-between align-items-md-center mb-4 gap-3">
                    <div>
                        <h4 class="fw-bold mb-1">Daftar Kegiatan</h4>
                        <p class="text-muted mb-0">
                            Kelola data kegiatan yang digunakan untuk pengajuan jam plus.
                        </p>
                    </div>

                    <a href="tambah.php" class="btn btn-primary">
                        <i class="fa-solid fa-plus me-1"></i>
                        Tambah Kegiatan
                    </a>
                </div>

                <div class="table-responsive">
                    <table id="myTable" class="table table-hover table-bordered table-striped align-middle">
                        <thead class="table-light">
                            <tr>
                                <th style="width: 60px;" class="text-center">No</th>
                                <th class="text-center">Nama Kegiatan</th>
                                <th class="text-center">Penyelenggara</th>
                                <th class="text-center">Tanggal Kegiatan</th>
                                <th class="text-center">Status</th>
                                <th style="width: 120px;" class="text-center">Aksi</th>
                            </tr>
                        </thead>

                        <tbody>
                            <?php if (count($data_kegiatan) > 0) { ?>
                                <?php $no = 1; ?>
                                <?php foreach ($data_kegiatan as $kegiatan) { ?>
                                    <tr>
                                        <td class="text-center"><?= $no++; ?></td>

                                        <td><?= aman($kegiatan['nama_kegiatan']); ?></td>

                                        <td class="text-center">
                                            <?= aman($kegiatan['penyelenggara']); ?>
                                        </td>

                                        <td class="text-center">
                                            <?= $kegiatan['tanggal_kegiatan'] ? date('d/m/Y', strtotime($kegiatan['tanggal_kegiatan'])) : '-'; ?>
                                        </td>

                                        <td class="text-center">
                                            <?php if ($kegiatan['status_kegiatan'] == "Aktif") { ?>
                                                <span class="badge bg-success">Aktif</span>
                                            <?php } else { ?>
                                                <span class="badge bg-secondary">Tidak Aktif</span>
                                            <?php } ?>
                                        </td>

                                        <td class="text-center text-nowrap">
                                            <?php if ($kegiatan['status_kegiatan'] == "Aktif") { ?>
                                                <div class="d-inline-flex gap-1 flex-nowrap">
                                                    <a href="edit.php?id=<?= $kegiatan['id_kegiatan']; ?>" class="btn btn-warning btn-sm">
                                                        <i class="fa-solid fa-pen-to-square"></i>
                                                    </a>

                                                    <a href="hapus.php?id=<?= $kegiatan['id_kegiatan']; ?>"
                                                        class="btn btn-danger btn-sm btn-konfirmasi"
                                                        data-title="Nonaktifkan Kegiatan?"
                                                        data-text="Yakin ingin menonaktifkan data kegiatan ini?"
                                                        data-icon="warning"
                                                        data-confirm-text="Ya, nonaktifkan"
                                                        data-cancel-text="Batal">
                                                        <i class="fa-solid fa-trash"></i>
                                                    </a>
                                                </div>
                                            <?php } else { ?>
                                                <div class="d-inline-flex gap-1 flex-nowrap">
                                                    <button type="button" class="btn btn-secondary btn-sm" disabled>
                                                        <i class="fa-solid fa-pen-to-square"></i>
                                                    </button>

                                                    <button type="button" class="btn btn-secondary btn-sm" disabled>
                                                        <i class="fa-solid fa-trash"></i>
                                                    </button>
                                                </div>
                                            <?php } ?>
                                        </td>
                                    </tr>
                                <?php } ?>
                            <?php } else { ?>
                                <tr>
                                    <td colspan="6" class="text-center text-muted py-4">
                                        Data kegiatan belum tersedia.
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