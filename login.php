<?php
session_start();

require_once "config/koneksi.php";
require_once "config/function.php";

if(isset($_SESSION['id_pengguna'])) {
    $dashboard = arahkan_dashboard($_SESSION['role']);
    header("Location: " . $dashboard);
    exit;
}

$error = "";

if (isset($_POST['login'])) {
    $username = trim($_POST['username'] ?? '');
    $password = trim($_POST['password'] ?? '');

    if ($username == '' || $password == '') {
        $error = "Username dan password wajib diisi!";
    } else {
        $query = "
            SELECT 
                p.*,
                m.nim,
                m.nama_mahasiswa,
                pg.nip,
                pg.nama_pengajar
            FROM pengguna p
            LEFT JOIN mahasiswa m 
                ON p.id_mahasiswa = m.id_mahasiswa
            LEFT JOIN pengajar pg 
                ON p.id_pengajar = pg.id_pengajar
            WHERE p.username = ?
            AND p.status_akun = 'Aktif'
            LIMIT 1
        ";

        $stmt = mysqli_prepare($koneksi, $query);
        mysqli_stmt_bind_param($stmt, "s", $username);
        mysqli_stmt_execute($stmt);

        $result = mysqli_stmt_get_result($stmt);
        $pengguna = mysqli_fetch_assoc($result);

        mysqli_stmt_close($stmt);

        if ($pengguna && $password == $pengguna['password']) {
            $_SESSION['id_pengguna'] = $pengguna['id_pengguna'];
            $_SESSION['id_mahasiswa'] = $pengguna['id_mahasiswa'];
            $_SESSION['id_pengajar'] = $pengguna['id_pengajar'];
            $_SESSION['username'] = $pengguna['username'];
            $_SESSION['role'] = $pengguna['role'];

            $dashboard = arahkan_dashboard($pengguna['role']);
            header("Location: " . $dashboard);
            exit;
        } else {
            $error = "Username atau password salah!";
        }
    }
}
?>

<!doctype html>
<html lang="id">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Login - SIMAT</title>

    <link rel="icon" type="image/png" href="assets/img/logoTp.png">

    <link rel="stylesheet" href="assets/vendor/bootstrap/css/bootstrap.min.css">
    <link rel="stylesheet" href="assets/vendor/fontawesome/css/all.min.css">
    <link rel="stylesheet" href="assets/vendor/sweetalert2/dist/sweetalert2.min.css">

    <style>
        body {
            min-height: 100vh;
            background: linear-gradient(135deg, #123e78, #0b3164);
            font-family: Arial, sans-serif;
        }

        .login-wrapper {
            min-height: 100vh;
        }

        .login-card {
            border: none;
            border-radius: 24px;
            overflow: hidden;
            box-shadow: 0 20px 50px rgba(0, 0, 0, 0.18);
        }

        .login-left {
            background: linear-gradient(135deg, #123e78, #12c5df);
            padding: 48px;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .logo-wrapper {
            width: 100%;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .logo-login {
            max-width: 80%;
            width: 420px;
            height: auto;
            display: block;
        }

        .login-right {
            padding: 48px;
            background: #ffffff;
        }

        .form-control {
            min-height: 48px;
            border-radius: 14px;
        }

        .input-group-text {
            border-radius: 14px 0 0 14px;
            background: #f4f7fb;
        }

        .btn-login {
            min-height: 48px;
            border-radius: 14px;
            background: #12c5df;
            border-color: #12c5df;
            color: #04172f;
            font-weight: 700;
        }

        .btn-login:hover {
            background: #0baac2;
            border-color: #0baac2;
            color: #04172f;
        }

        @media (max-width: 768px) {
            .login-left {
                display: none;
            }

            .login-right {
                padding: 32px 24px;
            }
        }
    </style>
</head>
<body>

<div class="container login-wrapper d-flex align-items-center justify-content-center py-5">
    <div class="col-12 col-lg-10 col-xl-9">
        <div class="card login-card">
            <div class="row g-0">
                <div class="col-md-6 login-left">
                    <div class="wrapper">
                        <img src="assets/img/logo-simat.png" alt="Logo SIMAT" class="logo-login">
                    </div>
                </div>

                <div class="col-md-6 login-right">
                    <div class="mb-4">
                        <h3 class="fw-bold mb-1">Masuk Akun</h3>
                    </div>

                    <form method="post" action="">
                        <div class="mb-3">
                            <label class="form-label">Username</label>
                            <div class="input-group">
                                <span class="input-group-text">
                                    <i class="fa-solid fa-user"></i>
                                </span>
                                <input type="text" name="username" class="form-control" placeholder="Masukkan Username" required>
                            </div>
                        </div>

                        <div class="mb-4">
                            <label class="form-label">Password</label>
                            <div class="input-group">
                                <span class="input-group-text">
                                    <i class="fa-solid fa-lock"></i>
                                </span>
                                <input type="password" name="password" class="form-control" placeholder="Masukkan Password" required>
                            </div>
                        </div>

                        <button type="submit" name="login" class="btn btn-login w-100">
                            <i class="fa-solid fa-right-to-bracket me-1"></i>
                            Masuk
                        </button>
                    </form>

                </div>
            </div>
        </div>
    </div>
</div>

<script src="assets/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
<script src="assets/vendor/sweetalert2/dist/sweetalert2.all.min.js"></script>

<?php if (!empty($error)) { ?>
    <script>
        Swal.fire({
            icon: 'error',
            title: 'Login Gagal',
            text: <?= json_encode($error); ?>,
            confirmButtonText: 'Coba Lagi',
            confirmButtonColor: '#12c5df'
        });
    </script>
<?php } ?>

</body>
</html>