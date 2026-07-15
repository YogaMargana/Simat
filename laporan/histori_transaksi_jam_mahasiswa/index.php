<?php
require_once "../../config/koneksi.php";
require_once "../../config/function.php";
require_once "../../includes/auth_dashboard.php";

cek_role_dashboard("Mahasiswa");

$page_title = "Laporan Histori Transaksi Jam";
$active_menu = "laporan_histori_transaksi_jam";
$data_table_ordering = false;

$id_pengguna = (int) ($_SESSION['id_pengguna'] ?? 0);
$jenis_filter = $_GET['filter'] ?? 'semua';
$nilai_filter = trim($_GET['nilai'] ?? '');
if (!in_array($jenis_filter, ['semua', 'tanggal', 'bulan', 'tahun'], true)) {
    $jenis_filter = 'semua';
}

$pesan_filter = '';
$rentang = rentang_filter_tanggal($jenis_filter, $nilai_filter, $pesan_filter);
if ($rentang === false) {
    $error_laporan = $pesan_filter;
    $jenis_filter = 'semua';
    $nilai_filter = '';
    $rentang = [null, null];
}
[$tanggal_mulai, $tanggal_selesai] = $rentang;

$data_laporan = [];
$stmt = mysqli_prepare($koneksi, "CALL usp_select_laporan_histori_jam_mahasiswa_filter(?, ?, ?)");
if ($stmt) {
    mysqli_stmt_bind_param($stmt, "iss", $id_pengguna, $tanggal_mulai, $tanggal_selesai);
    if (mysqli_stmt_execute($stmt)) {
        $result = mysqli_stmt_get_result($stmt);
        while ($result && $row = mysqli_fetch_assoc($result)) {
            $data_laporan[] = $row;
        }
        if ($result) {
            mysqli_free_result($result);
        }
    } else {
        $error_laporan = pesan_error_statement($stmt, 'Data laporan gagal dimuat.');
    }
    mysqli_stmt_close($stmt);
    bersihkan_hasil_procedure($koneksi);
} else {
    $error_laporan = 'Data laporan gagal dimuat.';
}

function format_tanggal_histori_jam($tanggal)
{
    if (empty($tanggal)) {
        return '-';
    }
    $timestamp = strtotime($tanggal);
    return $timestamp === false ? $tanggal : date('d/m/Y H:i', $timestamp);
}

$query_pdf = http_build_query([
    'filter' => $jenis_filter,
    'nilai' => $nilai_filter,
]);

require_once "../../includes/dashboard_header.php";
require_once "../../includes/sidebar.php";
?>

