-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Waktu pembuatan: 14 Jul 2026 pada 10.19
-- Versi server: 10.4.32-MariaDB
-- Versi PHP: 8.0.30

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `db_simat`
--

DELIMITER $$
--
-- Prosedur
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `usp_daftar_bursa_jobdesc` (IN `p_id_bursa_jobdesc` INT, IN `p_id_pengguna` INT)   BEGIN
    DECLARE v_role VARCHAR(30);
    DECLARE v_id_mahasiswa INT;
    DECLARE v_penerima_jobdesc VARCHAR(50);
    DECLARE v_jumlah_diperlukan INT;
    DECLARE v_jumlah_mengambil INT;
    DECLARE v_status_jobdesc VARCHAR(20);
    DECLARE v_total_jam_minus DECIMAL(10,2);

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    IF NOT EXISTS (
        SELECT 1
        FROM pengguna
        WHERE id_pengguna = p_id_pengguna
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Data pengguna tidak ditemukan';
    END IF;

    SELECT
        role,
        id_mahasiswa
    INTO
        v_role,
        v_id_mahasiswa
    FROM pengguna
    WHERE id_pengguna = p_id_pengguna;

    IF v_role <> 'Mahasiswa' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Hanya mahasiswa yang dapat mendaftar bursa jobdesc';
    END IF;

    IF v_id_mahasiswa IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Akun mahasiswa tidak terhubung dengan data mahasiswa';
    END IF;

    IF NOT EXISTS (
        SELECT 1
        FROM bursa_jobdesc
        WHERE id_bursa_jobdesc = p_id_bursa_jobdesc
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Data bursa jobdesc tidak ditemukan';
    END IF;

    IF EXISTS (
        SELECT 1
        FROM detail_pengguna_pada_bursa_jobdesc
        WHERE id_bursa_jobdesc = p_id_bursa_jobdesc
        AND id_pengguna = p_id_pengguna
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Kamu sudah mendaftar jobdesc ini';
    END IF;

    START TRANSACTION;

    SELECT
        penerima_jobdesc,
        jumlah_mahasiswa_diperlukan,
        jumlah_mahasiswa_mengambil,
        status_jobdesc
    INTO
        v_penerima_jobdesc,
        v_jumlah_diperlukan,
        v_jumlah_mengambil,
        v_status_jobdesc
    FROM bursa_jobdesc
    WHERE id_bursa_jobdesc = p_id_bursa_jobdesc
    FOR UPDATE;

    IF v_status_jobdesc <> 'Dibuka' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Jobdesc tidak sedang dibuka';
    END IF;

    IF v_jumlah_mengambil >= v_jumlah_diperlukan THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Kuota jobdesc sudah penuh';
    END IF;

    IF v_penerima_jobdesc = 'Mahasiswa dengan Jam Minus' THEN
        SET v_total_jam_minus = ufn_total_jam_minus_mahasiswa(v_id_mahasiswa);

        IF v_total_jam_minus <= 0 THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Jobdesc ini hanya untuk mahasiswa yang masih memiliki jam minus';
        END IF;
    END IF;

    INSERT INTO detail_pengguna_pada_bursa_jobdesc (
        id_bursa_jobdesc,
        id_pengguna,
        peran_pengguna
    )
    VALUES (
        p_id_bursa_jobdesc,
        p_id_pengguna,
        'Penerima'
    );

    UPDATE bursa_jobdesc
    SET
        jumlah_mahasiswa_mengambil = jumlah_mahasiswa_mengambil + 1,
        status_jobdesc = CASE
            WHEN jumlah_mahasiswa_mengambil + 1 >= jumlah_mahasiswa_diperlukan
                THEN 'Dikerjakan'
            ELSE status_jobdesc
        END
    WHERE id_bursa_jobdesc = p_id_bursa_jobdesc;

    COMMIT;

    SELECT
        'Berhasil mendaftar bursa jobdesc' AS Pesan,
        p_id_bursa_jobdesc AS id_bursa_jobdesc;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `usp_delete_pengajar_mata_kuliah_kelas` (IN `p_id_detail_kelas_pada_mata_kuliah` INT)   BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM detail_kelas_pada_mata_kuliah
        WHERE id_detail_kelas_pada_mata_kuliah = p_id_detail_kelas_pada_mata_kuliah
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Data penentuan pengajar tidak ditemukan';
    END IF;

    DELETE FROM detail_kelas_pada_mata_kuliah
    WHERE id_detail_kelas_pada_mata_kuliah = p_id_detail_kelas_pada_mata_kuliah;

    SELECT
        'Data pengajar mata kuliah kelas berhasil dihapus' AS Pesan,
        p_id_detail_kelas_pada_mata_kuliah AS id_detail_kelas_pada_mata_kuliah;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `usp_insert_bursa_jobdesc` (IN `p_id_pengguna` INT, IN `p_deskripsi_jobdesc` TEXT, IN `p_penerima_jobdesc` VARCHAR(50), IN `p_jam_plus` DECIMAL(6,2), IN `p_tanggal_pemberian_jobdesc` DATETIME, IN `p_jumlah_mahasiswa_diperlukan` INT)   BEGIN
    DECLARE v_id_bursa_jobdesc INT;
    DECLARE v_role VARCHAR(30);

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    IF NOT EXISTS (
        SELECT 1
        FROM pengguna
        WHERE id_pengguna = p_id_pengguna
          AND status_akun = 'Aktif'
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
            'Data pengguna tidak ditemukan atau tidak aktif';
    END IF;

    SELECT role
    INTO v_role
    FROM pengguna
    WHERE id_pengguna = p_id_pengguna;

    IF v_role NOT IN (
        'Pengajar',
        'Kepala Prodi',
        'PIC Tata Tertib',
        'PIC Aset Fasilitas',
        'PIC Kemahasiswaan'
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
            'Pengguna tidak memiliki akses membuat jobdesc';
    END IF;

    IF
        p_deskripsi_jobdesc IS NULL
        OR CHAR_LENGTH(TRIM(p_deskripsi_jobdesc)) = 0
    THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
            'Deskripsi jobdesc wajib diisi';
    END IF;

    IF p_penerima_jobdesc NOT IN (
        'Semua Mahasiswa',
        'Mahasiswa dengan Jam Minus'
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
            'Sasaran mahasiswa tidak valid';
    END IF;

    IF
        p_jam_plus < 0.1
        OR p_jam_plus > 1000.0
    THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
            'Jam plus harus antara 0,1 sampai 1000,0';
    END IF;

    IF p_jam_plus <> ROUND(p_jam_plus, 1) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
            'Jam plus maksimal satu angka di belakang koma';
    END IF;

    IF p_tanggal_pemberian_jobdesc IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
            'Tanggal pemberian jobdesc wajib diisi';
    END IF;

    IF p_tanggal_pemberian_jobdesc <
       TIMESTAMP(
           CURDATE(),
           MAKETIME(
               HOUR(NOW()),
               MINUTE(NOW()),
               0
           )
       )
    THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
            'Tanggal pemberian jobdesc tidak boleh lampau';
    END IF;

    IF
        p_jumlah_mahasiswa_diperlukan IS NULL
        OR p_jumlah_mahasiswa_diperlukan < 1
    THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
            'Jumlah mahasiswa minimal 1';
    END IF;

    START TRANSACTION;

    INSERT INTO bursa_jobdesc (
        deskripsi_jobdesc,
        penerima_jobdesc,
        jam_plus,
        tanggal_pemberian_jobdesc,
        jumlah_mahasiswa_diperlukan,
        jumlah_mahasiswa_mengambil,
        status_jobdesc
    )
    VALUES (
        TRIM(p_deskripsi_jobdesc),
        p_penerima_jobdesc,
        p_jam_plus,
        p_tanggal_pemberian_jobdesc,
        p_jumlah_mahasiswa_diperlukan,
        0,
        'Dibuka'
    );

    SET v_id_bursa_jobdesc = LAST_INSERT_ID();

    INSERT INTO detail_pengguna_pada_bursa_jobdesc (
        id_bursa_jobdesc,
        id_pengguna,
        peran_pengguna
    )
    VALUES (
        v_id_bursa_jobdesc,
        p_id_pengguna,
        'Pemberi'
    );

    COMMIT;

    SELECT
        'Bursa jobdesc berhasil ditambahkan' AS pesan,
        v_id_bursa_jobdesc AS id_bursa_jobdesc;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `usp_insert_detail_fasilitas_pada_kelas` (IN `p_id_kelas` INT, IN `p_id_fasilitas` INT, IN `p_jumlah_fasilitas` INT)   BEGIN
    IF p_jumlah_fasilitas <= 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Jumlah fasilitas harus lebih dari 0';
    END IF;

    IF NOT EXISTS (
        SELECT 1
        FROM kelas
        WHERE id_kelas = p_id_kelas
        AND status_kelas = 'Aktif'
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Kelas tidak ditemukan atau tidak aktif';
    END IF;

    IF NOT EXISTS (
        SELECT 1
        FROM fasilitas
        WHERE id_fasilitas = p_id_fasilitas
        AND status_fasilitas = 'Aktif'
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Fasilitas tidak ditemukan atau tidak aktif';
    END IF;

    IF EXISTS (
        SELECT 1
        FROM detail_fasilitas_pada_kelas
        WHERE id_kelas = p_id_kelas
        AND id_fasilitas = p_id_fasilitas
        AND status_detail_fasilitas_pada_kelas IN ('Aktif', 'Rusak')
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Fasilitas ini sudah ditentukan pada kelas tersebut';
    END IF;

    INSERT INTO detail_fasilitas_pada_kelas (
        id_kelas,
        id_fasilitas,
        jumlah_fasilitas,
        status_detail_fasilitas_pada_kelas
    )
    VALUES (
        p_id_kelas,
        p_id_fasilitas,
        p_jumlah_fasilitas,
        'Aktif'
    );

    SELECT
        'Data fasilitas kelas berhasil ditambahkan' AS Pesan,
        LAST_INSERT_ID() AS id_detail_fasilitas_pada_kelas;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `usp_insert_detail_pengguna_pada_pengaduan_kerusakan_fasilitas` (IN `p_id_pengaduan_kerusakan_fasilitas` INT, IN `p_id_pengguna` INT, IN `p_peran_pengguna` VARCHAR(20))   BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        RESIGNAL;
    END;
    
    INSERT INTO detail_pengguna_pada_pengaduan_kerusakan_fasilitas (
        id_pengaduan_kerusakan_fasilitas,
        id_pengguna,
        peran_pengguna
    )
    VALUES (
        p_id_pengaduan_kerusakan_fasilitas,
        p_id_pengguna,
        p_peran_pengguna
    );
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `usp_insert_fasilitas` (IN `p_nama_fasilitas` VARCHAR(50), IN `p_harga` DECIMAL(15,2))   BEGIN
    IF p_nama_fasilitas IS NULL OR TRIM(p_nama_fasilitas) = '' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Nama fasilitas wajib diisi';
    END IF;

    IF p_harga < 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Harga fasilitas tidak boleh kurang dari 0';
    END IF;

    INSERT INTO fasilitas (
        nama_fasilitas,
        harga,
        status_fasilitas,
        tanggal_pendataan
    )
    VALUES (
        p_nama_fasilitas,
        p_harga,
        'Aktif',
        NOW()
    );

    SELECT
        'Data fasilitas berhasil ditambahkan' AS Pesan,
        LAST_INSERT_ID() AS id_fasilitas_baru;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `usp_insert_kegiatan` (IN `p_nama_kegiatan` VARCHAR(50), IN `p_penyelenggara` VARCHAR(20), IN `p_tanggal_kegiatan` DATE)   BEGIN
    IF p_nama_kegiatan IS NULL OR TRIM(p_nama_kegiatan) = '' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Nama kegiatan wajib diisi';
    END IF;

    IF p_penyelenggara NOT IN ('ASTRAtech','BEM','MPM','HIMMA','UKM') THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Penyelenggara tidak valid';
    END IF;

    INSERT INTO kegiatan (
        nama_kegiatan,
        penyelenggara,
        tanggal_kegiatan,
        status_kegiatan
    )
    VALUES (
        p_nama_kegiatan,
        p_penyelenggara,
        p_tanggal_kegiatan,
        'Aktif'
    );

    SELECT
        'Data kegiatan berhasil ditambahkan' AS Pesan,
        LAST_INSERT_ID() AS id_kegiatan_baru;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `usp_insert_kelas` (IN `p_nama_kelas` VARCHAR(5), IN `p_tingkat` VARCHAR(1))   BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        RESIGNAL;
    END;

    INSERT INTO kelas (
        nama_kelas,
        tingkat
    )
    VALUES (
        p_nama_kelas,
        p_tingkat
    );

    SELECT 
        'Data kelas berhasil ditambahkan' AS Pesan,
        LAST_INSERT_ID() AS id_kelas_baru;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `usp_insert_mahasiswa` (IN `p_id_kelas` INT, IN `p_id_periode_akademik` INT, IN `p_nim` VARCHAR(20), IN `p_nama_mahasiswa` VARCHAR(50), IN `p_email` VARCHAR(50), IN `p_no_hp` VARCHAR(20))   BEGIN
    DECLARE v_id_mahasiswa_baru INT;
    
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
    	ROLLBACK;
        RESIGNAL;
    END;
    
    START TRANSACTION;

    INSERT INTO mahasiswa (
        id_kelas,
        id_periode_akademik,
        nim,
        nama_mahasiswa,
        email,
        no_hp
    )
    VALUES (
        p_id_kelas,
        p_id_periode_akademik,
        p_nim,
        p_nama_mahasiswa,
        p_email,
        p_no_hp
    );
    
    SET v_id_mahasiswa_baru = LAST_INSERT_ID();
    
    UPDATE kelas AS a
    SET jumlah_mahasiswa = jumlah_mahasiswa + 1
    WHERE id_kelas = p_id_kelas;
    
    COMMIT;

    SELECT 
        'Data mahasiswa berhasil ditambahkan' AS Pesan,
        v_id_mahasiswa_baru AS id_mahasiswa_baru;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `usp_insert_pemberian_jam_minus` (IN `p_id_pemberi` INT, IN `p_id_penerima` INT, IN `p_kategori_pelanggaran` VARCHAR(20), IN `p_id_detail_kelas_pada_mata_kuliah` INT, IN `p_keterangan_absensi` VARCHAR(10), IN `p_id_fasilitas` INT, IN `p_deskripsi_pelanggaran` TEXT, IN `p_jenis_jam_input` VARCHAR(20), IN `p_jumlah_jam_minus_input` DECIMAL(10,2))   BEGIN
    DECLARE v_id_mahasiswa INT;
    DECLARE v_id_kelas_mahasiswa INT;

    DECLARE v_id_detail_mk_final INT DEFAULT NULL;
    DECLARE v_keterangan_absensi_final VARCHAR(10) DEFAULT NULL;
    DECLARE v_id_fasilitas_final INT DEFAULT NULL;

    DECLARE v_harga_fasilitas DECIMAL(15,2) DEFAULT NULL;
    DECLARE v_hasil_perhitungan_fasilitas DECIMAL(20,6) DEFAULT NULL;

    DECLARE v_jumlah_jam_minus DECIMAL(10,1) DEFAULT 0.0;
    DECLARE v_jenis_jam VARCHAR(20);
    DECLARE v_nama_pelanggaran VARCHAR(100);
    DECLARE v_deskripsi_final TEXT DEFAULT NULL;

    DECLARE v_id_pemberian_jam_minus INT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    /*
    | Validasi PIC Tata Tertib
    */

    IF NOT EXISTS (
        SELECT 1
        FROM pengguna
        WHERE id_pengguna = p_id_pemberi
          AND role = 'PIC Tata Tertib'
          AND status_akun = 'Aktif'
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
            'Pemberi tidak valid atau bukan PIC Tata Tertib';
    END IF;

    /*
    | Validasi mahasiswa penerima
    */

    IF NOT EXISTS (
        SELECT 1
        FROM pengguna AS u
        JOIN mahasiswa AS m
            ON u.id_mahasiswa = m.id_mahasiswa
        WHERE u.id_pengguna = p_id_penerima
          AND u.role = 'Mahasiswa'
          AND u.status_akun = 'Aktif'
          AND m.status_mahasiswa = 'Aktif'
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
            'Mahasiswa penerima tidak ditemukan atau tidak aktif';
    END IF;

    /*
    | Validasi kategori
    */

    IF p_kategori_pelanggaran IS NULL
       OR p_kategori_pelanggaran NOT IN (
            'Akademik',
            'Fasilitas',
            'Lainnya'
       )
    THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
            'Kategori pemberian jam minus tidak valid';
    END IF;

    START TRANSACTION;

    /*
    | Ambil data mahasiswa
    */

    SELECT
        u.id_mahasiswa,
        m.id_kelas
    INTO
        v_id_mahasiswa,
        v_id_kelas_mahasiswa
    FROM pengguna AS u
    JOIN mahasiswa AS m
        ON u.id_mahasiswa = m.id_mahasiswa
    WHERE u.id_pengguna = p_id_penerima
    FOR UPDATE;

    /*
    | Kategori Akademik
    */

    IF p_kategori_pelanggaran = 'Akademik' THEN

        IF p_id_detail_kelas_pada_mata_kuliah IS NULL
           OR p_id_detail_kelas_pada_mata_kuliah <= 0
        THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT =
                'Mata kuliah wajib dipilih untuk kategori Akademik';
        END IF;

        IF p_keterangan_absensi IS NULL
           OR p_keterangan_absensi NOT IN (
                'Izin',
                'Sakit',
                'Alpa'
           )
        THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT =
                'Keterangan absensi tidak valid';
        END IF;

        IF p_jumlah_jam_minus_input IS NULL
           OR p_jumlah_jam_minus_input < 0.1
           OR p_jumlah_jam_minus_input > 1000.0
        THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT =
                'Jumlah jam minus Akademik harus antara 0,1 sampai 1000,0';
        END IF;

        IF p_jumlah_jam_minus_input <>
           ROUND(p_jumlah_jam_minus_input, 1)
        THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT =
                'Jumlah jam minus Akademik maksimal satu angka di belakang koma';
        END IF;

        IF NOT EXISTS (
            SELECT 1
            FROM detail_kelas_pada_mata_kuliah AS dkmk
            JOIN mata_kuliah AS mk
                ON dkmk.id_mata_kuliah = mk.id_matakuliah
            WHERE
                dkmk.id_detail_kelas_pada_mata_kuliah =
                    p_id_detail_kelas_pada_mata_kuliah
                AND dkmk.id_kelas = v_id_kelas_mahasiswa
                AND mk.status_mata_kuliah = 'Aktif'
        ) THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT =
                'Mata kuliah tidak dimiliki oleh kelas mahasiswa tersebut';
        END IF;

        SET v_id_detail_mk_final =
            p_id_detail_kelas_pada_mata_kuliah;

        SET v_keterangan_absensi_final =
            p_keterangan_absensi;

        SET v_jumlah_jam_minus =
            ROUND(p_jumlah_jam_minus_input, 1);

        SET v_jenis_jam = 'Murni';
        SET v_nama_pelanggaran = 'Pelanggaran Akademik';
        SET v_deskripsi_final = NULL;

    /*
    | Kategori Fasilitas
    */

    ELSEIF p_kategori_pelanggaran = 'Fasilitas' THEN

        IF p_id_fasilitas IS NULL
           OR p_id_fasilitas <= 0
        THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT =
                'Fasilitas wajib dipilih';
        END IF;

        IF NOT EXISTS (
            SELECT 1
            FROM fasilitas
            WHERE id_fasilitas = p_id_fasilitas
        ) THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT =
                'Fasilitas tidak ditemukan';
        END IF;

        SELECT harga
        INTO v_harga_fasilitas
        FROM fasilitas
        WHERE id_fasilitas = p_id_fasilitas
        LIMIT 1;

        IF v_harga_fasilitas IS NULL
           OR v_harga_fasilitas <= 0
        THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT =
                'Harga fasilitas harus lebih dari 0';
        END IF;

        /*
        | Rumus sementara:
        | harga fasilitas × 0,0005
        */

        SET v_hasil_perhitungan_fasilitas =
            v_harga_fasilitas * 0.0005;

        SET v_jumlah_jam_minus =
            ROUND(v_hasil_perhitungan_fasilitas, 1);

        IF v_jumlah_jam_minus < 0.1 THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT =
                'Hasil perhitungan jam minus harus lebih dari 0';
        END IF;

        SET v_id_fasilitas_final = p_id_fasilitas;
        SET v_jenis_jam = 'Kompensasi';
        SET v_nama_pelanggaran = 'Kerusakan Fasilitas';
        SET v_deskripsi_final = NULL;

    /*
    | Kategori Lainnya
    */

    ELSEIF p_kategori_pelanggaran = 'Lainnya' THEN

        IF TRIM(
            COALESCE(
                p_deskripsi_pelanggaran,
                ''
            )
        ) = ''
        THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT =
                'Deskripsi pelanggaran wajib diisi';
        END IF;

        IF p_jenis_jam_input IS NULL
           OR p_jenis_jam_input NOT IN (
                'Murni',
                'Kompensasi'
           )
        THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT =
                'Jenis jam minus tidak valid';
        END IF;

        IF p_jumlah_jam_minus_input IS NULL
           OR p_jumlah_jam_minus_input < 0.1
           OR p_jumlah_jam_minus_input > 1000.0
        THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT =
                'Jumlah jam minus harus antara 0,1 sampai 1000,0';
        END IF;

        IF p_jumlah_jam_minus_input <>
           ROUND(p_jumlah_jam_minus_input, 1)
        THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT =
                'Jumlah jam minus maksimal satu angka di belakang koma';
        END IF;

        SET v_nama_pelanggaran =
            'Pelanggaran Lainnya';

        SET v_deskripsi_final =
            TRIM(p_deskripsi_pelanggaran);

        SET v_jenis_jam =
            p_jenis_jam_input;

        SET v_jumlah_jam_minus =
            ROUND(p_jumlah_jam_minus_input, 1);

    END IF;

    /*
    | Simpan transaksi
    */

    INSERT INTO pemberian_jam_minus (
        kategori_pelanggaran,
        id_detail_kelas_pada_mata_kuliah,
        keterangan_absensi,
        id_fasilitas,
        harga_fasilitas_saat_pemberian,
        nama_pelanggaran,
        deskripsi_pelanggaran,
        jumlah_jam_minus,
        jenis_jam,
        tanggal_pemberian
    )
    VALUES (
        p_kategori_pelanggaran,
        v_id_detail_mk_final,
        v_keterangan_absensi_final,
        v_id_fasilitas_final,
        v_harga_fasilitas,
        v_nama_pelanggaran,
        v_deskripsi_final,
        v_jumlah_jam_minus,
        v_jenis_jam,
        NOW()
    );

    SET v_id_pemberian_jam_minus =
        LAST_INSERT_ID();

    /*
    | Simpan PIC sebagai pemberi
    */

    INSERT INTO detail_pengguna_pada_pemberian_jam_minus (
        id_pemberian_jam_minus,
        id_pengguna,
        peran_pengguna
    )
    VALUES (
        v_id_pemberian_jam_minus,
        p_id_pemberi,
        'Pemberi'
    );

    /*
    | Simpan mahasiswa sebagai penerima
    */

    INSERT INTO detail_pengguna_pada_pemberian_jam_minus (
        id_pemberian_jam_minus,
        id_pengguna,
        peran_pengguna
    )
    VALUES (
        v_id_pemberian_jam_minus,
        p_id_penerima,
        'Penerima'
    );

    /*
    | Tambahkan saldo jam minus
    */

    IF v_jenis_jam = 'Murni' THEN

        UPDATE mahasiswa
        SET saldo_jam_minus_murni =
            COALESCE(saldo_jam_minus_murni, 0.0)
            + v_jumlah_jam_minus
        WHERE id_mahasiswa = v_id_mahasiswa;

    ELSEIF v_jenis_jam = 'Kompensasi' THEN

        UPDATE mahasiswa
        SET saldo_jam_minus_kompensasi =
            COALESCE(saldo_jam_minus_kompensasi, 0.0)
            + v_jumlah_jam_minus
        WHERE id_mahasiswa = v_id_mahasiswa;

    END IF;

    COMMIT;

    SELECT
        'Pemberian jam minus berhasil disimpan' AS pesan,
        v_id_pemberian_jam_minus AS id_pemberian_jam_minus,
        v_jumlah_jam_minus AS jumlah_jam_minus,
        v_jenis_jam AS jenis_jam;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `usp_insert_pengaduan_kerusakan_fasilitas` (IN `p_id_fasilitas` INT, IN `p_id_pengguna` INT, IN `p_deskripsi_kerusakan` TEXT, IN `p_bukti_kerusakan_url` VARCHAR(2048), IN `p_pelaku_kerusakan` VARCHAR(50))   BEGIN
	DECLARE v_id_pengaduan_kerusakan_fasilitas INT;
    
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
    	ROLLBACK;
        RESIGNAL;
    END;
    
    START TRANSACTION;

    INSERT INTO pengaduan_kerusakan_fasilitas (
        id_fasilitas,
        deskripsi_kerusakan,
        tanggal_pengaduan,
        bukti_kerusakan_url,
        pelaku_kerusakan
    )
    VALUES (
        p_id_fasilitas,
        p_deskripsi_kerusakan,
        NOW(),
        p_bukti_kerusakan_url,
        p_pelaku_kerusakan
    );
    
    SET v_id_pengaduan_kerusakan_fasilitas = LAST_INSERT_ID();

    CALL usp_insert_detail_pengguna_pada_pengaduan_kerusakan_fasilitas(
    	v_id_pengaduan_kerusakan_fasilitas,
        p_id_pengguna,
        'Pelapor'
    );

    COMMIT;

    SELECT 
        'Data pengaduan kerusakan fasilitas berhasil ditambahkan' AS Pesan,
        v_id_pengaduan_kerusakan_fasilitas AS id_pengaduan_kerusakan_fasilitas_baru;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `usp_insert_pengajar` (IN `p_nip` VARCHAR(20), IN `p_nama_pengajar` VARCHAR(50), IN `p_email` VARCHAR(50), IN `p_no_hp` VARCHAR(20))   BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        RESIGNAL;
    END;

    INSERT INTO pengajar (
        nip,
        nama_pengajar,
        email,
        no_hp
    )
    VALUES (
        p_nip,
        p_nama_pengajar,
        p_email,
        p_no_hp
    );

    SELECT 
        'Data pengajar berhasil ditambahkan' AS Pesan,
        LAST_INSERT_ID() AS id_pengajar_baru;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `usp_insert_pengajar_mata_kuliah_kelas` (IN `p_id_kelas` INT, IN `p_id_mata_kuliah` INT, IN `p_id_pengajar_1` INT, IN `p_id_pengajar_2` INT)   BEGIN
    DECLARE v_id_detail INT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    IF p_id_pengajar_1 = p_id_pengajar_2 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Pengajar 1 dan Pengajar 2 tidak boleh sama';
    END IF;

    IF NOT EXISTS (
        SELECT 1 FROM kelas
        WHERE id_kelas = p_id_kelas
        AND status_kelas = 'Aktif'
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Kelas tidak ditemukan atau tidak aktif';
    END IF;

    IF NOT EXISTS (
        SELECT 1 FROM mata_kuliah
        WHERE id_matakuliah = p_id_mata_kuliah
        AND status_mata_kuliah = 'Aktif'
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Mata kuliah tidak ditemukan atau tidak aktif';
    END IF;

    IF NOT EXISTS (
        SELECT 1 FROM pengajar
        WHERE id_pengajar = p_id_pengajar_1
        AND status_pengajar = 'Aktif'
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Pengajar 1 tidak ditemukan atau tidak aktif';
    END IF;

    IF NOT EXISTS (
        SELECT 1 FROM pengajar
        WHERE id_pengajar = p_id_pengajar_2
        AND status_pengajar = 'Aktif'
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Pengajar 2 tidak ditemukan atau tidak aktif';
    END IF;

    IF EXISTS (
        SELECT 1
        FROM detail_kelas_pada_mata_kuliah
        WHERE id_kelas = p_id_kelas
        AND id_mata_kuliah = p_id_mata_kuliah
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Mata kuliah ini sudah ditentukan pada kelas tersebut';
    END IF;

    START TRANSACTION;

    INSERT INTO detail_kelas_pada_mata_kuliah
    (
        id_mata_kuliah,
        id_kelas
    )
    VALUES
    (
        p_id_mata_kuliah,
        p_id_kelas
    );

    SET v_id_detail = LAST_INSERT_ID();

    INSERT INTO detail_pengajar_pada_mata_kuliah
    (
        id_detail_kelas_pada_mata_kuliah,
        id_pengajar,
        kedudukan_pengajar
    )
    VALUES
    (
        v_id_detail,
        p_id_pengajar_1,
        'Pengajar1'
    ),
    (
        v_id_detail,
        p_id_pengajar_2,
        'Pengajar2'
    );

    COMMIT;

    SELECT
        'Data pengajar mata kuliah kelas berhasil ditambahkan' AS Pesan,
        v_id_detail AS id_detail_kelas_pada_mata_kuliah;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `usp_insert_pengajuan_jam_plus` (IN `p_id_pengguna` INT, IN `p_id_kegiatan` INT, IN `p_jumlah_jam` DECIMAL(6,2), IN `p_jenis_jam` VARCHAR(20), IN `p_sumber_jam` VARCHAR(10), IN `p_deskripsi` TEXT, IN `p_nama_pemberi` VARCHAR(50), IN `p_dokumen_url` VARCHAR(2048))   BEGIN
    DECLARE v_id_pengajuan INT;
    DECLARE v_id_kegiatan_final INT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    IF p_jumlah_jam <= 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Jumlah jam plus harus lebih dari 0';
    END IF;

    IF p_jenis_jam NOT IN ('Murni', 'Kompensasi') THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Jenis jam tidak valid';
    END IF;

    IF p_sumber_jam NOT IN ('Prodi', 'Luar') THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Sumber jam tidak valid';
    END IF;

    IF NOT EXISTS (
        SELECT 1
        FROM pengguna
        WHERE id_pengguna = p_id_pengguna
        AND role = 'Mahasiswa'
        AND status_akun = 'Aktif'
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Pengguna mahasiswa tidak valid atau tidak aktif';
    END IF;

    IF p_sumber_jam = 'Prodi' THEN
        SET v_id_kegiatan_final = NULL;
    ELSEIF p_sumber_jam = 'Luar' THEN
        IF p_id_kegiatan IS NULL OR p_id_kegiatan <= 0 THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Kegiatan wajib dipilih jika sumber jam berasal dari luar';
        END IF;

        IF NOT EXISTS (
            SELECT 1
            FROM kegiatan
            WHERE id_kegiatan = p_id_kegiatan
            AND status_kegiatan = 'Aktif'
        ) THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Kegiatan tidak ditemukan atau tidak aktif';
        END IF;

        SET v_id_kegiatan_final = p_id_kegiatan;
    END IF;

    START TRANSACTION;

    INSERT INTO pengajuan_jam_plus (
        id_kegiatan,
        jumlah_jam_plus,
        jenis_jam,
        sumber_jam,
        tanggal_pengajuan,
        deskripsi_pekerjaan,
        nama_pemberi,
        dokumen_url,
        status_pengajuan
    ) VALUES (
        v_id_kegiatan_final,
        p_jumlah_jam,
        p_jenis_jam,
        p_sumber_jam,
        NOW(),
        p_deskripsi,
        p_nama_pemberi,
        p_dokumen_url,
        'Menunggu Verifikasi'
    );

    SET v_id_pengajuan = LAST_INSERT_ID();

    INSERT INTO detail_pengguna_pada_pengajuan_jam_plus (
        id_pengajuan_jam_plus,
        id_pengguna,
        peran_pengguna
    ) VALUES (
        v_id_pengajuan,
        p_id_pengguna,
        'Pengaju'
    );

    COMMIT;

    SELECT
        'Pengajuan jam plus berhasil dikirim' AS Pesan,
        v_id_pengajuan AS id_pengajuan_jam_plus;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `usp_insert_pengguna` (IN `p_id_mahasiswa` INT, IN `p_id_pengajar` INT, IN `p_username` VARCHAR(50), IN `p_password` VARCHAR(255), IN `p_role` VARCHAR(30))   BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        RESIGNAL;
    END;

    IF p_role = 'Mahasiswa' THEN
        IF p_id_mahasiswa IS NULL THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Role Mahasiswa wajib memiliki id_mahasiswa';
        END IF;

        IF p_id_pengajar IS NOT NULL THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Role Mahasiswa tidak boleh memiliki id_pengajar';
        END IF;
    ELSE
        IF p_id_pengajar IS NULL THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Role selain Mahasiswa wajib memiliki id_pengajar';
        END IF;

        IF p_id_mahasiswa IS NOT NULL THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Role selain Mahasiswa tidak boleh memiliki id_mahasiswa';
        END IF;
    END IF;

    INSERT INTO pengguna (
        id_mahasiswa,
        id_pengajar,
        username,
        password,
        role
    )
    VALUES (
        p_id_mahasiswa,
        p_id_pengajar,
        p_username,
        p_password,
        p_role
    );

    SELECT 
        'Data pengguna berhasil ditambahkan' AS Pesan,
        LAST_INSERT_ID() AS id_pengguna_baru;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `usp_insert_periode_akademik` (IN `p_tahun_akademik` VARCHAR(10), IN `p_semester` VARCHAR(10), IN `p_tanggal_mulai` DATETIME, IN `p_tanggal_selesai` DATETIME, IN `p_status_periode` VARCHAR(20))   BEGIN
    DECLARE v_id_periode_akademik INT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    IF p_tahun_akademik IS NULL OR TRIM(p_tahun_akademik) = '' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Tahun akademik wajib diisi';
    END IF;

    IF p_semester NOT IN ('Ganjil', 'Genap') THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Semester tidak valid';
    END IF;

    IF p_status_periode NOT IN ('Aktif', 'Tidak Aktif') THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Status periode tidak valid';
    END IF;

    IF p_tanggal_mulai > p_tanggal_selesai THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Tanggal mulai tidak boleh lebih besar dari tanggal selesai';
    END IF;

    START TRANSACTION;

    IF p_status_periode = 'Aktif' THEN
        UPDATE periode_akademik
        SET status_periode = 'Tidak Aktif'
        WHERE status_periode = 'Aktif';
    END IF;

    INSERT INTO periode_akademik (
        tahun_akademik,
        semester,
        tanggal_mulai,
        tanggal_selesai,
        status_periode
    )
    VALUES (
        p_tahun_akademik,
        p_semester,
        p_tanggal_mulai,
        p_tanggal_selesai,
        p_status_periode
    );

    SET v_id_periode_akademik = LAST_INSERT_ID();

    COMMIT;

    SELECT
        'Data periode akademik berhasil ditambahkan' AS Pesan,
        v_id_periode_akademik AS id_periode_akademik_baru;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `usp_pulihkan_fasilitas_kelas` (IN `p_id_detail_fasilitas_pada_kelas` INT)   BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM detail_fasilitas_pada_kelas
        WHERE id_detail_fasilitas_pada_kelas = p_id_detail_fasilitas_pada_kelas
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Data fasilitas kelas tidak ditemukan';
    END IF;

    IF NOT EXISTS (
        SELECT 1
        FROM detail_fasilitas_pada_kelas
        WHERE id_detail_fasilitas_pada_kelas = p_id_detail_fasilitas_pada_kelas
        AND status_detail_fasilitas_pada_kelas = 'Rusak'
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Fasilitas hanya bisa dipulihkan jika statusnya Rusak';
    END IF;

    UPDATE detail_fasilitas_pada_kelas
    SET status_detail_fasilitas_pada_kelas = 'Aktif'
    WHERE id_detail_fasilitas_pada_kelas = p_id_detail_fasilitas_pada_kelas;

    SELECT
        'Status fasilitas kelas berhasil dipulihkan menjadi Aktif' AS Pesan,
        p_id_detail_fasilitas_pada_kelas AS id_detail_fasilitas_pada_kelas;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `usp_select_bursa_jobdesc` ()   BEGIN
    SELECT
        bj.id_bursa_jobdesc,
        bj.deskripsi_jobdesc,
        bj.penerima_jobdesc,
        bj.jam_plus,
        bj.tanggal_pemberian_jobdesc,
        bj.jumlah_mahasiswa_diperlukan,
        bj.jumlah_mahasiswa_mengambil,
        bj.bukti_selesai_url,
        bj.status_jobdesc,

        dp_pemberi.id_pengguna AS id_pemberi,
        p_pemberi.username AS username_pemberi,
        COALESCE(pg_pemberi.nama_pengajar, m_pemberi.nama_mahasiswa, p_pemberi.username) AS nama_pemberi,

        data_penerima.nama_penerima

    FROM bursa_jobdesc AS bj

    LEFT JOIN detail_pengguna_pada_bursa_jobdesc AS dp_pemberi
        ON bj.id_bursa_jobdesc = dp_pemberi.id_bursa_jobdesc
        AND dp_pemberi.peran_pengguna = 'Pemberi'

    LEFT JOIN pengguna AS p_pemberi
        ON dp_pemberi.id_pengguna = p_pemberi.id_pengguna

    LEFT JOIN pengajar AS pg_pemberi
        ON p_pemberi.id_pengajar = pg_pemberi.id_pengajar

    LEFT JOIN mahasiswa AS m_pemberi
        ON p_pemberi.id_mahasiswa = m_pemberi.id_mahasiswa

    LEFT JOIN (
        SELECT
            dp.id_bursa_jobdesc,
            GROUP_CONCAT(
                COALESCE(m.nama_mahasiswa, p.username)
                SEPARATOR ', '
            ) AS nama_penerima
        FROM detail_pengguna_pada_bursa_jobdesc dp
        JOIN pengguna p
            ON dp.id_pengguna = p.id_pengguna
        LEFT JOIN mahasiswa m
            ON p.id_mahasiswa = m.id_mahasiswa
        WHERE dp.peran_pengguna = 'Penerima'
        GROUP BY dp.id_bursa_jobdesc
    ) AS data_penerima
        ON bj.id_bursa_jobdesc = data_penerima.id_bursa_jobdesc

    ORDER BY bj.id_bursa_jobdesc DESC;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `usp_select_fasilitas` ()   BEGIN
    SELECT
        id_fasilitas,
        nama_fasilitas,
        harga,
        status_fasilitas,
        tanggal_pendataan
    FROM fasilitas
    ORDER BY id_fasilitas ASC;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `usp_select_fasilitas_aktif` ()   BEGIN
    SELECT
        id_fasilitas,
        nama_fasilitas,
        harga
    FROM fasilitas
    WHERE status_fasilitas = 'Aktif'
    ORDER BY nama_fasilitas ASC;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `usp_select_fasilitas_by_id` (IN `p_id_fasilitas` INT)   BEGIN
    SELECT
        id_fasilitas,
        nama_fasilitas,
        harga,
        status_fasilitas,
        tanggal_pendataan
    FROM fasilitas
    WHERE id_fasilitas = p_id_fasilitas
    LIMIT 1;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `usp_select_fasilitas_kelas` ()   BEGIN
    SELECT
        dfpk.id_detail_fasilitas_pada_kelas,
        dfpk.id_kelas,
        k.nama_kelas,
        k.tingkat,

        dfpk.id_fasilitas,
        f.nama_fasilitas,
        f.harga,

        dfpk.jumlah_fasilitas,
        dfpk.status_detail_fasilitas_pada_kelas
    FROM detail_fasilitas_pada_kelas dfpk
    JOIN kelas k
        ON dfpk.id_kelas = k.id_kelas
    JOIN fasilitas f
        ON dfpk.id_fasilitas = f.id_fasilitas
    WHERE k.status_kelas = 'Aktif'
    AND f.status_fasilitas = 'Aktif'
    AND dfpk.status_detail_fasilitas_pada_kelas IN ('Aktif', 'Rusak')
    ORDER BY k.nama_kelas ASC, f.nama_fasilitas ASC;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `usp_select_fasilitas_kelas_by_id` (IN `p_id_detail_fasilitas_pada_kelas` INT)   BEGIN
    SELECT
        dfpk.id_detail_fasilitas_pada_kelas,
        dfpk.id_kelas,
        k.nama_kelas,
        k.tingkat,

        dfpk.id_fasilitas,
        f.nama_fasilitas,

        dfpk.jumlah_fasilitas,
        dfpk.status_detail_fasilitas_pada_kelas
    FROM detail_fasilitas_pada_kelas dfpk
    JOIN kelas k
        ON dfpk.id_kelas = k.id_kelas
    JOIN fasilitas f
        ON dfpk.id_fasilitas = f.id_fasilitas
    WHERE dfpk.id_detail_fasilitas_pada_kelas = p_id_detail_fasilitas_pada_kelas
    AND k.status_kelas = 'Aktif'
    AND f.status_fasilitas = 'Aktif'
    AND dfpk.status_detail_fasilitas_pada_kelas IN ('Aktif', 'Rusak')
    LIMIT 1;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `usp_select_kegiatan` ()   BEGIN
    SELECT
        id_kegiatan,
        nama_kegiatan,
        penyelenggara,
        tanggal_kegiatan,
        status_kegiatan
    FROM kegiatan
    ORDER BY id_kegiatan ASC;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `usp_select_kegiatan_aktif` ()   BEGIN
    SELECT
        id_kegiatan,
        nama_kegiatan,
        penyelenggara,
        tanggal_kegiatan,
        status_kegiatan
    FROM kegiatan
    WHERE status_kegiatan = 'Aktif'
    ORDER BY nama_kegiatan ASC;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `usp_select_kegiatan_by_id` (IN `p_id_kegiatan` INT)   BEGIN
    SELECT
        id_kegiatan,
        nama_kegiatan,
        penyelenggara,
        tanggal_kegiatan,
        status_kegiatan
    FROM kegiatan
    WHERE id_kegiatan = p_id_kegiatan
    LIMIT 1;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `usp_select_kelas` ()   BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        RESIGNAL;
    END;

    SELECT
        id_kelas,
        nama_kelas,
        tingkat,
        jumlah_mahasiswa,
        status_kelas
    FROM kelas
    ORDER BY id_kelas ASC;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `usp_select_kelas_aktif` ()   BEGIN
    SELECT
        id_kelas,
        nama_kelas,
        tingkat,
        jumlah_mahasiswa,
        status_kelas
    FROM kelas
    WHERE status_kelas = 'Aktif'
    ORDER BY tingkat ASC, nama_kelas ASC;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `usp_select_laporan_bursa_jobdesc_by_role` (IN `p_role` VARCHAR(30))   BEGIN
    IF p_role IS NULL OR p_role = '' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Role tidak boleh kosong';
    END IF;

    IF p_role = 'Mahasiswa' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Mahasiswa tidak memiliki akses laporan bursa jobdesc';
    END IF;

    IF p_role NOT IN (
        'Pengajar',
        'PIC Tata Tertib',
        'PIC Aset Fasilitas',
        'PIC Kemahasiswaan',
        'Kepala Prodi'
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Role tidak valid untuk laporan bursa jobdesc';
    END IF;

    SET SESSION group_concat_max_len = 100000;

    SELECT
        id_bursa_jobdesc,
        deskripsi_jobdesc,
        nama_penerima_jobdesc AS penerima_jobdesc,
        target_penerima_jobdesc,
        jam_plus,
        tanggal_pemberian_jobdesc,
        kuota,
        terisi,
        kuota_terisi,
        status_jobdesc,
        nama_pemberi,
        username_pemberi,
        role_pemberi
    FROM vw_laporan_bursa_jobdesc
    WHERE role_pemberi = p_role
    ORDER BY tanggal_pemberian_jobdesc DESC, id_bursa_jobdesc DESC;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `usp_select_laporan_pengaduan_fasilitas` ()   BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        RESIGNAL;
    END;

    SELECT
        id_pengaduan_kerusakan_fasilitas,
        nim,
        nama_mahasiswa,
        nama_kelas,
        nama_fasilitas,
        deskripsi_kerusakan,
        tanggal_pengaduan
    FROM vw_laporan_pengaduan_fasilitas
    ORDER BY nim ASC, tanggal_pengaduan DESC;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `usp_select_mahasiswa` ()   BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        RESIGNAL;
    END;

    SELECT
        m.id_mahasiswa,
        m.id_kelas,
        k.nama_kelas,
        k.tingkat,
        m.id_periode_akademik,
        pa.tahun_akademik,
        pa.semester,
        m.nim,
        m.nama_mahasiswa,
        m.email,
        m.no_hp,
        m.saldo_jam_minus_murni,
        m.saldo_jam_minus_kompensasi,
        m.saldo_jam_plus_murni,
        m.saldo_jam_plus_kompensasi,
        m.status_mahasiswa
    FROM mahasiswa AS m
    JOIN kelas AS k ON m.id_kelas = k.id_kelas
    JOIN periode_akademik AS pa ON m.id_periode_akademik = pa.id_periode_akademik
    ORDER BY m.id_mahasiswa ASC;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `usp_select_mahasiswa_aktif_untuk_jam_minus` ()   BEGIN
    SELECT
        u.id_pengguna AS id_pengguna_mahasiswa,

        m.id_mahasiswa,
        m.id_kelas,
        m.nim,
        m.nama_mahasiswa,

        k.nama_kelas,
        k.tingkat,

        m.saldo_jam_minus_murni,
        m.saldo_jam_minus_kompensasi,
        m.saldo_jam_plus_murni,
        m.saldo_jam_plus_kompensasi

    FROM pengguna AS u

    JOIN mahasiswa AS m
        ON u.id_mahasiswa = m.id_mahasiswa

    JOIN kelas AS k
        ON m.id_kelas = k.id_kelas

    WHERE u.role = 'Mahasiswa'

      AND u.status_akun = 'Aktif'

      AND m.status_mahasiswa = 'Aktif'

    ORDER BY
        m.nama_mahasiswa ASC,
        m.nim ASC;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `usp_select_mata_kuliah_aktif` ()   BEGIN
    SELECT
        id_matakuliah AS id_mata_kuliah,
        nama_mata_kuliah,
        kode_mata_kuliah,
        sks,
        semester,
        status_mata_kuliah
    FROM mata_kuliah
    WHERE status_mata_kuliah = 'Aktif'
    ORDER BY semester ASC, nama_mata_kuliah ASC;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `usp_select_mata_kuliah_mahasiswa` (IN `p_id_pengguna` INT)   BEGIN
    DECLARE v_id_mahasiswa INT;
    DECLARE v_id_kelas INT;

    IF NOT EXISTS (
        SELECT 1
        FROM pengguna
        WHERE id_pengguna = p_id_pengguna
        AND role = 'Mahasiswa'
        AND status_akun = 'Aktif'
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Akun mahasiswa tidak ditemukan atau tidak aktif';
    END IF;

    SELECT id_mahasiswa
    INTO v_id_mahasiswa
    FROM pengguna
    WHERE id_pengguna = p_id_pengguna;

    IF v_id_mahasiswa IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Akun ini tidak terhubung dengan data mahasiswa';
    END IF;

    IF NOT EXISTS (
        SELECT 1
        FROM mahasiswa
        WHERE id_mahasiswa = v_id_mahasiswa
        AND status_mahasiswa = 'Aktif'
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Data mahasiswa tidak ditemukan atau tidak aktif';
    END IF;

    SELECT id_kelas
    INTO v_id_kelas
    FROM mahasiswa
    WHERE id_mahasiswa = v_id_mahasiswa;

    SELECT
        k.nama_kelas,
        k.tingkat,

        mk.kode_mata_kuliah,
        mk.nama_mata_kuliah,
        mk.sks,
        mk.semester,

        p1.nama_pengajar AS nama_pengajar_1,
        p2.nama_pengajar AS nama_pengajar_2

    FROM detail_kelas_pada_mata_kuliah dkmk
    JOIN kelas k
        ON dkmk.id_kelas = k.id_kelas
    JOIN mata_kuliah mk
        ON dkmk.id_mata_kuliah = mk.id_matakuliah

    LEFT JOIN detail_pengajar_pada_mata_kuliah dp1
        ON dkmk.id_detail_kelas_pada_mata_kuliah = dp1.id_detail_kelas_pada_mata_kuliah
        AND dp1.kedudukan_pengajar = 'Pengajar1'
    LEFT JOIN pengajar p1
        ON dp1.id_pengajar = p1.id_pengajar

    LEFT JOIN detail_pengajar_pada_mata_kuliah dp2
        ON dkmk.id_detail_kelas_pada_mata_kuliah = dp2.id_detail_kelas_pada_mata_kuliah
        AND dp2.kedudukan_pengajar = 'Pengajar2'
    LEFT JOIN pengajar p2
        ON dp2.id_pengajar = p2.id_pengajar

    WHERE dkmk.id_kelas = v_id_kelas
    ORDER BY mk.semester ASC, mk.nama_mata_kuliah ASC;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `usp_select_mata_kuliah_mahasiswa_untuk_jam_minus` (IN `p_id_pengguna_mahasiswa` INT)   BEGIN
    DECLARE v_id_kelas INT;

    /* =========================================
       VALIDASI MAHASISWA
       ========================================= */
    IF NOT EXISTS (
        SELECT 1

        FROM pengguna AS u

        JOIN mahasiswa AS m
            ON u.id_mahasiswa = m.id_mahasiswa

        WHERE u.id_pengguna =
                p_id_pengguna_mahasiswa

          AND u.role = 'Mahasiswa'

          AND u.status_akun = 'Aktif'

          AND m.status_mahasiswa = 'Aktif'
    ) THEN

        SIGNAL SQLSTATE '45000'

        SET MESSAGE_TEXT =
            'Mahasiswa tidak ditemukan atau tidak aktif';

    END IF;

    /* =========================================
       AMBIL KELAS MAHASISWA
       ========================================= */
    SELECT
        m.id_kelas

    INTO
        v_id_kelas

    FROM pengguna AS u

    JOIN mahasiswa AS m
        ON u.id_mahasiswa = m.id_mahasiswa

    WHERE u.id_pengguna =
            p_id_pengguna_mahasiswa

    LIMIT 1;

    /* =========================================
       AMBIL MATA KULIAH KELAS TERSEBUT
       ========================================= */
    SELECT
        dkmk.id_detail_kelas_pada_mata_kuliah,

        mk.id_matakuliah AS id_mata_kuliah,

        mk.kode_mata_kuliah,
        mk.nama_mata_kuliah,
        mk.sks,
        mk.semester,

        k.id_kelas,
        k.nama_kelas,
        k.tingkat

    FROM detail_kelas_pada_mata_kuliah AS dkmk

    JOIN mata_kuliah AS mk
        ON dkmk.id_mata_kuliah =
            mk.id_matakuliah

    JOIN kelas AS k
        ON dkmk.id_kelas =
            k.id_kelas

    WHERE dkmk.id_kelas = v_id_kelas

      AND mk.status_mata_kuliah = 'Aktif'

    ORDER BY
        mk.semester ASC,
        mk.nama_mata_kuliah ASC;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `usp_select_pemberian_jam_minus` ()   BEGIN
    SELECT
        pjm.id_pemberian_jam_minus,

        pjm.kategori_pelanggaran,

        pjm.nama_pelanggaran,

        pjm.deskripsi_pelanggaran,

        pjm.keterangan_absensi,

        pjm.jumlah_jam_minus,

        pjm.jenis_jam,

        pjm.tanggal_pemberian,

        /* ==========================
           MAHASISWA PENERIMA
           ========================== */
        u_penerima.id_pengguna
            AS id_pengguna_penerima,

        m.id_mahasiswa,

        m.nim,

        m.nama_mahasiswa,

        k_mhs.nama_kelas,

        k_mhs.tingkat,

        /* ==========================
           PIC PEMBERI
           ========================== */
        u_pemberi.id_pengguna
            AS id_pengguna_pemberi,

        COALESCE(
            pg_pemberi.nama_pengajar,
            u_pemberi.username,
            '-'
        )
            AS nama_pemberi,

        /* ==========================
           AKADEMIK
           ========================== */
        dkmk.id_detail_kelas_pada_mata_kuliah,

        mk.id_matakuliah
            AS id_mata_kuliah,

        mk.kode_mata_kuliah,

        mk.nama_mata_kuliah,

        /* ==========================
           FASILITAS
           ========================== */
        f.id_fasilitas,

        f.nama_fasilitas,

        pjm.harga_fasilitas_saat_pemberian

    FROM pemberian_jam_minus AS pjm

    /* PENERIMA */
    LEFT JOIN
        detail_pengguna_pada_pemberian_jam_minus
        AS dp_penerima

        ON pjm.id_pemberian_jam_minus =
            dp_penerima.id_pemberian_jam_minus

       AND dp_penerima.peran_pengguna =
            'Penerima'

    LEFT JOIN pengguna AS u_penerima

        ON dp_penerima.id_pengguna =
            u_penerima.id_pengguna

    LEFT JOIN mahasiswa AS m

        ON u_penerima.id_mahasiswa =
            m.id_mahasiswa

    LEFT JOIN kelas AS k_mhs

        ON m.id_kelas =
            k_mhs.id_kelas

    /* PEMBERI */
    LEFT JOIN
        detail_pengguna_pada_pemberian_jam_minus
        AS dp_pemberi

        ON pjm.id_pemberian_jam_minus =
            dp_pemberi.id_pemberian_jam_minus

       AND dp_pemberi.peran_pengguna =
            'Pemberi'

    LEFT JOIN pengguna AS u_pemberi

        ON dp_pemberi.id_pengguna =
            u_pemberi.id_pengguna

    LEFT JOIN pengajar AS pg_pemberi

        ON u_pemberi.id_pengajar =
            pg_pemberi.id_pengajar

    /* AKADEMIK */
    LEFT JOIN
        detail_kelas_pada_mata_kuliah
        AS dkmk

        ON pjm.id_detail_kelas_pada_mata_kuliah =
            dkmk.id_detail_kelas_pada_mata_kuliah

    LEFT JOIN mata_kuliah AS mk

        ON dkmk.id_mata_kuliah =
            mk.id_matakuliah

    /* FASILITAS */
    LEFT JOIN fasilitas AS f

        ON pjm.id_fasilitas =
            f.id_fasilitas

    ORDER BY
        pjm.id_pemberian_jam_minus DESC;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `usp_select_pengaduan_kerusakan_fasilitas` ()   BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        RESIGNAL;
    END;

    SELECT
        pkf.id_pengaduan_kerusakan_fasilitas,
        pkf.id_fasilitas,
        f.nama_fasilitas,
        pkf.deskripsi_kerusakan,
        pkf.tanggal_pengaduan,
        pkf.bukti_kerusakan_url,
        pkf.pelaku_kerusakan,
        pkf.status_pengaduan,

        dp_pelapor.id_pengguna AS id_pelapor,
        p_pelapor.username AS username_pelapor,
        COALESCE(m_pelapor.nama_mahasiswa, pg_pelapor.nama_pengajar) AS nama_pelapor,

        dp_verifikator.id_pengguna AS id_verifikator,
        p_verifikator.username AS username_verifikator,
        COALESCE(m_verifikator.nama_mahasiswa, pg_verifikator.nama_pengajar) AS nama_verifikator

    FROM pengaduan_kerusakan_fasilitas AS pkf
    JOIN fasilitas AS f 
        ON pkf.id_fasilitas = f.id_fasilitas

    LEFT JOIN detail_pengguna_pada_pengaduan_kerusakan_fasilitas AS dp_pelapor
        ON pkf.id_pengaduan_kerusakan_fasilitas = dp_pelapor.id_pengaduan_kerusakan_fasilitas
        AND dp_pelapor.peran_pengguna = 'Pelapor'
    LEFT JOIN pengguna AS p_pelapor
        ON dp_pelapor.id_pengguna = p_pelapor.id_pengguna
    LEFT JOIN mahasiswa AS m_pelapor
        ON p_pelapor.id_mahasiswa = m_pelapor.id_mahasiswa
    LEFT JOIN pengajar AS pg_pelapor
        ON p_pelapor.id_pengajar = pg_pelapor.id_pengajar

    LEFT JOIN detail_pengguna_pada_pengaduan_kerusakan_fasilitas AS dp_verifikator
        ON pkf.id_pengaduan_kerusakan_fasilitas = dp_verifikator.id_pengaduan_kerusakan_fasilitas
        AND dp_verifikator.peran_pengguna = 'Verifikator'
    LEFT JOIN pengguna AS p_verifikator
        ON dp_verifikator.id_pengguna = p_verifikator.id_pengguna
    LEFT JOIN mahasiswa AS m_verifikator
        ON p_verifikator.id_mahasiswa = m_verifikator.id_mahasiswa
    LEFT JOIN pengajar AS pg_verifikator
        ON p_verifikator.id_pengajar = pg_verifikator.id_pengajar

    ORDER BY pkf.id_pengaduan_kerusakan_fasilitas ASC;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `usp_select_pengajar` ()   BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        RESIGNAL;
    END;

    SELECT
        id_pengajar,
        nip,
        nama_pengajar,
        email,
        no_hp,
        status_pengajar
    FROM pengajar
    ORDER BY id_pengajar ASC;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `usp_select_pengajar_aktif` ()   BEGIN
    SELECT
        id_pengajar,
        nip,
        nama_pengajar,
        email,
        no_hp,
        status_pengajar
    FROM pengajar
    WHERE status_pengajar = 'Aktif'
    ORDER BY nama_pengajar ASC;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `usp_select_pengajar_mata_kuliah_kelas` ()   BEGIN
    SELECT
        dkmk.id_detail_kelas_pada_mata_kuliah,

        k.id_kelas,
        k.nama_kelas,
        k.tingkat,

        mk.id_matakuliah AS id_mata_kuliah,
        mk.kode_mata_kuliah,
        mk.nama_mata_kuliah,
        mk.sks,
        mk.semester,

        p1.id_pengajar AS id_pengajar_1,
        p1.nama_pengajar AS nama_pengajar_1,

        p2.id_pengajar AS id_pengajar_2,
        p2.nama_pengajar AS nama_pengajar_2

    FROM detail_kelas_pada_mata_kuliah dkmk
    JOIN kelas k
        ON dkmk.id_kelas = k.id_kelas
    JOIN mata_kuliah mk
        ON dkmk.id_mata_kuliah = mk.id_matakuliah

    LEFT JOIN detail_pengajar_pada_mata_kuliah dp1
        ON dkmk.id_detail_kelas_pada_mata_kuliah = dp1.id_detail_kelas_pada_mata_kuliah
        AND dp1.kedudukan_pengajar = 'Pengajar1'
    LEFT JOIN pengajar p1
        ON dp1.id_pengajar = p1.id_pengajar

    LEFT JOIN detail_pengajar_pada_mata_kuliah dp2
        ON dkmk.id_detail_kelas_pada_mata_kuliah = dp2.id_detail_kelas_pada_mata_kuliah
        AND dp2.kedudukan_pengajar = 'Pengajar2'
    LEFT JOIN pengajar p2
        ON dp2.id_pengajar = p2.id_pengajar

    ORDER BY k.tingkat ASC, k.nama_kelas ASC, mk.semester ASC, mk.nama_mata_kuliah ASC;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `usp_select_pengajar_mata_kuliah_kelas_by_id` (IN `p_id_detail_kelas_pada_mata_kuliah` INT)   BEGIN
    SELECT
        dkmk.id_detail_kelas_pada_mata_kuliah,

        dkmk.id_kelas,
        k.nama_kelas,
        k.tingkat,

        dkmk.id_mata_kuliah,
        mk.kode_mata_kuliah,
        mk.nama_mata_kuliah,
        mk.sks,
        mk.semester,

        p1.id_pengajar AS id_pengajar_1,
        p1.nama_pengajar AS nama_pengajar_1,

        p2.id_pengajar AS id_pengajar_2,
        p2.nama_pengajar AS nama_pengajar_2

    FROM detail_kelas_pada_mata_kuliah dkmk
    JOIN kelas k
        ON dkmk.id_kelas = k.id_kelas
    JOIN mata_kuliah mk
        ON dkmk.id_mata_kuliah = mk.id_matakuliah

    LEFT JOIN detail_pengajar_pada_mata_kuliah dp1
        ON dkmk.id_detail_kelas_pada_mata_kuliah = dp1.id_detail_kelas_pada_mata_kuliah
        AND dp1.kedudukan_pengajar = 'Pengajar1'
    LEFT JOIN pengajar p1
        ON dp1.id_pengajar = p1.id_pengajar

    LEFT JOIN detail_pengajar_pada_mata_kuliah dp2
        ON dkmk.id_detail_kelas_pada_mata_kuliah = dp2.id_detail_kelas_pada_mata_kuliah
        AND dp2.kedudukan_pengajar = 'Pengajar2'
    LEFT JOIN pengajar p2
        ON dp2.id_pengajar = p2.id_pengajar

    WHERE dkmk.id_detail_kelas_pada_mata_kuliah = p_id_detail_kelas_pada_mata_kuliah;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `usp_select_pengajuan_jam_plus` ()   BEGIN
    SELECT 
        pjp.*,

        CASE
            WHEN pjp.sumber_jam = 'Luar' THEN pjp.jumlah_jam_plus * 0.5
            ELSE pjp.jumlah_jam_plus
        END AS jumlah_jam_diterima,

        COALESCE(k.nama_kegiatan, '-') AS nama_kegiatan,
        COALESCE(k.penyelenggara, '-') AS penyelenggara,
        k.tanggal_kegiatan,

        m_pengaju.nama_mahasiswa AS nama_pengaju,
        m_pengaju.nim AS nim_pengaju,
        u_pengaju.id_pengguna AS id_pengaju,

        COALESCE(pg_verif.nama_pengajar, '-') AS nama_verifikator

    FROM pengajuan_jam_plus pjp

    LEFT JOIN kegiatan k 
        ON pjp.id_kegiatan = k.id_kegiatan

    LEFT JOIN detail_pengguna_pada_pengajuan_jam_plus dp_p 
        ON pjp.id_pengajuan_jam_plus = dp_p.id_pengajuan_jam_plus
        AND dp_p.peran_pengguna = 'Pengaju'

    LEFT JOIN pengguna u_pengaju 
        ON dp_p.id_pengguna = u_pengaju.id_pengguna

    LEFT JOIN mahasiswa m_pengaju 
        ON u_pengaju.id_mahasiswa = m_pengaju.id_mahasiswa

    LEFT JOIN detail_pengguna_pada_pengajuan_jam_plus dp_v 
        ON pjp.id_pengajuan_jam_plus = dp_v.id_pengajuan_jam_plus
        AND dp_v.peran_pengguna = 'Verifikator'

    LEFT JOIN pengguna u_verif 
        ON dp_v.id_pengguna = u_verif.id_pengguna

    LEFT JOIN pengajar pg_verif 
        ON u_verif.id_pengajar = pg_verif.id_pengajar

    ORDER BY pjp.id_pengajuan_jam_plus DESC;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `usp_select_pengguna` ()   BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        RESIGNAL;
    END;

    SELECT
        p.id_pengguna,
        p.id_mahasiswa,
        m.nim,
        m.nama_mahasiswa,
        p.id_pengajar,
        pg.nip,
        pg.nama_pengajar,
        p.username,
        p.role,
        p.status_akun
    FROM pengguna AS p
    LEFT JOIN mahasiswa AS m ON p.id_mahasiswa = m.id_mahasiswa
    LEFT JOIN pengajar AS pg ON p.id_pengajar = pg.id_pengajar
    ORDER BY p.id_pengguna ASC;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `usp_select_periode_akademik` ()   BEGIN
    SELECT
        id_periode_akademik,
        tahun_akademik,
        semester,
        tanggal_mulai,
        tanggal_selesai,
        status_periode
    FROM periode_akademik
    ORDER BY id_periode_akademik DESC;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `usp_select_periode_akademik_by_id` (IN `p_id_periode_akademik` INT)   BEGIN
    SELECT
        id_periode_akademik,
        tahun_akademik,
        semester,
        tanggal_mulai,
        tanggal_selesai,
        status_periode
    FROM periode_akademik
    WHERE id_periode_akademik = p_id_periode_akademik
    LIMIT 1;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `usp_selesaikan_bursa_jobdesc` (IN `p_id_bursa_jobdesc` INT, IN `p_id_pemberi` INT)   BEGIN
    DECLARE v_status_jobdesc VARCHAR(20);
    DECLARE v_bukti_selesai_url TEXT;
    DECLARE v_jam_plus DECIMAL(10,2);

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    IF NOT EXISTS (
        SELECT 1
        FROM detail_pengguna_pada_bursa_jobdesc
        WHERE id_bursa_jobdesc = p_id_bursa_jobdesc
        AND id_pengguna = p_id_pemberi
        AND peran_pengguna = 'Pemberi'
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Kamu bukan pemberi jobdesc ini';
    END IF;

    START TRANSACTION;

    SELECT
        status_jobdesc,
        bukti_selesai_url,
        jam_plus
    INTO
        v_status_jobdesc,
        v_bukti_selesai_url,
        v_jam_plus
    FROM bursa_jobdesc
    WHERE id_bursa_jobdesc = p_id_bursa_jobdesc
    FOR UPDATE;

    IF v_status_jobdesc <> 'Dikerjakan' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Jobdesc hanya dapat diselesaikan saat status Dikerjakan';
    END IF;

    IF v_bukti_selesai_url IS NULL OR TRIM(v_bukti_selesai_url) = '' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Bukti selesai belum dikirim oleh mahasiswa';
    END IF;

    UPDATE mahasiswa m
    JOIN pengguna p
        ON m.id_mahasiswa = p.id_mahasiswa
    JOIN detail_pengguna_pada_bursa_jobdesc dp
        ON p.id_pengguna = dp.id_pengguna
    SET m.saldo_jam_plus_kompensasi = COALESCE(m.saldo_jam_plus_kompensasi, 0) + v_jam_plus
    WHERE dp.id_bursa_jobdesc = p_id_bursa_jobdesc
    AND dp.peran_pengguna = 'Penerima';

    UPDATE bursa_jobdesc
    SET status_jobdesc = 'Selesai'
    WHERE id_bursa_jobdesc = p_id_bursa_jobdesc;

    COMMIT;

    SELECT
        'Status bursa jobdesc berhasil diubah menjadi Selesai dan jam plus berhasil diberikan' AS Pesan,
        p_id_bursa_jobdesc AS id_bursa_jobdesc;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `usp_soft_delete_fasilitas` (IN `p_id_fasilitas` INT)   BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        RESIGNAL;
    END;

    IF NOT EXISTS (
        SELECT 1 FROM fasilitas
        WHERE id_fasilitas = p_id_fasilitas
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Data fasilitas tidak ditemukan';
    END IF;

    UPDATE fasilitas
    SET status_fasilitas = 'Tidak Aktif'
    WHERE id_fasilitas = p_id_fasilitas;

    SELECT 
        'Data fasilitas berhasil dihapus secara soft delete' AS Pesan,
        p_id_fasilitas AS id_fasilitas;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `usp_soft_delete_fasilitas_kelas` (IN `p_id_detail_fasilitas_pada_kelas` INT)   BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM detail_fasilitas_pada_kelas
        WHERE id_detail_fasilitas_pada_kelas = p_id_detail_fasilitas_pada_kelas
        AND status_detail_fasilitas_pada_kelas IN ('Aktif', 'Rusak')
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Data fasilitas kelas tidak ditemukan atau sudah tidak aktif';
    END IF;

    UPDATE detail_fasilitas_pada_kelas
    SET status_detail_fasilitas_pada_kelas = 'Tidak Aktif'
    WHERE id_detail_fasilitas_pada_kelas = p_id_detail_fasilitas_pada_kelas;

    SELECT
        'Data fasilitas kelas berhasil dihapus secara soft delete' AS Pesan,
        p_id_detail_fasilitas_pada_kelas AS id_detail_fasilitas_pada_kelas;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `usp_soft_delete_kegiatan` (IN `p_id_kegiatan` INT)   BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM kegiatan
        WHERE id_kegiatan = p_id_kegiatan
        AND status_kegiatan = 'Aktif'
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Data kegiatan tidak ditemukan atau sudah tidak aktif';
    END IF;

    UPDATE kegiatan
    SET status_kegiatan = 'Tidak Aktif'
    WHERE id_kegiatan = p_id_kegiatan;

    SELECT
        'Data kegiatan berhasil dinonaktifkan' AS Pesan,
        p_id_kegiatan AS id_kegiatan;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `usp_soft_delete_kelas` (IN `p_id_kelas` INT)   BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        RESIGNAL;
    END;

    IF NOT EXISTS (
        SELECT 1 FROM kelas
        WHERE id_kelas = p_id_kelas
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Data kelas tidak ditemukan';
    END IF;

    UPDATE kelas
    SET status_kelas = 'Tidak Aktif'
    WHERE id_kelas = p_id_kelas;

    SELECT 
        'Data kelas berhasil dihapus secara soft delete' AS Pesan,
        p_id_kelas AS id_kelas;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `usp_soft_delete_mahasiswa` (IN `p_id_mahasiswa` INT)   BEGIN
	DECLARE v_id_kelas INT;
    
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
    	ROLLBACK;
        RESIGNAL;
    END;

    IF NOT EXISTS (
        SELECT 1 FROM mahasiswa
        WHERE id_mahasiswa = p_id_mahasiswa
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Data mahasiswa tidak ditemukan';
    END IF;
    
    IF EXISTS (
        SELECT 1
        FROM mahasiswa
        WHERE id_mahasiswa = p_id_mahasiswa
        AND status_mahasiswa = 'Tidak Aktif'
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Mahasiswa sudah tidak aktif';
    END IF;
    
    START TRANSACTION;
    
    SELECT id_kelas
    INTO v_id_kelas
    FROM mahasiswa
    WHERE id_mahasiswa = p_id_mahasiswa;
    
    UPDATE kelas
    SET jumlah_mahasiswa = jumlah_mahasiswa - 1
    WHERE id_kelas = v_id_kelas;

    UPDATE mahasiswa
    SET status_mahasiswa = 'Tidak Aktif'
    WHERE id_mahasiswa = p_id_mahasiswa;
    
    COMMIT;

    SELECT 
        'Data mahasiswa berhasil dihapus secara soft delete' AS Pesan,
        p_id_mahasiswa AS id_mahasiswa;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `usp_soft_delete_pengajar` (IN `p_id_pengajar` INT)   BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        RESIGNAL;
    END;

    IF NOT EXISTS (
        SELECT 1 FROM pengajar
        WHERE id_pengajar = p_id_pengajar
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Data pengajar tidak ditemukan';
    END IF;

    UPDATE pengajar
    SET status_pengajar = 'Tidak Aktif'
    WHERE id_pengajar = p_id_pengajar;

    SELECT 
        'Data pengajar berhasil dihapus secara soft delete' AS Pesan,
        p_id_pengajar AS id_pengajar;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `usp_soft_delete_pengguna` (IN `p_id_pengguna` INT)   BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        RESIGNAL;
    END;

    IF NOT EXISTS (
        SELECT 1 FROM pengguna
        WHERE id_pengguna = p_id_pengguna
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Data pengguna tidak ditemukan';
    END IF;

    UPDATE pengguna
    SET status_akun = 'Tidak Aktif'
    WHERE id_pengguna = p_id_pengguna;

    SELECT 
        'Data pengguna berhasil dihapus secara soft delete' AS Pesan,
        p_id_pengguna AS id_pengguna;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `usp_soft_delete_periode_akademik` (IN `p_id_periode_akademik` INT)   BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM periode_akademik
        WHERE id_periode_akademik = p_id_periode_akademik
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Data periode akademik tidak ditemukan';
    END IF;

    UPDATE periode_akademik
    SET status_periode = 'Tidak Aktif'
    WHERE id_periode_akademik = p_id_periode_akademik;

    SELECT
        'Data periode akademik berhasil dinonaktifkan' AS Pesan,
        p_id_periode_akademik AS id_periode_akademik;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `usp_update_bukti_selesai_url_bursa_jobdesc` (IN `p_id_bursa_jobdesc` INT, IN `p_id_pengguna` INT, IN `p_bukti_selesai_url` TEXT)   BEGIN
    DECLARE v_role VARCHAR(30);
    DECLARE v_status_jobdesc VARCHAR(20);
    DECLARE v_bukti_selesai_url TEXT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    IF NOT EXISTS (
        SELECT 1
        FROM pengguna
        WHERE id_pengguna = p_id_pengguna
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Data pengguna tidak ditemukan';
    END IF;

    SELECT role
    INTO v_role
    FROM pengguna
    WHERE id_pengguna = p_id_pengguna;

    IF v_role <> 'Mahasiswa' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Hanya mahasiswa yang dapat mengirim bukti selesai jobdesc';
    END IF;

    IF p_bukti_selesai_url IS NULL OR TRIM(p_bukti_selesai_url) = '' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Link bukti selesai wajib diisi';
    END IF;

    IF NOT EXISTS (
        SELECT 1
        FROM detail_pengguna_pada_bursa_jobdesc
        WHERE id_bursa_jobdesc = p_id_bursa_jobdesc
        AND id_pengguna = p_id_pengguna
        AND peran_pengguna = 'Penerima'
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Kamu bukan penerima jobdesc ini';
    END IF;

    START TRANSACTION;

    SELECT
        status_jobdesc,
        bukti_selesai_url
    INTO
        v_status_jobdesc,
        v_bukti_selesai_url
    FROM bursa_jobdesc
    WHERE id_bursa_jobdesc = p_id_bursa_jobdesc
    FOR UPDATE;

    IF v_status_jobdesc <> 'Dikerjakan' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Bukti hanya dapat dikirim saat jobdesc sedang dikerjakan';
    END IF;

    IF v_bukti_selesai_url IS NOT NULL AND TRIM(v_bukti_selesai_url) <> '' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Bukti selesai jobdesc sudah pernah dikirim';
    END IF;

    UPDATE bursa_jobdesc
    SET bukti_selesai_url = TRIM(p_bukti_selesai_url)
    WHERE id_bursa_jobdesc = p_id_bursa_jobdesc;

    COMMIT;

    SELECT
        'Bukti selesai jobdesc berhasil dikirim' AS Pesan,
        p_id_bursa_jobdesc AS id_bursa_jobdesc;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `usp_update_detail_fasilitas_pada_kelas` (IN `p_id_detail_fasilitas_pada_kelas` INT, IN `p_id_kelas` INT, IN `p_id_fasilitas` INT, IN `p_jumlah_fasilitas` INT)   BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM detail_fasilitas_pada_kelas
        WHERE id_detail_fasilitas_pada_kelas = p_id_detail_fasilitas_pada_kelas
        AND status_detail_fasilitas_pada_kelas IN ('Aktif', 'Rusak')
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Data fasilitas kelas tidak ditemukan atau sudah tidak aktif';
    END IF;

    IF p_jumlah_fasilitas <= 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Jumlah fasilitas harus lebih dari 0';
    END IF;

    IF NOT EXISTS (
        SELECT 1
        FROM kelas
        WHERE id_kelas = p_id_kelas
        AND status_kelas = 'Aktif'
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Kelas tidak ditemukan atau tidak aktif';
    END IF;

    IF NOT EXISTS (
        SELECT 1
        FROM fasilitas
        WHERE id_fasilitas = p_id_fasilitas
        AND status_fasilitas = 'Aktif'
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Fasilitas tidak ditemukan atau tidak aktif';
    END IF;

    IF EXISTS (
        SELECT 1
        FROM detail_fasilitas_pada_kelas
        WHERE id_kelas = p_id_kelas
        AND id_fasilitas = p_id_fasilitas
        AND status_detail_fasilitas_pada_kelas IN ('Aktif', 'Rusak')
        AND id_detail_fasilitas_pada_kelas <> p_id_detail_fasilitas_pada_kelas
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Fasilitas ini sudah ditentukan pada kelas tersebut';
    END IF;

    UPDATE detail_fasilitas_pada_kelas
    SET
        id_kelas = p_id_kelas,
        id_fasilitas = p_id_fasilitas,
        jumlah_fasilitas = p_jumlah_fasilitas
    WHERE id_detail_fasilitas_pada_kelas = p_id_detail_fasilitas_pada_kelas;

    SELECT
        'Data fasilitas kelas berhasil diupdate' AS Pesan,
        p_id_detail_fasilitas_pada_kelas AS id_detail_fasilitas_pada_kelas;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `usp_update_fasilitas` (IN `p_id_fasilitas` INT, IN `p_nama_fasilitas` VARCHAR(50), IN `p_harga` DECIMAL(15,2))   BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM fasilitas
        WHERE id_fasilitas = p_id_fasilitas
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Data fasilitas tidak ditemukan';
    END IF;

    IF p_nama_fasilitas IS NULL OR TRIM(p_nama_fasilitas) = '' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Nama fasilitas wajib diisi';
    END IF;

    IF p_harga < 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Harga fasilitas tidak boleh kurang dari 0';
    END IF;

    UPDATE fasilitas
    SET
        nama_fasilitas = p_nama_fasilitas,
        harga = p_harga
    WHERE id_fasilitas = p_id_fasilitas;

    SELECT
        'Data fasilitas berhasil diupdate' AS Pesan,
        p_id_fasilitas AS id_fasilitas;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `usp_update_kegiatan` (IN `p_id_kegiatan` INT, IN `p_nama_kegiatan` VARCHAR(50), IN `p_penyelenggara` VARCHAR(20), IN `p_tanggal_kegiatan` DATE)   BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM kegiatan
        WHERE id_kegiatan = p_id_kegiatan
        AND status_kegiatan = 'Aktif'
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Data kegiatan tidak ditemukan atau sudah tidak aktif';
    END IF;

    IF p_nama_kegiatan IS NULL OR TRIM(p_nama_kegiatan) = '' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Nama kegiatan wajib diisi';
    END IF;

    IF p_penyelenggara NOT IN ('ASTRAtech','BEM','MPM','HIMMA','UKM') THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Penyelenggara tidak valid';
    END IF;

    UPDATE kegiatan
    SET
        nama_kegiatan = p_nama_kegiatan,
        penyelenggara = p_penyelenggara,
        tanggal_kegiatan = p_tanggal_kegiatan
    WHERE id_kegiatan = p_id_kegiatan
    AND status_kegiatan = 'Aktif';

    SELECT
        'Data kegiatan berhasil diupdate' AS Pesan,
        p_id_kegiatan AS id_kegiatan;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `usp_update_kelas` (IN `p_id_kelas` INT, IN `p_nama_kelas` VARCHAR(5), IN `p_tingkat` VARCHAR(1))   BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        RESIGNAL;
    END;

    IF NOT EXISTS (
        SELECT 1 FROM kelas
        WHERE id_kelas = p_id_kelas
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Data kelas tidak ditemukan';
    END IF;

    UPDATE kelas
    SET
        nama_kelas = p_nama_kelas,
        tingkat = p_tingkat
    WHERE id_kelas = p_id_kelas;

    SELECT 
        'Data kelas berhasil diupdate' AS Pesan,
        p_id_kelas AS id_kelas;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `usp_update_mahasiswa` (IN `p_id_mahasiswa` INT, IN `p_id_kelas` INT, IN `p_id_periode_akademik` INT, IN `p_nim` VARCHAR(20), IN `p_nama_mahasiswa` VARCHAR(50), IN `p_email` VARCHAR(50), IN `p_no_hp` VARCHAR(20), IN `p_status_mahasiswa` VARCHAR(20))   BEGIN
    DECLARE v_id_kelas_lama INT;
    
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
    	ROLLBACK;
        RESIGNAL;
    END;

    IF NOT EXISTS (
        SELECT 1 FROM mahasiswa
        WHERE id_mahasiswa = p_id_mahasiswa
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Data mahasiswa tidak ditemukan';
    END IF;
    
    IF p_status_mahasiswa NOT IN ('Aktif', 'Lulus', 'Cuti') THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Status tidak valid';
    END IF;
    
    START TRANSACTION;
    
    SELECT id_kelas
    INTO v_id_kelas_lama
    FROM mahasiswa
    WHERE id_mahasiswa = p_id_mahasiswa;

    IF v_id_kelas_lama <> p_id_kelas THEN
        UPDATE kelas
        SET jumlah_mahasiswa = jumlah_mahasiswa - 1
        WHERE id_kelas = v_id_kelas_lama;

        UPDATE kelas
        SET jumlah_mahasiswa = jumlah_mahasiswa + 1
        WHERE id_kelas = p_id_kelas;
    END IF;

    UPDATE mahasiswa
    SET
        id_kelas = p_id_kelas,
        id_periode_akademik = p_id_periode_akademik,
        nim = p_nim,
        nama_mahasiswa = p_nama_mahasiswa,
        email = p_email,
        no_hp = p_no_hp,
        status_mahasiswa = p_status_mahasiswa
    WHERE id_mahasiswa = p_id_mahasiswa;
    
    COMMIT;

    SELECT 
        'Data mahasiswa berhasil diupdate' AS Pesan,
        p_id_mahasiswa AS id_mahasiswa;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `usp_update_pengajar` (IN `p_id_pengajar` INT, IN `p_nip` VARCHAR(20), IN `p_nama_pengajar` VARCHAR(50), IN `p_email` VARCHAR(50), IN `p_no_hp` VARCHAR(20))   BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        RESIGNAL;
    END;

    IF NOT EXISTS (
        SELECT 1 FROM pengajar
        WHERE id_pengajar = p_id_pengajar
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Data pengajar tidak ditemukan';
    END IF;

    UPDATE pengajar
    SET
        nip = p_nip,
        nama_pengajar = p_nama_pengajar,
        email = p_email,
        no_hp = p_no_hp
    WHERE id_pengajar = p_id_pengajar;

    SELECT 
        'Data pengajar berhasil diupdate' AS Pesan,
        p_id_pengajar AS id_pengajar;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `usp_update_pengajar_mata_kuliah_kelas` (IN `p_id_detail_kelas_pada_mata_kuliah` INT, IN `p_id_kelas` INT, IN `p_id_mata_kuliah` INT, IN `p_id_pengajar_1` INT, IN `p_id_pengajar_2` INT)   BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    IF p_id_pengajar_1 = p_id_pengajar_2 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Pengajar 1 dan Pengajar 2 tidak boleh sama';
    END IF;

    IF NOT EXISTS (
        SELECT 1
        FROM detail_kelas_pada_mata_kuliah
        WHERE id_detail_kelas_pada_mata_kuliah = p_id_detail_kelas_pada_mata_kuliah
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Data penentuan pengajar tidak ditemukan';
    END IF;

    IF NOT EXISTS (
        SELECT 1 FROM kelas
        WHERE id_kelas = p_id_kelas
        AND status_kelas = 'Aktif'
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Kelas tidak ditemukan atau tidak aktif';
    END IF;

    IF NOT EXISTS (
        SELECT 1 FROM mata_kuliah
        WHERE id_matakuliah = p_id_mata_kuliah
        AND status_mata_kuliah = 'Aktif'
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Mata kuliah tidak ditemukan atau tidak aktif';
    END IF;

    IF NOT EXISTS (
        SELECT 1 FROM pengajar
        WHERE id_pengajar = p_id_pengajar_1
        AND status_pengajar = 'Aktif'
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Pengajar 1 tidak ditemukan atau tidak aktif';
    END IF;

    IF NOT EXISTS (
        SELECT 1 FROM pengajar
        WHERE id_pengajar = p_id_pengajar_2
        AND status_pengajar = 'Aktif'
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Pengajar 2 tidak ditemukan atau tidak aktif';
    END IF;

    IF EXISTS (
        SELECT 1
        FROM detail_kelas_pada_mata_kuliah
        WHERE id_kelas = p_id_kelas
        AND id_mata_kuliah = p_id_mata_kuliah
        AND id_detail_kelas_pada_mata_kuliah <> p_id_detail_kelas_pada_mata_kuliah
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Mata kuliah ini sudah ditentukan pada kelas tersebut';
    END IF;

    START TRANSACTION;

    UPDATE detail_kelas_pada_mata_kuliah
    SET
        id_kelas = p_id_kelas,
        id_mata_kuliah = p_id_mata_kuliah
    WHERE id_detail_kelas_pada_mata_kuliah = p_id_detail_kelas_pada_mata_kuliah;

    DELETE FROM detail_pengajar_pada_mata_kuliah
    WHERE id_detail_kelas_pada_mata_kuliah = p_id_detail_kelas_pada_mata_kuliah;

    INSERT INTO detail_pengajar_pada_mata_kuliah
    (
        id_detail_kelas_pada_mata_kuliah,
        id_pengajar,
        kedudukan_pengajar
    )
    VALUES
    (
        p_id_detail_kelas_pada_mata_kuliah,
        p_id_pengajar_1,
        'Pengajar1'
    ),
    (
        p_id_detail_kelas_pada_mata_kuliah,
        p_id_pengajar_2,
        'Pengajar2'
    );

    COMMIT;

    SELECT
        'Data pengajar mata kuliah kelas berhasil diupdate' AS Pesan,
        p_id_detail_kelas_pada_mata_kuliah AS id_detail_kelas_pada_mata_kuliah;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `usp_update_pengguna` (IN `p_id_pengguna` INT, IN `p_id_mahasiswa` INT, IN `p_id_pengajar` INT, IN `p_username` VARCHAR(50), IN `p_password` VARCHAR(255), IN `p_role` VARCHAR(30))   BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        RESIGNAL;
    END;

    IF NOT EXISTS (
        SELECT 1 FROM pengguna
        WHERE id_pengguna = p_id_pengguna
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Data pengguna tidak ditemukan';
    END IF;

    IF p_role = 'Mahasiswa' THEN
        IF p_id_mahasiswa IS NULL THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Role Mahasiswa wajib memiliki id_mahasiswa';
        END IF;

        IF p_id_pengajar IS NOT NULL THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Role Mahasiswa tidak boleh memiliki id_pengajar';
        END IF;
    ELSE
        IF p_id_pengajar IS NULL THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Role selain Mahasiswa wajib memiliki id_pengajar';
        END IF;
        
        IF p_id_mahasiswa IS NOT NULL THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Role selain Mahasiswa tidak boleh memiliki id_mahasiswa';
        END IF;
    END IF;

    UPDATE pengguna
    SET
        id_mahasiswa = p_id_mahasiswa,
        id_pengajar = p_id_pengajar,
        username = p_username,
        password = p_password,
        role = p_role
    WHERE id_pengguna = p_id_pengguna;

    SELECT 
        'Data pengguna berhasil diupdate' AS Pesan,
        p_id_pengguna AS id_pengguna;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `usp_update_periode_akademik` (IN `p_id_periode_akademik` INT, IN `p_tahun_akademik` VARCHAR(10), IN `p_semester` VARCHAR(10), IN `p_tanggal_mulai` DATETIME, IN `p_tanggal_selesai` DATETIME, IN `p_status_periode` VARCHAR(20))   BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    IF NOT EXISTS (
        SELECT 1
        FROM periode_akademik
        WHERE id_periode_akademik = p_id_periode_akademik
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Data periode akademik tidak ditemukan';
    END IF;

    IF p_tahun_akademik IS NULL OR TRIM(p_tahun_akademik) = '' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Tahun akademik wajib diisi';
    END IF;

    IF p_semester NOT IN ('Ganjil', 'Genap') THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Semester tidak valid';
    END IF;

    IF p_status_periode NOT IN ('Aktif', 'Tidak Aktif') THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Status periode tidak valid';
    END IF;

    IF p_tanggal_mulai > p_tanggal_selesai THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Tanggal mulai tidak boleh lebih besar dari tanggal selesai';
    END IF;

    START TRANSACTION;

    IF p_status_periode = 'Aktif' THEN
        UPDATE periode_akademik
        SET status_periode = 'Tidak Aktif'
        WHERE id_periode_akademik <> p_id_periode_akademik
        AND status_periode = 'Aktif';
    END IF;

    UPDATE periode_akademik
    SET
        tahun_akademik = p_tahun_akademik,
        semester = p_semester,
        tanggal_mulai = p_tanggal_mulai,
        tanggal_selesai = p_tanggal_selesai,
        status_periode = p_status_periode
    WHERE id_periode_akademik = p_id_periode_akademik;

    COMMIT;

    SELECT
        'Data periode akademik berhasil diubah' AS Pesan,
        p_id_periode_akademik AS id_periode_akademik;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `usp_update_status_bursa_jobdesc` (IN `p_id_bursa_jobdesc` INT, IN `p_id_pengguna` INT)   BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        RESIGNAL;
    END;
    
    IF NOT EXISTS (
        SELECT 1 FROM bursa_jobdesc
        WHERE id_bursa_jobdesc = p_id_bursa_jobdesc
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Data bursa jobdesc tidak ditemukan';
    END IF;
    
    IF NOT EXISTS (
        SELECT 1 FROM detail_pengguna_pada_bursa_jobdesc
        WHERE id_bursa_jobdesc = p_id_bursa_jobdesc
        	AND id_pengguna = p_id_pengguna
        	AND peran_pengguna = 'Pemberi'
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Pengguna tidak melakukan bursa jobdesc ini, atau pengguna bukan pemberi jobdesc';
    END IF;
    
    IF EXISTS (
    	SELECT 1
        FROM bursa_jobdesc
        WHERE id_bursa_jobdesc = p_id_bursa_jobdesc
        	AND (
                status_jobdesc = 'Dibuka'
        		OR bukti_selesai_url IS NULL
            )
    ) THEN
    	SIGNAL SQLSTATE '45000'
	    SET MESSAGE_TEXT = 'Bursa jobdesc belum dikerjakan';
    ELSE
	    UPDATE bursa_jobdesc
    	SET status_jobdesc = 'Selesai'
    	WHERE id_bursa_jobdesc = p_id_bursa_jobdesc;
    END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `usp_update_status_detail_fasilitas_pada_kelas` (IN `p_id_pengguna` INT, IN `p_id_fasilitas` INT, IN `p_status_detail_fasilitas_pada_kelas` VARCHAR(20))   BEGIN
    DECLARE v_id_kelas INT;

    SET v_id_kelas = ufn_cari_id_kelas_di_table_detail_fasilitas_pada_kelas(p_id_pengguna);

    IF v_id_kelas IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'ID kelas tidak ditemukan dari pengguna';
    END IF;

    IF p_status_detail_fasilitas_pada_kelas NOT IN ('Aktif', 'Rusak') THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Status fasilitas pada kelas tidak valid';
    END IF;

    IF NOT EXISTS (
        SELECT 1
        FROM detail_fasilitas_pada_kelas
        WHERE id_kelas = v_id_kelas
        AND id_fasilitas = p_id_fasilitas
        AND status_detail_fasilitas_pada_kelas IN ('Aktif', 'Rusak')
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Data fasilitas pada kelas tidak ditemukan atau sudah tidak aktif';
    END IF;

    UPDATE detail_fasilitas_pada_kelas
    SET status_detail_fasilitas_pada_kelas = p_status_detail_fasilitas_pada_kelas
    WHERE id_kelas = v_id_kelas
    AND id_fasilitas = p_id_fasilitas
    AND status_detail_fasilitas_pada_kelas IN ('Aktif', 'Rusak');
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `usp_update_status_pengaduan_kerusakan_fasilitas` (IN `p_id_pengaduan_kerusakan_fasilitas` INT, IN `p_id_pengguna` INT, IN `p_status_pengaduan` VARCHAR(20))   BEGIN
	DECLARE v_id_fasilitas INT;
    DECLARE v_id_pengguna_pelapor INT;
    
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
    	ROLLBACK;
        RESIGNAL;
    END;

    IF NOT EXISTS (
        SELECT 1 FROM pengaduan_kerusakan_fasilitas
        WHERE id_pengaduan_kerusakan_fasilitas = p_id_pengaduan_kerusakan_fasilitas
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Data pengaduan kerusakan fasilitas tidak ditemukan';
    END IF;
    
    IF p_status_pengaduan NOT IN ('Diterima', 'Ditolak') THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Status pengaduan tidak valid';
    END IF;
    
    SELECT id_fasilitas
    INTO v_id_fasilitas
    FROM pengaduan_kerusakan_fasilitas
    WHERE id_pengaduan_kerusakan_fasilitas = p_id_pengaduan_kerusakan_fasilitas;
    
    START TRANSACTION;

    UPDATE pengaduan_kerusakan_fasilitas
    SET
        status_pengaduan = p_status_pengaduan
    WHERE id_pengaduan_kerusakan_fasilitas = p_id_pengaduan_kerusakan_fasilitas;

    IF NOT EXISTS (
        SELECT 1
        FROM detail_pengguna_pada_pengaduan_kerusakan_fasilitas
        WHERE id_pengaduan_kerusakan_fasilitas = p_id_pengaduan_kerusakan_fasilitas
        AND id_pengguna = p_id_pengguna
        AND peran_pengguna = 'Verifikator'
    ) THEN
        CALL usp_insert_detail_pengguna_pada_pengaduan_kerusakan_fasilitas(
            p_id_pengaduan_kerusakan_fasilitas,
            p_id_pengguna,
            'Verifikator'
        );
    END IF;
    
    IF p_status_pengaduan = 'Diterima' THEN
    	SELECT id_pengguna
        INTO v_id_pengguna_pelapor
        FROM detail_pengguna_pada_pengaduan_kerusakan_fasilitas
        WHERE id_pengaduan_kerusakan_fasilitas = p_id_pengaduan_kerusakan_fasilitas
        AND peran_pengguna = 'Pelapor'
        LIMIT 1;
        
    	CALL usp_update_status_detail_fasilitas_pada_kelas(
        	v_id_pengguna_pelapor,
            v_id_fasilitas,
            'Rusak'
        );
    END IF;
    
    COMMIT;

    SELECT 
        'status_pengaduan berhasil diupdate' AS Pesan,
        p_id_pengaduan_kerusakan_fasilitas AS id_pengaduan_kerusakan_fasilitas,
        p_status_pengaduan AS status_pengaduan;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `usp_update_status_pengajuan_jam_plus` (IN `p_id_pengajuan` INT, IN `p_id_verifikator` INT, IN `p_status` VARCHAR(20), IN `p_alasan_penolakan` VARCHAR(255))   BEGIN
    DECLARE v_id_mhs INT;
    DECLARE v_jumlah_asli DECIMAL(6,2);
    DECLARE v_jumlah_diterima DECIMAL(6,2);
    DECLARE v_jenis VARCHAR(20);
    DECLARE v_sumber VARCHAR(10);
    DECLARE v_status_lama VARCHAR(30);

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    IF p_status NOT IN ('Disetujui', 'Ditolak') THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Status verifikasi tidak valid';
    END IF;

    IF p_status = 'Ditolak'
       AND (
           p_alasan_penolakan IS NULL
           OR CHAR_LENGTH(TRIM(p_alasan_penolakan)) = 0
       ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Alasan penolakan wajib diisi';
    END IF;

    IF NOT EXISTS (
        SELECT 1
        FROM pengguna
        WHERE id_pengguna = p_id_verifikator
          AND role = 'PIC Tata Tertib'
          AND status_akun = 'Aktif'
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Verifikator tidak valid atau bukan PIC Tata Tertib';
    END IF;

    IF NOT EXISTS (
        SELECT 1
        FROM pengajuan_jam_plus
        WHERE id_pengajuan_jam_plus = p_id_pengajuan
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Data pengajuan tidak ditemukan';
    END IF;

    SELECT status_pengajuan
    INTO v_status_lama
    FROM pengajuan_jam_plus
    WHERE id_pengajuan_jam_plus = p_id_pengajuan;

    IF v_status_lama <> 'Menunggu Verifikasi' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
        'Pengajuan ini sudah diverifikasi dan tidak dapat diproses ulang';
    END IF;

    START TRANSACTION;

    UPDATE pengajuan_jam_plus
    SET
        status_pengajuan = p_status,
        alasan_penolakan = CASE
            WHEN p_status = 'Ditolak'
                THEN TRIM(p_alasan_penolakan)
            ELSE NULL
        END
    WHERE id_pengajuan_jam_plus = p_id_pengajuan;

    DELETE FROM detail_pengguna_pada_pengajuan_jam_plus
    WHERE id_pengajuan_jam_plus = p_id_pengajuan
      AND peran_pengguna = 'Verifikator';

    INSERT INTO detail_pengguna_pada_pengajuan_jam_plus (
        id_pengajuan_jam_plus,
        id_pengguna,
        peran_pengguna
    ) VALUES (
        p_id_pengajuan,
        p_id_verifikator,
        'Verifikator'
    );

    IF p_status = 'Disetujui' THEN

        SELECT
            pjp.jumlah_jam_plus,
            pjp.jenis_jam,
            pjp.sumber_jam,
            u.id_mahasiswa
        INTO
            v_jumlah_asli,
            v_jenis,
            v_sumber,
            v_id_mhs
        FROM pengajuan_jam_plus pjp
        JOIN detail_pengguna_pada_pengajuan_jam_plus dp
            ON pjp.id_pengajuan_jam_plus =
               dp.id_pengajuan_jam_plus
        JOIN pengguna u
            ON dp.id_pengguna = u.id_pengguna
        WHERE pjp.id_pengajuan_jam_plus = p_id_pengajuan
          AND dp.peran_pengguna = 'Pengaju'
        LIMIT 1;

        IF v_sumber = 'Luar' THEN
            SET v_jumlah_diterima = v_jumlah_asli * 0.5;
        ELSE
            SET v_jumlah_diterima = v_jumlah_asli;
        END IF;

        IF v_jenis = 'Murni' THEN

            UPDATE mahasiswa
            SET saldo_jam_plus_murni =
                saldo_jam_plus_murni + v_jumlah_diterima
            WHERE id_mahasiswa = v_id_mhs;

        ELSEIF v_jenis = 'Kompensasi' THEN

            UPDATE mahasiswa
            SET saldo_jam_plus_kompensasi =
                saldo_jam_plus_kompensasi + v_jumlah_diterima
            WHERE id_mahasiswa = v_id_mhs;

        ELSE
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT =
            'Jenis jam pada pengajuan tidak valid';
        END IF;

    END IF;

    COMMIT;

    SELECT
        'Verifikasi pengajuan jam plus berhasil disimpan' AS pesan,
        p_id_pengajuan AS id_pengajuan_jam_plus,
        p_status AS status_pengajuan,
        CASE
            WHEN p_status = 'Ditolak'
                THEN TRIM(p_alasan_penolakan)
            ELSE NULL
        END AS alasan_penolakan;
END$$

--
-- Fungsi
--
CREATE DEFINER=`root`@`localhost` FUNCTION `ufn_cari_id_kelas_di_table_detail_fasilitas_pada_kelas` (`p_id_pengguna` INT) RETURNS INT(11) READS SQL DATA BEGIN
    DECLARE v_id_kelas INT;

    DECLARE CONTINUE HANDLER FOR NOT FOUND
    BEGIN
        SET v_id_kelas = NULL;
    END;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        RETURN NULL;
    END;

    SELECT m.id_kelas
    INTO v_id_kelas
    FROM pengguna AS p
    JOIN mahasiswa AS m ON p.id_mahasiswa = m.id_mahasiswa
    WHERE p.id_pengguna = p_id_pengguna
    LIMIT 1;

    RETURN v_id_kelas;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `ufn_hitung_sisa_jam_plus_kompensasi_mahasiswa` (`p_id_mahasiswa` INT) RETURNS DECIMAL(10,1) DETERMINISTIC READS SQL DATA BEGIN
    DECLARE v_saldo_jam_plus_kompensasi DECIMAL(10,1) DEFAULT 0.0;
    DECLARE v_saldo_jam_minus_kompensasi DECIMAL(10,1) DEFAULT 0.0;
    DECLARE v_sisa_jam_plus_kompensasi DECIMAL(10,1) DEFAULT 0.0;

    SELECT
        COALESCE(saldo_jam_plus_kompensasi, 0.0),
        COALESCE(saldo_jam_minus_kompensasi, 0.0)
    INTO
        v_saldo_jam_plus_kompensasi,
        v_saldo_jam_minus_kompensasi
    FROM mahasiswa
    WHERE id_mahasiswa = p_id_mahasiswa
    LIMIT 1;

    SET v_sisa_jam_plus_kompensasi =
        v_saldo_jam_plus_kompensasi - v_saldo_jam_minus_kompensasi;

    IF v_sisa_jam_plus_kompensasi < 0 THEN
        SET v_sisa_jam_plus_kompensasi = 0.0;
    END IF;

    RETURN ROUND(COALESCE(v_sisa_jam_plus_kompensasi, 0.0), 1);
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `ufn_hitung_total_jam_kompensasi_mahasiswa` (`p_id_mahasiswa` INT) RETURNS DECIMAL(10,1) DETERMINISTIC READS SQL DATA BEGIN
    DECLARE v_saldo_jam_plus_kompensasi DECIMAL(10,1) DEFAULT 0.0;
    DECLARE v_saldo_jam_minus_kompensasi DECIMAL(10,1) DEFAULT 0.0;
    DECLARE v_data_ditemukan TINYINT DEFAULT 1;

    DECLARE CONTINUE HANDLER FOR NOT FOUND
        SET v_data_ditemukan = 0;

    SELECT
        COALESCE(saldo_jam_plus_kompensasi, 0.0),
        COALESCE(saldo_jam_minus_kompensasi, 0.0)
    INTO
        v_saldo_jam_plus_kompensasi,
        v_saldo_jam_minus_kompensasi
    FROM mahasiswa
    WHERE id_mahasiswa = p_id_mahasiswa
    LIMIT 1;

    IF v_data_ditemukan = 0 THEN
        RETURN 0.0;
    END IF;

    RETURN ROUND(
        v_saldo_jam_plus_kompensasi - v_saldo_jam_minus_kompensasi,
        1
    );
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `ufn_hitung_total_jam_mahasiswa` (`p_id_mahasiswa` INT) RETURNS DECIMAL(10,1) DETERMINISTIC READS SQL DATA BEGIN
    DECLARE v_total_jam_kompensasi DECIMAL(10,1) DEFAULT 0.0;
    DECLARE v_total_jam_murni DECIMAL(10,1) DEFAULT 0.0;
    DECLARE v_total_jam_mahasiswa DECIMAL(10,1) DEFAULT 0.0;

    SET v_total_jam_kompensasi =
        COALESCE(
            ufn_hitung_total_jam_kompensasi_mahasiswa(p_id_mahasiswa),
            0.0
        );

    SET v_total_jam_murni =
        COALESCE(
            ufn_hitung_total_jam_murni_mahasiswa(p_id_mahasiswa),
            0.0
        );

    IF
        v_total_jam_kompensasi < 0
        AND
        v_total_jam_murni > 0
    THEN
        SET v_total_jam_mahasiswa =
            v_total_jam_kompensasi;
    ELSE
        SET v_total_jam_mahasiswa =
            v_total_jam_kompensasi + v_total_jam_murni;
    END IF;

    RETURN ROUND(
        COALESCE(v_total_jam_mahasiswa, 0.0),
        1
    );
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `ufn_hitung_total_jam_murni_mahasiswa` (`p_id_mahasiswa` INT) RETURNS DECIMAL(10,1) DETERMINISTIC READS SQL DATA BEGIN
    DECLARE v_saldo_jam_plus_murni DECIMAL(10,1) DEFAULT 0.0;
    DECLARE v_saldo_jam_minus_murni DECIMAL(10,1) DEFAULT 0.0;
    DECLARE v_data_ditemukan TINYINT DEFAULT 1;

    DECLARE CONTINUE HANDLER FOR NOT FOUND
        SET v_data_ditemukan = 0;

    SELECT
        COALESCE(saldo_jam_plus_murni, 0.0),
        COALESCE(saldo_jam_minus_murni, 0.0)
    INTO
        v_saldo_jam_plus_murni,
        v_saldo_jam_minus_murni
    FROM mahasiswa
    WHERE id_mahasiswa = p_id_mahasiswa
    LIMIT 1;

    IF v_data_ditemukan = 0 THEN
        RETURN 0.0;
    END IF;

    RETURN ROUND(
        v_saldo_jam_plus_murni - v_saldo_jam_minus_murni,
        1
    );
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `ufn_total_jam_minus_mahasiswa` (`p_id_mahasiswa` INT) RETURNS DECIMAL(10,1) READS SQL DATA BEGIN
    DECLARE v_minus_murni DECIMAL(10,1) DEFAULT 0.0;
    DECLARE v_minus_kompensasi DECIMAL(10,1) DEFAULT 0.0;
    DECLARE v_plus_murni DECIMAL(10,1) DEFAULT 0.0;
    DECLARE v_plus_kompensasi DECIMAL(10,1) DEFAULT 0.0;

    DECLARE v_sisa_minus_murni DECIMAL(10,1) DEFAULT 0.0;
    DECLARE v_sisa_minus_kompensasi DECIMAL(10,1) DEFAULT 0.0;
    DECLARE v_sisa_plus_kompensasi DECIMAL(10,1) DEFAULT 0.0;

    DECLARE v_data_ditemukan TINYINT DEFAULT 1;

    DECLARE CONTINUE HANDLER FOR NOT FOUND
        SET v_data_ditemukan = 0;

    SELECT
        COALESCE(saldo_jam_minus_murni, 0.0),
        COALESCE(saldo_jam_minus_kompensasi, 0.0),
        COALESCE(saldo_jam_plus_murni, 0.0),
        COALESCE(saldo_jam_plus_kompensasi, 0.0)
    INTO
        v_minus_murni,
        v_minus_kompensasi,
        v_plus_murni,
        v_plus_kompensasi
    FROM mahasiswa
    WHERE id_mahasiswa = p_id_mahasiswa
    LIMIT 1;

    IF v_data_ditemukan = 0 THEN
        RETURN 0.0;
    END IF;

    SET v_sisa_minus_kompensasi =
        GREATEST(0.0, v_minus_kompensasi - v_plus_kompensasi);

    SET v_sisa_plus_kompensasi =
        GREATEST(0.0, v_plus_kompensasi - v_minus_kompensasi);

    SET v_sisa_minus_murni =
        GREATEST(0.0, v_minus_murni - v_plus_murni);

    SET v_sisa_minus_murni =
        GREATEST(0.0, v_sisa_minus_murni - v_sisa_plus_kompensasi);

    RETURN ROUND(v_sisa_minus_murni + v_sisa_minus_kompensasi, 1);
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Struktur dari tabel `bursa_jobdesc`
--

CREATE TABLE `bursa_jobdesc` (
  `id_bursa_jobdesc` int(11) NOT NULL,
  `deskripsi_jobdesc` text NOT NULL,
  `penerima_jobdesc` enum('Semua Mahasiswa','Mahasiswa dengan Jam Minus') NOT NULL DEFAULT 'Semua Mahasiswa',
  `jam_plus` decimal(6,1) NOT NULL,
  `tanggal_pemberian_jobdesc` datetime NOT NULL,
  `jumlah_mahasiswa_diperlukan` int(11) NOT NULL,
  `jumlah_mahasiswa_mengambil` int(11) NOT NULL DEFAULT 0,
  `bukti_selesai_url` varchar(2048) DEFAULT NULL,
  `status_jobdesc` enum('Dibuka','Dikerjakan','Selesai') DEFAULT 'Dibuka'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `bursa_jobdesc`
--

INSERT INTO `bursa_jobdesc` (`id_bursa_jobdesc`, `deskripsi_jobdesc`, `penerima_jobdesc`, `jam_plus`, `tanggal_pemberian_jobdesc`, `jumlah_mahasiswa_diperlukan`, `jumlah_mahasiswa_mengambil`, `bukti_selesai_url`, `status_jobdesc`) VALUES
(1, 'wertg34', 'Semua Mahasiswa', 20.0, '2026-06-18 18:46:00', 2, 2, 'https://halo', 'Selesai'),
(2, 'Membersihkan tendik', 'Semua Mahasiswa', 20.0, '2026-06-19 22:20:00', 10, 10, 'https://halo', 'Selesai'),
(3, 'Perbaiki laptop', 'Semua Mahasiswa', 10.0, '2026-06-20 00:00:00', 2, 2, 'https://halo', 'Selesai'),
(4, 'Cari ikan', 'Mahasiswa dengan Jam Minus', 90.0, '2026-06-27 04:40:00', 2, 2, 'a', 'Selesai'),
(5, 'hdsufodsf', 'Semua Mahasiswa', 20.0, '2026-06-19 08:36:00', 2, 2, 'selesai cik', 'Selesai'),
(6, 'Rapihkan Tendik', 'Semua Mahasiswa', 1.0, '2026-07-09 18:35:00', 3, 3, 'https://www.bing.com/search?pglt=299&q=apa&cvid=d715390a2ba542ac8f692dee3df6f0fe&gs_lcrp=EgRlZGdlKgYIABBFGDkyBggAEEUYOTIGCAEQRRg80gEHNjU2ajBqN6gCALACAA&FORM=ANNTA1&PC=U531', 'Selesai'),
(7, 'a', 'Semua Mahasiswa', 1.0, '2026-07-12 01:19:00', 1, 1, NULL, 'Dikerjakan'),
(8, 'sdfdsv', 'Semua Mahasiswa', 100.0, '2026-07-14 11:09:00', 1, 1, 'https://www.google.com/search?q=if+%28+%21preg_match%28+%27%2F%5E%5Cd%7B1%2C4%7D%28%5C.%5Cd%29%3F%24%2F%27%2C+%24jam_plus_input+%29+%29+%7B+kembali_dengan_error%28%22Jam+plus+hanya+boleh+memiliki+satu+angka+di+belakang+koma.%22%29%3B+%7D&gs_lcrp=EgZjaHJvbWUyBggAEEUYOTIHCAEQIRiPAjIHCAIQIRiPAtIBCDE2ODRqMGo3qAIAsAIA&sourceid=chrome&ie=UTF-8&udm=50&aep=10&ntc=1&mstk=AUtExfDErJ_94f2O22fKSc3SnVYDOCz9iJpwFN2QBjUMZHPJeH7VwFO5qqzufoJ0CQko_AasmfF68tOFybXW2qJu9gjRe7F2j9q-JsuQKDXmDaaBsDhBqv_6j29pNTY9v0UwRjHA8On-yBQy-UAv07wHs1RbXmReH6oWFgUN3nVAmaFSQYnslfE1L4HxqpHVj2s3My6ar5U3sjODi9PGnaJysNTfvnswB7R4Y8QhH3Lkbr45zYRdl1PDMahLBZ2qY-2APUgWlAbbTt__0LR00bhbg1gVXOEYW3Kj-lS6CGry8VI11vk7bXdGZ07YfBQ7LtzFk9C8gYrDTGJ5BQ&aioh=3&csuir=1&cs=1&mtid=3rNVavXwG_qY4-EPjYfewQQ', 'Selesai'),
(9, 'ouasdh', 'Mahasiswa dengan Jam Minus', 120.0, '2026-07-14 11:30:00', 1, 0, NULL, 'Dibuka');

-- --------------------------------------------------------

--
-- Struktur dari tabel `detail_fasilitas_pada_kelas`
--

CREATE TABLE `detail_fasilitas_pada_kelas` (
  `id_detail_fasilitas_pada_kelas` int(11) NOT NULL,
  `id_kelas` int(11) NOT NULL,
  `id_fasilitas` int(11) NOT NULL,
  `jumlah_fasilitas` int(11) DEFAULT 1,
  `status_detail_fasilitas_pada_kelas` enum('Aktif','Rusak','Tidak Aktif') DEFAULT 'Aktif'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `detail_fasilitas_pada_kelas`
--

INSERT INTO `detail_fasilitas_pada_kelas` (`id_detail_fasilitas_pada_kelas`, `id_kelas`, `id_fasilitas`, `jumlah_fasilitas`, `status_detail_fasilitas_pada_kelas`) VALUES
(1, 1, 6, 80, 'Aktif'),
(2, 1, 7, 1, 'Aktif'),
(3, 2, 8, 3, 'Aktif'),
(4, 5, 5, 20, 'Aktif'),
(5, 1, 8, 20, 'Aktif'),
(6, 2, 5, 20, 'Aktif');

-- --------------------------------------------------------

--
-- Struktur dari tabel `detail_kelas_pada_mata_kuliah`
--

CREATE TABLE `detail_kelas_pada_mata_kuliah` (
  `id_detail_kelas_pada_mata_kuliah` int(11) NOT NULL,
  `id_mata_kuliah` int(11) NOT NULL,
  `id_kelas` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `detail_kelas_pada_mata_kuliah`
--

INSERT INTO `detail_kelas_pada_mata_kuliah` (`id_detail_kelas_pada_mata_kuliah`, `id_mata_kuliah`, `id_kelas`) VALUES
(2, 2, 1),
(4, 2, 2),
(3, 3, 2),
(5, 1, 5),
(7, 4, 5),
(6, 5, 5);

-- --------------------------------------------------------

--
-- Struktur dari tabel `detail_pengajar_pada_mata_kuliah`
--

CREATE TABLE `detail_pengajar_pada_mata_kuliah` (
  `id_detail_pengajar_pada_mata_kuliah` int(11) NOT NULL,
  `id_detail_kelas_pada_mata_kuliah` int(11) NOT NULL,
  `id_pengajar` int(11) NOT NULL,
  `kedudukan_pengajar` enum('Pengajar1','Pengajar2') NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `detail_pengajar_pada_mata_kuliah`
--

INSERT INTO `detail_pengajar_pada_mata_kuliah` (`id_detail_pengajar_pada_mata_kuliah`, `id_detail_kelas_pada_mata_kuliah`, `id_pengajar`, `kedudukan_pengajar`) VALUES
(11, 2, 3, 'Pengajar1'),
(12, 2, 5, 'Pengajar2'),
(13, 3, 5, 'Pengajar1'),
(14, 3, 1, 'Pengajar2'),
(15, 4, 1, 'Pengajar1'),
(16, 4, 3, 'Pengajar2'),
(17, 5, 3, 'Pengajar1'),
(18, 5, 2, 'Pengajar2'),
(19, 6, 2, 'Pengajar1'),
(20, 6, 4, 'Pengajar2'),
(21, 7, 4, 'Pengajar1'),
(22, 7, 5, 'Pengajar2');

-- --------------------------------------------------------

--
-- Struktur dari tabel `detail_pengguna_pada_bursa_jobdesc`
--

CREATE TABLE `detail_pengguna_pada_bursa_jobdesc` (
  `id_detail_pengguna_pada_bursa_jobdesc` int(11) NOT NULL,
  `id_bursa_jobdesc` int(11) NOT NULL,
  `id_pengguna` int(11) NOT NULL,
  `peran_pengguna` enum('Pemberi','Penerima') NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `detail_pengguna_pada_bursa_jobdesc`
--

INSERT INTO `detail_pengguna_pada_bursa_jobdesc` (`id_detail_pengguna_pada_bursa_jobdesc`, `id_bursa_jobdesc`, `id_pengguna`, `peran_pengguna`) VALUES
(1, 1, 2, 'Pemberi'),
(17, 4, 2, 'Pemberi'),
(22, 5, 2, 'Pemberi'),
(29, 7, 3, 'Pemberi'),
(31, 8, 3, 'Pemberi'),
(33, 9, 3, 'Pemberi'),
(3, 2, 6, 'Pemberi'),
(16, 3, 6, 'Pemberi'),
(25, 6, 6, 'Pemberi'),
(15, 1, 7, 'Penerima'),
(4, 2, 7, 'Penerima'),
(18, 4, 7, 'Penerima'),
(28, 6, 7, 'Penerima'),
(14, 1, 9, 'Penerima'),
(5, 2, 9, 'Penerima'),
(23, 5, 9, 'Penerima'),
(26, 6, 9, 'Penerima'),
(30, 7, 9, 'Penerima'),
(32, 8, 9, 'Penerima'),
(6, 2, 10, 'Penerima'),
(24, 5, 10, 'Penerima'),
(7, 2, 12, 'Penerima'),
(8, 2, 13, 'Penerima'),
(9, 2, 14, 'Penerima'),
(10, 2, 15, 'Penerima'),
(19, 4, 15, 'Penerima'),
(11, 2, 16, 'Penerima'),
(21, 3, 16, 'Penerima'),
(12, 2, 17, 'Penerima'),
(13, 2, 18, 'Penerima'),
(20, 3, 19, 'Penerima'),
(27, 6, 19, 'Penerima');

-- --------------------------------------------------------

--
-- Struktur dari tabel `detail_pengguna_pada_pemberian_jam_minus`
--

CREATE TABLE `detail_pengguna_pada_pemberian_jam_minus` (
  `id_detail_pengguna_pada_pemberian_jam_minus` int(11) NOT NULL,
  `id_pemberian_jam_minus` int(11) NOT NULL,
  `id_pengguna` int(11) NOT NULL,
  `peran_pengguna` enum('Pemberi','Penerima') NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `detail_pengguna_pada_pemberian_jam_minus`
--

INSERT INTO `detail_pengguna_pada_pemberian_jam_minus` (`id_detail_pengguna_pada_pemberian_jam_minus`, `id_pemberian_jam_minus`, `id_pengguna`, `peran_pengguna`) VALUES
(1, 1, 3, 'Pemberi'),
(2, 1, 7, 'Penerima'),
(3, 2, 3, 'Pemberi'),
(4, 2, 9, 'Penerima'),
(5, 3, 3, 'Pemberi'),
(6, 3, 16, 'Penerima'),
(7, 4, 3, 'Pemberi'),
(8, 4, 14, 'Penerima'),
(9, 5, 3, 'Pemberi'),
(10, 5, 13, 'Penerima'),
(11, 6, 3, 'Pemberi'),
(12, 6, 9, 'Penerima');

-- --------------------------------------------------------

--
-- Struktur dari tabel `detail_pengguna_pada_pengaduan_kerusakan_fasilitas`
--

CREATE TABLE `detail_pengguna_pada_pengaduan_kerusakan_fasilitas` (
  `id_detail_pengguna_pada_pengaduan_kerusakan_fasilitas` int(11) NOT NULL,
  `id_pengaduan_kerusakan_fasilitas` int(11) NOT NULL,
  `id_pengguna` int(11) NOT NULL,
  `peran_pengguna` enum('Pelapor','Verifikator') NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `detail_pengguna_pada_pengaduan_kerusakan_fasilitas`
--

INSERT INTO `detail_pengguna_pada_pengaduan_kerusakan_fasilitas` (`id_detail_pengguna_pada_pengaduan_kerusakan_fasilitas`, `id_pengaduan_kerusakan_fasilitas`, `id_pengguna`, `peran_pengguna`) VALUES
(1, 1, 1, 'Pelapor'),
(2, 2, 1, 'Pelapor'),
(4, 3, 7, 'Pelapor'),
(5, 4, 7, 'Pelapor'),
(8, 5, 7, 'Pelapor'),
(10, 6, 9, 'Pelapor'),
(14, 7, 7, 'Pelapor'),
(13, 1, 4, 'Verifikator'),
(3, 2, 4, 'Verifikator'),
(6, 3, 4, 'Verifikator'),
(7, 4, 4, 'Verifikator'),
(9, 5, 4, 'Verifikator'),
(11, 6, 4, 'Verifikator');

-- --------------------------------------------------------

--
-- Struktur dari tabel `detail_pengguna_pada_pengajuan_jam_plus`
--

CREATE TABLE `detail_pengguna_pada_pengajuan_jam_plus` (
  `id_detail_pengguna_pada_pengajuan_jam_plus` int(11) NOT NULL,
  `id_pengajuan_jam_plus` int(11) NOT NULL,
  `id_pengguna` int(11) NOT NULL,
  `peran_pengguna` enum('Pengaju','Verifikator') NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `detail_pengguna_pada_pengajuan_jam_plus`
--

INSERT INTO `detail_pengguna_pada_pengajuan_jam_plus` (`id_detail_pengguna_pada_pengajuan_jam_plus`, `id_pengajuan_jam_plus`, `id_pengguna`, `peran_pengguna`) VALUES
(1, 1, 19, 'Pengaju'),
(2, 1, 3, 'Verifikator'),
(3, 2, 9, 'Pengaju'),
(4, 3, 9, 'Pengaju'),
(5, 2, 3, 'Verifikator'),
(6, 3, 3, 'Verifikator'),
(7, 4, 19, 'Pengaju'),
(8, 5, 19, 'Pengaju'),
(9, 6, 19, 'Pengaju'),
(10, 7, 9, 'Pengaju'),
(11, 8, 9, 'Pengaju'),
(12, 8, 3, 'Verifikator'),
(13, 9, 15, 'Pengaju'),
(14, 10, 15, 'Pengaju'),
(15, 10, 3, 'Verifikator'),
(16, 9, 3, 'Verifikator'),
(17, 5, 3, 'Verifikator'),
(18, 7, 3, 'Verifikator'),
(19, 4, 3, 'Verifikator'),
(20, 11, 9, 'Pengaju'),
(21, 12, 9, 'Pengaju'),
(22, 12, 3, 'Verifikator'),
(23, 13, 9, 'Pengaju'),
(24, 13, 3, 'Verifikator');

-- --------------------------------------------------------

--
-- Struktur dari tabel `fasilitas`
--

CREATE TABLE `fasilitas` (
  `id_fasilitas` int(11) NOT NULL,
  `nama_fasilitas` varchar(50) NOT NULL,
  `harga` decimal(15,2) DEFAULT 0.00,
  `status_fasilitas` enum('Aktif','Tidak Aktif') DEFAULT 'Aktif',
  `tanggal_pendataan` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `fasilitas`
--

INSERT INTO `fasilitas` (`id_fasilitas`, `nama_fasilitas`, `harga`, `status_fasilitas`, `tanggal_pendataan`) VALUES
(1, 'Proyektor Kelas', 4500000.00, 'Tidak Aktif', '2026-06-08 22:50:43'),
(2, 'AC Kelas', 3500000.00, 'Tidak Aktif', '2026-06-08 22:50:43'),
(3, 'Komputer Lab', 8500000.00, 'Tidak Aktif', '2026-06-08 22:50:43'),
(4, 'Kursi Kelas', 350000.00, 'Tidak Aktif', '2026-06-08 22:50:43'),
(5, 'Papan Tulis', 750000.00, 'Aktif', '2026-06-08 22:50:43'),
(6, 'Bangku', 100000.00, 'Tidak Aktif', '2026-06-11 23:44:46'),
(7, 'Kursi', 120000.00, 'Tidak Aktif', '2026-06-17 19:24:58'),
(8, 'Kursi Kelas', 170000.00, 'Aktif', '2026-06-17 19:30:39');

-- --------------------------------------------------------

--
-- Struktur dari tabel `kegiatan`
--

CREATE TABLE `kegiatan` (
  `id_kegiatan` int(11) NOT NULL,
  `nama_kegiatan` varchar(50) NOT NULL,
  `penyelenggara` enum('ASTRAtech','BEM','MPM','HIMMA','UKM') NOT NULL,
  `tanggal_kegiatan` date DEFAULT NULL,
  `status_kegiatan` enum('Aktif','Tidak Aktif') DEFAULT 'Aktif'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `kegiatan`
--

INSERT INTO `kegiatan` (`id_kegiatan`, `nama_kegiatan`, `penyelenggara`, `tanggal_kegiatan`, `status_kegiatan`) VALUES
(1, 'ASTRA', 'ASTRAtech', NULL, 'Tidak Aktif'),
(2, 'Donor Darah', 'BEM', '2026-07-15', 'Aktif'),
(3, 'Novastech', 'ASTRAtech', '2026-07-23', 'Aktif');

-- --------------------------------------------------------

--
-- Struktur dari tabel `kelas`
--

CREATE TABLE `kelas` (
  `id_kelas` int(11) NOT NULL,
  `nama_kelas` varchar(5) NOT NULL,
  `tingkat` enum('1','2','3','4') NOT NULL,
  `jumlah_mahasiswa` int(11) DEFAULT 0,
  `status_kelas` enum('Aktif','Tidak Aktif') DEFAULT 'Aktif'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `kelas`
--

INSERT INTO `kelas` (`id_kelas`, `nama_kelas`, `tingkat`, `jumlah_mahasiswa`, `status_kelas`) VALUES
(1, 'TR1C', '1', 3, 'Aktif'),
(2, 'TR1B', '1', 4, 'Aktif'),
(3, 'TR1K', '2', 0, 'Tidak Aktif'),
(4, 'IUGHS', '1', 0, 'Tidak Aktif'),
(5, 'TR1A', '1', 6, 'Aktif');

-- --------------------------------------------------------

--
-- Struktur dari tabel `mahasiswa`
--

CREATE TABLE `mahasiswa` (
  `id_mahasiswa` int(11) NOT NULL,
  `id_kelas` int(11) NOT NULL,
  `id_periode_akademik` int(11) NOT NULL,
  `nim` varchar(20) NOT NULL,
  `nama_mahasiswa` varchar(50) NOT NULL,
  `email` varchar(50) DEFAULT NULL,
  `no_hp` varchar(20) DEFAULT NULL,
  `saldo_jam_minus_murni` decimal(10,1) NOT NULL DEFAULT 0.0,
  `saldo_jam_minus_kompensasi` decimal(10,1) NOT NULL DEFAULT 0.0,
  `saldo_jam_plus_murni` decimal(10,1) NOT NULL DEFAULT 0.0,
  `saldo_jam_plus_kompensasi` decimal(10,1) NOT NULL DEFAULT 0.0,
  `status_mahasiswa` enum('Aktif','Tidak Aktif','Lulus','Cuti') DEFAULT 'Aktif'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `mahasiswa`
--

INSERT INTO `mahasiswa` (`id_mahasiswa`, `id_kelas`, `id_periode_akademik`, `nim`, `nama_mahasiswa`, `email`, `no_hp`, `saldo_jam_minus_murni`, `saldo_jam_minus_kompensasi`, `saldo_jam_plus_murni`, `saldo_jam_plus_kompensasi`, `status_mahasiswa`) VALUES
(1, 1, 1, '032025001', 'Yoga Margana', 'yoga@simat.test', '081111111111', 7.0, 0.0, 1.0, 1.0, 'Aktif'),
(2, 1, 1, '032025002', 'Fahri Aprilian', 'fahri@simat.test', '082222222222', 0.0, 1.0, 0.0, 1.0, 'Aktif'),
(3, 1, 1, '032025003', 'Nabilah Putri', 'nabilah@simat.test', '083333333333', 3.0, 0.0, 10.0, 10.0, 'Aktif'),
(4, 1, 1, '0987692345', 'Marganaa', 'marganayoga891@gmail.com', '089088752369', 0.0, 0.0, 0.0, 0.0, 'Tidak Aktif'),
(5, 2, 1, '0920250039', 'Mikael', 'mikael@gmail.com', '081298394420', 0.0, 2750.0, 520.0, 1126.0, 'Aktif'),
(6, 2, 1, '0920250035', 'Ridzal', 'Ridzal@gmail.com', '085477325643', 0.0, 0.0, 0.0, 0.0, 'Tidak Aktif'),
(7, 5, 1, '1', 'Mazt', '', '', 20.0, 0.0, 0.0, 0.0, 'Aktif'),
(8, 5, 1, '2', 'Daffa', '', '', 0.0, 1750.0, 0.0, 0.0, 'Aktif'),
(9, 5, 1, '3', 'Rijal', '', '', 0.0, 4250.0, 0.0, 0.0, 'Aktif'),
(10, 5, 1, '4', 'Adit', '', '', 0.0, 0.0, 0.0, 0.0, 'Aktif'),
(11, 5, 1, '5', 'Jonathan', '', '', 0.0, 0.0, 0.0, 0.0, 'Aktif'),
(12, 5, 1, '6', 'Irsyad', '', '', 0.0, 0.0, 0.0, 0.0, 'Aktif'),
(13, 2, 1, '9', 'Hailkal', '', '', 0.0, 0.0, 145.0, 101.0, 'Aktif');

-- --------------------------------------------------------

--
-- Struktur dari tabel `mata_kuliah`
--

CREATE TABLE `mata_kuliah` (
  `id_matakuliah` int(11) NOT NULL,
  `nama_mata_kuliah` varchar(30) NOT NULL,
  `kode_mata_kuliah` varchar(10) NOT NULL,
  `sks` int(11) NOT NULL,
  `semester` enum('1','2','3','4','5','6','7','8') NOT NULL,
  `status_mata_kuliah` enum('Aktif','Tidak Aktif') DEFAULT 'Aktif'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `mata_kuliah`
--

INSERT INTO `mata_kuliah` (`id_matakuliah`, `nama_mata_kuliah`, `kode_mata_kuliah`, `sks`, `semester`, `status_mata_kuliah`) VALUES
(1, 'Pemrograman Web', 'WEB101', 3, '2', 'Aktif'),
(2, 'Basis Data', 'BD101', 3, '2', 'Aktif'),
(3, 'Algoritma Pemrograman', 'ALG101', 3, '1', 'Aktif'),
(4, 'Rekayasa Perangkat Lunak', 'RPL101', 3, '3', 'Aktif'),
(5, 'Pemrograman Berorientasi Objek', 'PBO101', 3, '3', 'Aktif');

-- --------------------------------------------------------

--
-- Struktur dari tabel `pemberian_jam_minus`
--

CREATE TABLE `pemberian_jam_minus` (
  `id_pemberian_jam_minus` int(11) NOT NULL,
  `kategori_pelanggaran` enum('Akademik','Fasilitas','Lainnya') NOT NULL,
  `id_detail_kelas_pada_mata_kuliah` int(11) DEFAULT NULL,
  `keterangan_absensi` enum('Izin','Sakit','Alpa') DEFAULT NULL,
  `id_fasilitas` int(11) DEFAULT NULL,
  `harga_fasilitas_saat_pemberian` decimal(15,2) DEFAULT NULL,
  `nama_pelanggaran` varchar(100) NOT NULL,
  `deskripsi_pelanggaran` text DEFAULT NULL,
  `jumlah_jam_minus` decimal(10,1) NOT NULL,
  `jenis_jam` enum('Murni','Kompensasi') NOT NULL,
  `tanggal_pemberian` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `pemberian_jam_minus`
--

INSERT INTO `pemberian_jam_minus` (`id_pemberian_jam_minus`, `kategori_pelanggaran`, `id_detail_kelas_pada_mata_kuliah`, `keterangan_absensi`, `id_fasilitas`, `harga_fasilitas_saat_pemberian`, `nama_pelanggaran`, `deskripsi_pelanggaran`, `jumlah_jam_minus`, `jenis_jam`, `tanggal_pemberian`) VALUES
(1, 'Akademik', 2, 'Alpa', NULL, NULL, 'Pelanggaran Akademik', NULL, 5.0, 'Murni', '2026-07-06 19:21:40'),
(2, 'Fasilitas', NULL, NULL, 2, 3500000.00, 'Kerusakan Fasilitas', NULL, 1750.0, 'Kompensasi', '2026-07-06 21:11:02'),
(3, 'Fasilitas', NULL, NULL, 3, 8500000.00, 'Kerusakan Fasilitas', NULL, 4250.0, 'Kompensasi', '2026-07-07 10:04:33'),
(4, 'Akademik', 5, 'Izin', NULL, NULL, 'Pelanggaran Akademik', NULL, 20.0, 'Murni', '2026-07-12 04:21:20'),
(5, 'Fasilitas', NULL, NULL, 2, 3500000.00, 'Kerusakan Fasilitas', NULL, 1750.0, 'Kompensasi', '2026-07-14 11:31:43'),
(6, 'Lainnya', NULL, NULL, NULL, NULL, 'Pelanggaran Lainnya', 'eaaa', 1000.0, 'Kompensasi', '2026-07-14 12:15:35');

-- --------------------------------------------------------

--
-- Struktur dari tabel `pengaduan_kerusakan_fasilitas`
--

CREATE TABLE `pengaduan_kerusakan_fasilitas` (
  `id_pengaduan_kerusakan_fasilitas` int(11) NOT NULL,
  `id_fasilitas` int(11) NOT NULL,
  `deskripsi_kerusakan` text NOT NULL,
  `tanggal_pengaduan` datetime NOT NULL,
  `bukti_kerusakan_url` varchar(2048) DEFAULT NULL,
  `pelaku_kerusakan` varchar(50) DEFAULT NULL,
  `status_pengaduan` enum('Menunggu Verifikasi','Diterima','Ditolak') DEFAULT 'Menunggu Verifikasi'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `pengaduan_kerusakan_fasilitas`
--

INSERT INTO `pengaduan_kerusakan_fasilitas` (`id_pengaduan_kerusakan_fasilitas`, `id_fasilitas`, `deskripsi_kerusakan`, `tanggal_pengaduan`, `bukti_kerusakan_url`, `pelaku_kerusakan`, `status_pengaduan`) VALUES
(1, 1, 'Proyektor kelas tidak menyala saat digunakan.', '2026-06-08 22:50:43', 'assets/uploads/pengaduan/dummy-proyektor.jpg', NULL, 'Ditolak'),
(2, 2, 'AC kelas tidak dingin dan mengeluarkan suara bising.', '2026-06-08 22:50:43', 'assets/uploads/pengaduan/dummy-ac.jpg', NULL, 'Diterima'),
(3, 6, 'azhar', '2026-06-12 00:22:50', 'azhar', 'Tidak diketahui', 'Diterima'),
(4, 6, 'azhar', '2026-06-12 00:23:21', 'azhar', 'azhar', 'Ditolak'),
(5, 6, 'azahr', '2026-06-12 00:29:55', 'https://www.youtube.com/', 'azhar', 'Diterima'),
(6, 8, 'aku lempar jir', '2026-06-17 19:31:24', 'data:image/jpeg;base64,/9j/4AAQSkZJRgABAQAAAQABAAD/2wCEAAkGBxISEhUSEhMVFRUXFxYVFhUXFRYVFxgYFxcYGBcVGBUYHSggGBolGxcVITEiJSkrLi4uFx8zODMtNygtLisBCgoKDg0OGhAQGy0lHyUtLS0rKy0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLSstLS0tLS0tLSstLS0tLS0tLf/AABEIAM8A9AMBIgACEQEDEQH/xAAbAAABBQEBAAAAAAAAAAAAAAAAAgMEBQYBB//EADgQAAEDAgMFBgUCBwEBAQAAAAEAAhEDIQQxQQUSUWFxBiKBkaHwEzKxwdFC4RQjUmJygvEHwlP/xAAZAQACAwEAAAAAAAAAAAAAAAADBAABAgX/xAAmEQACAgIDAAICAgMBAAAAAAAAAQIRAyEEEjFBURMiMlJhcaEU/9oADAMBAAIRAxEAPwD3FCEKEBclN4iu1jS5xgBZ3EbZe5x3TuiQAIm3PghZMscfpuGNz8NOhVuzMeXd14g3gjJwGfiFYrcZKStGZRcXTOoQhaKBCEKEBCEkvExIngoQUkueBmYUPH43ds3P6Klq4515g8yEOeRRCQxORoTi2f1BIdj6YvvehWPxGKd8wMD35KIMW6CZMcffglpcuvgaXEX2bV21qY/q8k43aVM6/RYtoJ71+sHyTra5GYI5+/BUuUy//LE1z9osEZm+kW55qWHBYmlif5jLj5h7laSlXR8WbvYDLhUaos11QhiYXHbQA0ReyA9GTkKLSxzHawpIKtNPwppr06hCFZQIQhQgIQhQgIQhQgio8NBJyAkqkxO3twTu2ItnPiIUnbjjDWN/UXEnTutJjzjyVDVrfDgzG7Bvr+0JTkZnDSGcOJSWyFtztAahDCQ0ATY68cuBFlCOOAG848PHSypNp4tpe95Obi4dM4z0sFU4jEuffNugGgSE7ybZ0ceJJUej7O2iHd5v6AXc9J8PytdgcSKjA8WnTgRmF4zsLaLqb90GxkQTkfwV6P2Sx4JNOcwHNnpf0jyTXGydZdWKcrFStGoQhC6AgCEIUICqdo1/5gaMxqrHEVd1pKonOG9v6iw58z5lDm/hG4L5G6j595qOaIM7wkQfC1j5p0lJcUNoKnRntoUjvW1EcLRlKMLj9yG1B/tBm2pHBXdcNcCHAT/UB9QM+qra+AMW16XHGMyLZpKeJp2hyGVNUyU+uNwkGRIjXMi8+ak1alKAN5swYnWM46T6rP8AwKlE91scswecadR+6TicewsJgtqiN0kniLDSIk5BUp0tm+l+F+3Z7SQRYwN0zkQrHAVN8Xs6YIzuJBjyKxjtr1XGd+OkA8comFYbI2sGzvaD9IF7HhYGVvHmgn9GMuKTRrH2mCouMkCffu6h4faLX95tgD8pvlxSdpbQkR76pmWSLjYtGDUqI1XERcHJT8BtpzfmMt5gqhYS6SDAAknnEho55JXx5yI6JSORp2hpwTVM32Fxjagsb8FJWAw+McwgidPBanZ21w8d6xH04p7HmUtMSy4HHa8LZC41wNxkuo4uCEIUICEIUIVPaCd2mRE/EAvlDmuafqsjt2qPhOLpJIhukEX/ADK2HaJhNBzhmwteP9XAn0lYXadUPc4G4LnQOpMG2okLnc3TQ9xDEY502OYUenUiwyXMVUlxPNNNKxWjoXsn4c95p4EfVa3Z+0XMq0nNB3gB3eIAv42jxKxVNyvsK90Mc2xADm6XacvMHzQ3rZWRdtHtdGqHNDmmQQCDxBuClqg7H40PpFuW6bD+11wPC48lfrq45qUU0cScesmgQhC2ZEVqQcIKotqtax262wiT1P8AwK8rVQ0SVl9p1N50nO/1IH0WJm4DT6yT8axEcI+/2Ueu4C4M8oP1UR+IJtkgSlQVInb6X8aBAcRyhpGtr81AbUXZKzZs5VNzYeQA8gqPardeHvyV81ihY+jIQMsHVjGGdSKHf8k5SxAA9PH39F04aO7PvSVHrCEnQ/pl/hqm6ZY6WG02JsTEjQx5ruMxQ436qp2bU', 'azhar', 'Diterima'),
(7, 7, 'kaki patah', '2026-06-25 10:23:15', 'xmxb', 'saya sendiri', 'Menunggu Verifikasi');

-- --------------------------------------------------------

--
-- Struktur dari tabel `pengajar`
--

CREATE TABLE `pengajar` (
  `id_pengajar` int(11) NOT NULL,
  `nip` varchar(20) NOT NULL,
  `nama_pengajar` varchar(50) NOT NULL,
  `email` varchar(50) DEFAULT NULL,
  `no_hp` varchar(20) DEFAULT NULL,
  `status_pengajar` enum('Aktif','Tidak Aktif') DEFAULT 'Aktif'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `pengajar`
--

INSERT INTO `pengajar` (`id_pengajar`, `nip`, `nama_pengajar`, `email`, `no_hp`, `status_pengajar`) VALUES
(1, 'PGR001', 'Budi Santoso', 'pengajar@simat.test', '081200000001', 'Aktif'),
(2, 'PGR002', 'Rina Anggraini fgfyyt', 'pictatatertib@simat.test', '081200000002', 'Aktif'),
(3, 'PGR003', 'Dimas Pratama', 'picaset@simat.test', '081200000003', 'Aktif'),
(4, 'PGR004', 'Siti Rahma', 'pickemahasiswaan@simat.test', '081200000004', 'Aktif'),
(5, '347564576', 'Andi Wijaya', 'kaprodi@simat.test', '081200000005', 'Aktif'),
(6, '00099787', 'poles', 'anjingcepat@gmail.com', '09876543433', 'Tidak Aktif'),
(7, '03485743', 'Nadya E-Learning', 'bodat@hewan.com', '082365479873', 'Tidak Aktif'),
(8, '097764578', 'Irsyad', 'irsyad@gmail.com', '08430834892234', 'Tidak Aktif');

-- --------------------------------------------------------

--
-- Struktur dari tabel `pengajuan_jam_plus`
--

CREATE TABLE `pengajuan_jam_plus` (
  `id_pengajuan_jam_plus` int(11) NOT NULL,
  `id_kegiatan` int(11) DEFAULT NULL,
  `jumlah_jam_plus` decimal(6,1) NOT NULL,
  `jenis_jam` enum('Murni','Kompensasi') NOT NULL,
  `sumber_jam` enum('Prodi','Luar') NOT NULL,
  `tanggal_pengajuan` datetime NOT NULL,
  `deskripsi_pekerjaan` text DEFAULT NULL,
  `nama_pemberi` varchar(50) DEFAULT NULL,
  `dokumen_url` varchar(2048) DEFAULT NULL,
  `status_pengajuan` enum('Menunggu Verifikasi','Disetujui','Ditolak') DEFAULT 'Menunggu Verifikasi',
  `alasan_penolakan` varchar(255) DEFAULT NULL,
  `catatan_verifikasi` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `pengajuan_jam_plus`
--

INSERT INTO `pengajuan_jam_plus` (`id_pengajuan_jam_plus`, `id_kegiatan`, `jumlah_jam_plus`, `jenis_jam`, `sumber_jam`, `tanggal_pengajuan`, `deskripsi_pekerjaan`, `nama_pemberi`, `dokumen_url`, `status_pengajuan`, `alasan_penolakan`, `catatan_verifikasi`) VALUES
(1, 1, 100.0, 'Murni', 'Prodi', '2026-06-25 23:03:13', 'Olahraga', 'Fahri', 'abc', 'Disetujui', NULL, NULL),
(2, 1, 50.0, 'Kompensasi', 'Luar', '2026-06-25 23:55:15', 'Menyapu', 'Agoy', 'abc', 'Disetujui', NULL, NULL),
(3, 1, 100.0, 'Murni', 'Prodi', '2026-06-25 23:55:35', 'Mengepel', 'Agoy', 'abc', 'Ditolak', NULL, NULL),
(4, NULL, 100.0, 'Kompensasi', 'Prodi', '2026-07-02 09:06:26', 'Pulang', 'Adit', 'abc', 'Disetujui', NULL, NULL),
(5, 2, 90.0, 'Murni', 'Luar', '2026-07-02 09:07:26', 'a', 'Fahri', 'a', 'Disetujui', NULL, NULL),
(6, NULL, 1.0, 'Murni', 'Prodi', '2026-07-02 09:13:53', 'aa', 'Agoy', 'a', 'Menunggu Verifikasi', NULL, NULL),
(7, NULL, 50.0, 'Murni', 'Prodi', '2026-07-03 13:32:05', 'abc', 'Rafi', 'abc', 'Ditolak', 'okelah', NULL),
(8, NULL, 20.0, 'Murni', 'Prodi', '2026-07-03 14:47:18', 'Panitia', 'Yoga', 'https://www.bing.com/search?pglt=299&q=apa&cvid=d715390a2ba542ac8f692dee3df6f0fe&gs_lcrp=EgRlZGdlKgYIABBFGDkyBggAEEUYOTIGCAEQRRg80gEHNjU2ajBqN6gCALACAA&FORM=ANNTA1&PC=U531', 'Disetujui', NULL, NULL),
(9, NULL, 10.0, 'Murni', 'Prodi', '2026-07-11 18:15:33', 'a', 'Fahri', 'a', 'Disetujui', NULL, NULL),
(10, NULL, 10.0, 'Kompensasi', 'Prodi', '2026-07-11 18:16:51', 'a', 'a', 'a', 'Disetujui', NULL, NULL),
(11, 2, 100.0, 'Murni', 'Luar', '2026-07-13 23:16:06', 'qw', 'lokal', 'qw', 'Menunggu Verifikasi', NULL, NULL),
(12, 2, 1000.0, 'Murni', 'Luar', '2026-07-13 23:32:01', 'jj', 'asas', 'https://www.google.com/search?q=kucing&oq=kucing&gs_lcrp=EgZjaHJvbWUqDQgAEAAY4wIYsQMYgAQyDQgAEAAY4wIYsQMYgAQyCggBEC4YsQMYgAQyCggCEAAYsQMYgAQyBwgDEAAYgAQyCggEEC4YsQMYgAQyCggFEC4YsQMYgAQyCggGEC4YsQMYgAQyCggHEC4YsQMYgAQyCggIEC4YsQMYgAQyCggJEC4YsQMYgATSAQc5MDlqMGo0qAIAsAIB&sourceid=chrome&source=chrome.ob&ie=UTF-8', 'Disetujui', NULL, NULL),
(13, NULL, 1000.0, 'Kompensasi', 'Prodi', '2026-07-14 12:17:23', 'aspijdas', 'mas bray', 'https://www.google.com/search?q=kucing&oq=kucing&gs_lcrp=EgZjaHJvbWUqDQgAEAAY4wIYsQMYgAQyDQgAEAAY4wIYsQMYgAQyCggBEC4YsQMYgAQyCggCEAAYsQMYgAQyBwgDEAAYgAQyCggEEC4YsQMYgAQyCggFEC4YsQMYgAQyCggGEC4YsQMYgAQyCggHEC4YsQMYgAQyCggIEC4YsQMYgAQyCggJEC4YsQMYgATSAQc5MDlqMGo0qAIAsAIB&sourceid=chrome&source=chrome.ob&ie=UTF-8', 'Disetujui', NULL, NULL);

-- --------------------------------------------------------

--
-- Struktur dari tabel `pengguna`
--

CREATE TABLE `pengguna` (
  `id_pengguna` int(11) NOT NULL,
  `id_mahasiswa` int(11) DEFAULT NULL,
  `id_pengajar` int(11) DEFAULT NULL,
  `username` varchar(50) NOT NULL,
  `password` varchar(255) NOT NULL,
  `role` enum('Mahasiswa','Pengajar','PIC Tata Tertib','PIC Aset Fasilitas','PIC Kemahasiswaan','Kepala Prodi') NOT NULL,
  `status_akun` enum('Aktif','Tidak Aktif') DEFAULT 'Aktif'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `pengguna`
--

INSERT INTO `pengguna` (`id_pengguna`, `id_mahasiswa`, `id_pengajar`, `username`, `password`, `role`, `status_akun`) VALUES
(1, 1, NULL, 'mahasiswa@simat.net', '1234', 'Mahasiswa', 'Tidak Aktif'),
(2, NULL, 1, 'pengajar@simat.test', '123', 'Pengajar', 'Aktif'),
(3, NULL, 2, 'pictatatertib@simat.test', '123', 'PIC Tata Tertib', 'Aktif'),
(4, NULL, 3, 'picaset@simat.test', '123', 'PIC Aset Fasilitas', 'Aktif'),
(5, NULL, 4, 'pickemahasiswaan@simat.test', '123', 'PIC Kemahasiswaan', 'Aktif'),
(6, NULL, 5, 'kaprodi@simat.test', '123', 'Kepala Prodi', 'Aktif'),
(7, 1, NULL, 'yogaenjoy', '123', 'Mahasiswa', 'Aktif'),
(8, NULL, 7, 'bodat', '098', 'Pengajar', 'Tidak Aktif'),
(9, 5, NULL, 'mika', '123', 'Mahasiswa', 'Aktif'),
(10, 2, NULL, 'Fahri', '321', 'Mahasiswa', 'Aktif'),
(11, 6, NULL, 'ridzal', '123', 'Mahasiswa', 'Tidak Aktif'),
(12, 10, NULL, 'adit', '123', 'Mahasiswa', 'Aktif'),
(13, 8, NULL, 'daffa', '123', 'Mahasiswa', 'Aktif'),
(14, 7, NULL, 'mazt', '123', 'Mahasiswa', 'Aktif'),
(15, 3, NULL, 'nabilah', '123', 'Mahasiswa', 'Aktif'),
(16, 9, NULL, 'rijal', '123', 'Mahasiswa', 'Aktif'),
(17, 12, NULL, 'irsyad', '123', 'Mahasiswa', 'Aktif'),
(18, 11, NULL, 'jo', '123', 'Mahasiswa', 'Aktif'),
(19, 13, NULL, 'haikal', '123', 'Mahasiswa', 'Aktif');

-- --------------------------------------------------------

--
-- Struktur dari tabel `periode_akademik`
--

CREATE TABLE `periode_akademik` (
  `id_periode_akademik` int(11) NOT NULL,
  `tahun_akademik` varchar(10) NOT NULL,
  `semester` enum('Ganjil','Genap') NOT NULL,
  `tanggal_mulai` datetime NOT NULL,
  `tanggal_selesai` datetime NOT NULL,
  `status_periode` enum('Aktif','Tidak Aktif') DEFAULT 'Aktif'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `periode_akademik`
--

INSERT INTO `periode_akademik` (`id_periode_akademik`, `tahun_akademik`, `semester`, `tanggal_mulai`, `tanggal_selesai`, `status_periode`) VALUES
(1, '2025/2026', 'Genap', '2026-02-01 00:00:00', '2026-07-31 23:59:59', 'Aktif');

--
-- Indexes for dumped tables
--

--
-- Indeks untuk tabel `bursa_jobdesc`
--
ALTER TABLE `bursa_jobdesc`
  ADD PRIMARY KEY (`id_bursa_jobdesc`);

--
-- Indeks untuk tabel `detail_fasilitas_pada_kelas`
--
ALTER TABLE `detail_fasilitas_pada_kelas`
  ADD PRIMARY KEY (`id_detail_fasilitas_pada_kelas`),
  ADD KEY `fk_detail_fasilitas_kelas` (`id_kelas`),
  ADD KEY `fk_detail_fasilitas_fasilitas` (`id_fasilitas`);

--
-- Indeks untuk tabel `detail_kelas_pada_mata_kuliah`
--
ALTER TABLE `detail_kelas_pada_mata_kuliah`
  ADD PRIMARY KEY (`id_detail_kelas_pada_mata_kuliah`),
  ADD UNIQUE KEY `uq_kelas_mata_kuliah` (`id_kelas`,`id_mata_kuliah`),
  ADD KEY `fk_detail_kelas_mk_mk` (`id_mata_kuliah`),
  ADD KEY `fk_detail_kelas_mk_kelas` (`id_kelas`);

--
-- Indeks untuk tabel `detail_pengajar_pada_mata_kuliah`
--
ALTER TABLE `detail_pengajar_pada_mata_kuliah`
  ADD PRIMARY KEY (`id_detail_pengajar_pada_mata_kuliah`),
  ADD UNIQUE KEY `uq_detail_pengajar_unik` (`id_detail_kelas_pada_mata_kuliah`,`id_pengajar`),
  ADD UNIQUE KEY `uq_detail_kedudukan_unik` (`id_detail_kelas_pada_mata_kuliah`,`kedudukan_pengajar`),
  ADD KEY `fk_detail_pengajar_pengajar` (`id_pengajar`);

--
-- Indeks untuk tabel `detail_pengguna_pada_bursa_jobdesc`
--
ALTER TABLE `detail_pengguna_pada_bursa_jobdesc`
  ADD PRIMARY KEY (`id_detail_pengguna_pada_bursa_jobdesc`),
  ADD KEY `fk_detail_pengguna_bursa` (`id_bursa_jobdesc`),
  ADD KEY `fk_detail_bursa_pengguna` (`id_pengguna`),
  ADD KEY `idx_laporan_bursa_pemberi` (`peran_pengguna`,`id_pengguna`,`id_bursa_jobdesc`);

--
-- Indeks untuk tabel `detail_pengguna_pada_pemberian_jam_minus`
--
ALTER TABLE `detail_pengguna_pada_pemberian_jam_minus`
  ADD PRIMARY KEY (`id_detail_pengguna_pada_pemberian_jam_minus`),
  ADD UNIQUE KEY `uq_pjm_satu_peran` (`id_pemberian_jam_minus`,`peran_pengguna`),
  ADD KEY `fk_detail_pengguna_jam_minus` (`id_pemberian_jam_minus`),
  ADD KEY `fk_detail_jam_minus_pengguna` (`id_pengguna`);

--
-- Indeks untuk tabel `detail_pengguna_pada_pengaduan_kerusakan_fasilitas`
--
ALTER TABLE `detail_pengguna_pada_pengaduan_kerusakan_fasilitas`
  ADD PRIMARY KEY (`id_detail_pengguna_pada_pengaduan_kerusakan_fasilitas`),
  ADD KEY `fk_detail_pengguna_pengaduan` (`id_pengaduan_kerusakan_fasilitas`),
  ADD KEY `fk_detail_pengaduan_pengguna` (`id_pengguna`),
  ADD KEY `idx_laporan_pengaduan_pelapor` (`peran_pengguna`,`id_pengaduan_kerusakan_fasilitas`,`id_pengguna`);

--
-- Indeks untuk tabel `detail_pengguna_pada_pengajuan_jam_plus`
--
ALTER TABLE `detail_pengguna_pada_pengajuan_jam_plus`
  ADD PRIMARY KEY (`id_detail_pengguna_pada_pengajuan_jam_plus`),
  ADD KEY `fk_detail_pengguna_pengajuan` (`id_pengajuan_jam_plus`),
  ADD KEY `fk_detail_pengajuan_pengguna` (`id_pengguna`);

--
-- Indeks untuk tabel `fasilitas`
--
ALTER TABLE `fasilitas`
  ADD PRIMARY KEY (`id_fasilitas`);

--
-- Indeks untuk tabel `kegiatan`
--
ALTER TABLE `kegiatan`
  ADD PRIMARY KEY (`id_kegiatan`);

--
-- Indeks untuk tabel `kelas`
--
ALTER TABLE `kelas`
  ADD PRIMARY KEY (`id_kelas`);

--
-- Indeks untuk tabel `mahasiswa`
--
ALTER TABLE `mahasiswa`
  ADD PRIMARY KEY (`id_mahasiswa`),
  ADD UNIQUE KEY `nim` (`nim`),
  ADD KEY `fk_mahasiswa_kelas` (`id_kelas`),
  ADD KEY `fk_mahasiswa_periode` (`id_periode_akademik`);

--
-- Indeks untuk tabel `mata_kuliah`
--
ALTER TABLE `mata_kuliah`
  ADD PRIMARY KEY (`id_matakuliah`),
  ADD UNIQUE KEY `uq_mata_kuliah_id` (`id_matakuliah`),
  ADD UNIQUE KEY `uq_kode_mata_kuliah` (`kode_mata_kuliah`);

--
-- Indeks untuk tabel `pemberian_jam_minus`
--
ALTER TABLE `pemberian_jam_minus`
  ADD PRIMARY KEY (`id_pemberian_jam_minus`),
  ADD KEY `idx_pjm_kategori` (`kategori_pelanggaran`),
  ADD KEY `idx_pjm_detail_kelas_mata_kuliah` (`id_detail_kelas_pada_mata_kuliah`),
  ADD KEY `idx_pjm_fasilitas` (`id_fasilitas`),
  ADD KEY `idx_pjm_tanggal` (`tanggal_pemberian`);

--
-- Indeks untuk tabel `pengaduan_kerusakan_fasilitas`
--
ALTER TABLE `pengaduan_kerusakan_fasilitas`
  ADD PRIMARY KEY (`id_pengaduan_kerusakan_fasilitas`),
  ADD KEY `fk_pengaduan_fasilitas` (`id_fasilitas`);

--
-- Indeks untuk tabel `pengajar`
--
ALTER TABLE `pengajar`
  ADD PRIMARY KEY (`id_pengajar`),
  ADD UNIQUE KEY `nip` (`nip`);

--
-- Indeks untuk tabel `pengajuan_jam_plus`
--
ALTER TABLE `pengajuan_jam_plus`
  ADD PRIMARY KEY (`id_pengajuan_jam_plus`),
  ADD KEY `fk_pengajuan_jam_plus_kegiatan` (`id_kegiatan`);

--
-- Indeks untuk tabel `pengguna`
--
ALTER TABLE `pengguna`
  ADD PRIMARY KEY (`id_pengguna`),
  ADD UNIQUE KEY `username` (`username`),
  ADD KEY `fk_pengguna_mahasiswa` (`id_mahasiswa`),
  ADD KEY `fk_pengguna_pengajar` (`id_pengajar`);

--
-- Indeks untuk tabel `periode_akademik`
--
ALTER TABLE `periode_akademik`
  ADD PRIMARY KEY (`id_periode_akademik`);

--
-- AUTO_INCREMENT untuk tabel yang dibuang
--

--
-- AUTO_INCREMENT untuk tabel `bursa_jobdesc`
--
ALTER TABLE `bursa_jobdesc`
  MODIFY `id_bursa_jobdesc` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT untuk tabel `detail_fasilitas_pada_kelas`
--
ALTER TABLE `detail_fasilitas_pada_kelas`
  MODIFY `id_detail_fasilitas_pada_kelas` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT untuk tabel `detail_kelas_pada_mata_kuliah`
--
ALTER TABLE `detail_kelas_pada_mata_kuliah`
  MODIFY `id_detail_kelas_pada_mata_kuliah` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT untuk tabel `detail_pengajar_pada_mata_kuliah`
--
ALTER TABLE `detail_pengajar_pada_mata_kuliah`
  MODIFY `id_detail_pengajar_pada_mata_kuliah` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=23;

--
-- AUTO_INCREMENT untuk tabel `detail_pengguna_pada_bursa_jobdesc`
--
ALTER TABLE `detail_pengguna_pada_bursa_jobdesc`
  MODIFY `id_detail_pengguna_pada_bursa_jobdesc` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=34;

--
-- AUTO_INCREMENT untuk tabel `detail_pengguna_pada_pemberian_jam_minus`
--
ALTER TABLE `detail_pengguna_pada_pemberian_jam_minus`
  MODIFY `id_detail_pengguna_pada_pemberian_jam_minus` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT untuk tabel `detail_pengguna_pada_pengaduan_kerusakan_fasilitas`
--
ALTER TABLE `detail_pengguna_pada_pengaduan_kerusakan_fasilitas`
  MODIFY `id_detail_pengguna_pada_pengaduan_kerusakan_fasilitas` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- AUTO_INCREMENT untuk tabel `detail_pengguna_pada_pengajuan_jam_plus`
--
ALTER TABLE `detail_pengguna_pada_pengajuan_jam_plus`
  MODIFY `id_detail_pengguna_pada_pengajuan_jam_plus` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=25;

--
-- AUTO_INCREMENT untuk tabel `fasilitas`
--
ALTER TABLE `fasilitas`
  MODIFY `id_fasilitas` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT untuk tabel `kegiatan`
--
ALTER TABLE `kegiatan`
  MODIFY `id_kegiatan` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT untuk tabel `kelas`
--
ALTER TABLE `kelas`
  MODIFY `id_kelas` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT untuk tabel `mahasiswa`
--
ALTER TABLE `mahasiswa`
  MODIFY `id_mahasiswa` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT untuk tabel `mata_kuliah`
--
ALTER TABLE `mata_kuliah`
  MODIFY `id_matakuliah` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT untuk tabel `pemberian_jam_minus`
--
ALTER TABLE `pemberian_jam_minus`
  MODIFY `id_pemberian_jam_minus` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT untuk tabel `pengaduan_kerusakan_fasilitas`
--
ALTER TABLE `pengaduan_kerusakan_fasilitas`
  MODIFY `id_pengaduan_kerusakan_fasilitas` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT untuk tabel `pengajar`
--
ALTER TABLE `pengajar`
  MODIFY `id_pengajar` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT untuk tabel `pengajuan_jam_plus`
--
ALTER TABLE `pengajuan_jam_plus`
  MODIFY `id_pengajuan_jam_plus` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT untuk tabel `pengguna`
--
ALTER TABLE `pengguna`
  MODIFY `id_pengguna` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=20;

--
-- AUTO_INCREMENT untuk tabel `periode_akademik`
--
ALTER TABLE `periode_akademik`
  MODIFY `id_periode_akademik` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- Ketidakleluasaan untuk tabel pelimpahan (Dumped Tables)
--

--
-- Ketidakleluasaan untuk tabel `detail_fasilitas_pada_kelas`
--
ALTER TABLE `detail_fasilitas_pada_kelas`
  ADD CONSTRAINT `fk_detail_fasilitas_fasilitas` FOREIGN KEY (`id_fasilitas`) REFERENCES `fasilitas` (`id_fasilitas`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_detail_fasilitas_kelas` FOREIGN KEY (`id_kelas`) REFERENCES `kelas` (`id_kelas`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Ketidakleluasaan untuk tabel `detail_kelas_pada_mata_kuliah`
--
ALTER TABLE `detail_kelas_pada_mata_kuliah`
  ADD CONSTRAINT `fk_detail_kelas_mk_kelas` FOREIGN KEY (`id_kelas`) REFERENCES `kelas` (`id_kelas`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_detail_kelas_mk_mk` FOREIGN KEY (`id_mata_kuliah`) REFERENCES `mata_kuliah` (`id_matakuliah`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Ketidakleluasaan untuk tabel `detail_pengajar_pada_mata_kuliah`
--
ALTER TABLE `detail_pengajar_pada_mata_kuliah`
  ADD CONSTRAINT `fk_detail_pengajar_mk` FOREIGN KEY (`id_detail_kelas_pada_mata_kuliah`) REFERENCES `detail_kelas_pada_mata_kuliah` (`id_detail_kelas_pada_mata_kuliah`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_detail_pengajar_pengajar` FOREIGN KEY (`id_pengajar`) REFERENCES `pengajar` (`id_pengajar`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Ketidakleluasaan untuk tabel `detail_pengguna_pada_bursa_jobdesc`
--
ALTER TABLE `detail_pengguna_pada_bursa_jobdesc`
  ADD CONSTRAINT `fk_detail_bursa_pengguna` FOREIGN KEY (`id_pengguna`) REFERENCES `pengguna` (`id_pengguna`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_detail_pengguna_bursa` FOREIGN KEY (`id_bursa_jobdesc`) REFERENCES `bursa_jobdesc` (`id_bursa_jobdesc`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Ketidakleluasaan untuk tabel `detail_pengguna_pada_pemberian_jam_minus`
--
ALTER TABLE `detail_pengguna_pada_pemberian_jam_minus`
  ADD CONSTRAINT `fk_detail_jam_minus_pengguna` FOREIGN KEY (`id_pengguna`) REFERENCES `pengguna` (`id_pengguna`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_detail_pengguna_jam_minus` FOREIGN KEY (`id_pemberian_jam_minus`) REFERENCES `pemberian_jam_minus` (`id_pemberian_jam_minus`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Ketidakleluasaan untuk tabel `detail_pengguna_pada_pengaduan_kerusakan_fasilitas`
--
ALTER TABLE `detail_pengguna_pada_pengaduan_kerusakan_fasilitas`
  ADD CONSTRAINT `fk_detail_pengaduan_pengguna` FOREIGN KEY (`id_pengguna`) REFERENCES `pengguna` (`id_pengguna`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_detail_pengguna_pengaduan` FOREIGN KEY (`id_pengaduan_kerusakan_fasilitas`) REFERENCES `pengaduan_kerusakan_fasilitas` (`id_pengaduan_kerusakan_fasilitas`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Ketidakleluasaan untuk tabel `detail_pengguna_pada_pengajuan_jam_plus`
--
ALTER TABLE `detail_pengguna_pada_pengajuan_jam_plus`
  ADD CONSTRAINT `fk_detail_pengajuan_pengguna` FOREIGN KEY (`id_pengguna`) REFERENCES `pengguna` (`id_pengguna`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_detail_pengguna_pengajuan` FOREIGN KEY (`id_pengajuan_jam_plus`) REFERENCES `pengajuan_jam_plus` (`id_pengajuan_jam_plus`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Ketidakleluasaan untuk tabel `mahasiswa`
--
ALTER TABLE `mahasiswa`
  ADD CONSTRAINT `fk_mahasiswa_kelas` FOREIGN KEY (`id_kelas`) REFERENCES `kelas` (`id_kelas`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_mahasiswa_periode` FOREIGN KEY (`id_periode_akademik`) REFERENCES `periode_akademik` (`id_periode_akademik`) ON UPDATE CASCADE;

--
-- Ketidakleluasaan untuk tabel `pemberian_jam_minus`
--
ALTER TABLE `pemberian_jam_minus`
  ADD CONSTRAINT `fk_pjm_detail_kelas_mata_kuliah` FOREIGN KEY (`id_detail_kelas_pada_mata_kuliah`) REFERENCES `detail_kelas_pada_mata_kuliah` (`id_detail_kelas_pada_mata_kuliah`) ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_pjm_fasilitas` FOREIGN KEY (`id_fasilitas`) REFERENCES `fasilitas` (`id_fasilitas`) ON DELETE NO ACTION ON UPDATE CASCADE;

--
-- Ketidakleluasaan untuk tabel `pengaduan_kerusakan_fasilitas`
--
ALTER TABLE `pengaduan_kerusakan_fasilitas`
  ADD CONSTRAINT `fk_pengaduan_fasilitas` FOREIGN KEY (`id_fasilitas`) REFERENCES `fasilitas` (`id_fasilitas`) ON UPDATE CASCADE;

--
-- Ketidakleluasaan untuk tabel `pengajuan_jam_plus`
--
ALTER TABLE `pengajuan_jam_plus`
  ADD CONSTRAINT `fk_pengajuan_jam_plus_kegiatan` FOREIGN KEY (`id_kegiatan`) REFERENCES `kegiatan` (`id_kegiatan`) ON UPDATE CASCADE;

--
-- Ketidakleluasaan untuk tabel `pengguna`
--
ALTER TABLE `pengguna`
  ADD CONSTRAINT `fk_pengguna_mahasiswa` FOREIGN KEY (`id_mahasiswa`) REFERENCES `mahasiswa` (`id_mahasiswa`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_pengguna_pengajar` FOREIGN KEY (`id_pengajar`) REFERENCES `pengajar` (`id_pengajar`) ON DELETE SET NULL ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
