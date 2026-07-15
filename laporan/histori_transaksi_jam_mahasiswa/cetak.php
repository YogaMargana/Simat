<?php
require_once "../../config/koneksi.php";
require_once "../../config/function.php";
require_once "../../includes/auth_dashboard.php";
require_once "../../assets/vendor/fpdf19/fpdf.php";

cek_role_dashboard("Mahasiswa");
date_default_timezone_set("Asia/Jakarta");

$id_pengguna = (int) ($_SESSION['id_pengguna'] ?? 0);
$jenis_filter = $_GET['filter'] ?? 'semua';
$nilai_filter = trim($_GET['nilai'] ?? '');
if (!in_array($jenis_filter, ['semua', 'tanggal', 'bulan', 'tahun'], true)) {
    $jenis_filter = 'semua';
}
$pesan_filter = '';
$rentang = rentang_filter_tanggal($jenis_filter, $nilai_filter, $pesan_filter);
if ($rentang === false) {
    die('Filter laporan tidak valid.');
}
[$tanggal_mulai, $tanggal_selesai] = $rentang;

$data_laporan = [];
$stmt = mysqli_prepare($koneksi, "CALL usp_select_laporan_histori_jam_mahasiswa_filter(?, ?, ?)");
if (!$stmt) {
    die('Gagal menyiapkan laporan.');
}
mysqli_stmt_bind_param($stmt, "iss", $id_pengguna, $tanggal_mulai, $tanggal_selesai);
if (!mysqli_stmt_execute($stmt)) {
    mysqli_stmt_close($stmt);
    die('Gagal mengambil data laporan.');
}
$result = mysqli_stmt_get_result($stmt);
while ($result && $row = mysqli_fetch_assoc($result)) {
    $data_laporan[] = $row;
}
if ($result) {
    mysqli_free_result($result);
}
mysqli_stmt_close($stmt);
bersihkan_hasil_procedure($koneksi);

function pdf_text_histori($text)
{
    $converted = @iconv('UTF-8', 'ISO-8859-1//TRANSLIT', (string) $text);
    return $converted === false ? utf8_decode((string) $text) : $converted;
}

function format_tanggal_pdf_histori($tanggal)
{
    if (empty($tanggal)) {
        return '-';
    }
    $timestamp = strtotime($tanggal);
    return $timestamp === false ? $tanggal : date('d/m/Y H:i', $timestamp);
}

class PDFHistoriJam extends FPDF
{
    private $widths = [10, 35, 38, 90, 26, 26, 26, 26];
    private $aligns = ['C', 'C', 'L', 'L', 'R', 'R', 'R', 'R'];

    public function Header()
    {
        $this->SetFont('Arial', 'B', 14);
        $this->Cell(0, 8, pdf_text_histori('LAPORAN HISTORI TRANSAKSI JAM'), 0, 1, 'C');
        $this->SetFont('Arial', '', 10);
        $this->Cell(0, 6, pdf_text_histori('SIMAT - Mahasiswa: ' . ($_SESSION['username'] ?? '-')), 0, 1, 'C');
        $this->SetFont('Arial', '', 9);
        $this->Cell(0, 6, pdf_text_histori('Tanggal Cetak: ' . date('d/m/Y H:i')), 0, 1, 'R');
        $this->Ln(2);
    }

    public function Footer()
    {
        $this->SetY(-15);
        $this->SetFont('Arial', 'I', 8);
        $this->Cell(0, 10, pdf_text_histori('Halaman ' . $this->PageNo() . ' dari {nb}'), 0, 0, 'C');
    }

    public function TableHeader()
    {
        $this->SetFont('Arial', 'B', 7);
        $this->SetFillColor(230, 230, 230);
        $judul = ['No', 'Tanggal', 'Jenis', 'Deskripsi', 'Plus Komp.', 'Minus Komp.', 'Plus Murni', 'Minus Murni'];
        foreach ($judul as $i => $teks) {
            $this->Cell($this->widths[$i], 8, pdf_text_histori($teks), 1, $i === count($judul) - 1 ? 1 : 0, 'C', true);
        }
    }

    public function Row(array $data)
    {
        $maks = 1;
        foreach ($data as $i => $teks) {
            $maks = max($maks, $this->NbLines($this->widths[$i], pdf_text_histori($teks)));
        }
        $tinggi = 5 * $maks;
        if ($this->GetY() + $tinggi > $this->PageBreakTrigger) {
            $this->AddPage();
            $this->TableHeader();
            $this->SetFont('Arial', '', 7);
        }
        foreach ($data as $i => $teks) {
            $x = $this->GetX();
            $y = $this->GetY();
            $this->Rect($x, $y, $this->widths[$i], $tinggi);
            $this->MultiCell($this->widths[$i], 5, pdf_text_histori($teks), 0, $this->aligns[$i]);
            $this->SetXY($x + $this->widths[$i], $y);
        }
        $this->Ln($tinggi);
    }

    private function NbLines($width, $text)
    {
        $cw = &$this->CurrentFont['cw'];
        $wmax = ($width - 2 * $this->cMargin) * 1000 / $this->FontSize;
        $text = str_replace("\r", '', (string) $text);
        $nb = strlen($text);
        if ($nb > 0 && $text[$nb - 1] === "\n") {
            $nb--;
        }
        $sep = -1;
        $i = 0;
        $j = 0;
        $l = 0;
        $nl = 1;
        while ($i < $nb) {
            $c = $text[$i];
            if ($c === "\n") {
                $i++;
                $sep = -1;
                $j = $i;
                $l = 0;
                $nl++;
                continue;
            }
            if ($c === ' ') {
                $sep = $i;
            }
            $l += $cw[$c] ?? 0;
            if ($l > $wmax) {
                if ($sep === -1) {
                    if ($i === $j) {
                        $i++;
                    }
                } else {
                    $i = $sep + 1;
                }
                $sep = -1;
                $j = $i;
                $l = 0;
                $nl++;
            } else {
                $i++;
            }
        }
        return $nl;
    }
}

$pdf = new PDFHistoriJam('L', 'mm', 'A4');
$pdf->AliasNbPages();
$pdf->SetMargins(10, 10, 10);
$pdf->AddPage();
$pdf->TableHeader();
$pdf->SetFont('Arial', '', 7);

$no = 1;
if ($data_laporan) {
    foreach ($data_laporan as $row) {
        $pdf->Row([
            $no++,
            format_tanggal_pdf_histori($row['tanggal_transaksi']),
            $row['jenis_transaksi'],
            $row['deskripsi'],
            format_jam($row['saldo_jam_plus_kompensasi']),
            format_jam($row['saldo_jam_minus_kompensasi']),
            format_jam($row['saldo_jam_plus_murni']),
            format_jam($row['saldo_jam_minus_murni']),
        ]);
    }
} else {
    $pdf->Cell(277, 8, pdf_text_histori('Tidak ada histori transaksi jam sesuai filter.'), 1, 1, 'C');
}

$pdf->Output('I', 'laporan-histori-jam-' . date('Ymd-His') . '.pdf');
exit;