<main class="main-content">
    <div class="topbar">
        <h1 class="page-title">Laporan Histori Transaksi Jam</h1>
        <div class="user-info">
            <div class="user-detail">
                <div class="user-name"><?= aman($_SESSION['username']); ?></div>
                <div class="user-role"><?= aman($_SESSION['role']); ?></div>
            </div>
            <div class="user-avatar"><?= aman(strtoupper(substr($_SESSION['username'], 0, 1))); ?></div>
        </div>
    </div>

    <div class="content-wrapper">
        <?php if (isset($error_laporan)) { ?>
            <div class="alert alert-danger"><?= aman($error_laporan); ?></div>
        <?php } ?>

        <div class="card border-0 shadow-sm rounded-4">
            <div class="card-body p-4">
                <div class="d-flex flex-column flex-xl-row justify-content-between align-items-xl-end mb-4 gap-3">
                    <div>
                        <h4 class="fw-bold mb-1">Histori Transaksi Jam Saya</h4>
                        <p class="text-muted mb-0">Filter berdasarkan tanggal, bulan, atau tahun transaksi.</p>
                    </div>

                    <div class="d-flex flex-column flex-lg-row gap-2 align-items-lg-end">
                        <form method="get" class="d-flex flex-column flex-md-row gap-2 align-items-md-end">
                            <div>
                                <label class="form-label mb-1" for="filter">Jenis Filter <span class="text-danger">*</span></label>
                                <select name="filter" id="filter" class="form-select" required>
                                    <option value="semua" <?= $jenis_filter === 'semua' ? 'selected' : ''; ?>>Semua Data</option>
                                    <option value="tanggal" <?= $jenis_filter === 'tanggal' ? 'selected' : ''; ?>>Tanggal</option>
                                    <option value="bulan" <?= $jenis_filter === 'bulan' ? 'selected' : ''; ?>>Bulan</option>
                                    <option value="tahun" <?= $jenis_filter === 'tahun' ? 'selected' : ''; ?>>Tahun</option>
                                </select>
                            </div>
                            <div>
                                <label class="form-label mb-1" for="nilai">Nilai Filter</label>
                                <input type="text" id="nilai" name="nilai" class="form-control" value="<?= aman($nilai_filter); ?>" placeholder="Pilih jenis filter">
                            </div>
                            <button type="submit" class="btn btn-primary">
                                <i class="fa-solid fa-filter me-1"></i>Terapkan
                            </button>
                        </form>

                        <a href="cetak.php?<?= aman($query_pdf); ?>" target="_blank" rel="noopener noreferrer" class="btn btn-danger">
                            <i class="fa-solid fa-file-pdf me-1"></i>Cetak PDF
                        </a>
                    </div>
                </div>

                <div class="alert alert-info">
                    Nilai pada empat kolom jam merupakan jumlah jam dari setiap transaksi pengajuan jam plus, pemberian jam minus, dan bursa jobdesc yang telah selesai, bukan saldo jam yang sedang dimiliki mahasiswa.
                </div>

                <div class="table-responsive">
                    <?php if (count($data_laporan) > 0) { ?>
                        <table id="myTable" class="table table-hover table-bordered table-striped align-middle">
                            <thead class="table-light">
                                <tr>
                                    <th class="text-center">Tanggal</th>
                                    <th>Jenis Transaksi</th>
                                    <th>Deskripsi</th>
                                    <th class="text-end">Jam Plus Kompensasi</th>
                                    <th class="text-end">Jam Minus Kompensasi</th>
                                    <th class="text-end">Jam Plus Murni</th>
                                    <th class="text-end">Jam Minus Murni</th>
                                </tr>
                            </thead>
                            <tbody>
                                <?php foreach ($data_laporan as $row) { ?>
                                    <tr>
                                        <td class="text-center text-nowrap"><?= aman(format_tanggal_histori_jam($row['tanggal_transaksi'])); ?></td>
                                        <td><?= aman($row['jenis_transaksi']); ?></td>
                                        <td style="min-width:320px;white-space:normal;"><?= nl2br(aman($row['deskripsi'])); ?></td>
                                        <td class="text-end fw-bold text-success"><?= format_jam($row['saldo_jam_plus_kompensasi']); ?></td>
                                        <td class="text-end fw-bold text-danger"><?= format_jam($row['saldo_jam_minus_kompensasi']); ?></td>
                                        <td class="text-end fw-bold text-success"><?= format_jam($row['saldo_jam_plus_murni']); ?></td>
                                        <td class="text-end fw-bold text-danger"><?= format_jam($row['saldo_jam_minus_murni']); ?></td>
                                    </tr>
                                <?php } ?>
                            </tbody>
                        </table>
                    <?php } else { ?>
                        <div class="text-center text-muted py-4 border rounded">Tidak ada histori transaksi jam sesuai filter.</div>
                    <?php } ?>
                </div>
            </div>
        </div>
    </div>
</main>

<script>
document.addEventListener('DOMContentLoaded', function () {
    const jenis = document.getElementById('filter');
    const nilai = document.getElementById('nilai');

    function aturInputFilter() {
        const tipe = jenis.value;
        nilai.required = tipe !== 'semua';
        nilai.disabled = tipe === 'semua';
        nilai.type = tipe === 'tanggal' ? 'date' : tipe === 'bulan' ? 'month' : tipe === 'tahun' ? 'number' : 'text';
        nilai.placeholder = tipe === 'tahun' ? 'Contoh: 2026' : 'Pilih ' + tipe;
        if (tipe === 'tahun') {
            nilai.min = '2000';
            nilai.max = '2100';
        } else {
            nilai.removeAttribute('min');
            nilai.removeAttribute('max');
        }
        if (tipe === 'semua') {
            nilai.value = '';
        }
    }

    jenis.addEventListener('change', aturInputFilter);
    aturInputFilter();
});
</script>

<?php require_once "../../includes/dashboard_footer.php"; ?>
