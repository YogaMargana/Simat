<?php

require_once "../../config/koneksi.php";
require_once "../../config/function.php";
require_once "../../includes/auth_dashboard.php";
require_once "../../assets/vendor/fpdf19/fpdf.php";

cek_role_dashboard("PIC Tata Tertib");

date_default_timezone_set("Asia/Jakarta");

$data_laporan = [];

$sql = "
    SELECT
        nim,
        nama_mahasiswa,
        nama_kelas,
        total_jam_kompensasi,
        total_jam_murni,
        total_jam_mahasiswa
    FROM vw_laporan_total_jam_mahasiswa
    ORDER BY nama_kelas ASC, nim ASC, nama_mahasiswa ASC
";

$query = mysqli_query($koneksi, $sql);

if (!$query) {
    die("Gagal mengambil data laporan: " . mysqli_error($koneksi));
}

while ($row = mysqli_fetch_assoc($query)) {
    $data_laporan[] = $row;
}

mysqli_free_result($query);

function pdf_text($text)
{
    $text = (string) $text;

    $converted = @iconv("UTF-8", "ISO-8859-1//TRANSLIT", $text);

    if ($converted === false) {
        return utf8_decode($text);
    }

    return $converted;
}

class PDFLaporanTotalJamMahasiswa extends FPDF
{
    public function Header()
    {
        $this->SetFont("Arial", "B", 14);
        $this->Cell(0, 8, pdf_text("LAPORAN TOTAL JAM MAHASISWA"), 0, 1, "C");

        $this->SetFont("Arial", "", 10);
        $this->Cell(0, 6, pdf_text("SIMAT - PIC Tata Tertib"), 0, 1, "C");

        $this->Ln(4);

        $this->SetFont("Arial", "", 9);
        $this->Cell(0, 6, pdf_text("Tanggal Cetak: " . date("d/m/Y H:i")), 0, 1, "R");

        $this->Ln(2);
    }

    public function Footer()
    {
        $this->SetY(-15);
        $this->SetFont("Arial", "I", 8);
        $this->Cell(0, 10, pdf_text("Halaman " . $this->PageNo() . " dari {nb}"), 0, 0, "C");
    }

    public function TableNote()
    {
        $this->SetFont("Arial", "", 8);

        $this->MultiCell(
            0,
            5,
            pdf_text(
                "Aturan Perhitungan: Jam plus murni tidak bisa membayar jam minus kompensasi. " .
                "Jam plus kompensasi digunakan untuk membayar jam minus kompensasi terlebih dahulu. " .
                "Jika masih ada sisa jam plus kompensasi, sisanya dapat digunakan untuk membayar jam minus murni."
            ),
            0,
            "L"
        );

        $this->Ln(2);
    }

    public function TableHeader()
    {
        $this->SetFont("Arial", "B", 9);
        $this->SetFillColor(230, 230, 230);

        $this->Cell(10, 8, "No", 1, 0, "C", true);
        $this->Cell(35, 8, pdf_text("NIM"), 1, 0, "C", true);
        $this->Cell(75, 8, pdf_text("Nama Mahasiswa"), 1, 0, "C", true);
        $this->Cell(30, 8, pdf_text("Kelas"), 1, 0, "C", true);
        $this->Cell(42, 8, pdf_text("Total Kompensasi"), 1, 0, "C", true);
        $this->Cell(42, 8, pdf_text("Total Murni"), 1, 0, "C", true);
        $this->Cell(42, 8, pdf_text("Total Jam"), 1, 1, "C", true);
    }
}

$pdf = new PDFLaporanTotalJamMahasiswa("L", "mm", "A4");
$pdf->AliasNbPages();
$pdf->SetMargins(10, 10, 10);
$pdf->AddPage();

$pdf->TableNote();
$pdf->TableHeader();

$pdf->SetFont("Arial", "", 9);

$no = 1;

if (count($data_laporan) > 0) {
    foreach ($data_laporan as $row) {
        if ($pdf->GetY() > 185) {
            $pdf->AddPage();
            $pdf->TableNote();
            $pdf->TableHeader();
            $pdf->SetFont("Arial", "", 9);
        }

        $pdf->Cell(10, 7, $no++, 1, 0, "C");
        $pdf->Cell(35, 7, pdf_text($row["nim"]), 1, 0, "C");
        $pdf->Cell(75, 7, pdf_text($row["nama_mahasiswa"]), 1, 0, "L");
        $pdf->Cell(30, 7, pdf_text($row["nama_kelas"]), 1, 0, "C");
        $pdf->Cell(42, 7, format_jam($row["total_jam_kompensasi"]), 1, 0, "R");
        $pdf->Cell(42, 7, format_jam($row["total_jam_murni"]), 1, 0, "R");
        $pdf->Cell(42, 7, format_jam($row["total_jam_mahasiswa"]), 1, 1, "R");
    }
} else {
    $pdf->Cell(276, 8, pdf_text("Belum ada data mahasiswa aktif."), 1, 1, "C");
}

$nama_file = "laporan-total-jam-mahasiswa-" . date("Ymd-His") . ".pdf";

$pdf->Output("I", $nama_file);
exit;

?>