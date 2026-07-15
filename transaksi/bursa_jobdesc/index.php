<?php
require_once "../../config/koneksi.php";
require_once "../../config/function.php";
require_once "../../includes/auth_dashboard.php";

$role = $_SESSION['role'] ?? '';

if ($role == '') {
    header("Location: /SIMAT/index.php");
    exit;
}

$bisa_membuat_jobdesc = boleh_membuat_jobdesc($role);

$page_title = "Bursa Jobdesc";
$active_menu = "bursa_jobdesc";

$data_bursa_jobdesc = ambil_data_procedure(
    $koneksi,
    "CALL usp_select_bursa_jobdesc()"
);

$total_jam_minus_saya = 0;

if ($role === "Mahasiswa") {
    $id_mahasiswa_login = (int) ($_SESSION['id_mahasiswa'] ?? 0);

    if ($id_mahasiswa_login > 0) {
        $row_total = ambil_satu_procedure_prepared(
            $koneksi,
            "CALL usp_get_total_jam_minus_mahasiswa(?)",
            "i",
            [$id_mahasiswa_login]
        );
        $total_jam_minus_saya = (float) ($row_total['total_jam_minus'] ?? 0);
    }

    foreach ($data_bursa_jobdesc as $index => $jobdesc) {
        $cek = ambil_satu_procedure_prepared(
            $koneksi,
            "CALL usp_get_peran_bursa_jobdesc(?, ?)",
            "ii",
            [(int) $jobdesc['id_bursa_jobdesc'], (int) ($_SESSION['id_pengguna'] ?? 0)]
        );
        $data_bursa_jobdesc[$index]['peran_saya'] = $cek['peran_pengguna'] ?? '';
        $data_bursa_jobdesc[$index]['sudah_daftar'] = !empty($cek);
    }
}

require_once "../../includes/dashboard_header.php";
require_once "../../includes/sidebar.php";
?>

