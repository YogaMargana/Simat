</div>

<script src="/SIMAT/assets/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
<script src="/SIMAT/assets/vendor/sweetalert2/dist/sweetalert2.all.min.js"></script>

<?php
$status = $_GET['status'] ?? '';
$error = $_GET['error'] ?? '';

$pesan_status = [
    'berhasil_tambah' => 'Data berhasil ditambahkan.',
    'berhasil_edit' => 'Data berhasil diubah.',
    'berhasil_hapus' => 'Data berhasil dinonaktifkan.',
    'berhasil_pulihkan' => 'Kondisi fasilitas berhasil dipulihkan menjadi Aktif.',
    'berhasil_verifikasi' => 'Data berhasil diverifikasi.',
    'berhasil_daftar' => 'Pendaftaran jobdesc berhasil.',
    'berhasil_selesai' => 'Bukti selesai jobdesc berhasil dikirim.',
    'berhasil_selesaikan_jobdesc' => 'Status jobdesc berhasil diubah menjadi Selesai.'
];
?>

<script src="/SIMAT/assets/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
<script src="/SIMAT/assets/vendor/datatables/datatables.js"></script>
<script src="/SIMAT/assets/vendor/datatables/datatables.min.js"></script>

<script>
    const statusNotif = <?= json_encode($status); ?>;
    const errorNotif = <?= json_encode($error); ?>;
    const pesanStatus = <?= json_encode($pesan_status); ?>;

    if (statusNotif && pesanStatus[statusNotif]) {
        Swal.fire({
            icon: 'success',
            title: 'Berhasil',
            text: pesanStatus[statusNotif],
            confirmButtonText: 'OK',
            confirmButtonColor: '#12c5df'
        });
    }

    if (errorNotif) {
        Swal.fire({
            icon: 'error',
            title: 'Terjadi Kesalahan',
            text: errorNotif,
            confirmButtonText: 'OK',
            confirmButtonColor: '#12c5df'
        });
    }

    if (statusNotif || errorNotif) {
        const url = new URL(window.location.href);
        url.searchParams.delete('status');
        url.searchParams.delete('error');
        window.history.replaceState({}, document.title, url.pathname + url.search);
    }

    document.querySelectorAll('.btn-konfirmasi').forEach(function (tombol) {
        tombol.addEventListener('click', function (event) {
            event.preventDefault();

            const url = this.getAttribute('href');
            const title = this.dataset.title || 'Apakah kamu yakin?';
            const text = this.dataset.text || 'Data akan diproses.';
            const icon = this.dataset.icon || 'warning';
            const confirmText = this.dataset.confirmText || 'Ya, lanjutkan';
            const cancelText = this.dataset.cancelText || 'Batal';

            Swal.fire({
                title: title,
                text: text,
                icon: icon,
                showCancelButton: true,
                confirmButtonText: confirmText,
                cancelButtonText: cancelText,
                confirmButtonColor: '#dc3545',
                cancelButtonColor: '#6c757d',
                reverseButtons: true
            }).then((result) => {
                if (result.isConfirmed) {
                    window.location.href = url;
                }
            });
        });
    });
</script>

<script>
    new DataTable('#myTable', {
        ordering: true,
        paging: true,
        searching: true,
        info: true
    });
</script>

</body>
</html>