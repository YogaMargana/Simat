<?php
require_once "../../config/koneksi.php";
require_once "../../config/function.php";
require_once "../../includes/auth_dashboard.php";

cek_role_dashboard("PIC Aset Fasilitas");

$page_title = "Fasilitas Kelas";
$active_menu = "fasilitas_kelas";

$data_fasilitas_kelas = [];

$query = mysqli_query($koneksi, "CALL usp_select_fasilitas_kelas()");

if ($query) {
    while ($row = mysqli_fetch_assoc($query)) {
        $data_fasilitas_kelas[] = $row;
    }

    mysqli_free_result($query);
    mysqli_next_result($koneksi);
}

require_once "../../includes/dashboard_header.php";
require_once "../../includes/sidebar.php";
?>

<main class="main-content">
    <div class="topbar">
        <h1 class="page-title">Fasilitas Kelas</h1>

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
                <div class="d-flex flex-column flex-md-row justify-content-between align-items-md-center mb-4 gap-3">
                    <div>
                        <h4 class="fw-bold mb-1">Daftar Fasilitas Kelas</h4>
                        <p class="text-muted mb-0">
                            Tentukan fasilitas yang tersedia pada kelas aktif.
                        </p>
                    </div>

                    <a href="tambah.php" class="btn btn-primary">
                        <i class="fa-solid fa-plus me-1"></i>
                        Tambah Fasilitas Kelas
                    </a>
                </div>

                <div class="table-responsive">
                    <table id="myTable" class="table table-hover table-bordered table-striped align-middle text-nowrap">
                        <thead class="table-light">
                            <tr>
                                <th style="width: 60px;" class="text-center">No</th>
                                <th class="text-center">Kelas</th>
                                <th class="text-center">Fasilitas</th>
                                <th class="text-center">Jumlah</th>
                                <th class="text-center">Kondisi</th>
                                <th style="width: 170px;" class="text-center">Aksi</th>
                            </tr>
                        </thead>

                        <tbody>
                            <?php if (count($data_fasilitas_kelas) > 0) { ?>
                                <?php $no = 1; ?>
                                <?php foreach ($data_fasilitas_kelas as $row) { ?>
                                    <tr>
                                        <td class="text-center"><?= $no++; ?></td>

                                        <td>
                                            <?= aman($row['nama_kelas'] . " - Tingkat " . $row['tingkat']); ?>
                                        </td>

                                        <td><?= aman($row['nama_fasilitas']); ?></td>

                                        <td class="text-center"><?= aman($row['jumlah_fasilitas']); ?></td>

                                        <td class="text-center">
                                            <?php if ($row['status_detail_fasilitas_pada_kelas'] == "Aktif") { ?>
                                                <span class="badge bg-success">Aktif</span>
                                            <?php } else { ?>
                                                <span class="badge bg-secondary">Rusak</span>
                                            <?php } ?>
                                        </td>

                                        <td class="text-center text-nowrap">
                                            <div class="d-inline-flex gap-1">
                                                <a href="edit.php?id=<?= $row['id_detail_fasilitas_pada_kelas']; ?>" class="btn btn-warning btn-sm">
                                                    <i class="fa-solid fa-pen-to-square"></i>
                                                </a>

                                                <?php if ($row['status_detail_fasilitas_pada_kelas'] == "Rusak") { ?>
                                                    <a href="pulihkan_kondisi.php?id=<?= $row['id_detail_fasilitas_pada_kelas']; ?>"
                                                        class="btn btn-success btn-sm btn-konfirmasi"
                                                        data-title="Pulihkan Fasilitas?"
                                                        data-text="Yakin fasilitas ini sudah diperbaiki dan ingin diubah menjadi Aktif?"
                                                        data-icon="question"
                                                        data-confirm-text="Ya, pulihkan"
                                                        data-cancel-text="Batal">
                                                        <i class="fa-solid fa-check"></i>
                                                    </a>
                                                <?php } else { ?>
                                                    <button type="button" class="btn btn-secondary btn-sm" disabled>
                                                        <i class="fa-solid fa-check"></i>
                                                    </button>
                                                <?php } ?>

                                                <a href="hapus.php?id=<?= $row['id_detail_fasilitas_pada_kelas']; ?>"
                                                    class="btn btn-danger btn-sm btn-konfirmasi"
                                                    data-title="Hapus Data?"
                                                    data-text="Yakin ingin menghapus data fasilitas kelas ini?"
                                                    data-icon="warning"
                                                    data-confirm-text="Ya, hapus"
                                                    data-cancel-text="Batal">
                                                    <i class="fa-solid fa-trash"></i>
                                                </a>
                                            </div>
                                        </td>
                                    </tr>
                                <?php } ?>
                            <?php } else { ?>
                                <tr>
                                    <td colspan="6" class="text-center text-muted py-4">
                                        Data fasilitas kelas belum tersedia.
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