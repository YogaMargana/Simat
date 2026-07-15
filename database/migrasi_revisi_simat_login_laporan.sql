-- ============================================================
-- MIGRASI REVISI SIMAT: LOGIN PLAINTEXT, RELASI MATA KULIAH,
-- FILTER LAPORAN, RESET JAM PLUS, DAN HISTORI LOGIN
-- Jalankan satu kali pada database db_simat yang sudah ada.
-- Buat backup database sebelum menjalankan migrasi ini.
-- ============================================================

USE `db_simat`;

/*
  Password bcrypt tidak dapat dikembalikan ke plaintext secara matematis.
  Nilai password lama dicadangkan lebih dahulu agar data sebelum migrasi
  tetap tersedia. Akun seed dipulihkan ke password awal. Akun lain yang
  masih memiliki format bcrypt di-reset sementara menjadi 123.
*/
CREATE TABLE IF NOT EXISTS `backup_password_pengguna_sebelum_plaintext` (
  `id_backup` bigint NOT NULL AUTO_INCREMENT,
  `id_pengguna` int NOT NULL,
  `username` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `password_sebelum` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `dicadangkan_pada` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_backup`),
  UNIQUE KEY `uq_backup_password_pengguna` (`id_pengguna`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

INSERT IGNORE INTO `backup_password_pengguna_sebelum_plaintext`
  (`id_pengguna`, `username`, `password_sebelum`)
SELECT `id_pengguna`, `username`, `password`
FROM `pengguna`
WHERE `password` REGEXP '^\\$2[aby]\\$';

UPDATE `pengguna`
SET `password` = CASE
    WHEN `username` = 'mahasiswa@simat.net' THEN '1234'
    WHEN `username` = 'bodat' THEN '098'
    WHEN `username` = 'Fahri' THEN '321'
    ELSE '123'
END
WHERE `password` REGEXP '^\\$2[aby]\\$';

ALTER TABLE `pengguna`
  ADD COLUMN `login_terakhir_at` datetime(6) DEFAULT NULL
  AFTER `status_akun`;

CREATE TABLE `histori_login` (
  `id_histori_login` bigint NOT NULL AUTO_INCREMENT,
  `id_pengguna` int NOT NULL,
  `username` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `role` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `tanggal_login` datetime(6) NOT NULL,
  PRIMARY KEY (`id_histori_login`),
  KEY `idx_histori_login_pengguna` (`id_pengguna`),
  KEY `idx_histori_login_tanggal` (`tanggal_login`),
  CONSTRAINT `fk_histori_login_pengguna`
    FOREIGN KEY (`id_pengguna`) REFERENCES `pengguna` (`id_pengguna`)
    ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

DELIMITER $$
DROP PROCEDURE IF EXISTS `usp_insert_mata_kuliah`$$
CREATE PROCEDURE `usp_insert_mata_kuliah` (
    IN `p_nama` VARCHAR(100),
    IN `p_kode` VARCHAR(20),
    IN `p_sks` INT,
    IN `p_semester` INT,
    IN `p_id_kelas_csv` TEXT
) BEGIN
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

DROP PROCEDURE IF EXISTS `usp_update_mata_kuliah`$$
CREATE PROCEDURE `usp_update_mata_kuliah` (
    IN `p_id` INT,
    IN `p_nama` VARCHAR(100),
    IN `p_kode` VARCHAR(20),
    IN `p_sks` INT,
    IN `p_semester` INT,
    IN `p_status` VARCHAR(20),
    IN `p_id_kelas_csv` TEXT
) BEGIN
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

DROP PROCEDURE IF EXISTS `usp_select_kelas_mata_kuliah_by_id`$$
CREATE PROCEDURE `usp_select_kelas_mata_kuliah_by_id` (IN `p_id_mata_kuliah` INT) BEGIN
    SELECT d.id_kelas, k.nama_kelas, k.tingkat
    FROM detail_kelas_pada_mata_kuliah d
    JOIN kelas k ON k.id_kelas = d.id_kelas
    WHERE d.id_mata_kuliah = p_id_mata_kuliah
    ORDER BY k.tingkat, k.nama_kelas;
END$$

DROP PROCEDURE IF EXISTS `usp_select_laporan_pengaduan_fasilitas_filter`$$
CREATE PROCEDURE `usp_select_laporan_pengaduan_fasilitas_filter` (
    IN `p_tanggal_mulai` DATE,
    IN `p_tanggal_selesai` DATE
) BEGIN
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

DROP PROCEDURE IF EXISTS `usp_select_laporan_histori_jam_mahasiswa_filter`$$
CREATE PROCEDURE `usp_select_laporan_histori_jam_mahasiswa_filter` (
    IN `p_id_pengguna` INT,
    IN `p_tanggal_mulai` DATE,
    IN `p_tanggal_selesai` DATE
) BEGIN
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

DROP PROCEDURE IF EXISTS `usp_update_mahasiswa`$$
CREATE PROCEDURE `usp_update_mahasiswa` (
    IN `p_id_mahasiswa` INT,
    IN `p_id_kelas` INT,
    IN `p_id_periode_akademik` INT,
    IN `p_nim` VARCHAR(20),
    IN `p_nama_mahasiswa` VARCHAR(50),
    IN `p_email` VARCHAR(50),
    IN `p_no_hp` VARCHAR(20),
    IN `p_status_mahasiswa` VARCHAR(20)
) BEGIN
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

DROP PROCEDURE IF EXISTS `usp_catat_login_pengguna`$$
CREATE PROCEDURE `usp_catat_login_pengguna` (IN `p_id_pengguna` INT) BEGIN
    UPDATE pengguna
    SET login_terakhir_at = NOW(6)
    WHERE id_pengguna = p_id_pengguna
      AND status_akun = 'Aktif';

    IF ROW_COUNT() = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Pengguna aktif tidak ditemukan';
    END IF;
END$$

DROP PROCEDURE IF EXISTS `usp_select_histori_login`$$
CREATE PROCEDURE `usp_select_histori_login` () BEGIN
    SELECT id_histori_login, id_pengguna, username, role, tanggal_login
    FROM histori_login
    ORDER BY tanggal_login DESC, id_histori_login DESC;
END$$

DROP PROCEDURE IF EXISTS `usp_update_password_pengguna`$$
CREATE PROCEDURE `usp_update_password_pengguna` (IN `p_id_pengguna` INT, IN `p_password` VARCHAR(255)) BEGIN
    IF p_password IS NULL OR p_password = '' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Password tidak valid';
    END IF;
    UPDATE pengguna SET password = p_password WHERE id_pengguna = p_id_pengguna;
END$$

DROP TRIGGER IF EXISTS `trg_pengguna_au_histori_login`$$
CREATE TRIGGER `trg_pengguna_au_histori_login`
AFTER UPDATE ON `pengguna`
FOR EACH ROW
BEGIN
    IF NEW.login_terakhir_at IS NOT NULL
       AND NOT (NEW.login_terakhir_at <=> OLD.login_terakhir_at) THEN
        INSERT INTO histori_login (id_pengguna, username, role, tanggal_login)
        VALUES (NEW.id_pengguna, NEW.username, NEW.role, NEW.login_terakhir_at);
    END IF;
END$$

DELIMITER ;

-- Verifikasi singkat setelah migrasi:
-- SHOW CREATE TABLE histori_login;
-- SHOW CREATE PROCEDURE usp_insert_mata_kuliah;
-- SHOW CREATE PROCEDURE usp_update_mahasiswa;
-- SHOW CREATE TRIGGER trg_pengguna_au_histori_login;
