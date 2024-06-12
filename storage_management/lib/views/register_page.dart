import 'package:flutter/material.dart';
import 'package:giffy_dialog/giffy_dialog.dart'; // Import untuk menggunakan GiffyDialog
import 'package:provider/provider.dart'; // Import untuk menggunakan Provider
import 'package:slider_button/slider_button.dart'; // Import untuk menggunakan SliderButton
import 'package:storage_management/providers/auth_provider.dart'; // Import model AuthProvider
import 'package:storage_management/views/login_page.dart'; // Import halaman LoginPage

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key}); // Konstruktor kelas RegisterPage

  @override
  Widget build(BuildContext context) {
    var authProvider =
        context.watch<AuthProvider>(); // Mendapatkan instance dari AuthProvider

    return Scaffold(
      backgroundColor: const Color.fromARGB(
          255, 12, 71, 130), // Warna latar belakang halaman
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40.0),
        child: Form(
          key: authProvider.formKeyRegister, // Kunci form untuk validasi
          child: ListView(
            children: [
              const SizedBox(
                height: 50,
              ),
              Lottie.asset(
                'lib/assets/animations/register.json', // Animasi Lottie untuk halaman pendaftaran
                height: 250,
              ),
              const Text(
                'Register Page', // Judul halaman pendaftaran
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color.fromARGB(255, 255, 236, 170),
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              TextFormField(
                controller: authProvider
                    .usernameController, // Controller untuk input username
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Username tidak boleh kosong'; // Validasi input username
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(width: 2, color: Colors.black),
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  hintText: 'Username',
                  errorStyle: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  hintStyle: TextStyle(
                    color: Color.fromARGB(255, 101, 101, 101),
                  ),
                  suffixIcon: Icon(Icons.person), // Icon untuk input username
                  filled: true,
                  fillColor: Color.fromARGB(255, 255, 236, 170),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: authProvider
                    .passwordController, // Controller untuk input password
                obscureText: authProvider
                    .obscurePassword, // Mengatur apakah password tersembunyi atau tidak
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Password tidak boleh kosong'; // Validasi input password
                  }
                  return null;
                },
                decoration: InputDecoration(
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(width: 2, color: Colors.black),
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  hintText: 'Password',
                  errorStyle: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  hintStyle: const TextStyle(
                    color: Color.fromARGB(255, 101, 101, 101),
                  ),
                  filled: true,
                  fillColor: const Color.fromARGB(255, 255, 236, 170),
                  suffixIcon: IconButton(
                    onPressed: () {
                      context
                          .read<AuthProvider>()
                          .actionObscurePassword(); // Mengubah visibilitas password
                    },
                    icon: Icon(authProvider.obscurePassword == true
                        ? Icons.visibility_off
                        : Icons
                            .visibility), // Icon untuk menampilkan atau menyembunyikan password
                  ),
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              SliderButton(
                action: () async {
                  context
                      .read<AuthProvider>()
                      .processRegister(context); // Proses pendaftaran pengguna
                  return false;
                },
                label: const Text(
                  "Slide to Register", // Label pada SliderButton untuk mendaftar
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 17,
                  ),
                ),
                icon: const Center(
                  child: Icon(
                    Icons.app_registration_rounded, // Icon untuk mendaftar
                    color: Colors.white,
                    size: 30.0,
                    semanticLabel: 'Text to announce in accessibility modes',
                  ),
                ),
                width: MediaQuery.of(context).size.width * 0.75,
                radius: 50,
                height: 55,
                buttonSize: 55,
                buttonColor:
                    const Color.fromARGB(255, 213, 19, 1), // Warna tombol
                backgroundColor: const Color.fromARGB(
                    255, 240, 232, 7), // Warna latar belakang SliderButton
                highlightedColor: Colors.white, // Warna saat tombol ditekan
              ),
              const SizedBox(
                height: 20,
              ),
              SliderButton(
                action: () async {
                  authProvider.usernameController
                      .clear(); // Membersihkan input field username
                  authProvider.passwordController
                      .clear(); // Membersihkan input field password
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          const LoginPage(), // Pindah ke halaman login
                    ),
                  );

                  return Future.value(
                      false); // Mengembalikan nilai false secara async
                },
                label: const Text(
                  "Slide to Login Page", // Label pada SliderButton untuk pindah ke halaman login
                  style: TextStyle(
                    color: Color(0xff4a4a4a),
                    fontWeight: FontWeight.w500,
                    fontSize: 17,
                  ),
                ),
                icon: const Center(
                  child: Icon(
                    Icons.login, // Icon untuk pindah ke halaman login
                    color: Color.fromARGB(255, 4, 130, 240),
                    size: 30.0,
                    semanticLabel: 'Text to announce in accessibility modes',
                  ),
                ),
                buttonSize: 55,
                height: 55,
              ),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
