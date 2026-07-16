-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Waktu pembuatan: 15 Jul 2026 pada 18.55
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
CREATE DEFINER=`root`@`localhost` PROCEDURE `usp_catat_login_pengguna` (IN `p_id_pengguna` INT)   BEGIN
    UPDATE pengguna
    SET login_terakhir_at = NOW(6)
    WHERE id_pengguna = p_id_pengguna
      AND status_akun = 'Aktif';

    IF ROW_COUNT() = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Pengguna aktif tidak ditemukan';
    END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `usp_cek_kegiatan_aktif` (IN `p_nama_kegiatan` VARCHAR(50), IN `p_penyelenggara` VARCHAR(20), IN `p_tanggal_kegiatan` DATE, IN `p_id_kegiatan_abaikan` INT)   BEGIN SELECT COUNT(*) AS jumlah FROM kegiatan WHERE status_kegiatan='Aktif' AND UPPER(TRIM(nama_kegiatan))=UPPER(TRIM(p_nama_kegiatan)) AND penyelenggara=p_penyelenggara AND tanggal_kegiatan <=> p_tanggal_kegiatan AND (p_id_kegiatan_abaikan IS NULL OR id_kegiatan<>p_id_kegiatan_abaikan); END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `usp_cek_nama_fasilitas_aktif` (IN `p_nama_fasilitas` VARCHAR(50), IN `p_id_fasilitas_abaikan` INT)   BEGIN SELECT COUNT(*) AS jumlah FROM fasilitas WHERE status_fasilitas='Aktif' AND UPPER(TRIM(nama_fasilitas))=UPPER(TRIM(p_nama_fasilitas)) AND (p_id_fasilitas_abaikan IS NULL OR id_fasilitas<>p_id_fasilitas_abaikan); END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `usp_cek_nama_kelas_aktif` (IN `p_nama_kelas` VARCHAR(5), IN `p_id_kelas_abaikan` INT)   BEGIN
 SELECT COUNT(*) AS jumlah FROM kelas WHERE status_kelas='Aktif' AND UPPER(TRIM(nama_kelas))=UPPER(TRIM(p_nama_kelas)) AND (p_id_kelas_abaikan IS NULL OR id_kelas<>p_id_kelas_abaikan);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `usp_cek_nim_mahasiswa` (IN `p_nim` VARCHAR(20), IN `p_id_mahasiswa_abaikan` INT)   BEGIN SELECT COUNT(*) AS jumlah FROM mahasiswa WHERE nim=p_nim AND (p_id_mahasiswa_abaikan IS NULL OR id_mahasiswa<>p_id_mahasiswa_abaikan); END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `usp_cek_nip_pengajar` (IN `p_nip` VARCHAR(20), IN `p_id_pengajar_abaikan` INT)   BEGIN SELECT COUNT(*) AS jumlah FROM pengajar WHERE nip=p_nip AND (p_id_pengajar_abaikan IS NULL OR id_pengajar<>p_id_pengajar_abaikan); END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `usp_cek_periode_akademik` (IN `p_tahun` VARCHAR(10), IN `p_semester` VARCHAR(10), IN `p_id_abaikan` INT)   BEGIN SELECT COUNT(*) AS jumlah FROM periode_akademik WHERE tahun_akademik=p_tahun AND semester=p_semester AND (p_id_abaikan IS NULL OR id_periode_akademik<>p_id_abaikan); END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `usp_cek_username_pengguna` (IN `p_username` VARCHAR(20), IN `p_id_pengguna_abaikan` INT)   BEGIN SELECT COUNT(*) AS jumlah FROM pengguna WHERE username=p_username AND (p_id_pengguna_abaikan IS NULL OR id_pengguna<>p_id_pengguna_abaikan); END$$

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
          AND status_akun = 'Aktif'
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
        SELECT 1 FROM mahasiswa
        WHERE id_mahasiswa = v_id_mahasiswa AND status_mahasiswa = 'Aktif'
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Data mahasiswa tidak aktif';
    END IF;

    IF NOT EXISTS (
        SELECT 1
        FROM bursa_jobdesc
        WHERE id_bursa_jobdesc = p_id_bursa_jobdesc
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Data bursa jobdesc tidak ditemukan';
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

    IF EXISTS (
        SELECT 1
        FROM detail_pengguna_pada_bursa_jobdesc
        WHERE id_bursa_jobdesc = p_id_bursa_jobdesc
          AND id_pengguna = p_id_pengguna
          AND peran_pengguna = 'Penerima'
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Kamu sudah mendaftar jobdesc ini';
    END IF;

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

CREATE DEFINER=`root`@`localhost` PROCEDURE `usp_dashboard_ringkasan` (IN `p_id_pengguna` INT)   BEGIN
    SELECT
        (SELECT COUNT(*) FROM pengguna WHERE status_akun = 'Aktif') AS total_pengguna,
        (SELECT COUNT(*) FROM mahasiswa WHERE status_mahasiswa = 'Aktif') AS total_mahasiswa,
        (SELECT COUNT(*) FROM pengajar WHERE status_pengajar = 'Aktif') AS total_pengajar,
        (SELECT COUNT(*) FROM fasilitas WHERE status_fasilitas = 'Aktif') AS total_fasilitas,
        (SELECT COUNT(*) FROM kelas WHERE status_kelas = 'Aktif') AS total_kelas,
        (SELECT COUNT(*) FROM mata_kuliah WHERE status_mata_kuliah = 'Aktif') AS total_mata_kuliah_aktif,
        (SELECT COUNT(*) FROM kegiatan WHERE status_kegiatan = 'Aktif') AS total_kegiatan_aktif,
        (SELECT COUNT(*) FROM pengaduan_kerusakan_fasilitas) AS total_pengaduan,
        (SELECT COUNT(*) FROM pengaduan_kerusakan_fasilitas WHERE status_pengaduan = 'Menunggu Verifikasi') AS pengaduan_menunggu,
        (SELECT COUNT(*) FROM detail_fasilitas_pada_kelas WHERE status_detail_fasilitas_pada_kelas = 'Rusak') AS fasilitas_rusak,
        (
            SELECT COUNT(DISTINCT d.id_bursa_jobdesc)
            FROM detail_pengguna_pada_bursa_jobdesc d
            WHERE d.id_pengguna = p_id_pengguna
              AND d.peran_pengguna = 'Pemberi'
        ) AS jobdesc_saya,
        (
            SELECT COUNT(DISTINCT d.id_bursa_jobdesc)
            FROM detail_pengguna_pada_bursa_jobdesc d
            JOIN bursa_jobdesc bj
              ON bj.id_bursa_jobdesc = d.id_bursa_jobdesc
            JOIN pengguna pemberi
              ON pemberi.id_pengguna = d.id_pengguna
            JOIN pengguna pengguna_login
              ON pengguna_login.id_pengguna = p_id_pengguna
            WHERE d.peran_pengguna = 'Pemberi'
              AND pemberi.id_pengajar = pengguna_login.id_pengajar
              AND pengguna_login.id_pengajar IS NOT NULL
              AND bj.status_jobdesc = 'Dikerjakan'
        ) AS jobdesc_dikerjakan_saya,
        (SELECT COUNT(*) FROM bursa_jobdesc WHERE status_jobdesc = 'Dibuka') AS jobdesc_tersedia,
        (
            SELECT COUNT(DISTINCT d.id_bursa_jobdesc)
            FROM detail_pengguna_pada_bursa_jobdesc d
            WHERE d.id_pengguna = p_id_pengguna
              AND d.peran_pengguna = 'Penerima'
        ) AS jobdesc_diambil,
        (
            SELECT COUNT(DISTINCT d.id_pengaduan_kerusakan_fasilitas)
            FROM detail_pengguna_pada_pengaduan_kerusakan_fasilitas d
            WHERE d.id_pengguna = p_id_pengguna
              AND d.peran_pengguna = 'Pelapor'
        ) AS pengaduan_saya,
        (
            SELECT COUNT(DISTINCT d.id_pengaduan_kerusakan_fasilitas)
            FROM detail_pengguna_pada_pengaduan_kerusakan_fasilitas d
            JOIN pengaduan_kerusakan_fasilitas q
              ON q.id_pengaduan_kerusakan_fasilitas = d.id_pengaduan_kerusakan_fasilitas
            WHERE d.id_pengguna = p_id_pengguna
              AND d.peran_pengguna = 'Pelapor'
              AND q.status_pengaduan = 'Menunggu Verifikasi'
        ) AS pengaduan_menunggu_saya,
        (
            SELECT COUNT(DISTINCT d.id_pengajuan_jam_plus)
            FROM detail_pengguna_pada_pengajuan_jam_plus d
            JOIN pengajuan_jam_plus j
              ON j.id_pengajuan_jam_plus = d.id_pengajuan_jam_plus
            WHERE d.id_pengguna = p_id_pengguna
              AND d.peran_pengguna = 'Pengaju'
              AND j.status_pengajuan = 'Menunggu Verifikasi'
        ) AS jam_plus_menunggu,
        (
            SELECT COUNT(*)
            FROM pengajuan_jam_plus
            WHERE status_pengajuan = 'Menunggu Verifikasi'
        ) AS total_pengajuan_jam_plus_menunggu,
        (
            SELECT COUNT(*)
            FROM mahasiswa m
            WHERE m.status_mahasiswa = 'Aktif'
              AND ufn_hitung_total_jam_mahasiswa(m.id_mahasiswa) < 0
        ) AS total_mahasiswa_jam_negatif,
        (
            SELECT COUNT(*)
            FROM mahasiswa m
            WHERE m.status_mahasiswa = 'Aktif'
              AND ufn_hitung_total_jam_mahasiswa(m.id_mahasiswa) > 0
        ) AS total_mahasiswa_jam_positif,
        COALESCE((
            SELECT ufn_hitung_total_jam_kompensasi_mahasiswa(p.id_mahasiswa)
            FROM pengguna p
            WHERE p.id_pengguna = p_id_pengguna
            LIMIT 1
        ), 0.0) AS total_jam_kompensasi_mahasiswa,
        COALESCE((
            SELECT ufn_hitung_total_jam_murni_mahasiswa(p.id_mahasiswa)
            FROM pengguna p
            WHERE p.id_pengguna = p_id_pengguna
            LIMIT 1
        ), 0.0) AS total_jam_murni_mahasiswa,
        COALESCE((
            SELECT ufn_hitung_total_jam_mahasiswa(p.id_mahasiswa)
            FROM pengguna p
            WHERE p.id_pengguna = p_id_pengguna
            LIMIT 1
        ), 0.0) AS total_jam_mahasiswa;
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

CREATE DEFINER=`root`@`localhost` PROCEDURE `usp_get_peran_bursa_jobdesc` (IN `p_id_jobdesc` INT, IN `p_id_pengguna` INT)   BEGIN
    SELECT peran_pengguna FROM detail_pengguna_pada_bursa_jobdesc
    WHERE id_bursa_jobdesc=p_id_jobdesc AND id_pengguna=p_id_pengguna LIMIT 1;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `usp_get_total_jam_minus_mahasiswa` (IN `p_id_mahasiswa` INT)   BEGIN
    SELECT ufn_total_jam_minus_mahasiswa(p_id_mahasiswa) AS total_jam_minus;
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
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Data pengguna tidak ditemukan';
    END IF;

    SELECT role
    INTO v_role
    FROM pengguna
    WHERE id_pengguna = p_id_pengguna;

    IF v_role = 'Mahasiswa' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Mahasiswa tidak dapat membuat bursa jobdesc';
    END IF;

    IF p_penerima_jobdesc NOT IN (
        'Semua Mahasiswa',
        'Mahasiswa dengan Jam Minus'
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Pilihan penerima jobdesc tidak valid';
    END IF;

    IF p_jam_plus <= 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Jam plus harus lebih dari 0';
    END IF;

    IF p_jumlah_mahasiswa_diperlukan <= 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Jumlah mahasiswa diperlukan harus lebih dari 0';
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
        p_deskripsi_jobdesc,
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
        'Bursa jobdesc berhasil ditambahkan' AS Pesan,
        v_id_bursa_jobdesc AS id_bursa_jobdesc;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `usp_insert_detail_fasilitas_pada_kelas` (IN `p_id_kelas` INT, IN `p_id_fasilitas` INT)   BEGIN
    IF NOT EXISTS (SELECT 1 FROM kelas WHERE id_kelas = p_id_kelas AND status_kelas = 'Aktif') THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Kelas tidak ditemukan atau tidak aktif'; END IF;
    IF NOT EXISTS (SELECT 1 FROM fasilitas WHERE id_fasilitas = p_id_fasilitas AND status_fasilitas = 'Aktif') THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Fasilitas tidak ditemukan atau tidak aktif'; END IF;
    IF EXISTS (SELECT 1 FROM detail_fasilitas_pada_kelas WHERE id_kelas = p_id_kelas AND id_fasilitas = p_id_fasilitas) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Fasilitas sudah terhubung ke kelas tersebut'; END IF;
    INSERT INTO detail_fasilitas_pada_kelas (id_kelas, id_fasilitas, status_detail_fasilitas_pada_kelas) VALUES (p_id_kelas, p_id_fasilitas, 'Aktif');
    SELECT 'Data fasilitas kelas berhasil ditambahkan' AS Pesan, LAST_INSERT_ID() AS id_detail_fasilitas_pada_kelas;
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

CREATE DEFINER=`root`@`localhost` PROCEDURE `usp_insert_fasilitas` (IN `p_nama_fasilitas` VARCHAR(50), IN `p_harga` DECIMAL(15,2), IN `p_id_kelas_csv` TEXT)   BEGIN
    DECLARE v_id_fasilitas INT;
    DECLARE v_csv TEXT;
    DECLARE v_token VARCHAR(30);
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        DROP TEMPORARY TABLE IF EXISTS tmp_kelas_fasilitas;
        RESIGNAL;
    END;

    SET p_nama_fasilitas = TRIM(p_nama_fasilitas);
    SET v_csv = TRIM(BOTH ',' FROM COALESCE(p_id_kelas_csv, ''));
    IF p_nama_fasilitas = '' THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Nama fasilitas wajib diisi'; END IF;
    IF p_harga IS NULL OR p_harga < 0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Harga fasilitas tidak valid'; END IF;
    IF v_csv = '' THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Minimal satu kelas wajib dipilih'; END IF;
    IF EXISTS (SELECT 1 FROM fasilitas WHERE status_fasilitas = 'Aktif' AND UPPER(TRIM(nama_fasilitas)) = UPPER(p_nama_fasilitas)) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Nama fasilitas sudah digunakan oleh fasilitas aktif';
    END IF;

    DROP TEMPORARY TABLE IF EXISTS tmp_kelas_fasilitas;
    CREATE TEMPORARY TABLE tmp_kelas_fasilitas (id_kelas INT PRIMARY KEY) ENGINE=MEMORY;
    WHILE v_csv <> '' DO
        SET v_token = TRIM(SUBSTRING_INDEX(v_csv, ',', 1));
        IF v_token NOT REGEXP '^[0-9]+$' OR CAST(v_token AS UNSIGNED) <= 0 THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Daftar kelas tidak valid';
        END IF;
        INSERT IGNORE INTO tmp_kelas_fasilitas (id_kelas) VALUES (CAST(v_token AS UNSIGNED));
        IF INSTR(v_csv, ',') = 0 THEN SET v_csv = ''; ELSE SET v_csv = SUBSTRING(v_csv, INSTR(v_csv, ',') + 1); END IF;
    END WHILE;
    IF EXISTS (SELECT 1 FROM tmp_kelas_fasilitas t LEFT JOIN kelas k ON k.id_kelas=t.id_kelas AND k.status_kelas='Aktif' WHERE k.id_kelas IS NULL) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Terdapat kelas yang tidak ditemukan atau tidak aktif';
    END IF;

    START TRANSACTION;
    INSERT INTO fasilitas (nama_fasilitas, harga, status_fasilitas, tanggal_pendataan)
    VALUES (p_nama_fasilitas, p_harga, 'Aktif', NOW());
    SET v_id_fasilitas = LAST_INSERT_ID();
    INSERT INTO detail_fasilitas_pada_kelas (id_kelas, id_fasilitas, status_detail_fasilitas_pada_kelas)
    SELECT id_kelas, v_id_fasilitas, 'Aktif' FROM tmp_kelas_fasilitas;
    COMMIT;
    DROP TEMPORARY TABLE IF EXISTS tmp_kelas_fasilitas;
    SELECT 'Data fasilitas dan kelas berhasil ditambahkan' AS Pesan, v_id_fasilitas AS id_fasilitas_baru;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `usp_insert_kegiatan` (IN `p_nama_kegiatan` VARCHAR(50), IN `p_penyelenggara` VARCHAR(20), IN `p_tanggal_kegiatan` DATE)   BEGIN
    SET p_nama_kegiatan=TRIM(p_nama_kegiatan);
    IF p_nama_kegiatan='' OR p_penyelenggara NOT IN ('ASTRAtech','BEM','MPM','HIMMA','UKM','Prodi') THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Data kegiatan tidak valid'; END IF;
    IF EXISTS (SELECT 1 FROM kegiatan WHERE status_kegiatan='Aktif' AND UPPER(TRIM(nama_kegiatan))=UPPER(p_nama_kegiatan) AND penyelenggara=p_penyelenggara AND tanggal_kegiatan <=> p_tanggal_kegiatan) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Kegiatan aktif dengan seluruh input yang sama sudah tersedia';
    END IF;
    INSERT INTO kegiatan (nama_kegiatan,penyelenggara,tanggal_kegiatan,status_kegiatan) VALUES (p_nama_kegiatan,p_penyelenggara,p_tanggal_kegiatan,'Aktif');
    SELECT 'Data kegiatan berhasil ditambahkan' AS Pesan,LAST_INSERT_ID() AS id_kegiatan_baru;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `usp_insert_kelas` (IN `p_nama_kelas` VARCHAR(5), IN `p_tingkat` VARCHAR(1))   BEGIN
    SET p_nama_kelas = UPPER(TRIM(p_nama_kelas));
    IF p_nama_kelas IS NULL OR p_nama_kelas = '' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Nama kelas wajib diisi';
    END IF;
    IF p_tingkat NOT IN ('1','2','3','4') THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Tingkat kelas tidak valid';
    END IF;
    IF EXISTS (SELECT 1 FROM kelas WHERE status_kelas = 'Aktif' AND UPPER(TRIM(nama_kelas)) = p_nama_kelas) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Nama kelas sudah digunakan oleh kelas aktif';
    END IF;
    INSERT INTO kelas (nama_kelas, tingkat, status_kelas) VALUES (p_nama_kelas, p_tingkat, 'Aktif');
    SELECT 'Data kelas berhasil ditambahkan' AS Pesan, LAST_INSERT_ID() AS id_kelas_baru;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `usp_insert_mahasiswa` (IN `p_id_kelas` INT, IN `p_id_periode_akademik` INT, IN `p_nim` VARCHAR(20), IN `p_nama_mahasiswa` VARCHAR(50), IN `p_email` VARCHAR(50), IN `p_no_hp` VARCHAR(20))   BEGIN
    DECLARE v_id_mahasiswa_baru INT;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN ROLLBACK; RESIGNAL; END;
    SET p_email = NULLIF(TRIM(p_email), '');
    SET p_no_hp = NULLIF(TRIM(p_no_hp), '');
    IF p_no_hp IS NOT NULL AND p_no_hp NOT REGEXP '^[0-9]{10,13}$' THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No HP harus terdiri dari 10 sampai 13 digit'; END IF;
    IF NOT EXISTS (SELECT 1 FROM kelas WHERE id_kelas = p_id_kelas AND status_kelas = 'Aktif') THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Kelas tidak ditemukan atau tidak aktif'; END IF;
    IF NOT EXISTS (SELECT 1 FROM periode_akademik WHERE id_periode_akademik = p_id_periode_akademik AND tanggal_selesai >= CURDATE()) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Periode akademik tidak valid atau sudah berakhir'; END IF;
    IF EXISTS (SELECT 1 FROM mahasiswa WHERE nim = p_nim) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'NIM sudah digunakan'; END IF;
    START TRANSACTION;
    INSERT INTO mahasiswa (id_kelas, id_periode_akademik, nim, nama_mahasiswa, email, no_hp)
    VALUES (p_id_kelas, p_id_periode_akademik, TRIM(p_nim), TRIM(p_nama_mahasiswa), p_email, p_no_hp);
    SET v_id_mahasiswa_baru = LAST_INSERT_ID();
    UPDATE kelas SET jumlah_mahasiswa = jumlah_mahasiswa + 1 WHERE id_kelas = p_id_kelas;
    COMMIT;
    SELECT 'Data mahasiswa berhasil ditambahkan' AS Pesan, v_id_mahasiswa_baru AS id_mahasiswa_baru;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `usp_insert_mata_kuliah` (IN `p_nama` VARCHAR(100), IN `p_kode` VARCHAR(20), IN `p_sks` INT, IN `p_semester` INT, IN `p_id_kelas_csv` TEXT)   BEGIN
    DECLARE v_id_mata_kuliah INT;
    DECLARE v_csv TEXT;
    DECLARE v_token VARCHAR(30);
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        DROP TEMPORARY TABLE IF EXISTS tmp_kelas_mata_kuliah;
        RESIGNAL;
    END;

    SET p_nama = TRIM(p_nama);
    SET p_kode = UPPER(TRIM(p_kode));
    SET v_csv = TRIM(BOTH ',' FROM COALESCE(p_id_kelas_csv, ''));

    IF p_nama = '' OR p_kode = '' OR p_sks <= 0 OR p_semester NOT BETWEEN 1 AND 8 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Data mata kuliah tidak valid';
    END IF;
    IF v_csv = '' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Minimal satu kelas aktif wajib dipilih';
    END IF;
    IF EXISTS (SELECT 1 FROM mata_kuliah WHERE kode_mata_kuliah = p_kode) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Kode mata kuliah sudah digunakan';
    END IF;

    DROP TEMPORARY TABLE IF EXISTS tmp_kelas_mata_kuliah;
    CREATE TEMPORARY TABLE tmp_kelas_mata_kuliah (id_kelas INT PRIMARY KEY) ENGINE=MEMORY;
    WHILE v_csv <> '' DO
        SET v_token = TRIM(SUBSTRING_INDEX(v_csv, ',', 1));
        IF v_token NOT REGEXP '^[0-9]+$' OR CAST(v_token AS UNSIGNED) <= 0 THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Daftar kelas tidak valid';
        END IF;
        INSERT IGNORE INTO tmp_kelas_mata_kuliah (id_kelas) VALUES (CAST(v_token AS UNSIGNED));
        IF INSTR(v_csv, ',') = 0 THEN
            SET v_csv = '';
        ELSE
            SET v_csv = SUBSTRING(v_csv, INSTR(v_csv, ',') + 1);
        END IF;
    END WHILE;

    IF EXISTS (
        SELECT 1
        FROM tmp_kelas_mata_kuliah t
        LEFT JOIN kelas k ON k.id_kelas = t.id_kelas AND k.status_kelas = 'Aktif'
        WHERE k.id_kelas IS NULL
    ) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Terdapat kelas yang tidak ditemukan atau tidak aktif';
    END IF;

    START TRANSACTION;
    INSERT INTO mata_kuliah (nama_mata_kuliah, kode_mata_kuliah, sks, semester, status_mata_kuliah)
    VALUES (p_nama, p_kode, p_sks, p_semester, 'Aktif');
    SET v_id_mata_kuliah = LAST_INSERT_ID();

    INSERT INTO detail_kelas_pada_mata_kuliah (id_mata_kuliah, id_kelas)
    SELECT v_id_mata_kuliah, id_kelas FROM tmp_kelas_mata_kuliah;
    COMMIT;

    DROP TEMPORARY TABLE IF EXISTS tmp_kelas_mata_kuliah;
    SELECT 'Data mata kuliah dan kelas berhasil ditambahkan' AS Pesan,
           v_id_mata_kuliah AS id_mata_kuliah_baru;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `usp_insert_pemberian_jam_minus` (IN `p_id_pemberi` INT, IN `p_id_penerima` INT, IN `p_id_kelas` INT, IN `p_kategori_pelanggaran` VARCHAR(20), IN `p_id_detail_kelas_pada_mata_kuliah` INT, IN `p_keterangan_absensi` VARCHAR(10), IN `p_id_fasilitas` INT, IN `p_deskripsi_pelanggaran` TEXT, IN `p_jenis_jam_input` VARCHAR(20), IN `p_jumlah_jam_minus_input` DECIMAL(10,2))   BEGIN
    DECLARE v_id_mahasiswa INT;
    DECLARE v_id_kelas_mahasiswa INT;

    DECLARE v_id_detail_mk_final INT DEFAULT NULL;
    DECLARE v_keterangan_absensi_final VARCHAR(10)
        DEFAULT NULL;

    DECLARE v_id_fasilitas_final INT DEFAULT NULL;

    DECLARE v_harga_fasilitas DECIMAL(15,2)
        DEFAULT NULL;

    DECLARE v_hasil_perhitungan_fasilitas DECIMAL(20,6)
        DEFAULT NULL;

    DECLARE v_jumlah_jam_minus DECIMAL(10,2)
        DEFAULT 0.00;

    DECLARE v_jenis_jam VARCHAR(20);

    DECLARE v_nama_pelanggaran VARCHAR(100);

    DECLARE v_deskripsi_final TEXT DEFAULT NULL;

    DECLARE v_id_pemberian_jam_minus INT;

    /* =========================================
       ROLLBACK OTOMATIS JIKA ADA ERROR
       ========================================= */
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    /* =========================================
       VALIDASI PIC TATA TERTIB
       ========================================= */
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

    /* =========================================
       VALIDASI MAHASISWA PENERIMA
       ========================================= */
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

    /* =========================================
       VALIDASI KATEGORI
       ========================================= */
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

    /* =========================================
       AMBIL + LOCK DATA MAHASISWA
       ========================================= */
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

    IF p_id_kelas IS NULL OR p_id_kelas <= 0
       OR v_id_kelas_mahasiswa <> p_id_kelas
    THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
            'Mahasiswa tidak terdaftar pada kelas yang dipilih';
    END IF;

    /* ==================================================
       KATEGORI 1: AKADEMIK
       ================================================== */
    IF p_kategori_pelanggaran = 'Akademik' THEN

        /* Mata kuliah wajib dipilih */
        IF p_id_detail_kelas_pada_mata_kuliah IS NULL

           OR p_id_detail_kelas_pada_mata_kuliah <= 0
        THEN

            SIGNAL SQLSTATE '45000'

            SET MESSAGE_TEXT =
                'Mata kuliah wajib dipilih untuk kategori Akademik';

        END IF;

        /* Absensi wajib valid */
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

        /* Jumlah jam input PIC */
        IF p_jumlah_jam_minus_input IS NULL

           OR p_jumlah_jam_minus_input <= 0
        THEN

            SIGNAL SQLSTATE '45000'

            SET MESSAGE_TEXT =
                'Jumlah jam minus Akademik harus lebih dari 0';

        END IF;

        /*
         * PENTING:
         * Mata kuliah harus benar-benar dimiliki
         * kelas mahasiswa penerima.
         */
        IF NOT EXISTS (
            SELECT 1

            FROM detail_kelas_pada_mata_kuliah AS dkmk

            JOIN mata_kuliah AS mk
                ON dkmk.id_mata_kuliah =
                    mk.id_matakuliah

            WHERE dkmk.id_detail_kelas_pada_mata_kuliah =
                    p_id_detail_kelas_pada_mata_kuliah

              AND dkmk.id_kelas =
                    v_id_kelas_mahasiswa

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
            p_jumlah_jam_minus_input;

        SET v_jenis_jam =
            'Murni';

        SET v_nama_pelanggaran =
            'Pelanggaran Akademik';

        SET v_deskripsi_final =
            NULL;

    /* ==================================================
       KATEGORI 2: FASILITAS
       ================================================== */
    ELSEIF p_kategori_pelanggaran = 'Fasilitas' THEN

        /* Fasilitas wajib dipilih */
        IF p_id_fasilitas IS NULL

           OR p_id_fasilitas <= 0
        THEN

            SIGNAL SQLSTATE '45000'

            SET MESSAGE_TEXT =
                'Fasilitas wajib dipilih';

        END IF;

        /*
         * Tidak memfilter status_fasilitas.
         *
         * Sesuai requirement:
         * semua fasilitas pada tabel fasilitas
         * dapat dipilih.
         */
        IF NOT EXISTS (
            SELECT 1

            FROM fasilitas

            WHERE id_fasilitas =
                p_id_fasilitas
        ) THEN

            SIGNAL SQLSTATE '45000'

            SET MESSAGE_TEXT =
                'Fasilitas tidak ditemukan';

        END IF;

        /* Ambil harga ASLI dari database */
        SELECT
            harga

        INTO
            v_harga_fasilitas

        FROM fasilitas

        WHERE id_fasilitas =
            p_id_fasilitas

        LIMIT 1;

        IF v_harga_fasilitas IS NULL

           OR v_harga_fasilitas <= 0
        THEN

            SIGNAL SQLSTATE '45000'

            SET MESSAGE_TEXT =
                'Harga fasilitas harus lebih dari 0';

        END IF;

        /*
         * FORMULA FINAL:
         *
         * harga × 0,0005
         */
        SET v_hasil_perhitungan_fasilitas =
            v_harga_fasilitas * 0.0005;

        /*
         * Karena jumlah_jam_minus memakai DECIMAL(10,2),
         * validasi range dilakukan sebelum penyimpanan.
         */
        IF v_hasil_perhitungan_fasilitas >
            99999999.99
        THEN

            SIGNAL SQLSTATE '45000'

            SET MESSAGE_TEXT =
                'Hasil perhitungan jam minus melebihi kapasitas sistem';

        END IF;

        SET v_jumlah_jam_minus =
            ROUND(
                v_hasil_perhitungan_fasilitas,
                2
            );

        IF v_jumlah_jam_minus <= 0 THEN

            SIGNAL SQLSTATE '45000'

            SET MESSAGE_TEXT =
                'Hasil perhitungan jam minus harus lebih dari 0';

        END IF;

        SET v_id_fasilitas_final =
            p_id_fasilitas;

        SET v_jenis_jam =
            'Kompensasi';

        SET v_nama_pelanggaran =
            'Kerusakan Fasilitas';

        SET v_deskripsi_final =
            NULL;

    /* ==================================================
       KATEGORI 3: LAINNYA
       ================================================== */
    ELSEIF p_kategori_pelanggaran = 'Lainnya' THEN

        /* Deskripsi wajib */
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

        /* Jenis dipilih PIC */
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

        /* Jumlah diinput PIC */
        IF p_jumlah_jam_minus_input IS NULL

           OR p_jumlah_jam_minus_input <= 0
        THEN

            SIGNAL SQLSTATE '45000'

            SET MESSAGE_TEXT =
                'Jumlah jam minus harus lebih dari 0';

        END IF;

        SET v_nama_pelanggaran =
            'Pelanggaran Lainnya';

        SET v_deskripsi_final =
            TRIM(p_deskripsi_pelanggaran);

        SET v_jenis_jam =
            p_jenis_jam_input;

        SET v_jumlah_jam_minus =
            p_jumlah_jam_minus_input;

    END IF;

    /* =========================================
       INSERT TRANSAKSI UTAMA
       ========================================= */
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

    /* =========================================
       SIMPAN PIC SEBAGAI PEMBERI
       ========================================= */
    INSERT INTO
        detail_pengguna_pada_pemberian_jam_minus
    (
        id_pemberian_jam_minus,
        id_pengguna,
        peran_pengguna
    )
    VALUES (
        v_id_pemberian_jam_minus,
        p_id_pemberi,
        'Pemberi'
    );

    /* =========================================
       SIMPAN MAHASISWA SEBAGAI PENERIMA
       ========================================= */
    INSERT INTO
        detail_pengguna_pada_pemberian_jam_minus
    (
        id_pemberian_jam_minus,
        id_pengguna,
        peran_pengguna
    )
    VALUES (
        v_id_pemberian_jam_minus,
        p_id_penerima,
        'Penerima'
    );

    /* =========================================
       UPDATE SALDO MAHASISWA
       ========================================= */
    IF v_jenis_jam = 'Murni' THEN

        UPDATE mahasiswa

        SET saldo_jam_minus_murni =
            COALESCE(
                saldo_jam_minus_murni,
                0
            )
            +
            v_jumlah_jam_minus

        WHERE id_mahasiswa =
            v_id_mahasiswa;

    ELSEIF v_jenis_jam = 'Kompensasi' THEN

        UPDATE mahasiswa

        SET saldo_jam_minus_kompensasi =
            COALESCE(
                saldo_jam_minus_kompensasi,
                0
            )
            +
            v_jumlah_jam_minus

        WHERE id_mahasiswa =
            v_id_mahasiswa;

    END IF;

    COMMIT;

    /* =========================================
       RESPONSE
       ========================================= */
    SELECT
        'Pemberian jam minus berhasil disimpan'
            AS pesan,

        v_id_pemberian_jam_minus
            AS id_pemberian_jam_minus,

        v_jumlah_jam_minus
            AS jumlah_jam_minus,

        v_jenis_jam
            AS jenis_jam;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `usp_insert_pengaduan_kerusakan_fasilitas` (IN `p_id_fasilitas` INT, IN `p_id_pengguna` INT, IN `p_deskripsi_kerusakan` TEXT, IN `p_bukti_kerusakan_url` VARCHAR(2048), IN `p_pelaku_kerusakan` VARCHAR(50))   BEGIN
    DECLARE v_id_pengaduan INT;
    DECLARE v_id_detail_fasilitas_kelas INT DEFAULT NULL;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    SET p_deskripsi_kerusakan = TRIM(p_deskripsi_kerusakan);
    SET p_bukti_kerusakan_url = NULLIF(TRIM(p_bukti_kerusakan_url), '');
    SET p_pelaku_kerusakan = NULLIF(TRIM(p_pelaku_kerusakan), '');
    IF p_deskripsi_kerusakan IS NULL OR p_deskripsi_kerusakan = '' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Deskripsi kerusakan wajib diisi';
    END IF;

    START TRANSACTION;

    SELECT d.id_detail_fasilitas_pada_kelas
      INTO v_id_detail_fasilitas_kelas
    FROM pengguna p
    JOIN mahasiswa m ON p.id_mahasiswa = m.id_mahasiswa
    JOIN kelas k ON m.id_kelas = k.id_kelas
    JOIN detail_fasilitas_pada_kelas d
      ON d.id_kelas = k.id_kelas
     AND d.id_fasilitas = p_id_fasilitas
    JOIN fasilitas f ON f.id_fasilitas = d.id_fasilitas
    WHERE p.id_pengguna = p_id_pengguna
      AND p.role = 'Mahasiswa'
      AND p.status_akun = 'Aktif'
      AND m.status_mahasiswa = 'Aktif'
      AND k.status_kelas = 'Aktif'
      AND f.status_fasilitas = 'Aktif'
      AND d.status_detail_fasilitas_pada_kelas = 'Aktif'
    LIMIT 1
    FOR UPDATE;

    IF v_id_detail_fasilitas_kelas IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Fasilitas tidak tersedia pada kelas mahasiswa';
    END IF;

    INSERT INTO pengaduan_kerusakan_fasilitas (
        id_fasilitas,
        id_detail_fasilitas_pada_kelas,
        deskripsi_kerusakan,
        tanggal_pengaduan,
        bukti_kerusakan_url,
        pelaku_kerusakan
    ) VALUES (
        p_id_fasilitas,
        v_id_detail_fasilitas_kelas,
        p_deskripsi_kerusakan,
        NOW(),
        p_bukti_kerusakan_url,
        p_pelaku_kerusakan
    );

    SET v_id_pengaduan = LAST_INSERT_ID();
    INSERT INTO detail_pengguna_pada_pengaduan_kerusakan_fasilitas (
        id_pengaduan_kerusakan_fasilitas, id_pengguna, peran_pengguna
    ) VALUES (v_id_pengaduan, p_id_pengguna, 'Pelapor');

    COMMIT;
    SELECT 'Data pengaduan kerusakan fasilitas berhasil ditambahkan' AS Pesan,
           v_id_pengaduan AS id_pengaduan_kerusakan_fasilitas_baru;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `usp_insert_pengajar` (IN `p_nip` VARCHAR(20), IN `p_nama_pengajar` VARCHAR(50), IN `p_email` VARCHAR(50), IN `p_no_hp` VARCHAR(20))   BEGIN
    SET p_email = NULLIF(TRIM(p_email), '');
    SET p_no_hp = NULLIF(TRIM(p_no_hp), '');
    IF p_nip IS NULL OR TRIM(p_nip) = '' OR p_nama_pengajar IS NULL OR TRIM(p_nama_pengajar) = '' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'NIP dan nama pengajar wajib diisi';
    END IF;
    IF p_no_hp IS NOT NULL AND p_no_hp NOT REGEXP '^[0-9]{10,13}$' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No HP harus terdiri dari 10 sampai 13 digit';
    END IF;
    IF EXISTS (SELECT 1 FROM pengajar WHERE nip = p_nip) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'NIP sudah digunakan'; END IF;
    INSERT INTO pengajar (nip, nama_pengajar, email, no_hp) VALUES (TRIM(p_nip), TRIM(p_nama_pengajar), p_email, p_no_hp);
    SELECT 'Data pengajar berhasil ditambahkan' AS Pesan, LAST_INSERT_ID() AS id_pengajar_baru;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `usp_insert_pengajar_mata_kuliah_kelas` (IN `p_id_kelas` INT, IN `p_id_mata_kuliah` INT)   BEGIN
    IF NOT EXISTS (SELECT 1 FROM kelas WHERE id_kelas=p_id_kelas AND status_kelas='Aktif') THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Kelas tidak ditemukan atau tidak aktif'; END IF;
    IF NOT EXISTS (SELECT 1 FROM mata_kuliah WHERE id_matakuliah=p_id_mata_kuliah AND status_mata_kuliah='Aktif') THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Mata kuliah tidak ditemukan atau tidak aktif'; END IF;
    IF EXISTS (SELECT 1 FROM detail_kelas_pada_mata_kuliah WHERE id_kelas=p_id_kelas AND id_mata_kuliah=p_id_mata_kuliah) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Mata kuliah sudah ditentukan pada kelas tersebut'; END IF;
    INSERT INTO detail_kelas_pada_mata_kuliah (id_mata_kuliah,id_kelas) VALUES (p_id_mata_kuliah,p_id_kelas);
    SELECT 'Data mata kuliah kelas berhasil ditambahkan' AS Pesan,LAST_INSERT_ID() AS id_detail_kelas_pada_mata_kuliah;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `usp_insert_pengajuan_jam_plus` (IN `p_id_pengguna` INT, IN `p_id_kegiatan` INT, IN `p_jumlah_jam` DECIMAL(6,2), IN `p_jenis_jam` VARCHAR(20), IN `p_sumber_jam` VARCHAR(10), IN `p_deskripsi` TEXT, IN `p_nama_pemberi` VARCHAR(50), IN `p_dokumen_url` VARCHAR(2048))   BEGIN
    DECLARE v_id_pengajuan INT;
    DECLARE v_id_kegiatan_final INT;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN ROLLBACK; RESIGNAL; END;
    IF p_jumlah_jam<=0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Jumlah jam plus harus lebih dari 0'; END IF;
    IF p_jenis_jam NOT IN ('Murni','Kompensasi') OR p_sumber_jam NOT IN ('Prodi','Luar') THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Jenis atau sumber jam tidak valid'; END IF;
    IF NOT EXISTS (SELECT 1 FROM pengguna WHERE id_pengguna=p_id_pengguna AND role='Mahasiswa' AND status_akun='Aktif') THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Pengguna mahasiswa tidak valid atau tidak aktif'; END IF;
    IF p_sumber_jam='Prodi' THEN
        IF p_id_kegiatan IS NULL OR p_id_kegiatan<=0 THEN
            SET v_id_kegiatan_final=NULL;
        ELSEIF NOT EXISTS (SELECT 1 FROM kegiatan WHERE id_kegiatan=p_id_kegiatan AND status_kegiatan='Aktif' AND penyelenggara='Prodi') THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Untuk sumber Prodi, kegiatan harus diselenggarakan Prodi';
        ELSE SET v_id_kegiatan_final=p_id_kegiatan; END IF;
    ELSE
        IF p_id_kegiatan IS NULL OR p_id_kegiatan<=0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Kegiatan wajib dipilih untuk sumber luar Prodi'; END IF;
        IF NOT EXISTS (SELECT 1 FROM kegiatan WHERE id_kegiatan=p_id_kegiatan AND status_kegiatan='Aktif' AND penyelenggara<>'Prodi') THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Kegiatan luar tidak ditemukan atau diselenggarakan Prodi'; END IF;
        SET v_id_kegiatan_final=p_id_kegiatan;
    END IF;
    START TRANSACTION;
    INSERT INTO pengajuan_jam_plus (id_kegiatan,jumlah_jam_plus,jenis_jam,sumber_jam,tanggal_pengajuan,deskripsi_pekerjaan,nama_pemberi,dokumen_url,status_pengajuan)
    VALUES (v_id_kegiatan_final,p_jumlah_jam,p_jenis_jam,p_sumber_jam,NOW(),p_deskripsi,p_nama_pemberi,p_dokumen_url,'Menunggu Verifikasi');
    SET v_id_pengajuan=LAST_INSERT_ID();
    INSERT INTO detail_pengguna_pada_pengajuan_jam_plus (id_pengajuan_jam_plus,id_pengguna,peran_pengguna) VALUES (v_id_pengajuan,p_id_pengguna,'Pengaju');
    COMMIT;
    SELECT 'Pengajuan jam plus berhasil dikirim' AS Pesan,v_id_pengajuan AS id_pengajuan_jam_plus;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `usp_insert_pengguna` (IN `p_id_mahasiswa` INT, IN `p_id_pengajar` INT, IN `p_username` VARCHAR(20), IN `p_password` VARCHAR(255), IN `p_role` VARCHAR(30))   BEGIN
    SET p_username=TRIM(p_username);
    IF p_username='' OR CHAR_LENGTH(p_username)>20 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Username wajib diisi dan maksimal 20 karakter'; END IF;
    IF p_password IS NULL OR p_password = '' THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Password wajib diisi'; END IF;
    IF EXISTS (SELECT 1 FROM pengguna WHERE username = TRIM(p_username)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Username sudah digunakan'; END IF;
    IF p_role = 'Mahasiswa' THEN
        IF p_id_mahasiswa IS NULL OR p_id_pengajar IS NOT NULL THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Relasi akun mahasiswa tidak valid'; END IF;
    ELSE
        IF p_id_pengajar IS NULL OR p_id_mahasiswa IS NOT NULL THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Relasi akun pengajar tidak valid'; END IF;
    END IF;
    INSERT INTO pengguna (id_mahasiswa, id_pengajar, username, password, role) VALUES (p_id_mahasiswa, p_id_pengajar, TRIM(p_username), p_password, p_role);
    SELECT 'Data pengguna berhasil ditambahkan' AS Pesan, LAST_INSERT_ID() AS id_pengguna_baru;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `usp_insert_periode_akademik` (IN `p_tahun_akademik` VARCHAR(10), IN `p_semester` VARCHAR(10), IN `p_tanggal_mulai` DATE, IN `p_tanggal_selesai` DATE)   BEGIN
    DECLARE v_tahun_awal INT;
    DECLARE v_tahun_akhir INT;

    IF p_tahun_akademik NOT REGEXP '^[0-9]{4}/[0-9]{4}$' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Format tahun akademik harus YYYY/YYYY';
    END IF;

    SET v_tahun_awal =
        CAST(LEFT(p_tahun_akademik, 4) AS UNSIGNED);

    SET v_tahun_akhir =
        CAST(RIGHT(p_tahun_akademik, 4) AS UNSIGNED);

    IF v_tahun_akhir <> v_tahun_awal + 1 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
            'Tahun kedua harus satu tahun setelah tahun pertama';
    END IF;

    IF p_semester NOT IN ('Ganjil', 'Genap') THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Semester tidak valid';
    END IF;

    IF p_tanggal_mulai >= p_tanggal_selesai THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
            'Tanggal mulai harus lebih kecil dari tanggal selesai';
    END IF;

    IF YEAR(p_tanggal_mulai)
           NOT BETWEEN v_tahun_awal AND v_tahun_akhir
       OR YEAR(p_tanggal_selesai)
           NOT BETWEEN v_tahun_awal AND v_tahun_akhir THEN

        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
            'Tanggal periode harus berada dalam tahun akademik';
    END IF;

    IF EXISTS (
        SELECT 1
        FROM periode_akademik
        WHERE tahun_akademik = p_tahun_akademik
          AND semester = p_semester
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
            'Tahun akademik dan semester sudah tersedia';
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
        'Aktif'
    );

    SELECT
        'Data periode akademik berhasil ditambahkan dan otomatis aktif'
            AS Pesan,
        LAST_INSERT_ID()
            AS id_periode_akademik_baru;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `usp_login_pengguna` (IN `p_username` VARCHAR(20))   BEGIN
 SELECT p.*,m.nim,m.nama_mahasiswa,pg.nip,pg.nama_pengajar FROM pengguna p
 LEFT JOIN mahasiswa m ON p.id_mahasiswa=m.id_mahasiswa LEFT JOIN pengajar pg ON p.id_pengajar=pg.id_pengajar
 WHERE p.username=p_username AND p.status_akun='Aktif' LIMIT 1;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `usp_pulihkan_fasilitas_kelas` (IN `p_id_detail_fasilitas_pada_kelas` INT, IN `p_id_fasilitas` INT)   BEGIN
    DECLARE v_status VARCHAR(20) DEFAULT NULL;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN ROLLBACK; RESIGNAL; END;

    START TRANSACTION;

    SELECT status_detail_fasilitas_pada_kelas
    INTO v_status
    FROM detail_fasilitas_pada_kelas
    WHERE id_detail_fasilitas_pada_kelas=p_id_detail_fasilitas_pada_kelas
      AND id_fasilitas=p_id_fasilitas
    FOR UPDATE;

    IF v_status IS NULL OR v_status <> 'Rusak' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Fasilitas kelas tidak ditemukan atau kondisinya bukan Rusak';
    END IF;

    UPDATE detail_fasilitas_pada_kelas
    SET status_detail_fasilitas_pada_kelas='Aktif'
    WHERE id_detail_fasilitas_pada_kelas=p_id_detail_fasilitas_pada_kelas
      AND id_fasilitas=p_id_fasilitas;

    COMMIT;
    SELECT 'Kondisi fasilitas kelas berhasil dipulihkan' AS Pesan;
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

CREATE DEFINER=`root`@`localhost` PROCEDURE `usp_select_bursa_jobdesc_penerima_by_id` (IN `p_id_jobdesc` INT, IN `p_id_pengguna` INT)   BEGIN
    SELECT bj.id_bursa_jobdesc,bj.deskripsi_jobdesc,bj.jam_plus,bj.tanggal_pemberian_jobdesc,
           bj.jumlah_mahasiswa_diperlukan,bj.jumlah_mahasiswa_mengambil,bj.bukti_selesai_url,bj.status_jobdesc,dp.peran_pengguna
    FROM bursa_jobdesc bj
    JOIN detail_pengguna_pada_bursa_jobdesc dp ON bj.id_bursa_jobdesc=dp.id_bursa_jobdesc
    WHERE bj.id_bursa_jobdesc=p_id_jobdesc AND dp.id_pengguna=p_id_pengguna AND dp.peran_pengguna='Penerima'
    LIMIT 1;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `usp_select_fasilitas` ()   BEGIN
    SELECT id_fasilitas, nama_fasilitas, harga, status_fasilitas, tanggal_pendataan
    FROM fasilitas WHERE status_fasilitas = 'Aktif' ORDER BY nama_fasilitas ASC;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `usp_select_fasilitas_aktif` ()   BEGIN
    SELECT id_fasilitas, nama_fasilitas, harga, status_fasilitas, tanggal_pendataan
    FROM fasilitas WHERE status_fasilitas = 'Aktif' ORDER BY nama_fasilitas ASC;
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
    SELECT d.id_detail_fasilitas_pada_kelas, d.id_kelas, k.nama_kelas, k.tingkat,
           d.id_fasilitas, f.nama_fasilitas, d.status_detail_fasilitas_pada_kelas
    FROM detail_fasilitas_pada_kelas d
    JOIN kelas k ON d.id_kelas = k.id_kelas
    JOIN fasilitas f ON d.id_fasilitas = f.id_fasilitas
    WHERE k.status_kelas = 'Aktif' AND f.status_fasilitas = 'Aktif'
      AND d.status_detail_fasilitas_pada_kelas IN ('Aktif','Rusak')
    ORDER BY k.tingkat, k.nama_kelas, f.nama_fasilitas;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `usp_select_fasilitas_kelas_by_id` (IN `p_id_detail_fasilitas_pada_kelas` INT)   BEGIN
    SELECT d.id_detail_fasilitas_pada_kelas, d.id_kelas, k.nama_kelas, k.tingkat,
           d.id_fasilitas, f.nama_fasilitas, d.status_detail_fasilitas_pada_kelas
    FROM detail_fasilitas_pada_kelas d
    JOIN kelas k ON d.id_kelas = k.id_kelas
    JOIN fasilitas f ON d.id_fasilitas = f.id_fasilitas
    WHERE d.id_detail_fasilitas_pada_kelas = p_id_detail_fasilitas_pada_kelas
      AND d.status_detail_fasilitas_pada_kelas IN ('Aktif','Rusak') LIMIT 1;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `usp_select_fasilitas_pengaduan_mahasiswa` (IN `p_id_pengguna` INT)   BEGIN
    SELECT f.id_fasilitas,f.nama_fasilitas,k.id_kelas,k.nama_kelas,dfpk.id_detail_fasilitas_pada_kelas,dfpk.status_detail_fasilitas_pada_kelas
    FROM pengguna p
    JOIN mahasiswa m ON p.id_mahasiswa=m.id_mahasiswa AND m.status_mahasiswa='Aktif'
    JOIN kelas k ON m.id_kelas=k.id_kelas AND k.status_kelas='Aktif'
    JOIN detail_fasilitas_pada_kelas dfpk ON m.id_kelas=dfpk.id_kelas
    JOIN fasilitas f ON dfpk.id_fasilitas=f.id_fasilitas
    WHERE p.id_pengguna=p_id_pengguna AND p.role='Mahasiswa' AND p.status_akun='Aktif'
      AND f.status_fasilitas='Aktif' AND dfpk.status_detail_fasilitas_pada_kelas='Aktif'
    ORDER BY f.nama_fasilitas;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `usp_select_histori_login` ()   BEGIN
    SELECT id_histori_login, id_pengguna, username, role, tanggal_login
    FROM histori_login
    ORDER BY tanggal_login DESC, id_histori_login DESC;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `usp_select_identitas_pengguna_tersedia` (IN `p_jenis` VARCHAR(20), IN `p_id_pengguna_abaikan` INT)   BEGIN
    IF p_jenis='Mahasiswa' THEN
        SELECT m.id_mahasiswa AS id_identitas,m.nim AS nomor_identitas,m.nama_mahasiswa AS nama_identitas
        FROM mahasiswa m
        LEFT JOIN pengguna p ON p.id_mahasiswa=m.id_mahasiswa AND p.status_akun='Aktif' AND (p_id_pengguna_abaikan IS NULL OR p.id_pengguna<>p_id_pengguna_abaikan)
        WHERE m.status_mahasiswa='Aktif' AND p.id_pengguna IS NULL
        ORDER BY m.nama_mahasiswa;
    ELSEIF p_jenis='Pengajar' THEN
        SELECT pg.id_pengajar AS id_identitas,pg.nip AS nomor_identitas,pg.nama_pengajar AS nama_identitas
        FROM pengajar pg
        LEFT JOIN pengguna p ON p.id_pengajar=pg.id_pengajar AND p.status_akun='Aktif' AND (p_id_pengguna_abaikan IS NULL OR p.id_pengguna<>p_id_pengguna_abaikan)
        WHERE pg.status_pengajar='Aktif' AND p.id_pengguna IS NULL
        ORDER BY pg.nama_pengajar;
    ELSE
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Jenis identitas pengguna tidak valid';
    END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `usp_select_kegiatan` ()   BEGIN
    SELECT id_kegiatan, nama_kegiatan, penyelenggara, tanggal_kegiatan, status_kegiatan
    FROM kegiatan WHERE status_kegiatan = 'Aktif' ORDER BY tanggal_kegiatan DESC, nama_kegiatan ASC;
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
    SELECT id_kelas, nama_kelas, tingkat, jumlah_mahasiswa, status_kelas
    FROM kelas
    WHERE status_kelas = 'Aktif'
    ORDER BY tingkat ASC, nama_kelas ASC;
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

CREATE DEFINER=`root`@`localhost` PROCEDURE `usp_select_kelas_aktif_untuk_jam_minus` ()   BEGIN
    SELECT DISTINCT k.id_kelas,k.nama_kelas,k.tingkat
    FROM kelas k JOIN mahasiswa m ON m.id_kelas=k.id_kelas AND m.status_mahasiswa='Aktif'
    JOIN pengguna p ON p.id_mahasiswa=m.id_mahasiswa AND p.role='Mahasiswa' AND p.status_akun='Aktif'
    WHERE k.status_kelas='Aktif' ORDER BY k.tingkat,k.nama_kelas;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `usp_select_kelas_by_id` (IN `p_id_kelas` INT)   BEGIN
    SELECT * FROM kelas WHERE id_kelas=p_id_kelas LIMIT 1;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `usp_select_kelas_dengan_status_fasilitas` (IN `p_id_fasilitas` INT)   BEGIN
    SELECT k.id_kelas,k.nama_kelas,k.tingkat,d.id_detail_fasilitas_pada_kelas,d.status_detail_fasilitas_pada_kelas
    FROM kelas k
    LEFT JOIN detail_fasilitas_pada_kelas d
      ON d.id_kelas=k.id_kelas AND d.id_fasilitas=p_id_fasilitas
    WHERE k.status_kelas='Aktif'
    ORDER BY k.tingkat,k.nama_kelas;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `usp_select_kelas_mata_kuliah_by_id` (IN `p_id_mata_kuliah` INT)   BEGIN
    SELECT d.id_kelas, k.nama_kelas, k.tingkat
    FROM detail_kelas_pada_mata_kuliah d
    JOIN kelas k ON k.id_kelas = d.id_kelas
    WHERE d.id_mata_kuliah = p_id_mata_kuliah
    ORDER BY k.tingkat, k.nama_kelas;
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

CREATE DEFINER=`root`@`localhost` PROCEDURE `usp_select_laporan_bursa_jobdesc_filter` (IN `p_role` VARCHAR(30), IN `p_tanggal_mulai` DATE, IN `p_tanggal_selesai` DATE)   BEGIN
    SELECT bj.id_bursa_jobdesc,bj.deskripsi_jobdesc,bj.penerima_jobdesc,
           COALESCE(NULLIF(GROUP_CONCAT(DISTINCT CASE WHEN dp.peran_pengguna='Penerima' THEN COALESCE(m.nama_mahasiswa,pg.nama_pengajar,p.username) END ORDER BY COALESCE(m.nama_mahasiswa,pg.nama_pengajar,p.username) SEPARATOR ', '),''),'-') AS target_penerima_jobdesc,
           bj.jam_plus,bj.tanggal_pemberian_jobdesc,CONCAT(COUNT(DISTINCT CASE WHEN dp.peran_pengguna='Penerima' THEN dp.id_pengguna END),' / ',bj.jumlah_mahasiswa_diperlukan) AS kuota
    FROM bursa_jobdesc bj
    JOIN detail_pengguna_pada_bursa_jobdesc pemberi ON bj.id_bursa_jobdesc=pemberi.id_bursa_jobdesc AND pemberi.peran_pengguna='Pemberi'
    JOIN pengguna pembuat ON pemberi.id_pengguna=pembuat.id_pengguna
    LEFT JOIN detail_pengguna_pada_bursa_jobdesc dp ON bj.id_bursa_jobdesc=dp.id_bursa_jobdesc
    LEFT JOIN pengguna p ON dp.id_pengguna=p.id_pengguna
    LEFT JOIN mahasiswa m ON p.id_mahasiswa=m.id_mahasiswa
    LEFT JOIN pengajar pg ON p.id_pengajar=pg.id_pengajar
    WHERE pembuat.role=p_role
      AND (p_tanggal_mulai IS NULL OR DATE(bj.tanggal_pemberian_jobdesc)>=p_tanggal_mulai)
      AND (p_tanggal_selesai IS NULL OR DATE(bj.tanggal_pemberian_jobdesc)<=p_tanggal_selesai)
    GROUP BY bj.id_bursa_jobdesc,bj.deskripsi_jobdesc,bj.penerima_jobdesc,bj.jam_plus,bj.tanggal_pemberian_jobdesc,bj.jumlah_mahasiswa_diperlukan
    ORDER BY bj.tanggal_pemberian_jobdesc DESC,bj.id_bursa_jobdesc DESC;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `usp_select_laporan_histori_jam_mahasiswa_filter` (IN `p_id_pengguna` INT, IN `p_tanggal_mulai` DATE, IN `p_tanggal_selesai` DATE)   BEGIN
    SELECT
        id_transaksi,
        jenis_transaksi,
        tanggal_transaksi,
        deskripsi,
        saldo_jam_plus_kompensasi,
        saldo_jam_minus_kompensasi,
        saldo_jam_plus_murni,
        saldo_jam_minus_murni
    FROM vw_laporan_histori_transaksi_jam_mahasiswa
    WHERE id_pengguna = p_id_pengguna
      AND (p_tanggal_mulai IS NULL OR DATE(tanggal_transaksi) >= p_tanggal_mulai)
      AND (p_tanggal_selesai IS NULL OR DATE(tanggal_transaksi) <= p_tanggal_selesai)
    ORDER BY tanggal_transaksi DESC, jenis_transaksi ASC, id_transaksi DESC;
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

CREATE DEFINER=`root`@`localhost` PROCEDURE `usp_select_laporan_pengaduan_fasilitas_filter` (IN `p_tanggal_mulai` DATE, IN `p_tanggal_selesai` DATE)   BEGIN
    SELECT
        id_pengaduan_kerusakan_fasilitas,
        nim,
        nama_mahasiswa,
        nama_kelas,
        nama_fasilitas,
        deskripsi_kerusakan,
        tanggal_pengaduan
    FROM vw_laporan_pengaduan_fasilitas
    WHERE (p_tanggal_mulai IS NULL OR DATE(tanggal_pengaduan) >= p_tanggal_mulai)
      AND (p_tanggal_selesai IS NULL OR DATE(tanggal_pengaduan) <= p_tanggal_selesai)
    ORDER BY tanggal_pengaduan DESC, nim ASC;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `usp_select_laporan_total_jam` (IN `p_sort` VARCHAR(30))   BEGIN
    IF p_sort NOT IN ('nim','nama','total_tertinggi','total_terendah') THEN SET p_sort='nim'; END IF;
    SELECT nim,nama_mahasiswa,nama_kelas,total_jam_kompensasi,total_jam_murni,total_jam_mahasiswa
    FROM vw_laporan_total_jam_mahasiswa
    ORDER BY
      CASE WHEN p_sort='nim' THEN nim END ASC,
      CASE WHEN p_sort='nama' THEN nama_mahasiswa END ASC,
      CASE WHEN p_sort='total_tertinggi' THEN total_jam_mahasiswa END DESC,
      CASE WHEN p_sort='total_terendah' THEN total_jam_mahasiswa END ASC,
      nim ASC;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `usp_select_mahasiswa` ()   BEGIN
    SELECT m.id_mahasiswa, m.id_kelas, k.nama_kelas, k.tingkat, m.id_periode_akademik,
           pa.tahun_akademik, pa.semester, m.nim, m.nama_mahasiswa, m.email, m.no_hp,
           m.saldo_jam_minus_murni, m.saldo_jam_minus_kompensasi, m.saldo_jam_plus_murni,
           m.saldo_jam_plus_kompensasi, m.status_mahasiswa
    FROM mahasiswa m
    JOIN kelas k ON m.id_kelas = k.id_kelas
    JOIN periode_akademik pa ON m.id_periode_akademik = pa.id_periode_akademik
    WHERE m.status_mahasiswa = 'Aktif'
    ORDER BY m.nama_mahasiswa ASC;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `usp_select_mahasiswa_aktif` ()   BEGIN
    SELECT m.id_mahasiswa, m.id_kelas, k.nama_kelas, k.tingkat, m.id_periode_akademik,
           pa.tahun_akademik, pa.semester, m.nim, m.nama_mahasiswa, m.email, m.no_hp,
           m.saldo_jam_minus_murni, m.saldo_jam_minus_kompensasi, m.saldo_jam_plus_murni,
           m.saldo_jam_plus_kompensasi, m.status_mahasiswa
    FROM mahasiswa m
    JOIN kelas k ON m.id_kelas = k.id_kelas
    JOIN periode_akademik pa ON m.id_periode_akademik = pa.id_periode_akademik
    WHERE m.status_mahasiswa = 'Aktif'
    ORDER BY m.nama_mahasiswa ASC;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `usp_select_mahasiswa_aktif_by_kelas` (IN `p_id_kelas` INT)   BEGIN
    SELECT p.id_pengguna AS id_pengguna_mahasiswa,m.id_mahasiswa,m.nim,m.nama_mahasiswa,k.id_kelas,k.nama_kelas,k.tingkat
    FROM mahasiswa m JOIN pengguna p ON p.id_mahasiswa=m.id_mahasiswa AND p.role='Mahasiswa' AND p.status_akun='Aktif'
    JOIN kelas k ON m.id_kelas=k.id_kelas
    WHERE m.status_mahasiswa='Aktif' AND k.status_kelas='Aktif' AND k.id_kelas=p_id_kelas
    ORDER BY m.nim,m.nama_mahasiswa;
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

CREATE DEFINER=`root`@`localhost` PROCEDURE `usp_select_mahasiswa_by_id` (IN `p_id_mahasiswa` INT)   BEGIN
    SELECT * FROM mahasiswa WHERE id_mahasiswa=p_id_mahasiswa LIMIT 1;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `usp_select_mata_kuliah_aktif` ()   BEGIN
    SELECT
        id_matakuliah,
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

CREATE DEFINER=`root`@`localhost` PROCEDURE `usp_select_mata_kuliah_by_id` (IN `p_id_matakuliah` INT)   BEGIN
    SELECT * FROM mata_kuliah WHERE id_matakuliah=p_id_matakuliah LIMIT 1;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `usp_select_mata_kuliah_kelas_untuk_jam_minus` (IN `p_id_kelas` INT)   BEGIN
    SELECT d.id_detail_kelas_pada_mata_kuliah,mk.id_matakuliah AS id_mata_kuliah,mk.kode_mata_kuliah,mk.nama_mata_kuliah,mk.sks,mk.semester
    FROM detail_kelas_pada_mata_kuliah d JOIN mata_kuliah mk ON d.id_mata_kuliah=mk.id_matakuliah
    JOIN kelas k ON d.id_kelas=k.id_kelas
    WHERE d.id_kelas=p_id_kelas AND k.status_kelas='Aktif' AND mk.status_mata_kuliah='Aktif'
    ORDER BY mk.semester,mk.nama_mata_kuliah;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `usp_select_mata_kuliah_mahasiswa` (IN `p_id_pengguna` INT)   BEGIN
    DECLARE v_id_mahasiswa INT;
    DECLARE v_id_kelas INT;
    IF NOT EXISTS (SELECT 1 FROM pengguna WHERE id_pengguna=p_id_pengguna AND role='Mahasiswa' AND status_akun='Aktif') THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Akun mahasiswa tidak ditemukan atau tidak aktif'; END IF;
    SELECT id_mahasiswa INTO v_id_mahasiswa FROM pengguna WHERE id_pengguna=p_id_pengguna;
    IF NOT EXISTS (SELECT 1 FROM mahasiswa WHERE id_mahasiswa=v_id_mahasiswa AND status_mahasiswa='Aktif') THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Data mahasiswa tidak ditemukan atau tidak aktif'; END IF;
    SELECT id_kelas INTO v_id_kelas FROM mahasiswa WHERE id_mahasiswa=v_id_mahasiswa;
    SELECT k.nama_kelas,k.tingkat,mk.kode_mata_kuliah,mk.nama_mata_kuliah,mk.sks,mk.semester
    FROM detail_kelas_pada_mata_kuliah d
    JOIN kelas k ON d.id_kelas=k.id_kelas
    JOIN mata_kuliah mk ON d.id_mata_kuliah=mk.id_matakuliah
    WHERE d.id_kelas=v_id_kelas AND k.status_kelas='Aktif' AND mk.status_mata_kuliah='Aktif'
    ORDER BY mk.semester,mk.nama_mata_kuliah;
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

CREATE DEFINER=`root`@`localhost` PROCEDURE `usp_select_pengaduan_by_id` (IN `p_id_pengaduan` INT)   BEGIN
 SELECT pkf.id_pengaduan_kerusakan_fasilitas,pkf.id_fasilitas,pkf.id_detail_fasilitas_pada_kelas,f.nama_fasilitas,
        COALESCE(k_hist.nama_kelas,k_current.nama_kelas,'-') AS nama_kelas,pkf.deskripsi_kerusakan,
        pkf.tanggal_pengaduan,pkf.bukti_kerusakan_url,pkf.status_pengaduan,pkf.alsan_penolakan,
        dp.id_pengguna AS id_pelapor,p.username AS username_pelapor,
        COALESCE(m.nama_mahasiswa,pg.nama_pengajar) AS nama_pelapor
 FROM pengaduan_kerusakan_fasilitas pkf
 JOIN fasilitas f ON pkf.id_fasilitas=f.id_fasilitas
 LEFT JOIN detail_pengguna_pada_pengaduan_kerusakan_fasilitas dp ON pkf.id_pengaduan_kerusakan_fasilitas=dp.id_pengaduan_kerusakan_fasilitas AND dp.peran_pengguna='Pelapor'
 LEFT JOIN pengguna p ON dp.id_pengguna=p.id_pengguna
 LEFT JOIN mahasiswa m ON p.id_mahasiswa=m.id_mahasiswa
 LEFT JOIN pengajar pg ON p.id_pengajar=pg.id_pengajar
 LEFT JOIN detail_fasilitas_pada_kelas dfpk ON pkf.id_detail_fasilitas_pada_kelas=dfpk.id_detail_fasilitas_pada_kelas
 LEFT JOIN kelas k_hist ON dfpk.id_kelas=k_hist.id_kelas
 LEFT JOIN kelas k_current ON m.id_kelas=k_current.id_kelas
 WHERE pkf.id_pengaduan_kerusakan_fasilitas=p_id_pengaduan LIMIT 1;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `usp_select_pengaduan_kerusakan_fasilitas` ()   BEGIN
    SELECT pkf.id_pengaduan_kerusakan_fasilitas,pkf.id_fasilitas,pkf.id_detail_fasilitas_pada_kelas,f.nama_fasilitas,
           COALESCE(k_hist.nama_kelas,k_current.nama_kelas,'-') AS nama_kelas,
           pkf.deskripsi_kerusakan,pkf.tanggal_pengaduan,pkf.bukti_kerusakan_url,
           pkf.pelaku_kerusakan,pkf.status_pengaduan,pkf.alsan_penolakan,
           dp_pelapor.id_pengguna AS id_pelapor,p_pelapor.username AS username_pelapor,
           COALESCE(m_pelapor.nama_mahasiswa,pg_pelapor.nama_pengajar) AS nama_pelapor,
           dp_verifikator.id_pengguna AS id_verifikator,p_verifikator.username AS username_verifikator,
           COALESCE(m_verifikator.nama_mahasiswa,pg_verifikator.nama_pengajar) AS nama_verifikator
    FROM pengaduan_kerusakan_fasilitas pkf
    JOIN fasilitas f ON pkf.id_fasilitas=f.id_fasilitas
    LEFT JOIN detail_pengguna_pada_pengaduan_kerusakan_fasilitas dp_pelapor ON pkf.id_pengaduan_kerusakan_fasilitas=dp_pelapor.id_pengaduan_kerusakan_fasilitas AND dp_pelapor.peran_pengguna='Pelapor'
    LEFT JOIN pengguna p_pelapor ON dp_pelapor.id_pengguna=p_pelapor.id_pengguna
    LEFT JOIN mahasiswa m_pelapor ON p_pelapor.id_mahasiswa=m_pelapor.id_mahasiswa
    LEFT JOIN pengajar pg_pelapor ON p_pelapor.id_pengajar=pg_pelapor.id_pengajar
    LEFT JOIN detail_pengguna_pada_pengaduan_kerusakan_fasilitas dp_verifikator ON pkf.id_pengaduan_kerusakan_fasilitas=dp_verifikator.id_pengaduan_kerusakan_fasilitas AND dp_verifikator.peran_pengguna='Verifikator'
    LEFT JOIN pengguna p_verifikator ON dp_verifikator.id_pengguna=p_verifikator.id_pengguna
    LEFT JOIN mahasiswa m_verifikator ON p_verifikator.id_mahasiswa=m_verifikator.id_mahasiswa
    LEFT JOIN pengajar pg_verifikator ON p_verifikator.id_pengajar=pg_verifikator.id_pengajar
    LEFT JOIN detail_fasilitas_pada_kelas dfpk ON pkf.id_detail_fasilitas_pada_kelas=dfpk.id_detail_fasilitas_pada_kelas
    LEFT JOIN kelas k_hist ON dfpk.id_kelas=k_hist.id_kelas
    LEFT JOIN kelas k_current ON m_pelapor.id_kelas=k_current.id_kelas
    ORDER BY CASE WHEN pkf.status_pengaduan='Menunggu Verifikasi' THEN 0 ELSE 1 END,
             pkf.tanggal_pengaduan DESC,pkf.id_pengaduan_kerusakan_fasilitas DESC;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `usp_select_pengajar` ()   BEGIN
    SELECT id_pengajar, nip, nama_pengajar, email, no_hp, status_pengajar
    FROM pengajar WHERE status_pengajar = 'Aktif' ORDER BY nama_pengajar ASC;
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

CREATE DEFINER=`root`@`localhost` PROCEDURE `usp_select_pengajar_by_id` (IN `p_id_pengajar` INT)   BEGIN
    SELECT * FROM pengajar WHERE id_pengajar=p_id_pengajar LIMIT 1;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `usp_select_pengajar_mata_kuliah_kelas` ()   BEGIN
    SELECT d.id_detail_kelas_pada_mata_kuliah,k.id_kelas,k.nama_kelas,k.tingkat,
           mk.id_matakuliah AS id_mata_kuliah,mk.kode_mata_kuliah,mk.nama_mata_kuliah,mk.sks,mk.semester
    FROM detail_kelas_pada_mata_kuliah d
    JOIN kelas k ON d.id_kelas=k.id_kelas
    JOIN mata_kuliah mk ON d.id_mata_kuliah=mk.id_matakuliah
    WHERE k.status_kelas='Aktif' AND mk.status_mata_kuliah='Aktif'
    ORDER BY k.tingkat,k.nama_kelas,mk.semester,mk.nama_mata_kuliah;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `usp_select_pengajar_mata_kuliah_kelas_by_id` (IN `p_id_detail_kelas_pada_mata_kuliah` INT)   BEGIN
    SELECT d.id_detail_kelas_pada_mata_kuliah,d.id_kelas,k.nama_kelas,k.tingkat,
           d.id_mata_kuliah,mk.kode_mata_kuliah,mk.nama_mata_kuliah,mk.sks,mk.semester
    FROM detail_kelas_pada_mata_kuliah d
    JOIN kelas k ON d.id_kelas=k.id_kelas
    JOIN mata_kuliah mk ON d.id_mata_kuliah=mk.id_matakuliah
    WHERE d.id_detail_kelas_pada_mata_kuliah=p_id_detail_kelas_pada_mata_kuliah;
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

CREATE DEFINER=`root`@`localhost` PROCEDURE `usp_select_pengajuan_jam_plus_by_id` (IN `p_id_pengajuan` INT)   BEGIN
    SELECT pjp.*,k.nama_kegiatan,k.penyelenggara,k.tanggal_kegiatan,
           m.nama_mahasiswa,m.nim,p.username AS username_pengaju
    FROM pengajuan_jam_plus pjp
    LEFT JOIN kegiatan k ON pjp.id_kegiatan=k.id_kegiatan
    JOIN detail_pengguna_pada_pengajuan_jam_plus dp ON pjp.id_pengajuan_jam_plus=dp.id_pengajuan_jam_plus AND dp.peran_pengguna='Pengaju'
    JOIN pengguna p ON dp.id_pengguna=p.id_pengguna
    JOIN mahasiswa m ON p.id_mahasiswa=m.id_mahasiswa
    WHERE pjp.id_pengajuan_jam_plus=p_id_pengajuan
    LIMIT 1;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `usp_select_pengguna` ()   BEGIN
    SELECT p.id_pengguna, p.id_mahasiswa, m.nim, m.nama_mahasiswa, p.id_pengajar,
           pg.nip, pg.nama_pengajar, p.username, p.role, p.status_akun
    FROM pengguna p
    LEFT JOIN mahasiswa m ON p.id_mahasiswa = m.id_mahasiswa
    LEFT JOIN pengajar pg ON p.id_pengajar = pg.id_pengajar
    WHERE p.status_akun = 'Aktif'
    ORDER BY p.username ASC;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `usp_select_pengguna_aktif` ()   BEGIN
    SELECT p.id_pengguna, p.id_mahasiswa, m.nim, m.nama_mahasiswa, p.id_pengajar,
           pg.nip, pg.nama_pengajar, p.username, p.role, p.status_akun
    FROM pengguna p
    LEFT JOIN mahasiswa m ON p.id_mahasiswa = m.id_mahasiswa
    LEFT JOIN pengajar pg ON p.id_pengajar = pg.id_pengajar
    WHERE p.status_akun = 'Aktif'
    ORDER BY p.username ASC;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `usp_select_pengguna_by_id` (IN `p_id_pengguna` INT)   BEGIN
    SELECT * FROM pengguna WHERE id_pengguna=p_id_pengguna LIMIT 1;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `usp_select_periode_akademik` ()   BEGIN
    SELECT id_periode_akademik, tahun_akademik, semester, tanggal_mulai, tanggal_selesai, status_periode
    FROM periode_akademik
    WHERE status_periode = 'Aktif'
    ORDER BY tanggal_mulai DESC, id_periode_akademik DESC;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `usp_select_periode_akademik_by_id` (IN `p_id_periode_akademik` INT)   BEGIN
    SELECT id_periode_akademik, tahun_akademik, semester, tanggal_mulai, tanggal_selesai, status_periode
    FROM periode_akademik
    WHERE id_periode_akademik = p_id_periode_akademik AND status_periode = 'Aktif';
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `usp_select_periode_tersedia_mahasiswa` ()   BEGIN
    SELECT id_periode_akademik,tahun_akademik,semester,tanggal_mulai,tanggal_selesai,status_periode
    FROM periode_akademik
    WHERE status_periode='Aktif' AND tanggal_selesai>=CURDATE()
    ORDER BY tanggal_mulai DESC;
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

CREATE DEFINER=`root`@`localhost` PROCEDURE `usp_soft_delete_mata_kuliah` (IN `p_id` INT)   BEGIN UPDATE mata_kuliah SET status_mata_kuliah='Tidak Aktif' WHERE id_matakuliah=p_id AND status_mata_kuliah='Aktif'; IF ROW_COUNT()=0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Mata kuliah tidak ditemukan atau sudah tidak aktif'; END IF; END$$

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
    DECLARE v_mulai DATE;
    DECLARE v_selesai DATE;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET @simat_izinkan_nonaktif_periode = NULL;
        RESIGNAL;
    END;

    IF NOT EXISTS (SELECT 1 FROM periode_akademik WHERE id_periode_akademik = p_id_periode_akademik) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Data periode akademik tidak ditemukan';
    END IF;

    SELECT tanggal_mulai, tanggal_selesai
    INTO v_mulai, v_selesai
    FROM periode_akademik
    WHERE id_periode_akademik = p_id_periode_akademik;

    IF CURDATE() BETWEEN v_mulai AND v_selesai THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Periode akademik yang sedang berlangsung tidak dapat dinonaktifkan';
    END IF;

    SET @simat_izinkan_nonaktif_periode = 1;
    UPDATE periode_akademik
    SET status_periode = 'Tidak Aktif'
    WHERE id_periode_akademik = p_id_periode_akademik;
    SET @simat_izinkan_nonaktif_periode = NULL;

    SELECT 'Data periode akademik berhasil dinonaktifkan' AS Pesan,
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

CREATE DEFINER=`root`@`localhost` PROCEDURE `usp_update_detail_fasilitas_pada_kelas` (IN `p_id_detail_fasilitas_pada_kelas` INT, IN `p_id_kelas` INT, IN `p_id_fasilitas` INT)   BEGIN
    IF NOT EXISTS (SELECT 1 FROM detail_fasilitas_pada_kelas WHERE id_detail_fasilitas_pada_kelas = p_id_detail_fasilitas_pada_kelas) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Data fasilitas kelas tidak ditemukan'; END IF;
    IF EXISTS (SELECT 1 FROM detail_fasilitas_pada_kelas WHERE id_kelas = p_id_kelas AND id_fasilitas = p_id_fasilitas AND id_detail_fasilitas_pada_kelas <> p_id_detail_fasilitas_pada_kelas) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Fasilitas sudah terhubung ke kelas tersebut'; END IF;
    UPDATE detail_fasilitas_pada_kelas SET id_kelas = p_id_kelas, id_fasilitas = p_id_fasilitas WHERE id_detail_fasilitas_pada_kelas = p_id_detail_fasilitas_pada_kelas;
    SELECT 'Data fasilitas kelas berhasil diupdate' AS Pesan, p_id_detail_fasilitas_pada_kelas AS id_detail_fasilitas_pada_kelas;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `usp_update_fasilitas` (IN `p_id_fasilitas` INT, IN `p_nama_fasilitas` VARCHAR(50), IN `p_harga` DECIMAL(15,2), IN `p_id_kelas_csv` TEXT)   BEGIN
    DECLARE v_csv TEXT;
    DECLARE v_token VARCHAR(30);
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        DROP TEMPORARY TABLE IF EXISTS tmp_kelas_fasilitas;
        RESIGNAL;
    END;

    SET p_nama_fasilitas = TRIM(p_nama_fasilitas);
    SET v_csv = TRIM(BOTH ',' FROM COALESCE(p_id_kelas_csv, ''));
    IF NOT EXISTS (SELECT 1 FROM fasilitas WHERE id_fasilitas=p_id_fasilitas AND status_fasilitas='Aktif') THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Data fasilitas tidak ditemukan atau tidak aktif';
    END IF;
    IF p_nama_fasilitas = '' OR p_harga IS NULL OR p_harga < 0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Data fasilitas tidak valid'; END IF;
    IF v_csv = '' THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Minimal satu kelas wajib dipilih'; END IF;
    IF EXISTS (SELECT 1 FROM fasilitas WHERE status_fasilitas='Aktif' AND UPPER(TRIM(nama_fasilitas))=UPPER(p_nama_fasilitas) AND id_fasilitas<>p_id_fasilitas) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Nama fasilitas sudah digunakan oleh fasilitas aktif lain';
    END IF;

    DROP TEMPORARY TABLE IF EXISTS tmp_kelas_fasilitas;
    CREATE TEMPORARY TABLE tmp_kelas_fasilitas (id_kelas INT PRIMARY KEY) ENGINE=MEMORY;
    WHILE v_csv <> '' DO
        SET v_token = TRIM(SUBSTRING_INDEX(v_csv, ',', 1));
        IF v_token NOT REGEXP '^[0-9]+$' OR CAST(v_token AS UNSIGNED) <= 0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Daftar kelas tidak valid'; END IF;
        INSERT IGNORE INTO tmp_kelas_fasilitas (id_kelas) VALUES (CAST(v_token AS UNSIGNED));
        IF INSTR(v_csv, ',') = 0 THEN SET v_csv = ''; ELSE SET v_csv = SUBSTRING(v_csv, INSTR(v_csv, ',') + 1); END IF;
    END WHILE;
    IF EXISTS (SELECT 1 FROM tmp_kelas_fasilitas t LEFT JOIN kelas k ON k.id_kelas=t.id_kelas AND k.status_kelas='Aktif' WHERE k.id_kelas IS NULL) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Terdapat kelas yang tidak ditemukan atau tidak aktif';
    END IF;

    START TRANSACTION;
    SELECT id_fasilitas FROM fasilitas WHERE id_fasilitas=p_id_fasilitas FOR UPDATE;
    UPDATE fasilitas SET nama_fasilitas=p_nama_fasilitas, harga=p_harga WHERE id_fasilitas=p_id_fasilitas;
    INSERT INTO detail_fasilitas_pada_kelas (id_kelas,id_fasilitas,status_detail_fasilitas_pada_kelas)
    SELECT id_kelas,p_id_fasilitas,'Aktif' FROM tmp_kelas_fasilitas
    ON DUPLICATE KEY UPDATE status_detail_fasilitas_pada_kelas = CASE
        WHEN status_detail_fasilitas_pada_kelas='Rusak' THEN 'Rusak' ELSE 'Aktif' END;
    UPDATE detail_fasilitas_pada_kelas d
    LEFT JOIN tmp_kelas_fasilitas t ON t.id_kelas=d.id_kelas
    SET d.status_detail_fasilitas_pada_kelas='Tidak Aktif'
    WHERE d.id_fasilitas=p_id_fasilitas AND t.id_kelas IS NULL AND d.status_detail_fasilitas_pada_kelas='Aktif';
    COMMIT;
    DROP TEMPORARY TABLE IF EXISTS tmp_kelas_fasilitas;
    SELECT 'Data fasilitas dan kelas berhasil diubah' AS Pesan, p_id_fasilitas AS id_fasilitas;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `usp_update_kegiatan` (IN `p_id_kegiatan` INT, IN `p_nama_kegiatan` VARCHAR(50), IN `p_penyelenggara` VARCHAR(20), IN `p_tanggal_kegiatan` DATE)   BEGIN
    SET p_nama_kegiatan=TRIM(p_nama_kegiatan);
    IF NOT EXISTS (SELECT 1 FROM kegiatan WHERE id_kegiatan=p_id_kegiatan AND status_kegiatan='Aktif') THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Data kegiatan tidak ditemukan atau tidak aktif'; END IF;
    IF p_nama_kegiatan='' OR p_penyelenggara NOT IN ('ASTRAtech','BEM','MPM','HIMMA','UKM','Prodi') THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Data kegiatan tidak valid'; END IF;
    IF EXISTS (SELECT 1 FROM kegiatan WHERE status_kegiatan='Aktif' AND id_kegiatan<>p_id_kegiatan AND UPPER(TRIM(nama_kegiatan))=UPPER(p_nama_kegiatan) AND penyelenggara=p_penyelenggara AND tanggal_kegiatan <=> p_tanggal_kegiatan) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Kegiatan aktif dengan seluruh input yang sama sudah tersedia';
    END IF;
    UPDATE kegiatan SET nama_kegiatan=p_nama_kegiatan,penyelenggara=p_penyelenggara,tanggal_kegiatan=p_tanggal_kegiatan WHERE id_kegiatan=p_id_kegiatan;
    SELECT 'Data kegiatan berhasil diubah' AS Pesan,p_id_kegiatan AS id_kegiatan;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `usp_update_kelas` (IN `p_id_kelas` INT, IN `p_nama_kelas` VARCHAR(5), IN `p_tingkat` VARCHAR(1))   BEGIN
    SET p_nama_kelas = UPPER(TRIM(p_nama_kelas));
    IF NOT EXISTS (SELECT 1 FROM kelas WHERE id_kelas = p_id_kelas AND status_kelas = 'Aktif') THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Data kelas tidak ditemukan atau tidak aktif';
    END IF;
    IF p_nama_kelas IS NULL OR p_nama_kelas = '' OR p_tingkat NOT IN ('1','2','3','4') THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Nama atau tingkat kelas tidak valid';
    END IF;
    IF EXISTS (SELECT 1 FROM kelas WHERE status_kelas = 'Aktif' AND UPPER(TRIM(nama_kelas)) = p_nama_kelas AND id_kelas <> p_id_kelas) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Nama kelas sudah digunakan oleh kelas aktif lain';
    END IF;
    UPDATE kelas SET nama_kelas = p_nama_kelas, tingkat = p_tingkat WHERE id_kelas = p_id_kelas;
    SELECT 'Data kelas berhasil diubah' AS Pesan, p_id_kelas AS id_kelas;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `usp_update_mahasiswa` (IN `p_id_mahasiswa` INT, IN `p_id_kelas` INT, IN `p_id_periode_akademik` INT, IN `p_nim` VARCHAR(20), IN `p_nama_mahasiswa` VARCHAR(50), IN `p_email` VARCHAR(50), IN `p_no_hp` VARCHAR(20), IN `p_status_mahasiswa` VARCHAR(20))   BEGIN
    DECLARE v_id_kelas_lama INT;
    DECLARE v_id_periode_lama INT;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN ROLLBACK; RESIGNAL; END;

    SET p_email = NULLIF(TRIM(p_email), '');
    SET p_no_hp = NULLIF(TRIM(p_no_hp), '');

    IF NOT EXISTS (SELECT 1 FROM mahasiswa WHERE id_mahasiswa = p_id_mahasiswa AND status_mahasiswa = 'Aktif') THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Data mahasiswa tidak ditemukan atau tidak aktif';
    END IF;
    IF p_status_mahasiswa NOT IN ('Aktif','Lulus','Cuti') THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Status mahasiswa tidak valid';
    END IF;
    IF p_no_hp IS NOT NULL AND p_no_hp NOT REGEXP '^[0-9]{10,13}$' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No HP harus terdiri dari 10 sampai 13 digit';
    END IF;
    IF NOT EXISTS (SELECT 1 FROM kelas WHERE id_kelas = p_id_kelas AND status_kelas = 'Aktif') THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Kelas tidak ditemukan atau tidak aktif';
    END IF;
    IF NOT EXISTS (SELECT 1 FROM periode_akademik WHERE id_periode_akademik = p_id_periode_akademik AND status_periode = 'Aktif' AND tanggal_selesai >= CURDATE()) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Periode akademik tidak valid atau sudah berakhir';
    END IF;
    IF EXISTS (SELECT 1 FROM mahasiswa WHERE nim = p_nim AND id_mahasiswa <> p_id_mahasiswa) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'NIM sudah digunakan oleh mahasiswa lain';
    END IF;

    START TRANSACTION;
    SELECT id_kelas, id_periode_akademik
    INTO v_id_kelas_lama, v_id_periode_lama
    FROM mahasiswa
    WHERE id_mahasiswa = p_id_mahasiswa
    FOR UPDATE;

    IF v_id_kelas_lama <> p_id_kelas THEN
        UPDATE kelas SET jumlah_mahasiswa = GREATEST(jumlah_mahasiswa - 1, 0) WHERE id_kelas = v_id_kelas_lama;
        UPDATE kelas SET jumlah_mahasiswa = jumlah_mahasiswa + 1 WHERE id_kelas = p_id_kelas;
    END IF;

    UPDATE mahasiswa
    SET id_kelas = p_id_kelas,
        id_periode_akademik = p_id_periode_akademik,
        nim = TRIM(p_nim),
        nama_mahasiswa = TRIM(p_nama_mahasiswa),
        email = p_email,
        no_hp = p_no_hp,
        status_mahasiswa = p_status_mahasiswa,
        saldo_jam_plus_murni = CASE WHEN v_id_periode_lama <> p_id_periode_akademik THEN 0 ELSE saldo_jam_plus_murni END,
        saldo_jam_plus_kompensasi = CASE WHEN v_id_periode_lama <> p_id_periode_akademik THEN 0 ELSE saldo_jam_plus_kompensasi END
    WHERE id_mahasiswa = p_id_mahasiswa;

    COMMIT;
    SELECT 'Data mahasiswa berhasil diupdate' AS Pesan,
           p_id_mahasiswa AS id_mahasiswa,
           IF(v_id_periode_lama <> p_id_periode_akademik, 1, 0) AS saldo_plus_direset;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `usp_update_mata_kuliah` (IN `p_id` INT, IN `p_nama` VARCHAR(100), IN `p_kode` VARCHAR(20), IN `p_sks` INT, IN `p_semester` INT, IN `p_status` VARCHAR(20), IN `p_id_kelas_csv` TEXT)   BEGIN
    DECLARE v_csv TEXT;
    DECLARE v_token VARCHAR(30);
    DECLARE v_id_mata_kuliah_ditemukan INT DEFAULT NULL;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET v_id_mata_kuliah_ditemukan = NULL;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        DROP TEMPORARY TABLE IF EXISTS tmp_kelas_mata_kuliah;
        RESIGNAL;
    END;

    SET p_nama = TRIM(p_nama);
    SET p_kode = UPPER(TRIM(p_kode));
    SET v_csv = TRIM(BOTH ',' FROM COALESCE(p_id_kelas_csv, ''));

    IF p_status NOT IN ('Aktif','Tidak Aktif') THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Status mata kuliah tidak valid';
    END IF;
    IF p_nama = '' OR p_kode = '' OR p_sks <= 0 OR p_semester NOT BETWEEN 1 AND 8 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Data mata kuliah tidak valid';
    END IF;
    IF v_csv = '' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Minimal satu kelas aktif wajib dipilih';
    END IF;
    IF EXISTS (SELECT 1 FROM mata_kuliah WHERE kode_mata_kuliah = p_kode AND id_matakuliah <> p_id) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Kode mata kuliah sudah digunakan';
    END IF;

    DROP TEMPORARY TABLE IF EXISTS tmp_kelas_mata_kuliah;
    CREATE TEMPORARY TABLE tmp_kelas_mata_kuliah (id_kelas INT PRIMARY KEY) ENGINE=MEMORY;
    WHILE v_csv <> '' DO
        SET v_token = TRIM(SUBSTRING_INDEX(v_csv, ',', 1));
        IF v_token NOT REGEXP '^[0-9]+$' OR CAST(v_token AS UNSIGNED) <= 0 THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Daftar kelas tidak valid';
        END IF;
        INSERT IGNORE INTO tmp_kelas_mata_kuliah (id_kelas) VALUES (CAST(v_token AS UNSIGNED));
        IF INSTR(v_csv, ',') = 0 THEN
            SET v_csv = '';
        ELSE
            SET v_csv = SUBSTRING(v_csv, INSTR(v_csv, ',') + 1);
        END IF;
    END WHILE;

    IF EXISTS (
        SELECT 1
        FROM tmp_kelas_mata_kuliah t
        LEFT JOIN kelas k ON k.id_kelas = t.id_kelas AND k.status_kelas = 'Aktif'
        WHERE k.id_kelas IS NULL
    ) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Terdapat kelas yang tidak ditemukan atau tidak aktif';
    END IF;

    START TRANSACTION;
    SELECT id_matakuliah
    INTO v_id_mata_kuliah_ditemukan
    FROM mata_kuliah
    WHERE id_matakuliah = p_id
    FOR UPDATE;

    IF v_id_mata_kuliah_ditemukan IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Mata kuliah tidak ditemukan';
    END IF;

    UPDATE mata_kuliah
    SET nama_mata_kuliah = p_nama,
        kode_mata_kuliah = p_kode,
        sks = p_sks,
        semester = p_semester,
        status_mata_kuliah = p_status
    WHERE id_matakuliah = p_id;

    INSERT INTO detail_kelas_pada_mata_kuliah (id_mata_kuliah, id_kelas)
    SELECT p_id, id_kelas FROM tmp_kelas_mata_kuliah
    ON DUPLICATE KEY UPDATE id_mata_kuliah = VALUES(id_mata_kuliah);

    IF EXISTS (
        SELECT 1
        FROM detail_kelas_pada_mata_kuliah d
        JOIN pemberian_jam_minus pjm
          ON pjm.id_detail_kelas_pada_mata_kuliah = d.id_detail_kelas_pada_mata_kuliah
        LEFT JOIN tmp_kelas_mata_kuliah t ON t.id_kelas = d.id_kelas
        WHERE d.id_mata_kuliah = p_id
          AND t.id_kelas IS NULL
    ) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Kelas tidak dapat dilepas karena relasi mata kuliah sudah digunakan pada transaksi jam minus';
    END IF;

    DELETE d
    FROM detail_kelas_pada_mata_kuliah d
    LEFT JOIN tmp_kelas_mata_kuliah t ON t.id_kelas = d.id_kelas
    WHERE d.id_mata_kuliah = p_id
      AND t.id_kelas IS NULL;

    COMMIT;
    DROP TEMPORARY TABLE IF EXISTS tmp_kelas_mata_kuliah;
    SELECT 'Data mata kuliah dan kelas berhasil diubah' AS Pesan, p_id AS id_mata_kuliah;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `usp_update_password_pengguna` (IN `p_id_pengguna` INT, IN `p_password` VARCHAR(255))   BEGIN
    IF p_password IS NULL OR p_password = '' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Password tidak valid';
    END IF;
    UPDATE pengguna SET password = p_password WHERE id_pengguna = p_id_pengguna;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `usp_update_pengajar` (IN `p_id_pengajar` INT, IN `p_nip` VARCHAR(20), IN `p_nama_pengajar` VARCHAR(50), IN `p_email` VARCHAR(50), IN `p_no_hp` VARCHAR(20))   BEGIN
    SET p_email = NULLIF(TRIM(p_email), '');
    SET p_no_hp = NULLIF(TRIM(p_no_hp), '');
    IF NOT EXISTS (SELECT 1 FROM pengajar WHERE id_pengajar = p_id_pengajar AND status_pengajar = 'Aktif') THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Data pengajar tidak ditemukan atau tidak aktif';
    END IF;
    IF p_no_hp IS NOT NULL AND p_no_hp NOT REGEXP '^[0-9]{10,13}$' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No HP harus terdiri dari 10 sampai 13 digit';
    END IF;
    IF EXISTS (SELECT 1 FROM pengajar WHERE nip = p_nip AND id_pengajar <> p_id_pengajar) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'NIP sudah digunakan oleh pengajar lain'; END IF;
    UPDATE pengajar SET nip = TRIM(p_nip), nama_pengajar = TRIM(p_nama_pengajar), email = p_email, no_hp = p_no_hp WHERE id_pengajar = p_id_pengajar;
    SELECT 'Data pengajar berhasil diupdate' AS Pesan, p_id_pengajar AS id_pengajar;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `usp_update_pengajar_mata_kuliah_kelas` (IN `p_id_detail_kelas_pada_mata_kuliah` INT, IN `p_id_kelas` INT, IN `p_id_mata_kuliah` INT)   BEGIN
    IF NOT EXISTS (SELECT 1 FROM detail_kelas_pada_mata_kuliah WHERE id_detail_kelas_pada_mata_kuliah=p_id_detail_kelas_pada_mata_kuliah) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Data mata kuliah kelas tidak ditemukan'; END IF;
    IF NOT EXISTS (SELECT 1 FROM kelas WHERE id_kelas=p_id_kelas AND status_kelas='Aktif') OR NOT EXISTS (SELECT 1 FROM mata_kuliah WHERE id_matakuliah=p_id_mata_kuliah AND status_mata_kuliah='Aktif') THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Kelas atau mata kuliah tidak aktif'; END IF;
    IF EXISTS (SELECT 1 FROM detail_kelas_pada_mata_kuliah WHERE id_kelas=p_id_kelas AND id_mata_kuliah=p_id_mata_kuliah AND id_detail_kelas_pada_mata_kuliah<>p_id_detail_kelas_pada_mata_kuliah) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Mata kuliah sudah ditentukan pada kelas tersebut'; END IF;
    UPDATE detail_kelas_pada_mata_kuliah SET id_kelas=p_id_kelas,id_mata_kuliah=p_id_mata_kuliah WHERE id_detail_kelas_pada_mata_kuliah=p_id_detail_kelas_pada_mata_kuliah;
    SELECT 'Data mata kuliah kelas berhasil diubah' AS Pesan,p_id_detail_kelas_pada_mata_kuliah AS id_detail_kelas_pada_mata_kuliah;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `usp_update_pengguna` (IN `p_id_pengguna` INT, IN `p_id_mahasiswa` INT, IN `p_id_pengajar` INT, IN `p_username` VARCHAR(20), IN `p_password` VARCHAR(255), IN `p_role` VARCHAR(30))   BEGIN
    SET p_username=TRIM(p_username);
    IF p_username='' OR CHAR_LENGTH(p_username)>20 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Username wajib diisi dan maksimal 20 karakter'; END IF;
    IF NOT EXISTS (SELECT 1 FROM pengguna WHERE id_pengguna = p_id_pengguna AND status_akun = 'Aktif') THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Data pengguna tidak ditemukan atau tidak aktif'; END IF;
    IF EXISTS (SELECT 1 FROM pengguna WHERE username = TRIM(p_username) AND id_pengguna <> p_id_pengguna) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Username sudah digunakan oleh pengguna lain'; END IF;
    IF p_role = 'Mahasiswa' THEN
        IF p_id_mahasiswa IS NULL OR p_id_pengajar IS NOT NULL THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Relasi akun mahasiswa tidak valid'; END IF;
    ELSE
        IF p_id_pengajar IS NULL OR p_id_mahasiswa IS NOT NULL THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Relasi akun pengajar tidak valid'; END IF;
    END IF;
    UPDATE pengguna SET id_mahasiswa = p_id_mahasiswa, id_pengajar = p_id_pengajar, username = TRIM(p_username), password = COALESCE(NULLIF(p_password, ''), password), role = p_role WHERE id_pengguna = p_id_pengguna;
    SELECT 'Data pengguna berhasil diupdate' AS Pesan, p_id_pengguna AS id_pengguna;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `usp_update_periode_akademik` (IN `p_id_periode_akademik` INT, IN `p_tahun_akademik` VARCHAR(10), IN `p_semester` VARCHAR(10), IN `p_tanggal_mulai` DATE, IN `p_tanggal_selesai` DATE)   BEGIN
    DECLARE v_tahun_awal INT;
    DECLARE v_tahun_akhir INT;

    IF NOT EXISTS (
        SELECT 1
        FROM periode_akademik
        WHERE id_periode_akademik = p_id_periode_akademik
          AND status_periode = 'Aktif'
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
            'Data periode akademik tidak ditemukan atau tidak aktif';
    END IF;

    IF p_tahun_akademik NOT REGEXP '^[0-9]{4}/[0-9]{4}$' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
            'Format tahun akademik harus YYYY/YYYY';
    END IF;

    SET v_tahun_awal =
        CAST(LEFT(p_tahun_akademik, 4) AS UNSIGNED);

    SET v_tahun_akhir =
        CAST(RIGHT(p_tahun_akademik, 4) AS UNSIGNED);

    IF v_tahun_akhir <> v_tahun_awal + 1 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
            'Tahun kedua harus satu tahun setelah tahun pertama';
    END IF;

    IF p_semester NOT IN ('Ganjil', 'Genap') THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Semester tidak valid';
    END IF;

    IF p_tanggal_mulai >= p_tanggal_selesai THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
            'Tanggal mulai harus lebih kecil dari tanggal selesai';
    END IF;

    IF YEAR(p_tanggal_mulai)
           NOT BETWEEN v_tahun_awal AND v_tahun_akhir
       OR YEAR(p_tanggal_selesai)
           NOT BETWEEN v_tahun_awal AND v_tahun_akhir THEN

        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
            'Tanggal periode harus berada dalam tahun akademik';
    END IF;

    IF EXISTS (
        SELECT 1
        FROM periode_akademik
        WHERE tahun_akademik = p_tahun_akademik
          AND semester = p_semester
          AND id_periode_akademik <> p_id_periode_akademik
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
            'Tahun akademik dan semester sudah digunakan oleh data lain';
    END IF;

    UPDATE periode_akademik
    SET
        tahun_akademik = p_tahun_akademik,
        semester = p_semester,
        tanggal_mulai = p_tanggal_mulai,
        tanggal_selesai = p_tanggal_selesai
    WHERE id_periode_akademik = p_id_periode_akademik;

    SELECT
        'Data periode akademik berhasil diubah'
            AS Pesan,
        p_id_periode_akademik
            AS id_periode_akademik;
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

CREATE DEFINER=`root`@`localhost` PROCEDURE `usp_update_status_pengaduan_kerusakan_fasilitas` (IN `p_id_pengaduan_kerusakan_fasilitas` INT, IN `p_id_pengguna` INT, IN `p_status_pengaduan` VARCHAR(20), IN `p_alsan_penolakan` VARCHAR(255))   BEGIN
    DECLARE v_id_fasilitas INT DEFAULT NULL;
    DECLARE v_id_detail_fasilitas_kelas INT DEFAULT NULL;
    DECLARE v_id_pengguna_pelapor INT DEFAULT NULL;
    DECLARE v_status_lama VARCHAR(30) DEFAULT NULL;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN ROLLBACK; RESIGNAL; END;

    IF p_status_pengaduan NOT IN ('Diterima','Ditolak') THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Status pengaduan tidak valid';
    END IF;
    IF NOT EXISTS (
        SELECT 1 FROM pengguna
        WHERE id_pengguna = p_id_pengguna
          AND role = 'PIC Aset Fasilitas'
          AND status_akun = 'Aktif'
    ) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Verifikator bukan PIC Aset Fasilitas aktif';
    END IF;
    SET p_alsan_penolakan = NULLIF(TRIM(p_alsan_penolakan), '');
    IF p_status_pengaduan = 'Ditolak' AND p_alsan_penolakan IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Alasan penolakan wajib diisi';
    END IF;

    START TRANSACTION;
    SELECT id_fasilitas, id_detail_fasilitas_pada_kelas, status_pengaduan
      INTO v_id_fasilitas, v_id_detail_fasilitas_kelas, v_status_lama
    FROM pengaduan_kerusakan_fasilitas
    WHERE id_pengaduan_kerusakan_fasilitas = p_id_pengaduan_kerusakan_fasilitas
    FOR UPDATE;

    IF v_status_lama IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Data pengaduan tidak ditemukan';
    END IF;
    IF v_status_lama <> 'Menunggu Verifikasi' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Pengaduan sudah diverifikasi dan tidak dapat diproses ulang';
    END IF;

    UPDATE pengaduan_kerusakan_fasilitas
    SET status_pengaduan = p_status_pengaduan,
        alsan_penolakan = CASE WHEN p_status_pengaduan = 'Ditolak' THEN p_alsan_penolakan ELSE NULL END
    WHERE id_pengaduan_kerusakan_fasilitas = p_id_pengaduan_kerusakan_fasilitas;

    DELETE FROM detail_pengguna_pada_pengaduan_kerusakan_fasilitas
    WHERE id_pengaduan_kerusakan_fasilitas = p_id_pengaduan_kerusakan_fasilitas
      AND peran_pengguna = 'Verifikator';
    INSERT INTO detail_pengguna_pada_pengaduan_kerusakan_fasilitas (
        id_pengaduan_kerusakan_fasilitas, id_pengguna, peran_pengguna
    ) VALUES (p_id_pengaduan_kerusakan_fasilitas, p_id_pengguna, 'Verifikator');

    IF p_status_pengaduan = 'Diterima' THEN
        IF v_id_detail_fasilitas_kelas IS NOT NULL THEN
            IF NOT EXISTS (
                SELECT 1 FROM detail_fasilitas_pada_kelas
                WHERE id_detail_fasilitas_pada_kelas = v_id_detail_fasilitas_kelas
                  AND id_fasilitas = v_id_fasilitas
                  AND status_detail_fasilitas_pada_kelas IN ('Aktif','Rusak')
            ) THEN
                SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Fasilitas kelas pada saat pengaduan sudah tidak tersedia';
            END IF;
            UPDATE detail_fasilitas_pada_kelas
            SET status_detail_fasilitas_pada_kelas = 'Rusak'
            WHERE id_detail_fasilitas_pada_kelas = v_id_detail_fasilitas_kelas;
        ELSE
            SELECT id_pengguna INTO v_id_pengguna_pelapor
            FROM detail_pengguna_pada_pengaduan_kerusakan_fasilitas
            WHERE id_pengaduan_kerusakan_fasilitas = p_id_pengaduan_kerusakan_fasilitas
              AND peran_pengguna = 'Pelapor'
            LIMIT 1;
            CALL usp_update_status_detail_fasilitas_pada_kelas(v_id_pengguna_pelapor, v_id_fasilitas, 'Rusak');
        END IF;
    END IF;

    COMMIT;
    SELECT 'Status pengaduan berhasil diperbarui' AS Pesan,
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
    DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN ROLLBACK; RESIGNAL; END;
    IF p_status NOT IN ('Disetujui','Ditolak') THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Status verifikasi tidak valid'; END IF;
    IF NOT EXISTS (SELECT 1 FROM pengguna WHERE id_pengguna=p_id_verifikator AND role='PIC Tata Tertib' AND status_akun='Aktif') THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Verifikator tidak valid'; END IF;
    SET p_alasan_penolakan=NULLIF(TRIM(p_alasan_penolakan),'');
    IF p_status='Ditolak' AND p_alasan_penolakan IS NULL THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Alasan penolakan wajib diisi'; END IF;
    START TRANSACTION;
    SELECT status_pengajuan INTO v_status_lama FROM pengajuan_jam_plus WHERE id_pengajuan_jam_plus=p_id_pengajuan FOR UPDATE;
    IF v_status_lama IS NULL THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Data pengajuan tidak ditemukan'; END IF;
    IF v_status_lama<>'Menunggu Verifikasi' THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Pengajuan sudah diverifikasi'; END IF;
    UPDATE pengajuan_jam_plus SET status_pengajuan=p_status,alasan_penolakan=CASE WHEN p_status='Ditolak' THEN p_alasan_penolakan ELSE NULL END WHERE id_pengajuan_jam_plus=p_id_pengajuan;
    DELETE FROM detail_pengguna_pada_pengajuan_jam_plus WHERE id_pengajuan_jam_plus=p_id_pengajuan AND peran_pengguna='Verifikator';
    INSERT INTO detail_pengguna_pada_pengajuan_jam_plus (id_pengajuan_jam_plus,id_pengguna,peran_pengguna) VALUES (p_id_pengajuan,p_id_verifikator,'Verifikator');
    IF p_status='Disetujui' THEN
        SELECT pjp.jumlah_jam_plus,pjp.jenis_jam,pjp.sumber_jam,u.id_mahasiswa
        INTO v_jumlah_asli,v_jenis,v_sumber,v_id_mhs
        FROM pengajuan_jam_plus pjp
        JOIN detail_pengguna_pada_pengajuan_jam_plus dp ON pjp.id_pengajuan_jam_plus=dp.id_pengajuan_jam_plus AND dp.peran_pengguna='Pengaju'
        JOIN pengguna u ON dp.id_pengguna=u.id_pengguna
        WHERE pjp.id_pengajuan_jam_plus=p_id_pengajuan LIMIT 1;
        IF v_id_mhs IS NULL THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Mahasiswa pengaju tidak ditemukan'; END IF;
        SET v_jumlah_diterima=CASE WHEN v_sumber='Luar' THEN v_jumlah_asli*0.5 ELSE v_jumlah_asli END;
        IF v_jenis='Murni' THEN UPDATE mahasiswa SET saldo_jam_plus_murni=saldo_jam_plus_murni+v_jumlah_diterima WHERE id_mahasiswa=v_id_mhs;
        ELSEIF v_jenis='Kompensasi' THEN UPDATE mahasiswa SET saldo_jam_plus_kompensasi=saldo_jam_plus_kompensasi+v_jumlah_diterima WHERE id_mahasiswa=v_id_mhs;
        ELSE SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Jenis jam tidak valid'; END IF;
    END IF;
    COMMIT;
    SELECT 'Verifikasi pengajuan jam plus berhasil disimpan' AS Pesan,p_id_pengajuan AS id_pengajuan_jam_plus,p_status AS status_pengajuan;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `usp_validasi_referensi_mahasiswa` (IN `p_id_kelas` INT, IN `p_id_periode` INT)   BEGIN
 SELECT EXISTS(SELECT 1 FROM kelas WHERE id_kelas=p_id_kelas AND status_kelas='Aktif') AS kelas_valid,
        EXISTS(SELECT 1 FROM periode_akademik WHERE id_periode_akademik=p_id_periode AND status_periode='Aktif' AND tanggal_selesai>=CURDATE()) AS periode_valid;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `usp_validasi_session_pengguna` (IN `p_id_pengguna` INT)   BEGIN
    SELECT p.id_pengguna,p.id_mahasiswa,p.id_pengajar,p.username,p.role,p.status_akun
    FROM pengguna p
    LEFT JOIN mahasiswa m ON p.id_mahasiswa=m.id_mahasiswa
    LEFT JOIN pengajar pg ON p.id_pengajar=pg.id_pengajar
    WHERE p.id_pengguna=p_id_pengguna
      AND p.status_akun='Aktif'
      AND (p.role<>'Mahasiswa' OR (m.id_mahasiswa IS NOT NULL AND m.status_mahasiswa='Aktif'))
      AND (p.role='Mahasiswa' OR (pg.id_pengajar IS NOT NULL AND pg.status_pengajar='Aktif'))
    LIMIT 1;
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
(1, 'Menata ruang kelas', 'Semua Mahasiswa', 2.0, '2026-06-01 08:00:00', 1, 0, NULL, 'Dibuka'),
(2, 'Merapikan ruang laboratorium', 'Mahasiswa dengan Jam Minus', 3.0, '2026-06-02 08:00:00', 1, 0, NULL, 'Dibuka'),
(3, 'Mendata inventaris kelas', 'Semua Mahasiswa', 4.0, '2026-06-03 08:00:00', 1, 0, NULL, 'Dibuka'),
(4, 'Membantu persiapan seminar', 'Mahasiswa dengan Jam Minus', 5.0, '2026-06-04 08:00:00', 1, 0, NULL, 'Dibuka'),
(5, 'Membersihkan area perpustakaan', 'Semua Mahasiswa', 1.0, '2026-06-05 08:00:00', 1, 0, NULL, 'Dibuka'),
(6, 'Menata arsip program studi', 'Mahasiswa dengan Jam Minus', 2.0, '2026-06-06 08:00:00', 1, 0, NULL, 'Dibuka'),
(7, 'Membantu registrasi kegiatan', 'Semua Mahasiswa', 3.0, '2026-06-07 08:00:00', 1, 1, 'assets/uploads/jobdesc/bukti-07.jpg', 'Dikerjakan'),
(8, 'Menyiapkan perlengkapan workshop', 'Mahasiswa dengan Jam Minus', 4.0, '2026-06-08 08:00:00', 1, 1, 'assets/uploads/jobdesc/bukti-08.jpg', 'Dikerjakan'),
(9, 'Mendokumentasikan kegiatan kampus', 'Semua Mahasiswa', 5.0, '2026-06-09 08:00:00', 1, 1, 'assets/uploads/jobdesc/bukti-09.jpg', 'Dikerjakan'),
(10, 'Memeriksa kelengkapan ruang kelas', 'Mahasiswa dengan Jam Minus', 1.0, '2026-06-10 08:00:00', 1, 1, 'assets/uploads/jobdesc/bukti-10.jpg', 'Dikerjakan'),
(11, 'Membantu piket laboratorium', 'Semua Mahasiswa', 2.0, '2026-06-11 08:00:00', 1, 1, 'assets/uploads/jobdesc/bukti-11.jpg', 'Dikerjakan'),
(12, 'Merapikan gudang fasilitas', 'Mahasiswa dengan Jam Minus', 3.0, '2026-06-12 08:00:00', 1, 1, 'assets/uploads/jobdesc/bukti-12.jpg', 'Dikerjakan'),
(13, 'Membantu publikasi kegiatan', 'Semua Mahasiswa', 4.0, '2026-06-13 08:00:00', 1, 1, 'assets/uploads/jobdesc/bukti-13.jpg', 'Dikerjakan'),
(14, 'Menyiapkan ruang rapat', 'Mahasiswa dengan Jam Minus', 5.0, '2026-06-14 08:00:00', 1, 1, 'assets/uploads/jobdesc/bukti-14.jpg', 'Selesai'),
(15, 'Melakukan pengecekan perangkat', 'Semua Mahasiswa', 1.0, '2026-06-15 08:00:00', 1, 1, 'assets/uploads/jobdesc/bukti-15.jpg', 'Selesai'),
(16, 'Membantu penerimaan tamu', 'Mahasiswa dengan Jam Minus', 2.0, '2026-06-16 08:00:00', 1, 1, 'assets/uploads/jobdesc/bukti-16.jpg', 'Selesai'),
(17, 'Membuat rekap peserta kegiatan', 'Semua Mahasiswa', 3.0, '2026-06-17 08:00:00', 1, 1, 'assets/uploads/jobdesc/bukti-17.jpg', 'Selesai'),
(18, 'Menata area pameran proyek', 'Mahasiswa dengan Jam Minus', 4.0, '2026-06-18 08:00:00', 1, 1, 'assets/uploads/jobdesc/bukti-18.jpg', 'Selesai'),
(19, 'Membantu evaluasi inventaris', 'Semua Mahasiswa', 5.0, '2026-06-19 08:00:00', 1, 1, 'assets/uploads/jobdesc/bukti-19.jpg', 'Selesai'),
(20, 'Merapikan ruang organisasi', 'Mahasiswa dengan Jam Minus', 1.0, '2026-06-20 08:00:00', 1, 1, 'assets/uploads/jobdesc/bukti-20.jpg', 'Selesai');

-- --------------------------------------------------------

--
-- Struktur dari tabel `detail_fasilitas_pada_kelas`
--

CREATE TABLE `detail_fasilitas_pada_kelas` (
  `id_detail_fasilitas_pada_kelas` int(11) NOT NULL,
  `id_kelas` int(11) NOT NULL,
  `id_fasilitas` int(11) NOT NULL,
  `status_detail_fasilitas_pada_kelas` enum('Aktif','Rusak','Tidak Aktif') DEFAULT 'Aktif'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `detail_fasilitas_pada_kelas`
--

INSERT INTO `detail_fasilitas_pada_kelas` (`id_detail_fasilitas_pada_kelas`, `id_kelas`, `id_fasilitas`, `status_detail_fasilitas_pada_kelas`) VALUES
(1, 1, 1, 'Aktif'),
(2, 2, 2, 'Aktif'),
(3, 3, 3, 'Aktif'),
(4, 4, 4, 'Aktif'),
(5, 5, 5, 'Aktif'),
(6, 6, 6, 'Aktif'),
(7, 7, 7, 'Aktif'),
(8, 8, 8, 'Rusak'),
(9, 9, 9, 'Rusak'),
(10, 10, 10, 'Rusak'),
(11, 11, 11, 'Rusak'),
(12, 12, 12, 'Rusak'),
(13, 13, 13, 'Rusak'),
(14, 14, 14, 'Rusak'),
(15, 15, 15, 'Aktif'),
(16, 16, 16, 'Aktif'),
(17, 17, 17, 'Aktif'),
(18, 18, 18, 'Aktif'),
(19, 19, 19, 'Aktif'),
(20, 20, 20, 'Aktif');

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
(1, 1, 1),
(2, 2, 2),
(3, 3, 3),
(4, 4, 4),
(5, 5, 5),
(6, 6, 6),
(7, 7, 7),
(8, 8, 8),
(9, 9, 9),
(10, 10, 10),
(11, 11, 11),
(12, 12, 12),
(13, 13, 13),
(14, 14, 14),
(15, 15, 15),
(16, 16, 16),
(17, 17, 17),
(18, 18, 18),
(19, 19, 19),
(20, 20, 20);

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
(1, 1, 15, 'Pemberi'),
(2, 2, 19, 'Pemberi'),
(3, 3, 20, 'Pemberi'),
(4, 4, 15, 'Pemberi'),
(5, 5, 19, 'Pemberi'),
(6, 6, 20, 'Pemberi'),
(8, 7, 1, 'Penerima'),
(7, 7, 15, 'Pemberi'),
(10, 8, 2, 'Penerima'),
(9, 8, 19, 'Pemberi'),
(12, 9, 3, 'Penerima'),
(11, 9, 20, 'Pemberi'),
(14, 10, 4, 'Penerima'),
(13, 10, 15, 'Pemberi'),
(16, 11, 5, 'Penerima'),
(15, 11, 19, 'Pemberi'),
(18, 12, 6, 'Penerima'),
(17, 12, 20, 'Pemberi'),
(20, 13, 7, 'Penerima'),
(19, 13, 15, 'Pemberi'),
(22, 14, 8, 'Penerima'),
(21, 14, 19, 'Pemberi'),
(24, 15, 9, 'Penerima'),
(23, 15, 20, 'Pemberi'),
(26, 16, 10, 'Penerima'),
(25, 16, 15, 'Pemberi'),
(28, 17, 11, 'Penerima'),
(27, 17, 19, 'Pemberi'),
(30, 18, 12, 'Penerima'),
(29, 18, 20, 'Pemberi'),
(32, 19, 13, 'Penerima'),
(31, 19, 15, 'Pemberi'),
(34, 20, 14, 'Penerima'),
(33, 20, 19, 'Pemberi');

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
(1, 1, 16, 'Pemberi'),
(2, 1, 1, 'Penerima'),
(3, 2, 16, 'Pemberi'),
(4, 2, 2, 'Penerima'),
(5, 3, 16, 'Pemberi'),
(6, 3, 3, 'Penerima'),
(7, 4, 16, 'Pemberi'),
(8, 4, 4, 'Penerima'),
(9, 5, 16, 'Pemberi'),
(10, 5, 5, 'Penerima'),
(11, 6, 16, 'Pemberi'),
(12, 6, 6, 'Penerima'),
(13, 7, 16, 'Pemberi'),
(14, 7, 7, 'Penerima'),
(15, 8, 16, 'Pemberi'),
(16, 8, 8, 'Penerima'),
(17, 9, 16, 'Pemberi'),
(18, 9, 9, 'Penerima'),
(19, 10, 16, 'Pemberi'),
(20, 10, 10, 'Penerima'),
(21, 11, 16, 'Pemberi'),
(22, 11, 11, 'Penerima'),
(23, 12, 16, 'Pemberi'),
(24, 12, 12, 'Penerima'),
(25, 13, 16, 'Pemberi'),
(26, 13, 13, 'Penerima'),
(27, 14, 16, 'Pemberi'),
(28, 14, 14, 'Penerima'),
(29, 15, 16, 'Pemberi'),
(30, 15, 1, 'Penerima'),
(31, 16, 16, 'Pemberi'),
(32, 16, 2, 'Penerima'),
(33, 17, 16, 'Pemberi'),
(34, 17, 3, 'Penerima'),
(35, 18, 16, 'Pemberi'),
(36, 18, 4, 'Penerima'),
(37, 19, 16, 'Pemberi'),
(38, 19, 5, 'Penerima'),
(39, 20, 16, 'Pemberi'),
(40, 20, 6, 'Penerima');

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
(2, 2, 2, 'Pelapor'),
(3, 3, 3, 'Pelapor'),
(4, 4, 4, 'Pelapor'),
(5, 5, 5, 'Pelapor'),
(6, 6, 6, 'Pelapor'),
(7, 7, 7, 'Pelapor'),
(8, 8, 8, 'Pelapor'),
(10, 9, 9, 'Pelapor'),
(12, 10, 10, 'Pelapor'),
(14, 11, 11, 'Pelapor'),
(16, 12, 12, 'Pelapor'),
(18, 13, 13, 'Pelapor'),
(20, 14, 14, 'Pelapor'),
(22, 15, 1, 'Pelapor'),
(24, 16, 2, 'Pelapor'),
(26, 17, 3, 'Pelapor'),
(28, 18, 4, 'Pelapor'),
(30, 19, 5, 'Pelapor'),
(32, 20, 6, 'Pelapor'),
(9, 8, 17, 'Verifikator'),
(11, 9, 17, 'Verifikator'),
(13, 10, 17, 'Verifikator'),
(15, 11, 17, 'Verifikator'),
(17, 12, 17, 'Verifikator'),
(19, 13, 17, 'Verifikator'),
(21, 14, 17, 'Verifikator'),
(23, 15, 17, 'Verifikator'),
(25, 16, 17, 'Verifikator'),
(27, 17, 17, 'Verifikator'),
(29, 18, 17, 'Verifikator'),
(31, 19, 17, 'Verifikator'),
(33, 20, 17, 'Verifikator');

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
(1, 1, 1, 'Pengaju'),
(2, 2, 2, 'Pengaju'),
(3, 3, 3, 'Pengaju'),
(4, 4, 4, 'Pengaju'),
(5, 5, 5, 'Pengaju'),
(6, 6, 6, 'Pengaju'),
(7, 7, 7, 'Pengaju'),
(8, 8, 8, 'Pengaju'),
(9, 8, 16, 'Verifikator'),
(10, 9, 9, 'Pengaju'),
(11, 9, 16, 'Verifikator'),
(12, 10, 10, 'Pengaju'),
(13, 10, 16, 'Verifikator'),
(14, 11, 11, 'Pengaju'),
(15, 11, 16, 'Verifikator'),
(16, 12, 12, 'Pengaju'),
(17, 12, 16, 'Verifikator'),
(18, 13, 13, 'Pengaju'),
(19, 13, 16, 'Verifikator'),
(20, 14, 14, 'Pengaju'),
(21, 14, 16, 'Verifikator'),
(22, 15, 1, 'Pengaju'),
(23, 15, 16, 'Verifikator'),
(24, 16, 2, 'Pengaju'),
(25, 16, 16, 'Verifikator'),
(26, 17, 3, 'Pengaju'),
(27, 17, 16, 'Verifikator'),
(28, 18, 4, 'Pengaju'),
(29, 18, 16, 'Verifikator'),
(30, 19, 5, 'Pengaju'),
(31, 19, 16, 'Verifikator'),
(32, 20, 6, 'Pengaju'),
(33, 20, 16, 'Verifikator');

-- --------------------------------------------------------

--
-- Struktur dari tabel `fasilitas`
--

CREATE TABLE `fasilitas` (
  `id_fasilitas` int(11) NOT NULL,
  `nama_fasilitas` varchar(50) NOT NULL,
  `harga` decimal(15,2) DEFAULT 0.00,
  `stok` int(11) NOT NULL DEFAULT 0,
  `status_fasilitas` enum('Aktif','Tidak Aktif') DEFAULT 'Aktif',
  `nama_fasilitas_aktif` varchar(50) GENERATED ALWAYS AS (case when `status_fasilitas` = 'Aktif' then ucase(trim(`nama_fasilitas`)) else NULL end) STORED,
  `tanggal_pendataan` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `fasilitas`
--

INSERT INTO `fasilitas` (`id_fasilitas`, `nama_fasilitas`, `harga`, `stok`, `status_fasilitas`, `tanggal_pendataan`) VALUES
(1, 'Proyektor', 4500000.00, 2, 'Aktif', '2026-01-01 08:00:00'),
(2, 'AC Split', 3500000.00, 3, 'Aktif', '2026-01-02 08:00:00'),
(3, 'Komputer Lab', 8500000.00, 4, 'Aktif', '2026-01-03 08:00:00'),
(4, 'Monitor', 1800000.00, 5, 'Aktif', '2026-01-04 08:00:00'),
(5, 'Keyboard', 250000.00, 6, 'Aktif', '2026-01-05 08:00:00'),
(6, 'Mouse', 150000.00, 7, 'Aktif', '2026-01-06 08:00:00'),
(7, 'Kursi Kelas', 350000.00, 8, 'Aktif', '2026-01-07 08:00:00'),
(8, 'Meja Kelas', 600000.00, 9, 'Aktif', '2026-01-08 08:00:00'),
(9, 'Papan Tulis', 750000.00, 10, 'Aktif', '2026-01-09 08:00:00'),
(10, 'Printer', 2500000.00, 11, 'Aktif', '2026-01-10 08:00:00'),
(11, 'Router', 1200000.00, 12, 'Aktif', '2026-01-11 08:00:00'),
(12, 'Access Point', 950000.00, 13, 'Aktif', '2026-01-12 08:00:00'),
(13, 'Speaker', 800000.00, 14, 'Aktif', '2026-01-13 08:00:00'),
(14, 'Mikrofon', 650000.00, 15, 'Aktif', '2026-01-14 08:00:00'),
(15, 'Kamera', 6000000.00, 16, 'Aktif', '2026-01-15 08:00:00'),
(16, 'Tripod', 700000.00, 17, 'Aktif', '2026-01-16 08:00:00'),
(17, 'Lemari Arsip', 1800000.00, 18, 'Aktif', '2026-01-17 08:00:00'),
(18, 'Dispenser', 500000.00, 19, 'Aktif', '2026-01-18 08:00:00'),
(19, 'Lampu Kelas', 300000.00, 20, 'Aktif', '2026-01-19 08:00:00'),
(20, 'Kipas Angin', 550000.00, 21, 'Aktif', '2026-01-20 08:00:00');

-- --------------------------------------------------------

--
-- Struktur dari tabel `histori_login`
--

CREATE TABLE `histori_login` (
  `id_histori_login` bigint(20) NOT NULL,
  `id_pengguna` int(11) NOT NULL,
  `username` varchar(20) NOT NULL,
  `role` varchar(30) NOT NULL,
  `tanggal_login` datetime(6) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `histori_login`
--

INSERT INTO `histori_login` (`id_histori_login`, `id_pengguna`, `username`, `role`, `tanggal_login`) VALUES
(3, 19, 'kaprodi', 'Kepala Prodi', '2026-07-15 23:46:10.272653');

-- --------------------------------------------------------

--
-- Struktur dari tabel `kegiatan`
--

CREATE TABLE `kegiatan` (
  `id_kegiatan` int(11) NOT NULL,
  `nama_kegiatan` varchar(50) NOT NULL,
  `penyelenggara` enum('ASTRAtech','BEM','MPM','HIMMA','UKM','Prodi') NOT NULL,
  `tanggal_kegiatan` date DEFAULT NULL,
  `status_kegiatan` enum('Aktif','Tidak Aktif') DEFAULT 'Aktif',
  `tanggal_kegiatan_kunci` date GENERATED ALWAYS AS (coalesce(`tanggal_kegiatan`,cast('1000-01-01' as date))) STORED,
  `kunci_kegiatan_aktif` varchar(100) GENERATED ALWAYS AS (case when `status_kegiatan` = 'Aktif' then concat_ws('|',ucase(trim(`nama_kegiatan`)),`penyelenggara`,coalesce(cast(`tanggal_kegiatan` as char charset utf8mb4),'1000-01-01')) else NULL end) STORED
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `kegiatan`
--

INSERT INTO `kegiatan` (`id_kegiatan`, `nama_kegiatan`, `penyelenggara`, `tanggal_kegiatan`, `status_kegiatan`) VALUES
(1, 'Orientasi Mahasiswa', 'Prodi', '2026-01-05', 'Aktif'),
(2, 'Seminar Teknologi', 'ASTRAtech', '2026-01-15', 'Aktif'),
(3, 'Donor Darah', 'BEM', '2026-02-05', 'Aktif'),
(4, 'Bakti Sosial', 'MPM', '2026-02-15', 'Aktif'),
(5, 'Pelatihan Kepemimpinan', 'HIMMA', '2026-03-05', 'Aktif'),
(6, 'Lomba Inovasi', 'UKM', '2026-03-15', 'Aktif'),
(7, 'Workshop UI UX', 'Prodi', '2026-04-05', 'Aktif'),
(8, 'Kuliah Umum', 'ASTRAtech', '2026-04-15', 'Aktif'),
(9, 'Expo Organisasi', 'BEM', '2026-05-05', 'Aktif'),
(10, 'Kompetisi Coding', 'HIMMA', '2026-05-15', 'Aktif'),
(11, 'Festival Seni', 'UKM', '2026-06-05', 'Aktif'),
(12, 'Pelatihan Kewirausahaan', 'BEM', '2026-06-15', 'Aktif'),
(13, 'Kunjungan Industri', 'Prodi', '2026-07-05', 'Aktif'),
(14, 'Kegiatan Olahraga', 'UKM', '2026-07-15', 'Aktif'),
(15, 'Pelatihan Public Speaking', 'MPM', '2026-08-05', 'Aktif'),
(16, 'Webinar Karier', 'ASTRAtech', '2026-08-15', 'Aktif'),
(17, 'Program Mentoring', 'Prodi', '2026-09-05', 'Aktif'),
(18, 'Pengabdian Masyarakat', 'BEM', '2026-09-15', 'Aktif'),
(19, 'Pameran Proyek', 'Prodi', '2026-10-05', 'Aktif'),
(20, 'Malam Keakraban', 'HIMMA', '2026-10-15', 'Aktif');

-- --------------------------------------------------------

--
-- Struktur dari tabel `kelas`
--

CREATE TABLE `kelas` (
  `id_kelas` int(11) NOT NULL,
  `nama_kelas` varchar(5) NOT NULL,
  `tingkat` enum('1','2','3','4') NOT NULL,
  `jumlah_mahasiswa` int(11) DEFAULT 0,
  `status_kelas` enum('Aktif','Tidak Aktif') DEFAULT 'Aktif',
  `nama_kelas_aktif` varchar(5) GENERATED ALWAYS AS (case when `status_kelas` = 'Aktif' then ucase(trim(`nama_kelas`)) else NULL end) STORED
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `kelas`
--

INSERT INTO `kelas` (`id_kelas`, `nama_kelas`, `tingkat`, `jumlah_mahasiswa`, `status_kelas`) VALUES
(1, 'TR1A', '1', 1, 'Aktif'),
(2, 'TR1B', '1', 1, 'Aktif'),
(3, 'TR1C', '1', 1, 'Aktif'),
(4, 'TR1D', '1', 1, 'Aktif'),
(5, 'TR1E', '1', 1, 'Aktif'),
(6, 'TR2A', '2', 1, 'Aktif'),
(7, 'TR2B', '2', 1, 'Aktif'),
(8, 'TR2C', '2', 1, 'Aktif'),
(9, 'TR2D', '2', 1, 'Aktif'),
(10, 'TR2E', '2', 1, 'Aktif'),
(11, 'TR3A', '3', 1, 'Aktif'),
(12, 'TR3B', '3', 1, 'Aktif'),
(13, 'TR3C', '3', 1, 'Aktif'),
(14, 'TR3D', '3', 1, 'Aktif'),
(15, 'TR3E', '3', 1, 'Aktif'),
(16, 'TR4A', '4', 1, 'Aktif'),
(17, 'TR4B', '4', 1, 'Aktif'),
(18, 'TR4C', '4', 1, 'Aktif'),
(19, 'TR4D', '4', 1, 'Aktif'),
(20, 'TR4E', '4', 1, 'Aktif');

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
(1, 1, 20, '032025001', 'Yoga Wargana', 'mahasiswa01@simat.test', '081210000001', 6.5, 0.0, 0.0, 0.0, 'Aktif'),
(2, 2, 20, '032025002', 'Fahri Aprilian', 'mahasiswa02@simat.test', '081210000002', 3.0, 6.0, 0.0, 0.0, 'Aktif'),
(3, 3, 20, '032025003', 'Nabilah Putri', 'mahasiswa03@simat.test', '081210000003', 11.5, 0.0, 0.0, 0.0, 'Aktif'),
(4, 4, 20, '032025004', 'Mikael Jonathan', 'mahasiswa04@simat.test', '081210000004', 5.0, 9.0, 0.0, 0.0, 'Aktif'),
(5, 5, 20, '032025005', 'Rizal Maulana', 'mahasiswa05@simat.test', '081210000005', 16.5, 0.0, 0.0, 0.0, 'Aktif'),
(6, 6, 20, '032025006', 'Daffa Pratama', 'mahasiswa06@simat.test', '081210000006', 7.0, 12.0, 0.0, 0.0, 'Aktif'),
(7, 7, 20, '032025007', 'Adit Saputra', 'mahasiswa07@simat.test', '081210000007', 8.0, 0.0, 0.0, 0.0, 'Aktif'),
(8, 8, 20, '032025008', 'Irsyad Hidayat', 'mahasiswa08@simat.test', '081210000008', 0.0, 300.0, 0.0, 10.0, 'Aktif'),
(9, 9, 20, '032025009', 'Haikal Ramadhan', 'mahasiswa09@simat.test', '081210000009', 0.0, 375.0, 5.5, 1.0, 'Aktif'),
(10, 10, 20, '032025010', 'Aulia Rahma', 'mahasiswa10@simat.test', '081210000010', 0.0, 1250.0, 0.0, 8.0, 'Aktif'),
(11, 11, 20, '032025011', 'Kevin Wijaya', 'mahasiswa11@simat.test', '081210000011', 0.0, 600.0, 6.5, 3.0, 'Aktif'),
(12, 12, 20, '032025012', 'Salsa Nuraini', 'mahasiswa12@simat.test', '081210000012', 0.0, 475.0, 0.0, 11.0, 'Aktif'),
(13, 13, 20, '032025013', 'Rafi Akbar', 'mahasiswa13@simat.test', '081210000013', 0.0, 400.0, 15.0, 5.0, 'Aktif'),
(14, 14, 20, '032025014', 'Nadia Safitri', 'mahasiswa14@simat.test', '081210000014', 0.0, 325.0, 0.0, 9.0, 'Aktif'),
(15, 15, 20, '032025015', 'Farhan Aditya', 'mahasiswa15@simat.test', '081210000015', 0.0, 0.0, 0.0, 0.0, 'Aktif'),
(16, 16, 20, '032025016', 'Intan Permata', 'mahasiswa16@simat.test', '081210000016', 0.0, 0.0, 0.0, 0.0, 'Aktif'),
(17, 17, 20, '032025017', 'Galih Prakoso', 'mahasiswa17@simat.test', '081210000017', 0.0, 0.0, 0.0, 0.0, 'Aktif'),
(18, 18, 20, '032025018', 'Dinda Maharani', 'mahasiswa18@simat.test', '081210000018', 0.0, 0.0, 0.0, 0.0, 'Aktif'),
(19, 19, 20, '032025019', 'Raka Firmansyah', 'mahasiswa19@simat.test', '081210000019', 0.0, 0.0, 0.0, 0.0, 'Aktif'),
(20, 20, 20, '032025020', 'Zahra Azzahra', 'mahasiswa20@simat.test', '081210000020', 0.0, 0.0, 0.0, 0.0, 'Aktif');

--
-- Trigger `mahasiswa`
--
DELIMITER $$
CREATE TRIGGER `trg_mahasiswa_bi_validasi` BEFORE INSERT ON `mahasiswa` FOR EACH ROW BEGIN
    IF NEW.no_hp IS NOT NULL AND TRIM(NEW.no_hp) <> ''
       AND NEW.no_hp NOT REGEXP '^[0-9]{10,13}$' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'No HP mahasiswa harus terdiri dari 10 sampai 13 digit';
    END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `trg_mahasiswa_bu_validasi` BEFORE UPDATE ON `mahasiswa` FOR EACH ROW BEGIN
    IF NEW.no_hp IS NOT NULL AND TRIM(NEW.no_hp) <> ''
       AND NEW.no_hp NOT REGEXP '^[0-9]{10,13}$' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'No HP mahasiswa harus terdiri dari 10 sampai 13 digit';
    END IF;
END
$$
DELIMITER ;

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
(1, 'Algoritma Pemrograman', 'ALG101', 2, '1', 'Aktif'),
(2, 'Basis Data', 'BD101', 3, '1', 'Aktif'),
(3, 'Pemrograman Web', 'WEB101', 4, '1', 'Aktif'),
(4, 'Struktur Data', 'STD201', 2, '2', 'Aktif'),
(5, 'Sistem Operasi', 'SO201', 3, '2', 'Aktif'),
(6, 'Jaringan Komputer', 'JAR201', 4, '2', 'Aktif'),
(7, 'Rekayasa Perangkat Lunak', 'RPL301', 2, '3', 'Aktif'),
(8, 'Pemrograman Berorientasi Objek', 'PBO201', 3, '3', 'Aktif'),
(9, 'Interaksi Manusia Komputer', 'IMK301', 4, '3', 'Aktif'),
(10, 'Matematika Diskrit', 'MD101', 2, '4', 'Aktif'),
(11, 'Bahasa Inggris Teknik', 'BIT101', 3, '4', 'Aktif'),
(12, 'Keamanan Informasi', 'KI401', 4, '4', 'Aktif'),
(13, 'Pengujian Perangkat Lunak', 'PPL301', 2, '5', 'Aktif'),
(14, 'Analisis Sistem', 'AS301', 3, '5', 'Aktif'),
(15, 'Manajemen Proyek TI', 'MPTI401', 4, '5', 'Aktif'),
(16, 'Komputasi Awan', 'KA401', 2, '6', 'Aktif'),
(17, 'Kecerdasan Buatan', 'AI401', 3, '6', 'Aktif'),
(18, 'Pemrograman Mobile', 'MOB301', 4, '6', 'Aktif'),
(19, 'Data Warehouse', 'DW401', 2, '7', 'Aktif'),
(20, 'Proyek Akhir', 'PA801', 3, '7', 'Aktif');

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
(1, 'Akademik', 1, 'Alpa', NULL, NULL, 'Pelanggaran Akademik', 'Tidak mengikuti perkuliahan pada pertemuan ke-1', 2.0, 'Murni', '2026-04-01 09:00:00'),
(2, 'Akademik', 2, 'Izin', NULL, NULL, 'Pelanggaran Akademik', 'Tidak mengikuti perkuliahan pada pertemuan ke-2', 3.0, 'Murni', '2026-04-02 09:00:00'),
(3, 'Akademik', 3, 'Sakit', NULL, NULL, 'Pelanggaran Akademik', 'Tidak mengikuti perkuliahan pada pertemuan ke-3', 4.0, 'Murni', '2026-04-03 09:00:00'),
(4, 'Akademik', 4, 'Alpa', NULL, NULL, 'Pelanggaran Akademik', 'Tidak mengikuti perkuliahan pada pertemuan ke-4', 5.0, 'Murni', '2026-04-04 09:00:00'),
(5, 'Akademik', 5, 'Izin', NULL, NULL, 'Pelanggaran Akademik', 'Tidak mengikuti perkuliahan pada pertemuan ke-5', 6.0, 'Murni', '2026-04-05 09:00:00'),
(6, 'Akademik', 6, 'Sakit', NULL, NULL, 'Pelanggaran Akademik', 'Tidak mengikuti perkuliahan pada pertemuan ke-6', 7.0, 'Murni', '2026-04-06 09:00:00'),
(7, 'Akademik', 7, 'Alpa', NULL, NULL, 'Pelanggaran Akademik', 'Tidak mengikuti perkuliahan pada pertemuan ke-7', 8.0, 'Murni', '2026-04-07 09:00:00'),
(8, 'Fasilitas', NULL, NULL, 8, 600000.00, 'Kerusakan Fasilitas', 'Mengganti kerusakan Meja Kelas', 300.0, 'Kompensasi', '2026-04-08 10:00:00'),
(9, 'Fasilitas', NULL, NULL, 9, 750000.00, 'Kerusakan Fasilitas', 'Mengganti kerusakan Papan Tulis', 375.0, 'Kompensasi', '2026-04-09 10:00:00'),
(10, 'Fasilitas', NULL, NULL, 10, 2500000.00, 'Kerusakan Fasilitas', 'Mengganti kerusakan Printer', 1250.0, 'Kompensasi', '2026-04-10 10:00:00'),
(11, 'Fasilitas', NULL, NULL, 11, 1200000.00, 'Kerusakan Fasilitas', 'Mengganti kerusakan Router', 600.0, 'Kompensasi', '2026-04-11 10:00:00'),
(12, 'Fasilitas', NULL, NULL, 12, 950000.00, 'Kerusakan Fasilitas', 'Mengganti kerusakan Access Point', 475.0, 'Kompensasi', '2026-04-12 10:00:00'),
(13, 'Fasilitas', NULL, NULL, 13, 800000.00, 'Kerusakan Fasilitas', 'Mengganti kerusakan Speaker', 400.0, 'Kompensasi', '2026-04-13 10:00:00'),
(14, 'Fasilitas', NULL, NULL, 14, 650000.00, 'Kerusakan Fasilitas', 'Mengganti kerusakan Mikrofon', 325.0, 'Kompensasi', '2026-04-14 10:00:00'),
(15, 'Lainnya', NULL, NULL, NULL, NULL, 'Pelanggaran Lainnya', 'Terlambat mengikuti apel', 4.5, 'Murni', '2026-04-15 11:00:00'),
(16, 'Lainnya', NULL, NULL, NULL, NULL, 'Pelanggaran Lainnya', 'Tidak memakai kartu identitas', 6.0, 'Kompensasi', '2026-04-16 11:00:00'),
(17, 'Lainnya', NULL, NULL, NULL, NULL, 'Pelanggaran Lainnya', 'Meninggalkan kelas tanpa izin', 7.5, 'Murni', '2026-04-17 11:00:00'),
(18, 'Lainnya', NULL, NULL, NULL, NULL, 'Pelanggaran Lainnya', 'Tidak mengikuti kegiatan wajib', 9.0, 'Kompensasi', '2026-04-18 11:00:00'),
(19, 'Lainnya', NULL, NULL, NULL, NULL, 'Pelanggaran Lainnya', 'Melanggar kebersihan area kampus', 10.5, 'Murni', '2026-04-19 11:00:00'),
(20, 'Lainnya', NULL, NULL, NULL, NULL, 'Pelanggaran Lainnya', 'Tidak mematuhi tata tertib laboratorium', 12.0, 'Kompensasi', '2026-04-20 11:00:00');

-- --------------------------------------------------------

--
-- Struktur dari tabel `pengaduan_kerusakan_fasilitas`
--

CREATE TABLE `pengaduan_kerusakan_fasilitas` (
  `id_pengaduan_kerusakan_fasilitas` int(11) NOT NULL,
  `id_fasilitas` int(11) NOT NULL,
  `id_detail_fasilitas_pada_kelas` int(11) DEFAULT NULL,
  `deskripsi_kerusakan` text NOT NULL,
  `tanggal_pengaduan` datetime NOT NULL,
  `bukti_kerusakan_url` varchar(2048) DEFAULT NULL,
  `pelaku_kerusakan` varchar(50) DEFAULT NULL,
  `status_pengaduan` enum('Menunggu Verifikasi','Diterima','Ditolak') DEFAULT 'Menunggu Verifikasi',
  `alsan_penolakan` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `pengaduan_kerusakan_fasilitas`
--

INSERT INTO `pengaduan_kerusakan_fasilitas` (`id_pengaduan_kerusakan_fasilitas`, `id_fasilitas`, `id_detail_fasilitas_pada_kelas`, `deskripsi_kerusakan`, `tanggal_pengaduan`, `bukti_kerusakan_url`, `pelaku_kerusakan`, `status_pengaduan`, `alsan_penolakan`) VALUES
(1, 1, 1, 'Proyektor tidak menampilkan gambar', '2026-03-01 09:00:00', 'assets/uploads/pengaduan/bukti-01.jpg', NULL, 'Menunggu Verifikasi', NULL),
(2, 2, 2, 'AC mengeluarkan suara bising', '2026-03-02 10:00:00', 'assets/uploads/pengaduan/bukti-02.jpg', NULL, 'Menunggu Verifikasi', NULL),
(3, 3, 3, 'Komputer gagal menyala', '2026-03-03 11:00:00', 'assets/uploads/pengaduan/bukti-03.jpg', NULL, 'Menunggu Verifikasi', NULL),
(4, 4, 4, 'Monitor berkedip saat digunakan', '2026-03-04 12:00:00', 'assets/uploads/pengaduan/bukti-04.jpg', 'Tidak diketahui', 'Menunggu Verifikasi', NULL),
(5, 5, 5, 'Beberapa tombol keyboard tidak berfungsi', '2026-03-05 13:00:00', 'assets/uploads/pengaduan/bukti-05.jpg', NULL, 'Menunggu Verifikasi', NULL),
(6, 6, 6, 'Mouse tidak terdeteksi', '2026-03-06 14:00:00', 'assets/uploads/pengaduan/bukti-06.jpg', NULL, 'Menunggu Verifikasi', NULL),
(7, 7, 7, 'Sandaran kursi patah', '2026-03-07 15:00:00', 'assets/uploads/pengaduan/bukti-07.jpg', NULL, 'Menunggu Verifikasi', NULL),
(8, 8, 8, 'Permukaan meja retak', '2026-03-08 08:00:00', 'assets/uploads/pengaduan/bukti-08.jpg', 'Tidak diketahui', 'Diterima', NULL),
(9, 9, 9, 'Papan tulis sulit dibersihkan', '2026-03-09 09:00:00', 'assets/uploads/pengaduan/bukti-09.jpg', NULL, 'Diterima', NULL),
(10, 10, 10, 'Printer menarik kertas ganda', '2026-03-10 10:00:00', 'assets/uploads/pengaduan/bukti-10.jpg', NULL, 'Diterima', NULL),
(11, 11, 11, 'Router sering mati sendiri', '2026-03-11 11:00:00', 'assets/uploads/pengaduan/bukti-11.jpg', NULL, 'Diterima', NULL),
(12, 12, 12, 'Access point kehilangan koneksi', '2026-03-12 12:00:00', 'assets/uploads/pengaduan/bukti-12.jpg', 'Tidak diketahui', 'Diterima', NULL),
(13, 13, 13, 'Speaker mengeluarkan suara pecah', '2026-03-13 13:00:00', 'assets/uploads/pengaduan/bukti-13.jpg', NULL, 'Diterima', NULL),
(14, 14, 14, 'Mikrofon tidak menangkap suara', '2026-03-14 14:00:00', 'assets/uploads/pengaduan/bukti-14.jpg', NULL, 'Diterima', NULL),
(15, 1, 1, 'Tampilan proyektor terlihat buram', '2026-03-15 15:00:00', 'assets/uploads/pengaduan/bukti-15.jpg', NULL, 'Ditolak', 'Bukti kerusakan belum cukup jelas'),
(16, 2, 2, 'Remote AC tidak merespons', '2026-03-16 08:00:00', 'assets/uploads/pengaduan/bukti-16.jpg', 'Tidak diketahui', 'Ditolak', 'Bukti kerusakan belum cukup jelas'),
(17, 3, 3, 'Komputer sering memulai ulang sendiri', '2026-03-17 09:00:00', 'assets/uploads/pengaduan/bukti-17.jpg', NULL, 'Ditolak', 'Bukti kerusakan belum cukup jelas'),
(18, 4, 4, 'Warna monitor tidak tampil normal', '2026-03-18 10:00:00', 'assets/uploads/pengaduan/bukti-18.jpg', NULL, 'Ditolak', 'Bukti kerusakan belum cukup jelas'),
(19, 5, 5, 'Kabel keyboard terkelupas', '2026-03-19 11:00:00', 'assets/uploads/pengaduan/bukti-19.jpg', NULL, 'Ditolak', 'Bukti kerusakan belum cukup jelas'),
(20, 6, 6, 'Klik kanan mouse tidak berfungsi', '2026-03-20 12:00:00', 'assets/uploads/pengaduan/bukti-20.jpg', 'Tidak diketahui', 'Ditolak', 'Bukti kerusakan belum cukup jelas');

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
(1, 'PGR2026001', 'Budi Santoso', 'pengajar01@simat.test', '081220000001', 'Aktif'),
(2, 'PGR2026002', 'Rina Anggraini', 'pengajar02@simat.test', '081220000002', 'Aktif'),
(3, 'PGR2026003', 'Dimas Pratama', 'pengajar03@simat.test', '081220000003', 'Aktif'),
(4, 'PGR2026004', 'Siti Rahmawati', 'pengajar04@simat.test', '081220000004', 'Aktif'),
(5, 'PGR2026005', 'Andi Wijaya', 'pengajar05@simat.test', '081220000005', 'Aktif'),
(6, 'PGR2026006', 'Nadia Permata', 'pengajar06@simat.test', '081220000006', 'Aktif'),
(7, 'PGR2026007', 'Fajar Hidayat', 'pengajar07@simat.test', '081220000007', 'Aktif'),
(8, 'PGR2026008', 'Dewi Lestari', 'pengajar08@simat.test', '081220000008', 'Aktif'),
(9, 'PGR2026009', 'Rizky Maulana', 'pengajar09@simat.test', '081220000009', 'Aktif'),
(10, 'PGR2026010', 'Putri Maharani', 'pengajar10@simat.test', '081220000010', 'Aktif'),
(11, 'PGR2026011', 'Arif Nugroho', 'pengajar11@simat.test', '081220000011', 'Aktif'),
(12, 'PGR2026012', 'Lina Marlina', 'pengajar12@simat.test', '081220000012', 'Aktif'),
(13, 'PGR2026013', 'Bagus Saputra', 'pengajar13@simat.test', '081220000013', 'Aktif'),
(14, 'PGR2026014', 'Maya Kurnia', 'pengajar14@simat.test', '081220000014', 'Aktif'),
(15, 'PGR2026015', 'Teguh Prakoso', 'pengajar15@simat.test', '081220000015', 'Aktif'),
(16, 'PGR2026016', 'Nina Oktaviani', 'pengajar16@simat.test', '081220000016', 'Aktif'),
(17, 'PGR2026017', 'Agus Setiawan', 'pengajar17@simat.test', '081220000017', 'Aktif'),
(18, 'PGR2026018', 'Citra Puspita', 'pengajar18@simat.test', '081220000018', 'Aktif'),
(19, 'PGR2026019', 'Reza Firmansyah', 'pengajar19@simat.test', '081220000019', 'Aktif'),
(20, 'PGR2026020', 'Wulan Sari', 'pengajar20@simat.test', '081220000020', 'Aktif');

--
-- Trigger `pengajar`
--
DELIMITER $$
CREATE TRIGGER `trg_pengajar_bi_validasi` BEFORE INSERT ON `pengajar` FOR EACH ROW BEGIN
    IF NEW.no_hp IS NOT NULL AND TRIM(NEW.no_hp) <> ''
       AND NEW.no_hp NOT REGEXP '^[0-9]{10,13}$' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'No HP pengajar harus terdiri dari 10 sampai 13 digit';
    END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `trg_pengajar_bu_validasi` BEFORE UPDATE ON `pengajar` FOR EACH ROW BEGIN
    IF NEW.no_hp IS NOT NULL AND TRIM(NEW.no_hp) <> ''
       AND NEW.no_hp NOT REGEXP '^[0-9]{10,13}$' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'No HP pengajar harus terdiri dari 10 sampai 13 digit';
    END IF;
END
$$
DELIMITER ;

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
  `alasan_penolakan` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `pengajuan_jam_plus`
--

INSERT INTO `pengajuan_jam_plus` (`id_pengajuan_jam_plus`, `id_kegiatan`, `jumlah_jam_plus`, `jenis_jam`, `sumber_jam`, `tanggal_pengajuan`, `deskripsi_pekerjaan`, `nama_pemberi`, `dokumen_url`, `status_pengajuan`, `alasan_penolakan`) VALUES
(1, 1, 3.0, 'Murni', 'Prodi', '2026-05-01 13:00:00', 'Berpartisipasi sebagai panitia Orientasi Mahasiswa', 'Budi Santoso', 'assets/uploads/jam-plus/dokumen-01.pdf', 'Menunggu Verifikasi', NULL),
(2, 2, 4.0, 'Kompensasi', 'Luar', '2026-05-02 13:00:00', 'Berpartisipasi sebagai panitia Seminar Teknologi', 'Rina Anggraini', 'assets/uploads/jam-plus/dokumen-02.pdf', 'Menunggu Verifikasi', NULL),
(3, 3, 5.0, 'Murni', 'Luar', '2026-05-03 13:00:00', 'Berpartisipasi sebagai panitia Donor Darah', 'Dimas Pratama', 'assets/uploads/jam-plus/dokumen-03.pdf', 'Menunggu Verifikasi', NULL),
(4, 4, 6.0, 'Kompensasi', 'Luar', '2026-05-04 13:00:00', 'Berpartisipasi sebagai panitia Bakti Sosial', 'Siti Rahmawati', 'assets/uploads/jam-plus/dokumen-04.pdf', 'Menunggu Verifikasi', NULL),
(5, 5, 7.0, 'Murni', 'Luar', '2026-05-05 13:00:00', 'Berpartisipasi sebagai panitia Pelatihan Kepemimpinan', 'Andi Wijaya', 'assets/uploads/jam-plus/dokumen-05.pdf', 'Menunggu Verifikasi', NULL),
(6, 6, 8.0, 'Kompensasi', 'Luar', '2026-05-06 13:00:00', 'Berpartisipasi sebagai panitia Lomba Inovasi', 'Budi Santoso', 'assets/uploads/jam-plus/dokumen-06.pdf', 'Menunggu Verifikasi', NULL),
(7, 7, 9.0, 'Murni', 'Prodi', '2026-05-07 13:00:00', 'Berpartisipasi sebagai panitia Workshop UI UX', 'Rina Anggraini', 'assets/uploads/jam-plus/dokumen-07.pdf', 'Menunggu Verifikasi', NULL),
(8, 8, 10.0, 'Kompensasi', 'Luar', '2026-05-08 13:00:00', 'Berpartisipasi sebagai panitia Kuliah Umum', 'Dimas Pratama', 'assets/uploads/jam-plus/dokumen-08.pdf', 'Disetujui', NULL),
(9, 9, 11.0, 'Murni', 'Luar', '2026-05-09 13:00:00', 'Berpartisipasi sebagai panitia Expo Organisasi', 'Siti Rahmawati', 'assets/uploads/jam-plus/dokumen-09.pdf', 'Disetujui', NULL),
(10, 10, 12.0, 'Kompensasi', 'Luar', '2026-05-10 13:00:00', 'Berpartisipasi sebagai panitia Kompetisi Coding', 'Andi Wijaya', 'assets/uploads/jam-plus/dokumen-10.pdf', 'Disetujui', NULL),
(11, 11, 13.0, 'Murni', 'Luar', '2026-05-11 13:00:00', 'Berpartisipasi sebagai panitia Festival Seni', 'Budi Santoso', 'assets/uploads/jam-plus/dokumen-11.pdf', 'Disetujui', NULL),
(12, 12, 14.0, 'Kompensasi', 'Luar', '2026-05-12 13:00:00', 'Berpartisipasi sebagai panitia Pelatihan Kewirausahaan', 'Rina Anggraini', 'assets/uploads/jam-plus/dokumen-12.pdf', 'Disetujui', NULL),
(13, 13, 15.0, 'Murni', 'Prodi', '2026-05-13 13:00:00', 'Berpartisipasi sebagai panitia Kunjungan Industri', 'Dimas Pratama', 'assets/uploads/jam-plus/dokumen-13.pdf', 'Disetujui', NULL),
(14, 14, 16.0, 'Kompensasi', 'Luar', '2026-05-14 13:00:00', 'Berpartisipasi sebagai panitia Kegiatan Olahraga', 'Siti Rahmawati', 'assets/uploads/jam-plus/dokumen-14.pdf', 'Disetujui', NULL),
(15, 15, 17.0, 'Murni', 'Luar', '2026-05-15 13:00:00', 'Berpartisipasi sebagai panitia Pelatihan Public Speaking', 'Andi Wijaya', 'assets/uploads/jam-plus/dokumen-15.pdf', 'Ditolak', 'Dokumen pendukung tidak sesuai'),
(16, 16, 18.0, 'Kompensasi', 'Luar', '2026-05-16 13:00:00', 'Berpartisipasi sebagai panitia Webinar Karier', 'Budi Santoso', 'assets/uploads/jam-plus/dokumen-16.pdf', 'Ditolak', 'Dokumen pendukung tidak sesuai'),
(17, 17, 19.0, 'Murni', 'Prodi', '2026-05-17 13:00:00', 'Berpartisipasi sebagai panitia Program Mentoring', 'Rina Anggraini', 'assets/uploads/jam-plus/dokumen-17.pdf', 'Ditolak', 'Dokumen pendukung tidak sesuai'),
(18, 18, 20.0, 'Kompensasi', 'Luar', '2026-05-18 13:00:00', 'Berpartisipasi sebagai panitia Pengabdian Masyarakat', 'Dimas Pratama', 'assets/uploads/jam-plus/dokumen-18.pdf', 'Ditolak', 'Dokumen pendukung tidak sesuai'),
(19, 19, 21.0, 'Murni', 'Prodi', '2026-05-19 13:00:00', 'Berpartisipasi sebagai panitia Pameran Proyek', 'Siti Rahmawati', 'assets/uploads/jam-plus/dokumen-19.pdf', 'Ditolak', 'Dokumen pendukung tidak sesuai'),
(20, 20, 22.0, 'Kompensasi', 'Luar', '2026-05-20 13:00:00', 'Berpartisipasi sebagai panitia Malam Keakraban', 'Andi Wijaya', 'assets/uploads/jam-plus/dokumen-20.pdf', 'Ditolak', 'Dokumen pendukung tidak sesuai');

-- --------------------------------------------------------

--
-- Struktur dari tabel `pengguna`
--

CREATE TABLE `pengguna` (
  `id_pengguna` int(11) NOT NULL,
  `id_mahasiswa` int(11) DEFAULT NULL,
  `id_pengajar` int(11) DEFAULT NULL,
  `username` varchar(20) NOT NULL,
  `password` varchar(255) NOT NULL,
  `role` enum('Mahasiswa','Pengajar','PIC Tata Tertib','PIC Aset Fasilitas','PIC Kemahasiswaan','Kepala Prodi') NOT NULL,
  `status_akun` enum('Aktif','Tidak Aktif') DEFAULT 'Aktif',
  `login_terakhir_at` datetime(6) DEFAULT NULL,
  `id_mahasiswa_aktif` int(11) GENERATED ALWAYS AS (case when `status_akun` = 'Aktif' then `id_mahasiswa` else NULL end) STORED,
  `id_pengajar_aktif` int(11) GENERATED ALWAYS AS (case when `status_akun` = 'Aktif' then `id_pengajar` else NULL end) STORED
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `pengguna`
--

INSERT INTO `pengguna` (`id_pengguna`, `id_mahasiswa`, `id_pengajar`, `username`, `password`, `role`, `status_akun`, `login_terakhir_at`) VALUES
(1, 1, NULL, 'mhs001', '123', 'Mahasiswa', 'Aktif', NULL),
(2, 2, NULL, 'mhs002', '123', 'Mahasiswa', 'Aktif', NULL),
(3, 3, NULL, 'mhs003', '123', 'Mahasiswa', 'Aktif', NULL),
(4, 4, NULL, 'mhs004', '123', 'Mahasiswa', 'Aktif', NULL),
(5, 5, NULL, 'mhs005', '123', 'Mahasiswa', 'Aktif', NULL),
(6, 6, NULL, 'mhs006', '123', 'Mahasiswa', 'Aktif', NULL),
(7, 7, NULL, 'mhs007', '123', 'Mahasiswa', 'Aktif', NULL),
(8, 8, NULL, 'mhs008', '123', 'Mahasiswa', 'Aktif', NULL),
(9, 9, NULL, 'mhs009', '123', 'Mahasiswa', 'Aktif', NULL),
(10, 10, NULL, 'mhs010', '123', 'Mahasiswa', 'Aktif', NULL),
(11, 11, NULL, 'mhs011', '123', 'Mahasiswa', 'Aktif', NULL),
(12, 12, NULL, 'mhs012', '123', 'Mahasiswa', 'Aktif', NULL),
(13, 13, NULL, 'mhs013', '123', 'Mahasiswa', 'Aktif', NULL),
(14, 14, NULL, 'mhs014', '123', 'Mahasiswa', 'Aktif', NULL),
(15, NULL, 1, 'pengajar01', '123', 'Pengajar', 'Aktif', NULL),
(16, NULL, 2, 'pictatib', '123', 'PIC Tata Tertib', 'Aktif', NULL),
(17, NULL, 3, 'picaset', '123', 'PIC Aset Fasilitas', 'Aktif', NULL),
(18, NULL, 4, 'pickemahasiswaan', '123', 'PIC Kemahasiswaan', 'Aktif', NULL),
(19, NULL, 5, 'kaprodi', '123', 'Kepala Prodi', 'Aktif', '2026-07-15 23:46:10.272653'),
(20, NULL, 6, 'pengajar02', '123', 'Pengajar', 'Aktif', NULL);

--
-- Trigger `pengguna`
--
DELIMITER $$
CREATE TRIGGER `trg_pengguna_au_histori_login` AFTER UPDATE ON `pengguna` FOR EACH ROW BEGIN
    IF NEW.login_terakhir_at IS NOT NULL
       AND NOT (NEW.login_terakhir_at <=> OLD.login_terakhir_at) THEN
        INSERT INTO histori_login (id_pengguna, username, role, tanggal_login)
        VALUES (NEW.id_pengguna, NEW.username, NEW.role, NEW.login_terakhir_at);
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Struktur dari tabel `periode_akademik`
--

CREATE TABLE `periode_akademik` (
  `id_periode_akademik` int(11) NOT NULL,
  `tahun_akademik` varchar(10) NOT NULL,
  `semester` enum('Ganjil','Genap') NOT NULL,
  `tanggal_mulai` date NOT NULL,
  `tanggal_selesai` date NOT NULL,
  `status_periode` enum('Aktif','Tidak Aktif') DEFAULT 'Aktif',
  `kunci_periode_aktif` tinyint(4) GENERATED ALWAYS AS (case when `status_periode` = 'Aktif' then 1 else NULL end) STORED
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `periode_akademik`
--

INSERT INTO `periode_akademik` (`id_periode_akademik`, `tahun_akademik`, `semester`, `tanggal_mulai`, `tanggal_selesai`, `status_periode`) VALUES
(1, '2016/2017', 'Ganjil', '2016-08-01', '2017-01-31', 'Tidak Aktif'),
(2, '2016/2017', 'Genap', '2017-02-01', '2017-07-31', 'Tidak Aktif'),
(3, '2017/2018', 'Ganjil', '2017-08-01', '2018-01-31', 'Tidak Aktif'),
(4, '2017/2018', 'Genap', '2018-02-01', '2018-07-31', 'Tidak Aktif'),
(5, '2018/2019', 'Ganjil', '2018-08-01', '2019-01-31', 'Tidak Aktif'),
(6, '2018/2019', 'Genap', '2019-02-01', '2019-07-31', 'Tidak Aktif'),
(7, '2019/2020', 'Ganjil', '2019-08-01', '2020-01-31', 'Tidak Aktif'),
(8, '2019/2020', 'Genap', '2020-02-01', '2020-07-31', 'Tidak Aktif'),
(9, '2020/2021', 'Ganjil', '2020-08-01', '2021-01-31', 'Tidak Aktif'),
(10, '2020/2021', 'Genap', '2021-02-01', '2021-07-31', 'Tidak Aktif'),
(11, '2021/2022', 'Ganjil', '2021-08-01', '2022-01-31', 'Tidak Aktif'),
(12, '2021/2022', 'Genap', '2022-02-01', '2022-07-31', 'Tidak Aktif'),
(13, '2022/2023', 'Ganjil', '2022-08-01', '2023-01-31', 'Tidak Aktif'),
(14, '2022/2023', 'Genap', '2023-02-01', '2023-07-31', 'Tidak Aktif'),
(15, '2023/2024', 'Ganjil', '2023-08-01', '2024-01-31', 'Tidak Aktif'),
(16, '2023/2024', 'Genap', '2024-02-01', '2024-07-31', 'Tidak Aktif'),
(17, '2024/2025', 'Ganjil', '2024-08-01', '2025-01-31', 'Tidak Aktif'),
(18, '2024/2025', 'Genap', '2025-02-01', '2025-07-31', 'Tidak Aktif'),
(19, '2025/2026', 'Ganjil', '2025-08-01', '2026-01-31', 'Tidak Aktif'),
(20, '2025/2026', 'Genap', '2026-02-01', '2026-07-31', 'Aktif');

--
-- Trigger `periode_akademik`
--
DELIMITER $$
CREATE TRIGGER `trg_periode_akademik_bi` BEFORE INSERT ON `periode_akademik` FOR EACH ROW BEGIN
    SET NEW.status_periode = 'Aktif';
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `trg_periode_akademik_bu` BEFORE UPDATE ON `periode_akademik` FOR EACH ROW BEGIN
    IF OLD.status_periode = 'Aktif'
       AND NEW.status_periode = 'Tidak Aktif'
       AND COALESCE(@simat_izinkan_nonaktif_periode, 0) <> 1 THEN

        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
            'Status periode aktif tidak dapat diubah menjadi tidak aktif melalui update';
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Stand-in struktur untuk tampilan `vw_laporan_bursa_jobdesc`
-- (Lihat di bawah untuk tampilan aktual)
--
CREATE TABLE `vw_laporan_bursa_jobdesc` (
`id_bursa_jobdesc` int(11)
,`deskripsi_jobdesc` text
,`target_penerima_jobdesc` enum('Semua Mahasiswa','Mahasiswa dengan Jam Minus')
,`nama_penerima_jobdesc` longtext
,`jam_plus` decimal(6,1)
,`tanggal_pemberian_jobdesc` datetime
,`kuota` int(11)
,`terisi` int(11)
,`kuota_terisi` varchar(23)
,`status_jobdesc` enum('Dibuka','Dikerjakan','Selesai')
,`id_pemberi` int(11)
,`username_pemberi` varchar(20)
,`role_pemberi` enum('Mahasiswa','Pengajar','PIC Tata Tertib','PIC Aset Fasilitas','PIC Kemahasiswaan','Kepala Prodi')
,`nama_pemberi` varchar(50)
);

-- --------------------------------------------------------

--
-- Stand-in struktur untuk tampilan `vw_laporan_histori_transaksi_jam_mahasiswa`
-- (Lihat di bawah untuk tampilan aktual)
--
CREATE TABLE `vw_laporan_histori_transaksi_jam_mahasiswa` (
`id_pengguna` int(11)
,`id_mahasiswa` int(11)
,`id_transaksi` int(11)
,`jenis_transaksi` varchar(19)
,`tanggal_transaksi` datetime
,`deskripsi` mediumtext
,`saldo_jam_plus_kompensasi` decimal(10,1)
,`saldo_jam_minus_kompensasi` decimal(10,1)
,`saldo_jam_plus_murni` decimal(10,1)
,`saldo_jam_minus_murni` decimal(10,1)
);

-- --------------------------------------------------------

--
-- Stand-in struktur untuk tampilan `vw_laporan_pengaduan_fasilitas`
-- (Lihat di bawah untuk tampilan aktual)
--
CREATE TABLE `vw_laporan_pengaduan_fasilitas` (
`id_pengaduan_kerusakan_fasilitas` int(11)
,`id_mahasiswa` int(11)
,`nim` varchar(20)
,`nama_mahasiswa` varchar(50)
,`id_kelas` int(11)
,`nama_kelas` varchar(5)
,`id_fasilitas` int(11)
,`nama_fasilitas` varchar(50)
,`deskripsi_kerusakan` text
,`tanggal_pengaduan` datetime
);

-- --------------------------------------------------------

--
-- Stand-in struktur untuk tampilan `vw_laporan_total_jam_mahasiswa`
-- (Lihat di bawah untuk tampilan aktual)
--
CREATE TABLE `vw_laporan_total_jam_mahasiswa` (
`id_mahasiswa` int(11)
,`nim` varchar(20)
,`nama_mahasiswa` varchar(50)
,`id_kelas` int(11)
,`nama_kelas` varchar(5)
,`total_jam_kompensasi` decimal(10,1)
,`total_jam_murni` decimal(10,1)
,`total_jam_mahasiswa` decimal(10,1)
);

-- --------------------------------------------------------

--
-- Struktur untuk view `vw_laporan_bursa_jobdesc`
--
DROP TABLE IF EXISTS `vw_laporan_bursa_jobdesc`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vw_laporan_bursa_jobdesc`  AS SELECT `bj`.`id_bursa_jobdesc` AS `id_bursa_jobdesc`, `bj`.`deskripsi_jobdesc` AS `deskripsi_jobdesc`, `bj`.`penerima_jobdesc` AS `target_penerima_jobdesc`, coalesce(`data_penerima`.`nama_penerima_jobdesc`,'Belum ada penerima') AS `nama_penerima_jobdesc`, `bj`.`jam_plus` AS `jam_plus`, `bj`.`tanggal_pemberian_jobdesc` AS `tanggal_pemberian_jobdesc`, `bj`.`jumlah_mahasiswa_diperlukan` AS `kuota`, `bj`.`jumlah_mahasiswa_mengambil` AS `terisi`, concat(`bj`.`jumlah_mahasiswa_mengambil`,'/',`bj`.`jumlah_mahasiswa_diperlukan`) AS `kuota_terisi`, `bj`.`status_jobdesc` AS `status_jobdesc`, `p_pemberi`.`id_pengguna` AS `id_pemberi`, `p_pemberi`.`username` AS `username_pemberi`, `p_pemberi`.`role` AS `role_pemberi`, coalesce(`pg_pemberi`.`nama_pengajar`,`m_pemberi`.`nama_mahasiswa`,`p_pemberi`.`username`) AS `nama_pemberi` FROM (((((`bursa_jobdesc` `bj` join `detail_pengguna_pada_bursa_jobdesc` `dp_pemberi` on(`bj`.`id_bursa_jobdesc` = `dp_pemberi`.`id_bursa_jobdesc` and `dp_pemberi`.`peran_pengguna` = 'Pemberi')) join `pengguna` `p_pemberi` on(`dp_pemberi`.`id_pengguna` = `p_pemberi`.`id_pengguna`)) left join `pengajar` `pg_pemberi` on(`p_pemberi`.`id_pengajar` = `pg_pemberi`.`id_pengajar`)) left join `mahasiswa` `m_pemberi` on(`p_pemberi`.`id_mahasiswa` = `m_pemberi`.`id_mahasiswa`)) left join (select `dp`.`id_bursa_jobdesc` AS `id_bursa_jobdesc`,group_concat(coalesce(`m`.`nama_mahasiswa`,`p`.`username`) order by coalesce(`m`.`nama_mahasiswa`,`p`.`username`) ASC separator ', ') AS `nama_penerima_jobdesc` from ((`detail_pengguna_pada_bursa_jobdesc` `dp` join `pengguna` `p` on(`dp`.`id_pengguna` = `p`.`id_pengguna`)) left join `mahasiswa` `m` on(`p`.`id_mahasiswa` = `m`.`id_mahasiswa`)) where `dp`.`peran_pengguna` = 'Penerima' group by `dp`.`id_bursa_jobdesc`) `data_penerima` on(`bj`.`id_bursa_jobdesc` = `data_penerima`.`id_bursa_jobdesc`)) ;

-- --------------------------------------------------------

--
-- Struktur untuk view `vw_laporan_histori_transaksi_jam_mahasiswa`
--
DROP TABLE IF EXISTS `vw_laporan_histori_transaksi_jam_mahasiswa`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY INVOKER VIEW `vw_laporan_histori_transaksi_jam_mahasiswa`  AS SELECT `u_pengaju`.`id_pengguna` AS `id_pengguna`, `m`.`id_mahasiswa` AS `id_mahasiswa`, `pjp`.`id_pengajuan_jam_plus` AS `id_transaksi`, 'Pengajuan Jam Plus' AS `jenis_transaksi`, `pjp`.`tanggal_pengajuan` AS `tanggal_transaksi`, concat('Jam Plus ',`pjp`.`jenis_jam`,' - ',coalesce(nullif(trim(`pjp`.`deskripsi_pekerjaan`),''),'Tanpa deskripsi'),' | Sumber: ',`pjp`.`sumber_jam`,case when `pjp`.`sumber_jam` = 'Luar' then concat(' (',coalesce(nullif(trim(`k`.`nama_kegiatan`),''),'Kegiatan tidak diketahui'),')') else '' end,' | Jam diterima: ',cast(case when `pjp`.`sumber_jam` = 'Luar' then `pjp`.`jumlah_jam_plus` * 0.5 else `pjp`.`jumlah_jam_plus` end as decimal(10,1)),' jam') AS `deskripsi`, cast(case when `pjp`.`jenis_jam` = 'Kompensasi' then case when `pjp`.`sumber_jam` = 'Luar' then `pjp`.`jumlah_jam_plus` * 0.5 else `pjp`.`jumlah_jam_plus` end else 0 end as decimal(10,1)) AS `saldo_jam_plus_kompensasi`, cast(0 as decimal(10,1)) AS `saldo_jam_minus_kompensasi`, cast(case when `pjp`.`jenis_jam` = 'Murni' then case when `pjp`.`sumber_jam` = 'Luar' then `pjp`.`jumlah_jam_plus` * 0.5 else `pjp`.`jumlah_jam_plus` end else 0 end as decimal(10,1)) AS `saldo_jam_plus_murni`, cast(0 as decimal(10,1)) AS `saldo_jam_minus_murni` FROM ((((`pengajuan_jam_plus` `pjp` join `detail_pengguna_pada_pengajuan_jam_plus` `dp_pengaju` on(`pjp`.`id_pengajuan_jam_plus` = `dp_pengaju`.`id_pengajuan_jam_plus` and `dp_pengaju`.`peran_pengguna` = 'Pengaju')) join `pengguna` `u_pengaju` on(`dp_pengaju`.`id_pengguna` = `u_pengaju`.`id_pengguna`)) join `mahasiswa` `m` on(`u_pengaju`.`id_mahasiswa` = `m`.`id_mahasiswa`)) left join `kegiatan` `k` on(`pjp`.`id_kegiatan` = `k`.`id_kegiatan`)) WHERE `pjp`.`status_pengajuan` = 'Disetujui'union all select `u_penerima`.`id_pengguna` AS `id_pengguna`,`m`.`id_mahasiswa` AS `id_mahasiswa`,`pjm`.`id_pemberian_jam_minus` AS `id_transaksi`,'Pemberian Jam Minus' AS `jenis_transaksi`,`pjm`.`tanggal_pemberian` AS `tanggal_transaksi`,case when `pjm`.`kategori_pelanggaran` = 'Akademik' then concat('Jam Minus ',`pjm`.`jenis_jam`,' - ',coalesce(nullif(trim(`pjm`.`deskripsi_pelanggaran`),''),nullif(trim(`pjm`.`nama_pelanggaran`),''),'Pelanggaran akademik'),' | Mata kuliah: ',coalesce(`mk`.`nama_mata_kuliah`,'-'),' | Absensi: ',coalesce(`pjm`.`keterangan_absensi`,'-'),' | Jumlah: ',cast(`pjm`.`jumlah_jam_minus` as decimal(10,1)),' jam') when `pjm`.`kategori_pelanggaran` = 'Fasilitas' then concat('Jam Minus ',`pjm`.`jenis_jam`,' - ',coalesce(nullif(trim(`pjm`.`deskripsi_pelanggaran`),''),nullif(trim(`pjm`.`nama_pelanggaran`),''),'Kerusakan fasilitas'),' | Fasilitas: ',coalesce(`f`.`nama_fasilitas`,'-'),' | Jumlah: ',cast(`pjm`.`jumlah_jam_minus` as decimal(10,1)),' jam') else concat('Jam Minus ',`pjm`.`jenis_jam`,' - ',coalesce(nullif(trim(`pjm`.`deskripsi_pelanggaran`),''),nullif(trim(`pjm`.`nama_pelanggaran`),''),'Pelanggaran lainnya'),' | Jumlah: ',cast(`pjm`.`jumlah_jam_minus` as decimal(10,1)),' jam') end AS `deskripsi`,cast(0 as decimal(10,1)) AS `saldo_jam_plus_kompensasi`,cast(case when `pjm`.`jenis_jam` = 'Kompensasi' then `pjm`.`jumlah_jam_minus` else 0 end as decimal(10,1)) AS `saldo_jam_minus_kompensasi`,cast(0 as decimal(10,1)) AS `saldo_jam_plus_murni`,cast(case when `pjm`.`jenis_jam` = 'Murni' then `pjm`.`jumlah_jam_minus` else 0 end as decimal(10,1)) AS `saldo_jam_minus_murni` from ((((((`pemberian_jam_minus` `pjm` join `detail_pengguna_pada_pemberian_jam_minus` `dp_penerima` on(`pjm`.`id_pemberian_jam_minus` = `dp_penerima`.`id_pemberian_jam_minus` and `dp_penerima`.`peran_pengguna` = 'Penerima')) join `pengguna` `u_penerima` on(`dp_penerima`.`id_pengguna` = `u_penerima`.`id_pengguna`)) join `mahasiswa` `m` on(`u_penerima`.`id_mahasiswa` = `m`.`id_mahasiswa`)) left join `detail_kelas_pada_mata_kuliah` `dkmk` on(`pjm`.`id_detail_kelas_pada_mata_kuliah` = `dkmk`.`id_detail_kelas_pada_mata_kuliah`)) left join `mata_kuliah` `mk` on(`dkmk`.`id_mata_kuliah` = `mk`.`id_matakuliah`)) left join `fasilitas` `f` on(`pjm`.`id_fasilitas` = `f`.`id_fasilitas`)) union all select `u_penerima_jobdesc`.`id_pengguna` AS `id_pengguna`,`m_jobdesc`.`id_mahasiswa` AS `id_mahasiswa`,`bj`.`id_bursa_jobdesc` AS `id_transaksi`,'Bursa Jobdesc' AS `jenis_transaksi`,`bj`.`tanggal_pemberian_jobdesc` AS `tanggal_transaksi`,concat('Bursa Jobdesc - ',coalesce(nullif(trim(`bj`.`deskripsi_jobdesc`),''),'Tanpa deskripsi'),' | Status: Selesai',' | Jam Plus Kompensasi diterima: ',cast(`bj`.`jam_plus` as decimal(10,1)),' jam') AS `deskripsi`,cast(`bj`.`jam_plus` as decimal(10,1)) AS `saldo_jam_plus_kompensasi`,cast(0 as decimal(10,1)) AS `saldo_jam_minus_kompensasi`,cast(0 as decimal(10,1)) AS `saldo_jam_plus_murni`,cast(0 as decimal(10,1)) AS `saldo_jam_minus_murni` from (((`bursa_jobdesc` `bj` join `detail_pengguna_pada_bursa_jobdesc` `dp_penerima_jobdesc` on(`bj`.`id_bursa_jobdesc` = `dp_penerima_jobdesc`.`id_bursa_jobdesc` and `dp_penerima_jobdesc`.`peran_pengguna` = 'Penerima')) join `pengguna` `u_penerima_jobdesc` on(`dp_penerima_jobdesc`.`id_pengguna` = `u_penerima_jobdesc`.`id_pengguna`)) join `mahasiswa` `m_jobdesc` on(`u_penerima_jobdesc`.`id_mahasiswa` = `m_jobdesc`.`id_mahasiswa`)) where `bj`.`status_jobdesc` = 'Selesai'  ;

-- --------------------------------------------------------

--
-- Struktur untuk view `vw_laporan_pengaduan_fasilitas`
--
DROP TABLE IF EXISTS `vw_laporan_pengaduan_fasilitas`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vw_laporan_pengaduan_fasilitas`  AS SELECT `pkf`.`id_pengaduan_kerusakan_fasilitas` AS `id_pengaduan_kerusakan_fasilitas`, `m`.`id_mahasiswa` AS `id_mahasiswa`, `m`.`nim` AS `nim`, `m`.`nama_mahasiswa` AS `nama_mahasiswa`, coalesce(`k_hist`.`id_kelas`,`k_current`.`id_kelas`) AS `id_kelas`, coalesce(`k_hist`.`nama_kelas`,`k_current`.`nama_kelas`,'-') AS `nama_kelas`, `f`.`id_fasilitas` AS `id_fasilitas`, `f`.`nama_fasilitas` AS `nama_fasilitas`, `pkf`.`deskripsi_kerusakan` AS `deskripsi_kerusakan`, `pkf`.`tanggal_pengaduan` AS `tanggal_pengaduan` FROM (((((((`pengaduan_kerusakan_fasilitas` `pkf` join `fasilitas` `f` on(`pkf`.`id_fasilitas` = `f`.`id_fasilitas`)) join `detail_pengguna_pada_pengaduan_kerusakan_fasilitas` `dp` on(`pkf`.`id_pengaduan_kerusakan_fasilitas` = `dp`.`id_pengaduan_kerusakan_fasilitas` and `dp`.`peran_pengguna` = 'Pelapor')) join `pengguna` `p` on(`dp`.`id_pengguna` = `p`.`id_pengguna`)) join `mahasiswa` `m` on(`p`.`id_mahasiswa` = `m`.`id_mahasiswa`)) left join `detail_fasilitas_pada_kelas` `dfpk` on(`pkf`.`id_detail_fasilitas_pada_kelas` = `dfpk`.`id_detail_fasilitas_pada_kelas`)) left join `kelas` `k_hist` on(`dfpk`.`id_kelas` = `k_hist`.`id_kelas`)) left join `kelas` `k_current` on(`m`.`id_kelas` = `k_current`.`id_kelas`)) ;

-- --------------------------------------------------------

--
-- Struktur untuk view `vw_laporan_total_jam_mahasiswa`
--
DROP TABLE IF EXISTS `vw_laporan_total_jam_mahasiswa`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vw_laporan_total_jam_mahasiswa`  AS SELECT `m`.`id_mahasiswa` AS `id_mahasiswa`, `m`.`nim` AS `nim`, `m`.`nama_mahasiswa` AS `nama_mahasiswa`, `k`.`id_kelas` AS `id_kelas`, `k`.`nama_kelas` AS `nama_kelas`, cast(`ufn_hitung_total_jam_kompensasi_mahasiswa`(`m`.`id_mahasiswa`) as decimal(10,1)) AS `total_jam_kompensasi`, cast(`ufn_hitung_total_jam_murni_mahasiswa`(`m`.`id_mahasiswa`) as decimal(10,1)) AS `total_jam_murni`, cast(`ufn_hitung_total_jam_mahasiswa`(`m`.`id_mahasiswa`) as decimal(10,1)) AS `total_jam_mahasiswa` FROM (`mahasiswa` `m` join `kelas` `k` on(`k`.`id_kelas` = `m`.`id_kelas`)) WHERE `m`.`status_mahasiswa` = 'Aktif' ;

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
  ADD UNIQUE KEY `uq_fasilitas_pada_kelas` (`id_kelas`,`id_fasilitas`),
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
-- Indeks untuk tabel `detail_pengguna_pada_bursa_jobdesc`
--
ALTER TABLE `detail_pengguna_pada_bursa_jobdesc`
  ADD PRIMARY KEY (`id_detail_pengguna_pada_bursa_jobdesc`),
  ADD UNIQUE KEY `uq_bursa_pengguna_peran` (`id_bursa_jobdesc`,`id_pengguna`,`peran_pengguna`),
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
  ADD UNIQUE KEY `uq_pengaduan_satu_peran` (`id_pengaduan_kerusakan_fasilitas`,`peran_pengguna`),
  ADD KEY `fk_detail_pengguna_pengaduan` (`id_pengaduan_kerusakan_fasilitas`),
  ADD KEY `fk_detail_pengaduan_pengguna` (`id_pengguna`),
  ADD KEY `idx_laporan_pengaduan_pelapor` (`peran_pengguna`,`id_pengaduan_kerusakan_fasilitas`,`id_pengguna`);

--
-- Indeks untuk tabel `detail_pengguna_pada_pengajuan_jam_plus`
--
ALTER TABLE `detail_pengguna_pada_pengajuan_jam_plus`
  ADD PRIMARY KEY (`id_detail_pengguna_pada_pengajuan_jam_plus`),
  ADD UNIQUE KEY `uq_pengajuan_satu_peran` (`id_pengajuan_jam_plus`,`peran_pengguna`),
  ADD KEY `fk_detail_pengguna_pengajuan` (`id_pengajuan_jam_plus`),
  ADD KEY `fk_detail_pengajuan_pengguna` (`id_pengguna`);

--
-- Indeks untuk tabel `fasilitas`
--
ALTER TABLE `fasilitas`
  ADD PRIMARY KEY (`id_fasilitas`),
  ADD UNIQUE KEY `uq_fasilitas_nama_aktif` (`nama_fasilitas_aktif`);

--
-- Indeks untuk tabel `histori_login`
--
ALTER TABLE `histori_login`
  ADD PRIMARY KEY (`id_histori_login`),
  ADD KEY `idx_histori_login_pengguna` (`id_pengguna`),
  ADD KEY `idx_histori_login_tanggal` (`tanggal_login`);

--
-- Indeks untuk tabel `kegiatan`
--
ALTER TABLE `kegiatan`
  ADD PRIMARY KEY (`id_kegiatan`),
  ADD UNIQUE KEY `uq_kegiatan_aktif` (`kunci_kegiatan_aktif`);

--
-- Indeks untuk tabel `kelas`
--
ALTER TABLE `kelas`
  ADD PRIMARY KEY (`id_kelas`),
  ADD UNIQUE KEY `uq_kelas_nama_aktif` (`nama_kelas_aktif`);

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
  ADD KEY `fk_pengaduan_fasilitas` (`id_fasilitas`),
  ADD KEY `fk_pengaduan_detail_fasilitas_kelas` (`id_detail_fasilitas_pada_kelas`);

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
  ADD UNIQUE KEY `uq_pengguna_mahasiswa_aktif` (`id_mahasiswa_aktif`),
  ADD UNIQUE KEY `uq_pengguna_pengajar_aktif` (`id_pengajar_aktif`),
  ADD KEY `fk_pengguna_mahasiswa` (`id_mahasiswa`),
  ADD KEY `fk_pengguna_pengajar` (`id_pengajar`);

--
-- Indeks untuk tabel `periode_akademik`
--
ALTER TABLE `periode_akademik`
  ADD PRIMARY KEY (`id_periode_akademik`),
  ADD UNIQUE KEY `uq_periode_tahun_semester` (`tahun_akademik`,`semester`);

--
-- AUTO_INCREMENT untuk tabel yang dibuang
--

--
-- AUTO_INCREMENT untuk tabel `bursa_jobdesc`
--
ALTER TABLE `bursa_jobdesc`
  MODIFY `id_bursa_jobdesc` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT untuk tabel `detail_fasilitas_pada_kelas`
--
ALTER TABLE `detail_fasilitas_pada_kelas`
  MODIFY `id_detail_fasilitas_pada_kelas` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT untuk tabel `detail_kelas_pada_mata_kuliah`
--
ALTER TABLE `detail_kelas_pada_mata_kuliah`
  MODIFY `id_detail_kelas_pada_mata_kuliah` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT untuk tabel `detail_pengguna_pada_bursa_jobdesc`
--
ALTER TABLE `detail_pengguna_pada_bursa_jobdesc`
  MODIFY `id_detail_pengguna_pada_bursa_jobdesc` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=35;

--
-- AUTO_INCREMENT untuk tabel `detail_pengguna_pada_pemberian_jam_minus`
--
ALTER TABLE `detail_pengguna_pada_pemberian_jam_minus`
  MODIFY `id_detail_pengguna_pada_pemberian_jam_minus` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=41;

--
-- AUTO_INCREMENT untuk tabel `detail_pengguna_pada_pengaduan_kerusakan_fasilitas`
--
ALTER TABLE `detail_pengguna_pada_pengaduan_kerusakan_fasilitas`
  MODIFY `id_detail_pengguna_pada_pengaduan_kerusakan_fasilitas` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=34;

--
-- AUTO_INCREMENT untuk tabel `detail_pengguna_pada_pengajuan_jam_plus`
--
ALTER TABLE `detail_pengguna_pada_pengajuan_jam_plus`
  MODIFY `id_detail_pengguna_pada_pengajuan_jam_plus` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=34;

--
-- AUTO_INCREMENT untuk tabel `fasilitas`
--
ALTER TABLE `fasilitas`
  MODIFY `id_fasilitas` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT untuk tabel `histori_login`
--
ALTER TABLE `histori_login`
  MODIFY `id_histori_login` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT untuk tabel `kegiatan`
--
ALTER TABLE `kegiatan`
  MODIFY `id_kegiatan` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT untuk tabel `kelas`
--
ALTER TABLE `kelas`
  MODIFY `id_kelas` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT untuk tabel `mahasiswa`
--
ALTER TABLE `mahasiswa`
  MODIFY `id_mahasiswa` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT untuk tabel `mata_kuliah`
--
ALTER TABLE `mata_kuliah`
  MODIFY `id_matakuliah` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT untuk tabel `pemberian_jam_minus`
--
ALTER TABLE `pemberian_jam_minus`
  MODIFY `id_pemberian_jam_minus` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT untuk tabel `pengaduan_kerusakan_fasilitas`
--
ALTER TABLE `pengaduan_kerusakan_fasilitas`
  MODIFY `id_pengaduan_kerusakan_fasilitas` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT untuk tabel `pengajar`
--
ALTER TABLE `pengajar`
  MODIFY `id_pengajar` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT untuk tabel `pengajuan_jam_plus`
--
ALTER TABLE `pengajuan_jam_plus`
  MODIFY `id_pengajuan_jam_plus` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT untuk tabel `pengguna`
--
ALTER TABLE `pengguna`
  MODIFY `id_pengguna` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT untuk tabel `periode_akademik`
--
ALTER TABLE `periode_akademik`
  MODIFY `id_periode_akademik` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

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
-- Ketidakleluasaan untuk tabel `histori_login`
--
ALTER TABLE `histori_login`
  ADD CONSTRAINT `fk_histori_login_pengguna` FOREIGN KEY (`id_pengguna`) REFERENCES `pengguna` (`id_pengguna`) ON DELETE NO ACTION ON UPDATE NO ACTION;

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
  ADD CONSTRAINT `fk_pengaduan_detail_fasilitas_kelas` FOREIGN KEY (`id_detail_fasilitas_pada_kelas`) REFERENCES `detail_fasilitas_pada_kelas` (`id_detail_fasilitas_pada_kelas`) ON DELETE SET NULL ON UPDATE CASCADE,
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
  ADD CONSTRAINT `fk_pengguna_mahasiswa` FOREIGN KEY (`id_mahasiswa`) REFERENCES `mahasiswa` (`id_mahasiswa`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_pengguna_pengajar` FOREIGN KEY (`id_pengajar`) REFERENCES `pengajar` (`id_pengajar`) ON DELETE NO ACTION ON UPDATE NO ACTION;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
