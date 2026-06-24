<?php
require_once "../../config/koneksi.php";
require_once "../../config/function.php";
require_once "../../includes/auth_dashboard.php";

// /** @var mysqli $koneksi */

cek_role_dashboard("Kepala Prodi");

$page_title = "Tambah Pengguna";
$active_menu = "pengguna";

$data_mahasiswa = [];
$query_mahasiswa = mysqli_query($koneksi, "
    SELECT 
        m.id_mahasiswa,
        m.nim,
        m.nama_mahasiswa
    FROM mahasiswa m
    LEFT JOIN pengguna p ON m.id_mahasiswa = p.id_mahasiswa AND p.status_akun = 'Aktif'
    WHERE m.status_mahasiswa = 'Aktif'
    AND p.id_pengguna IS NULL
    ORDER BY m.nama_mahasiswa ASC
");

while ($row = mysqli_fetch_assoc($query_mahasiswa)) {
    $data_mahasiswa[] = $row;
}

$data_pengajar = [];
$query_pengajar = mysqli_query($koneksi, "
    SELECT 
        pg.id_pengajar,
        pg.nip,
        pg.nama_pengajar
    FROM pengajar pg 
    LEFT JOIN pengguna p ON pg.id_pengajar = p.id_pengajar AND p.status_akun = 'Aktif'
    WHERE pg.status_pengajar = 'Aktif'
    AND p.id_pengguna IS NULL
    ORDER BY pg.nama_pengajar ASC
");

while ($row = mysqli_fetch_assoc($query_pengajar)) {
    $data_pengajar[] = $row;
}

require_once "../../includes/dashboard_header.php";
require_once "../../includes/sidebar.php";
?>

<main class="main-content">
    <div class="topbar">
        <h1 class="page-title">Tambah Pengguna</h1>

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
                <h4 class="fw-bold mb-4">Form Tambah Pengguna</h4>

                <form action="proses_tambah.php" method="post">
                    <div class="mb-3">
                        <label class="form-label">Role</label>
                        <select name="role" id="role" class="form-select" required>
                            <option value="">Pilih Role</option>
                            <option value="Mahasiswa">Mahasiswa</option>
                            <option value="Pengajar">Pengajar</option>
                            <option value="PIC Tata Tertib">PIC Tata Tertib</option>
                            <option value="PIC Aset Fasilitas">PIC Aset Fasilitas</option>
                            <option value="PIC Kemahasiswaan">PIC Kemahasiswaan</option>
                            <option value="Kepala Prodi">Kepala Prodi</option>
                        </select>
                    </div>

                    <div class="mb-3" id="pilih_mahasiswa" style="display: none;">
                        <label class="form-label">Data Mahasiswa</label>
                        <select name="id_mahasiswa" class="form-select">
                            <option value="">Pilih Mahasiswa</option>
                            <?php foreach ($data_mahasiswa as $mahasiswa) { ?>
                                <option value="<?= $mahasiswa['id_mahasiswa']; ?>">
                                    <?= aman($mahasiswa['nim'] . " - " . $mahasiswa['nama_mahasiswa']); ?>
                                </option>
                            <?php } ?>
                        </select>
                        <small class="text-muted">Semua role login menggunakan username dan password.</small>
                    </div>

                    <div class="mb-3" id="pilih_pengajar" style="display: none;">
                        <label class="form-label">Data Pengajar</label>
                        <select name="id_pengajar" class="form-select">
                            <option value="">Pilih Pengajar</option>
                            <?php foreach ($data_pengajar as $pengajar) { ?>
                                <option value="<?= $pengajar['id_pengajar']; ?>">
                                    <?= aman($pengajar['nip'] . " - " . $pengajar['nama_pengajar']); ?>
                                </option>
                            <?php } ?>
                        </select>
                        <small class="text-muted">Semua role login menggunakan username dan password.</small>
                    </div>

                    <div class="mb-3">
                        <label class="form-label">Username</label>
                        <input type="text" name="username" class="form-control" maxlength="50" required>
                    </div>

                    <div class="mb-3">
                        <label class="form-label">Password</label>
                        <input type="text" name="password" class="form-control" maxlength="255" required>
                        <small class="text-muted">Sementara masih plain text, contoh: 123.</small>
                    </div>

                    <div class="d-flex gap-2">
                        <button type="submit" name="simpan" class="btn btn-primary">
                            <i class="fa-solid fa-floppy-disk me-1"></i>
                            Simpan
                        </button>

                        <a href="index.php" class="btn btn-secondary">
                            Kembali
                        </a>
                    </div>
                </form>
            </div>
        </div>
    </div>
</main>

<script>
    const role = document.getElementById('role');
    const pilihMahasiswa = document.getElementById('pilih_mahasiswa');
    const pilihPengajar = document.getElementById('pilih_pengajar');

    role.addEventListener('change', function () {
        if (this.value === 'Mahasiswa') {
            pilihMahasiswa.style.display = 'block';
            pilihPengajar.style.display = 'none';
        } else if (this.value !== '') {
            pilihMahasiswa.style.display = 'none';
            pilihPengajar.style.display = 'block';
        } else {
            pilihMahasiswa.style.display = 'none';
            pilihPengajar.style.display = 'none';
        }
    });
</script>

<?php require_once "../../includes/dashboard_footer.php"; ?>