<main class="main-content">
    <div class="topbar">
        <h1 class="page-title">Bursa Jobdesc</h1>

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
                        <h4 class="fw-bold mb-1">Daftar Bursa Jobdesc</h4>
                        <p class="text-muted mb-0">
                            Mahasiswa dapat mendaftar jobdesc selama kuota masih tersedia.
                        </p>
                    </div>

                    <?php if ($bisa_membuat_jobdesc) { ?>
                        <a href="tambah.php" class="btn btn-primary">
                            <i class="fa-solid fa-plus me-1"></i>
                            Tambah Jobdesc
                        </a>
                    <?php } ?>
                </div>

                <div class="table-responsive">
                    <table id="myTable" class="table table-hover table-bordered table-striped align-middle text-nowrap" border="1">
                     <thead class="table-light">
                        <tr>
                            <th style="width: 60px;" class="text-center">No</th>
                            <th class="text-center">Deskripsi</th>
                            <th class="text-center">Penerima Jobdesc</th>

                            <?php if ($role !== "Mahasiswa") { ?>
                                <th class="text-center">Pemberi</th>
                            <?php } ?>

                            <th class="text-center">Jam Plus</th>

                            <th class="text-center">Tanggal</th>

                            <?php if ($role !== "Mahasiswa") { ?>
                                <th class="text-center">Terisi/Kuota</th>
                            <?php } ?>

                            <th class="text-center">Status</th>

                            <?php if ($role !== "Mahasiswa") { ?>
                                <th class="text-center">Penerima</th>
                                <th class="text-center">Bukti Selesai</th>
                            <?php } ?>

                            <th style="width: 170px;" class="text-center">Aksi</th>
                        </tr>
                    </thead>
                        <tbody>
                            <?php if (count($data_bursa_jobdesc) > 0) { ?>
                                <?php $no = 1; ?>

                                <?php foreach ($data_bursa_jobdesc as $jobdesc) { ?>
                                    <tr>
                                        <td class="text-center"><?= $no++; ?></td>

                                       <td class="text-wrap" style="min-width: 250px;">
                                            <?= aman($jobdesc['deskripsi_jobdesc']); ?>
                                        </td>

                                            <td class="text-center">
                                                <?php if (
                                                    $jobdesc['penerima_jobdesc'] ===
                                                    "Semua Mahasiswa"
                                                ) { ?>
                                                    <span class="badge bg-info text-dark">
                                                        Semua Mahasiswa
                                                    </span>

                                                <?php } elseif (
                                                    $jobdesc['penerima_jobdesc'] ===
                                                    "Mahasiswa dengan Jam Minus"
                                                ) { ?>
                                                    <span class="badge bg-warning text-dark">
                                                        Mahasiswa dengan Sisa Jam Minus
                                                    </span>

                                                <?php } else { ?>
                                                    <span class="badge bg-secondary">
                                                        <?= aman(
                                                            $jobdesc['penerima_jobdesc']
                                                        ); ?>
                                                    </span>
                                                <?php } ?>
                                            </td>

                                            <?php if ($role !== "Mahasiswa") { ?>
                                                <td>
                                                    <?= aman($jobdesc['nama_pemberi'] ?? '-'); ?><br>
                                                    <small class="text-muted">
                                                        <?= aman($jobdesc['username_pemberi'] ?? '-'); ?>
                                                    </small>
                                                </td>
                                            <?php } ?>

                                        <td class="text-center fw-semibold"><?= format_jam($jobdesc['jam_plus']); ?> Jam</td>

                                        <td class="text-center"><?= date('d-m-Y H:i', strtotime($jobdesc['tanggal_pemberian_jobdesc'])); ?></td>

                                        <?php if ($role !== "Mahasiswa") { ?>
                                            <td class="text-center"><?= (int) ($jobdesc['jumlah_mahasiswa_mengambil'] ?? 0); ?> / <?= (int) ($jobdesc['jumlah_mahasiswa_diperlukan'] ?? 0); ?></td>
                                        <?php } ?>

                                        <td class="text-center">
                                            <?php if ($jobdesc['status_jobdesc'] == "Dibuka") { ?>
                                                <span class="badge bg-success">Dibuka</span>
                                            <?php } elseif ($jobdesc['status_jobdesc'] == "Dikerjakan") { ?>
                                                <span class="badge bg-warning text-dark">Dikerjakan</span>
                                            <?php } else { ?>
                                                <span class="badge bg-primary">Selesai</span>
                                            <?php } ?>
                                        </td>

                                            <?php if ($role !== "Mahasiswa") { ?>
                                                <td>
                                                    <?= aman($jobdesc['nama_penerima'] ?? '-'); ?>
                                                </td>

                                                <td class="text-center">
                                                    <?php if (!empty($jobdesc['bukti_selesai_url'])) { ?>
                                                        <a href="<?= aman($jobdesc['bukti_selesai_url']); ?>" target="_blank" rel="noopener noreferrer" class="btn btn-outline-primary btn-sm">
                                                            Lihat Bukti Selesai
                                                        </a>
                                                    <?php } else { ?>
                                                        <span class="text-muted">-</span>
                                                    <?php } ?>
                                                </td>
                                            <?php } ?>

                                        <?php if ($role == "Mahasiswa" || $bisa_membuat_jobdesc) { ?>
                                            <td class="text-center">
                                                <?php if ($role == "Mahasiswa") { ?>

                                                    <?php
                                                    $sudah_daftar = $jobdesc['sudah_daftar'] ?? false;
                                                    $peran_saya = $jobdesc['peran_saya'] ?? '';
                                                    $jumlah_mengambil = (int) ($jobdesc['jumlah_mahasiswa_mengambil'] ?? 0);
                                                    $jumlah_diperlukan = (int) ($jobdesc['jumlah_mahasiswa_diperlukan'] ?? 0);
                                                    $bukti_selesai_url = trim($jobdesc['bukti_selesai_url'] ?? '');
                                                    $penerima_jobdesc = $jobdesc['penerima_jobdesc'] ?? 'Semua Mahasiswa';

                                                    $boleh_daftar_berdasarkan_jam = true;

                                                    if ($penerima_jobdesc == "Mahasiswa dengan Jam Minus" && $total_jam_minus_saya <= 0) {
                                                        $boleh_daftar_berdasarkan_jam = false;
                                                    }
                                                    ?>

                                                    <?php if ($peran_saya == "Penerima" && $jobdesc['status_jobdesc'] == "Dikerjakan" && $bukti_selesai_url == '') { ?>

                                                        <a href="selesai.php?id=<?= $jobdesc['id_bursa_jobdesc']; ?>" class="btn btn-primary btn-sm">
                                                            Kirim Bukti
                                                        </a>

                                                    <?php } elseif ($peran_saya == "Penerima" && $bukti_selesai_url != '') { ?>

                                                        <button type="button" class="btn btn-secondary btn-sm" disabled>
                                                            Bukti Terkirim
                                                        </button>

                                                    <?php } elseif ($sudah_daftar) { ?>

                                                        <button type="button" class="btn btn-secondary btn-sm" disabled>
                                                            Sudah Daftar
                                                        </button>

                                                    <?php } elseif (!$boleh_daftar_berdasarkan_jam) { ?>

                                                        <button type="button" class="btn btn-secondary btn-sm" disabled>
                                                            Tidak Memenuhi
                                                        </button>

                                                    <?php } elseif ($jobdesc['status_jobdesc'] == "Dibuka" && $jumlah_mengambil < $jumlah_diperlukan) { ?>

                                                        <a href="daftar.php?id=<?= $jobdesc['id_bursa_jobdesc']; ?>"
                                                        class="btn btn-primary btn-sm btn-konfirmasi"
                                                        data-title="Daftar Jobdesc?"
                                                        data-text="Yakin ingin mendaftar jobdesc ini?"
                                                        data-icon="question"
                                                        data-confirm-text="Ya, daftar"
                                                        data-cancel-text="Batal">
                                                            Daftar
                                                        </a>

                                                    <?php } else { ?>

                                                        <button type="button" class="btn btn-secondary btn-sm" disabled>
                                                            Penuh
                                                        </button>

                                                    <?php } ?>

                                                <?php } else { ?>

                                                    <?php
                                                    $bukti_selesai_url = trim($jobdesc['bukti_selesai_url'] ?? '');
                                                    $id_pemberi = $jobdesc['id_pemberi'] ?? '';
                                                    ?>

                                                    <?php if ($id_pemberi == $_SESSION['id_pengguna'] && $jobdesc['status_jobdesc'] == "Dikerjakan" && $bukti_selesai_url != '') { ?>

                                                        <a href="proses_selesaikan.php?id=<?= $jobdesc['id_bursa_jobdesc']; ?>"
                                                        class="btn btn-primary btn-sm btn-konfirmasi"
                                                        data-title="Selesaikan Jobdesc?"
                                                        data-text="Pastikan bukti selesai sudah benar. Yakin ingin mengubah status menjadi Selesai?"
                                                        data-icon="question"
                                                        data-confirm-text="Ya, selesaikan"
                                                        data-cancel-text="Batal">
                                                            Selesaikan
                                                        </a>

                                                    <?php } elseif ($id_pemberi == $_SESSION['id_pengguna'] && $jobdesc['status_jobdesc'] == "Dikerjakan" && $bukti_selesai_url == '') { ?>

                                                        <button type="button" class="btn btn-secondary btn-sm" disabled>
                                                            Menunggu Bukti
                                                        </button>

                                                    <?php } elseif ($id_pemberi == $_SESSION['id_pengguna'] && $jobdesc['status_jobdesc'] == "Selesai") { ?>

                                                        <button type="button" class="btn btn-secondary btn-sm" disabled>
                                                            Selesai
                                                        </button>

                                                    <?php } else { ?>

                                                        -

                                                    <?php } ?>

                                                <?php } ?>
                                            </td>
                                        <?php } ?>
                                    </tr>
                                <?php } ?>


                            <?php } ?>
                        </tbody>
                    </table>
                </div>

            </div>
        </div>
    </div>
</main>

<?php require_once "../../includes/dashboard_footer.php"; ?>