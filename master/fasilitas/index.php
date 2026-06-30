<?php
require_once "../../config/koneksi.php";
require_once "../../config/function.php";
require_once "../../includes/auth_dashboard.php";

cek_role_dashboard("PIC Aset Fasilitas");

$page_title = "Data Fasilitas";
$active_menu = "fasilitas";

$data_fasilitas = [];

$query = mysqli_query($koneksi, "CALL usp_select_fasilitas()");

if ($query) {
    while ($row = mysqli_fetch_assoc($query)) {
        $data_fasilitas[] = $row;
    }

    mysqli_free_result($query);
    mysqli_next_result($koneksi);
}

require_once "../../includes/dashboard_header.php";
require_once "../../includes/sidebar.php";
?>

<main class="main-content">
    <div class="topbar">
        <h1 class="page-title">Data Fasilitas</h1>

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
        <div class="card border-0 shadow-sm rounded-4">
            <div class="card-body p-4">
                <div class="d-flex flex-column flex-md-row justify-content-between align-items-md-center mb-4 gap-3">
                    <div>
                        <h4 class="fw-bold mb-1">Daftar Fasilitas</h4>
                        <p class="text-muted mb-0">
                            Kelola data fasilitas dan lihat kondisi fasilitas pada kelas.
                        </p>
                    </div>

                    <a href="tambah.php" class="btn btn-primary">
                        <i class="fa-solid fa-plus me-1"></i>
                        Tambah Fasilitas
                    </a>
                </div>

                <div class="table-responsive">
                    <table id="myTable" class="table table-hover table-bordered table-striped align-middle text-nowrap" border="1">
                        <thead class="table-light">
                            <tr>
                                <th style="width: 60px;" class="text-center">No</th>
                                <th class="text-center">Nama Fasilitas</th>
                                <th class="text-center">Harga</th>
                                <th class="text-center">Tanggal Pendataan</th>
                                <th class="text-center">Status Data</th>
                                <th style="width: 120px;" class="text-center">Aksi</th>
                            </tr>
                        </thead>
                        <tbody>
                            <?php if (count($data_fasilitas) > 0) { ?>
                                <?php $no = 1; ?>
                                <?php foreach ($data_fasilitas as $fasilitas) { ?>
                                    <tr>
                                        <td class="text-center"><?= $no++; ?></td>

                                        <td><?= aman($fasilitas['nama_fasilitas']); ?></td>

                                        <td>
                                            Rp <?= number_format($fasilitas['harga'] ?? 0, 0, ',', '.'); ?>
                                        </td>

                                        <td>
                                            <?= date('d/m/Y H:i', strtotime($fasilitas['tanggal_pendataan'])); ?>
                                        </td>

                                        <td class="text-center">
                                            <?php if ($fasilitas['status_fasilitas'] == "Aktif") { ?>
                                                <span class="badge bg-success">Aktif</span>
                                            <?php } else { ?>
                                                <span class="badge bg-secondary">Tidak Aktif</span>
                                            <?php } ?>
                                        </td>

                                        <td class="text-center text-nowrap">
                                            <?php if ($fasilitas['status_fasilitas'] == "Aktif") { ?>
                                                <div class="d-inline-flex gap-1">
                                                    <a href="edit.php?id=<?= $fasilitas['id_fasilitas']; ?>" class="btn btn-warning btn-sm">
                                                        <i class="fa-solid fa-pen-to-square"></i>
                                                    </a>

                                                    <a href="hapus.php?id=<?= $fasilitas['id_fasilitas']; ?>"
                                                        class="btn btn-danger btn-sm btn-konfirmasi"
                                                        data-title="Hapus Fasilitas?"
                                                        data-text="Yakin ingin menonaktifkan fasilitas ini?"
                                                        data-icon="warning"
                                                        data-confirm-text="Ya, nonaktifkan"
                                                        data-cancel-text="Batal">
                                                        <i class="fa-solid fa-trash"></i>
                                                    </a>
                                                </div>
                                            <?php } else { ?>
                                                -
                                            <?php } ?>
                                        </td>
                                    </tr>
                                <?php } ?>
                            <?php } else { ?>
                                <tr>
                                    <td colspan="6" class="text-center text-muted py-4">
                                        Data fasilitas belum tersedia.
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