<?php

require_once "../../config/koneksi.php";
require_once "../../config/function.php";
require_once "../../includes/auth_dashboard.php";

cek_role_bukan_mahasiswa();

$page_title = "Laporan Bursa Jobdesc";
$active_menu = "laporan_bursa_jobdesc";

$role = $_SESSION['role'] ?? '';
$data_laporan = [];

$stmt = mysqli_prepare(
    $koneksi,
    "CALL usp_select_laporan_bursa_jobdesc_by_role(?)"
);

if (!$stmt) {
    $error_laporan = mysqli_error($koneksi);
} else {
    mysqli_stmt_bind_param($stmt, "s", $role);

    if (mysqli_stmt_execute($stmt)) {
        $result = mysqli_stmt_get_result($stmt);

        if ($result) {
            while ($row = mysqli_fetch_assoc($result)) {
                $data_laporan[] = $row;
            }

            mysqli_free_result($result);
        }
    } else {
        $error_laporan = mysqli_error($koneksi);
    }

    mysqli_stmt_close($stmt);

    while (mysqli_more_results($koneksi)) {
        mysqli_next_result($koneksi);

        if ($extra_result = mysqli_store_result($koneksi)) {
            mysqli_free_result($extra_result);
        }
    }
}

function format_tanggal_laporan_bursa($tanggal)
{
    if (empty($tanggal)) {
        return "-";
    }

    $timestamp = strtotime($tanggal);

    if ($timestamp === false) {
        return $tanggal;
    }

    return date("d/m/Y H:i", $timestamp);
}

require_once "../../includes/dashboard_header.php";
require_once "../../includes/sidebar.php";

?>

<main class="main-content">

    <div class="topbar">

        <h1 class="page-title">
            Laporan Bursa Jobdesc
        </h1>

        <div class="user-info">

            <div class="user-detail">

                <div class="user-name">
                    <?= aman($_SESSION['username']); ?>
                </div>

                <div class="user-role">
                    <?= aman($_SESSION['role']); ?>
                </div>

            </div>

            <div class="user-avatar">
                <?= strtoupper(substr($_SESSION['username'], 0, 1)); ?>
            </div>

        </div>

    </div>

    <div class="content-wrapper">

        <?php if (isset($error_laporan)) { ?>

            <div class="alert alert-danger">
                Gagal mengambil data laporan:
                <?= aman($error_laporan); ?>
            </div>

        <?php } ?>

        <div class="card border-0 shadow-sm rounded-4">

            <div class="card-body p-4">

                <div class="d-flex flex-column flex-md-row justify-content-between align-items-md-center mb-4 gap-3">

                    <div>

                        <h4 class="fw-bold mb-1">
                            Data Bursa Jobdesc <?= aman($role); ?>
                        </h4>

                        <p class="text-muted mb-0">
                            Laporan bursa jobdesc yang dibuat oleh
                            <strong><?= aman($role); ?></strong>.
                        </p>

                    </div>

                    <a
                        href="cetak.php"
                        target="_blank"
                        class="btn btn-danger"
                    >
                        <i class="fa-solid fa-file-pdf me-1"></i>
                        Cetak PDF
                    </a>

                </div>

                <div class="table-responsive">

                    <?php if (count($data_laporan) > 0) { ?>

                        <table
                            id="myTable"
                            class="table table-hover table-bordered table-striped align-middle"
                        >

                            <thead class="table-light">

                                <tr>
                                    <th class="text-center" style="width: 60px;">No</th>
                                    <th>Deskripsi</th>
                                    <th>Penerima Jobdesc</th>
                                    <th>Penerima</th>
                                    <th class="text-end">Jam Plus</th>
                                    <th class="text-center">Tanggal</th>
                                    <th class="text-center">Kuota</th>
                                </tr>

                            </thead>

                            <tbody>

                                <?php $no = 1; ?>

                                <?php foreach ($data_laporan as $row) { ?>

                                    <tr>

                                        <td class="text-center">
                                            <?= $no++; ?>
                                        </td>

                                        <td>
                                            <?= aman($row['deskripsi_jobdesc']); ?>
                                        </td>

                                        <td>
                                            <?= aman($row['penerima_jobdesc']); ?>
                                        </td>

                                        <td>
                                            <?= aman($row['target_penerima_jobdesc']); ?>
                                        </td>

                                        <td class="text-end fw-bold">
                                            <?= format_jam($row['jam_plus']); ?>
                                        </td>

                                        <td class="text-center">
                                            <?= aman(format_tanggal_laporan_bursa($row['tanggal_pemberian_jobdesc'])); ?>
                                        </td>

                                        <td class="text-center">
                                            <?= aman($row['kuota']); ?>
                                        </td>

                                    </tr>

                                <?php } ?>

                            </tbody>

                        </table>

                    <?php } else { ?>

                        <div class="text-center text-muted py-4 border rounded">
                            Belum ada data bursa jobdesc yang dibuat oleh role ini.
                        </div>

                    <?php } ?>

                </div>

            </div>

        </div>

    </div>

</main>

<?php

require_once "../../includes/dashboard_footer.php";

?>