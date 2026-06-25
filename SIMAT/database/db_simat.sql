-- phpMyAdmin SQL Dump - import-ready for Laragon/XAMPP
-- Database: `db_simat`
-- Modified: portable local import version

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";
SET NAMES utf8mb4;

SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS;
SET FOREIGN_KEY_CHECKS=0;

DROP DATABASE IF EXISTS `db_simat`;
CREATE DATABASE IF NOT EXISTS `db_simat`
  DEFAULT CHARACTER SET utf8mb4
  COLLATE utf8mb4_general_ci;
USE `db_simat`;

-- --------------------------------------------------------

--
-- Table structure for table `bursa_jobdesc`
--

CREATE TABLE `bursa_jobdesc` (
  `id_bursa_jobdesc` int NOT NULL,
  `deskripsi_jobdesc` text COLLATE utf8mb4_general_ci NOT NULL,
  `penerima_jobdesc` enum('Semua mahasiswa','Yang memiliki jam minus') COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'Semua mahasiswa',
  `jam_plus` decimal(6,2) NOT NULL,
  `tanggal_pemberian_jobdesc` datetime NOT NULL,
  `jumlah_mahasiswa_diperlukan` int NOT NULL,
  `jumlah_mahasiswa_mengambil` int NOT NULL DEFAULT '0',
  `bukti_selesai_url` varchar(2048) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `status_jobdesc` enum('Dibuka','Dikerjakan','Selesai') COLLATE utf8mb4_general_ci DEFAULT 'Dibuka'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `bursa_jobdesc`
--

INSERT INTO `bursa_jobdesc` (`id_bursa_jobdesc`, `deskripsi_jobdesc`, `penerima_jobdesc`, `jam_plus`, `tanggal_pemberian_jobdesc`, `jumlah_mahasiswa_diperlukan`, `jumlah_mahasiswa_mengambil`, `bukti_selesai_url`, `status_jobdesc`) VALUES
(1, 'wertg34', 'Semua mahasiswa', '20.00', '2026-06-18 18:46:00', 2, 2, 'https://halo', 'Selesai'),
(2, 'Membersihkan tendik', 'Semua mahasiswa', '20.00', '2026-06-19 22:20:00', 10, 10, 'https://halo', 'Selesai'),
(3, 'Perbaiki laptop', 'Semua mahasiswa', '10.00', '2026-06-20 00:00:00', 2, 2, 'https://halo', 'Selesai'),
(4, 'Cari ikan', 'Yang memiliki jam minus', '90.00', '2026-06-27 04:40:00', 2, 2, 'a', 'Selesai'),
(5, 'hdsufodsf', 'Semua mahasiswa', '20.00', '2026-06-19 08:36:00', 2, 2, 'selesai cik', 'Selesai');

-- --------------------------------------------------------

--
-- Table structure for table `detail_fasilitas_pada_kelas`
--

CREATE TABLE `detail_fasilitas_pada_kelas` (
  `id_detail_fasilitas_pada_kelas` int NOT NULL,
  `id_kelas` int NOT NULL,
  `id_fasilitas` int NOT NULL,
  `jumlah_fasilitas` int DEFAULT '1',
  `status_detail_fasilitas_pada_kelas` enum('Aktif','Rusak') COLLATE utf8mb4_general_ci DEFAULT 'Aktif'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `detail_fasilitas_pada_kelas`
--

INSERT INTO `detail_fasilitas_pada_kelas` (`id_detail_fasilitas_pada_kelas`, `id_kelas`, `id_fasilitas`, `jumlah_fasilitas`, `status_detail_fasilitas_pada_kelas`) VALUES
(1, 1, 6, 80, 'Aktif'),
(2, 1, 7, 1, 'Aktif'),
(3, 2, 8, 3, 'Rusak');

-- --------------------------------------------------------

--
-- Table structure for table `detail_kelas_pada_mata_kuliah`
--

CREATE TABLE `detail_kelas_pada_mata_kuliah` (
  `id_detail_kelas_pada_mata_kuliah` int NOT NULL,
  `id_mata_kuliah` int NOT NULL,
  `id_kelas` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `detail_pengajar_pada_mata_kuliah`
--

CREATE TABLE `detail_pengajar_pada_mata_kuliah` (
  `id_detail_pengajar_pada_mata_kuliah` int NOT NULL,
  `id_detail_kelas_pada_mata_kuliah` int NOT NULL,
  `id_pengajar` int NOT NULL,
  `kedudukan_pengajar` enum('Pengajar1','Pengajar2') COLLATE utf8mb4_general_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `detail_pengguna_pada_bursa_jobdesc`
--

CREATE TABLE `detail_pengguna_pada_bursa_jobdesc` (
  `id_detail_pengguna_pada_bursa_jobdesc` int NOT NULL,
  `id_bursa_jobdesc` int NOT NULL,
  `id_pengguna` int NOT NULL,
  `peran_pengguna` enum('Pemberi','Penerima') COLLATE utf8mb4_general_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `detail_pengguna_pada_bursa_jobdesc`
--

INSERT INTO `detail_pengguna_pada_bursa_jobdesc` (`id_detail_pengguna_pada_bursa_jobdesc`, `id_bursa_jobdesc`, `id_pengguna`, `peran_pengguna`) VALUES
(1, 1, 2, 'Pemberi'),
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
(14, 1, 9, 'Penerima'),
(15, 1, 7, 'Penerima'),
(16, 3, 6, 'Pemberi'),
(17, 4, 2, 'Pemberi'),
(18, 4, 7, 'Penerima'),
(19, 4, 15, 'Penerima'),
(20, 3, 19, 'Penerima'),
(21, 3, 16, 'Penerima'),
(22, 5, 2, 'Pemberi'),
(23, 5, 9, 'Penerima'),
(24, 5, 10, 'Penerima');

-- --------------------------------------------------------

--
-- Table structure for table `detail_pengguna_pada_pemberian_jam_minus`
--

CREATE TABLE `detail_pengguna_pada_pemberian_jam_minus` (
  `id_detail_pengguna_pada_pemberian_jam_minus` int NOT NULL,
  `id_pemberian_jam_minus` int NOT NULL,
  `id_pengguna` int NOT NULL,
  `peran_pengguna` enum('Pemberi','Penerima') COLLATE utf8mb4_general_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `detail_pengguna_pada_pengaduan_kerusakan_fasilitas`
--

CREATE TABLE `detail_pengguna_pada_pengaduan_kerusakan_fasilitas` (
  `id_detail_pengguna_pada_pengaduan_kerusakan_fasilitas` int NOT NULL,
  `id_pengaduan_kerusakan_fasilitas` int NOT NULL,
  `id_pengguna` int NOT NULL,
  `peran_pengguna` enum('Pelapor','Verifikator') COLLATE utf8mb4_general_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `detail_pengguna_pada_pengaduan_kerusakan_fasilitas`
--

INSERT INTO `detail_pengguna_pada_pengaduan_kerusakan_fasilitas` (`id_detail_pengguna_pada_pengaduan_kerusakan_fasilitas`, `id_pengaduan_kerusakan_fasilitas`, `id_pengguna`, `peran_pengguna`) VALUES
(1, 1, 1, 'Pelapor'),
(2, 2, 1, 'Pelapor'),
(3, 2, 4, 'Verifikator'),
(4, 3, 7, 'Pelapor'),
(5, 4, 7, 'Pelapor'),
(6, 3, 4, 'Verifikator'),
(7, 4, 4, 'Verifikator'),
(8, 5, 7, 'Pelapor'),
(9, 5, 4, 'Verifikator'),
(10, 6, 9, 'Pelapor'),
(11, 6, 4, 'Verifikator'),
(13, 1, 4, 'Verifikator');

-- --------------------------------------------------------

--
-- Table structure for table `detail_pengguna_pada_pengajuan_jam_plus`
--

CREATE TABLE `detail_pengguna_pada_pengajuan_jam_plus` (
  `id_detail_pengguna_pada_pengajuan_jam_plus` int NOT NULL,
  `id_pengajuan_jam_plus` int NOT NULL,
  `id_pengguna` int NOT NULL,
  `peran_pengguna` enum('Pengaju','Verifikator') COLLATE utf8mb4_general_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `fasilitas`
--

CREATE TABLE `fasilitas` (
  `id_fasilitas` int NOT NULL,
  `nama_fasilitas` varchar(50) COLLATE utf8mb4_general_ci NOT NULL,
  `harga` decimal(15,2) DEFAULT '0.00',
  `status_fasilitas` enum('Aktif','Tidak Aktif') COLLATE utf8mb4_general_ci DEFAULT 'Aktif',
  `tanggal_pendataan` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `fasilitas`
--

INSERT INTO `fasilitas` (`id_fasilitas`, `nama_fasilitas`, `harga`, `status_fasilitas`, `tanggal_pendataan`) VALUES
(1, 'Proyektor Kelas', '4500000.00', 'Tidak Aktif', '2026-06-08 22:50:43'),
(2, 'AC Kelas', '3500000.00', 'Tidak Aktif', '2026-06-08 22:50:43'),
(3, 'Komputer Lab', '8500000.00', 'Tidak Aktif', '2026-06-08 22:50:43'),
(4, 'Kursi Kelas', '350000.00', 'Tidak Aktif', '2026-06-08 22:50:43'),
(5, 'Papan Tulis', '750000.00', 'Tidak Aktif', '2026-06-08 22:50:43'),
(6, 'Bangku', '100000.00', 'Tidak Aktif', '2026-06-11 23:44:46'),
(7, 'Bangku', '120000.00', 'Aktif', '2026-06-17 19:24:58'),
(8, 'Kursi Kelas', '170000.00', 'Aktif', '2026-06-17 19:30:39');

-- --------------------------------------------------------

--
-- Table structure for table `kegiatan`
--

CREATE TABLE `kegiatan` (
  `id_kegiatan` int NOT NULL,
  `nama_kegiatan` varchar(50) COLLATE utf8mb4_general_ci NOT NULL,
  `tanggal_kegiatan` datetime NOT NULL,
  `status_kegiatan` enum('Aktif','Tidak Aktif') COLLATE utf8mb4_general_ci DEFAULT 'Aktif'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `kelas`
--

CREATE TABLE `kelas` (
  `id_kelas` int NOT NULL,
  `nama_kelas` varchar(5) COLLATE utf8mb4_general_ci NOT NULL,
  `tingkat` enum('1','2','3','4') COLLATE utf8mb4_general_ci NOT NULL,
  `jumlah_mahasiswa` int DEFAULT '0',
  `status_kelas` enum('Aktif','Tidak Aktif') COLLATE utf8mb4_general_ci DEFAULT 'Aktif'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `kelas`
--

INSERT INTO `kelas` (`id_kelas`, `nama_kelas`, `tingkat`, `jumlah_mahasiswa`, `status_kelas`) VALUES
(1, 'TR1C', '1', 3, 'Aktif'),
(2, 'TR1B', '1', 4, 'Aktif'),
(3, 'TR1K', '2', 0, 'Tidak Aktif'),
(4, 'IUGHS', '1', 0, 'Tidak Aktif'),
(5, 'TR1A', '1', 6, 'Aktif');

-- --------------------------------------------------------

--
-- Table structure for table `mahasiswa`
--

CREATE TABLE `mahasiswa` (
  `id_mahasiswa` int NOT NULL,
  `id_kelas` int NOT NULL,
  `id_periode_akademik` int NOT NULL,
  `nim` varchar(20) COLLATE utf8mb4_general_ci NOT NULL,
  `nama_mahasiswa` varchar(50) COLLATE utf8mb4_general_ci NOT NULL,
  `email` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `no_hp` varchar(20) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `saldo_jam_minus_murni` decimal(6,2) DEFAULT '0.00',
  `saldo_jam_minus_kompensasi` decimal(6,2) DEFAULT '0.00',
  `saldo_jam_plus_murni` decimal(6,2) DEFAULT '0.00',
  `saldo_jam_plus_kompensasi` decimal(6,2) DEFAULT '0.00',
  `status_mahasiswa` enum('Aktif','Tidak Aktif','Lulus','Cuti') COLLATE utf8mb4_general_ci DEFAULT 'Aktif'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `mahasiswa`
--

INSERT INTO `mahasiswa` (`id_mahasiswa`, `id_kelas`, `id_periode_akademik`, `nim`, `nama_mahasiswa`, `email`, `no_hp`, `saldo_jam_minus_murni`, `saldo_jam_minus_kompensasi`, `saldo_jam_plus_murni`, `saldo_jam_plus_kompensasi`, `status_mahasiswa`) VALUES
(1, 1, 1, '032025001', 'Yoga Margana', 'yoga@simat.test', '081111111111', '2.00', '0.00', '1.00', '0.00', 'Aktif'),
(2, 1, 1, '032025002', 'Fahri Aprilian', 'fahri@simat.test', '082222222222', '0.00', '1.00', '0.00', '1.00', 'Aktif'),
(3, 1, 1, '032025003', 'Nabilah Putri', 'nabilah@simat.test', '083333333333', '3.00', '0.00', '0.00', '0.00', 'Aktif'),
(4, 1, 1, '0987692345', 'Marganaa', 'marganayoga891@gmail.com', '089088752369', '0.00', '0.00', '0.00', '0.00', 'Tidak Aktif'),
(5, 2, 1, '0920250039', 'Mikael', 'mikael@gmail.com', '081298394420', '0.00', '0.00', '0.00', '0.00', 'Aktif'),
(6, 2, 1, '0920250035', 'Ridzal', 'Ridzal@gmail.com', '085477325643', '0.00', '0.00', '0.00', '0.00', 'Tidak Aktif'),
(7, 5, 1, '1', 'Mazt', '', '', '0.00', '0.00', '0.00', '0.00', 'Aktif'),
(8, 5, 1, '2', 'Daffa', '', '', '0.00', '0.00', '0.00', '0.00', 'Aktif'),
(9, 5, 1, '3', 'Rijal', '', '', '0.00', '0.00', '0.00', '0.00', 'Aktif'),
(10, 5, 1, '4', 'Adit', '', '', '0.00', '0.00', '0.00', '0.00', 'Aktif'),
(11, 5, 1, '5', 'Jonathan', '', '', '0.00', '0.00', '0.00', '0.00', 'Aktif'),
(12, 5, 1, '6', 'Irsyad', '', '', '0.00', '0.00', '0.00', '0.00', 'Aktif'),
(13, 2, 1, '9', 'Hailkal', '', '', '0.00', '0.00', '0.00', '0.00', 'Aktif');

-- --------------------------------------------------------

--
-- Table structure for table `mata_kuliah`
--

CREATE TABLE `mata_kuliah` (
  `id_matakuliah` int NOT NULL,
  `nama_mata_kuliah` varchar(30) COLLATE utf8mb4_general_ci NOT NULL,
  `kode_mata_kuliah` varchar(10) COLLATE utf8mb4_general_ci NOT NULL,
  `sks` int NOT NULL,
  `semester` enum('1','2','3','4','5','6','7','8') COLLATE utf8mb4_general_ci NOT NULL,
  `status_mata_kuliah` enum('Aktif','Tidak Aktif') COLLATE utf8mb4_general_ci DEFAULT 'Aktif'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `pemberian_jam_minus`
--

CREATE TABLE `pemberian_jam_minus` (
  `id_pemberian_jam_minus` int NOT NULL,
  `nama_pelanggaran` varchar(30) COLLATE utf8mb4_general_ci NOT NULL,
  `deskripsi_pelanggaran` text COLLATE utf8mb4_general_ci,
  `jumlah_jam_minus` decimal(6,2) NOT NULL,
  `jenis_jam` enum('Murni','Kompensasi') COLLATE utf8mb4_general_ci NOT NULL,
  `tanggal_pemberian` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `pengaduan_kerusakan_fasilitas`
--

CREATE TABLE `pengaduan_kerusakan_fasilitas` (
  `id_pengaduan_kerusakan_fasilitas` int NOT NULL,
  `id_fasilitas` int NOT NULL,
  `deskripsi_kerusakan` text COLLATE utf8mb4_general_ci NOT NULL,
  `tanggal_pengaduan` datetime NOT NULL,
  `bukti_kerusakan_url` varchar(2048) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `pelaku_kerusakan` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `status_pengaduan` enum('Menunggu Verifikasi','Diterima','Ditolak') COLLATE utf8mb4_general_ci DEFAULT 'Menunggu Verifikasi'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `pengaduan_kerusakan_fasilitas`
--

INSERT INTO `pengaduan_kerusakan_fasilitas` (`id_pengaduan_kerusakan_fasilitas`, `id_fasilitas`, `deskripsi_kerusakan`, `tanggal_pengaduan`, `bukti_kerusakan_url`, `pelaku_kerusakan`, `status_pengaduan`) VALUES
(1, 1, 'Proyektor kelas tidak menyala saat digunakan.', '2026-06-08 22:50:43', 'assets/uploads/pengaduan/dummy-proyektor.jpg', NULL, 'Ditolak'),
(2, 2, 'AC kelas tidak dingin dan mengeluarkan suara bising.', '2026-06-08 22:50:43', 'assets/uploads/pengaduan/dummy-ac.jpg', NULL, 'Diterima'),
(3, 6, 'azhar', '2026-06-12 00:22:50', 'azhar', 'Tidak diketahui', 'Diterima'),
(4, 6, 'azhar', '2026-06-12 00:23:21', 'azhar', 'azhar', 'Ditolak'),
(5, 6, 'azahr', '2026-06-12 00:29:55', 'https://www.youtube.com/', 'azhar', 'Diterima'),
(6, 8, 'aku lempar jir', '2026-06-17 19:31:24', 'data:image/jpeg;base64,/9j/4AAQSkZJRgABAQAAAQABAAD/2wCEAAkGBxISEhUSEhMVFRUXFxYVFhUXFRYVFxgYFxcYGBcVGBUYHSggGBolGxcVITEiJSkrLi4uFx8zODMtNygtLisBCgoKDg0OGhAQGy0lHyUtLS0rKy0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLSstLS0tLS0tLSstLS0tLS0tLf/AABEIAM8A9AMBIgACEQEDEQH/xAAbAAABBQEBAAAAAAAAAAAAAAAAAgMEBQYBB//EADgQAAEDAgMFBgUCBwEBAQAAAAEAAhEDIQQxQQUSUWFxBiKBkaHwEzKxwdFC4RQjUmJygvEHwlP/xAAZAQACAwEAAAAAAAAAAAAAAAADBAABAgX/xAAmEQACAgIDAAICAgMBAAAAAAAAAQIRAyEEEjFBURMiMlJhcaEU/9oADAMBAAIRAxEAPwD3FCEKEBclN4iu1jS5xgBZ3EbZe5x3TuiQAIm3PghZMscfpuGNz8NOhVuzMeXd14g3gjJwGfiFYrcZKStGZRcXTOoQhaKBCEKEBCEkvExIngoQUkueBmYUPH43ds3P6Klq4515g8yEOeRRCQxORoTi2f1BIdj6YvvehWPxGKd8wMD35KIMW6CZMcffglpcuvgaXEX2bV21qY/q8k43aVM6/RYtoJ71+sHyTra5GYI5+/BUuUy//LE1z9osEZm+kW55qWHBYmlif5jLj5h7laSlXR8WbvYDLhUaos11QhiYXHbQA0ReyA9GTkKLSxzHawpIKtNPwppr06hCFZQIQhQgIQhQgIQhQgio8NBJyAkqkxO3twTu2ItnPiIUnbjjDWN/UXEnTutJjzjyVDVrfDgzG7Bvr+0JTkZnDSGcOJSWyFtztAahDCQ0ATY68cuBFlCOOAG848PHSypNp4tpe95Obi4dM4z0sFU4jEuffNugGgSE7ybZ0ceJJUej7O2iHd5v6AXc9J8PytdgcSKjA8WnTgRmF4zsLaLqb90GxkQTkfwV6P2Sx4JNOcwHNnpf0jyTXGydZdWKcrFStGoQhC6AgCEIUICqdo1/5gaMxqrHEVd1pKonOG9v6iw58z5lDm/hG4L5G6j595qOaIM7wkQfC1j5p0lJcUNoKnRntoUjvW1EcLRlKMLj9yG1B/tBm2pHBXdcNcCHAT/UB9QM+qra+AMW16XHGMyLZpKeJp2hyGVNUyU+uNwkGRIjXMi8+ak1alKAN5swYnWM46T6rP8AwKlE91scswecadR+6TicewsJgtqiN0kniLDSIk5BUp0tm+l+F+3Z7SQRYwN0zkQrHAVN8Xs6YIzuJBjyKxjtr1XGd+OkA8comFYbI2sGzvaD9IF7HhYGVvHmgn9GMuKTRrH2mCouMkCffu6h4faLX95tgD8pvlxSdpbQkR76pmWSLjYtGDUqI1XERcHJT8BtpzfmMt5gqhYS6SDAAknnEho55JXx5yI6JSORp2hpwTVM32Fxjagsb8FJWAw+McwgidPBanZ21w8d6xH04p7HmUtMSy4HHa8LZC41wNxkuo4uCEIUICEIUIVPaCd2mRE/EAvlDmuafqsjt2qPhOLpJIhukEX/ADK2HaJhNBzhmwteP9XAn0lYXadUPc4G4LnQOpMG2okLnc3TQ9xDEY502OYUenUiwyXMVUlxPNNNKxWjoXsn4c95p4EfVa3Z+0XMq0nNB3gB3eIAv42jxKxVNyvsK90Mc2xADm6XacvMHzQ3rZWRdtHtdGqHNDmmQQCDxBuClqg7H40PpFuW6bD+11wPC48lfrq45qUU0cScesmgQhC2ZEVqQcIKotqtax262wiT1P8AwK8rVQ0SVl9p1N50nO/1IH0WJm4DT6yT8axEcI+/2Ueu4C4M8oP1UR+IJtkgSlQVInb6X8aBAcRyhpGtr81AbUXZKzZs5VNzYeQA8gqPardeHvyV81ihY+jIQMsHVjGGdSKHf8k5SxAA9PH39F04aO7PvSVHrCEnQ/pl/hqm6ZY6WG02JsTEjQx5ruMxQ436qp2bU', 'azhar', 'Diterima');

-- --------------------------------------------------------

--
-- Table structure for table `pengajar`
--

CREATE TABLE `pengajar` (
  `id_pengajar` int NOT NULL,
  `nip` varchar(20) COLLATE utf8mb4_general_ci NOT NULL,
  `nama_pengajar` varchar(50) COLLATE utf8mb4_general_ci NOT NULL,
  `email` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `no_hp` varchar(20) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `status_pengajar` enum('Aktif','Tidak Aktif') COLLATE utf8mb4_general_ci DEFAULT 'Aktif'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `pengajar`
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
-- Table structure for table `pengajuan_jam_plus`
--

CREATE TABLE `pengajuan_jam_plus` (
  `id_pengajuan_jam_plus` int NOT NULL,
  `id_kegiatan` int NOT NULL,
  `jumlah_jam_plus` decimal(6,2) NOT NULL,
  `jenis_jam` enum('Murni','Kompensasi') COLLATE utf8mb4_general_ci NOT NULL,
  `tanggal_pengajuan` datetime NOT NULL,
  `deskripsi_pekerjaan` text COLLATE utf8mb4_general_ci,
  `nama_pemberi` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `dokumen_url` varchar(2048) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `status_pengajuan` enum('Menunggu Verifikasi','Disetujui','Ditolak') COLLATE utf8mb4_general_ci DEFAULT 'Menunggu Verifikasi'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `pengguna`
--

CREATE TABLE `pengguna` (
  `id_pengguna` int NOT NULL,
  `id_mahasiswa` int DEFAULT NULL,
  `id_pengajar` int DEFAULT NULL,
  `username` varchar(50) COLLATE utf8mb4_general_ci NOT NULL,
  `password` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `role` enum('Mahasiswa','Pengajar','PIC Tata Tertib','PIC Aset Fasilitas','PIC Kemahasiswaan','Kepala Prodi') COLLATE utf8mb4_general_ci NOT NULL,
  `status_akun` enum('Aktif','Tidak Aktif') COLLATE utf8mb4_general_ci DEFAULT 'Aktif'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `pengguna`
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
-- Table structure for table `periode_akademik`
--

CREATE TABLE `periode_akademik` (
  `id_periode_akademik` int NOT NULL,
  `tahun_akademik` varchar(10) COLLATE utf8mb4_general_ci NOT NULL,
  `semester` enum('Ganjil','Genap') COLLATE utf8mb4_general_ci NOT NULL,
  `tanggal_mulai` datetime NOT NULL,
  `tanggal_selesai` datetime NOT NULL,
  `status_periode` enum('Aktif','Tidak Aktif') COLLATE utf8mb4_general_ci DEFAULT 'Aktif'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `periode_akademik`
--

INSERT INTO `periode_akademik` (`id_periode_akademik`, `tahun_akademik`, `semester`, `tanggal_mulai`, `tanggal_selesai`, `status_periode`) VALUES
(1, '2025/2026', 'Genap', '2026-02-01 00:00:00', '2026-07-31 23:59:59', 'Aktif');

--
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
  ADD KEY `fk_detail_fasilitas_kelas` (`id_kelas`),
  ADD KEY `fk_detail_fasilitas_fasilitas` (`id_fasilitas`);

--
-- Indexes for table `detail_kelas_pada_mata_kuliah`
--
ALTER TABLE `detail_kelas_pada_mata_kuliah`
  ADD PRIMARY KEY (`id_detail_kelas_pada_mata_kuliah`),
  ADD KEY `fk_detail_kelas_mk_mk` (`id_mata_kuliah`),
  ADD KEY `fk_detail_kelas_mk_kelas` (`id_kelas`);

--
-- Indexes for table `detail_pengajar_pada_mata_kuliah`
--
ALTER TABLE `detail_pengajar_pada_mata_kuliah`
  ADD PRIMARY KEY (`id_detail_pengajar_pada_mata_kuliah`),
  ADD KEY `fk_detail_pengajar_pengajar` (`id_pengajar`),
  ADD KEY `fk_detail_pengajar_mk` (`id_detail_kelas_pada_mata_kuliah`);

--
-- Indexes for table `detail_pengguna_pada_bursa_jobdesc`
--
ALTER TABLE `detail_pengguna_pada_bursa_jobdesc`
  ADD PRIMARY KEY (`id_detail_pengguna_pada_bursa_jobdesc`),
  ADD KEY `fk_detail_pengguna_bursa` (`id_bursa_jobdesc`),
  ADD KEY `fk_detail_bursa_pengguna` (`id_pengguna`);

--
-- Indexes for table `detail_pengguna_pada_pemberian_jam_minus`
--
ALTER TABLE `detail_pengguna_pada_pemberian_jam_minus`
  ADD PRIMARY KEY (`id_detail_pengguna_pada_pemberian_jam_minus`),
  ADD KEY `fk_detail_pengguna_jam_minus` (`id_pemberian_jam_minus`),
  ADD KEY `fk_detail_jam_minus_pengguna` (`id_pengguna`);

--
-- Indexes for table `detail_pengguna_pada_pengaduan_kerusakan_fasilitas`
--
ALTER TABLE `detail_pengguna_pada_pengaduan_kerusakan_fasilitas`
  ADD PRIMARY KEY (`id_detail_pengguna_pada_pengaduan_kerusakan_fasilitas`),
  ADD KEY `fk_detail_pengguna_pengaduan` (`id_pengaduan_kerusakan_fasilitas`),
  ADD KEY `fk_detail_pengaduan_pengguna` (`id_pengguna`);

--
-- Indexes for table `detail_pengguna_pada_pengajuan_jam_plus`
--
ALTER TABLE `detail_pengguna_pada_pengajuan_jam_plus`
  ADD PRIMARY KEY (`id_detail_pengguna_pada_pengajuan_jam_plus`),
  ADD KEY `fk_detail_pengguna_pengajuan` (`id_pengajuan_jam_plus`),
  ADD KEY `fk_detail_pengajuan_pengguna` (`id_pengguna`);

--
-- Indexes for table `fasilitas`
--
ALTER TABLE `fasilitas`
  ADD PRIMARY KEY (`id_fasilitas`);

--
-- Indexes for table `kegiatan`
--
ALTER TABLE `kegiatan`
  ADD PRIMARY KEY (`id_kegiatan`);

--
-- Indexes for table `kelas`
--
ALTER TABLE `kelas`
  ADD PRIMARY KEY (`id_kelas`);

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
  ADD PRIMARY KEY (`id_pemberian_jam_minus`);

--
-- Indexes for table `pengaduan_kerusakan_fasilitas`
--
ALTER TABLE `pengaduan_kerusakan_fasilitas`
  ADD PRIMARY KEY (`id_pengaduan_kerusakan_fasilitas`),
  ADD KEY `fk_pengaduan_fasilitas` (`id_fasilitas`);

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
  ADD KEY `fk_pengguna_mahasiswa` (`id_mahasiswa`),
  ADD KEY `fk_pengguna_pengajar` (`id_pengajar`);

--
-- Indexes for table `periode_akademik`
--
ALTER TABLE `periode_akademik`
  ADD PRIMARY KEY (`id_periode_akademik`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `bursa_jobdesc`
--
ALTER TABLE `bursa_jobdesc`
  MODIFY `id_bursa_jobdesc` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `detail_fasilitas_pada_kelas`
--
ALTER TABLE `detail_fasilitas_pada_kelas`
  MODIFY `id_detail_fasilitas_pada_kelas` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `detail_kelas_pada_mata_kuliah`
--
ALTER TABLE `detail_kelas_pada_mata_kuliah`
  MODIFY `id_detail_kelas_pada_mata_kuliah` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `detail_pengajar_pada_mata_kuliah`
--
ALTER TABLE `detail_pengajar_pada_mata_kuliah`
  MODIFY `id_detail_pengajar_pada_mata_kuliah` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `detail_pengguna_pada_bursa_jobdesc`
--
ALTER TABLE `detail_pengguna_pada_bursa_jobdesc`
  MODIFY `id_detail_pengguna_pada_bursa_jobdesc` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=25;

--
-- AUTO_INCREMENT for table `detail_pengguna_pada_pemberian_jam_minus`
--
ALTER TABLE `detail_pengguna_pada_pemberian_jam_minus`
  MODIFY `id_detail_pengguna_pada_pemberian_jam_minus` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `detail_pengguna_pada_pengaduan_kerusakan_fasilitas`
--
ALTER TABLE `detail_pengguna_pada_pengaduan_kerusakan_fasilitas`
  MODIFY `id_detail_pengguna_pada_pengaduan_kerusakan_fasilitas` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT for table `detail_pengguna_pada_pengajuan_jam_plus`
--
ALTER TABLE `detail_pengguna_pada_pengajuan_jam_plus`
  MODIFY `id_detail_pengguna_pada_pengajuan_jam_plus` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `fasilitas`
--
ALTER TABLE `fasilitas`
  MODIFY `id_fasilitas` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `kegiatan`
--
ALTER TABLE `kegiatan`
  MODIFY `id_kegiatan` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `kelas`
--
ALTER TABLE `kelas`
  MODIFY `id_kelas` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `mahasiswa`
--
ALTER TABLE `mahasiswa`
  MODIFY `id_mahasiswa` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT for table `mata_kuliah`
--
ALTER TABLE `mata_kuliah`
  MODIFY `id_matakuliah` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `pemberian_jam_minus`
--
ALTER TABLE `pemberian_jam_minus`
  MODIFY `id_pemberian_jam_minus` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `pengaduan_kerusakan_fasilitas`
--
ALTER TABLE `pengaduan_kerusakan_fasilitas`
  MODIFY `id_pengaduan_kerusakan_fasilitas` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `pengajar`
--
ALTER TABLE `pengajar`
  MODIFY `id_pengajar` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `pengajuan_jam_plus`
--
ALTER TABLE `pengajuan_jam_plus`
  MODIFY `id_pengajuan_jam_plus` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `pengguna`
--
ALTER TABLE `pengguna`
  MODIFY `id_pengguna` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=20;

--
-- AUTO_INCREMENT for table `periode_akademik`
--
ALTER TABLE `periode_akademik`
  MODIFY `id_periode_akademik` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

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
-- Constraints for table `detail_pengajar_pada_mata_kuliah`
--
ALTER TABLE `detail_pengajar_pada_mata_kuliah`
  ADD CONSTRAINT `fk_detail_pengajar_mk` FOREIGN KEY (`id_detail_kelas_pada_mata_kuliah`) REFERENCES `detail_kelas_pada_mata_kuliah` (`id_detail_kelas_pada_mata_kuliah`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_detail_pengajar_pengajar` FOREIGN KEY (`id_pengajar`) REFERENCES `pengajar` (`id_pengajar`) ON DELETE CASCADE ON UPDATE CASCADE;

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
-- Constraints for table `pengaduan_kerusakan_fasilitas`
--
ALTER TABLE `pengaduan_kerusakan_fasilitas`
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
  ADD CONSTRAINT `fk_pengguna_mahasiswa` FOREIGN KEY (`id_mahasiswa`) REFERENCES `mahasiswa` (`id_mahasiswa`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_pengguna_pengajar` FOREIGN KEY (`id_pengajar`) REFERENCES `pengajar` (`id_pengajar`) ON DELETE SET NULL ON UPDATE CASCADE;


-- --------------------------------------------------------

--
-- Stored functions and procedures
--

DELIMITER $$
DROP FUNCTION IF EXISTS `ufn_cari_id_kelas_di_table_detail_fasilitas_pada_kelas`$$
DROP FUNCTION IF EXISTS `ufn_total_jam_minus_mahasiswa`$$
DROP PROCEDURE IF EXISTS `usp_daftar_bursa_jobdesc`$$
DROP PROCEDURE IF EXISTS `usp_insert_bursa_jobdesc`$$
DROP PROCEDURE IF EXISTS `usp_insert_detail_fasilitas_pada_kelas`$$
DROP PROCEDURE IF EXISTS `usp_insert_detail_pengguna_pada_pengaduan_kerusakan_fasilitas`$$
DROP PROCEDURE IF EXISTS `usp_insert_fasilitas`$$
DROP PROCEDURE IF EXISTS `usp_insert_kelas`$$
DROP PROCEDURE IF EXISTS `usp_insert_mahasiswa`$$
DROP PROCEDURE IF EXISTS `usp_insert_pengaduan_kerusakan_fasilitas`$$
DROP PROCEDURE IF EXISTS `usp_insert_pengajar`$$
DROP PROCEDURE IF EXISTS `usp_insert_pengguna`$$
DROP PROCEDURE IF EXISTS `usp_select_bursa_jobdesc`$$
DROP PROCEDURE IF EXISTS `usp_select_fasilitas`$$
DROP PROCEDURE IF EXISTS `usp_select_kelas`$$
DROP PROCEDURE IF EXISTS `usp_select_mahasiswa`$$
DROP PROCEDURE IF EXISTS `usp_select_pengaduan_kerusakan_fasilitas`$$
DROP PROCEDURE IF EXISTS `usp_select_pengajar`$$
DROP PROCEDURE IF EXISTS `usp_select_pengguna`$$
DROP PROCEDURE IF EXISTS `usp_selesaikan_bursa_jobdesc`$$
DROP PROCEDURE IF EXISTS `usp_soft_delete_fasilitas`$$
DROP PROCEDURE IF EXISTS `usp_soft_delete_kelas`$$
DROP PROCEDURE IF EXISTS `usp_soft_delete_mahasiswa`$$
DROP PROCEDURE IF EXISTS `usp_soft_delete_pengajar`$$
DROP PROCEDURE IF EXISTS `usp_soft_delete_pengguna`$$
DROP PROCEDURE IF EXISTS `usp_update_bukti_selesai_url_bursa_jobdesc`$$
DROP PROCEDURE IF EXISTS `usp_update_detail_fasilitas_pada_kelas`$$
DROP PROCEDURE IF EXISTS `usp_update_fasilitas`$$
DROP PROCEDURE IF EXISTS `usp_update_jumlah_mahasiswa_mengambil_bursa_jobdesc`$$
DROP PROCEDURE IF EXISTS `usp_update_kelas`$$
DROP PROCEDURE IF EXISTS `usp_update_mahasiswa`$$
DROP PROCEDURE IF EXISTS `usp_update_pengajar`$$
DROP PROCEDURE IF EXISTS `usp_update_pengguna`$$
DROP PROCEDURE IF EXISTS `usp_update_status_bursa_jobdesc`$$
DROP PROCEDURE IF EXISTS `usp_update_status_detail_fasilitas_pada_kelas`$$
DROP PROCEDURE IF EXISTS `usp_update_status_pengaduan_kerusakan_fasilitas`$$

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

CREATE FUNCTION `ufn_total_jam_minus_mahasiswa` (`p_id_mahasiswa` INT) RETURNS DECIMAL(10,2) READS SQL DATA BEGIN
    DECLARE v_minus_murni DECIMAL(10,2) DEFAULT 0;
    DECLARE v_minus_kompensasi DECIMAL(10,2) DEFAULT 0;
    DECLARE v_plus_murni DECIMAL(10,2) DEFAULT 0;
    DECLARE v_plus_kompensasi DECIMAL(10,2) DEFAULT 0;

    DECLARE v_sisa_minus_murni DECIMAL(10,2) DEFAULT 0;
    DECLARE v_sisa_minus_kompensasi DECIMAL(10,2) DEFAULT 0;
    DECLARE v_sisa_plus_kompensasi DECIMAL(10,2) DEFAULT 0;

    DECLARE v_data_ditemukan TINYINT DEFAULT 1;

    DECLARE CONTINUE HANDLER FOR NOT FOUND
    SET v_data_ditemukan = 0;

    SELECT
        COALESCE(saldo_jam_minus_murni, 0),
        COALESCE(saldo_jam_minus_kompensasi, 0),
        COALESCE(saldo_jam_plus_murni, 0),
        COALESCE(saldo_jam_plus_kompensasi, 0)
    INTO
        v_minus_murni,
        v_minus_kompensasi,
        v_plus_murni,
        v_plus_kompensasi
    FROM mahasiswa
    WHERE id_mahasiswa = p_id_mahasiswa
    LIMIT 1;

    IF v_data_ditemukan = 0 THEN
        RETURN 0;
    END IF;

    SET v_sisa_minus_kompensasi = GREATEST(0, v_minus_kompensasi - v_plus_kompensasi);

    SET v_sisa_plus_kompensasi = GREATEST(0, v_plus_kompensasi - v_minus_kompensasi);

    SET v_sisa_minus_murni = GREATEST(0, v_minus_murni - v_plus_murni);

    SET v_sisa_minus_murni = GREATEST(0, v_sisa_minus_murni - v_sisa_plus_kompensasi);

    RETURN v_sisa_minus_murni + v_sisa_minus_kompensasi;
END$$

CREATE PROCEDURE `usp_daftar_bursa_jobdesc` (IN `p_id_bursa_jobdesc` INT, IN `p_id_pengguna` INT)   BEGIN
    DECLARE v_role VARCHAR(30);
    DECLARE v_id_mahasiswa INT;
    DECLARE v_penerima_jobdesc VARCHAR(30);
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

    IF v_penerima_jobdesc = 'Yang memiliki jam minus' THEN
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
            WHEN jumlah_mahasiswa_mengambil >= jumlah_mahasiswa_diperlukan THEN 'Dikerjakan'
            ELSE 'Dibuka'
        END
    WHERE id_bursa_jobdesc = p_id_bursa_jobdesc;

    COMMIT;

    SELECT 
        'Pendaftaran bursa jobdesc berhasil' AS Pesan,
        p_id_bursa_jobdesc AS id_bursa_jobdesc;
END$$

CREATE PROCEDURE `usp_insert_bursa_jobdesc` (IN `p_id_pengguna` INT, IN `p_deskripsi_jobdesc` TEXT, IN `p_penerima_jobdesc` VARCHAR(50), IN `p_jam_plus` DECIMAL(6,2), IN `p_tanggal_pemberian_jobdesc` DATETIME, IN `p_jumlah_mahasiswa_diperlukan` INT, IN `p_jam_pengerjaan` TIME)   BEGIN
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

    IF p_penerima_jobdesc NOT IN ('Semua mahasiswa', 'Yang memiliki jam minus') THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Pilihan penerima jobdesc tidak valid';
    END IF;

    START TRANSACTION;

    INSERT INTO bursa_jobdesc (
        deskripsi_jobdesc,
        penerima_jobdesc,
        jam_plus,
        tanggal_pemberian_jobdesc,
        jumlah_mahasiswa_diperlukan,
        jumlah_mahasiswa_mengambil,
        jam_pengerjaan,
        status_jobdesc
    )
    VALUES (
        p_deskripsi_jobdesc,
        p_penerima_jobdesc,
        p_jam_plus,
        p_tanggal_pemberian_jobdesc,
        p_jumlah_mahasiswa_diperlukan,
        0,
        p_jam_pengerjaan,
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
        'Data bursa jobdesc berhasil ditambahkan' AS Pesan,
        v_id_bursa_jobdesc AS id_bursa_jobdesc_baru;
END$$

CREATE PROCEDURE `usp_insert_detail_fasilitas_pada_kelas` (IN `p_id_kelas` INT, IN `p_id_fasilitas` INT, IN `p_jumlah_fasilitas` INT)   BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        RESIGNAL;
    END;

    INSERT INTO detail_fasilitas_pada_kelas (
        id_kelas,
        id_fasilitas,
        jumlah_fasilitas
    )
    VALUES (
        p_id_kelas,
        p_id_fasilitas,
        p_jumlah_fasilitas
    );
END$$

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

CREATE PROCEDURE `usp_insert_fasilitas` (IN `p_id_kelas` INT, IN `p_nama_fasilitas` VARCHAR(50), IN `p_harga` DECIMAL(15,2), IN `p_jumlah_fasilitas` INT)   BEGIN
	DECLARE v_id_fasilitas INT;
    
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
    	ROLLBACK;
        RESIGNAL;
    END;
    
    START TRANSACTION;

    INSERT INTO fasilitas (
        nama_fasilitas,
        harga,
        tanggal_pendataan
    )
    VALUES (
        p_nama_fasilitas,
        p_harga,
        NOW()
    );
    
    SET v_id_fasilitas = LAST_INSERT_ID();
    
    CALL usp_insert_detail_fasilitas_pada_kelas(
    	p_id_kelas,
        v_id_fasilitas,
        p_jumlah_fasilitas
    );
    
    COMMIT;

    SELECT 
        'Data fasilitas berhasil ditambahkan' AS Pesan,
        v_id_fasilitas AS id_fasilitas_baru;
END$$

CREATE PROCEDURE `usp_insert_kelas` (IN `p_nama_kelas` VARCHAR(5), IN `p_tingkat` VARCHAR(1))   BEGIN
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

CREATE PROCEDURE `usp_insert_mahasiswa` (IN `p_id_kelas` INT, IN `p_id_periode_akademik` INT, IN `p_nim` VARCHAR(20), IN `p_nama_mahasiswa` VARCHAR(50), IN `p_email` VARCHAR(50), IN `p_no_hp` VARCHAR(20))   BEGIN
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

CREATE PROCEDURE `usp_insert_pengaduan_kerusakan_fasilitas` (IN `p_id_fasilitas` INT, IN `p_id_pengguna` INT, IN `p_deskripsi_kerusakan` TEXT, IN `p_bukti_kerusakan_url` VARCHAR(2048), IN `p_pelaku_kerusakan` VARCHAR(50))   BEGIN
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

CREATE PROCEDURE `usp_insert_pengajar` (IN `p_nip` VARCHAR(20), IN `p_nama_pengajar` VARCHAR(50), IN `p_email` VARCHAR(50), IN `p_no_hp` VARCHAR(20))   BEGIN
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

CREATE PROCEDURE `usp_insert_pengguna` (IN `p_id_mahasiswa` INT, IN `p_id_pengajar` INT, IN `p_username` VARCHAR(50), IN `p_password` VARCHAR(255), IN `p_role` VARCHAR(30))   BEGIN
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

CREATE PROCEDURE `usp_select_bursa_jobdesc` ()   BEGIN
    SELECT
        bj.id_bursa_jobdesc,
        bj.deskripsi_jobdesc,
        bj.penerima_jobdesc,
        bj.jam_plus,
        bj.tanggal_pemberian_jobdesc,
        bj.jumlah_mahasiswa_diperlukan,
        bj.jumlah_mahasiswa_mengambil,
        bj.jam_pengerjaan,
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

CREATE PROCEDURE `usp_select_fasilitas` ()   BEGIN
    SELECT
        f.id_fasilitas,
        f.nama_fasilitas,
        f.harga,
        f.status_fasilitas,
        f.tanggal_pendataan,

        dfpk.id_detail_fasilitas_pada_kelas,
        dfpk.id_kelas,
        k.nama_kelas,
        k.tingkat,
        dfpk.jumlah_fasilitas,
        dfpk.status_detail_fasilitas_pada_kelas

    FROM fasilitas AS f
    LEFT JOIN detail_fasilitas_pada_kelas AS dfpk 
        ON f.id_fasilitas = dfpk.id_fasilitas
    LEFT JOIN kelas AS k 
        ON dfpk.id_kelas = k.id_kelas
    ORDER BY f.id_fasilitas ASC;
END$$

CREATE PROCEDURE `usp_select_kelas` ()   BEGIN
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

CREATE PROCEDURE `usp_select_mahasiswa` ()   BEGIN
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

CREATE PROCEDURE `usp_select_pengaduan_kerusakan_fasilitas` ()   BEGIN
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

CREATE PROCEDURE `usp_select_pengajar` ()   BEGIN
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

CREATE PROCEDURE `usp_select_pengguna` ()   BEGIN
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

CREATE PROCEDURE `usp_selesaikan_bursa_jobdesc` (IN `p_id_bursa_jobdesc` INT, IN `p_id_pemberi` INT)   BEGIN
    DECLARE v_status_jobdesc VARCHAR(20);
    DECLARE v_bukti_selesai_url TEXT;

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
        bukti_selesai_url
    INTO
        v_status_jobdesc,
        v_bukti_selesai_url
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

    UPDATE bursa_jobdesc
    SET status_jobdesc = 'Selesai'
    WHERE id_bursa_jobdesc = p_id_bursa_jobdesc;

    COMMIT;

    SELECT
        'Status bursa jobdesc berhasil diubah menjadi Selesai' AS Pesan,
        p_id_bursa_jobdesc AS id_bursa_jobdesc;
END$$

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

CREATE PROCEDURE `usp_update_detail_fasilitas_pada_kelas` (IN `p_id_kelas` INT, IN `p_id_fasilitas` INT, IN `p_jumlah_fasilitas` INT)   BEGIN
    IF NOT EXISTS (
        SELECT 1 
        FROM detail_fasilitas_pada_kelas
        WHERE id_fasilitas = p_id_fasilitas
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Data detail fasilitas pada kelas tidak ditemukan';
    END IF;

    UPDATE detail_fasilitas_pada_kelas
    SET
        id_kelas = p_id_kelas,
        jumlah_fasilitas = p_jumlah_fasilitas
    WHERE id_fasilitas = p_id_fasilitas;
END$$

CREATE PROCEDURE `usp_update_fasilitas` (IN `p_id_fasilitas` INT, IN `p_id_kelas` INT, IN `p_nama_fasilitas` VARCHAR(50), IN `p_harga` DECIMAL(15,2), IN `p_jumlah_fasilitas` INT)   BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    IF NOT EXISTS (
        SELECT 1 
        FROM fasilitas
        WHERE id_fasilitas = p_id_fasilitas
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Data fasilitas tidak ditemukan';
    END IF;

    START TRANSACTION;

    UPDATE fasilitas
    SET
        nama_fasilitas = p_nama_fasilitas,
        harga = p_harga
    WHERE id_fasilitas = p_id_fasilitas;

    CALL usp_update_detail_fasilitas_pada_kelas(
        p_id_kelas,
        p_id_fasilitas,
        p_jumlah_fasilitas
    );

    COMMIT;

    SELECT 
        'Data fasilitas berhasil diupdate' AS Pesan,
        p_id_fasilitas AS id_fasilitas;
END$$

CREATE PROCEDURE `usp_update_jumlah_mahasiswa_mengambil_bursa_jobdesc` (IN `p_id_bursa_jobdesc` INT, IN `p_id_pengguna` INT)   BEGIN
    DECLARE v_jumlah_mahasiswa_diperlukan INT;
    DECLARE v_jumlah_mahasiswa_mengambil INT;
    
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;
    
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
        AND peran_pengguna = 'Penerima'
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Pengguna sudah mengambil bursa jobdesc ini';
    END IF;
    
    START TRANSACTION;
    
    SELECT jumlah_mahasiswa_diperlukan, jumlah_mahasiswa_mengambil
    INTO v_jumlah_mahasiswa_diperlukan, v_jumlah_mahasiswa_mengambil
    FROM bursa_jobdesc
    WHERE id_bursa_jobdesc = p_id_bursa_jobdesc
    FOR UPDATE;
    
    IF v_jumlah_mahasiswa_mengambil >= v_jumlah_mahasiswa_diperlukan THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Jumlah mahasiswa sudah mencukupi';
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
END$$

CREATE PROCEDURE `usp_update_kelas` (IN `p_id_kelas` INT, IN `p_nama_kelas` VARCHAR(5), IN `p_tingkat` VARCHAR(1))   BEGIN
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

CREATE PROCEDURE `usp_update_mahasiswa` (IN `p_id_mahasiswa` INT, IN `p_id_kelas` INT, IN `p_id_periode_akademik` INT, IN `p_nim` VARCHAR(20), IN `p_nama_mahasiswa` VARCHAR(50), IN `p_email` VARCHAR(50), IN `p_no_hp` VARCHAR(20), IN `p_status_mahasiswa` VARCHAR(20))   BEGIN
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

CREATE PROCEDURE `usp_update_pengajar` (IN `p_id_pengajar` INT, IN `p_nip` VARCHAR(20), IN `p_nama_pengajar` VARCHAR(50), IN `p_email` VARCHAR(50), IN `p_no_hp` VARCHAR(20))   BEGIN
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

CREATE PROCEDURE `usp_update_pengguna` (IN `p_id_pengguna` INT, IN `p_id_mahasiswa` INT, IN `p_id_pengajar` INT, IN `p_username` VARCHAR(50), IN `p_password` VARCHAR(255), IN `p_role` VARCHAR(30))   BEGIN
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

CREATE PROCEDURE `usp_update_status_detail_fasilitas_pada_kelas` (IN `p_id_pengguna` INT, IN `p_id_fasilitas` INT, IN `p_status_detail_fasilitas_pada_kelas` VARCHAR(20))   BEGIN
	DECLARE v_id_kelas INT;
    
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        RESIGNAL;
    END;
    
    SET v_id_kelas = ufn_cari_id_kelas_di_table_detail_fasilitas_pada_kelas(p_id_pengguna);
    
    IF v_id_kelas IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'ID kelas tidak ditemukan dari pengguna';
    END IF;

    IF NOT EXISTS (
        SELECT 1 FROM detail_fasilitas_pada_kelas
        WHERE id_kelas = v_id_kelas
        	AND id_fasilitas = p_id_fasilitas
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Data detail_fasilitas_pada_kelas tidak ditemukan';
    END IF;
    
    IF p_status_detail_fasilitas_pada_kelas NOT IN ('Aktif', 'Rusak') THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Status fasilitas pada kelas tidak valid';
    END IF;

    UPDATE detail_fasilitas_pada_kelas
    SET
        status_detail_fasilitas_pada_kelas = p_status_detail_fasilitas_pada_kelas
    WHERE id_kelas = v_id_kelas
        AND id_fasilitas = p_id_fasilitas;
END$$

CREATE PROCEDURE `usp_update_status_pengaduan_kerusakan_fasilitas` (IN `p_id_pengaduan_kerusakan_fasilitas` INT, IN `p_id_pengguna` INT, IN `p_status_pengaduan` VARCHAR(20))   BEGIN
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
DELIMITER ;

SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
