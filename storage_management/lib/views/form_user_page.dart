// Import library flutter/material.dart untuk menggunakan widget Flutter
import 'package:flutter/material.dart';

// Import library provider.dart untuk menggunakan Provider
import 'package:provider/provider.dart';

// Import class UserProvider dari file user_provider.dart
import 'package:storage_management/providers/user_provider.dart';

// Import widget SliderButton dari package slider_button.dart
import 'package:slider_button/slider_button.dart';

// Kelas FormUserPage merupakan StatelessWidget yang digunakan untuk menampilkan formulir penambahan pengguna
class FormUserPage extends StatelessWidget {
  // Konstruktor FormUserPage dengan parameter key opsional
  const FormUserPage({super.key});

  // Override method build untuk membuat tampilan widget
  @override
  Widget build(BuildContext context) {
    // Mendapatkan instance dari UserProvider menggunakan context
    var userProvider = context.watch<UserProvider>();

    // Mengembalikan Scaffold, sebuah layout untuk halaman tunggal yang memiliki struktur dasar.
    return Scaffold(
      // AppBar berisi judul "Insert User"
      appBar: AppBar(
        title: const Text('Insert User'), // Teks judul
        titleTextStyle: const TextStyle(
          // Gaya teks judul
          fontWeight: FontWeight.bold,
          color: Colors.black,
          fontSize: 20,
        ),
        backgroundColor: Colors.amber, // Warna latar belakang app bar
      ),
      // Body merupakan bagian tengah dari Scaffold yang digunakan untuk menampilkan konten utama
      body: Container(
        color: const Color.fromARGB(
            255, 42, 98, 154), // Warna latar belakang container
        child: Padding(
          padding: const EdgeInsets.all(16), // Padding dari semua sisi
          child: Form(
            key: userProvider
                .formKey, // Kunci form yang digunakan untuk validasi
            child: ListView(
              padding: const EdgeInsets.all(
                  16), // Padding dari semua sisi untuk ListView
              children: [
                const Text(
                  'Username', // Label untuk input field username
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10), // Spacer vertikal
                // TextFormField untuk memasukkan username
                TextFormField(
                  controller: userProvider
                      .usernameController, // Controller untuk input username
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Tolong isi field ini'; // Validasi apakah field username kosong
                    }
                    return null; // Validasi berhasil
                  },
                  decoration: const InputDecoration(
                    hintText: "Username", // Hint text
                    border: OutlineInputBorder(
                      // Border input field
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    filled: true, // Background field diisi
                    fillColor:
                        Color.fromARGB(255, 255, 236, 170), // Warna background
                  ),
                ),
                // Widget ini menampilkan pesan error jika messageError tidak kosong
                if (userProvider.messageError.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      userProvider.messageError,
                      style: const TextStyle(
                          color: Colors.red), // Gaya teks pesan error
                    ),
                  ),
                const SizedBox(height: 10), // Spacer vertikal
                const Text(
                  'Password', // Label untuk input field password
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10), // Spacer vertikal
                // TextFormField untuk memasukkan password
                TextFormField(
                  controller: userProvider
                      .passwordController, // Controller untuk input password
                  obscureText:
                      true, // Teks ditampilkan sebagai karakter tersembunyi
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Tolong isi field ini'; // Validasi apakah field password kosong
                    }
                    return null; // Validasi berhasil
                  },
                  decoration: const InputDecoration(
                    hintText: "Password", // Hint text
                    border: OutlineInputBorder(
                      // Border input field
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    filled: true, // Background field diisi
                    fillColor:
                        Color.fromARGB(255, 255, 236, 170), // Warna background
                  ),
                ),
                // Widget ini menampilkan pesan error jika messageError tidak kosong
                if (userProvider.messageError.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      userProvider.messageError,
                      style: const TextStyle(
                          color: Colors.red), // Gaya teks pesan error
                    ),
                  ),
                const SizedBox(height: 10), // Spacer vertikal
                // SliderButton untuk melakukan aksi submit
                SliderButton(
                  action: () async {
                    if (userProvider.usernameController.text.isNotEmpty &&
                        userProvider.passwordController.text.isNotEmpty) {
                      try {
                        // Memanggil fungsi insertUser dari UserProvider untuk menambahkan pengguna baru
                        await context.read<UserProvider>().insertUser(context);
                      } catch (e) {
                        // Menangani kesalahan yang mungkin terjadi dan menampilkan pesan error
                        userProvider.messageError = e.toString();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(userProvider.messageError),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    } else {
                      // Menampilkan pesan error jika username atau password kosong
                      userProvider.messageError =
                          'Username dan Password tidak boleh kosong';
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(userProvider.messageError),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  label: const Text(
                    "Submit", // Label tombol
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                  icon: const Center(
                    child: Icon(
                      Icons.login, // Icon untuk tombol
                      color: Colors.white, // Warna icon
                      size: 30.0, // Ukuran icon
                      semanticLabel:
                          'Text to announce in accessibility modes', // Label untuk mode aksesibilitas
                    ),
                  ),
                  width: MediaQuery.of(context).size.width *
                      0.75, // Lebar tombol sebesar 75% dari lebar layar
                  radius: 10, // Jari-jari slider
                  height: 50, // Tinggi slider
                  buttonSize: 50, // Ukuran tombol slider
                  buttonColor: Colors.amber, // Warna tombol slider
                  backgroundColor: Colors.blue, // Warna latar belakang slider
                  highlightedColor: Colors
                      .white, // Warna yang ditampilkan saat slider ditekan
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
