<?php
require_once "../../config/koneksi.php";
require_once "../../config/function.php";
require_once "../../includes/auth_dashboard.php";

$role = $_SESSION['role'] ?? '';

if (!in_array($role, ["Kepala Prodi", "PIC Aset Fasilitas"])) {
    header("Location: /SIMAT/index.php");
    exit;
}

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
                    <table class="table table-hover align-middle">
                        <thead class="table-light">
                            <tr>
                                <th style="width: 60px;">No</th>
                                <th>Nama Fasilitas</th>
                                <th>Kelas</th>
                                <th>Jumlah</th>
                                <th>Harga</th>
                                <th>Status Data</th>
                                <th style="width: 210px;" class="text-center">Aksi</th>
                            </tr>
                        </thead>
                        <tbody>
                            <?php if (count($data_fasilitas) > 0) { ?>
                                <?php $no = 1; ?>
                                <?php foreach ($data_fasilitas as $fasilitas) { ?>
                                    <tr>
                                        <td><?= $no++; ?></td>

                                        <td><?= aman($fasilitas['nama_fasilitas']); ?></td>

                                        <td>
                                            <?= aman($fasilitas['nama_kelas'] ?? '-'); ?>
                                        </td>

                                        <td><?= aman($fasilitas['jumlah_fasilitas'] ?? '0'); ?></td>

                                        <td>
                                            Rp <?= number_format($fasilitas['harga'] ?? 0, 0, ',', '.'); ?>
                                        </td>

                                        <td>
                                            <?php if ($fasilitas['status_detail_fasilitas_pada_kelas'] == "Aktif") { ?>
                                                <span class="badge bg-success">Aktif</span>
                                            <?php } else { ?>
                                                <span class="badge bg-secondary">Rusak</span>
                                            <?php } ?>
                                        </td>

                                        <td class="text-center">
                                            <?php if ($fasilitas['status_fasilitas'] == "Aktif") { ?>

                                                <a href="edit.php?id=<?= $fasilitas['id_fasilitas']; ?>" class="btn btn-warning btn-sm me-1">
                                                    <i class="fa-solid fa-pen-to-square"></i>
                                                </a>

                                                <?php if (($fasilitas['status_detail_fasilitas_pada_kelas'] ?? '') == "Rusak") { ?>
                                                    <a href="pulihkan_kondisi.php?id=<?= $fasilitas['id_detail_fasilitas_pada_kelas']; ?>"
                                                        class="btn btn-success btn-sm me-1 btn-konfirmasi"
                                                        data-title="Pulihkan Fasilitas?"
                                                        data-text="Yakin fasilitas ini sudah diperbaiki dan ingin diubah menjadi Aktif?"
                                                        data-icon="question"
                                                        data-confirm-text="Ya, pulihkan"
                                                        data-cancel-text="Batal">
                                                            <i class="fa-solid fa-check"></i>
                                                    </a>
                                                <?php } else { ?>
                                                    <button type="button" class="btn btn-secondary btn-sm me-1" disabled>
                                                        <i class="fa-solid fa-check"></i>
                                                    </button>
                                                <?php } ?>

                                                    <a href="hapus.php?id=<?= $fasilitas['id_fasilitas']; ?>"
                                                        class="btn btn-danger btn-sm btn-konfirmasi"
                                                        data-title="Hapus Fasilitas?"
                                                        data-text="Yakin ingin menonaktifkan fasilitas ini?"
                                                        data-icon="warning"
                                                        data-confirm-text="Ya, nonaktifkan"
                                                        data-cancel-text="Batal">
                                                            <i class="fa-solid fa-trash"></i>
                                                    </a>

                                            <?php } else { ?>

                                                <button type="button" class="btn btn-secondary btn-sm me-1" disabled>
                                                    <i class="fa-solid fa-pen-to-square"></i>
                                                </button>

                                                <button type="button" class="btn btn-secondary btn-sm me-1" disabled>
                                                    <i class="fa-solid fa-check"></i>
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
                                    <td colspan="7" class="text-center text-muted py-4">
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