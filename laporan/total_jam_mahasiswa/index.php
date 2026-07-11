<?php

require_once "../../config/koneksi.php";
require_once "../../config/function.php";
require_once "../../includes/auth_dashboard.php";

cek_role_dashboard("PIC Tata Tertib");

$page_title = "Laporan Total Jam Mahasiswa";
$active_menu = "laporan_total_jam_mahasiswa";

$data_laporan = [];

$sql = "
    SELECT
        nim,
        nama_mahasiswa,
        nama_kelas,
        total_jam_kompensasi,
        total_jam_murni,
        total_jam_mahasiswa
    FROM vw_laporan_total_jam_mahasiswa
    -- ORDER BY nama_kelas ASC, nim ASC, nama_mahasiswa ASC
    ORDER BY total_jam_mahasiswa DESC
";

$query = mysqli_query($koneksi, $sql);

if ($query) {
    while ($row = mysqli_fetch_assoc($query)) {
        $data_laporan[] = $row;
    }

    mysqli_free_result($query);
} else {
    $error_laporan = mysqli_error($koneksi);
}

function class_total_jam($nilai)
{
    $nilai = (float) $nilai;

    if ($nilai < 0) {
        return "text-danger";
    }

    if ($nilai > 0) {
        return "text-success";
    }

    return "text-muted";
}

require_once "../../includes/dashboard_header.php";
require_once "../../includes/sidebar.php";

?>

<main class="main-content">

    <div class="topbar">

        <h1 class="page-title">
            Laporan Total Jam Mahasiswa
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

                <div class="d-flex justify-content-between align-items-center mb-4">

                    <div>
                        <h4 class="fw-bold mb-1">
                            Data Total Jam Mahasiswa
                        </h4>

                        <p class="text-muted mb-0">
                            Laporan total jam mahasiswa berdasarkan aturan pembayaran jam murni dan kompensasi.
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

                <div class="alert alert-info">
                    <strong>Aturan Perhitungan:</strong>
                    Jam plus murni tidak bisa membayar jam minus kompensasi.
                    Jam plus kompensasi digunakan untuk membayar jam minus kompensasi terlebih dahulu.
                    Jika masih ada sisa jam plus kompensasi, sisanya dapat digunakan untuk membayar jam minus murni.
                </div>

                <div class="table-responsive">

                    <table
                        id="myTable"
                        class="table table-hover table-bordered table-striped align-middle text-nowrap"
                    >

                        <thead class="table-light">

                            <tr>
                                <th class="text-center" style="width: 60px;">No</th>
                                <th>NIM</th>
                                <th>Nama Mahasiswa</th>
                                <th>Kelas</th>
                                <th class="text-end">Total Jam Kompensasi</th>
                                <th class="text-end">Total Jam Murni</th>
                                <th class="text-end">Total Jam</th>
                            </tr>

                        </thead>

                        <tbody>

                            <?php if (count($data_laporan) > 0) { ?>

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

                                        <td class="text-end fw-bold <?= class_total_jam($row['total_jam_kompensasi']); ?>">
                                            <?= format_jam($row['total_jam_kompensasi']); ?>
                                        </td>

                                        <td class="text-end fw-bold <?= class_total_jam($row['total_jam_murni']); ?>">
                                            <?= format_jam($row['total_jam_murni']); ?>
                                        </td>

                                        <td class="text-end fw-bold <?= class_total_jam($row['total_jam_mahasiswa']); ?>">
                                            <?= format_jam($row['total_jam_mahasiswa']); ?>
                                        </td>

                                    </tr>

                                <?php } ?>

                            <?php } else { ?>

                                <tr>
                                    <td colspan="7" class="text-center text-muted py-4">
                                        Belum ada data mahasiswa aktif.
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

<?php

require_once "../../includes/dashboard_footer.php";

?>