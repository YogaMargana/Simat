<?php
require_once "../../config/koneksi.php";
require_once "../../config/function.php";
require_once "../../includes/auth_dashboard.php";

cek_role_dashboard("Kepala Prodi");

$page_title = "Data Mata Kuliah";
$active_menu = "mata_kuliah";

$data_mata_kuliah = [];

// $query = mysqli_query($koneksi, "CALL usp_select_mata_kuliah()");
$query = mysqli_query($koneksi, "
    SELECT
        id_matakuliah,
        nama_mata_kuliah,
        kode_mata_kuliah,
        sks,
        semester,
        status_mata_kuliah
    FROM mata_kuliah
");

if ($query) {
    while ($row = mysqli_fetch_assoc($query)) {
        $data_mata_kuliah[] = $row;
    }

    mysqli_free_result($query);
    mysqli_next_result($koneksi);
}

require_once "../../includes/dashboard_header.php";
require_once "../../includes/sidebar.php";

?>


<main class="main-content">
    <div class="topbar">
        <h1 class="page-title">Mata Kuliah</h1>

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
            <div class="alert alert-success">Data mata kuliah berhasil ditambahkan.</div>
        <?php } ?>

        <?php if (isset($_GET['status']) && $_GET['status'] == "berhasil_edit") { ?>
            <div class="alert alert-success">Data mata kuliah berhasil diubah.</div>
        <?php } ?>

        <?php if (isset($_GET['status']) && $_GET['status'] == "berhasil_hapus") { ?>
            <div class="alert alert-success">Data mata kuliah berhasil dinonaktifkan.</div>
        <?php } ?>

        <?php if (isset($_GET['error'])) { ?>
            <div class="alert alert-danger"><?= aman($_GET['error']); ?></div>
        <?php } ?>

        <div class="card border-0 shadow-sm rounded-4">
            <div class="card-body p-4">
                <div class="d-flex flex-column flex-md-row justify-content-between align-items-md-center mb-4 gap-3">
                    <div>
                        <h4 class="fw-bold mb-1">Daftar Mata Kuliah</h4>
                        <p class="text-muted mb-0">Kelola data mata kuliah.</p>
                    </div>

                    <a href="tambah.php" class="btn btn-primary">
                        <i class="fa-solid fa-plus me-1"></i>
                        Tambah Mata Kuliah
                    </a>
                </div>

                <div class="table-responsive">
                    <table class="table table-hover align-middle">
                        <thead class="table-light">
                            <tr>
                                <th style="width: 60px;">No</th>
                                <th>Nama Mata Kuliah</th>
                                <th>Kode Mata Kuliah</th>
                                <th>SKS</th>
                                <th>Semester</th>
                                <th>Status</th>
                                <th style="width: 170px;" class="text-center">Aksi</th>
                            </tr>
                        </thead>
                        <tbody>
                            <?php if (count($data_mata_kuliah) > 0) { ?>
                                <?php $no = 1; ?>
                                <?php foreach ($data_mata_kuliah as $mata_kuliah) { ?>
                                    <tr>
                                        <td><?= $no++; ?></td>
                                        <td><?= aman($mata_kuliah['nama_mata_kuliah']); ?></td>
                                        <td><?= aman($mata_kuliah['kode_mata_kuliah']); ?></td>
                                        <td><?= aman($mata_kuliah['sks']); ?></td>
                                        <td><?= aman($mata_kuliah['semester']); ?></td>
                                        <td>
                                            <?php if ($mata_kuliah['status_mata_kuliah'] == "Aktif") { ?>
                                                <span class="badge bg-success">Aktif</span>
                                            <?php } else { ?>
                                                <span class="badge bg-secondary">Tidak Aktif</span>
                                            <?php } ?>
                                        </td>
                                        <td class="text-center">
                                            <?php if ($mata_kuliah['status_mata_kuliah'] == "Aktif") { ?>
                                                <a href="edit.php?id=<?= $mata_kuliah['id_matakuliah']; ?>" class="btn btn-warning btn-sm me-1">
                                                    <i class="fa-solid fa-pen-to-square"></i>
                                                </a>

                                                <a href="hapus.php?id=<?= $mata_kuliah['id_matakuliah']; ?>"
                                                class="btn btn-danger btn-sm btn-konfirmasi"
                                                data-title="Nonaktifkan Data?"
                                                data-text="Yakin ingin menonaktifkan data mata kuliah ini?"
                                                data-icon="warning"
                                                data-confirm-text="Ya, nonaktifkan"
                                                data-cancel-text="Batal">
                                                    <i class="fa-solid fa-trash"></i>
                                                </a>
                                                
                                            <?php } else { ?>
                                                <button type="button" class="btn btn-secondary btn-sm me-1" disabled>
                                                    <i class="fa-solid fa-pen-to-square"></i>
                                                </button>

                                                <button type="button" class="btn btn-secondary btn-sm" disabled>
                                                    <i class="fa-solid fa-trash"></i>
                                                </button>
                                            <?php } ?>
                                        </td>
                                    </tr>
                                <?php } ?>
                            <?php } else { ?>
                                <tr>
                                    <td colspan="6" class="text-center text-muted py-4">
                                        Data mata kuliah belum tersedia.
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
