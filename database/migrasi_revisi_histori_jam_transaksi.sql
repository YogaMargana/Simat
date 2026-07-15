-- =========================================================
-- MIGRASI REVISI LAPORAN HISTORI JAM MAHASISWA
--
-- Tujuan:
-- Empat kolom jam pada laporan menampilkan nilai jam dari
-- setiap transaksi pengajuan jam plus atau pemberian jam
-- minus, bukan saldo mahasiswa saat laporan dibuka.
--
-- Migrasi ini tidak menghapus atau mengubah data transaksi.
-- Hanya definisi view laporan yang diganti.
-- =========================================================

USE `db_simat`;

DROP VIEW IF EXISTS `vw_laporan_histori_transaksi_jam_mahasiswa`;

CREATE ALGORITHM=UNDEFINED SQL SECURITY INVOKER VIEW `vw_laporan_histori_transaksi_jam_mahasiswa` AS
SELECT
    `u_pengaju`.`id_pengguna` AS `id_pengguna`,
    `m`.`id_mahasiswa` AS `id_mahasiswa`,
    `pjp`.`id_pengajuan_jam_plus` AS `id_transaksi`,
    'Pengajuan Jam Plus' AS `jenis_transaksi`,
    `pjp`.`tanggal_pengajuan` AS `tanggal_transaksi`,
    CONCAT(
        'Jam Plus ',
        `pjp`.`jenis_jam`,
        ' - ',
        COALESCE(NULLIF(TRIM(`pjp`.`deskripsi_pekerjaan`), ''), 'Tanpa deskripsi'),
        ' | Sumber: ',
        `pjp`.`sumber_jam`,
        CASE
            WHEN `pjp`.`sumber_jam` = 'Luar' THEN CONCAT(
                ' (',
                COALESCE(NULLIF(TRIM(`k`.`nama_kegiatan`), ''), 'Kegiatan tidak diketahui'),
                ')'
            )
            ELSE ''
        END,
        ' | Jam diterima: ',
        CAST(
            CASE
                WHEN `pjp`.`sumber_jam` = 'Luar' THEN `pjp`.`jumlah_jam_plus` * 0.5
                ELSE `pjp`.`jumlah_jam_plus`
            END AS DECIMAL(10,1)
        ),
        ' jam'
    ) AS `deskripsi`,
    CAST(
        CASE
            WHEN `pjp`.`jenis_jam` = 'Kompensasi' THEN
                CASE
                    WHEN `pjp`.`sumber_jam` = 'Luar' THEN `pjp`.`jumlah_jam_plus` * 0.5
                    ELSE `pjp`.`jumlah_jam_plus`
                END
            ELSE 0
        END AS DECIMAL(10,1)
    ) AS `saldo_jam_plus_kompensasi`,
    CAST(0 AS DECIMAL(10,1)) AS `saldo_jam_minus_kompensasi`,
    CAST(
        CASE
            WHEN `pjp`.`jenis_jam` = 'Murni' THEN
                CASE
                    WHEN `pjp`.`sumber_jam` = 'Luar' THEN `pjp`.`jumlah_jam_plus` * 0.5
                    ELSE `pjp`.`jumlah_jam_plus`
                END
            ELSE 0
        END AS DECIMAL(10,1)
    ) AS `saldo_jam_plus_murni`,
    CAST(0 AS DECIMAL(10,1)) AS `saldo_jam_minus_murni`
FROM `pengajuan_jam_plus` `pjp`
JOIN `detail_pengguna_pada_pengajuan_jam_plus` `dp_pengaju`
    ON `pjp`.`id_pengajuan_jam_plus` = `dp_pengaju`.`id_pengajuan_jam_plus`
   AND `dp_pengaju`.`peran_pengguna` = 'Pengaju'
JOIN `pengguna` `u_pengaju`
    ON `dp_pengaju`.`id_pengguna` = `u_pengaju`.`id_pengguna`
JOIN `mahasiswa` `m`
    ON `u_pengaju`.`id_mahasiswa` = `m`.`id_mahasiswa`
LEFT JOIN `kegiatan` `k`
    ON `pjp`.`id_kegiatan` = `k`.`id_kegiatan`
WHERE `pjp`.`status_pengajuan` = 'Disetujui'

UNION ALL

