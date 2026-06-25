<?php
require_once "../../config/koneksi.php";
require_once "../../config/function.php";
require_once "../../includes/auth_dashboard.php";

cek_role_dashboard("Kepala Prodi");

$page_title = "Data Mahasiswa";
$active_menu = "mahasiswa";

// /** @var mysqli $koneksi */

$data_mahasiswa = [];

$query = mysqli_query($koneksi, "CALL usp_select_mahasiswa()");

if ($query) {
    while ($row = mysqli_fetch_assoc($query)) {
        $data_mahasiswa[] = $row;
    }

    mysqli_free_result($query);
    mysqli_next_result($koneksi);
}

require_once "../../includes/dashboard_header.php";
require_once "../../includes/sidebar.php";
?>

<main class="main-content">
    <div class="topbar">
        <h1 class="page-title">Data Mahasiswa</h1>

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
            <div class="alert alert-success">Data mahasiswa berhasil ditambahkan.</div>
        <?php } ?>

        <?php if (isset($_GET['status']) && $_GET['status'] == "berhasil_edit") { ?>
            <div class="alert alert-success">Data mahasiswa berhasil diubah.</div>
        <?php } ?>

        <?php if (isset($_GET['status']) && $_GET['status'] == "berhasil_hapus") { ?>
            <div class="alert alert-success">Data mahasiswa berhasil dinonaktifkan.</div>
        <?php } ?>

        <?php if (isset($_GET['error'])) { ?>
            <div class="alert alert-danger"><?= aman($_GET['error']); ?></div>
        <?php } ?>

        <div class="card border-0 shadow-sm rounded-4">
            <div class="card-body p-4">
                <div class="d-flex flex-column flex-md-row justify-content-between align-items-md-center mb-4 gap-3">
                    <div>
                        <h4 class="fw-bold mb-1">Daftar Mahasiswa</h4>
                        <p class="text-muted mb-0">Kelola data mahasiswa TRPL.</p>
                    </div>

                    <a href="tambah.php" class="btn btn-primary">
                        <i class="fa-solid fa-plus me-1"></i>
                        Tambah Mahasiswa
                    </a>
                </div>

                <div class="table-responsive">
                    <table class="table table-hover align-middle">
                        <thead class="table-light">
                            <tr>
                                <th style="width: 60px;">No</th>
                                <th>NIM</th>
                                <th>Nama Mahasiswa</th>
                                <th>Kelas</th>
                                <th>Periode</th>
                                <th>Email</th>
                                <th>No HP</th>
                                <th>Status</th>
                                <th style="width: 170px;" class="text-center">Aksi</th>
                            </tr>
                        </thead>
                        <tbody>
                            <?php if (count($data_mahasiswa) > 0) { ?>
                                <?php $no = 1; ?>
                                <?php foreach ($data_mahasiswa as $mahasiswa) { ?>
                                    <tr>
                                        <td><?= $no++; ?></td>
                                        <td><?= aman($mahasiswa['nim']); ?></td>
                                        <td><?= aman($mahasiswa['nama_mahasiswa']); ?></td>
                                        <td><?= aman($mahasiswa['nama_kelas']); ?></td>
                                        <td><?= aman($mahasiswa['tahun_akademik'] . " - " . $mahasiswa['semester']); ?></td>
                                        <td><?= aman($mahasiswa['email'] ?? '-'); ?></td>
                                        <td><?= aman($mahasiswa['no_hp'] ?? '-'); ?></td>
                                        <td>
                                            <?php if ($mahasiswa['status_mahasiswa'] == "Aktif") { ?>
                                                <span class="badge bg-success">Aktif</span>
                                            <?php } elseif ($mahasiswa['status_mahasiswa'] == "Tidak Aktif") { ?>
                                                <span class="badge bg-secondary">Tidak Aktif</span>
                                            <?php } elseif ($mahasiswa['status_mahasiswa'] == "Lulus") { ?>
                                                <span class="badge bg-primary">Lulus</span>
                                            <?php } else { ?>
                                                <span class="badge bg-warning text-dark">Cuti</span>
                                            <?php } ?>
                                        </td>
                                        <td class="text-center">
                                            <?php if ($mahasiswa['status_mahasiswa'] == "Aktif") { ?>
                                                <a href="edit.php?id=<?= $mahasiswa['id_mahasiswa']; ?>" class="btn btn-warning btn-sm me-1">
                                                    <i class="fa-solid fa-pen-to-square"></i>
                                                </a>

                                                <a href="hapus.php?id=<?= $mahasiswa['id_mahasiswa']; ?>"
                                                    class="btn btn-danger btn-sm btn-konfirmasi"
                                                    data-title="Nonaktifkan Data?"
                                                    data-text="Yakin ingin menonaktifkan data mahasiswa ini?"
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
                                    <td colspan="9" class="text-center text-muted py-4">
                                        Data mahasiswa belum tersedia.
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