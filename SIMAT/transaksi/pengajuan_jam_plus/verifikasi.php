<?php
require_once "../../config/koneksi.php";
require_once "../../config/function.php";
require_once "../../includes/auth_dashboard.php";

$role = $_SESSION['role'] ?? '';

// Hanya PIC Kemahasiswaan yang boleh melakukan verifikasi
if ($role != "PIC Tata Tertib") {
    header("Location: /SIMAT/index.php");
    exit;
}

$page_title = "Verifikasi Pengajuan Jam Plus";
$active_menu = "pengajuan_jam_plus";

$id_pengajuan = $_GET['id'] ?? '';

if ($id_pengajuan == '') {
    header("Location: index.php?error=" . urlencode("ID pengajuan tidak ditemukan."));
    exit;
}

// Ambil detail pengajuan, data mahasiswa (pengaju), dan nama kegiatan
$stmt = mysqli_prepare($koneksi, "
    SELECT
        pjp.*,
        k.nama_kegiatan,
        m.nama_mahasiswa,
        m.nim,
        p.username AS username_pengaju
    FROM pengajuan_jam_plus pjp
    JOIN kegiatan k ON pjp.id_kegiatan = k.id_kegiatan
    JOIN detail_pengguna_pada_pengajuan_jam_plus dp ON pjp.id_pengajuan_jam_plus = dp.id_pengajuan_jam_plus
    JOIN pengguna p ON dp.id_pengguna = p.id_pengguna
    JOIN mahasiswa m ON p.id_mahasiswa = m.id_mahasiswa
    WHERE pjp.id_pengajuan_jam_plus = ? 
    AND dp.peran_pengguna = 'Pengaju'
    LIMIT 1
");

mysqli_stmt_bind_param($stmt, "i", $id_pengajuan);
mysqli_stmt_execute($stmt);

$result = mysqli_stmt_get_result($stmt);
$pengajuan = mysqli_fetch_assoc($result);

mysqli_stmt_close($stmt);

if (!$pengajuan) {
    header("Location: index.php?error=" . urlencode("Data pengajuan tidak ditemukan."));
    exit;
}

require_once "../../includes/dashboard_header.php";
require_once "../../includes/sidebar.php";
?>

<main class="main-content">
    <div class="topbar">
        <h1 class="page-title">Verifikasi Jam Plus</h1>

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
        <?php if (isset($_GET['error'])) { ?>
            <div class="alert alert-danger"><?= aman($_GET['error']); ?></div>
        <?php } ?>

        <div class="card border-0 shadow-sm rounded-4">
            <div class="card-body p-4">
                <div class="d-flex justify-content-between align-items-start mb-4">
                    <h4 class="fw-bold">Detail Pengajuan</h4>
                    <span class="badge <?= $pengajuan['status_pengajuan'] == 'Menunggu Verifikasi' ? 'bg-warning text-dark' : ($pengajuan['status_pengajuan'] == 'Disetujui' ? 'bg-success' : 'bg-danger') ?>">
                        <?= aman($pengajuan['status_pengajuan']); ?>
                    </span>
                </div>

                <div class="row mb-4">
                    <div class="col-md-6">
                        <table class="table table-sm table-borderless">
                            <tr>
                                <th style="width: 150px;">Nama Mahasiswa</th>
                                <td>: <?= aman($pengajuan['nama_mahasiswa']); ?></td>
                            </tr>
                            <tr>
                                <th>NIM</th>
                                <td>: <?= aman($pengajuan['nim']); ?></td>
                            </tr>
                            <tr>
                                <th>Kegiatan</th>
                                <td>: <?= aman($pengajuan['nama_kegiatan']); ?></td>
                            </tr>
                            <tr>
                                <th>Pemberi Tugas</th>
                                <td>: <?= aman($pengajuan['nama_pemberi']); ?></td>
                            </tr>
                        </table>
                    </div>
                    <div class="col-md-6 border-start">
                        <table class="table table-sm table-borderless">
                            <?php
                            $jumlah_jam_diterima = $pengajuan['sumber_jam'] == 'Luar'
                                ? $pengajuan['jumlah_jam_plus'] * 0.5
                                : $pengajuan['jumlah_jam_plus'];
                            ?>

                            <tr>
                                <th style="width: 150px;">Jam Diajukan</th>
                                <td class="fw-bold text-primary">
                                    : +<?= number_format($pengajuan['jumlah_jam_plus'], 2); ?> Jam
                                </td>
                            </tr>

                            <tr>
                                <th>Sumber Jam</th>
                                <td>
                                    : <?php if ($pengajuan['sumber_jam'] == "Prodi") { ?>
                                        <span class="badge bg-primary">Prodi</span>
                                        <small class="text-muted ms-1">Jam masuk utuh</small>
                                    <?php } else { ?>
                                        <span class="badge bg-secondary">Luar</span>
                                        <small class="text-muted ms-1">Jam masuk 50%</small>
                                    <?php } ?>
                                </td>
                            </tr>

                            <tr>
                                <th>Jam Diterima</th>
                                <td class="fw-bold text-success">
                                    : +<?= number_format($jumlah_jam_diterima, 2); ?> Jam
                                </td>
                            </tr>

                            <tr>
                                <th>Jenis Jam</th>
                                <td>
                                    : <span class="badge border text-dark"><?= aman($pengajuan['jenis_jam']); ?></span>
                                </td>
                            </tr>
                            <tr>
                                <th>Tanggal Ajuan</th>
                                <td>: <?= date('d F Y', strtotime($pengajuan['tanggal_pengajuan'])); ?></td>
                            </tr>
                            <tr>
                                <th>Dokumen Bukti</th>
                                <td>: 
                                    <a href="<?= aman($pengajuan['dokumen_url']); ?>" target="_blank" class="btn btn-info btn-sm text-white">
                                        <i class="fa-solid fa-external-link me-1"></i> Buka Dokumen
                                    </a>
                                </td>
                            </tr>
                        </table>
                    </div>
                </div>

                <div class="mb-4">
                    <label class="fw-bold d-block mb-2">Deskripsi Pekerjaan:</label>
                    <div class="p-3 bg-light rounded border">
                        <?= nl2br(aman($pengajuan['deskripsi_pekerjaan'])); ?>
                    </div>
                </div>

                <hr>

                <?php if ($pengajuan['status_pengajuan'] == "Menunggu Verifikasi") { ?>
                    <form action="proses_verifikasi.php" method="post">
                        <input type="hidden" name="id_pengajuan_jam_plus" value="<?= aman($pengajuan['id_pengajuan_jam_plus']); ?>">

                        <div class="mb-4">
                            <label class="form-label fw-bold">Keputusan Verifikasi</label>
                            <select name="status_pengajuan" class="form-select form-select-lg" required>
                                <option value="">-- Pilih Keputusan --</option>
                                <option value="Disetujui">Setujui Pengajuan (Jam diterima akan ditambahkan ke saldo)</option>
                                <option value="Ditolak">Tolak Pengajuan</option>
                            </select>
                        </div>

                        <div class="d-flex gap-2">
                            <button type="submit" name="verifikasi" class="btn btn-primary px-4">
                                <i class="fa-solid fa-save me-1"></i>
                                Simpan Keputusan
                            </button>

                            <a href="index.php" class="btn btn-secondary px-4">
                                Kembali
                            </a>
                        </div>
                    </form>
                <?php } else { ?>
                    <div class="alert alert-secondary d-flex align-items-center">
                        <i class="fa-solid fa-info-circle me-2"></i>
                        <span>Pengajuan ini sudah diproses dan tidak dapat diubah kembali.</span>
                    </div>
                    <a href="index.php" class="btn btn-secondary px-4">Kembali</a>
                <?php } ?>
            </div>
        </div>
    </div>
</main>

<?php require_once "../../includes/dashboard_footer.php"; ?>