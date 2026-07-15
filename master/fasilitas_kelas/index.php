<?php
require_once "../../config/koneksi.php";
require_once "../../config/function.php";
require_once "../../includes/auth_dashboard.php";

cek_role_dashboard("PIC Aset Fasilitas");

$page_title = "Fasilitas Kelas";
$active_menu = "fasilitas_kelas";
$data_fasilitas_kelas = ambil_data_procedure($koneksi, "CALL usp_select_fasilitas_kelas()");

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
            <div class="user-avatar"><?= strtoupper(substr($_SESSION['username'], 0, 1)); ?></div>
        </div>
    </div>

    <div class="content-wrapper">
        <?php if (isset($_GET['error'])) { ?>
            <div class="alert alert-danger"><?= aman($_GET['error']); ?></div>
        <?php } ?>

        <div class="card border-0 shadow-sm rounded-4">
            <div class="card-body p-4">
                <div class="mb-4">
                    <h4 class="fw-bold mb-1">Daftar Fasilitas pada Kelas</h4>
                    <p class="text-muted mb-0">Halaman ini hanya menampilkan data. Penentuan kelas dan pemulihan kondisi dilakukan melalui menu Data Fasilitas.</p>
                </div>

                <div class="table-responsive">
                    <table id="myTable" class="table table-hover table-bordered table-striped align-middle text-nowrap">
                        <thead class="table-light">
                            <tr>
                                <th style="width: 60px;" class="text-center">No</th>
                                <th class="text-center">Kelas</th>
                                <th class="text-center">Tingkat</th>
                                <th class="text-center">Fasilitas</th>
                                <th class="text-center">Kondisi</th>
                            </tr>
                        </thead>
                        <tbody>
                            <?php if (count($data_fasilitas_kelas) > 0) { ?>
                                <?php $no = 1; ?>
                                <?php foreach ($data_fasilitas_kelas as $row) { ?>
                                    <tr>
                                        <td class="text-center"><?= $no++; ?></td>
                                        <td><?= aman($row['nama_kelas']); ?></td>
                                        <td class="text-center"><?= aman($row['tingkat']); ?></td>
                                        <td><?= aman($row['nama_fasilitas']); ?></td>
                                        <td class="text-center">
                                            <?php if ($row['status_detail_fasilitas_pada_kelas'] === 'Aktif') { ?>
                                                <span class="badge bg-success">Aktif</span>
                                            <?php } else { ?>
                                                <span class="badge bg-danger">Rusak</span>
                                            <?php } ?>
                                        </td>
                                    </tr>
                                <?php } ?>
                            <?php } else { ?>
                                <tr><td colspan="5" class="text-center text-muted py-4">Data fasilitas kelas belum tersedia.</td></tr>
                            <?php } ?>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</main>

<?php require_once "../../includes/dashboard_footer.php"; ?>
