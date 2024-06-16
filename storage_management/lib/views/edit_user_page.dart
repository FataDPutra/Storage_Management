import 'package:flutter/material.dart'; // Impor library Flutter untuk membuat UI
import 'package:provider/provider.dart'; // Impor library Provider untuk manajemen state
import 'package:storage_management/providers/user_provider.dart'; // Impor UserProvider untuk mengelola data pengguna

class EditFormUser extends StatefulWidget {
  // Deklarasi kelas EditFormUser sebagai StatefulWidget
  final int id; // ID pengguna yang akan diedit
  const EditFormUser(
      {required this.id, super.key}); // Konstruktor untuk menerima ID

  @override
  State<EditFormUser> createState() =>
      _EditFormUserState(); // Membuat state dari EditFormUser
}

class _EditFormUserState extends State<EditFormUser> {
  // Deklarasi _EditFormUserState sebagai state dari EditFormUser
  bool _isObscure =
      true; // Boolean untuk menentukan apakah teks password tersembunyi atau tidak

  @override
  void initState() {
    // Metode yang dipanggil saat state diinisialisasi
    super.initState();
    context.read<UserProvider>().clearSelectedImage();
    context
        .read<UserProvider>()
        .detailUser(widget.id); // Memuat detail pengguna saat inisialisasi
  }