SELECT
    `u_penerima`.`id_pengguna` AS `id_pengguna`,
    `m`.`id_mahasiswa` AS `id_mahasiswa`,
    `pjm`.`id_pemberian_jam_minus` AS `id_transaksi`,
    'Pemberian Jam Minus' AS `jenis_transaksi`,
    `pjm`.`tanggal_pemberian` AS `tanggal_transaksi`,
    CASE
        WHEN `pjm`.`kategori_pelanggaran` = 'Akademik' THEN CONCAT(
            'Jam Minus ',
            `pjm`.`jenis_jam`,
            ' - ',
            COALESCE(
                NULLIF(TRIM(`pjm`.`deskripsi_pelanggaran`), ''),
                NULLIF(TRIM(`pjm`.`nama_pelanggaran`), ''),
                'Pelanggaran akademik'
            ),
            ' | Mata kuliah: ',
            COALESCE(`mk`.`nama_mata_kuliah`, '-'),
            ' | Absensi: ',
            COALESCE(`pjm`.`keterangan_absensi`, '-'),
            ' | Jumlah: ',
            CAST(`pjm`.`jumlah_jam_minus` AS DECIMAL(10,1)),
            ' jam'
        )
        WHEN `pjm`.`kategori_pelanggaran` = 'Fasilitas' THEN CONCAT(
            'Jam Minus ',
            `pjm`.`jenis_jam`,
            ' - ',
            COALESCE(
                NULLIF(TRIM(`pjm`.`deskripsi_pelanggaran`), ''),
                NULLIF(TRIM(`pjm`.`nama_pelanggaran`), ''),
                'Kerusakan fasilitas'
            ),
            ' | Fasilitas: ',
            COALESCE(`f`.`nama_fasilitas`, '-'),
            ' | Jumlah: ',
            CAST(`pjm`.`jumlah_jam_minus` AS DECIMAL(10,1)),
            ' jam'
        )
        ELSE CONCAT(
            'Jam Minus ',
            `pjm`.`jenis_jam`,
            ' - ',
            COALESCE(
                NULLIF(TRIM(`pjm`.`deskripsi_pelanggaran`), ''),
                NULLIF(TRIM(`pjm`.`nama_pelanggaran`), ''),
                'Pelanggaran lainnya'
            ),
            ' | Jumlah: ',
            CAST(`pjm`.`jumlah_jam_minus` AS DECIMAL(10,1)),
            ' jam'
        )
    END AS `deskripsi`,
    CAST(0 AS DECIMAL(10,1)) AS `saldo_jam_plus_kompensasi`,
    CAST(
        CASE
            WHEN `pjm`.`jenis_jam` = 'Kompensasi' THEN `pjm`.`jumlah_jam_minus`
            ELSE 0
        END AS DECIMAL(10,1)
    ) AS `saldo_jam_minus_kompensasi`,
    CAST(0 AS DECIMAL(10,1)) AS `saldo_jam_plus_murni`,
    CAST(
        CASE
            WHEN `pjm`.`jenis_jam` = 'Murni' THEN `pjm`.`jumlah_jam_minus`
            ELSE 0
        END AS DECIMAL(10,1)
    ) AS `saldo_jam_minus_murni`
FROM `pemberian_jam_minus` `pjm`
JOIN `detail_pengguna_pada_pemberian_jam_minus` `dp_penerima`
    ON `pjm`.`id_pemberian_jam_minus` = `dp_penerima`.`id_pemberian_jam_minus`
   AND `dp_penerima`.`peran_pengguna` = 'Penerima'
JOIN `pengguna` `u_penerima`
    ON `dp_penerima`.`id_pengguna` = `u_penerima`.`id_pengguna`
JOIN `mahasiswa` `m`
    ON `u_penerima`.`id_mahasiswa` = `m`.`id_mahasiswa`
LEFT JOIN `detail_kelas_pada_mata_kuliah` `dkmk`
    ON `pjm`.`id_detail_kelas_pada_mata_kuliah` = `dkmk`.`id_detail_kelas_pada_mata_kuliah`
LEFT JOIN `mata_kuliah` `mk`
    ON `dkmk`.`id_mata_kuliah` = `mk`.`id_matakuliah`
LEFT JOIN `fasilitas` `f`
    ON `pjm`.`id_fasilitas` = `f`.`id_fasilitas`;
