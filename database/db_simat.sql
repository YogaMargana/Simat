-- SIMAT database - ready import for phpMyAdmin, XAMPP, and Laragon
-- Generated from db_simat(1).sql
-- Compatibility target: MySQL 5.7+/8.x and MariaDB 10.2+
-- WARNING: this script drops and recreates the `db_simat` database.

SET @OLD_SQL_MODE=@@SQL_MODE;
SET SQL_MODE='NO_AUTO_VALUE_ON_ZERO';
SET @OLD_TIME_ZONE=@@TIME_ZONE;
SET TIME_ZONE='+00:00';
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS;
SET FOREIGN_KEY_CHECKS=0;
SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS;
SET UNIQUE_CHECKS=0;

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

DROP DATABASE IF EXISTS `db_simat`;
CREATE DATABASE `db_simat`
  DEFAULT CHARACTER SET utf8mb4
  DEFAULT COLLATE utf8mb4_general_ci;
USE `db_simat`;

-- --------------------------------------------------------

-- Base tables and data

-- Table structure for table `bursa_jobdesc`
--

CREATE TABLE `bursa_jobdesc` (
  `id_bursa_jobdesc` int NOT NULL,
  `deskripsi_jobdesc` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `penerima_jobdesc` enum('Semua Mahasiswa','Mahasiswa dengan Jam Minus') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'Semua Mahasiswa',
  `jam_plus` decimal(6,1) NOT NULL,
  `tanggal_pemberian_jobdesc` datetime NOT NULL,
  `jumlah_mahasiswa_diperlukan` int NOT NULL,
  `jumlah_mahasiswa_mengambil` int NOT NULL DEFAULT '0',
  `bukti_selesai_url` varchar(2048) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `status_jobdesc` enum('Dibuka','Dikerjakan','Selesai') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT 'Dibuka'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `bursa_jobdesc`
--

INSERT INTO `bursa_jobdesc` (`id_bursa_jobdesc`, `deskripsi_jobdesc`, `penerima_jobdesc`, `jam_plus`, `tanggal_pemberian_jobdesc`, `jumlah_mahasiswa_diperlukan`, `jumlah_mahasiswa_mengambil`, `bukti_selesai_url`, `status_jobdesc`) VALUES
(1, 'wertg34', 'Semua Mahasiswa', '20.0', '2026-06-18 18:46:00', 2, 2, 'https://halo', 'Selesai'),
(2, 'Membersihkan tendik', 'Semua Mahasiswa', '20.0', '2026-06-19 22:20:00', 10, 10, 'https://halo', 'Selesai'),
(3, 'Perbaiki laptop', 'Semua Mahasiswa', '10.0', '2026-06-20 00:00:00', 2, 2, 'https://halo', 'Selesai'),
(4, 'Cari ikan', 'Mahasiswa dengan Jam Minus', '90.0', '2026-06-27 04:40:00', 2, 2, 'a', 'Selesai'),
(5, 'hdsufodsf', 'Semua Mahasiswa', '20.0', '2026-06-19 08:36:00', 2, 2, 'selesai cik', 'Selesai'),
(6, 'Rapihkan Tendik', 'Semua Mahasiswa', '1.0', '2026-07-09 18:35:00', 3, 3, 'https://www.bing.com/search?pglt=299&q=apa&cvid=d715390a2ba542ac8f692dee3df6f0fe&gs_lcrp=EgRlZGdlKgYIABBFGDkyBggAEEUYOTIGCAEQRRg80gEHNjU2ajBqN6gCALACAA&FORM=ANNTA1&PC=U531', 'Selesai'),
(7, 'a', 'Semua Mahasiswa', '1.0', '2026-07-12 01:19:00', 1, 1, NULL, 'Dikerjakan');

-- --------------------------------------------------------

--
-- Table structure for table `detail_fasilitas_pada_kelas`
--

CREATE TABLE `detail_fasilitas_pada_kelas` (
  `id_detail_fasilitas_pada_kelas` int NOT NULL,
  `id_kelas` int NOT NULL,
  `id_fasilitas` int NOT NULL,
  `status_detail_fasilitas_pada_kelas` enum('Aktif','Rusak','Tidak Aktif') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT 'Aktif'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `detail_fasilitas_pada_kelas`
--

INSERT INTO `detail_fasilitas_pada_kelas` (`id_detail_fasilitas_pada_kelas`, `id_kelas`, `id_fasilitas`, `status_detail_fasilitas_pada_kelas`) VALUES
(1, 1, 6, 'Aktif'),
(2, 1, 7, 'Rusak'),
(3, 2, 8, 'Rusak'),
(4, 5, 5, 'Aktif'),
(5, 1, 8, 'Aktif'),
(6, 2, 5, 'Aktif'),
(7, 6, 9, 'Tidak Aktif'),
(8, 1, 9, 'Aktif'),
(10, 5, 9, 'Aktif');

-- --------------------------------------------------------

--
-- Table structure for table `detail_kelas_pada_mata_kuliah`
--

CREATE TABLE `detail_kelas_pada_mata_kuliah` (
  `id_detail_kelas_pada_mata_kuliah` int NOT NULL,
  `id_mata_kuliah` int NOT NULL,
  `id_kelas` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `detail_kelas_pada_mata_kuliah`
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
-- Table structure for table `detail_pengguna_pada_bursa_jobdesc`
--

CREATE TABLE `detail_pengguna_pada_bursa_jobdesc` (
  `id_detail_pengguna_pada_bursa_jobdesc` int NOT NULL,
  `id_bursa_jobdesc` int NOT NULL,
  `id_pengguna` int NOT NULL,
  `peran_pengguna` enum('Pemberi','Penerima') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `detail_pengguna_pada_bursa_jobdesc`
--

INSERT INTO `detail_pengguna_pada_bursa_jobdesc` (`id_detail_pengguna_pada_bursa_jobdesc`, `id_bursa_jobdesc`, `id_pengguna`, `peran_pengguna`) VALUES
(1, 1, 2, 'Pemberi'),
(15, 1, 7, 'Penerima'),
(14, 1, 9, 'Penerima'),
(3, 2, 6, 'Pemberi'),
(4, 2, 7, 'Penerima'),
(5, 2, 9, 'Penerima'),
(6, 2, 10, 'Penerima'),
(7, 2, 12, 'Penerima'),
(8, 2, 13, 'Penerima'),
(9, 2, 14, 'Penerima'),
(10, 2, 15, 'Penerima'),
(11, 2, 16, 'Penerima'),
(12, 2, 17, 'Penerima'),
(13, 2, 18, 'Penerima'),
(16, 3, 6, 'Pemberi'),
(21, 3, 16, 'Penerima'),
(20, 3, 19, 'Penerima'),
(17, 4, 2, 'Pemberi'),
(18, 4, 7, 'Penerima'),
(19, 4, 15, 'Penerima'),
(22, 5, 2, 'Pemberi'),
(23, 5, 9, 'Penerima'),
(24, 5, 10, 'Penerima'),
(25, 6, 6, 'Pemberi'),
(28, 6, 7, 'Penerima'),
(26, 6, 9, 'Penerima'),
(27, 6, 19, 'Penerima'),
(29, 7, 3, 'Pemberi'),
(30, 7, 9, 'Penerima');

-- --------------------------------------------------------

--
-- Table structure for table `detail_pengguna_pada_pemberian_jam_minus`
--

CREATE TABLE `detail_pengguna_pada_pemberian_jam_minus` (
  `id_detail_pengguna_pada_pemberian_jam_minus` int NOT NULL,
  `id_pemberian_jam_minus` int NOT NULL,
  `id_pengguna` int NOT NULL,
  `peran_pengguna` enum('Pemberi','Penerima') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `detail_pengguna_pada_pemberian_jam_minus`
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
(10, 5, 12, 'Penerima'),
(11, 6, 3, 'Pemberi'),
(12, 6, 16, 'Penerima'),
(13, 7, 3, 'Pemberi'),
(14, 7, 14, 'Penerima');

-- --------------------------------------------------------

--
-- Table structure for table `detail_pengguna_pada_pengaduan_kerusakan_fasilitas`
--

CREATE TABLE `detail_pengguna_pada_pengaduan_kerusakan_fasilitas` (
  `id_detail_pengguna_pada_pengaduan_kerusakan_fasilitas` int NOT NULL,
  `id_pengaduan_kerusakan_fasilitas` int NOT NULL,
  `id_pengguna` int NOT NULL,
  `peran_pengguna` enum('Pelapor','Verifikator') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `detail_pengguna_pada_pengaduan_kerusakan_fasilitas`
--

INSERT INTO `detail_pengguna_pada_pengaduan_kerusakan_fasilitas` (`id_detail_pengguna_pada_pengaduan_kerusakan_fasilitas`, `id_pengaduan_kerusakan_fasilitas`, `id_pengguna`, `peran_pengguna`) VALUES
(1, 1, 1, 'Pelapor'),
(2, 2, 1, 'Pelapor'),
(4, 3, 7, 'Pelapor'),
(5, 4, 7, 'Pelapor'),
(8, 5, 7, 'Pelapor'),
(10, 6, 9, 'Pelapor'),
(14, 7, 7, 'Pelapor'),
(15, 8, 9, 'Pelapor'),
(18, 9, 7, 'Pelapor'),
(20, 10, 9, 'Pelapor'),
(22, 11, 9, 'Pelapor'),
(13, 1, 4, 'Verifikator'),
(3, 2, 4, 'Verifikator'),
(6, 3, 4, 'Verifikator'),
(7, 4, 4, 'Verifikator'),
(9, 5, 4, 'Verifikator'),
(11, 6, 4, 'Verifikator'),
(17, 7, 4, 'Verifikator'),
(16, 8, 4, 'Verifikator'),
(19, 9, 4, 'Verifikator'),
(21, 10, 4, 'Verifikator'),
(23, 11, 4, 'Verifikator');

-- --------------------------------------------------------

--
-- Table structure for table `detail_pengguna_pada_pengajuan_jam_plus`
--

CREATE TABLE `detail_pengguna_pada_pengajuan_jam_plus` (
  `id_detail_pengguna_pada_pengajuan_jam_plus` int NOT NULL,
  `id_pengajuan_jam_plus` int NOT NULL,
  `id_pengguna` int NOT NULL,
  `peran_pengguna` enum('Pengaju','Verifikator') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `detail_pengguna_pada_pengajuan_jam_plus`
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
(15, 10, 3, 'Verifikator');

-- --------------------------------------------------------

--
-- Table structure for table `fasilitas`
--

CREATE TABLE `fasilitas` (
  `id_fasilitas` int NOT NULL,
  `nama_fasilitas` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `harga` decimal(15,2) DEFAULT '0.00',
  `stok` int NOT NULL DEFAULT '0',
  `status_fasilitas` enum('Aktif','Tidak Aktif') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT 'Aktif',
  `nama_fasilitas_aktif` varchar(50) COLLATE utf8mb4_general_ci GENERATED ALWAYS AS ((case when (`status_fasilitas` = 'Aktif') then upper(trim(`nama_fasilitas`)) else NULL end)) STORED,
  `tanggal_pendataan` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `fasilitas`
--

INSERT INTO `fasilitas` (`id_fasilitas`, `nama_fasilitas`, `harga`, `stok`, `status_fasilitas`, `tanggal_pendataan`) VALUES
(1, 'Proyektor Kelas', '4500000.00', 0, 'Tidak Aktif', '2026-06-08 22:50:43'),
(2, 'AC Kelas', '3500000.00', 0, 'Tidak Aktif', '2026-06-08 22:50:43'),
(3, 'Komputer Lab', '8500000.00', 0, 'Tidak Aktif', '2026-06-08 22:50:43'),
(4, 'Kursi Kelas Lama', '350000.00', 0, 'Tidak Aktif', '2026-06-08 22:50:43'),
(5, 'Papan Tulis', '750000.00', 0, 'Aktif', '2026-06-08 22:50:43'),
(6, 'Bangku', '100000.00', 0, 'Tidak Aktif', '2026-06-11 23:44:46'),
(7, 'Kursi', '120000.00', 0, 'Tidak Aktif', '2026-06-17 19:24:58'),
(8, 'Kursi Kelas', '170000.00', 0, 'Aktif', '2026-06-17 19:30:39'),
(9, 'AC', '1000000.00', 0, 'Aktif', '2026-07-15 09:26:07');

-- --------------------------------------------------------

--
-- Table structure for table `kegiatan`
--

CREATE TABLE `kegiatan` (
  `id_kegiatan` int NOT NULL,
  `nama_kegiatan` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `penyelenggara` enum('ASTRAtech','BEM','MPM','HIMMA','UKM','Prodi') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `tanggal_kegiatan` date DEFAULT NULL,
  `status_kegiatan` enum('Aktif','Tidak Aktif') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT 'Aktif',
  `tanggal_kegiatan_kunci` date GENERATED ALWAYS AS (coalesce(`tanggal_kegiatan`,cast('1000-01-01' as date))) STORED,
  `kunci_kegiatan_aktif` varchar(100) COLLATE utf8mb4_general_ci GENERATED ALWAYS AS ((case when (`status_kegiatan` = 'Aktif') then concat_ws('|',upper(trim(`nama_kegiatan`)),`penyelenggara`,coalesce(cast(`tanggal_kegiatan` AS CHAR CHARACTER SET utf8mb4),'1000-01-01')) else NULL end)) STORED
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `kegiatan`
--

INSERT INTO `kegiatan` (`id_kegiatan`, `nama_kegiatan`, `penyelenggara`, `tanggal_kegiatan`, `status_kegiatan`) VALUES
(1, 'ASTRA', 'ASTRAtech', NULL, 'Tidak Aktif'),
(2, 'Donor Darah', 'BEM', '2026-07-15', 'Aktif'),
(3, 'Novastech', 'ASTRAtech', '2026-07-23', 'Aktif');

-- --------------------------------------------------------

--
-- Table structure for table `kelas`
--

CREATE TABLE `kelas` (
  `id_kelas` int NOT NULL,
  `nama_kelas` varchar(5) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `tingkat` enum('1','2','3','4') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `jumlah_mahasiswa` int DEFAULT '0',
  `status_kelas` enum('Aktif','Tidak Aktif') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT 'Aktif',
  `nama_kelas_aktif` varchar(5) COLLATE utf8mb4_general_ci GENERATED ALWAYS AS ((case when (`status_kelas` = 'Aktif') then upper(trim(`nama_kelas`)) else NULL end)) STORED
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `kelas`
--

INSERT INTO `kelas` (`id_kelas`, `nama_kelas`, `tingkat`, `jumlah_mahasiswa`, `status_kelas`) VALUES
(1, 'TR1C', '1', 3, 'Aktif'),
(2, 'TR1B', '1', 2, 'Aktif'),
(3, 'TR1K', '2', 0, 'Tidak Aktif'),
(4, 'IUGHS', '1', 0, 'Tidak Aktif'),
(5, 'TR1A', '1', 6, 'Aktif'),
(6, 'A', '1', 0, 'Aktif');

-- --------------------------------------------------------

--
-- Table structure for table `mahasiswa`
--

CREATE TABLE `mahasiswa` (
  `id_mahasiswa` int NOT NULL,
  `id_kelas` int NOT NULL,
  `id_periode_akademik` int NOT NULL,
  `nim` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `nama_mahasiswa` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `email` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `no_hp` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `saldo_jam_minus_murni` decimal(10,1) NOT NULL DEFAULT '0.0',
  `saldo_jam_minus_kompensasi` decimal(10,1) NOT NULL DEFAULT '0.0',
  `saldo_jam_plus_murni` decimal(10,1) NOT NULL DEFAULT '0.0',
  `saldo_jam_plus_kompensasi` decimal(10,1) NOT NULL DEFAULT '0.0',
  `status_mahasiswa` enum('Aktif','Tidak Aktif','Lulus','Cuti') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT 'Aktif'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `mahasiswa`
--

INSERT INTO `mahasiswa` (`id_mahasiswa`, `id_kelas`, `id_periode_akademik`, `nim`, `nama_mahasiswa`, `email`, `no_hp`, `saldo_jam_minus_murni`, `saldo_jam_minus_kompensasi`, `saldo_jam_plus_murni`, `saldo_jam_plus_kompensasi`, `status_mahasiswa`) VALUES
(1, 1, 1, '032025001', 'Yoga Margana', 'yoga@simat.test', '081111111111', '7.0', '0.0', '1.0', '1.0', 'Aktif'),
(2, 1, 1, '032025002', 'Fahri Aprilian', 'fahri@simat.test', '082222222222', '0.0', '1.0', '0.0', '1.0', 'Aktif'),
(3, 1, 1, '032025003', 'Nabilah Putri', 'nabilah@simat.test', '083333333333', '3.0', '0.0', '0.0', '10.0', 'Aktif'),
(4, 1, 1, '0987692345', 'Marganaa', 'marganayoga891@gmail.com', '089088752369', '0.0', '0.0', '0.0', '0.0', 'Tidak Aktif'),
(5, 2, 1, '0920250039', 'Mikael', 'mikael@gmail.com', '081298394420', '0.0', '1750.0', '20.0', '26.0', 'Aktif'),
(6, 2, 1, '0920250035', 'Ridzal', 'Ridzal@gmail.com', '085477325643', '0.0', '0.0', '0.0', '0.0', 'Tidak Aktif'),
(7, 5, 1, '1', 'Mazt', NULL, NULL, '20.0', '0.5', '0.0', '0.0', 'Aktif'),
(8, 5, 1, '2', 'Daffa', NULL, NULL, '0.0', '0.0', '0.0', '0.0', 'Aktif'),
(9, 5, 1, '3', 'Rijal', NULL, NULL, '0.0', '4270.0', '0.0', '0.0', 'Aktif'),
(10, 5, 1, '4', 'Adit', NULL, NULL, '0.0', '1750.0', '0.0', '0.0', 'Aktif'),
(11, 5, 1, '5', 'Jonathan', NULL, NULL, '0.0', '0.0', '0.0', '0.0', 'Aktif'),
(12, 5, 1, '6', 'Irsyad', NULL, NULL, '0.0', '0.0', '0.0', '0.0', 'Aktif'),
(13, 2, 1, '9', 'Hailkal', NULL, NULL, '0.0', '0.0', '100.0', '1.0', 'Aktif');


-- --------------------------------------------------------

--
-- Table structure for table `mata_kuliah`
--

CREATE TABLE `mata_kuliah` (
  `id_matakuliah` int NOT NULL,
  `nama_mata_kuliah` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `kode_mata_kuliah` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `sks` int NOT NULL,
  `semester` enum('1','2','3','4','5','6','7','8') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `status_mata_kuliah` enum('Aktif','Tidak Aktif') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT 'Aktif'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `mata_kuliah`
--

INSERT INTO `mata_kuliah` (`id_matakuliah`, `nama_mata_kuliah`, `kode_mata_kuliah`, `sks`, `semester`, `status_mata_kuliah`) VALUES
(1, 'Pemrograman Web', 'WEB101', 3, '2', 'Aktif'),
(2, 'Basis Data', 'BD101', 3, '2', 'Aktif'),
(3, 'Algoritma Pemrograman', 'ALG101', 3, '1', 'Aktif'),
(4, 'Rekayasa Perangkat Lunak', 'RPL101', 3, '3', 'Aktif'),
(5, 'Pemrograman Berorientasi Objek', 'PBO101', 3, '3', 'Aktif');

-- --------------------------------------------------------

--
-- Table structure for table `pemberian_jam_minus`
--

CREATE TABLE `pemberian_jam_minus` (
  `id_pemberian_jam_minus` int NOT NULL,
  `kategori_pelanggaran` enum('Akademik','Fasilitas','Lainnya') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `id_detail_kelas_pada_mata_kuliah` int DEFAULT NULL,
  `keterangan_absensi` enum('Izin','Sakit','Alpa') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `id_fasilitas` int DEFAULT NULL,
  `harga_fasilitas_saat_pemberian` decimal(15,2) DEFAULT NULL,
  `nama_pelanggaran` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `deskripsi_pelanggaran` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
  `jumlah_jam_minus` decimal(10,1) NOT NULL,
  `jenis_jam` enum('Murni','Kompensasi') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `tanggal_pemberian` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `pemberian_jam_minus`
--

INSERT INTO `pemberian_jam_minus` (`id_pemberian_jam_minus`, `kategori_pelanggaran`, `id_detail_kelas_pada_mata_kuliah`, `keterangan_absensi`, `id_fasilitas`, `harga_fasilitas_saat_pemberian`, `nama_pelanggaran`, `deskripsi_pelanggaran`, `jumlah_jam_minus`, `jenis_jam`, `tanggal_pemberian`) VALUES
(1, 'Akademik', 2, 'Alpa', NULL, NULL, 'Pelanggaran Akademik', NULL, '5.0', 'Murni', '2026-07-06 19:21:40'),
(2, 'Fasilitas', NULL, NULL, 2, '3500000.00', 'Kerusakan Fasilitas', NULL, '1750.0', 'Kompensasi', '2026-07-06 21:11:02'),
(3, 'Fasilitas', NULL, NULL, 3, '8500000.00', 'Kerusakan Fasilitas', NULL, '4250.0', 'Kompensasi', '2026-07-07 10:04:33'),
(4, 'Akademik', 5, 'Izin', NULL, NULL, 'Pelanggaran Akademik', NULL, '20.0', 'Murni', '2026-07-12 04:21:20'),
(5, 'Fasilitas', NULL, NULL, 2, '3500000.00', 'Kerusakan Fasilitas', NULL, '1750.0', 'Kompensasi', '2026-07-14 15:04:34'),
(6, 'Lainnya', NULL, NULL, NULL, NULL, 'Pelanggaran Lainnya', 'Tidak Masuk Kampus', '20.0', 'Kompensasi', '2026-07-14 15:12:49'),
(7, 'Lainnya', NULL, NULL, NULL, NULL, 'Pelanggaran Lainnya', 'Bolos', '0.5', 'Kompensasi', '2026-07-15 09:30:46');

-- --------------------------------------------------------

--
-- Table structure for table `pengaduan_kerusakan_fasilitas`
--

CREATE TABLE `pengaduan_kerusakan_fasilitas` (
  `id_pengaduan_kerusakan_fasilitas` int NOT NULL,
  `id_fasilitas` int NOT NULL,
  `id_detail_fasilitas_pada_kelas` int DEFAULT NULL,
  `deskripsi_kerusakan` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `tanggal_pengaduan` datetime NOT NULL,
  `bukti_kerusakan_url` varchar(2048) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `pelaku_kerusakan` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `status_pengaduan` enum('Menunggu Verifikasi','Diterima','Ditolak') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT 'Menunggu Verifikasi',
  `alsan_penolakan` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `pengaduan_kerusakan_fasilitas`
--

INSERT INTO `pengaduan_kerusakan_fasilitas` (`id_pengaduan_kerusakan_fasilitas`, `id_fasilitas`, `id_detail_fasilitas_pada_kelas`, `deskripsi_kerusakan`, `tanggal_pengaduan`, `bukti_kerusakan_url`, `pelaku_kerusakan`, `status_pengaduan`, `alsan_penolakan`) VALUES
(1, 1, NULL, 'Proyektor kelas tidak menyala saat digunakan.', '2026-06-08 22:50:43', 'assets/uploads/pengaduan/dummy-proyektor.jpg', NULL, 'Ditolak', NULL),
(2, 2, NULL, 'AC kelas tidak dingin dan mengeluarkan suara bising.', '2026-06-08 22:50:43', 'assets/uploads/pengaduan/dummy-ac.jpg', NULL, 'Diterima', NULL),
(3, 6, 1, 'azhar', '2026-06-12 00:22:50', 'azhar', 'Tidak diketahui', 'Diterima', NULL),
(4, 6, 1, 'azhar', '2026-06-12 00:23:21', 'azhar', 'azhar', 'Ditolak', NULL),
(5, 6, 1, 'azahr', '2026-06-12 00:29:55', 'https://www.youtube.com/', 'azhar', 'Diterima', NULL),
(6, 8, 3, 'aku lempar jir', '2026-06-17 19:31:24', 'https://example.invalid/bukti-kerusakan-6', 'azhar', 'Diterima', NULL),
(7, 7, 2, 'kaki patah', '2026-06-25 10:23:15', 'xmxb', 'saya sendiri', 'Diterima', NULL),
(8, 8, 3, 'a', '2026-07-14 00:41:27', 'a', 'a', 'Diterima', NULL),
(9, 8, 3, 'a', '2026-07-14 00:45:56', 'a', 'a', 'Ditolak', NULL),
(10, 5, 6, 'Patah', '2026-07-15 09:27:39', 'http://localhost/SIMAT/transaksi/pengaduan_kerusakan_fasilitas/tambah.php', 'saya sendiri', 'Ditolak', 'Bukti tidak valid'),
(11, 8, 3, 'Patah', '2026-07-15 09:29:01', 'http://localhost/SIMAT/transaksi/pengaduan_kerusakan_fasilitas/tambah.php', 'a', 'Diterima', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `pengajar`
--

CREATE TABLE `pengajar` (
  `id_pengajar` int NOT NULL,
  `nip` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `nama_pengajar` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `email` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `no_hp` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `status_pengajar` enum('Aktif','Tidak Aktif') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT 'Aktif'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `pengajar`
--

INSERT INTO `pengajar` (`id_pengajar`, `nip`, `nama_pengajar`, `email`, `no_hp`, `status_pengajar`) VALUES
(1, 'PGR001', 'Budi Santoso', 'pengajar@simat.test', '081200000001', 'Aktif'),
(2, 'PGR002', 'Rina Anggraini fgfyyt', 'pictatib@simat.test', '081200000002', 'Aktif'),
(3, 'PGR003', 'Dimas Pratama', 'picaset@simat.test', '081200000003', 'Aktif'),
(4, 'PGR004', 'Siti Rahma', 'pickemahasiswaan', '081200000004', 'Aktif'),
(5, '347564576', 'Andi Wijaya', 'kaprodi@simat.test', '081200000005', 'Aktif'),
(6, '00099787', 'poles', 'anjingcepat@gmail.com', '09876543433', 'Tidak Aktif'),
(7, '03485743', 'Nadya E-Learning', 'bodat@hewan.com', '082365479873', 'Tidak Aktif'),
(8, '097764578', 'Irsyad', 'irsyad@gmail.com', '1', 'Tidak Aktif'),
(10, '1', 'a', 'fahri@gmail.com', '081234567890', 'Aktif');


-- --------------------------------------------------------

--
-- Table structure for table `pengajuan_jam_plus`
--

CREATE TABLE `pengajuan_jam_plus` (
  `id_pengajuan_jam_plus` int NOT NULL,
  `id_kegiatan` int DEFAULT NULL,
  `jumlah_jam_plus` decimal(6,1) NOT NULL,
  `jenis_jam` enum('Murni','Kompensasi') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `sumber_jam` enum('Prodi','Luar') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `tanggal_pengajuan` datetime NOT NULL,
  `deskripsi_pekerjaan` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
  `nama_pemberi` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `dokumen_url` varchar(2048) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `status_pengajuan` enum('Menunggu Verifikasi','Disetujui','Ditolak') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT 'Menunggu Verifikasi',
  `alasan_penolakan` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `pengajuan_jam_plus`
--

INSERT INTO `pengajuan_jam_plus` (`id_pengajuan_jam_plus`, `id_kegiatan`, `jumlah_jam_plus`, `jenis_jam`, `sumber_jam`, `tanggal_pengajuan`, `deskripsi_pekerjaan`, `nama_pemberi`, `dokumen_url`, `status_pengajuan`, `alasan_penolakan`) VALUES
(1, 1, '100.0', 'Murni', 'Prodi', '2026-06-25 23:03:13', 'Olahraga', 'Fahri', 'abc', 'Disetujui', NULL),
(2, 1, '50.0', 'Kompensasi', 'Luar', '2026-06-25 23:55:15', 'Menyapu', 'Agoy', 'abc', 'Disetujui', NULL),
(3, 1, '100.0', 'Murni', 'Prodi', '2026-06-25 23:55:35', 'Mengepel', 'Agoy', 'abc', 'Ditolak', NULL),
(4, NULL, '100.0', 'Kompensasi', 'Prodi', '2026-07-02 09:06:26', 'Pulang', 'Adit', 'abc', 'Menunggu Verifikasi', NULL),
(5, 2, '90.0', 'Murni', 'Luar', '2026-07-02 09:07:26', 'a', 'Fahri', 'a', 'Menunggu Verifikasi', NULL),
(6, NULL, '1.0', 'Murni', 'Prodi', '2026-07-02 09:13:53', 'aa', 'Agoy', 'a', 'Menunggu Verifikasi', NULL),
(7, NULL, '50.0', 'Murni', 'Prodi', '2026-07-03 13:32:05', 'abc', 'Rafi', 'abc', 'Menunggu Verifikasi', NULL),
(8, NULL, '20.0', 'Murni', 'Prodi', '2026-07-03 14:47:18', 'Panitia', 'Yoga', 'https://www.bing.com/search?pglt=299&q=apa&cvid=d715390a2ba542ac8f692dee3df6f0fe&gs_lcrp=EgRlZGdlKgYIABBFGDkyBggAEEUYOTIGCAEQRRg80gEHNjU2ajBqN6gCALACAA&FORM=ANNTA1&PC=U531', 'Disetujui', NULL),
(9, NULL, '10.0', 'Murni', 'Prodi', '2026-07-11 18:15:33', 'a', 'Fahri', 'a', 'Menunggu Verifikasi', NULL),
(10, NULL, '10.0', 'Kompensasi', 'Prodi', '2026-07-11 18:16:51', 'a', 'a', 'a', 'Disetujui', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `pengguna`
--

CREATE TABLE `pengguna` (
  `id_pengguna` int NOT NULL,
  `id_mahasiswa` int DEFAULT NULL,
  `id_pengajar` int DEFAULT NULL,
  `username` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `password` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `role` enum('Mahasiswa','Pengajar','PIC Tata Tertib','PIC Aset Fasilitas','PIC Kemahasiswaan','Kepala Prodi') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `status_akun` enum('Aktif','Tidak Aktif') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT 'Aktif',
  `id_mahasiswa_aktif` int GENERATED ALWAYS AS ((case when (`status_akun` = 'Aktif') then `id_mahasiswa` else NULL end)) STORED,
  `id_pengajar_aktif` int GENERATED ALWAYS AS ((case when (`status_akun` = 'Aktif') then `id_pengajar` else NULL end)) STORED
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `pengguna`
--

INSERT INTO `pengguna` (`id_pengguna`, `id_mahasiswa`, `id_pengajar`, `username`, `password`, `role`, `status_akun`) VALUES
(1, 1, NULL, 'mahasiswa@simat.net', '$2y$12$.tZTBJwnqST3RlSHTkn8uu3gBFmSquwqvckHGPGlCSjj9PXSOLeaq', 'Mahasiswa', 'Tidak Aktif'),
(2, NULL, 1, 'pengajar@simat.test', '$2y$12$VS8SLfM4BVvP9qiQ89yzWuJD8Akl2r4jzF/0za08ZATzRmUHKJT26', 'Pengajar', 'Aktif'),
(3, NULL, 2, 'pictatib@simat.test', '$2y$10$1SpgJ5GlEIs.D7/QVt86MuW7/n.6xLkPj/DtkdAuafvTMW6/UeWNe', 'PIC Tata Tertib', 'Aktif'),
(4, NULL, 3, 'picaset@simat.test', '$2y$10$C55.aKZtDpQH1mx.8p1qk.Hu7gEgHLyX72yH5GKNRLHIRCLR.a7jW', 'PIC Aset Fasilitas', 'Aktif'),
(5, NULL, 4, 'pickemahasiswaan', '$2y$12$VS8SLfM4BVvP9qiQ89yzWuJD8Akl2r4jzF/0za08ZATzRmUHKJT26', 'PIC Kemahasiswaan', 'Aktif'),
(6, NULL, 5, 'kaprodi@simat.test', '$2y$10$a8/NU9DJRi8u7i.mVHKO.uNyaCizHBbkTd7a0wVWHkVk46a2dxTXG', 'Kepala Prodi', 'Aktif'),
(7, 1, NULL, 'yogaenjoy', '$2y$12$VS8SLfM4BVvP9qiQ89yzWuJD8Akl2r4jzF/0za08ZATzRmUHKJT26', 'Mahasiswa', 'Aktif'),
(8, NULL, 7, 'bodat', '$2y$12$nys.J8WPpORz7CTTRFUJye1JdwwkZznlsptDqp5yay/wmeYhuOWy2', 'Pengajar', 'Tidak Aktif'),
(9, 5, NULL, 'mika', '$2y$10$NzVA7dCQ19TJM5e7Iaju2O5vmkEk8dqkV7IGNhs135I2WV5y3GWZi', 'Mahasiswa', 'Aktif'),
(10, 2, NULL, 'Fahri', '$2y$12$9swwkylUuRvEZs1pvCh/oubUe0FPWJP49/J/XxMQZp61VHwlgBOlC', 'Mahasiswa', 'Aktif'),
(11, 6, NULL, 'ridzal', '$2y$12$VS8SLfM4BVvP9qiQ89yzWuJD8Akl2r4jzF/0za08ZATzRmUHKJT26', 'Mahasiswa', 'Tidak Aktif'),
(12, 10, NULL, 'adit', '$2y$12$VS8SLfM4BVvP9qiQ89yzWuJD8Akl2r4jzF/0za08ZATzRmUHKJT26', 'Mahasiswa', 'Aktif'),
(13, 8, NULL, 'daffa', '$2y$12$VS8SLfM4BVvP9qiQ89yzWuJD8Akl2r4jzF/0za08ZATzRmUHKJT26', 'Mahasiswa', 'Aktif'),
(14, 7, NULL, 'mazt', '$2y$12$VS8SLfM4BVvP9qiQ89yzWuJD8Akl2r4jzF/0za08ZATzRmUHKJT26', 'Mahasiswa', 'Aktif'),
(15, 3, NULL, 'nabilah', '$2y$12$VS8SLfM4BVvP9qiQ89yzWuJD8Akl2r4jzF/0za08ZATzRmUHKJT26', 'Mahasiswa', 'Aktif'),
(16, 9, NULL, 'rijal', '$2y$12$VS8SLfM4BVvP9qiQ89yzWuJD8Akl2r4jzF/0za08ZATzRmUHKJT26', 'Mahasiswa', 'Aktif'),
(17, 12, NULL, 'irsyad', '$2y$12$VS8SLfM4BVvP9qiQ89yzWuJD8Akl2r4jzF/0za08ZATzRmUHKJT26', 'Mahasiswa', 'Aktif'),
(18, 11, NULL, 'jo', '$2y$12$VS8SLfM4BVvP9qiQ89yzWuJD8Akl2r4jzF/0za08ZATzRmUHKJT26', 'Mahasiswa', 'Aktif'),
(19, 13, NULL, 'haikal', '$2y$12$VS8SLfM4BVvP9qiQ89yzWuJD8Akl2r4jzF/0za08ZATzRmUHKJT26', 'Mahasiswa', 'Aktif');

-- --------------------------------------------------------

--
-- Table structure for table `periode_akademik`
--

CREATE TABLE `periode_akademik` (
  `id_periode_akademik` int NOT NULL,
  `tahun_akademik` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `semester` enum('Ganjil','Genap') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `tanggal_mulai` date NOT NULL,
  `tanggal_selesai` date NOT NULL,
  `status_periode` enum('Aktif','Tidak Aktif') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT 'Aktif',
  `kunci_periode_aktif` tinyint GENERATED ALWAYS AS ((case when (`status_periode` = 'Aktif') then 1 else NULL end)) STORED
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `periode_akademik`
--

INSERT INTO `periode_akademik` (`id_periode_akademik`, `tahun_akademik`, `semester`, `tanggal_mulai`, `tanggal_selesai`, `status_periode`) VALUES
(1, '2025/2026', 'Genap', '2026-02-01', '2026-07-31', 'Aktif'),
(3, '2026/2027', 'Ganjil', '2026-08-24', '2027-02-15', 'Aktif');


-- --------------------------------------------------------

--

-- --------------------------------------------------------

-- Indexes for dumped tables
--

--
-- Indexes for table `bursa_jobdesc`
--
ALTER TABLE `bursa_jobdesc`
  ADD PRIMARY KEY (`id_bursa_jobdesc`);

--
-- Indexes for table `detail_fasilitas_pada_kelas`
--
ALTER TABLE `detail_fasilitas_pada_kelas`
  ADD PRIMARY KEY (`id_detail_fasilitas_pada_kelas`),
  ADD UNIQUE KEY `uq_fasilitas_pada_kelas` (`id_kelas`,`id_fasilitas`),
  ADD KEY `fk_detail_fasilitas_kelas` (`id_kelas`),
  ADD KEY `fk_detail_fasilitas_fasilitas` (`id_fasilitas`);

--
-- Indexes for table `detail_kelas_pada_mata_kuliah`
--
ALTER TABLE `detail_kelas_pada_mata_kuliah`
  ADD PRIMARY KEY (`id_detail_kelas_pada_mata_kuliah`),
  ADD UNIQUE KEY `uq_kelas_mata_kuliah` (`id_kelas`,`id_mata_kuliah`),
  ADD KEY `fk_detail_kelas_mk_mk` (`id_mata_kuliah`),
  ADD KEY `fk_detail_kelas_mk_kelas` (`id_kelas`);

--
-- Indexes for table `detail_pengguna_pada_bursa_jobdesc`
--
ALTER TABLE `detail_pengguna_pada_bursa_jobdesc`
  ADD PRIMARY KEY (`id_detail_pengguna_pada_bursa_jobdesc`),
  ADD UNIQUE KEY `uq_bursa_pengguna_peran` (`id_bursa_jobdesc`,`id_pengguna`,`peran_pengguna`),
  ADD KEY `fk_detail_pengguna_bursa` (`id_bursa_jobdesc`),
  ADD KEY `fk_detail_bursa_pengguna` (`id_pengguna`),
  ADD KEY `idx_laporan_bursa_pemberi` (`peran_pengguna`,`id_pengguna`,`id_bursa_jobdesc`);

--
-- Indexes for table `detail_pengguna_pada_pemberian_jam_minus`
--
ALTER TABLE `detail_pengguna_pada_pemberian_jam_minus`
  ADD PRIMARY KEY (`id_detail_pengguna_pada_pemberian_jam_minus`),
  ADD UNIQUE KEY `uq_pjm_satu_peran` (`id_pemberian_jam_minus`,`peran_pengguna`),
  ADD KEY `fk_detail_pengguna_jam_minus` (`id_pemberian_jam_minus`),
  ADD KEY `fk_detail_jam_minus_pengguna` (`id_pengguna`);

--
-- Indexes for table `detail_pengguna_pada_pengaduan_kerusakan_fasilitas`
--
ALTER TABLE `detail_pengguna_pada_pengaduan_kerusakan_fasilitas`
  ADD PRIMARY KEY (`id_detail_pengguna_pada_pengaduan_kerusakan_fasilitas`),
  ADD UNIQUE KEY `uq_pengaduan_satu_peran` (`id_pengaduan_kerusakan_fasilitas`,`peran_pengguna`),
  ADD KEY `fk_detail_pengguna_pengaduan` (`id_pengaduan_kerusakan_fasilitas`),
  ADD KEY `fk_detail_pengaduan_pengguna` (`id_pengguna`),
  ADD KEY `idx_laporan_pengaduan_pelapor` (`peran_pengguna`,`id_pengaduan_kerusakan_fasilitas`,`id_pengguna`);

--
-- Indexes for table `detail_pengguna_pada_pengajuan_jam_plus`
--
ALTER TABLE `detail_pengguna_pada_pengajuan_jam_plus`
  ADD PRIMARY KEY (`id_detail_pengguna_pada_pengajuan_jam_plus`),
  ADD UNIQUE KEY `uq_pengajuan_satu_peran` (`id_pengajuan_jam_plus`,`peran_pengguna`),
  ADD KEY `fk_detail_pengguna_pengajuan` (`id_pengajuan_jam_plus`),
  ADD KEY `fk_detail_pengajuan_pengguna` (`id_pengguna`);

--
-- Indexes for table `fasilitas`
--
ALTER TABLE `fasilitas`
  ADD PRIMARY KEY (`id_fasilitas`),
  ADD UNIQUE KEY `uq_fasilitas_nama_aktif` (`nama_fasilitas_aktif`);

--
-- Indexes for table `kegiatan`
--
ALTER TABLE `kegiatan`
  ADD PRIMARY KEY (`id_kegiatan`),
  ADD UNIQUE KEY `uq_kegiatan_aktif` (`kunci_kegiatan_aktif`);

--
-- Indexes for table `kelas`
--
ALTER TABLE `kelas`
  ADD PRIMARY KEY (`id_kelas`),
  ADD UNIQUE KEY `uq_kelas_nama_aktif` (`nama_kelas_aktif`);

--
-- Indexes for table `mahasiswa`
--
ALTER TABLE `mahasiswa`
  ADD PRIMARY KEY (`id_mahasiswa`),
  ADD UNIQUE KEY `nim` (`nim`),
  ADD KEY `fk_mahasiswa_kelas` (`id_kelas`),
  ADD KEY `fk_mahasiswa_periode` (`id_periode_akademik`);

--
-- Indexes for table `mata_kuliah`
--
ALTER TABLE `mata_kuliah`
  ADD PRIMARY KEY (`id_matakuliah`),
  ADD UNIQUE KEY `uq_mata_kuliah_id` (`id_matakuliah`),
  ADD UNIQUE KEY `uq_kode_mata_kuliah` (`kode_mata_kuliah`);

--
-- Indexes for table `pemberian_jam_minus`
--
ALTER TABLE `pemberian_jam_minus`
  ADD PRIMARY KEY (`id_pemberian_jam_minus`),
  ADD KEY `idx_pjm_kategori` (`kategori_pelanggaran`),
  ADD KEY `idx_pjm_detail_kelas_mata_kuliah` (`id_detail_kelas_pada_mata_kuliah`),
  ADD KEY `idx_pjm_fasilitas` (`id_fasilitas`),
  ADD KEY `idx_pjm_tanggal` (`tanggal_pemberian`);

--
-- Indexes for table `pengaduan_kerusakan_fasilitas`
--
ALTER TABLE `pengaduan_kerusakan_fasilitas`
  ADD PRIMARY KEY (`id_pengaduan_kerusakan_fasilitas`),
  ADD KEY `fk_pengaduan_fasilitas` (`id_fasilitas`),
  ADD KEY `fk_pengaduan_detail_fasilitas_kelas` (`id_detail_fasilitas_pada_kelas`);

--
-- Indexes for table `pengajar`
--
ALTER TABLE `pengajar`
  ADD PRIMARY KEY (`id_pengajar`),
  ADD UNIQUE KEY `nip` (`nip`);

--
-- Indexes for table `pengajuan_jam_plus`
--
ALTER TABLE `pengajuan_jam_plus`
  ADD PRIMARY KEY (`id_pengajuan_jam_plus`),
  ADD KEY `fk_pengajuan_jam_plus_kegiatan` (`id_kegiatan`);

--
-- Indexes for table `pengguna`
--
ALTER TABLE `pengguna`
  ADD PRIMARY KEY (`id_pengguna`),
  ADD UNIQUE KEY `username` (`username`),
  ADD UNIQUE KEY `uq_pengguna_mahasiswa_aktif` (`id_mahasiswa_aktif`),
  ADD UNIQUE KEY `uq_pengguna_pengajar_aktif` (`id_pengajar_aktif`),
  ADD KEY `fk_pengguna_mahasiswa` (`id_mahasiswa`),
  ADD KEY `fk_pengguna_pengajar` (`id_pengajar`);

--
-- Indexes for table `periode_akademik`
--
ALTER TABLE `periode_akademik`
  ADD PRIMARY KEY (`id_periode_akademik`),
  ADD UNIQUE KEY `uq_periode_tahun_semester` (`tahun_akademik`,`semester`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `bursa_jobdesc`
--
ALTER TABLE `bursa_jobdesc`
  MODIFY `id_bursa_jobdesc` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `detail_fasilitas_pada_kelas`
--
ALTER TABLE `detail_fasilitas_pada_kelas`
  MODIFY `id_detail_fasilitas_pada_kelas` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT for table `detail_kelas_pada_mata_kuliah`
--
ALTER TABLE `detail_kelas_pada_mata_kuliah`
  MODIFY `id_detail_kelas_pada_mata_kuliah` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `detail_pengguna_pada_bursa_jobdesc`
--
ALTER TABLE `detail_pengguna_pada_bursa_jobdesc`
  MODIFY `id_detail_pengguna_pada_bursa_jobdesc` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=31;

--
-- AUTO_INCREMENT for table `detail_pengguna_pada_pemberian_jam_minus`
--
ALTER TABLE `detail_pengguna_pada_pemberian_jam_minus`
  MODIFY `id_detail_pengguna_pada_pemberian_jam_minus` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- AUTO_INCREMENT for table `detail_pengguna_pada_pengaduan_kerusakan_fasilitas`
--
ALTER TABLE `detail_pengguna_pada_pengaduan_kerusakan_fasilitas`
  MODIFY `id_detail_pengguna_pada_pengaduan_kerusakan_fasilitas` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=24;

--
-- AUTO_INCREMENT for table `detail_pengguna_pada_pengajuan_jam_plus`
--
ALTER TABLE `detail_pengguna_pada_pengajuan_jam_plus`
  MODIFY `id_detail_pengguna_pada_pengajuan_jam_plus` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT for table `fasilitas`
--
ALTER TABLE `fasilitas`
  MODIFY `id_fasilitas` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `kegiatan`
--
ALTER TABLE `kegiatan`
  MODIFY `id_kegiatan` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `kelas`
--
ALTER TABLE `kelas`
  MODIFY `id_kelas` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `mahasiswa`
--
ALTER TABLE `mahasiswa`
  MODIFY `id_mahasiswa` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT for table `mata_kuliah`
--
ALTER TABLE `mata_kuliah`
  MODIFY `id_matakuliah` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `pemberian_jam_minus`
--
ALTER TABLE `pemberian_jam_minus`
  MODIFY `id_pemberian_jam_minus` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `pengaduan_kerusakan_fasilitas`
--
ALTER TABLE `pengaduan_kerusakan_fasilitas`
  MODIFY `id_pengaduan_kerusakan_fasilitas` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT for table `pengajar`
--
ALTER TABLE `pengajar`
  MODIFY `id_pengajar` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `pengajuan_jam_plus`
--
ALTER TABLE `pengajuan_jam_plus`
  MODIFY `id_pengajuan_jam_plus` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `pengguna`
--
ALTER TABLE `pengguna`
  MODIFY `id_pengguna` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT for table `periode_akademik`
--
ALTER TABLE `periode_akademik`
  MODIFY `id_periode_akademik` int NOT NULL AUTO_INCREMENT;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `detail_fasilitas_pada_kelas`
--
ALTER TABLE `detail_fasilitas_pada_kelas`
  ADD CONSTRAINT `fk_detail_fasilitas_fasilitas` FOREIGN KEY (`id_fasilitas`) REFERENCES `fasilitas` (`id_fasilitas`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_detail_fasilitas_kelas` FOREIGN KEY (`id_kelas`) REFERENCES `kelas` (`id_kelas`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `detail_kelas_pada_mata_kuliah`
--
ALTER TABLE `detail_kelas_pada_mata_kuliah`
  ADD CONSTRAINT `fk_detail_kelas_mk_kelas` FOREIGN KEY (`id_kelas`) REFERENCES `kelas` (`id_kelas`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_detail_kelas_mk_mk` FOREIGN KEY (`id_mata_kuliah`) REFERENCES `mata_kuliah` (`id_matakuliah`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `detail_pengguna_pada_bursa_jobdesc`
--
ALTER TABLE `detail_pengguna_pada_bursa_jobdesc`
  ADD CONSTRAINT `fk_detail_bursa_pengguna` FOREIGN KEY (`id_pengguna`) REFERENCES `pengguna` (`id_pengguna`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_detail_pengguna_bursa` FOREIGN KEY (`id_bursa_jobdesc`) REFERENCES `bursa_jobdesc` (`id_bursa_jobdesc`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `detail_pengguna_pada_pemberian_jam_minus`
--
ALTER TABLE `detail_pengguna_pada_pemberian_jam_minus`
  ADD CONSTRAINT `fk_detail_jam_minus_pengguna` FOREIGN KEY (`id_pengguna`) REFERENCES `pengguna` (`id_pengguna`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_detail_pengguna_jam_minus` FOREIGN KEY (`id_pemberian_jam_minus`) REFERENCES `pemberian_jam_minus` (`id_pemberian_jam_minus`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `detail_pengguna_pada_pengaduan_kerusakan_fasilitas`
--
ALTER TABLE `detail_pengguna_pada_pengaduan_kerusakan_fasilitas`
  ADD CONSTRAINT `fk_detail_pengaduan_pengguna` FOREIGN KEY (`id_pengguna`) REFERENCES `pengguna` (`id_pengguna`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_detail_pengguna_pengaduan` FOREIGN KEY (`id_pengaduan_kerusakan_fasilitas`) REFERENCES `pengaduan_kerusakan_fasilitas` (`id_pengaduan_kerusakan_fasilitas`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `detail_pengguna_pada_pengajuan_jam_plus`
--
ALTER TABLE `detail_pengguna_pada_pengajuan_jam_plus`
  ADD CONSTRAINT `fk_detail_pengajuan_pengguna` FOREIGN KEY (`id_pengguna`) REFERENCES `pengguna` (`id_pengguna`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_detail_pengguna_pengajuan` FOREIGN KEY (`id_pengajuan_jam_plus`) REFERENCES `pengajuan_jam_plus` (`id_pengajuan_jam_plus`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `mahasiswa`
--
ALTER TABLE `mahasiswa`
  ADD CONSTRAINT `fk_mahasiswa_kelas` FOREIGN KEY (`id_kelas`) REFERENCES `kelas` (`id_kelas`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_mahasiswa_periode` FOREIGN KEY (`id_periode_akademik`) REFERENCES `periode_akademik` (`id_periode_akademik`) ON UPDATE CASCADE;

--
-- Constraints for table `pemberian_jam_minus`
--
ALTER TABLE `pemberian_jam_minus`
  ADD CONSTRAINT `fk_pjm_detail_kelas_mata_kuliah` FOREIGN KEY (`id_detail_kelas_pada_mata_kuliah`) REFERENCES `detail_kelas_pada_mata_kuliah` (`id_detail_kelas_pada_mata_kuliah`) ON DELETE RESTRICT ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_pjm_fasilitas` FOREIGN KEY (`id_fasilitas`) REFERENCES `fasilitas` (`id_fasilitas`) ON DELETE RESTRICT ON UPDATE CASCADE;

--
-- Constraints for table `pengaduan_kerusakan_fasilitas`
--
ALTER TABLE `pengaduan_kerusakan_fasilitas`
  ADD CONSTRAINT `fk_pengaduan_detail_fasilitas_kelas` FOREIGN KEY (`id_detail_fasilitas_pada_kelas`) REFERENCES `detail_fasilitas_pada_kelas` (`id_detail_fasilitas_pada_kelas`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_pengaduan_fasilitas` FOREIGN KEY (`id_fasilitas`) REFERENCES `fasilitas` (`id_fasilitas`) ON UPDATE CASCADE;

--
-- Constraints for table `pengajuan_jam_plus`
--
ALTER TABLE `pengajuan_jam_plus`
  ADD CONSTRAINT `fk_pengajuan_jam_plus_kegiatan` FOREIGN KEY (`id_kegiatan`) REFERENCES `kegiatan` (`id_kegiatan`) ON UPDATE CASCADE;

--
-- Constraints for table `pengguna`
--
ALTER TABLE `pengguna`
  ADD CONSTRAINT `fk_pengguna_mahasiswa` FOREIGN KEY (`id_mahasiswa`) REFERENCES `mahasiswa` (`id_mahasiswa`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `fk_pengguna_pengajar` FOREIGN KEY (`id_pengajar`) REFERENCES `pengajar` (`id_pengajar`) ON DELETE RESTRICT ON UPDATE RESTRICT;

-- --------------------------------------------------------

--
-- Stored functions
--
DELIMITER $$
DROP FUNCTION IF EXISTS `ufn_cari_id_kelas_di_table_detail_fasilitas_pada_kelas`$$
CREATE FUNCTION `ufn_cari_id_kelas_di_table_detail_fasilitas_pada_kelas` (`p_id_pengguna` INT) RETURNS INT READS SQL DATA BEGIN
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

DROP FUNCTION IF EXISTS `ufn_hitung_sisa_jam_plus_kompensasi_mahasiswa`$$
CREATE FUNCTION `ufn_hitung_sisa_jam_plus_kompensasi_mahasiswa` (`p_id_mahasiswa` INT) RETURNS DECIMAL(10,1) DETERMINISTIC READS SQL DATA BEGIN
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

DROP FUNCTION IF EXISTS `ufn_hitung_total_jam_kompensasi_mahasiswa`$$
CREATE FUNCTION `ufn_hitung_total_jam_kompensasi_mahasiswa` (`p_id_mahasiswa` INT) RETURNS DECIMAL(10,1) DETERMINISTIC READS SQL DATA BEGIN
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

DROP FUNCTION IF EXISTS `ufn_hitung_total_jam_murni_mahasiswa`$$
CREATE FUNCTION `ufn_hitung_total_jam_murni_mahasiswa` (`p_id_mahasiswa` INT) RETURNS DECIMAL(10,1) DETERMINISTIC READS SQL DATA BEGIN
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

DROP FUNCTION IF EXISTS `ufn_total_jam_minus_mahasiswa`$$
CREATE FUNCTION `ufn_total_jam_minus_mahasiswa` (`p_id_mahasiswa` INT) RETURNS DECIMAL(10,1) READS SQL DATA BEGIN
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

DROP FUNCTION IF EXISTS `ufn_hitung_total_jam_mahasiswa`$$
CREATE FUNCTION `ufn_hitung_total_jam_mahasiswa` (`p_id_mahasiswa` INT) RETURNS DECIMAL(10,1) DETERMINISTIC READS SQL DATA BEGIN
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

DELIMITER ;

-- --------------------------------------------------------

--
-- Stored procedures
--
DELIMITER $$
DROP PROCEDURE IF EXISTS `usp_cek_kegiatan_aktif`$$
CREATE PROCEDURE `usp_cek_kegiatan_aktif` (IN `p_nama_kegiatan` VARCHAR(50), IN `p_penyelenggara` VARCHAR(20), IN `p_tanggal_kegiatan` DATE, IN `p_id_kegiatan_abaikan` INT)   BEGIN SELECT COUNT(*) AS jumlah FROM kegiatan WHERE status_kegiatan='Aktif' AND UPPER(TRIM(nama_kegiatan))=UPPER(TRIM(p_nama_kegiatan)) AND penyelenggara=p_penyelenggara AND tanggal_kegiatan <=> p_tanggal_kegiatan AND (p_id_kegiatan_abaikan IS NULL OR id_kegiatan<>p_id_kegiatan_abaikan); END$$

DROP PROCEDURE IF EXISTS `usp_cek_nama_fasilitas_aktif`$$
CREATE PROCEDURE `usp_cek_nama_fasilitas_aktif` (IN `p_nama_fasilitas` VARCHAR(50), IN `p_id_fasilitas_abaikan` INT)   BEGIN SELECT COUNT(*) AS jumlah FROM fasilitas WHERE status_fasilitas='Aktif' AND UPPER(TRIM(nama_fasilitas))=UPPER(TRIM(p_nama_fasilitas)) AND (p_id_fasilitas_abaikan IS NULL OR id_fasilitas<>p_id_fasilitas_abaikan); END$$

DROP PROCEDURE IF EXISTS `usp_cek_nama_kelas_aktif`$$
CREATE PROCEDURE `usp_cek_nama_kelas_aktif` (IN `p_nama_kelas` VARCHAR(5), IN `p_id_kelas_abaikan` INT)   BEGIN
 SELECT COUNT(*) AS jumlah FROM kelas WHERE status_kelas='Aktif' AND UPPER(TRIM(nama_kelas))=UPPER(TRIM(p_nama_kelas)) AND (p_id_kelas_abaikan IS NULL OR id_kelas<>p_id_kelas_abaikan);
END$$

DROP PROCEDURE IF EXISTS `usp_cek_nim_mahasiswa`$$
CREATE PROCEDURE `usp_cek_nim_mahasiswa` (IN `p_nim` VARCHAR(20), IN `p_id_mahasiswa_abaikan` INT)   BEGIN SELECT COUNT(*) AS jumlah FROM mahasiswa WHERE nim=p_nim AND (p_id_mahasiswa_abaikan IS NULL OR id_mahasiswa<>p_id_mahasiswa_abaikan); END$$

DROP PROCEDURE IF EXISTS `usp_cek_nip_pengajar`$$
CREATE PROCEDURE `usp_cek_nip_pengajar` (IN `p_nip` VARCHAR(20), IN `p_id_pengajar_abaikan` INT)   BEGIN SELECT COUNT(*) AS jumlah FROM pengajar WHERE nip=p_nip AND (p_id_pengajar_abaikan IS NULL OR id_pengajar<>p_id_pengajar_abaikan); END$$

DROP PROCEDURE IF EXISTS `usp_cek_periode_akademik`$$
CREATE PROCEDURE `usp_cek_periode_akademik` (IN `p_tahun` VARCHAR(10), IN `p_semester` VARCHAR(10), IN `p_id_abaikan` INT)   BEGIN SELECT COUNT(*) AS jumlah FROM periode_akademik WHERE tahun_akademik=p_tahun AND semester=p_semester AND (p_id_abaikan IS NULL OR id_periode_akademik<>p_id_abaikan); END$$

DROP PROCEDURE IF EXISTS `usp_cek_username_pengguna`$$
CREATE PROCEDURE `usp_cek_username_pengguna` (IN `p_username` VARCHAR(20), IN `p_id_pengguna_abaikan` INT)   BEGIN SELECT COUNT(*) AS jumlah FROM pengguna WHERE username=p_username AND (p_id_pengguna_abaikan IS NULL OR id_pengguna<>p_id_pengguna_abaikan); END$$

DROP PROCEDURE IF EXISTS `usp_daftar_bursa_jobdesc`$$
CREATE PROCEDURE `usp_daftar_bursa_jobdesc` (IN `p_id_bursa_jobdesc` INT, IN `p_id_pengguna` INT)   BEGIN
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

DROP PROCEDURE IF EXISTS `usp_dashboard_ringkasan`$$
CREATE PROCEDURE `usp_dashboard_ringkasan` (IN `p_id_pengguna` INT)   BEGIN
    SELECT
        (SELECT COUNT(*) FROM pengguna WHERE status_akun='Aktif') AS total_pengguna,
        (SELECT COUNT(*) FROM mahasiswa WHERE status_mahasiswa='Aktif') AS total_mahasiswa,
        (SELECT COUNT(*) FROM pengajar WHERE status_pengajar='Aktif') AS total_pengajar,
        (SELECT COUNT(*) FROM fasilitas WHERE status_fasilitas='Aktif') AS total_fasilitas,
        (SELECT COUNT(*) FROM kelas WHERE status_kelas='Aktif') AS total_kelas,
        (SELECT COUNT(*) FROM pengaduan_kerusakan_fasilitas) AS total_pengaduan,
        (SELECT COUNT(*) FROM pengaduan_kerusakan_fasilitas WHERE status_pengaduan='Menunggu Verifikasi') AS pengaduan_menunggu,
        (SELECT COUNT(*) FROM detail_fasilitas_pada_kelas WHERE status_detail_fasilitas_pada_kelas='Rusak') AS fasilitas_rusak,
        (SELECT COUNT(DISTINCT d.id_bursa_jobdesc) FROM detail_pengguna_pada_bursa_jobdesc d WHERE d.id_pengguna=p_id_pengguna AND d.peran_pengguna='Pemberi') AS jobdesc_saya,
        (SELECT COUNT(*) FROM bursa_jobdesc WHERE status_jobdesc='Dibuka') AS jobdesc_tersedia,
        (SELECT COUNT(DISTINCT d.id_bursa_jobdesc) FROM detail_pengguna_pada_bursa_jobdesc d WHERE d.id_pengguna=p_id_pengguna AND d.peran_pengguna='Penerima') AS jobdesc_diambil,
        (SELECT COUNT(DISTINCT d.id_pengaduan_kerusakan_fasilitas) FROM detail_pengguna_pada_pengaduan_kerusakan_fasilitas d WHERE d.id_pengguna=p_id_pengguna AND d.peran_pengguna='Pelapor') AS pengaduan_saya,
        (SELECT COUNT(DISTINCT d.id_pengaduan_kerusakan_fasilitas) FROM detail_pengguna_pada_pengaduan_kerusakan_fasilitas d JOIN pengaduan_kerusakan_fasilitas q ON q.id_pengaduan_kerusakan_fasilitas=d.id_pengaduan_kerusakan_fasilitas WHERE d.id_pengguna=p_id_pengguna AND d.peran_pengguna='Pelapor' AND q.status_pengaduan='Menunggu Verifikasi') AS pengaduan_menunggu_saya,
        (SELECT COUNT(DISTINCT d.id_pengajuan_jam_plus) FROM detail_pengguna_pada_pengajuan_jam_plus d JOIN pengajuan_jam_plus j ON j.id_pengajuan_jam_plus=d.id_pengajuan_jam_plus WHERE d.id_pengguna=p_id_pengguna AND d.peran_pengguna='Pengaju' AND j.status_pengajuan='Menunggu Verifikasi') AS jam_plus_menunggu;
END$$

DROP PROCEDURE IF EXISTS `usp_delete_pengajar_mata_kuliah_kelas`$$
CREATE PROCEDURE `usp_delete_pengajar_mata_kuliah_kelas` (IN `p_id_detail_kelas_pada_mata_kuliah` INT)   BEGIN
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

DROP PROCEDURE IF EXISTS `usp_get_peran_bursa_jobdesc`$$
CREATE PROCEDURE `usp_get_peran_bursa_jobdesc` (IN `p_id_jobdesc` INT, IN `p_id_pengguna` INT)   BEGIN
    SELECT peran_pengguna FROM detail_pengguna_pada_bursa_jobdesc
    WHERE id_bursa_jobdesc=p_id_jobdesc AND id_pengguna=p_id_pengguna LIMIT 1;
END$$

DROP PROCEDURE IF EXISTS `usp_get_total_jam_minus_mahasiswa`$$
CREATE PROCEDURE `usp_get_total_jam_minus_mahasiswa` (IN `p_id_mahasiswa` INT)   BEGIN
    SELECT ufn_total_jam_minus_mahasiswa(p_id_mahasiswa) AS total_jam_minus;
END$$

DROP PROCEDURE IF EXISTS `usp_insert_bursa_jobdesc`$$
CREATE PROCEDURE `usp_insert_bursa_jobdesc` (IN `p_id_pengguna` INT, IN `p_deskripsi_jobdesc` TEXT, IN `p_penerima_jobdesc` VARCHAR(50), IN `p_jam_plus` DECIMAL(6,2), IN `p_tanggal_pemberian_jobdesc` DATETIME, IN `p_jumlah_mahasiswa_diperlukan` INT)   BEGIN
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

DROP PROCEDURE IF EXISTS `usp_insert_detail_fasilitas_pada_kelas`$$
CREATE PROCEDURE `usp_insert_detail_fasilitas_pada_kelas` (IN `p_id_kelas` INT, IN `p_id_fasilitas` INT)   BEGIN
    IF NOT EXISTS (SELECT 1 FROM kelas WHERE id_kelas = p_id_kelas AND status_kelas = 'Aktif') THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Kelas tidak ditemukan atau tidak aktif'; END IF;
    IF NOT EXISTS (SELECT 1 FROM fasilitas WHERE id_fasilitas = p_id_fasilitas AND status_fasilitas = 'Aktif') THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Fasilitas tidak ditemukan atau tidak aktif'; END IF;
    IF EXISTS (SELECT 1 FROM detail_fasilitas_pada_kelas WHERE id_kelas = p_id_kelas AND id_fasilitas = p_id_fasilitas) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Fasilitas sudah terhubung ke kelas tersebut'; END IF;
    INSERT INTO detail_fasilitas_pada_kelas (id_kelas, id_fasilitas, status_detail_fasilitas_pada_kelas) VALUES (p_id_kelas, p_id_fasilitas, 'Aktif');
    SELECT 'Data fasilitas kelas berhasil ditambahkan' AS Pesan, LAST_INSERT_ID() AS id_detail_fasilitas_pada_kelas;
END$$

DROP PROCEDURE IF EXISTS `usp_insert_detail_pengguna_pada_pengaduan_kerusakan_fasilitas`$$
CREATE PROCEDURE `usp_insert_detail_pengguna_pada_pengaduan_kerusakan_fasilitas` (IN `p_id_pengaduan_kerusakan_fasilitas` INT, IN `p_id_pengguna` INT, IN `p_peran_pengguna` VARCHAR(20))   BEGIN
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

DROP PROCEDURE IF EXISTS `usp_insert_fasilitas`$$
CREATE PROCEDURE `usp_insert_fasilitas` (IN `p_nama_fasilitas` VARCHAR(50), IN `p_harga` DECIMAL(15,2), IN `p_id_kelas_csv` TEXT)   BEGIN
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

DROP PROCEDURE IF EXISTS `usp_insert_kegiatan`$$
CREATE PROCEDURE `usp_insert_kegiatan` (IN `p_nama_kegiatan` VARCHAR(50), IN `p_penyelenggara` VARCHAR(20), IN `p_tanggal_kegiatan` DATE)   BEGIN
    SET p_nama_kegiatan=TRIM(p_nama_kegiatan);
    IF p_nama_kegiatan='' OR p_penyelenggara NOT IN ('ASTRAtech','BEM','MPM','HIMMA','UKM','Prodi') THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Data kegiatan tidak valid'; END IF;
    IF EXISTS (SELECT 1 FROM kegiatan WHERE status_kegiatan='Aktif' AND UPPER(TRIM(nama_kegiatan))=UPPER(p_nama_kegiatan) AND penyelenggara=p_penyelenggara AND tanggal_kegiatan <=> p_tanggal_kegiatan) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Kegiatan aktif dengan seluruh input yang sama sudah tersedia';
    END IF;
    INSERT INTO kegiatan (nama_kegiatan,penyelenggara,tanggal_kegiatan,status_kegiatan) VALUES (p_nama_kegiatan,p_penyelenggara,p_tanggal_kegiatan,'Aktif');
    SELECT 'Data kegiatan berhasil ditambahkan' AS Pesan,LAST_INSERT_ID() AS id_kegiatan_baru;
END$$

DROP PROCEDURE IF EXISTS `usp_insert_kelas`$$
CREATE PROCEDURE `usp_insert_kelas` (IN `p_nama_kelas` VARCHAR(5), IN `p_tingkat` VARCHAR(1))   BEGIN
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

DROP PROCEDURE IF EXISTS `usp_insert_mahasiswa`$$
CREATE PROCEDURE `usp_insert_mahasiswa` (IN `p_id_kelas` INT, IN `p_id_periode_akademik` INT, IN `p_nim` VARCHAR(20), IN `p_nama_mahasiswa` VARCHAR(50), IN `p_email` VARCHAR(50), IN `p_no_hp` VARCHAR(20))   BEGIN
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

DROP PROCEDURE IF EXISTS `usp_insert_mata_kuliah`$$
CREATE PROCEDURE `usp_insert_mata_kuliah` (IN `p_nama` VARCHAR(100), IN `p_kode` VARCHAR(20), IN `p_sks` INT, IN `p_semester` INT)   BEGIN
 IF TRIM(p_nama)='' OR TRIM(p_kode)='' OR p_sks<=0 OR p_semester<=0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Data mata kuliah tidak valid'; END IF;
 IF EXISTS(SELECT 1 FROM mata_kuliah WHERE kode_mata_kuliah=p_kode) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Kode mata kuliah sudah digunakan'; END IF;
 INSERT INTO mata_kuliah(nama_mata_kuliah,kode_mata_kuliah,sks,semester,status_mata_kuliah) VALUES(TRIM(p_nama),TRIM(p_kode),p_sks,p_semester,'Aktif');
END$$

DROP PROCEDURE IF EXISTS `usp_insert_pemberian_jam_minus`$$
CREATE PROCEDURE `usp_insert_pemberian_jam_minus` (IN `p_id_pemberi` INT, IN `p_id_penerima` INT, IN `p_id_kelas` INT, IN `p_kategori_pelanggaran` VARCHAR(20), IN `p_id_detail_kelas_pada_mata_kuliah` INT, IN `p_keterangan_absensi` VARCHAR(10), IN `p_id_fasilitas` INT, IN `p_deskripsi_pelanggaran` TEXT, IN `p_jenis_jam_input` VARCHAR(20), IN `p_jumlah_jam_minus_input` DECIMAL(10,2))   BEGIN
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

DROP PROCEDURE IF EXISTS `usp_insert_pengaduan_kerusakan_fasilitas`$$
CREATE PROCEDURE `usp_insert_pengaduan_kerusakan_fasilitas` (IN `p_id_fasilitas` INT, IN `p_id_pengguna` INT, IN `p_deskripsi_kerusakan` TEXT, IN `p_bukti_kerusakan_url` VARCHAR(2048), IN `p_pelaku_kerusakan` VARCHAR(50))   BEGIN
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

DROP PROCEDURE IF EXISTS `usp_insert_pengajar`$$
CREATE PROCEDURE `usp_insert_pengajar` (IN `p_nip` VARCHAR(20), IN `p_nama_pengajar` VARCHAR(50), IN `p_email` VARCHAR(50), IN `p_no_hp` VARCHAR(20))   BEGIN
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

DROP PROCEDURE IF EXISTS `usp_insert_pengajar_mata_kuliah_kelas`$$
CREATE PROCEDURE `usp_insert_pengajar_mata_kuliah_kelas` (IN `p_id_kelas` INT, IN `p_id_mata_kuliah` INT)   BEGIN
    IF NOT EXISTS (SELECT 1 FROM kelas WHERE id_kelas=p_id_kelas AND status_kelas='Aktif') THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Kelas tidak ditemukan atau tidak aktif'; END IF;
    IF NOT EXISTS (SELECT 1 FROM mata_kuliah WHERE id_matakuliah=p_id_mata_kuliah AND status_mata_kuliah='Aktif') THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Mata kuliah tidak ditemukan atau tidak aktif'; END IF;
    IF EXISTS (SELECT 1 FROM detail_kelas_pada_mata_kuliah WHERE id_kelas=p_id_kelas AND id_mata_kuliah=p_id_mata_kuliah) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Mata kuliah sudah ditentukan pada kelas tersebut'; END IF;
    INSERT INTO detail_kelas_pada_mata_kuliah (id_mata_kuliah,id_kelas) VALUES (p_id_mata_kuliah,p_id_kelas);
    SELECT 'Data mata kuliah kelas berhasil ditambahkan' AS Pesan,LAST_INSERT_ID() AS id_detail_kelas_pada_mata_kuliah;
END$$

DROP PROCEDURE IF EXISTS `usp_insert_pengajuan_jam_plus`$$
CREATE PROCEDURE `usp_insert_pengajuan_jam_plus` (IN `p_id_pengguna` INT, IN `p_id_kegiatan` INT, IN `p_jumlah_jam` DECIMAL(6,2), IN `p_jenis_jam` VARCHAR(20), IN `p_sumber_jam` VARCHAR(10), IN `p_deskripsi` TEXT, IN `p_nama_pemberi` VARCHAR(50), IN `p_dokumen_url` VARCHAR(2048))   BEGIN
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

DROP PROCEDURE IF EXISTS `usp_insert_pengguna`$$
CREATE PROCEDURE `usp_insert_pengguna` (IN `p_id_mahasiswa` INT, IN `p_id_pengajar` INT, IN `p_username` VARCHAR(20), IN `p_password` VARCHAR(255), IN `p_role` VARCHAR(30))   BEGIN
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

DROP PROCEDURE IF EXISTS `usp_insert_periode_akademik`$$
CREATE PROCEDURE `usp_insert_periode_akademik` (IN `p_tahun_akademik` VARCHAR(10), IN `p_semester` VARCHAR(10), IN `p_tanggal_mulai` DATE, IN `p_tanggal_selesai` DATE)   BEGIN
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

DROP PROCEDURE IF EXISTS `usp_login_pengguna`$$
CREATE PROCEDURE `usp_login_pengguna` (IN `p_username` VARCHAR(20))   BEGIN
 SELECT p.*,m.nim,m.nama_mahasiswa,pg.nip,pg.nama_pengajar FROM pengguna p
 LEFT JOIN mahasiswa m ON p.id_mahasiswa=m.id_mahasiswa LEFT JOIN pengajar pg ON p.id_pengajar=pg.id_pengajar
 WHERE p.username=p_username AND p.status_akun='Aktif' LIMIT 1;
END$$

DROP PROCEDURE IF EXISTS `usp_pulihkan_fasilitas_kelas`$$
CREATE PROCEDURE `usp_pulihkan_fasilitas_kelas` (IN `p_id_detail_fasilitas_pada_kelas` INT, IN `p_id_fasilitas` INT)   BEGIN
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

DROP PROCEDURE IF EXISTS `usp_select_bursa_jobdesc`$$
CREATE PROCEDURE `usp_select_bursa_jobdesc` ()   BEGIN
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

DROP PROCEDURE IF EXISTS `usp_select_bursa_jobdesc_penerima_by_id`$$
CREATE PROCEDURE `usp_select_bursa_jobdesc_penerima_by_id` (IN `p_id_jobdesc` INT, IN `p_id_pengguna` INT)   BEGIN
    SELECT bj.id_bursa_jobdesc,bj.deskripsi_jobdesc,bj.jam_plus,bj.tanggal_pemberian_jobdesc,
           bj.jumlah_mahasiswa_diperlukan,bj.jumlah_mahasiswa_mengambil,bj.bukti_selesai_url,bj.status_jobdesc,dp.peran_pengguna
    FROM bursa_jobdesc bj
    JOIN detail_pengguna_pada_bursa_jobdesc dp ON bj.id_bursa_jobdesc=dp.id_bursa_jobdesc
    WHERE bj.id_bursa_jobdesc=p_id_jobdesc AND dp.id_pengguna=p_id_pengguna AND dp.peran_pengguna='Penerima'
    LIMIT 1;
END$$

DROP PROCEDURE IF EXISTS `usp_select_fasilitas`$$
CREATE PROCEDURE `usp_select_fasilitas` ()   BEGIN
    SELECT id_fasilitas, nama_fasilitas, harga, status_fasilitas, tanggal_pendataan
    FROM fasilitas WHERE status_fasilitas = 'Aktif' ORDER BY nama_fasilitas ASC;
END$$

DROP PROCEDURE IF EXISTS `usp_select_fasilitas_aktif`$$
CREATE PROCEDURE `usp_select_fasilitas_aktif` ()   BEGIN
    SELECT id_fasilitas, nama_fasilitas, harga, status_fasilitas, tanggal_pendataan
    FROM fasilitas WHERE status_fasilitas = 'Aktif' ORDER BY nama_fasilitas ASC;
END$$

DROP PROCEDURE IF EXISTS `usp_select_fasilitas_by_id`$$
CREATE PROCEDURE `usp_select_fasilitas_by_id` (IN `p_id_fasilitas` INT)   BEGIN
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

DROP PROCEDURE IF EXISTS `usp_select_fasilitas_kelas`$$
CREATE PROCEDURE `usp_select_fasilitas_kelas` ()   BEGIN
    SELECT d.id_detail_fasilitas_pada_kelas, d.id_kelas, k.nama_kelas, k.tingkat,
           d.id_fasilitas, f.nama_fasilitas, d.status_detail_fasilitas_pada_kelas
    FROM detail_fasilitas_pada_kelas d
    JOIN kelas k ON d.id_kelas = k.id_kelas
    JOIN fasilitas f ON d.id_fasilitas = f.id_fasilitas
    WHERE k.status_kelas = 'Aktif' AND f.status_fasilitas = 'Aktif'
      AND d.status_detail_fasilitas_pada_kelas IN ('Aktif','Rusak')
    ORDER BY k.tingkat, k.nama_kelas, f.nama_fasilitas;
END$$

DROP PROCEDURE IF EXISTS `usp_select_fasilitas_kelas_by_id`$$
CREATE PROCEDURE `usp_select_fasilitas_kelas_by_id` (IN `p_id_detail_fasilitas_pada_kelas` INT)   BEGIN
    SELECT d.id_detail_fasilitas_pada_kelas, d.id_kelas, k.nama_kelas, k.tingkat,
           d.id_fasilitas, f.nama_fasilitas, d.status_detail_fasilitas_pada_kelas
    FROM detail_fasilitas_pada_kelas d
    JOIN kelas k ON d.id_kelas = k.id_kelas
    JOIN fasilitas f ON d.id_fasilitas = f.id_fasilitas
    WHERE d.id_detail_fasilitas_pada_kelas = p_id_detail_fasilitas_pada_kelas
      AND d.status_detail_fasilitas_pada_kelas IN ('Aktif','Rusak') LIMIT 1;
END$$

DROP PROCEDURE IF EXISTS `usp_select_fasilitas_pengaduan_mahasiswa`$$
CREATE PROCEDURE `usp_select_fasilitas_pengaduan_mahasiswa` (IN `p_id_pengguna` INT)   BEGIN
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

DROP PROCEDURE IF EXISTS `usp_select_identitas_pengguna_tersedia`$$
CREATE PROCEDURE `usp_select_identitas_pengguna_tersedia` (IN `p_jenis` VARCHAR(20), IN `p_id_pengguna_abaikan` INT)   BEGIN
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

DROP PROCEDURE IF EXISTS `usp_select_kegiatan`$$
CREATE PROCEDURE `usp_select_kegiatan` ()   BEGIN
    SELECT id_kegiatan, nama_kegiatan, penyelenggara, tanggal_kegiatan, status_kegiatan
    FROM kegiatan WHERE status_kegiatan = 'Aktif' ORDER BY tanggal_kegiatan DESC, nama_kegiatan ASC;
END$$

DROP PROCEDURE IF EXISTS `usp_select_kegiatan_aktif`$$
CREATE PROCEDURE `usp_select_kegiatan_aktif` ()   BEGIN
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

DROP PROCEDURE IF EXISTS `usp_select_kegiatan_by_id`$$
CREATE PROCEDURE `usp_select_kegiatan_by_id` (IN `p_id_kegiatan` INT)   BEGIN
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

DROP PROCEDURE IF EXISTS `usp_select_kelas`$$
CREATE PROCEDURE `usp_select_kelas` ()   BEGIN
    SELECT id_kelas, nama_kelas, tingkat, jumlah_mahasiswa, status_kelas
    FROM kelas
    WHERE status_kelas = 'Aktif'
    ORDER BY tingkat ASC, nama_kelas ASC;
END$$

DROP PROCEDURE IF EXISTS `usp_select_kelas_aktif`$$
CREATE PROCEDURE `usp_select_kelas_aktif` ()   BEGIN
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

DROP PROCEDURE IF EXISTS `usp_select_kelas_aktif_untuk_jam_minus`$$
CREATE PROCEDURE `usp_select_kelas_aktif_untuk_jam_minus` ()   BEGIN
    SELECT DISTINCT k.id_kelas,k.nama_kelas,k.tingkat
    FROM kelas k JOIN mahasiswa m ON m.id_kelas=k.id_kelas AND m.status_mahasiswa='Aktif'
    JOIN pengguna p ON p.id_mahasiswa=m.id_mahasiswa AND p.role='Mahasiswa' AND p.status_akun='Aktif'
    WHERE k.status_kelas='Aktif' ORDER BY k.tingkat,k.nama_kelas;
END$$

DROP PROCEDURE IF EXISTS `usp_select_kelas_by_id`$$
CREATE PROCEDURE `usp_select_kelas_by_id` (IN `p_id_kelas` INT)   BEGIN
    SELECT * FROM kelas WHERE id_kelas=p_id_kelas LIMIT 1;
END$$

DROP PROCEDURE IF EXISTS `usp_select_kelas_dengan_status_fasilitas`$$
CREATE PROCEDURE `usp_select_kelas_dengan_status_fasilitas` (IN `p_id_fasilitas` INT)   BEGIN
    SELECT k.id_kelas,k.nama_kelas,k.tingkat,d.id_detail_fasilitas_pada_kelas,d.status_detail_fasilitas_pada_kelas
    FROM kelas k
    LEFT JOIN detail_fasilitas_pada_kelas d
      ON d.id_kelas=k.id_kelas AND d.id_fasilitas=p_id_fasilitas
    WHERE k.status_kelas='Aktif'
    ORDER BY k.tingkat,k.nama_kelas;
END$$

DROP PROCEDURE IF EXISTS `usp_select_laporan_bursa_jobdesc_by_role`$$
CREATE PROCEDURE `usp_select_laporan_bursa_jobdesc_by_role` (IN `p_role` VARCHAR(30))   BEGIN
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

DROP PROCEDURE IF EXISTS `usp_select_laporan_bursa_jobdesc_filter`$$
CREATE PROCEDURE `usp_select_laporan_bursa_jobdesc_filter` (IN `p_role` VARCHAR(30), IN `p_tanggal_mulai` DATE, IN `p_tanggal_selesai` DATE)   BEGIN
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

DROP PROCEDURE IF EXISTS `usp_select_laporan_pengaduan_fasilitas`$$
CREATE PROCEDURE `usp_select_laporan_pengaduan_fasilitas` ()   BEGIN
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

DROP PROCEDURE IF EXISTS `usp_select_laporan_total_jam`$$
CREATE PROCEDURE `usp_select_laporan_total_jam` (IN `p_sort` VARCHAR(30))   BEGIN
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

DROP PROCEDURE IF EXISTS `usp_select_mahasiswa`$$
CREATE PROCEDURE `usp_select_mahasiswa` ()   BEGIN
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

DROP PROCEDURE IF EXISTS `usp_select_mahasiswa_aktif`$$
CREATE PROCEDURE `usp_select_mahasiswa_aktif` ()   BEGIN
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

DROP PROCEDURE IF EXISTS `usp_select_mahasiswa_aktif_by_kelas`$$
CREATE PROCEDURE `usp_select_mahasiswa_aktif_by_kelas` (IN `p_id_kelas` INT)   BEGIN
    SELECT p.id_pengguna AS id_pengguna_mahasiswa,m.id_mahasiswa,m.nim,m.nama_mahasiswa,k.id_kelas,k.nama_kelas,k.tingkat
    FROM mahasiswa m JOIN pengguna p ON p.id_mahasiswa=m.id_mahasiswa AND p.role='Mahasiswa' AND p.status_akun='Aktif'
    JOIN kelas k ON m.id_kelas=k.id_kelas
    WHERE m.status_mahasiswa='Aktif' AND k.status_kelas='Aktif' AND k.id_kelas=p_id_kelas
    ORDER BY m.nim,m.nama_mahasiswa;
END$$

DROP PROCEDURE IF EXISTS `usp_select_mahasiswa_aktif_untuk_jam_minus`$$
CREATE PROCEDURE `usp_select_mahasiswa_aktif_untuk_jam_minus` ()   BEGIN
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

DROP PROCEDURE IF EXISTS `usp_select_mahasiswa_by_id`$$
CREATE PROCEDURE `usp_select_mahasiswa_by_id` (IN `p_id_mahasiswa` INT)   BEGIN
    SELECT * FROM mahasiswa WHERE id_mahasiswa=p_id_mahasiswa LIMIT 1;
END$$

DROP PROCEDURE IF EXISTS `usp_select_mata_kuliah_aktif`$$
CREATE PROCEDURE `usp_select_mata_kuliah_aktif` ()   BEGIN
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

DROP PROCEDURE IF EXISTS `usp_select_mata_kuliah_by_id`$$
CREATE PROCEDURE `usp_select_mata_kuliah_by_id` (IN `p_id_matakuliah` INT)   BEGIN
    SELECT * FROM mata_kuliah WHERE id_matakuliah=p_id_matakuliah LIMIT 1;
END$$

DROP PROCEDURE IF EXISTS `usp_select_mata_kuliah_kelas_untuk_jam_minus`$$
CREATE PROCEDURE `usp_select_mata_kuliah_kelas_untuk_jam_minus` (IN `p_id_kelas` INT)   BEGIN
    SELECT d.id_detail_kelas_pada_mata_kuliah,mk.id_matakuliah AS id_mata_kuliah,mk.kode_mata_kuliah,mk.nama_mata_kuliah,mk.sks,mk.semester
    FROM detail_kelas_pada_mata_kuliah d JOIN mata_kuliah mk ON d.id_mata_kuliah=mk.id_matakuliah
    JOIN kelas k ON d.id_kelas=k.id_kelas
    WHERE d.id_kelas=p_id_kelas AND k.status_kelas='Aktif' AND mk.status_mata_kuliah='Aktif'
    ORDER BY mk.semester,mk.nama_mata_kuliah;
END$$

DROP PROCEDURE IF EXISTS `usp_select_mata_kuliah_mahasiswa`$$
CREATE PROCEDURE `usp_select_mata_kuliah_mahasiswa` (IN `p_id_pengguna` INT)   BEGIN
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

DROP PROCEDURE IF EXISTS `usp_select_mata_kuliah_mahasiswa_untuk_jam_minus`$$
CREATE PROCEDURE `usp_select_mata_kuliah_mahasiswa_untuk_jam_minus` (IN `p_id_pengguna_mahasiswa` INT)   BEGIN
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

DROP PROCEDURE IF EXISTS `usp_select_pemberian_jam_minus`$$
CREATE PROCEDURE `usp_select_pemberian_jam_minus` ()   BEGIN
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

DROP PROCEDURE IF EXISTS `usp_select_pengaduan_by_id`$$
CREATE PROCEDURE `usp_select_pengaduan_by_id` (IN `p_id_pengaduan` INT)   BEGIN
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

DROP PROCEDURE IF EXISTS `usp_select_pengaduan_kerusakan_fasilitas`$$
CREATE PROCEDURE `usp_select_pengaduan_kerusakan_fasilitas` ()   BEGIN
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

DROP PROCEDURE IF EXISTS `usp_select_pengajar`$$
CREATE PROCEDURE `usp_select_pengajar` ()   BEGIN
    SELECT id_pengajar, nip, nama_pengajar, email, no_hp, status_pengajar
    FROM pengajar WHERE status_pengajar = 'Aktif' ORDER BY nama_pengajar ASC;
END$$

DROP PROCEDURE IF EXISTS `usp_select_pengajar_aktif`$$
CREATE PROCEDURE `usp_select_pengajar_aktif` ()   BEGIN
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

DROP PROCEDURE IF EXISTS `usp_select_pengajar_by_id`$$
CREATE PROCEDURE `usp_select_pengajar_by_id` (IN `p_id_pengajar` INT)   BEGIN
    SELECT * FROM pengajar WHERE id_pengajar=p_id_pengajar LIMIT 1;
END$$

DROP PROCEDURE IF EXISTS `usp_select_pengajar_mata_kuliah_kelas`$$
CREATE PROCEDURE `usp_select_pengajar_mata_kuliah_kelas` ()   BEGIN
    SELECT d.id_detail_kelas_pada_mata_kuliah,k.id_kelas,k.nama_kelas,k.tingkat,
           mk.id_matakuliah AS id_mata_kuliah,mk.kode_mata_kuliah,mk.nama_mata_kuliah,mk.sks,mk.semester
    FROM detail_kelas_pada_mata_kuliah d
    JOIN kelas k ON d.id_kelas=k.id_kelas
    JOIN mata_kuliah mk ON d.id_mata_kuliah=mk.id_matakuliah
    WHERE k.status_kelas='Aktif' AND mk.status_mata_kuliah='Aktif'
    ORDER BY k.tingkat,k.nama_kelas,mk.semester,mk.nama_mata_kuliah;
END$$

DROP PROCEDURE IF EXISTS `usp_select_pengajar_mata_kuliah_kelas_by_id`$$
CREATE PROCEDURE `usp_select_pengajar_mata_kuliah_kelas_by_id` (IN `p_id_detail_kelas_pada_mata_kuliah` INT)   BEGIN
    SELECT d.id_detail_kelas_pada_mata_kuliah,d.id_kelas,k.nama_kelas,k.tingkat,
           d.id_mata_kuliah,mk.kode_mata_kuliah,mk.nama_mata_kuliah,mk.sks,mk.semester
    FROM detail_kelas_pada_mata_kuliah d
    JOIN kelas k ON d.id_kelas=k.id_kelas
    JOIN mata_kuliah mk ON d.id_mata_kuliah=mk.id_matakuliah
    WHERE d.id_detail_kelas_pada_mata_kuliah=p_id_detail_kelas_pada_mata_kuliah;
END$$

DROP PROCEDURE IF EXISTS `usp_select_pengajuan_jam_plus`$$
CREATE PROCEDURE `usp_select_pengajuan_jam_plus` ()   BEGIN
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

DROP PROCEDURE IF EXISTS `usp_select_pengajuan_jam_plus_by_id`$$
CREATE PROCEDURE `usp_select_pengajuan_jam_plus_by_id` (IN `p_id_pengajuan` INT)   BEGIN
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

DROP PROCEDURE IF EXISTS `usp_select_pengguna`$$
CREATE PROCEDURE `usp_select_pengguna` ()   BEGIN
    SELECT p.id_pengguna, p.id_mahasiswa, m.nim, m.nama_mahasiswa, p.id_pengajar,
           pg.nip, pg.nama_pengajar, p.username, p.role, p.status_akun
    FROM pengguna p
    LEFT JOIN mahasiswa m ON p.id_mahasiswa = m.id_mahasiswa
    LEFT JOIN pengajar pg ON p.id_pengajar = pg.id_pengajar
    WHERE p.status_akun = 'Aktif'
    ORDER BY p.username ASC;
END$$

DROP PROCEDURE IF EXISTS `usp_select_pengguna_aktif`$$
CREATE PROCEDURE `usp_select_pengguna_aktif` ()   BEGIN
    SELECT p.id_pengguna, p.id_mahasiswa, m.nim, m.nama_mahasiswa, p.id_pengajar,
           pg.nip, pg.nama_pengajar, p.username, p.role, p.status_akun
    FROM pengguna p
    LEFT JOIN mahasiswa m ON p.id_mahasiswa = m.id_mahasiswa
    LEFT JOIN pengajar pg ON p.id_pengajar = pg.id_pengajar
    WHERE p.status_akun = 'Aktif'
    ORDER BY p.username ASC;
END$$

DROP PROCEDURE IF EXISTS `usp_select_pengguna_by_id`$$
CREATE PROCEDURE `usp_select_pengguna_by_id` (IN `p_id_pengguna` INT)   BEGIN
    SELECT * FROM pengguna WHERE id_pengguna=p_id_pengguna LIMIT 1;
END$$

DROP PROCEDURE IF EXISTS `usp_select_periode_akademik`$$
CREATE PROCEDURE `usp_select_periode_akademik` ()   BEGIN
    SELECT id_periode_akademik, tahun_akademik, semester, tanggal_mulai, tanggal_selesai, status_periode
    FROM periode_akademik
    WHERE status_periode = 'Aktif'
    ORDER BY tanggal_mulai DESC, id_periode_akademik DESC;
END$$

DROP PROCEDURE IF EXISTS `usp_select_periode_akademik_by_id`$$
CREATE PROCEDURE `usp_select_periode_akademik_by_id` (IN `p_id_periode_akademik` INT)   BEGIN
    SELECT id_periode_akademik, tahun_akademik, semester, tanggal_mulai, tanggal_selesai, status_periode
    FROM periode_akademik
    WHERE id_periode_akademik = p_id_periode_akademik AND status_periode = 'Aktif';
END$$

DROP PROCEDURE IF EXISTS `usp_select_periode_tersedia_mahasiswa`$$
CREATE PROCEDURE `usp_select_periode_tersedia_mahasiswa` ()   BEGIN
    SELECT id_periode_akademik,tahun_akademik,semester,tanggal_mulai,tanggal_selesai,status_periode
    FROM periode_akademik
    WHERE status_periode='Aktif' AND tanggal_selesai>=CURDATE()
    ORDER BY tanggal_mulai DESC;
END$$

DROP PROCEDURE IF EXISTS `usp_selesaikan_bursa_jobdesc`$$
CREATE PROCEDURE `usp_selesaikan_bursa_jobdesc` (IN `p_id_bursa_jobdesc` INT, IN `p_id_pemberi` INT)   BEGIN
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

DROP PROCEDURE IF EXISTS `usp_soft_delete_fasilitas`$$
CREATE PROCEDURE `usp_soft_delete_fasilitas` (IN `p_id_fasilitas` INT)   BEGIN
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

DROP PROCEDURE IF EXISTS `usp_soft_delete_fasilitas_kelas`$$
CREATE PROCEDURE `usp_soft_delete_fasilitas_kelas` (IN `p_id_detail_fasilitas_pada_kelas` INT)   BEGIN
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

DROP PROCEDURE IF EXISTS `usp_soft_delete_kegiatan`$$
CREATE PROCEDURE `usp_soft_delete_kegiatan` (IN `p_id_kegiatan` INT)   BEGIN
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

DROP PROCEDURE IF EXISTS `usp_soft_delete_kelas`$$
CREATE PROCEDURE `usp_soft_delete_kelas` (IN `p_id_kelas` INT)   BEGIN
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

DROP PROCEDURE IF EXISTS `usp_soft_delete_mahasiswa`$$
CREATE PROCEDURE `usp_soft_delete_mahasiswa` (IN `p_id_mahasiswa` INT)   BEGIN
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

DROP PROCEDURE IF EXISTS `usp_soft_delete_mata_kuliah`$$
CREATE PROCEDURE `usp_soft_delete_mata_kuliah` (IN `p_id` INT)   BEGIN UPDATE mata_kuliah SET status_mata_kuliah='Tidak Aktif' WHERE id_matakuliah=p_id AND status_mata_kuliah='Aktif'; IF ROW_COUNT()=0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Mata kuliah tidak ditemukan atau sudah tidak aktif'; END IF; END$$

DROP PROCEDURE IF EXISTS `usp_soft_delete_pengajar`$$
CREATE PROCEDURE `usp_soft_delete_pengajar` (IN `p_id_pengajar` INT)   BEGIN
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

DROP PROCEDURE IF EXISTS `usp_soft_delete_pengguna`$$
CREATE PROCEDURE `usp_soft_delete_pengguna` (IN `p_id_pengguna` INT)   BEGIN
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

DROP PROCEDURE IF EXISTS `usp_soft_delete_periode_akademik`$$
CREATE PROCEDURE `usp_soft_delete_periode_akademik` (IN `p_id_periode_akademik` INT)   BEGIN
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

DROP PROCEDURE IF EXISTS `usp_update_bukti_selesai_url_bursa_jobdesc`$$
CREATE PROCEDURE `usp_update_bukti_selesai_url_bursa_jobdesc` (IN `p_id_bursa_jobdesc` INT, IN `p_id_pengguna` INT, IN `p_bukti_selesai_url` TEXT)   BEGIN
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

DROP PROCEDURE IF EXISTS `usp_update_detail_fasilitas_pada_kelas`$$
CREATE PROCEDURE `usp_update_detail_fasilitas_pada_kelas` (IN `p_id_detail_fasilitas_pada_kelas` INT, IN `p_id_kelas` INT, IN `p_id_fasilitas` INT)   BEGIN
    IF NOT EXISTS (SELECT 1 FROM detail_fasilitas_pada_kelas WHERE id_detail_fasilitas_pada_kelas = p_id_detail_fasilitas_pada_kelas) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Data fasilitas kelas tidak ditemukan'; END IF;
    IF EXISTS (SELECT 1 FROM detail_fasilitas_pada_kelas WHERE id_kelas = p_id_kelas AND id_fasilitas = p_id_fasilitas AND id_detail_fasilitas_pada_kelas <> p_id_detail_fasilitas_pada_kelas) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Fasilitas sudah terhubung ke kelas tersebut'; END IF;
    UPDATE detail_fasilitas_pada_kelas SET id_kelas = p_id_kelas, id_fasilitas = p_id_fasilitas WHERE id_detail_fasilitas_pada_kelas = p_id_detail_fasilitas_pada_kelas;
    SELECT 'Data fasilitas kelas berhasil diupdate' AS Pesan, p_id_detail_fasilitas_pada_kelas AS id_detail_fasilitas_pada_kelas;
END$$

DROP PROCEDURE IF EXISTS `usp_update_fasilitas`$$
CREATE PROCEDURE `usp_update_fasilitas` (IN `p_id_fasilitas` INT, IN `p_nama_fasilitas` VARCHAR(50), IN `p_harga` DECIMAL(15,2), IN `p_id_kelas_csv` TEXT)   BEGIN
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

DROP PROCEDURE IF EXISTS `usp_update_kegiatan`$$
CREATE PROCEDURE `usp_update_kegiatan` (IN `p_id_kegiatan` INT, IN `p_nama_kegiatan` VARCHAR(50), IN `p_penyelenggara` VARCHAR(20), IN `p_tanggal_kegiatan` DATE)   BEGIN
    SET p_nama_kegiatan=TRIM(p_nama_kegiatan);
    IF NOT EXISTS (SELECT 1 FROM kegiatan WHERE id_kegiatan=p_id_kegiatan AND status_kegiatan='Aktif') THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Data kegiatan tidak ditemukan atau tidak aktif'; END IF;
    IF p_nama_kegiatan='' OR p_penyelenggara NOT IN ('ASTRAtech','BEM','MPM','HIMMA','UKM','Prodi') THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Data kegiatan tidak valid'; END IF;
    IF EXISTS (SELECT 1 FROM kegiatan WHERE status_kegiatan='Aktif' AND id_kegiatan<>p_id_kegiatan AND UPPER(TRIM(nama_kegiatan))=UPPER(p_nama_kegiatan) AND penyelenggara=p_penyelenggara AND tanggal_kegiatan <=> p_tanggal_kegiatan) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Kegiatan aktif dengan seluruh input yang sama sudah tersedia';
    END IF;
    UPDATE kegiatan SET nama_kegiatan=p_nama_kegiatan,penyelenggara=p_penyelenggara,tanggal_kegiatan=p_tanggal_kegiatan WHERE id_kegiatan=p_id_kegiatan;
    SELECT 'Data kegiatan berhasil diubah' AS Pesan,p_id_kegiatan AS id_kegiatan;
END$$

DROP PROCEDURE IF EXISTS `usp_update_kelas`$$
CREATE PROCEDURE `usp_update_kelas` (IN `p_id_kelas` INT, IN `p_nama_kelas` VARCHAR(5), IN `p_tingkat` VARCHAR(1))   BEGIN
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

DROP PROCEDURE IF EXISTS `usp_update_mahasiswa`$$
CREATE PROCEDURE `usp_update_mahasiswa` (IN `p_id_mahasiswa` INT, IN `p_id_kelas` INT, IN `p_id_periode_akademik` INT, IN `p_nim` VARCHAR(20), IN `p_nama_mahasiswa` VARCHAR(50), IN `p_email` VARCHAR(50), IN `p_no_hp` VARCHAR(20), IN `p_status_mahasiswa` VARCHAR(20))   BEGIN
    DECLARE v_id_kelas_lama INT;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN ROLLBACK; RESIGNAL; END;
    SET p_email = NULLIF(TRIM(p_email), '');
    SET p_no_hp = NULLIF(TRIM(p_no_hp), '');
    IF NOT EXISTS (SELECT 1 FROM mahasiswa WHERE id_mahasiswa = p_id_mahasiswa AND status_mahasiswa = 'Aktif') THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Data mahasiswa tidak ditemukan atau tidak aktif'; END IF;
    IF p_status_mahasiswa NOT IN ('Aktif','Lulus','Cuti') THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Status mahasiswa tidak valid'; END IF;
    IF p_no_hp IS NOT NULL AND p_no_hp NOT REGEXP '^[0-9]{10,13}$' THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No HP harus terdiri dari 10 sampai 13 digit'; END IF;
    IF NOT EXISTS (SELECT 1 FROM kelas WHERE id_kelas = p_id_kelas AND status_kelas = 'Aktif') THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Kelas tidak ditemukan atau tidak aktif'; END IF;
    IF NOT EXISTS (SELECT 1 FROM periode_akademik WHERE id_periode_akademik = p_id_periode_akademik AND tanggal_selesai >= CURDATE()) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Periode akademik tidak valid atau sudah berakhir'; END IF;
    IF EXISTS (SELECT 1 FROM mahasiswa WHERE nim = p_nim AND id_mahasiswa <> p_id_mahasiswa) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'NIM sudah digunakan oleh mahasiswa lain'; END IF;
    START TRANSACTION;
    SELECT id_kelas INTO v_id_kelas_lama FROM mahasiswa WHERE id_mahasiswa = p_id_mahasiswa FOR UPDATE;
    IF v_id_kelas_lama <> p_id_kelas THEN
        UPDATE kelas SET jumlah_mahasiswa = GREATEST(jumlah_mahasiswa - 1, 0) WHERE id_kelas = v_id_kelas_lama;
        UPDATE kelas SET jumlah_mahasiswa = jumlah_mahasiswa + 1 WHERE id_kelas = p_id_kelas;
    END IF;
    UPDATE mahasiswa SET id_kelas = p_id_kelas, id_periode_akademik = p_id_periode_akademik, nim = TRIM(p_nim), nama_mahasiswa = TRIM(p_nama_mahasiswa), email = p_email, no_hp = p_no_hp, status_mahasiswa = p_status_mahasiswa WHERE id_mahasiswa = p_id_mahasiswa;
    COMMIT;
    SELECT 'Data mahasiswa berhasil diupdate' AS Pesan, p_id_mahasiswa AS id_mahasiswa;
END$$

DROP PROCEDURE IF EXISTS `usp_update_mata_kuliah`$$
CREATE PROCEDURE `usp_update_mata_kuliah` (IN `p_id` INT, IN `p_nama` VARCHAR(100), IN `p_kode` VARCHAR(20), IN `p_sks` INT, IN `p_semester` INT, IN `p_status` VARCHAR(20))   BEGIN
 IF p_status NOT IN('Aktif','Tidak Aktif') THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Status mata kuliah tidak valid'; END IF;
 IF EXISTS(SELECT 1 FROM mata_kuliah WHERE kode_mata_kuliah=p_kode AND id_matakuliah<>p_id) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Kode mata kuliah sudah digunakan'; END IF;
 UPDATE mata_kuliah SET nama_mata_kuliah=TRIM(p_nama),kode_mata_kuliah=TRIM(p_kode),sks=p_sks,semester=p_semester,status_mata_kuliah=p_status WHERE id_matakuliah=p_id;
 IF ROW_COUNT()=0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Mata kuliah tidak ditemukan'; END IF;
END$$

DROP PROCEDURE IF EXISTS `usp_update_password_pengguna`$$
CREATE PROCEDURE `usp_update_password_pengguna` (IN `p_id_pengguna` INT, IN `p_password_hash` VARCHAR(255))   BEGIN
 IF p_password_hash IS NULL OR p_password_hash='' THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Password hash tidak valid'; END IF;
 UPDATE pengguna SET password=p_password_hash WHERE id_pengguna=p_id_pengguna;
END$$

DROP PROCEDURE IF EXISTS `usp_update_pengajar`$$
CREATE PROCEDURE `usp_update_pengajar` (IN `p_id_pengajar` INT, IN `p_nip` VARCHAR(20), IN `p_nama_pengajar` VARCHAR(50), IN `p_email` VARCHAR(50), IN `p_no_hp` VARCHAR(20))   BEGIN
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

DROP PROCEDURE IF EXISTS `usp_update_pengajar_mata_kuliah_kelas`$$
CREATE PROCEDURE `usp_update_pengajar_mata_kuliah_kelas` (IN `p_id_detail_kelas_pada_mata_kuliah` INT, IN `p_id_kelas` INT, IN `p_id_mata_kuliah` INT)   BEGIN
    IF NOT EXISTS (SELECT 1 FROM detail_kelas_pada_mata_kuliah WHERE id_detail_kelas_pada_mata_kuliah=p_id_detail_kelas_pada_mata_kuliah) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Data mata kuliah kelas tidak ditemukan'; END IF;
    IF NOT EXISTS (SELECT 1 FROM kelas WHERE id_kelas=p_id_kelas AND status_kelas='Aktif') OR NOT EXISTS (SELECT 1 FROM mata_kuliah WHERE id_matakuliah=p_id_mata_kuliah AND status_mata_kuliah='Aktif') THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Kelas atau mata kuliah tidak aktif'; END IF;
    IF EXISTS (SELECT 1 FROM detail_kelas_pada_mata_kuliah WHERE id_kelas=p_id_kelas AND id_mata_kuliah=p_id_mata_kuliah AND id_detail_kelas_pada_mata_kuliah<>p_id_detail_kelas_pada_mata_kuliah) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Mata kuliah sudah ditentukan pada kelas tersebut'; END IF;
    UPDATE detail_kelas_pada_mata_kuliah SET id_kelas=p_id_kelas,id_mata_kuliah=p_id_mata_kuliah WHERE id_detail_kelas_pada_mata_kuliah=p_id_detail_kelas_pada_mata_kuliah;
    SELECT 'Data mata kuliah kelas berhasil diubah' AS Pesan,p_id_detail_kelas_pada_mata_kuliah AS id_detail_kelas_pada_mata_kuliah;
END$$

DROP PROCEDURE IF EXISTS `usp_update_pengguna`$$
CREATE PROCEDURE `usp_update_pengguna` (IN `p_id_pengguna` INT, IN `p_id_mahasiswa` INT, IN `p_id_pengajar` INT, IN `p_username` VARCHAR(20), IN `p_password` VARCHAR(255), IN `p_role` VARCHAR(30))   BEGIN
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

DROP PROCEDURE IF EXISTS `usp_update_periode_akademik`$$
CREATE PROCEDURE `usp_update_periode_akademik` (IN `p_id_periode_akademik` INT, IN `p_tahun_akademik` VARCHAR(10), IN `p_semester` VARCHAR(10), IN `p_tanggal_mulai` DATE, IN `p_tanggal_selesai` DATE)   BEGIN
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

DROP PROCEDURE IF EXISTS `usp_update_status_bursa_jobdesc`$$
CREATE PROCEDURE `usp_update_status_bursa_jobdesc` (IN `p_id_bursa_jobdesc` INT, IN `p_id_pengguna` INT)   BEGIN
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

DROP PROCEDURE IF EXISTS `usp_update_status_detail_fasilitas_pada_kelas`$$
CREATE PROCEDURE `usp_update_status_detail_fasilitas_pada_kelas` (IN `p_id_pengguna` INT, IN `p_id_fasilitas` INT, IN `p_status_detail_fasilitas_pada_kelas` VARCHAR(20))   BEGIN
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

DROP PROCEDURE IF EXISTS `usp_update_status_pengaduan_kerusakan_fasilitas`$$
CREATE PROCEDURE `usp_update_status_pengaduan_kerusakan_fasilitas` (IN `p_id_pengaduan_kerusakan_fasilitas` INT, IN `p_id_pengguna` INT, IN `p_status_pengaduan` VARCHAR(20), IN `p_alsan_penolakan` VARCHAR(255))   BEGIN
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

DROP PROCEDURE IF EXISTS `usp_update_status_pengajuan_jam_plus`$$
CREATE PROCEDURE `usp_update_status_pengajuan_jam_plus` (IN `p_id_pengajuan` INT, IN `p_id_verifikator` INT, IN `p_status` VARCHAR(20), IN `p_alasan_penolakan` VARCHAR(255))   BEGIN
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

DROP PROCEDURE IF EXISTS `usp_validasi_referensi_mahasiswa`$$
CREATE PROCEDURE `usp_validasi_referensi_mahasiswa` (IN `p_id_kelas` INT, IN `p_id_periode` INT)   BEGIN
 SELECT EXISTS(SELECT 1 FROM kelas WHERE id_kelas=p_id_kelas AND status_kelas='Aktif') AS kelas_valid,
        EXISTS(SELECT 1 FROM periode_akademik WHERE id_periode_akademik=p_id_periode AND status_periode='Aktif' AND tanggal_selesai>=CURDATE()) AS periode_valid;
END$$

DROP PROCEDURE IF EXISTS `usp_validasi_session_pengguna`$$
CREATE PROCEDURE `usp_validasi_session_pengguna` (IN `p_id_pengguna` INT)   BEGIN
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

DELIMITER ;

-- --------------------------------------------------------

--
-- Triggers
--
DELIMITER $$
DROP TRIGGER IF EXISTS `trg_mahasiswa_bi_validasi`$$
CREATE TRIGGER `trg_mahasiswa_bi_validasi` BEFORE INSERT ON `mahasiswa` FOR EACH ROW BEGIN
    IF NEW.no_hp IS NOT NULL AND TRIM(NEW.no_hp) <> ''
       AND NEW.no_hp NOT REGEXP '^[0-9]{10,13}$' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'No HP mahasiswa harus terdiri dari 10 sampai 13 digit';
    END IF;
END$$

DROP TRIGGER IF EXISTS `trg_mahasiswa_bu_validasi`$$
CREATE TRIGGER `trg_mahasiswa_bu_validasi` BEFORE UPDATE ON `mahasiswa` FOR EACH ROW BEGIN
    IF NEW.no_hp IS NOT NULL AND TRIM(NEW.no_hp) <> ''
       AND NEW.no_hp NOT REGEXP '^[0-9]{10,13}$' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'No HP mahasiswa harus terdiri dari 10 sampai 13 digit';
    END IF;
END$$

DROP TRIGGER IF EXISTS `trg_pengajar_bi_validasi`$$
CREATE TRIGGER `trg_pengajar_bi_validasi` BEFORE INSERT ON `pengajar` FOR EACH ROW BEGIN
    IF NEW.no_hp IS NOT NULL AND TRIM(NEW.no_hp) <> ''
       AND NEW.no_hp NOT REGEXP '^[0-9]{10,13}$' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'No HP pengajar harus terdiri dari 10 sampai 13 digit';
    END IF;
END$$

DROP TRIGGER IF EXISTS `trg_pengajar_bu_validasi`$$
CREATE TRIGGER `trg_pengajar_bu_validasi` BEFORE UPDATE ON `pengajar` FOR EACH ROW BEGIN
    IF NEW.no_hp IS NOT NULL AND TRIM(NEW.no_hp) <> ''
       AND NEW.no_hp NOT REGEXP '^[0-9]{10,13}$' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'No HP pengajar harus terdiri dari 10 sampai 13 digit';
    END IF;
END$$

DROP TRIGGER IF EXISTS `trg_periode_akademik_bi`$$
CREATE TRIGGER `trg_periode_akademik_bi` BEFORE INSERT ON `periode_akademik` FOR EACH ROW BEGIN
    SET NEW.status_periode = 'Aktif';
END$$

DROP TRIGGER IF EXISTS `trg_periode_akademik_bu`$$
CREATE TRIGGER `trg_periode_akademik_bu` BEFORE UPDATE ON `periode_akademik` FOR EACH ROW BEGIN
    IF OLD.status_periode = 'Aktif'
       AND NEW.status_periode = 'Tidak Aktif'
       AND COALESCE(@simat_izinkan_nonaktif_periode, 0) <> 1 THEN

        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
            'Status periode aktif tidak dapat diubah menjadi tidak aktif melalui update';
    END IF;
END$$

DELIMITER ;

-- --------------------------------------------------------

-- Structure for view `vw_laporan_bursa_jobdesc`
--
DROP VIEW IF EXISTS `vw_laporan_bursa_jobdesc`;

CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `vw_laporan_bursa_jobdesc`  AS SELECT `bj`.`id_bursa_jobdesc` AS `id_bursa_jobdesc`, `bj`.`deskripsi_jobdesc` AS `deskripsi_jobdesc`, `bj`.`penerima_jobdesc` AS `target_penerima_jobdesc`, coalesce(`data_penerima`.`nama_penerima_jobdesc`,'Belum ada penerima') AS `nama_penerima_jobdesc`, `bj`.`jam_plus` AS `jam_plus`, `bj`.`tanggal_pemberian_jobdesc` AS `tanggal_pemberian_jobdesc`, `bj`.`jumlah_mahasiswa_diperlukan` AS `kuota`, `bj`.`jumlah_mahasiswa_mengambil` AS `terisi`, concat(`bj`.`jumlah_mahasiswa_mengambil`,'/',`bj`.`jumlah_mahasiswa_diperlukan`) AS `kuota_terisi`, `bj`.`status_jobdesc` AS `status_jobdesc`, `p_pemberi`.`id_pengguna` AS `id_pemberi`, `p_pemberi`.`username` AS `username_pemberi`, `p_pemberi`.`role` AS `role_pemberi`, coalesce(`pg_pemberi`.`nama_pengajar`,`m_pemberi`.`nama_mahasiswa`,`p_pemberi`.`username`) AS `nama_pemberi` FROM (((((`bursa_jobdesc` `bj` join `detail_pengguna_pada_bursa_jobdesc` `dp_pemberi` on(((`bj`.`id_bursa_jobdesc` = `dp_pemberi`.`id_bursa_jobdesc`) and (`dp_pemberi`.`peran_pengguna` = 'Pemberi')))) join `pengguna` `p_pemberi` on((`dp_pemberi`.`id_pengguna` = `p_pemberi`.`id_pengguna`))) left join `pengajar` `pg_pemberi` on((`p_pemberi`.`id_pengajar` = `pg_pemberi`.`id_pengajar`))) left join `mahasiswa` `m_pemberi` on((`p_pemberi`.`id_mahasiswa` = `m_pemberi`.`id_mahasiswa`))) left join (select `dp`.`id_bursa_jobdesc` AS `id_bursa_jobdesc`,group_concat(coalesce(`m`.`nama_mahasiswa`,`p`.`username`) order by coalesce(`m`.`nama_mahasiswa`,`p`.`username`) ASC separator ', ') AS `nama_penerima_jobdesc` from ((`detail_pengguna_pada_bursa_jobdesc` `dp` join `pengguna` `p` on((`dp`.`id_pengguna` = `p`.`id_pengguna`))) left join `mahasiswa` `m` on((`p`.`id_mahasiswa` = `m`.`id_mahasiswa`))) where (`dp`.`peran_pengguna` = 'Penerima') group by `dp`.`id_bursa_jobdesc`) `data_penerima` on((`bj`.`id_bursa_jobdesc` = `data_penerima`.`id_bursa_jobdesc`)))  ;

-- --------------------------------------------------------

--
-- Structure for view `vw_laporan_histori_transaksi_jam_mahasiswa`
--
DROP VIEW IF EXISTS `vw_laporan_histori_transaksi_jam_mahasiswa`;

CREATE ALGORITHM=UNDEFINED SQL SECURITY INVOKER VIEW `vw_laporan_histori_transaksi_jam_mahasiswa`  AS SELECT `u_pengaju`.`id_pengguna` AS `id_pengguna`, `m`.`id_mahasiswa` AS `id_mahasiswa`, `pjp`.`id_pengajuan_jam_plus` AS `id_transaksi`, 'Pengajuan Jam Plus' AS `jenis_transaksi`, `pjp`.`tanggal_pengajuan` AS `tanggal_transaksi`, concat('Jam Plus ',`pjp`.`jenis_jam`,' - ',coalesce(nullif(trim(`pjp`.`deskripsi_pekerjaan`),''),'Tanpa deskripsi'),' | Sumber: ',`pjp`.`sumber_jam`,(case when (`pjp`.`sumber_jam` = 'Luar') then concat(' (',coalesce(nullif(trim(`k`.`nama_kegiatan`),''),'Kegiatan tidak diketahui'),')') else '' end),' | Jam diterima: ',cast((case when (`pjp`.`sumber_jam` = 'Luar') then (`pjp`.`jumlah_jam_plus` * 0.5) else `pjp`.`jumlah_jam_plus` end) as decimal(10,1)),' jam') AS `deskripsi`, `m`.`saldo_jam_plus_kompensasi` AS `saldo_jam_plus_kompensasi`, `m`.`saldo_jam_minus_kompensasi` AS `saldo_jam_minus_kompensasi`, `m`.`saldo_jam_plus_murni` AS `saldo_jam_plus_murni`, `m`.`saldo_jam_minus_murni` AS `saldo_jam_minus_murni` FROM ((((`pengajuan_jam_plus` `pjp` join `detail_pengguna_pada_pengajuan_jam_plus` `dp_pengaju` on(((`pjp`.`id_pengajuan_jam_plus` = `dp_pengaju`.`id_pengajuan_jam_plus`) and (`dp_pengaju`.`peran_pengguna` = 'Pengaju')))) join `pengguna` `u_pengaju` on((`dp_pengaju`.`id_pengguna` = `u_pengaju`.`id_pengguna`))) join `mahasiswa` `m` on((`u_pengaju`.`id_mahasiswa` = `m`.`id_mahasiswa`))) left join `kegiatan` `k` on((`pjp`.`id_kegiatan` = `k`.`id_kegiatan`))) WHERE (`pjp`.`status_pengajuan` = 'Disetujui') union all select `u_penerima`.`id_pengguna` AS `id_pengguna`,`m`.`id_mahasiswa` AS `id_mahasiswa`,`pjm`.`id_pemberian_jam_minus` AS `id_transaksi`,'Pemberian Jam Minus' AS `jenis_transaksi`,`pjm`.`tanggal_pemberian` AS `tanggal_transaksi`,(case when (`pjm`.`kategori_pelanggaran` = 'Akademik') then concat('Jam Minus ',`pjm`.`jenis_jam`,' - ',coalesce(nullif(trim(`pjm`.`deskripsi_pelanggaran`),''),nullif(trim(`pjm`.`nama_pelanggaran`),''),'Pelanggaran akademik'),' | Mata kuliah: ',coalesce(`mk`.`nama_mata_kuliah`,'-'),' | Absensi: ',coalesce(`pjm`.`keterangan_absensi`,'-'),' | Jumlah: ',cast(`pjm`.`jumlah_jam_minus` as decimal(10,1)),' jam') when (`pjm`.`kategori_pelanggaran` = 'Fasilitas') then concat('Jam Minus ',`pjm`.`jenis_jam`,' - ',coalesce(nullif(trim(`pjm`.`deskripsi_pelanggaran`),''),nullif(trim(`pjm`.`nama_pelanggaran`),''),'Kerusakan fasilitas'),' | Fasilitas: ',coalesce(`f`.`nama_fasilitas`,'-'),' | Jumlah: ',cast(`pjm`.`jumlah_jam_minus` as decimal(10,1)),' jam') else concat('Jam Minus ',`pjm`.`jenis_jam`,' - ',coalesce(nullif(trim(`pjm`.`deskripsi_pelanggaran`),''),nullif(trim(`pjm`.`nama_pelanggaran`),''),'Pelanggaran lainnya'),' | Jumlah: ',cast(`pjm`.`jumlah_jam_minus` as decimal(10,1)),' jam') end) AS `deskripsi`,`m`.`saldo_jam_plus_kompensasi` AS `saldo_jam_plus_kompensasi`,`m`.`saldo_jam_minus_kompensasi` AS `saldo_jam_minus_kompensasi`,`m`.`saldo_jam_plus_murni` AS `saldo_jam_plus_murni`,`m`.`saldo_jam_minus_murni` AS `saldo_jam_minus_murni` from ((((((`pemberian_jam_minus` `pjm` join `detail_pengguna_pada_pemberian_jam_minus` `dp_penerima` on(((`pjm`.`id_pemberian_jam_minus` = `dp_penerima`.`id_pemberian_jam_minus`) and (`dp_penerima`.`peran_pengguna` = 'Penerima')))) join `pengguna` `u_penerima` on((`dp_penerima`.`id_pengguna` = `u_penerima`.`id_pengguna`))) join `mahasiswa` `m` on((`u_penerima`.`id_mahasiswa` = `m`.`id_mahasiswa`))) left join `detail_kelas_pada_mata_kuliah` `dkmk` on((`pjm`.`id_detail_kelas_pada_mata_kuliah` = `dkmk`.`id_detail_kelas_pada_mata_kuliah`))) left join `mata_kuliah` `mk` on((`dkmk`.`id_mata_kuliah` = `mk`.`id_matakuliah`))) left join `fasilitas` `f` on((`pjm`.`id_fasilitas` = `f`.`id_fasilitas`)))  ;

-- --------------------------------------------------------

--
-- Structure for view `vw_laporan_pengaduan_fasilitas`
--
DROP VIEW IF EXISTS `vw_laporan_pengaduan_fasilitas`;

CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `vw_laporan_pengaduan_fasilitas`  AS SELECT `pkf`.`id_pengaduan_kerusakan_fasilitas` AS `id_pengaduan_kerusakan_fasilitas`, `m`.`id_mahasiswa` AS `id_mahasiswa`, `m`.`nim` AS `nim`, `m`.`nama_mahasiswa` AS `nama_mahasiswa`, coalesce(`k_hist`.`id_kelas`,`k_current`.`id_kelas`) AS `id_kelas`, coalesce(`k_hist`.`nama_kelas`,`k_current`.`nama_kelas`,'-') AS `nama_kelas`, `f`.`id_fasilitas` AS `id_fasilitas`, `f`.`nama_fasilitas` AS `nama_fasilitas`, `pkf`.`deskripsi_kerusakan` AS `deskripsi_kerusakan`, `pkf`.`tanggal_pengaduan` AS `tanggal_pengaduan` FROM (((((((`pengaduan_kerusakan_fasilitas` `pkf` join `fasilitas` `f` on((`pkf`.`id_fasilitas` = `f`.`id_fasilitas`))) join `detail_pengguna_pada_pengaduan_kerusakan_fasilitas` `dp` on(((`pkf`.`id_pengaduan_kerusakan_fasilitas` = `dp`.`id_pengaduan_kerusakan_fasilitas`) and (`dp`.`peran_pengguna` = 'Pelapor')))) join `pengguna` `p` on((`dp`.`id_pengguna` = `p`.`id_pengguna`))) join `mahasiswa` `m` on((`p`.`id_mahasiswa` = `m`.`id_mahasiswa`))) left join `detail_fasilitas_pada_kelas` `dfpk` on((`pkf`.`id_detail_fasilitas_pada_kelas` = `dfpk`.`id_detail_fasilitas_pada_kelas`))) left join `kelas` `k_hist` on((`dfpk`.`id_kelas` = `k_hist`.`id_kelas`))) left join `kelas` `k_current` on((`m`.`id_kelas` = `k_current`.`id_kelas`)))  ;

-- --------------------------------------------------------

--
-- Structure for view `vw_laporan_total_jam_mahasiswa`
--
DROP VIEW IF EXISTS `vw_laporan_total_jam_mahasiswa`;

CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `vw_laporan_total_jam_mahasiswa`  AS SELECT `m`.`id_mahasiswa` AS `id_mahasiswa`, `m`.`nim` AS `nim`, `m`.`nama_mahasiswa` AS `nama_mahasiswa`, `k`.`id_kelas` AS `id_kelas`, `k`.`nama_kelas` AS `nama_kelas`, cast(`ufn_hitung_total_jam_kompensasi_mahasiswa`(`m`.`id_mahasiswa`) as decimal(10,1)) AS `total_jam_kompensasi`, cast(`ufn_hitung_total_jam_murni_mahasiswa`(`m`.`id_mahasiswa`) as decimal(10,1)) AS `total_jam_murni`, cast(`ufn_hitung_total_jam_mahasiswa`(`m`.`id_mahasiswa`) as decimal(10,1)) AS `total_jam_mahasiswa` FROM (`mahasiswa` `m` join `kelas` `k` on((`k`.`id_kelas` = `m`.`id_kelas`))) WHERE (`m`.`status_mahasiswa` = 'Aktif')  ;

--


SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
SET TIME_ZONE=@OLD_TIME_ZONE;
SET SQL_MODE=@OLD_SQL_MODE;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
