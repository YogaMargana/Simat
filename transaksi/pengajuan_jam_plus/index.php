<?php
require_once "../../config/koneksi.php";
require_once "../../config/function.php";
require_once "../../includes/auth_dashboard.php";

$role = $_SESSION['role'] ?? '';

// Hak akses: Mahasiswa, PIC Kemahasiswaan, Kepala Prodi
if (!in_array($role, ["Mahasiswa", "PIC Tata Tertib"])) {
    header("Location: /SIMAT/index.php");
    exit;
}

$page_title = "Pengajuan Jam Plus";
$active_menu = "pengajuan_jam_plus";

$data_pengajuan = [];

// Memanggil Stored Procedure Select
$query = mysqli_query($koneksi, "CALL usp_select_pengajuan_jam_plus()");

if ($query) {
    while ($row = mysqli_fetch_assoc($query)) {
        // Jika Mahasiswa, filter hanya miliknya sendiri
        if ($role == "Mahasiswa" && $row['id_pengaju'] != $_SESSION['id_pengguna']) {
            continue;
        }
        $data_pengajuan[] = $row;
    }
    // Bersihkan result set agar bisa menjalankan query lain setelah Stored Procedure
    mysqli_free_result($query);
    mysqli_next_result($koneksi);
}

require_once "../../includes/dashboard_header.php";
require_once "../../includes/sidebar.php";
?>

<main class="main-content">
    <div class="topbar">
        <h1 class="page-title">Pengajuan Jam Plus</h1>
        <div class="user-info">
            <div class="user-detail">
                <div class="user-name"><?= aman($_SESSION['username']); ?></div>
                <div class="user-role"><?= aman($_SESSION['role']); ?></div>
            </div>
            <div class="user-avatar"><?= strtoupper(substr($_SESSION['username'], 0, 1)); ?></div>
        </div>
    </div>

    <div class="content-wrapper">
        <?php if (isset($_GET['status']) && $_GET['status'] == "berhasil_tambah") { ?>
            <div class="alert alert-success">Pengajuan berhasil dikirim.</div>
        <?php } ?>
        <?php if (isset($_GET['status']) && $_GET['status'] == "berhasil_verifikasi") { ?>
            <div class="alert alert-success">Verifikasi berhasil disimpan.</div>
        <?php } ?>
        <?php if (isset($_GET['error'])) { ?>
            <div class="alert alert-danger"><?= aman($_GET['error']); ?></div>
        <?php } ?>

        <div class="card border-0 shadow-sm rounded-4">
            <div class="card-body p-4">
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <h4 class="fw-bold mb-0">Daftar Pengajuan</h4>
                    <?php if ($role == "Mahasiswa") { ?>
                        <a href="tambah.php" class="btn btn-primary"><i class="fa-solid fa-plus me-1"></i> Buat Pengajuan</a>
                    <?php } ?>
                </div>

                <div class="table-responsive">
                    <table id="myTable" class="table table-hover table-bordered table-striped align-middle text-nowrap" border="1">
                        <thead class="table-light">
                            <tr>
                                <th style="width: 60px" class="text-center">No</th>
                                <th class="text-center">Pengaju</th>
                                <th class="text-center">Kegiatan</th>
                                <th class="text-center">Jam Diajukan</th>
                                <th class="text-center">Sumber</th>
                                <th class="text-center">Jam Diterima</th>
                                <th class="text-center">Jenis</th>
                                <th class="text-center">Tanggal</th>
                                <th class="text-center">Status</th>
                                <th class="text-center">Aksi</th>
                            </tr>
                        </thead>
                        <tbody>
                            <?php if (count($data_pengajuan) > 0) { $no = 1; foreach ($data_pengajuan as $row) { ?>
                                <tr>
                                    <td class="text-center"><?= $no++; ?></td>
                                    <td><?= aman($row['nama_pengaju']); ?><br><small class="text-muted"><?= aman($row['nim_pengaju']); ?></small></td>
                                    <td><?= aman($row['nama_kegiatan']); ?></td>
                                    <td class="fw-bold text-primary">+<?= $row['jumlah_jam_plus']; ?></td>
                                    <td class="text-center">
                                        <?php if ($row['sumber_jam'] == "Prodi") { ?>
                                            <span class="badge bg-primary">Prodi</span>
                                        <?php } else { ?>
                                            <span class="badge bg-secondary">Luar</span>
                                        <?php } ?>
                                    </td>
                                    <td class="fw-bold text-success">
                                        +<?= number_format($row['jumlah_jam_diterima'], 2); ?>
                                    </td>
                                    <td class="text-center"><span class="badge border text-dark"><?= $row['jenis_jam']; ?></span></td>
                                    <td><?= date('d/m/Y', strtotime($row['tanggal_pengajuan'])); ?></td>
                                    <td class="text-center">
                                        <?php if ($row['status_pengajuan'] == "Menunggu Verifikasi") { ?>
                                            <span class="badge bg-warning text-dark">Menunggu</span>
                                        <?php } elseif ($row['status_pengajuan'] == "Disetujui") { ?>
                                            <span class="badge bg-success">Disetujui</span>
                                        <?php } else { ?>
                                            <span class="badge bg-danger">Ditolak</span>
                                        <?php } ?>
                                    </td>
                                    <td class="text-center">
                                        <?php if ($role == "PIC Tata Tertib" && $row['status_pengajuan'] == "Menunggu Verifikasi") { ?>
                                            <a href="verifikasi.php?id=<?= $row['id_pengajuan_jam_plus']; ?>" class="btn btn-primary btn-sm">Verifikasi</a>
                                        <?php } else { ?>
                                            <span class="text-muted small">-</span>
                                        <?php } ?>
                                    </td>
                                </tr>
                            <?php } } else { ?>
                                <tr><td colspan="10" class="text-center py-4">Belum ada data.</td></tr>
                            <?php } ?>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</main>
<?php require_once "../../includes/dashboard_footer.php"; ?>