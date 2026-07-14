<?php
require_once "../../config/koneksi.php";
require_once "../../config/function.php";
require_once "../../includes/auth_dashboard.php";

$role = $_SESSION['role'] ?? '';

// Hanya Mahasiswa yang boleh membuat pengajuan jam plus
if ($role !== "Mahasiswa") {
    header("Location: /SIMAT/index.php");
    exit;
}

$page_title = "Buat Pengajuan Jam Plus";
$active_menu = "pengajuan_jam_plus";

// Mengambil daftar kegiatan aktif dari database
$data_kegiatan = ambil_data_procedure(
    $koneksi,
    "CALL usp_select_kegiatan_aktif()"
);

require_once "../../includes/dashboard_header.php";
require_once "../../includes/sidebar.php";
?>

<main class="main-content">
    <div class="topbar">
        <h1 class="page-title">Tambah Pengajuan Jam Plus</h1>

        <div class="user-info">
            <div class="user-detail">
                <div class="user-name">
                    <?= aman($_SESSION['username']); ?>
                </div>

                <div class="user-role">
                    <?= aman($_SESSION['role']); ?>
                </div>
            </div>

            <div class="user-avatar">
                <?= strtoupper(
                    substr($_SESSION['username'], 0, 1)
                ); ?>
            </div>
        </div>
    </div>

    <div class="content-wrapper">
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

        <div class="card border-0 shadow-sm rounded-4">
            <div class="card-body p-4">
                <h4 class="fw-bold mb-4">
                    Form Pengajuan Jam Plus
                </h4>

                <form
                    action="proses_tambah.php"
                    method="post"
                >
                    <div class="row">
                        <div class="col-md-6">
                            <div class="mb-3">
                                <label
                                    for="jumlah_jam_plus"
                                    class="form-label fw-bold"
                                >
                                    Jumlah Jam Plus
                                    <span class="text-danger">*</span>
                                </label>

                                <div class="input-group">
                                    <input
                                        type="number"
                                        name="jumlah_jam_plus"
                                        id="jumlah_jam_plus"
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
                                    Masukkan jumlah antara 0,1 sampai
                                    1000,0 jam.
                                </div>
                            </div>
                        </div>

                        <div class="col-md-6">
                            <div class="mb-3">
                                <label
                                    for="jenis_jam"
                                    class="form-label fw-bold"
                                >
                                    Jenis Jam
                                    <span class="text-danger">*</span>
                                </label>

                                <select
                                    name="jenis_jam"
                                    id="jenis_jam"
                                    class="form-select"
                                    required
                                >
                                    <option value="">
                                        Pilih jenis jam
                                    </option>

                                    <option value="Murni">
                                        Jam Plus Murni
                                    </option>

                                    <option value="Kompensasi">
                                        Jam Plus Kompensasi
                                    </option>
                                </select>
                            </div>
                        </div>
                    </div>

                    <div class="row">
                        <div class="col-md-6">
                            <div class="mb-3">
                                <label
                                    for="sumber_jam"
                                    class="form-label fw-bold"
                                >
                                    Sumber Jam
                                    <span class="text-danger">*</span>
                                </label>

                                <select
                                    name="sumber_jam"
                                    id="sumber_jam"
                                    class="form-select"
                                    required
                                >
                                    <option value="">
                                        Pilih sumber jam
                                    </option>

                                    <option value="Prodi">
                                        Kegiatan dari Prodi
                                    </option>

                                    <option value="Luar">
                                        Kegiatan dari Luar Prodi
                                    </option>
                                </select>

                                <div class="form-text">
                                    Pilih kegiatan jika sumber jam berasal
                                    dari luar Prodi.
                                </div>
                            </div>
                        </div>

                        <div class="col-md-6">
                            <div
                                class="mb-3 d-none"
                                id="wrapper_kegiatan"
                            >
                                <label
                                    for="id_kegiatan"
                                    class="form-label fw-bold"
                                >
                                    Kegiatan

                                    <span
                                        class="text-danger d-none"
                                        id="tanda_wajib_kegiatan"
                                    >
                                        *
                                    </span>
                                </label>

                                <select
                                    name="id_kegiatan"
                                    id="id_kegiatan"
                                    class="form-select"
                                    disabled
                                >
                                    <option value="">
                                        Pilih kegiatan
                                    </option>

                                    <?php foreach (
                                        $data_kegiatan as $kegiatan
                                    ) { ?>
                                        <option
                                            value="<?= (int)
                                                $kegiatan['id_kegiatan']; ?>"
                                        >
                                            <?= aman(
                                                $kegiatan['nama_kegiatan']
                                            ); ?>

                                            -

                                            <?= aman(
                                                $kegiatan['penyelenggara']
                                            ); ?>

                                            <?php if (
                                                !empty(
                                                    $kegiatan[
                                                        'tanggal_kegiatan'
                                                    ]
                                                )
                                            ) { ?>
                                                -
                                                <?= date(
                                                    'd/m/Y',
                                                    strtotime(
                                                        $kegiatan[
                                                            'tanggal_kegiatan'
                                                        ]
                                                    )
                                                ); ?>
                                            <?php } ?>
                                        </option>
                                    <?php } ?>
                                </select>

                                <div class="form-text">
                                    Kegiatan wajib dipilih untuk sumber
                                    jam dari luar Prodi.
                                </div>
                            </div>
                        </div>

                        <div class="col-md-6">
                            <div class="mb-3">
                                <label
                                    for="nama_pemberi"
                                    class="form-label fw-bold"
                                >
                                    Nama Pemberi Tugas
                                    <span class="text-danger">*</span>
                                </label>

                                <input
                                    type="text"
                                    name="nama_pemberi"
                                    id="nama_pemberi"
                                    class="form-control"
                                    maxlength="50"
                                    placeholder="Masukkan nama pemberi tugas"
                                    required
                                >
                            </div>
                        </div>
                    </div>

                    <div class="mb-3">
                        <label
                            for="deskripsi_pekerjaan"
                            class="form-label fw-bold"
                        >
                            Deskripsi Pekerjaan
                            <span class="text-danger">*</span>
                        </label>

                        <textarea
                            name="deskripsi_pekerjaan"
                            id="deskripsi_pekerjaan"
                            class="form-control"
                            rows="4"
                            placeholder="Jelaskan pekerjaan yang telah dilakukan"
                            required
                        ></textarea>
                    </div>

                    <div class="mb-4">
                        <label
                            for="dokumen_url"
                            class="form-label fw-bold"
                        >
                            Tautan Dokumen Bukti
                            <span class="text-danger">*</span>
                        </label>

                        <input
                            type="url"
                            name="dokumen_url"
                            id="dokumen_url"
                            class="form-control"
                            maxlength="2048"
                            placeholder="https://drive.google.com/..."
                            required
                        >

                        <div class="form-text">
                            Pastikan dokumen dapat diakses oleh PIC Tata
                            Tertib.
                        </div>
                    </div>

                    <div class="d-flex gap-2">
                        <button
                            type="submit"
                            name="simpan"
                            class="btn btn-primary px-4"
                        >
                            <i
                                class="fa-solid fa-paper-plane me-1"
                            ></i>

                            Kirim Pengajuan
                        </button>

                        <a
                            href="index.php"
                            class="btn btn-secondary px-4"
                        >
                            Kembali
                        </a>
                    </div>
                </form>
            </div>
        </div>
    </div>
</main>

<script>
document.addEventListener('DOMContentLoaded', function () {
    const sumberJam = document.getElementById('sumber_jam');
    const wrapperKegiatan = document.getElementById(
        'wrapper_kegiatan'
    );
    const idKegiatan = document.getElementById('id_kegiatan');
    const tandaWajibKegiatan = document.getElementById(
        'tanda_wajib_kegiatan'
    );

    function aturKegiatan() {
        if (sumberJam.value === 'Luar') {
            wrapperKegiatan.classList.remove('d-none');
            tandaWajibKegiatan.classList.remove('d-none');

            idKegiatan.disabled = false;
            idKegiatan.setAttribute('required', 'required');
        } else {
            wrapperKegiatan.classList.add('d-none');
            tandaWajibKegiatan.classList.add('d-none');

            idKegiatan.removeAttribute('required');
            idKegiatan.value = '';
            idKegiatan.disabled = true;
        }
    }

    sumberJam.addEventListener('change', aturKegiatan);

    aturKegiatan();
});
</script>

<?php require_once "../../includes/dashboard_footer.php"; ?>