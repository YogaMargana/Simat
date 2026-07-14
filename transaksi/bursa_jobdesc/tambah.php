<?php
require_once "../../config/koneksi.php";
require_once "../../config/function.php";
require_once "../../includes/auth_dashboard.php";

$role = $_SESSION['role'] ?? '';

cek_role_pembuat_jobdesc();

$page_title = "Tambah Bursa Jobdesc";
$active_menu = "bursa_jobdesc";
$tanggal_minimal = date('Y-m-d\TH:i');

require_once "../../includes/dashboard_header.php";
require_once "../../includes/sidebar.php";
?>

<main class="main-content">
    <div class="topbar">
        <h1 class="page-title">Tambah Bursa Jobdesc</h1>

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
                <h4 class="fw-bold mb-4">Form Tambah Bursa Jobdesc</h4>

                <?php if (isset($_GET['error'])) { ?>
                    <div
                        class="alert alert-danger alert-dismissible fade show"
                        role="alert"
                    >
                        <?= aman($_GET['error']); ?>

                        <button
                            type="button"
                            class="btn-close"
                            data-bs-dismiss="alert"
                            aria-label="Tutup"
                        ></button>
                    </div>
                <?php } ?>

           <form action="proses_tambah.php" method="post">
                <div class="mb-3">
                    <label
                        for="deskripsi_jobdesc"
                        class="form-label fw-bold"
                    >
                        Deskripsi Jobdesc
                        <span class="text-danger">*</span>
                    </label>

                    <textarea
                        name="deskripsi_jobdesc"
                        id="deskripsi_jobdesc"
                        class="form-control"
                        rows="4"
                        placeholder="Jelaskan pekerjaan yang harus dilakukan"
                        required
                    ></textarea>
                </div>

                <div class="mb-3">
                    <label
                        for="penerima_jobdesc"
                        class="form-label fw-bold"
                    >
                        Sasaran Mahasiswa
                        <span class="text-danger">*</span>
                    </label>

                    <select
                        name="penerima_jobdesc"
                        id="penerima_jobdesc"
                        class="form-select"
                        required
                    >
                        <option value="">
                            Pilih sasaran mahasiswa
                        </option>

                        <option value="Semua Mahasiswa">
                            Semua Mahasiswa
                        </option>

                        <option value="Mahasiswa dengan Jam Minus">
                            Mahasiswa dengan Sisa Jam Minus
                        </option>
                    </select>

                    <div class="form-text">
                        Pilih kelompok mahasiswa yang diperbolehkan
                        mengambil jobdesc.
                    </div>
                </div>

                <div class="mb-3">
                    <label
                        for="jam_plus"
                        class="form-label fw-bold"
                    >
                        Jam Plus
                        <span class="text-danger">*</span>
                    </label>

                    <div class="input-group">
                        <input
                            type="number"
                            name="jam_plus"
                            id="jam_plus"
                            class="form-control"
                            min="0.1"
                            max="1000.0"
                            step="0.1"
                            inputmode="decimal"
                            placeholder="0.0"
                            required
                        >

                        <span class="input-group-text">
                            Jam
                        </span>
                    </div>

                    <div class="form-text">
                        Masukkan jumlah antara 0,1 sampai 1000,0 jam.
                    </div>
                </div>

                <div class="mb-3">
                    <label
                        for="tanggal_pemberian_jobdesc"
                        class="form-label fw-bold">
                        Tanggal Pemberian Jobdesc
                        <span class="text-danger">*</span>
                    </label>

                    <input
                        type="datetime-local"
                        name="tanggal_pemberian_jobdesc"
                        id="tanggal_pemberian_jobdesc"
                        class="form-control"
                        min="<?= aman($tanggal_minimal); ?>"
                        required>

                    <div class="form-text">
                        Tanggal dan waktu tidak boleh lebih awal dari
                        waktu sekarang.
                    </div>
                </div>

                <div class="mb-4">
                    <label
                        for="jumlah_mahasiswa_diperlukan"
                        class="form-label fw-bold">
                        Jumlah Mahasiswa Diperlukan
                        <span class="text-danger">*</span>
                    </label>

                    <input
                        type="number"
                        name="jumlah_mahasiswa_diperlukan"
                        id="jumlah_mahasiswa_diperlukan"
                        class="form-control"
                        min="1"
                        step="1"
                        placeholder="Contoh: 2"
                        required>
                </div>

                <div class="d-flex gap-2">
                    <button type="submit"name="simpan"class="btn btn-primary">
                        <i class="fa-solid fa-floppy-disk me-1"></i>
                        Simpan Jobdesc
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

<?php require_once "../../includes/dashboard_footer.php"; ?>