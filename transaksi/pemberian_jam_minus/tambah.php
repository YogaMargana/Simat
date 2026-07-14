<?php

require_once "../../config/koneksi.php";
require_once "../../config/function.php";
require_once "../../includes/auth_dashboard.php";

cek_role_dashboard("PIC Tata Tertib");

$page_title = "Tambah Pemberian Jam Minus";
$active_menu = "pemberian_jam_minus";

/* Mahasiswa aktif */
$data_mahasiswa = ambil_data_procedure(
    $koneksi,
    "CALL usp_select_mahasiswa_aktif_untuk_jam_minus()"
);

/*
 * Semua fasilitas.
 *
 * Sengaja menggunakan usp_select_fasilitas(),
 * bukan usp_select_fasilitas_aktif().
 */
$data_fasilitas = ambil_data_procedure(
    $koneksi,
    "CALL usp_select_fasilitas()"
);

require_once "../../includes/dashboard_header.php";
require_once "../../includes/sidebar.php";

?>

<main class="main-content">

    <div class="topbar">

        <h1 class="page-title">
            Tambah Pemberian Jam Minus
        </h1>

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
                    substr(
                        $_SESSION['username'],
                        0,
                        1
                    )
                ); ?>
            </div>

        </div>

    </div>

    <div class="content-wrapper">

        <?php if (isset($_GET['error'])) { ?>

            <div class="alert alert-danger">
                <?= aman($_GET['error']); ?>
            </div>

        <?php } ?>

        <div class="card border-0 shadow-sm rounded-4">

            <div class="card-body p-4">

                <h4 class="fw-bold mb-4">
                    Form Pemberian Jam Minus
                </h4>

                <form
                    action="proses_tambah.php"
                    method="post"
                    id="form_pemberian_jam_minus">

                    <div class="mb-3">

                        <label
                            for="id_pengguna_mahasiswa"
                            class="form-label fw-bold">
                            Mahasiswa
                            <span class="text-danger">*</span>
                        </label>

                        <select
                            name="id_pengguna_mahasiswa"
                            id="id_pengguna_mahasiswa"
                            class="form-select"
                            required>

                            <option value="">
                                Pilih Mahasiswa
                            </option>

                            <?php foreach (
                                $data_mahasiswa as $mahasiswa
                            ) { ?>

                                <option
                                    value="<?= (int)
                                            $mahasiswa['id_pengguna_mahasiswa']; ?>">

                                    <?= aman(
                                        $mahasiswa['nim']
                                    ); ?>

                                    -

                                    <?= aman(
                                        $mahasiswa['nama_mahasiswa']
                                    ); ?>

                                    -

                                    <?= aman(
                                        $mahasiswa['nama_kelas']
                                    ); ?>

                                </option>

                            <?php } ?>

                        </select>

                    </div>

                    <div class="mb-4">

                        <label
                            for="kategori_pelanggaran"
                            class="form-label fw-bold">
                            Kategori Pemberian Jam Minus
                            <span class="text-danger">*</span>
                        </label>

                        <select
                            name="kategori_pelanggaran"
                            id="kategori_pelanggaran"
                            class="form-select"
                            required>

                            <option value="">
                                Pilih Kategori
                            </option>

                            <option value="Akademik">
                                Akademik
                            </option>

                            <option value="Fasilitas">
                                Fasilitas
                            </option>

                            <option value="Lainnya">
                                Lainnya
                            </option>

                        </select>

                    </div>

                    <div id="section_akademik" class="d-none">

                        <div class="card bg-light border mb-4">

                            <div class="card-body">

                                <h5 class="fw-bold mb-3">
                                    Data Akademik
                                </h5>

                                <div class="mb-3">

                                    <label
                                        for="id_detail_kelas_pada_mata_kuliah"
                                        class="form-label fw-bold">
                                        Mata Kuliah
                                        <span class="text-danger">*</span>
                                    </label>

                                    <select
                                        name="id_detail_kelas_pada_mata_kuliah"
                                        id="id_detail_kelas_pada_mata_kuliah"
                                        class="form-select">

                                        <option value="">
                                            Pilih mahasiswa terlebih dahulu
                                        </option>

                                    </select>

                                    <div class="form-text">
                                        Hanya mata kuliah pada kelas mahasiswa
                                        terpilih yang dapat digunakan.
                                    </div>

                                </div>

                                <div class="mb-3">

                                    <label
                                        for="keterangan_absensi"
                                        class="form-label fw-bold">
                                        Keterangan Absensi
                                        <span class="text-danger">*</span>
                                    </label>

                                    <select
                                        name="keterangan_absensi"
                                        id="keterangan_absensi"
                                        class="form-select">

                                        <option value="">
                                            Pilih Keterangan Absensi
                                        </option>

                                        <option value="Izin">
                                            Izin
                                        </option>

                                        <option value="Sakit">
                                            Sakit
                                        </option>

                                        <option value="Alpa">
                                            Alpa
                                        </option>

                                    </select>

                                </div>

                                <div class="mb-3">
                                    <label
                                        for="jumlah_jam_minus_akademik"
                                        class="form-label fw-bold">
                                        Jumlah Jam Minus
                                        <span class="text-danger">*</span>
                                    </label>

                                    <div class="input-group">
                                        <input
                                            type="number"
                                            name="jumlah_jam_minus_akademik"
                                            id="jumlah_jam_minus_akademik"
                                            class="form-control"
                                            min="0.1"
                                            max="1000.0"
                                            step="0.1"
                                            inputmode="decimal"
                                            placeholder="0.0">

                                        <span class="input-group-text">
                                            Jam
                                        </span>
                                    </div>

                                    <div class="form-text">
                                        Masukkan jumlah antara 0,1 sampai 1000,0 jam.
                                    </div>
                                </div>

                                <div class="alert alert-info mb-0">
                                    Jenis jam minus:
                                    <strong>Jam Minus Murni</strong>
                                </div>

                            </div>

                        </div>

                    </div>

                    <div
                        id="section_fasilitas"
                        class="d-none">

                        <div class="card bg-light border mb-4">

                            <div class="card-body">

                                <h5 class="fw-bold mb-3">
                                    Data Kerusakan Fasilitas
                                </h5>

                                <div class="mb-3">

                                    <label
                                        for="id_fasilitas"
                                        class="form-label fw-bold">
                                        Fasilitas Rusak
                                        <span class="text-danger">*</span>
                                    </label>

                                    <select
                                        name="id_fasilitas"
                                        id="id_fasilitas"
                                        class="form-select">

                                        <option value="">
                                            Pilih Fasilitas
                                        </option>

                                        <?php foreach (
                                            $data_fasilitas as $fasilitas
                                        ) { ?>

                                            <option
                                                value="<?= (int)
                                                        $fasilitas['id_fasilitas']; ?>"

                                                data-harga="<?= aman(
                                                                $fasilitas['harga']
                                                            ); ?>">

                                                <?= aman(
                                                    $fasilitas['nama_fasilitas']
                                                ); ?> -
                                                Rp<?= number_format(
                                                    (float) $fasilitas['harga'],0,',','.'
                                                ); ?> -
                                                <?= aman(
                                                    $fasilitas['status_fasilitas']
                                                ); ?>

                                            </option>

                                        <?php } ?>

                                    </select>

                                    <div class="form-text">
                                        Semua fasilitas pada tabel fasilitas
                                        dapat dipilih, termasuk yang berstatus
                                        Tidak Aktif.
                                    </div>

                                </div>

                                <div class="alert alert-warning mb-0">

                                    <div>
                                        Harga fasilitas:

                                        <strong
                                            id="preview_harga_fasilitas">
                                            -
                                        </strong>
                                    </div>

                                    <div>
                                        Formula:

                                        <strong>
                                            Harga × 0,0005
                                        </strong>
                                    </div>

                                    <div>
                                        Perkiraan jam minus:

                                        <strong id="preview_jam_fasilitas">
                                            -
                                        </strong>
                                    </div>

                                    <div>
                                        Jenis jam minus:

                                        <strong>
                                            Jam Minus Kompensasi
                                        </strong>
                                    </div>

                                </div>

                            </div>

                        </div>

                    </div>

                    <div
                        id="section_lainnya"
                        class="d-none">

                        <div class="card bg-light border mb-4">

                            <div class="card-body">

                                <h5 class="fw-bold mb-3">
                                    Data Pelanggaran Lainnya
                                </h5>

                                <div class="mb-3">

                                    <label
                                        for="deskripsi_pelanggaran"
                                        class="form-label fw-bold">
                                        Deskripsi Pelanggaran
                                        <span class="text-danger">*</span>
                                    </label>

                                    <textarea
                                        name="deskripsi_pelanggaran"
                                        id="deskripsi_pelanggaran"
                                        class="form-control"
                                        rows="4"
                                        placeholder="Jelaskan pelanggaran secara jelas..."></textarea>

                                </div>

                                <div class="mb-3">
                                    <label
                                        for="jenis_jam_lainnya"
                                        class="form-label fw-bold">
                                        Jenis Jam Minus
                                        <span class="text-danger">*</span>
                                    </label>

                                    <select
                                        name="jenis_jam_lainnya"
                                        id="jenis_jam_lainnya"
                                        class="form-select">
                                        <option value="">
                                            Pilih jenis jam minus
                                        </option>

                                        <option value="Murni">
                                            Jam Minus Murni
                                        </option>

                                        <option value="Kompensasi">
                                            Jam Minus Kompensasi
                                        </option>
                                    </select>
                                </div>

                                <div class="mb-3">
                                    <label
                                        for="jumlah_jam_minus_lainnya"
                                        class="form-label fw-bold">
                                        Jumlah Jam Minus
                                        <span class="text-danger">*</span>
                                    </label>

                                    <div class="input-group">
                                        <input
                                            type="number"
                                            name="jumlah_jam_minus_lainnya"
                                            id="jumlah_jam_minus_lainnya"
                                            class="form-control"
                                            min="0.1"
                                            max="1000.0"
                                            step="0.1"
                                            inputmode="decimal"
                                            placeholder="0.0">

                                        <span class="input-group-text">
                                            Jam
                                        </span>
                                    </div>

                                    <div class="form-text">
                                        Masukkan jumlah antara 0,1 sampai 1000,0 jam.
                                    </div>
                                </div>

                            </div>

                        </div>

                    </div>

            </div>

            <div class="d-flex gap-2">

                <button
                    type="submit"
                    name="simpan"
                    class="btn btn-primary px-4">

                    <i class="fa-solid fa-floppy-disk me-1"></i>

                    Simpan Pemberian Jam Minus

                </button>

                <a
                    href="index.php"
                    class="btn btn-secondary px-4">
                    Kembali
                </a>

            </div>

            </form>

        </div>

    </div>

    </div>

