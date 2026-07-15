<?php
require_once "../../config/koneksi.php";
require_once "../../config/function.php";
require_once "../../includes/auth_dashboard.php";

cek_role_bukan_mahasiswa();
$page_title = "Laporan Bursa Jobdesc";
$active_menu = "laporan_bursa_jobdesc";
$role = $_SESSION['role'] ?? '';

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
$stmt = mysqli_prepare($koneksi, "CALL usp_select_laporan_bursa_jobdesc_filter(?, ?, ?)");
if ($stmt) {
    mysqli_stmt_bind_param($stmt, "sss", $role, $tanggal_mulai, $tanggal_selesai);
    if (mysqli_stmt_execute($stmt)) {
        $result = mysqli_stmt_get_result($stmt);
        while ($result && $row = mysqli_fetch_assoc($result)) $data_laporan[] = $row;
        if ($result) mysqli_free_result($result);
    } else {
        $error_laporan = pesan_error_statement($stmt, 'Gagal mengambil laporan.');
    }
    mysqli_stmt_close($stmt);
    bersihkan_hasil_procedure($koneksi);
} else {
    $error_laporan = 'Gagal menyiapkan laporan.';
}

function format_tanggal_laporan_bursa($tanggal)
{
    if (empty($tanggal)) return '-';
    $timestamp = strtotime($tanggal);
    return $timestamp === false ? $tanggal : date('d/m/Y H:i', $timestamp);
}

$query_pdf = http_build_query(['filter' => $jenis_filter, 'nilai' => $nilai_filter]);
require_once "../../includes/dashboard_header.php";
require_once "../../includes/sidebar.php";
?>
<main class="main-content">
    <div class="topbar"><h1 class="page-title">Laporan Bursa Jobdesc</h1><div class="user-info"><div class="user-detail"><div class="user-name"><?= aman($_SESSION['username']); ?></div><div class="user-role"><?= aman($_SESSION['role']); ?></div></div><div class="user-avatar"><?= strtoupper(substr($_SESSION['username'],0,1)); ?></div></div></div>
    <div class="content-wrapper">
        <?php if(isset($error_laporan)){?><div class="alert alert-danger"><?= aman($error_laporan); ?></div><?php }?>
        <div class="card border-0 shadow-sm rounded-4"><div class="card-body p-4">
            <div class="d-flex flex-column flex-xl-row justify-content-between align-items-xl-end mb-4 gap-3">
                <div><h4 class="fw-bold mb-1">Data Bursa Jobdesc <?= aman($role); ?></h4><p class="text-muted mb-0">Filter laporan berdasarkan tanggal, bulan, atau tahun pemberian jobdesc.</p></div>
                <div class="d-flex flex-column flex-lg-row gap-2 align-items-lg-end">
                    <form method="get" class="d-flex flex-column flex-md-row gap-2 align-items-md-end">
                        <div><label class="form-label mb-1" for="filter">Jenis Filter <span class="text-danger">*</span></label><select name="filter" id="filter" class="form-select" required>
                            <option value="semua" <?= $jenis_filter==='semua'?'selected':''; ?>>Semua Data</option><option value="tanggal" <?= $jenis_filter==='tanggal'?'selected':''; ?>>Tanggal</option><option value="bulan" <?= $jenis_filter==='bulan'?'selected':''; ?>>Bulan</option><option value="tahun" <?= $jenis_filter==='tahun'?'selected':''; ?>>Tahun</option>
                        </select></div>
                        <div id="wrapper_nilai_filter"><label class="form-label mb-1" for="nilai">Nilai Filter</label><input type="text" id="nilai" name="nilai" class="form-control" value="<?= aman($nilai_filter); ?>" placeholder="Pilih jenis filter"></div>
                        <button type="submit" class="btn btn-primary"><i class="fa-solid fa-filter me-1"></i>Terapkan</button>
                    </form>
                    <a href="cetak.php?<?= aman($query_pdf); ?>" target="_blank" rel="noopener noreferrer" class="btn btn-danger"><i class="fa-solid fa-file-pdf me-1"></i>Cetak PDF</a>
                </div>
            </div>
            <div class="table-responsive">
                <?php if($data_laporan){?><table id="myTable" class="table table-hover table-bordered table-striped align-middle"><thead class="table-light"><tr><th class="text-center">No</th><th>Deskripsi</th><th>Penerima Jobdesc</th><th>Penerima</th><th class="text-end">Jam Plus</th><th class="text-center">Tanggal</th><th class="text-center">Kuota</th></tr></thead><tbody>
                <?php $no=1;foreach($data_laporan as $row){?><tr><td class="text-center"><?= $no++; ?></td><td><?= aman($row['deskripsi_jobdesc']); ?></td><td><?= aman($row['penerima_jobdesc']); ?></td><td><?= aman($row['target_penerima_jobdesc']); ?></td><td class="text-end fw-bold"><?= format_jam($row['jam_plus']); ?></td><td class="text-center"><?= aman(format_tanggal_laporan_bursa($row['tanggal_pemberian_jobdesc'])); ?></td><td class="text-center"><?= aman($row['kuota']); ?></td></tr><?php }?></tbody></table>
                <?php }else{?><div class="text-center text-muted py-4 border rounded">Tidak ada data bursa jobdesc sesuai filter.</div><?php }?>
            </div>
        </div></div>
    </div>
</main>
<script>
document.addEventListener('DOMContentLoaded',function(){const jenis=document.getElementById('filter');const nilai=document.getElementById('nilai');function atur(){const tipe=jenis.value;nilai.required=tipe!=='semua';nilai.disabled=tipe==='semua';nilai.type=tipe==='tanggal'?'date':tipe==='bulan'?'month':tipe==='tahun'?'number':'text';nilai.placeholder=tipe==='tahun'?'Contoh: 2026':'Pilih '+tipe;if(tipe==='tahun'){nilai.min='2000';nilai.max='2100';}else{nilai.removeAttribute('min');nilai.removeAttribute('max');}if(tipe==='semua')nilai.value='';}jenis.addEventListener('change',atur);atur();});
</script>
<?php require_once "../../includes/dashboard_footer.php"; ?>
