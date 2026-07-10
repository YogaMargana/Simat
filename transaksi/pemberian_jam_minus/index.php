<?php

require_once "../../config/koneksi.php";
require_once "../../config/function.php";
require_once "../../includes/auth_dashboard.php";

cek_role_dashboard("PIC Tata Tertib");

$page_title = "Pemberian Jam Minus";
$active_menu = "pemberian_jam_minus";

$data_pemberian = ambil_data_procedure(
    $koneksi,
    "CALL usp_select_pemberian_jam_minus()"
);

require_once "../../includes/dashboard_header.php";
require_once "../../includes/sidebar.php";

?>

<main class="main-content">

    <div class="topbar">

        <h1 class="page-title">
            Pemberian Jam Minus
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
                <?= strtoupper(
                    substr(
                        $_SESSION['username'],
                        0,
                        1
                    )
                ); ?>
            </div>

        </div>

    </div>

    <div class="content-wrapper">

        <?php if (
            isset($_GET['status']) &&
            $_GET['status'] === 'berhasil_tambah'
        ) { ?>

            <div class="alert alert-success">
                Pemberian jam minus berhasil disimpan.
            </div>

        <?php } ?>

        <?php if (isset($_GET['error'])) { ?>

            <div class="alert alert-danger">
                <?= aman($_GET['error']); ?>
            </div>

        <?php } ?>

        <div class="card border-0 shadow-sm rounded-4">

            <div class="card-body p-4">

                <div
                    class="
                        d-flex
                        justify-content-between
                        align-items-center
                        mb-4
                    "
                >

                    <div>
                        <h4 class="fw-bold mb-1">
                            Riwayat Pemberian Jam Minus
                        </h4>

                        <p class="text-muted mb-0">
                            Data jam minus yang diberikan
                            kepada mahasiswa.
                        </p>
                    </div>

                    <a
                        href="tambah.php"
                        class="btn btn-primary"
                    >
                        <i class="fa-solid fa-plus me-1"></i>

                        Berikan Jam Minus
                    </a>

                </div>

                <div class="table-responsive">

                    <table
                        id="myTable"
                        class="
                            table
                            table-hover
                            table-bordered
                            table-striped
                            align-middle
                        "
                    >

                        <thead class="table-light">

                            <tr>
                                <th>No</th>
                                <th>Mahasiswa</th>
                                <th>Kelas</th>
                                <th>Kategori</th>
                                <th>Detail</th>
                                <th>Jenis Jam</th>
                                <th>Jumlah</th>
                                <th>Pemberi</th>
                                <th>Tanggal</th>
                            </tr>

                        </thead>

                        <tbody>

                        <?php if (
                            count($data_pemberian) > 0
                        ) { ?>

                            <?php $no = 1; ?>

                            <?php foreach (
                                $data_pemberian as $row
                            ) { ?>

                                <tr>

                                    <td class="text-center">
                                        <?= $no++; ?>
                                    </td>

                                    <td>
                                        <div class="fw-semibold">
                                            <?= aman(
                                                $row[
                                                    'nama_mahasiswa'
                                                ]
                                            ); ?>
                                        </div>

                                        <small class="text-muted">
                                            <?= aman(
                                                $row['nim']
                                            ); ?>
                                        </small>
                                    </td>

                                    <td>
                                        <?= aman(
                                            $row['nama_kelas']
                                        ); ?>
                                    </td>

                                    <td>
                                        <?= aman(
                                            $row[
                                                'kategori_pelanggaran'
                                            ]
                                        ); ?>
                                    </td>

                                    <td>

                                    <?php if (
                                        $row[
                                            'kategori_pelanggaran'
                                        ] === 'Akademik'
                                    ) { ?>

                                        <div class="fw-semibold">
                                            <?= aman(
                                                $row[
                                                    'nama_mata_kuliah'
                                                ]
                                            ); ?>
                                        </div>

                                        <small class="text-muted">
                                            <?= aman(
                                                $row[
                                                    'kode_mata_kuliah'
                                                ]
                                            ); ?>

                                            ·

                                            <?= aman(
                                                $row[
                                                    'keterangan_absensi'
                                                ]
                                            ); ?>
                                        </small>

                                    <?php } elseif (
                                        $row[
                                            'kategori_pelanggaran'
                                        ] === 'Fasilitas'
                                    ) { ?>

                                        <div class="fw-semibold">
                                            <?= aman(
                                                $row[
                                                    'nama_fasilitas'
                                                ]
                                            ); ?>
                                        </div>

                                        <small class="text-muted">
                                            Harga saat pemberian:

                                            Rp<?= number_format(
                                                (float) $row[
                                                    'harga_fasilitas_saat_pemberian'
                                                ],
                                                0,
                                                ',',
                                                '.'
                                            ); ?>
                                        </small>

                                    <?php } else { ?>

                                        <?= nl2br(
                                            aman(
                                                $row[
                                                    'deskripsi_pelanggaran'
                                                ]
                                            )
                                        ); ?>

                                    <?php } ?>

                                    </td>

                                    <td>
                                        <?= aman(
                                            $row['jenis_jam']
                                        ); ?>
                                    </td>

                                    <td class="fw-bold text-danger">

                                        -<?= number_format(
                                            (float) $row[
                                                'jumlah_jam_minus'
                                            ],
                                            2,
                                            ',',
                                            '.'
                                        ); ?>

                                    </td>

                                    <td>
                                        <?= aman(
                                            $row['nama_pemberi']
                                        ); ?>
                                    </td>

                                    <td>
                                        <?= date(
                                            'd/m/Y H:i',
                                            strtotime(
                                                $row[
                                                    'tanggal_pemberian'
                                                ]
                                            )
                                        ); ?>
                                    </td>

                                </tr>

                            <?php } ?>

                        <?php } else { ?>

                            <tr>
                                <td
                                    colspan="9"
                                    class="
                                        text-center
                                        text-muted
                                        py-4
                                    "
                                >
                                    Belum ada pemberian jam minus.
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