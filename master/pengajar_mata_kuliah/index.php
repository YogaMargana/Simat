<?php
require_once "../../config/koneksi.php";
require_once "../../config/function.php";
require_once "../../includes/auth_dashboard.php";

cek_role_dashboard("Kepala Prodi");

$page_title = "Pengajar Mata Kuliah";
$active_menu = "pengajar_mata_kuliah";

$data_pengajar_mk = [];

$query = mysqli_query($koneksi, "CALL usp_select_pengajar_mata_kuliah_kelas()");

if ($query) {
    while ($row = mysqli_fetch_assoc($query)) {
        $data_pengajar_mk[] = $row;
    }

    mysqli_free_result($query);
    mysqli_next_result($koneksi);
}

require_once "../../includes/dashboard_header.php";
require_once "../../includes/sidebar.php";
?>

<main class="main-content">
    <div class="topbar">
        <h1 class="page-title">Data Pengajar Mata Kuliah</h1>

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
            <div class="alert alert-success">Data pengajar mata kuliah berhasil ditambahkan.</div>
        <?php } ?>

        <?php if (isset($_GET['status']) && $_GET['status'] == "berhasil_edit") { ?>
            <div class="alert alert-success">Data pengajar mata kuliah berhasil diubah.</div>
        <?php } ?>

        <?php if (isset($_GET['status']) && $_GET['status'] == "berhasil_hapus") { ?>
            <div class="alert alert-success">Data pengajar mata kuliah berhasil dihapus.</div>
        <?php } ?>

        <?php if (isset($_GET['error'])) { ?>
            <div class="alert alert-danger"><?= aman($_GET['error']); ?></div>
        <?php } ?>

        <div class="card border-0 shadow-sm rounded-4">
            <div class="card-body p-4">
                <div class="d-flex flex-column flex-md-row justify-content-between align-items-md-center mb-4 gap-3">
                    <div>
                        <h4 class="fw-bold mb-1">Daftar Pengajar Mata Kuliah</h4>
                        <p class="text-muted mb-0">Kelola data pengajar mata kuliah TRPL.</p>
                    </div>

                    <a href="tambah.php" class="btn btn-primary">
                        <i class="fa-solid fa-plus me-1"></i>
                        Tambah Penentuan
                    </a>
                </div>

                <div class="table-responsive">
                    <table id="myTable" class="table table-hover table-bordered table-striped align-middle text-nowrap" border="1">
                        <thead class="table-light">
                            <tr>
                                <th style="width: 60px;" class="text-center">No</th>
                                <th class="text-center">Kelas</th>
                                <th class="text-center">Mata Kuliah</th>
                                <th class="text-center">Pengajar 1</th>
                                <th class="text-center">Pengajar 2</th>
                                <th style="width: 170px;" class="text-center">Aksi</th>
                            </tr>
                        </thead>
                        <tbody>
                            <?php if (count($data_pengajar_mk) > 0) { ?>
                                <?php $no = 1; ?>
                                <?php foreach ($data_pengajar_mk as $pengajar_mk) { ?>
                                    <tr>
                                        <td class="text-center"><?= $no++; ?></td>
                                        <td><?= aman($pengajar_mk['nama_kelas']); ?></td>
                                        <td><?= aman($pengajar_mk['nama_mata_kuliah']); ?></td>
                                        <td><?= aman($pengajar_mk['nama_pengajar_1']); ?></td>
                                        <td><?= aman($pengajar_mk['nama_pengajar_2']); ?></td>
                                        <td class="text-center">
                                            <a href="edit.php?id=<?= $pengajar_mk['id_detail_kelas_pada_mata_kuliah']; ?>" class="btn btn-warning btn-sm">
                                                <i class="fa-solid fa-pen-to-square"></i>
                                            </a>

                                            <a href="hapus.php?id=<?= $pengajar_mk['id_detail_kelas_pada_mata_kuliah']; ?>"
                                                class="btn btn-danger btn-sm btn-konfirmasi"
                                                data-title="Hapus Data?"
                                                data-text="Yakin ingin menghapus penentuan pengajar ini?"
                                                data-icon="warning"
                                                data-confirm-text="Ya, hapus"
                                                data-cancel-text="Batal">
                                                <i class="fa-solid fa-trash"></i>
                                            </a>
                                        </td>
                                    </tr>
                                <?php } ?>
                            <?php } else { ?>
                                <tr>
                                    <td colspan="9" class="text-center text-muted py-4">
                                        Data pengajar pada mata kuliah pada kelas belum tersedia.
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