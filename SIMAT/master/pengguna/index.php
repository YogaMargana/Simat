<?php
require_once "../../config/koneksi.php";
require_once "../../config/function.php";
require_once "../../includes/auth_dashboard.php";

// /** @var mysqli $koneksi */

cek_role_dashboard("Kepala Prodi");

$page_title = "Data Pengguna";
$active_menu = "pengguna";

$data_pengguna = [];

$query = mysqli_query($koneksi, "CALL usp_select_pengguna()");

if ($query) {
    while ($row = mysqli_fetch_assoc($query)) {
        $data_pengguna[] = $row;
    }

    mysqli_free_result($query);
    mysqli_next_result($koneksi);
}

require_once "../../includes/dashboard_header.php";
require_once "../../includes/sidebar.php";
?>

<main class="main-content">
    <div class="topbar">
        <h1 class="page-title">Data Pengguna</h1>

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
            <div class="alert alert-success">Data pengguna berhasil ditambahkan.</div>
        <?php } ?>

        <?php if (isset($_GET['status']) && $_GET['status'] == "berhasil_edit") { ?>
            <div class="alert alert-success">Data pengguna berhasil diubah.</div>
        <?php } ?>

        <?php if (isset($_GET['status']) && $_GET['status'] == "berhasil_hapus") { ?>
            <div class="alert alert-success">Data pengguna berhasil dinonaktifkan.</div>
        <?php } ?>

        <?php if (isset($_GET['error'])) { ?>
            <div class="alert alert-danger"><?= aman($_GET['error']); ?></div>
        <?php } ?>

        <div class="card border-0 shadow-sm rounded-4">
            <div class="card-body p-4">
                <div class="d-flex flex-column flex-md-row justify-content-between align-items-md-center mb-4 gap-3">
                    <div>
                        <h4 class="fw-bold mb-1">Daftar Pengguna</h4>
                        <p class="text-muted mb-0">Kelola akun login pengguna SIMAT.</p>
                    </div>

                    <a href="tambah.php" class="btn btn-primary">
                        <i class="fa-solid fa-plus me-1"></i>
                        Tambah Pengguna
                    </a>
                </div>

                <div class="table-responsive">
                    <table id="myTable" class="table table-hover table-bordered table-striped align-middle" border="1">
                        <thead class="table-light">
                            <tr>
                                <th style="width: 60px;" class="text-center">No</th>
                                <th class="text-center">Username</th>
                                <th class="text-center">Role</th>
                                <th class="text-center">Terhubung Ke</th>
                                <th class="text-center">Status</th>
                                <th style="width: 170px;" class="text-center">Aksi</th>
                            </tr>
                        </thead>
                        <tbody>
                            <?php if (count($data_pengguna) > 0) { ?>
                                <?php $no = 1; ?>
                                <?php foreach ($data_pengguna as $pengguna) { ?>
                                    <tr>
                                        <td class="text-center"><?= $no++; ?></td>
                                        <td><?= aman($pengguna['username']); ?></td>
                                        <td><?= aman($pengguna['role']); ?></td>
                                        <td>
                                            <?php if ($pengguna['role'] == "Mahasiswa") { ?>
                                                <?= aman(($pengguna['nim'] ?? '-') . " - " . ($pengguna['nama_mahasiswa'] ?? '-')); ?>
                                            <?php } else { ?>
                                                <?= aman(($pengguna['nip'] ?? '-') . " - " . ($pengguna['nama_pengajar'] ?? '-')); ?>
                                            <?php } ?>
                                        </td>
                                        <td class="text-center">
                                            <?php if ($pengguna['status_akun'] == "Aktif") { ?>
                                                <span class="badge bg-success">Aktif</span>
                                            <?php } else { ?>
                                                <span class="badge bg-secondary">Tidak Aktif</span>
                                            <?php } ?>
                                        </td>
                                        <td class="text-center">
                                            <?php if ($pengguna['status_akun'] == "Aktif") { ?>
                                                <a href="edit.php?id=<?= $pengguna['id_pengguna']; ?>" class="btn btn-warning btn-sm me-1">
                                                    <i class="fa-solid fa-pen-to-square"></i>
                                                </a>

                                                <a href="hapus.php?id=<?= $pengguna['id_pengguna']; ?>"
                                                    class="btn btn-danger btn-sm btn-konfirmasi"
                                                    data-title="Nonaktifkan Pengguna?"
                                                    data-text="Yakin ingin menonaktifkan data pengguna ini?"
                                                    data-icon="warning"
                                                    data-confirm-text="Ya, nonaktifkan"
                                                    data-cancel-text="Batal">
                                                        <i class="fa-solid fa-trash"></i>
                                                </a>

                                            <?php } else { ?>
                                                <!-- <button type="button" class="btn btn-secondary btn-sm me-1" disabled>
                                                    <i class="fa-solid fa-pen-to-square"></i>
                                                </button>

                                                <button type="button" class="btn btn-secondary btn-sm" disabled>
                                                    <i class="fa-solid fa-trash"></i>
                                                </button> -->
                                                -
                                            <?php } ?>
                                        </td>
                                    </tr>
                                <?php } ?>
                            <?php } else { ?>
                                <tr>
                                    <td colspan="6" class="text-center text-muted py-4">
                                        Data pengguna belum tersedia.
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