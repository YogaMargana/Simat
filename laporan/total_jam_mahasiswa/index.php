<?php
require_once "../../config/koneksi.php";
require_once "../../config/function.php";
require_once "../../includes/auth_dashboard.php";

cek_role_dashboard("PIC Tata Tertib");
$page_title = "Laporan Total Jam Mahasiswa";
$active_menu = "laporan_total_jam_mahasiswa";

$opsi_sort = [
    'nim' => 'NIM',
    'nama' => 'Nama Mahasiswa',
    'total_tertinggi' => 'Total Jam Tertinggi',
    'total_terendah' => 'Total Jam Terendah',
];
$sort = $_GET['sort'] ?? 'nim';
if (!array_key_exists($sort, $opsi_sort)) {
    $sort = 'nim';
}

$data_laporan = [];
$stmt = mysqli_prepare($koneksi, "CALL usp_select_laporan_total_jam(?)");
if ($stmt) {
    mysqli_stmt_bind_param($stmt, "s", $sort);
    if (mysqli_stmt_execute($stmt)) {
        $result = mysqli_stmt_get_result($stmt);
        while ($result && $row = mysqli_fetch_assoc($result)) {
            $data_laporan[] = $row;
        }
        if ($result) mysqli_free_result($result);
    } else {
        $error_laporan = pesan_error_statement($stmt, 'Gagal mengambil data laporan.');
    }
    mysqli_stmt_close($stmt);
    bersihkan_hasil_procedure($koneksi);
} else {
    $error_laporan = "Gagal menyiapkan laporan.";
}

function class_total_jam($nilai)
{
    if ((float) $nilai < 0) return "text-danger";
    if ((float) $nilai > 0) return "text-success";
    return "text-muted";
}

require_once "../../includes/dashboard_header.php";
require_once "../../includes/sidebar.php";
?>
<main class="main-content">
    <div class="topbar">
        <h1 class="page-title">Laporan Total Jam Mahasiswa</h1>
        <div class="user-info"><div class="user-detail"><div class="user-name"><?= aman($_SESSION['username']); ?></div><div class="user-role"><?= aman($_SESSION['role']); ?></div></div><div class="user-avatar"><?= strtoupper(substr($_SESSION['username'], 0, 1)); ?></div></div>
    </div>
    <div class="content-wrapper">
        <?php if (isset($error_laporan)) { ?><div class="alert alert-danger"><?= aman($error_laporan); ?></div><?php } ?>
        <div class="card border-0 shadow-sm rounded-4"><div class="card-body p-4">
            <div class="d-flex flex-column flex-lg-row justify-content-between align-items-lg-end mb-4 gap-3">
                <div><h4 class="fw-bold mb-1">Data Total Jam Mahasiswa</h4><p class="text-muted mb-0">Urutkan data berdasarkan NIM, nama, atau total jam.</p></div>
                <div class="d-flex flex-column flex-md-row gap-2 align-items-md-end">
                    <form method="get" class="d-flex gap-2 align-items-end">
                        <div><label for="sort" class="form-label mb-1">Urutkan Berdasarkan <span class="text-danger">*</span></label><select id="sort" name="sort" class="form-select" required>
                            <?php foreach ($opsi_sort as $nilai => $label) { ?><option value="<?= aman($nilai); ?>" <?= $sort === $nilai ? 'selected' : ''; ?>><?= aman($label); ?></option><?php } ?>
                        </select></div>
                        <button type="submit" class="btn btn-primary"><i class="fa-solid fa-sort me-1"></i>Terapkan</button>
                    </form>
                    <a href="cetak.php?sort=<?= urlencode($sort); ?>" target="_blank" rel="noopener noreferrer" class="btn btn-danger"><i class="fa-solid fa-file-pdf me-1"></i>Cetak PDF</a>
                </div>
            </div>
            <div class="alert alert-info"><strong>Aturan Perhitungan:</strong> Jam plus murni tidak bisa membayar jam minus kompensasi. Jam plus kompensasi digunakan untuk membayar jam minus kompensasi terlebih dahulu, lalu sisanya dapat membayar jam minus murni.</div>
            <div class="table-responsive"><table id="myTable" class="table table-hover table-bordered table-striped align-middle text-nowrap">
                <thead class="table-light"><tr><th class="text-center">No</th><th>NIM</th><th>Nama Mahasiswa</th><th>Kelas</th><th class="text-end">Total Jam Kompensasi</th><th class="text-end">Total Jam Murni</th><th class="text-end">Total Jam</th></tr></thead>
                <tbody><?php if ($data_laporan) { $no=1; foreach ($data_laporan as $row) { ?><tr>
                    <td class="text-center"><?= $no++; ?></td><td><?= aman($row['nim']); ?></td><td><?= aman($row['nama_mahasiswa']); ?></td><td><?= aman($row['nama_kelas']); ?></td>
                    <td class="text-end fw-bold <?= class_total_jam($row['total_jam_kompensasi']); ?>"><?= format_jam($row['total_jam_kompensasi']); ?></td>
                    <td class="text-end fw-bold <?= class_total_jam($row['total_jam_murni']); ?>"><?= format_jam($row['total_jam_murni']); ?></td>
                    <td class="text-end fw-bold <?= class_total_jam($row['total_jam_mahasiswa']); ?>"><?= format_jam($row['total_jam_mahasiswa']); ?></td>
                </tr><?php } } else { ?><tr><td colspan="7" class="text-center text-muted py-4">Belum ada data mahasiswa aktif.</td></tr><?php } ?></tbody>
            </table></div>
        </div></div>
    </div>
</main>
<?php require_once "../../includes/dashboard_footer.php"; ?>
