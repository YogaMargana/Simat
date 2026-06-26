<?php
require_once "../../config/koneksi.php";
require_once "../../config/function.php";
require_once "../../includes/auth_dashboard.php";

// /** @var mysqli $koneksi */

cek_role_dashboard("Kepala Prodi");

$page_title = "Data Pengajar";
$active_menu = "pengajar";

$data_pengajar = [];

$query = mysqli_query($koneksi, "CALL usp_select_pengajar()");

if ($query) {
    while ($row = mysqli_fetch_assoc($query)) {
        $data_pengajar[] = $row;
    }

    mysqli_free_result($query);
    mysqli_next_result($koneksi);
}

require_once "../../includes/dashboard_header.php";
require_once "../../includes/sidebar.php";
?>

<main class="main-content">
    <div class="topbar">
        <h1 class="page-title">Data Pengajar</h1>

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
            <div class="alert alert-success">Data pengajar berhasil ditambahkan.</div>
        <?php } ?>

        <?php if (isset($_GET['status']) && $_GET['status'] == "berhasil_edit") { ?>
            <div class="alert alert-success">Data pengajar berhasil diubah.</div>
        <?php } ?>

        <?php if (isset($_GET['status']) && $_GET['status'] == "berhasil_hapus") { ?>
            <div class="alert alert-success">Data pengajar berhasil dinonaktifkan.</div>
        <?php } ?>

        <?php if (isset($_GET['error'])) { ?>
            <div class="alert alert-danger"><?= aman($_GET['error']); ?></div>
        <?php } ?>

        <div class="card border-0 shadow-sm rounded-4">
            <div class="card-body p-4">
                <div class="d-flex flex-column flex-md-row justify-content-between align-items-md-center mb-4 gap-3">
                    <div>
                        <h4 class="fw-bold mb-1">Daftar Pengajar</h4>
                        <p class="text-muted mb-0">Kelola data pengajar, PIC, dan Kepala Prodi.</p>
                    </div>

                    <a href="tambah.php" class="btn btn-primary">
                        <i class="fa-solid fa-plus me-1"></i>
                        Tambah Pengajar
                    </a>
                </div>

                <div class="table-responsive">
                    <table id="myTable" class="table table-hover table-bordered table-striped align-middle" border="1">
                        <thead class="table-light">
                            <tr>
                                <th style="width: 60px;" class="text-center">No</th>
                                <th class="text-center">NIP</th>
                                <th class="text-center">Nama Pengajar</th>
                                <th class="text-center">Email</th>
                                <th class="text-center">No HP</th>
                                <th class="text-center">Status</th>
                                <th style="width: 170px;" class="text-center">Aksi</th>
                            </tr>
                        </thead>
                        <tbody>
                            <?php if (count($data_pengajar) > 0) { ?>
                                <?php $no = 1; ?>
                                <?php foreach ($data_pengajar as $pengajar) { ?>
                                    <tr>
                                        <td class="text-center"><?= $no++; ?></td>
                                        <td><?= aman($pengajar['nip']); ?></td>
                                        <td><?= aman($pengajar['nama_pengajar']); ?></td>
                                        <td><?= aman($pengajar['email'] ?? '-'); ?></td>
                                        <td><?= aman($pengajar['no_hp'] ?? '-'); ?></td>
                                        <td class="text-center">
                                            <?php if ($pengajar['status_pengajar'] == "Aktif") { ?>
                                                <span class="badge bg-success">Aktif</span>
                                            <?php } else { ?>
                                                <span class="badge bg-secondary">Tidak Aktif</span>
                                            <?php } ?>
                                        </td>
                                        <td class="text-center">
                                            <?php if ($pengajar['status_pengajar'] == "Aktif") { ?>
                                                <a href="edit.php?id=<?= $pengajar['id_pengajar']; ?>" class="btn btn-warning btn-sm">
                                                    <i class="fa-solid fa-pen-to-square"></i>
                                                </a>

                                                <a href="hapus.php?id=<?= $pengajar['id_pengajar']; ?>"
                                                    class="btn btn-danger btn-sm btn-konfirmasi"
                                                    data-title="Nonaktifkan Data?"
                                                    data-text="Yakin ingin menonaktifkan data pengajar ini?"
                                                    data-icon="warning"
                                                    data-confirm-text="Ya, nonaktifkan"
                                                    data-cancel-text="Batal">
                                                        <i class="fa-solid fa-trash"></i>
                                                </a>

                                            <?php } else { ?>
                                                -
                                            <?php } ?>
                                        </td>
                                    </tr>
                                <?php } ?>
                            <?php } else { ?>
                                <tr>
                                    <td colspan="7" class="text-center text-muted py-4">
                                        Data pengajar belum tersedia.
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