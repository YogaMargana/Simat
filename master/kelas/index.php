<?php
require_once "../../config/koneksi.php";
require_once "../../config/function.php";
require_once "../../includes/auth_dashboard.php";

cek_role_dashboard("Kepala Prodi");

$page_title = "Data Kelas";
$active_menu = "kelas";

$data_kelas = [];

$query = mysqli_query($koneksi, "CALL usp_select_kelas()");

if ($query) {
    while ($row = mysqli_fetch_assoc($query)) {
        $data_kelas[] = $row;
    }

    mysqli_free_result($query);
    mysqli_next_result($koneksi);
}

require_once "../../includes/dashboard_header.php";
require_once "../../includes/sidebar.php";
?>

<main class="main-content">
    <div class="topbar">
        <h1 class="page-title">Data Kelas</h1>

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
            <div class="alert alert-success">Data kelas berhasil ditambahkan.</div>
        <?php } ?>

        <?php if (isset($_GET['status']) && $_GET['status'] == "berhasil_edit") { ?>
            <div class="alert alert-success">Data kelas berhasil diubah.</div>
        <?php } ?>

        <?php if (isset($_GET['status']) && $_GET['status'] == "berhasil_hapus") { ?>
            <div class="alert alert-success">Data kelas berhasil dinonaktifkan.</div>
        <?php } ?>

        <?php if (isset($_GET['error'])) { ?>
            <div class="alert alert-danger"><?= aman($_GET['error']); ?></div>
        <?php } ?>

        <div class="card border-0 shadow-sm rounded-4">
            <div class="card-body p-4">
                <div class="d-flex flex-column flex-md-row justify-content-between align-items-md-center mb-4 gap-3">
                    <div>
                        <h4 class="fw-bold mb-1">Daftar Kelas</h4>
                        <p class="text-muted mb-0">Kelola data kelas mahasiswa TRPL.</p>
                    </div>

                    <a href="tambah.php" class="btn btn-primary">
                        <i class="fa-solid fa-plus me-1"></i>
                        Tambah Kelas
                    </a>
                </div>

                <div class="table-responsive">
                    <table id="myTable" class="table table-hover table-bordered table-striped align-middle text-nowrap" border="1">
                        <thead class="table-light">
                            <tr>
                                <th style="width: 60px;" class="text-center">No</th>
                                <th class="text-center">Nama Kelas</th>
                                <th class="text-center">Tingkat</th>
                                <th class="text-center">Jumlah Mahasiswa</th>
                                <th class="text-center">Status</th>
                                <th style="width: 170px;" class="text-center">Aksi</th>
                            </tr>
                        </thead>
                        <tbody>
                            <?php if (count($data_kelas) > 0) { ?>
                                <?php $no = 1; ?>
                                <?php foreach ($data_kelas as $kelas) { ?>
                                    <tr>
                                        <td class="text-center"><?= $no++; ?></td>
                                        <td><?= aman($kelas['nama_kelas']); ?></td>
                                        <td class="text-center"><?= aman($kelas['tingkat']); ?></td>
                                        <td class="text-center"><?= aman($kelas['jumlah_mahasiswa']); ?></td>
                                        <td class="text-center">
                                            <?php if ($kelas['status_kelas'] == "Aktif") { ?>
                                                <span class="badge bg-success">Aktif</span>
                                            <?php } else { ?>
                                                <span class="badge bg-secondary">Tidak Aktif</span>
                                            <?php } ?>
                                        </td>
                                        <td class="text-center">
                                            <?php if ($kelas['status_kelas'] == "Aktif") { ?>
                                                <a href="edit.php?id=<?= $kelas['id_kelas']; ?>" class="btn btn-warning btn-sm me-1">
                                                    <i class="fa-solid fa-pen-to-square"></i>
                                                </a>

                                                <a href="hapus.php?id=<?= $kelas['id_kelas']; ?>"
                                                class="btn btn-danger btn-sm btn-konfirmasi"
                                                data-title="Nonaktifkan Data?"
                                                data-text="Yakin ingin menonaktifkan data kelas ini?"
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
                                    <td colspan="6" class="text-center text-muted py-4">
                                        Data kelas belum tersedia.
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