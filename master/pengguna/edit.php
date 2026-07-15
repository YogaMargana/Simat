<?php
require_once "../../config/koneksi.php";
require_once "../../config/function.php";
require_once "../../includes/auth_dashboard.php";

// /** @var mysqli $koneksi */

cek_role_dashboard("Kepala Prodi");

$page_title = "Edit Pengguna";
$active_menu = "pengguna";

$id_pengguna = $_GET['id'] ?? '';

if ($id_pengguna == '') {
    header("Location: index.php?error=" . urlencode("ID pengguna tidak ditemukan."));
    exit;
}

$pengguna = ambil_satu_procedure_prepared(
    $koneksi,
    "CALL usp_select_pengguna_by_id(?)",
    "i",
    [(int) $id_pengguna]
);

if (!$pengguna) {
    header("Location: index.php?error=" . urlencode("Data pengguna tidak ditemukan."));
    exit;
}

if ($pengguna['status_akun'] === "Tidak Aktif") {
    header("Location: index.php?error=" . urlencode("Akun tidak aktif tidak dapat diedit."));
    exit;
}

$data_mahasiswa_raw = ambil_data_procedure_prepared(
    $koneksi,
    "CALL usp_select_identitas_pengguna_tersedia(?, ?)",
    "si",
    ['Mahasiswa', (int) $id_pengguna]
);
$data_mahasiswa = array_map(static function ($row) {
    return [
        'id_mahasiswa' => $row['id_identitas'],
        'nim' => $row['nomor_identitas'],
        'nama_mahasiswa' => $row['nama_identitas'],
    ];
}, $data_mahasiswa_raw);

$data_pengajar_raw = ambil_data_procedure_prepared(
    $koneksi,
    "CALL usp_select_identitas_pengguna_tersedia(?, ?)",
    "si",
    ['Pengajar', (int) $id_pengguna]
);
$data_pengajar = array_map(static function ($row) {
    return [
        'id_pengajar' => $row['id_identitas'],
        'nip' => $row['nomor_identitas'],
        'nama_pengajar' => $row['nama_identitas'],
    ];
}, $data_pengajar_raw);

require_once "../../includes/dashboard_header.php";
require_once "../../includes/sidebar.php";
?>

<main class="main-content">
    <div class="topbar">
        <h1 class="page-title">Edit Pengguna</h1>

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
                <h4 class="fw-bold mb-4">Form Edit Pengguna</h4>

                <form action="proses_edit.php" method="post">
                    <?= csrf_input(); ?>
                    <input type="hidden" name="id_pengguna" value="<?= aman($pengguna['id_pengguna']); ?>">

                    <div class="mb-3">
                        <label class="form-label">Role <span class="text-danger">*</span></label>
                        <select name="role" id="role" class="form-select" required>
                            <option value="Mahasiswa" <?= $pengguna['role'] == "Mahasiswa" ? "selected" : ""; ?>>Mahasiswa</option>
                            <option value="Pengajar" <?= $pengguna['role'] == "Pengajar" ? "selected" : ""; ?>>Pengajar</option>
                            <option value="PIC Tata Tertib" <?= $pengguna['role'] == "PIC Tata Tertib" ? "selected" : ""; ?>>PIC Tata Tertib</option>
                            <option value="PIC Aset Fasilitas" <?= $pengguna['role'] == "PIC Aset Fasilitas" ? "selected" : ""; ?>>PIC Aset Fasilitas</option>
                            <option value="PIC Kemahasiswaan" <?= $pengguna['role'] == "PIC Kemahasiswaan" ? "selected" : ""; ?>>PIC Kemahasiswaan</option>
                            <option value="Kepala Prodi" <?= $pengguna['role'] == "Kepala Prodi" ? "selected" : ""; ?>>Kepala Prodi</option>
                        </select>
                    </div>

                    <div class="mb-3" id="pilih_mahasiswa">
                        <label class="form-label">Data Mahasiswa</label>
                        <select name="id_mahasiswa" class="form-select">
                            <option value="">Pilih Mahasiswa</option>
                            <?php foreach ($data_mahasiswa as $mahasiswa) { ?>
                                <option value="<?= $mahasiswa['id_mahasiswa']; ?>" <?= $mahasiswa['id_mahasiswa'] == $pengguna['id_mahasiswa'] ? "selected" : ""; ?>>
                                    <?= aman($mahasiswa['nim'] . " - " . $mahasiswa['nama_mahasiswa']); ?>
                                </option>
                            <?php } ?>
                        </select>
                    </div>

                    <div class="mb-3" id="pilih_pengajar">
                        <label class="form-label">Data Pengajar</label>
                        <select name="id_pengajar" class="form-select">
                            <option value="">Pilih Pengajar</option>
                            <?php foreach ($data_pengajar as $pengajar) { ?>
                                <option value="<?= $pengajar['id_pengajar']; ?>" <?= $pengajar['id_pengajar'] == $pengguna['id_pengajar'] ? "selected" : ""; ?>>
                                    <?= aman($pengajar['nip'] . " - " . $pengajar['nama_pengajar']); ?>
                                </option>
                            <?php } ?>
                        </select>
                    </div>

                    <div class="mb-3">
                        <label class="form-label">Username <span class="text-danger">*</span></label>
                        <input type="text" name="username" class="form-control" maxlength="20" value="<?= aman($pengguna['username']); ?>" required>
                    </div>

                    <div class="mb-3">
                        <label class="form-label">Password Baru</label>
                        <input type="text" name="password" class="form-control" maxlength="255">
                        <small class="text-muted">Kosongkan jika password tidak ingin diubah.</small>
                    </div>

                    <div class="d-flex gap-2">
                        <button type="submit" name="update" class="btn btn-primary">
                            <i class="fa-solid fa-floppy-disk me-1"></i>
                            Simpan Perubahan
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

    function aturPilihan() {
        if (role.value === 'Mahasiswa') {
            pilihMahasiswa.style.display = 'block';
            pilihPengajar.style.display = 'none';
        } else {
            pilihMahasiswa.style.display = 'none';
            pilihPengajar.style.display = 'block';
        }
    }

    role.addEventListener('change', aturPilihan);
    aturPilihan();
</script>

<?php require_once "../../includes/dashboard_footer.php"; ?>