  void _showConfirmationDialog(BuildContext context, Function onConfirm) {
    // Metode untuk menampilkan dialog konfirmasi
    showDialog(
      // Memunculkan dialog
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          // AlertDialog untuk konfirmasi
          title: const Text('Confirm Update'), // Judul dialog
          content: const Text(
              'Are you sure you want to update this user?'), // Isi dialog
          actions: <Widget>[
            // Tombol aksi
            TextButton(
              // Tombol untuk membatalkan tindakan
              child: const Text('Cancel'), // Teks tombol
              onPressed: () {
                // Aksi saat tombol ditekan
                Navigator.of(context).pop(); // Tutup dialog
              },
            ),
            TextButton(
              // Tombol untuk melakukan pembaruan
              child: const Text('Update'), // Teks tombol
              onPressed: () {
                // Aksi saat tombol ditekan
                Navigator.of(context).pop(); // Tutup dialog
                onConfirm(); // Panggil fungsi yang dikonfirmasi
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Metode untuk membuat UI
    var userProvider = context.watch<
        UserProvider>(); // Menggunakan UserProvider dari Provider untuk mengakses data pengguna
    return Scaffold(
      // Scaffold untuk menyusun UI
      appBar: AppBar(
        // AppBar sebagai bagian atas halaman
        title: const Text('Edit User'), // Judul AppBar
        titleTextStyle: const TextStyle(
          // Gaya teks judul AppBar
          fontWeight: FontWeight.bold,
          color: Colors.black,
          fontSize: 20,
        ),
        backgroundColor: Colors.grey[200], // Warna latar belakang AppBar
      ),
      body: Container(
        // Container untuk menyimpan konten halaman
        color: const Color.fromARGB(
            255, 42, 98, 154), // Warna latar belakang konten
        child: Padding(
          // Padding untuk memberikan jarak dari tepi konten
          padding: const EdgeInsets.all(16.0),
          child: Form(
            // Form untuk mengelola input
            key: userProvider.formKey, // Kunci form
            child: ListView(
              // ListView untuk mengatur input dalam daftar gulir
              children: [
                const Text(
                  // Teks untuk label 'Username'
                  'Username',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                const SizedBox(height: 8), // SizedBox untuk memberikan jarak
                TextFormField(
                  // TextFormField untuk input username
                  controller: userProvider
                      .usernameController, // Controller untuk mengelola input
                  validator: (value) {
                    // Validasi input
                    if (value!.isEmpty) {
                      // Jika input kosong
                      return 'Please enter a username'; // Tampilkan pesan kesalahan
                    }
                    return null; // Kembalikan null jika input valid
                  },
                  decoration: const InputDecoration(
                    // Dekorasi untuk input
                    focusedBorder: OutlineInputBorder(
                      // Border saat input difokuskan
                      borderSide: BorderSide(
                        width: 2,
                        color: Color.fromARGB(255, 51, 58, 115),
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    hintText: 'Enter username', // Hint untuk input
                    hintStyle: TextStyle(
                      // Gaya teks hint
                      color: Color.fromARGB(255, 101, 101, 101),
                    ),
                    filled: true, // Mengisi input dengan warna latar belakang
                    fillColor: Color.fromARGB(
                        255, 255, 236, 170), // Warna latar belakang input
                    border: OutlineInputBorder(
                      // Border input
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    errorStyle: TextStyle(
                      // Gaya untuk pesan kesalahan
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 16), // SizedBox untuk memberikan jarak
                const Text(
                  // Teks untuk label 'Password'
                  'Password',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                const SizedBox(height: 8), // SizedBox untuk memberikan jarak
                TextFormField(
                  // TextFormField untuk input password
                  controller: userProvider
                      .passwordController, // Controller untuk mengelola input
                  obscureText: _isObscure, // Menyembunyikan teks password
                  validator: (value) {
                    // Validasi input
                    if (value!.isEmpty) {
                      // Jika input kosong
                      return 'Please enter a password'; // Tampilkan pesan kesalahan
                    }
                    return null; // Kembalikan null jika input valid
                  },
                  decoration: InputDecoration(
                    // Dekorasi untuk input
                    focusedBorder: const OutlineInputBorder(
                      // Border saat input difokuskan
                      borderSide: BorderSide(
                        width: 2,
                        color: Color.fromARGB(255, 51, 58, 115),
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    hintText: 'Enter password', // Hint untuk input
                    hintStyle: const TextStyle(
                      // Gaya teks hint
                      color: Color.fromARGB(255, 101, 101, 101),
                    ),
                    filled: true, // Mengisi input dengan warna latar belakang
                    fillColor: const Color.fromARGB(
                        255, 255, 236, 170), // Warna latar belakang input
                    suffixIcon: IconButton(
                      // IconButton untuk mengubah visibilitas teks password
                      icon: Icon(
                        // Icon yang ditampilkan
                        _isObscure ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () {
                        // Saat tombol ditekan
                        setState(() {
                          // Set state baru
                          _isObscure = !_isObscure; // Mengubah nilai _isObscure
                        });
                      },
                    ),
                    border: const OutlineInputBorder(
                      // Border input
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                  ),
                ),
                const SizedBox(height: 16), // SizedBox untuk memberikan jarak
                const Text(
                  // Teks untuk label 'Image'
                  'Image',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                const SizedBox(height: 8), // SizedBox untuk memberikan jarak
                userProvider.selectedImage !=
                        null // Cek apakah gambar telah dipilih
                    ? SizedBox(
                        // SizedBox untuk memuat gambar yang dipilih
                        height: 200,
                        width: 200,
                        child: Image.file(
                          // Menampilkan gambar yang dipilih dari file
                          userProvider.selectedImage!, // Gambar yang dipilih
                          fit: BoxFit.fill, // Mengisi ruang yang tersedia
                        ),
                      )
                    : userProvider.imageController.text
                            .isNotEmpty // Cek apakah gambar sudah dipilih sebelumnya
                        ? SizedBox(
                            // SizedBox untuk memuat gambar yang sudah dipilih sebelumnya
                            height: 200,
                            width: 200,
                            child: Image.network(
                              // Menampilkan gambar dari URL
                              'http://10.0.2.2:3000/assets/images/users/${userProvider.imageController.text}',
                              fit: BoxFit.fill, // Mengisi ruang yang tersedia
                            ),
                          )
                        : const Text(
                            'No image selected.'), // Teks ketika tidak ada gambar yang dipilih
                const SizedBox(height: 8), // SizedBox untuk memberikan jarak
                ElevatedButton(
                  // Tombol untuk memilih gambar baru
                  style: ElevatedButton.styleFrom(
                    // Gaya tombol
                    backgroundColor: const Color.fromARGB(
                        255, 255, 236, 170), // Warna latar belakang
                    elevation: 5, // Elevation (bayangan) tombol
                    shape: RoundedRectangleBorder(
                      // Bentuk tombol
                      borderRadius: BorderRadius.circular(
                          10), // Border radius (bentuk sudut)
                    ),
                  ),
                  onPressed: () {
                    // Saat tombol ditekan
                    context
                        .read<UserProvider>()
                        .pickImage(); // Memilih gambar baru menggunakan UserProvider
                  },
                  child: const Text(
                    // Teks pada tombol
                    'Pick Image',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                ),
                const SizedBox(height: 20), // SizedBox untuk memberikan jarak
                ElevatedButton(
                  // Tombol untuk memperbarui data pengguna
                  style: ElevatedButton.styleFrom(
                    // Gaya tombol
                    backgroundColor: Colors.amber, // Warna latar belakang
                    elevation: 5, // Elevation (bayangan) tombol
                    shape: RoundedRectangleBorder(
                      // Bentuk tombol
                      borderRadius: BorderRadius.circular(
                          10), // Border radius (bentuk sudut)
                    ),
                  ),
                  onPressed: () {
                    // Saat tombol ditekan
                    if (userProvider.formKey.currentState!.validate()) {
                      // Validasi form sebelum pembaruan
                      _showConfirmationDialog(context, () {
                        // Tampilkan dialog konfirmasi sebelum pembaruan
                        userProvider.updateUser(
                            context); // Panggil metode untuk memperbarui pengguna
                      });
                    }
                  },
                  child: const Text(
                    // Teks pada tombol
                    "Update",
                    style: TextStyle(fontSize: 18, color: Colors.black),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
