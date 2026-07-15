<?php
require_once __DIR__ . '/config/koneksi.php';
require_once __DIR__ . '/includes/auth_dashboard.php';

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    http_response_code(405);
    header('Allow: POST');
    exit('Metode permintaan tidak diizinkan.');
}

$_SESSION = [];
if (ini_get('session.use_cookies')) {
    $parameter = session_get_cookie_params();
    setcookie(
        session_name(),
        '',
        time() - 42000,
        $parameter['path'],
        $parameter['domain'],
        $parameter['secure'],
        $parameter['httponly']
    );
}
session_destroy();

header('Location: login.php');
exit;
?>
