<?php
require_once "../../config/koneksi.php";
require_once "../../config/function.php";
require_once "../../includes/auth_dashboard.php";

cek_role_dashboard("Mahasiswa");

$page_title = "Mata Kuliah Saya";
$active_menu = "mata_kuliah_saya";

$data_mata_kuliah = [];

$id_pengguna = (int) $_SESSION['id_pengguna'];

$stmt = mysqli_prepare($koneksi, "CALL usp_select_mata_kuliah_mahasiswa(?)");
mysqli_stmt_bind_param($stmt, "i", $id_pengguna);
mysqli_stmt_execute($stmt);

$result = mysqli_stmt_get_result($stmt);

if ($result) {
    while ($row = mysqli_fetch_assoc($result)) {
        $data_mata_kuliah[] = $row;
    }
}

mysqli_stmt_close($stmt);
mysqli_next_result($koneksi);

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
        <div class="card border-0 shadow-sm rounded-4">
            <div class="card-body p-4">
                <div class="d-flex flex-column flex-md-row justify-content-between align-items-md-center mb-4 gap-3">
                    <div>
                        <h4 class="fw-bold mb-1">Daftar Pengajar Mata Kuliah</h4>
                        <p class="text-muted mb-0">Data pengajar mata kuliah kelas.</p>
                    </div>
                </div>

                <div class="table-responsive">
                    <table class="table table-hover align-middle">
                        <thead class="table-light">
                            <tr>
                                <th style="width: 60px;">No</th>
                                <th>Kelas</th>
                                <th>Mata Kuliah</th>
                                <th>Pengajar 1</th>
                                <th>Pengajar 2</th>
                            </tr>
                        </thead>
                        <tbody>
                            <?php if (count($data_mata_kuliah) > 0) { ?>
                                <?php $no = 1; ?>
                                <?php foreach ($data_mata_kuliah as $mata_kuliah) { ?>
                                    <tr>
                                        <td><?= $no++; ?></td>
                                        <td><?= aman($mata_kuliah['nama_kelas']); ?></td>
                                        <td><?= aman($mata_kuliah['nama_mata_kuliah']); ?></td>
                                        <td><?= aman($mata_kuliah['nama_pengajar_1']); ?></td>
                                        <td><?= aman($mata_kuliah['nama_pengajar_2']); ?></td>
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