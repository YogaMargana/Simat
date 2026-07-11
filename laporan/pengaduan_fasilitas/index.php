<?php

require_once "../../config/koneksi.php";
require_once "../../config/function.php";
require_once "../../includes/auth_dashboard.php";

cek_role_dashboard("PIC Aset Fasilitas");

$page_title = "Laporan Pengaduan";
$active_menu = "laporan_pengaduan_fasilitas";

$data_laporan = [];

$query = mysqli_query(
    $koneksi,
    "CALL usp_select_laporan_pengaduan_fasilitas()"
);

if ($query) {
    while ($row = mysqli_fetch_assoc($query)) {
        $data_laporan[] = $row;
    }

    mysqli_free_result($query);

    while (mysqli_more_results($koneksi)) {
        mysqli_next_result($koneksi);

        if ($extra_result = mysqli_store_result($koneksi)) {
            mysqli_free_result($extra_result);
        }
    }
} else {
    $error_laporan = mysqli_error($koneksi);
}

function format_tanggal_laporan_pengaduan($tanggal)
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
            Laporan Pengaduan
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
                            Data Laporan Pengaduan Fasilitas
                        </h4>

                        <p class="text-muted mb-0">
                            Laporan ini menampilkan data pengaduan fasilitas berdasarkan nama mahasiswa.
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
                                    <th>NIM</th>
                                    <th>Nama Mahasiswa</th>
                                    <th>Kelas</th>
                                    <th>Nama Fasilitas</th>
                                    <th>Deskripsi Kerusakan</th>
                                    <th class="text-center">Tanggal Pengaduan</th>
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
                                                <?= aman($row['nim']); ?>
                                            </td>

                                            <td>
                                                <?= aman($row['nama_mahasiswa']); ?>
                                            </td>

                                            <td>
                                                <?= aman($row['nama_kelas']); ?>
                                            </td>

                                            <td>
                                                <?= aman($row['nama_fasilitas']); ?>
                                            </td>

                                            <td>
                                                <?= aman($row['deskripsi_kerusakan']); ?>
                                            </td>

                                            <td class="text-center">
                                                <?= aman(format_tanggal_laporan_pengaduan($row['tanggal_pengaduan'])); ?>
                                            </td>

                                        </tr>

                                    <?php } ?>

                            </tbody>

                        </table>

                    <?php } else { ?>

                        <div class="text-center text-muted py-4 border rounded">
                            Belum ada data pengaduan fasilitas.
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