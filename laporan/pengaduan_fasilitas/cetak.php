<?php

require_once "../../config/koneksi.php";
require_once "../../config/function.php";
require_once "../../includes/auth_dashboard.php";
require_once "../../assets/vendor/fpdf19/fpdf.php";

cek_role_dashboard("PIC Aset Fasilitas");

date_default_timezone_set("Asia/Jakarta");

$data_laporan = [];

$query = mysqli_query(
    $koneksi,
    "CALL usp_select_laporan_pengaduan_fasilitas()"
);

if (!$query) {
    die("Gagal mengambil data laporan: " . mysqli_error($koneksi));
}

while ($row = mysqli_fetch_assoc($query)) {
    $data_laporan[] = $row;
}

mysqli_free_result($query);

while (mysqli_more_results($koneksi)) {
    mysqli_next_result($koneksi);

    if ($extra_result = mysqli_store_result($koneksi)) {
        mysqli_free_result($extra_result);
    }
}

function pdf_text($text)
{
    $text = (string) $text;

    $converted = @iconv("UTF-8", "ISO-8859-1//TRANSLIT", $text);

    if ($converted === false) {
        return utf8_decode($text);
    }

    return $converted;
}

function format_tanggal_pdf_pengaduan($tanggal)
{
    if (empty($tanggal)) {
        return "-";
    }

    $timestamp = strtotime($tanggal);

    if ($timestamp === false) {
        return $tanggal;
    }

    return date("d/m/Y H:i", $timestamp);
}

class PDFLaporanPengaduanFasilitas extends FPDF
{
    private $widths;
    private $aligns;

    public function Header()
    {
        $this->SetFont("Arial", "B", 14);
        $this->Cell(0, 8, pdf_text("LAPORAN PENGADUAN FASILITAS"), 0, 1, "C");

        $this->SetFont("Arial", "", 10);
        $this->Cell(0, 6, pdf_text("SIMAT - PIC Aset Fasilitas"), 0, 1, "C");

        $this->Ln(4);

        $this->SetFont("Arial", "", 9);
        $this->Cell(
            0,
            6,
            pdf_text("Tanggal Cetak: " . date("d/m/Y H:i")),
            0,
            1,
            "R"
        );

        $this->Ln(2);
    }

    public function Footer()
    {
        $this->SetY(-15);
        $this->SetFont("Arial", "I", 8);
        $this->Cell(
            0,
            10,
            pdf_text("Halaman " . $this->PageNo() . " dari {nb}"),
            0,
            0,
            "C"
        );
    }

    public function TableHeader()
    {
        $this->SetFont("Arial", "B", 8);
        $this->SetFillColor(230, 230, 230);

        $this->Cell(10, 8, "No", 1, 0, "C", true);
        $this->Cell(28, 8, pdf_text("NIM"), 1, 0, "C", true);
        $this->Cell(50, 8, pdf_text("Nama Mahasiswa"), 1, 0, "C", true);
        $this->Cell(32, 8, pdf_text("Kelas"), 1, 0, "C", true);
        $this->Cell(45, 8, pdf_text("Nama Fasilitas"), 1, 0, "C", true);
        $this->Cell(72, 8, pdf_text("Deskripsi Kerusakan"), 1, 0, "C", true);
        $this->Cell(40, 8, pdf_text("Tanggal Pengaduan"), 1, 1, "C", true);

        $this->SetWidths([10, 28, 50, 32, 45, 72, 40]);
        $this->SetAligns(["C", "C", "L", "C", "L", "L", "C"]);
    }

    public function SetWidths($widths)
    {
        $this->widths = $widths;
    }

    public function SetAligns($aligns)
    {
        $this->aligns = $aligns;
    }

    public function Row($data)
    {
        $jumlah_baris_maksimal = 0;

        for ($i = 0; $i < count($data); $i++) {
            $jumlah_baris_maksimal = max(
                $jumlah_baris_maksimal,
                $this->NbLines($this->widths[$i], $data[$i])
            );
        }

        $tinggi_baris = 5;
        $tinggi_total = $tinggi_baris * $jumlah_baris_maksimal;

        $this->CheckPageBreak($tinggi_total);

        for ($i = 0; $i < count($data); $i++) {
            $lebar = $this->widths[$i];
            $align = isset($this->aligns[$i]) ? $this->aligns[$i] : "L";

            $x = $this->GetX();
            $y = $this->GetY();

            $this->Rect($x, $y, $lebar, $tinggi_total);

            $this->MultiCell(
                $lebar,
                $tinggi_baris,
                pdf_text($data[$i]),
                0,
                $align
            );

            $this->SetXY($x + $lebar, $y);
        }

        $this->Ln($tinggi_total);
    }

    public function CheckPageBreak($height)
    {
        if ($this->GetY() + $height > $this->PageBreakTrigger) {
            $this->AddPage();
            $this->TableHeader();
            $this->SetFont("Arial", "", 8);
        }
    }

    public function NbLines($width, $text)
    {
        $cw = &$this->CurrentFont["cw"];

        if ($width == 0) {
            $width = $this->w - $this->rMargin - $this->x;
        }

        $wmax = ($width - 2 * $this->cMargin) * 1000 / $this->FontSize;

        $text = str_replace("\r", "", (string) $text);
        $text = pdf_text($text);

        $nb = strlen($text);

        if ($nb > 0 && $text[$nb - 1] == "\n") {
            $nb--;
        }

        $sep = -1;
        $i = 0;
        $j = 0;
        $l = 0;
        $nl = 1;

        while ($i < $nb) {
            $c = $text[$i];

            if ($c == "\n") {
                $i++;
                $sep = -1;
                $j = $i;
                $l = 0;
                $nl++;
                continue;
            }

            if ($c == " ") {
                $sep = $i;
            }

            $l += $cw[$c] ?? 0;

            if ($l > $wmax) {
                if ($sep == -1) {
                    if ($i == $j) {
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

$pdf = new PDFLaporanPengaduanFasilitas("L", "mm", "A4");
$pdf->AliasNbPages();
$pdf->SetMargins(10, 10, 10);
$pdf->AddPage();

$pdf->TableHeader();

$pdf->SetFont("Arial", "", 8);

$no = 1;

if (count($data_laporan) > 0) {
    foreach ($data_laporan as $row) {
        $pdf->Row([
            $no++,
            $row["nim"],
            $row["nama_mahasiswa"],
            $row["nama_kelas"],
            $row["nama_fasilitas"],
            $row["deskripsi_kerusakan"],
            format_tanggal_pdf_pengaduan($row["tanggal_pengaduan"])
        ]);
    }
} else {
    $pdf->Cell(
        277,
        8,
        pdf_text("Belum ada data pengaduan fasilitas."),
        1,
        1,
        "C"
    );
}

$nama_file = "laporan-pengaduan-fasilitas-" . date("Ymd-His") . ".pdf";

$pdf->Output("I", $nama_file);
exit;

?>