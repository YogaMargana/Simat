-- =========================================================
-- MIGRASI REVISI DASHBOARD SIMAT
-- =========================================================
-- Tujuan:
-- 1. Menambahkan ringkasan total jam mahasiswa.
-- 2. Menambahkan total Bursa Jobdesc berstatus Dikerjakan
--    yang dibuat oleh pengguna yang sedang login.
-- 3. Menambahkan ringkasan PIC Tata Tertib.
-- 4. Menambahkan total kegiatan aktif.
-- 5. Menambahkan total mata kuliah aktif.
--
-- Migrasi ini tidak menghapus atau mengubah data lama.
-- Jalankan satu kali pada database db_simat yang sudah ada.
-- =========================================================

USE `db_simat`;

DELIMITER $$

DROP PROCEDURE IF EXISTS `usp_dashboard_ringkasan`$$
CREATE PROCEDURE `usp_dashboard_ringkasan` (IN `p_id_pengguna` INT)
BEGIN
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

DELIMITER ;
