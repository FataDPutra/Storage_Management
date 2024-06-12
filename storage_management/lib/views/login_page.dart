import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart'; // Import untuk menggunakan animasi Lottie
import 'package:provider/provider.dart'; // Import untuk menggunakan Provider
import 'package:slider_button/slider_button.dart'; // Import untuk menggunakan SliderButton
import 'package:storage_management/providers/auth_provider.dart'; // Import model AuthProvider
import 'package:storage_management/views/register_page.dart'; // Import halaman RegisterPage

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}); // Constructor untuk LoginPage

  @override
  Widget build(BuildContext context) {
    var authProvider = context.watch<
        AuthProvider>(); // Mendapatkan instance dari AuthProvider menggunakan Provider

    return Scaffold(
      // Scaffold sebagai kerangka utama halaman
      backgroundColor: const Color.fromARGB(
          255, 79, 187, 241), // Warna latar belakang halaman
      body: Padding(
        // Padding untuk memberikan jarak dari tepi halaman
        padding: const EdgeInsets.symmetric(horizontal: 40.0),
        child: Form(
          // Form untuk input data
          key: authProvider
              .formKeyLogin, // Kunci form yang diambil dari AuthProvider
          child: ListView(
            // ListView untuk menampilkan elemen secara berurutan
            children: [
              const SizedBox(
                height: 50,
              ),
              const Text(
                // Judul "Welcome Back!"
                'Welcome Back !',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  color: Color.fromARGB(255, 51, 58, 115),
                ),
              ),
              Lottie.asset(
                // Widget untuk menampilkan animasi Lottie
                'lib/assets/animations/login.json', // Lokasi file animasi
                height: 225, // Tinggi animasi
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                // Judul "Login"
                'Login',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color.fromARGB(255, 51, 58, 115),
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                // Input field untuk username
                controller: authProvider
                    .usernameController, // Controller untuk mengatur input field
                validator: (value) {
                  // Validator untuk memeriksa input field
                  if (value!.isEmpty) {
                    return 'Username cannot be empty';
                  }
                  return null;
                },
                autofocus: true, // Fokus otomatis pada input field
                decoration: InputDecoration(
                  // Penataan tampilan input field
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                      width: 2,
                      color: Color.fromARGB(255, 51, 58, 115),
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  hintText: 'Username', // Hint text untuk input field
                  hintStyle: const TextStyle(
                    color: Color.fromARGB(255, 101, 101, 101),
                  ),
                  filled: true,
                  fillColor: const Color.fromARGB(255, 255, 236, 170),
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  errorText: authProvider.loginState == StateLogin.error &&
                          authProvider.messageError
                              .contains('Username tidak ditemukan')
                      ? 'Username tidak ditemukan'
                      : null,
                  errorStyle: const TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                // Input field untuk password
                controller: authProvider
                    .passwordController, // Controller untuk mengatur input field
                obscureText: authProvider
                    .obscurePassword, // Menyembunyikan teks password
                validator: (value) {
                  // Validator untuk memeriksa input field
                  if (value!.isEmpty) {
                    return 'Password cannot be empty';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  // Penataan tampilan input field
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                      width: 2,
                      color: Color.fromARGB(255, 51, 58, 115),
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  hintText: 'Password', // Hint text untuk input field
                  hintStyle: const TextStyle(
                    color: Color.fromARGB(255, 101, 101, 101),
                  ),
                  filled: true,
                  fillColor: const Color.fromARGB(255, 255, 236, 170),
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  suffixIcon: IconButton(
                    // Ikona untuk menampilkan/sembunyikan password
                    onPressed: () {
                      context
                          .read<AuthProvider>()
                          .actionObscurePassword(); // Mengubah status penampilan password
                    },
                    icon: Icon(
                      authProvider.obscurePassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                  ),
                  errorText: authProvider.loginState == StateLogin.error &&
                          authProvider.messageError
                              .contains('password tidak sesuai')
                      ? 'Password tidak sesuai'
                      : null,
                  errorStyle: const TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              // Menampilkan pesan error jika login gagal
              if (authProvider.loginState == StateLogin.error &&
                  !authProvider.messageError
                      .contains('Username tidak ditemukan') &&
                  !authProvider.messageError.contains('password tidak sesuai'))
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    authProvider.messageError,
                    style: const TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              const SizedBox(
                height: 25,
              ),
              SliderButton(
                // Widget SliderButton untuk login
                action: () async {
                  context.read<AuthProvider>().processLogin(
                      context); // Memproses login menggunakan AuthProvider
                  return false;
                },
                label: const Text(
                  // Label pada SliderButton
                  "Slide to Login",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 17,
                  ),
                ),
                icon: const Center(
                  child: Icon(
                    Icons.login,
                    color: Colors.white,
                    size: 30.0,
                    semanticLabel: 'Text to announce in accessibility modes',
                  ),
                ),
                width: MediaQuery.of(context).size.width * 0.75,
                radius: 50,
                height: 50,
                buttonSize: 50,
                buttonColor: const Color.fromARGB(
                    255, 1, 213, 58), // Warna tombol SliderButton saat normal
                backgroundColor: const Color.fromARGB(
                    255, 240, 232, 7), // Warna latar belakang SliderButton
                highlightedColor:
                    Colors.white, // Warna tombol SliderButton saat ditekan
              ),
              const SizedBox(
                height: 20,
              ),
              SliderButton(
                // Widget SliderButton untuk pindah ke halaman register
                action: () async {
                  authProvider.usernameController
                      .clear(); // Membersihkan input field username
                  authProvider.passwordController
                      .clear(); // Membersihkan input field password
                  Navigator.pushReplacement(
                    // Pindah ke halaman RegisterPage dan mengganti halaman saat ini
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          const RegisterPage(), // Membuat halaman RegisterPage sebagai halaman baru
                    ),
                  );

                  return Future.value(
                      false); // Mengembalikan nilai false secara async
                },
                label: const Text(
                  // Label pada SliderButton
                  "Slide to Register Page",
                  style: TextStyle(
                      color: Color(0xff4a4a4a),
                      fontWeight: FontWeight.w500,
                      fontSize: 17),
                ),
                icon: const Center(
                  child: Icon(
                    Icons.app_registration,
                    color: Color.fromARGB(255, 4, 130, 240),
                    size: 30.0,
                    semanticLabel: 'Text to announce in accessibility modes',
                  ),
                ),
                buttonSize: 55,
                height: 55,
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
