<?php
require_once "../../config/koneksi.php";
require_once "../../config/function.php";
require_once "../../includes/auth_dashboard.php";

$role = $_SESSION['role'] ?? '';

if ($role == '') {
    header("Location: /SIMAT/index.php");
    exit;
}

$bisa_membuat_jobdesc = $role != "Mahasiswa";

$page_title = "Bursa Jobdesc";
$active_menu = "bursa_jobdesc";

$data_bursa_jobdesc = [];

$query = mysqli_query($koneksi, "CALL usp_select_bursa_jobdesc()");

if ($query) {
    while ($row = mysqli_fetch_assoc($query)) {
        $data_bursa_jobdesc[] = $row;
    }

    mysqli_free_result($query);
    mysqli_next_result($koneksi);
}

$total_jam_minus_saya = 0;

if ($role == "Mahasiswa") {
    $id_mahasiswa_login = $_SESSION['id_mahasiswa'] ?? null;

    if ($id_mahasiswa_login != null) {
        $stmt_total = mysqli_prepare($koneksi, "
            SELECT ufn_total_jam_minus_mahasiswa(?) AS total_jam_minus
        ");

        mysqli_stmt_bind_param($stmt_total, "i", $id_mahasiswa_login);
        mysqli_stmt_execute($stmt_total);

        $result_total = mysqli_stmt_get_result($stmt_total);
        $row_total = mysqli_fetch_assoc($result_total);

        $total_jam_minus_saya = (float) ($row_total['total_jam_minus'] ?? 0);

        mysqli_stmt_close($stmt_total);
    }

    foreach ($data_bursa_jobdesc as $index => $jobdesc) {
        $stmt_cek = mysqli_prepare($koneksi, "
            SELECT peran_pengguna
            FROM detail_pengguna_pada_bursa_jobdesc
            WHERE id_bursa_jobdesc = ?
            AND id_pengguna = ?
            LIMIT 1
        ");

        mysqli_stmt_bind_param(
            $stmt_cek,
            "ii",
            $jobdesc['id_bursa_jobdesc'],
            $_SESSION['id_pengguna']
        );

        mysqli_stmt_execute($stmt_cek);

        $result_cek = mysqli_stmt_get_result($stmt_cek);
        $cek = mysqli_fetch_assoc($result_cek);

        mysqli_stmt_close($stmt_cek);

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
                                <th class="text-center">Pemberi</th>
                                <th class="text-center">Jam Plus</th>
                                <th class="text-center">Tanggal</th>
                                <th class="text-center">Terisi/Kuota</th>
                                <th class="text-center">Status</th>
                                <th class="text-center">Penerima</th>
                                <th class="text-center">Bukti Selesai</th>

                                <?php if ($role == "Mahasiswa" || $bisa_membuat_jobdesc) { ?>
                                    <th style="width: 170px;" class="text-center">Aksi</th>
                                <?php } ?>
                            </tr>
                        </thead>
                        <tbody>
                            <?php if (count($data_bursa_jobdesc) > 0) { ?>
                                <?php $no = 1; ?>

                                <?php foreach ($data_bursa_jobdesc as $jobdesc) { ?>
                                    <tr>
                                        <td class="text-center"><?= $no++; ?></td>

                                        <td><?= aman($jobdesc['deskripsi_jobdesc']); ?></td>

                                        <td class="text-center">
                                            <?php if ($jobdesc['penerima_jobdesc'] == "Semua mahasiswa") { ?>
                                                <span class="badge bg-info text-dark">Semua mahasiswa</span>
                                            <?php } else { ?>
                                                <span class="badge bg-warning text-dark">Yang memiliki jam minus</span>
                                            <?php } ?>
                                        </td>

                                        <td>
                                            <?= aman($jobdesc['nama_pemberi'] ?? '-'); ?><br>
                                            <small class="text-muted">
                                                <?= aman($jobdesc['username_pemberi'] ?? '-'); ?>
                                            </small>
                                        </td>

                                        <td class="text-center"><?= aman($jobdesc['jam_plus']); ?></td>

                                        <td><?= aman($jobdesc['tanggal_pemberian_jobdesc']); ?></td>

                                        <td class="text-center">
                                            <?= aman($jobdesc['jumlah_mahasiswa_mengambil'] ?? '0'); ?>
                                            /
                                            <?= aman($jobdesc['jumlah_mahasiswa_diperlukan'] ?? '0'); ?>
                                        </td>

                                        <td class="text-center">
                                            <?php if ($jobdesc['status_jobdesc'] == "Dibuka") { ?>
                                                <span class="badge bg-success">Dibuka</span>
                                            <?php } elseif ($jobdesc['status_jobdesc'] == "Dikerjakan") { ?>
                                                <span class="badge bg-warning text-dark">Dikerjakan</span>
                                            <?php } else { ?>
                                                <span class="badge bg-primary">Selesai</span>
                                            <?php } ?>
                                        </td>

                                        <td>
                                            <?= aman($jobdesc['nama_penerima'] ?? '-'); ?>
                                        </td>

                                        <td class="text-center">
                                            <?php if (!empty($jobdesc['bukti_selesai_url'])) { ?>
                                                <a href="<?= aman($jobdesc['bukti_selesai_url']); ?>" target="_blank" class="btn btn-outline-primary btn-sm">
                                                    Lihat Bukti
                                                </a>
                                            <?php } else { ?>
                                                <span class="text-muted">-</span>
                                            <?php } ?>
                                        </td>

                                        <?php if ($role == "Mahasiswa" || $bisa_membuat_jobdesc) { ?>
                                            <td class="text-center">
                                                <?php if ($role == "Mahasiswa") { ?>

                                                    <?php
                                                    $sudah_daftar = $jobdesc['sudah_daftar'] ?? false;
                                                    $peran_saya = $jobdesc['peran_saya'] ?? '';
                                                    $jumlah_mengambil = (int) ($jobdesc['jumlah_mahasiswa_mengambil'] ?? 0);
                                                    $jumlah_diperlukan = (int) ($jobdesc['jumlah_mahasiswa_diperlukan'] ?? 0);
                                                    $bukti_selesai_url = trim($jobdesc['bukti_selesai_url'] ?? '');
                                                    $penerima_jobdesc = $jobdesc['penerima_jobdesc'] ?? 'Semua mahasiswa';

                                                    $boleh_daftar_berdasarkan_jam = true;

                                                    if ($penerima_jobdesc == "Yang memiliki jam minus" && $total_jam_minus_saya <= 0) {
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
                                                        class="btn btn-success btn-sm btn-konfirmasi"
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

                            <?php } else { ?>
                                <tr>
                                    <td colspan="12" class="text-center text-muted py-4">
                                        Data bursa jobdesc belum tersedia.
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