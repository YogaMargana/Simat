<?php
require_once "../../config/koneksi.php";
require_once "../../config/function.php";
require_once "../../includes/auth_dashboard.php";

cek_role_dashboard("Kepala Prodi");

$page_title = "Histori Login";
$active_menu = "histori_login";
$data_histori = ambil_data_procedure($koneksi, "CALL usp_select_histori_login()");

function format_tanggal_histori_login($tanggal)
{
    if (empty($tanggal)) {
        return '-';
    }
    $timestamp = strtotime($tanggal);
    return $timestamp === false ? $tanggal : date('d/m/Y H:i:s', $timestamp);
}

require_once "../../includes/dashboard_header.php";
require_once "../../includes/sidebar.php";
?>

<main class="main-content">
    <div class="topbar">
        <h1 class="page-title">Histori Login</h1>
        <div class="user-info">
            <div class="user-detail">
                <div class="user-name"><?= aman($_SESSION['username']); ?></div>
                <div class="user-role"><?= aman($_SESSION['role']); ?></div>
            </div>
            <div class="user-avatar"><?= aman(strtoupper(substr($_SESSION['username'], 0, 1))); ?></div>
        </div>
    </div>

    <div class="content-wrapper">
        <div class="card border-0 shadow-sm rounded-4">
            <div class="card-body p-4">
                <div class="mb-4">
                    <h4 class="fw-bold mb-1">Daftar Histori Login Pengguna</h4>
                    <p class="text-muted mb-0">Menampilkan username, role, dan tanggal login seluruh pengguna.</p>
                </div>

                <div class="table-responsive">
                    <table id="myTable" class="table table-hover table-bordered table-striped align-middle">
                        <thead class="table-light">
                            <tr>
                                <th class="text-center" style="width:60px;">No</th>
                                <th>Username</th>
                                <th>Role</th>
                                <th class="text-center">Tanggal Login</th>
                            </tr>
                        </thead>
                        <tbody>
                            <?php if (count($data_histori) > 0) { ?>
                                <?php $no = 1; ?>
                                <?php foreach ($data_histori as $histori) { ?>
                                    <tr>
                                        <td class="text-center"><?= $no++; ?></td>
                                        <td><?= aman($histori['username']); ?></td>
                                        <td><?= aman($histori['role']); ?></td>
                                        <td class="text-center text-nowrap"><?= aman(format_tanggal_histori_login($histori['tanggal_login'])); ?></td>
                                    </tr>
                                <?php } ?>
                            <?php } else { ?>
                                <tr>
                                    <td colspan="4" class="text-center text-muted py-4">Belum ada histori login.</td>
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