</main>

<script>
    document.addEventListener(
        'DOMContentLoaded',
        function() {

            const mahasiswa =
                document.getElementById(
                    'id_pengguna_mahasiswa'
                );

            const kategori =
                document.getElementById(
                    'kategori_pelanggaran'
                );

            const sectionAkademik =
                document.getElementById(
                    'section_akademik'
                );

            const sectionFasilitas =
                document.getElementById(
                    'section_fasilitas'
                );

            const sectionLainnya =
                document.getElementById(
                    'section_lainnya'
                );

            const mataKuliah =
                document.getElementById(
                    'id_detail_kelas_pada_mata_kuliah'
                );

            const absensi =
                document.getElementById(
                    'keterangan_absensi'
                );

            const jumlahAkademik =
                document.getElementById(
                    'jumlah_jam_minus_akademik'
                );

            const fasilitas =
                document.getElementById(
                    'id_fasilitas'
                );

            const deskripsi =
                document.getElementById(
                    'deskripsi_pelanggaran'
                );

            const jenisLainnya =
                document.getElementById(
                    'jenis_jam_lainnya'
                );

            const jumlahLainnya =
                document.getElementById(
                    'jumlah_jam_minus_lainnya'
                );

            const previewHarga =
                document.getElementById(
                    'preview_harga_fasilitas'
                );

            const previewJamFasilitas =
                document.getElementById(
                    'preview_jam_fasilitas'
                );

            function formatRupiah(nilai) {
                return new Intl.NumberFormat(
                    'id-ID', {
                        minimumFractionDigits: 0,
                        maximumFractionDigits: 0
                    }
                ).format(nilai);
            }

            function formatJam(nilai) {
                return new Intl.NumberFormat(
                    'id-ID', {
                        minimumFractionDigits: 1,
                        maximumFractionDigits: 1
                    }
                ).format(nilai);
            }

            function nonaktifkanSemuaFieldKategori() {

                /* Akademik */
                mataKuliah.disabled = true;
                mataKuliah.required = false;

                absensi.disabled = true;
                absensi.required = false;

                jumlahAkademik.disabled = true;
                jumlahAkademik.required = false;

                /* Fasilitas */
                fasilitas.disabled = true;
                fasilitas.required = false;

                /* Lainnya */
                deskripsi.disabled = true;
                deskripsi.required = false;

                jenisLainnya.disabled = true;
                jenisLainnya.required = false;

                jumlahLainnya.disabled = true;
                jumlahLainnya.required = false;
            }

            function sembunyikanSemuaSection() {

                sectionAkademik.classList.add(
                    'd-none'
                );

                sectionFasilitas.classList.add(
                    'd-none'
                );

                sectionLainnya.classList.add(
                    'd-none'
                );

                nonaktifkanSemuaFieldKategori();
            }

            async function ambilMataKuliah() {

                const idMahasiswa =
                    mahasiswa.value;

                mataKuliah.innerHTML =
                    '<option value="">' +
                    'Memuat data...' +
                    '</option>';

                if (!idMahasiswa) {

                    mataKuliah.innerHTML =
                        '<option value="">' +
                        'Pilih mahasiswa terlebih dahulu' +
                        '</option>';

                    return;
                }

                try {

                    const response = await fetch(
                        'ambil_mata_kuliah.php' +
                        '?id_pengguna_mahasiswa=' +
                        encodeURIComponent(
                            idMahasiswa
                        )
                    );

                    const result =
                        await response.json();

                    if (!response.ok) {
                        throw new Error(
                            result.message ||
                            'Gagal mengambil data.'
                        );
                    }

                    if (!result.success) {
                        throw new Error(
                            result.message ||
                            'Gagal mengambil data.'
                        );
                    }

                    mataKuliah.innerHTML =
                        '<option value="">' +
                        'Pilih Mata Kuliah' +
                        '</option>';

                    result.data.forEach(
                        function(item) {

                            const option =
                                document.createElement(
                                    'option'
                                );

                            option.value =
                                item[
                                    'id_detail_kelas_pada_mata_kuliah'
                                ];

                            option.textContent =
                                item['kode_mata_kuliah'] +
                                ' - ' +
                                item['nama_mata_kuliah'];

                            mataKuliah.appendChild(
                                option
                            );
                        }
                    );

                    if (result.data.length === 0) {

                        mataKuliah.innerHTML =
                            '<option value="">' +
                            'Tidak ada mata kuliah' +
                            '</option>';

                    }

                } catch (error) {

                    console.error(error);

                    mataKuliah.innerHTML =
                        '<option value="">' +
                        'Gagal mengambil mata kuliah' +
                        '</option>';

                }
            }

            function aturKategori() {

                sembunyikanSemuaSection();

                if (kategori.value === 'Akademik') {

                    sectionAkademik.classList.remove(
                        'd-none'
                    );

                    mataKuliah.disabled = false;
                    mataKuliah.required = true;

                    absensi.disabled = false;
                    absensi.required = true;

                    jumlahAkademik.disabled = false;
                    jumlahAkademik.required = true;

                    ambilMataKuliah();
                }

                if (kategori.value === 'Fasilitas') {

                    sectionFasilitas.classList.remove(
                        'd-none'
                    );

                    fasilitas.disabled = false;
                    fasilitas.required = true;
                }

                if (kategori.value === 'Lainnya') {

                    sectionLainnya.classList.remove(
                        'd-none'
                    );

                    deskripsi.disabled = false;
                    deskripsi.required = true;

                    jenisLainnya.disabled = false;
                    jenisLainnya.required = true;

                    jumlahLainnya.disabled = false;
                    jumlahLainnya.required = true;
                }
            }

            function previewFasilitas() {

                const option =
                    fasilitas.options[
                        fasilitas.selectedIndex
                    ];

                if (!option || !option.value) {

                    previewHarga.textContent = '-';

                    previewJamFasilitas.textContent = '-';

                    return;
                }

                const harga =
                    Number(
                        option.dataset.harga || 0
                    );

                /*
                 * Formula final:
                 * harga × 0.0005
                 */
                const jamMinus =
                    harga * 0.0005;

                previewHarga.textContent =
                    'Rp' +
                    formatRupiah(harga);

                previewJamFasilitas.textContent =
                    formatJam(jamMinus) +
                    ' Jam';
            }

            kategori.addEventListener(
                'change',
                aturKategori
            );

            mahasiswa.addEventListener(
                'change',
                function() {

                    if (
                        kategori.value ===
                        'Akademik'
                    ) {
                        ambilMataKuliah();
                    }

                }
            );

            fasilitas.addEventListener(
                'change',
                previewFasilitas
            );

            aturKategori();
        }
    );
</script>

<?php
require_once "../../includes/dashboard_footer.php";
?>