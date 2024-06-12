import 'package:flutter/material.dart'; // Mengimpor library dari Flutter untuk pengembangan antarmuka pengguna.
import 'package:provider/provider.dart'; // Mengimpor library untuk menggunakan Provider, sebuah library state management.
import 'package:storage_management/providers/auth_provider.dart'; // Mengimpor provider yang digunakan untuk otentikasi.
import 'package:storage_management/providers/category_provider.dart'; // Mengimpor provider untuk mengelola kategori.
import 'package:storage_management/providers/product_provider.dart'; // Mengimpor provider untuk mengelola produk.
import 'package:storage_management/providers/user_provider.dart'; // Mengimpor provider untuk mengelola pengguna.
import 'package:storage_management/views/home.dart'; // Mengimpor halaman utama aplikasi untuk admin.
import 'package:storage_management/views/home_user.dart'; // Mengimpor halaman utama aplikasi untuk pengguna.
import 'package:storage_management/views/login_page.dart'; // Mengimpor halaman login.
import 'package:shared_preferences/shared_preferences.dart'; // Mengimpor shared_preferences untuk menyimpan data lokal.

void main() {
  // Metode utama untuk menjalankan aplikasi.
  runApp(const MyApp()); // Menjalankan aplikasi dengan kelas MyApp.
}

class MyApp extends StatelessWidget {
  // Kelas MyApp, sebagai root dari aplikasi.
  const MyApp({super.key}); // Konstruktor MyApp.

  @override
  Widget build(BuildContext context) {
    // Metode untuk membangun antarmuka pengguna.
    return MultiProvider(
      // MultiProvider untuk menyediakan beberapa provider.
      providers: [
        // Daftar provider yang disediakan.
        ChangeNotifierProvider(
          // Provider untuk otentikasi.
          create: (context) => AuthProvider(), // Membuat instance AuthProvider.
        ),
        ChangeNotifierProvider(
          // Provider untuk kategori.
          create: (context) =>
              CategoryProvider(), // Membuat instance CategoryProvider.
        ),
        ChangeNotifierProvider(
          // Provider untuk pengguna.
          create: (context) => UserProvider(), // Membuat instance UserProvider.
        ),
        ChangeNotifierProvider(
          // Provider untuk produk.
          create: (context) =>
              ProductProvider(), // Membuat instance ProductProvider.
        ),
      ],
      child: const MaterialApp(
        // MaterialApp sebagai aplikasi berbasis material design.
        debugShowCheckedModeBanner: false, // Menyembunyikan banner debug.
        home: MyAppWrapper(), // Mengatur halaman utama aplikasi.
      ),
    );
  }
}

class MyAppWrapper extends StatefulWidget {
  // Kelas MyAppWrapper, sebagai wrapper untuk penanganan otentikasi.
  const MyAppWrapper({super.key}); // Konstruktor MyAppWrapper.

  @override
  _MyAppWrapperState createState() =>
      _MyAppWrapperState(); // Membuat state MyAppWrapper.
}

class _MyAppWrapperState extends State<MyAppWrapper> {
  // State untuk MyAppWrapper.
  late SharedPreferences
      _sharedPreferences; // Variabel untuk menyimpan shared preferences.

  @override
  void initState() {
    // Metode untuk inisialisasi state.
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Eksekusi setelah frame pertama selesai.
      _checkLoginStatus(); // Memeriksa status login pengguna.
    });
  }

  Future<void> _checkLoginStatus() async {
    // Metode untuk memeriksa status login pengguna.
    _sharedPreferences = await SharedPreferences
        .getInstance(); // Mendapatkan instance shared preferences.
    final isLoggedIn = _sharedPreferences.getString('username') !=
        null; // Memeriksa apakah pengguna sudah login.
    if (isLoggedIn) {
      // Jika pengguna sudah login.
      final String username = _sharedPreferences
          .getString('username')!; // Mendapatkan username pengguna.
      final String image = _sharedPreferences
          .getString('image')!; // Mendapatkan gambar pengguna.
      final bool isAdmin = username ==
          'administrator'; // Memeriksa apakah pengguna adalah admin.
      if (isAdmin) {
        // Jika pengguna adalah admin.
        _navigateToAdminHome(
            username, image); // Navigasi ke halaman utama admin.
      } else {
        // Jika pengguna adalah pengguna biasa.
        _navigateToUserHome(
            username, image); // Navigasi ke halaman utama pengguna.
      }
    } else {
      // Jika pengguna belum login.
      _navigateToLoginPage(); // Navigasi ke halaman login.
    }
  }

  void _navigateToAdminHome(String username, String image) {
    // Metode untuk navigasi ke halaman utama admin.
    Navigator.of(context).pushReplacement(
      // Navigasi dengan mengganti halaman sebelumnya.
      MaterialPageRoute(
        builder: (_) => Home(
          // Halaman utama admin.
          id: _sharedPreferences.getInt('id')!, // Mendapatkan ID pengguna.
          username: username, // Username pengguna.
          image: image, // Gambar pengguna.
        ),
      ),
    );
  }

  void _navigateToUserHome(String username, String image) {
    // Metode untuk navigasi ke halaman utama pengguna.
    Navigator.of(context).pushReplacement(
      // Navigasi dengan mengganti halaman sebelumnya.
      MaterialPageRoute(
        builder: (_) => HomeUser(
          // Halaman utama pengguna.
          id: _sharedPreferences.getInt('id')!, // Mendapatkan ID pengguna.
          username: username, // Username pengguna.
          image: image, // Gambar pengguna.
        ),
      ),
    );
  }

  void _navigateToLoginPage() {
    // Metode untuk navigasi ke halaman login.
    Navigator.of(context).pushReplacement(
      // Navigasi dengan mengganti halaman sebelumnya.
      MaterialPageRoute(
        builder: (_) => const LoginPage(), // Halaman login.
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Metode untuk membangun antarmuka pengguna.
    return const Scaffold(
      // Scaffold sebagai kerangka dasar aplikasi.
      body: Center(
        // Tengahkan konten dalam scaffold.
        child: CircularProgressIndicator(), // Tampilkan indikator loading.
      ),
    );
  }
}
