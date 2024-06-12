import 'package:flutter/material.dart'; // Import library flutter untuk membangun UI
import 'package:provider/provider.dart'; // Import library provider untuk manajemen state
import 'package:storage_management/providers/category_provider.dart'; // Import provider CategoryProvider
import 'package:slider_button/slider_button.dart'; // Import package SliderButton

class FormCategoryPage extends StatelessWidget {
  // Deklarasi kelas FormCategoryPage
  const FormCategoryPage({super.key}); // Constructor FormCategoryPage

  @override
  Widget build(BuildContext context) {
    // Method build untuk membangun UI
    var categoryProvider = context
        .watch<CategoryProvider>(); // Menggunakan provider CategoryProvider

    return Scaffold(
      // Scaffold sebagai kerangka utama halaman
      appBar: AppBar(
        // AppBar sebagai bagian atas halaman
        title: const Text('Insert Category'), // Judul AppBar
        titleTextStyle: const TextStyle(
          // Gaya teks judul
          fontWeight: FontWeight.bold, // Ketebalan teks
          color: Colors.black, // Warna teks
          fontSize: 20, // Ukuran teks
        ),
        backgroundColor: Colors.amber, // Warna latar belakang AppBar
      ),
      body: Container(
        // Container untuk konten halaman
        color: const Color.fromARGB(
            255, 42, 98, 154), // Warna latar belakang konten
        child: Padding(
          // Padding untuk memberikan jarak antara konten dan tepi layar
          padding: const EdgeInsets.all(16), // Padding sebesar 16
          child: Form(
            // Form untuk mengelola input
            key: categoryProvider.formKey, // Kunci form dari CategoryProvider
            child: ListView(
              // ListView untuk daftar input
              padding: const EdgeInsets.all(16), // Padding sebesar 16
              children: [
                const Text(
                  // Teks untuk label "Category Name"
                  'Category Name', // Isi teks
                  style: TextStyle(
                      // Gaya teks
                      fontSize: 18, // Ukuran teks
                      fontWeight: FontWeight.bold, // Ketebalan teks
                      color: Colors.white), // Warna teks
                ),
                TextFormField(
                  // TextFormField untuk input nama kategori
                  controller: categoryProvider
                      .nameController, // Controller untuk mengelola input
                  validator: (value) {
                    // Validasi input
                    if (value!.isEmpty) {
                      // Jika input kosong
                      return 'Tolong isi field ini'; // Pesan kesalahan
                    }
                    return null; // Input valid
                  },
                  decoration: const InputDecoration(
                    // Dekorasi input
                    hintText: "Name", // Teks hint
                    border: OutlineInputBorder(
                      // Border input
                      borderRadius: BorderRadius.all(
                          Radius.circular(10)), // Border radius (bentuk sudut)
                    ),
                    filled: true, // Diisi dengan warna latar belakang
                    fillColor: Color.fromARGB(
                        255, 255, 236, 170), // Warna latar belakang input
                  ),
                ),
                if (categoryProvider
                    .messageError.isNotEmpty) // Jika terdapat pesan kesalahan
                  Padding(
                    // Padding untuk memberikan jarak antara pesan kesalahan dan input
                    padding: const EdgeInsets.only(
                        top: 8.0), // Padding hanya di bagian atas
                    child: Text(
                      // Teks untuk pesan kesalahan
                      categoryProvider.messageError, // Isi teks
                      style: const TextStyle(
                          color: Colors.red), // Gaya teks (warna merah)
                    ),
                  ),
                const SizedBox(
                    height: 10), // SizedBox untuk memberikan jarak vertikal
                SliderButton(
                  // SliderButton sebagai tombol submit
                  action: () async {
                    // Aksi saat tombol ditekan
                    if (categoryProvider.nameController.text.isNotEmpty) {
                      // Jika nama kategori tidak kosong
                      try {
                        // Mencoba eksekusi
                        await context // Melakukan aksi menggunakan provider
                            .read<CategoryProvider>()
                            .insertCategory(
                                context); // Memasukkan kategori baru
                      } catch (e) {
                        // Tangkapan jika terjadi kesalahan
                        categoryProvider.messageError =
                            e.toString(); // Menetapkan pesan kesalahan
                        ScaffoldMessenger.of(context).showSnackBar(
                          // Menampilkan snackbar
                          SnackBar(
                            // Snackbar sebagai pesan notifikasi sementara
                            content: Text(categoryProvider
                                .messageError), // Isi pesan snackbar
                            backgroundColor: Colors
                                .red, // Warna latar belakang snackbar (merah)
                          ),
                        );
                      }
                    } else {
                      // Jika nama kategori kosong
                      categoryProvider.messageError =
                          'Nama tidak boleh kosong'; // Menetapkan pesan kesalahan
                      ScaffoldMessenger.of(context).showSnackBar(
                        // Menampilkan snackbar
                        SnackBar(
                          // Snackbar sebagai pesan notifikasi sementara
                          content: Text(categoryProvider
                              .messageError), // Isi pesan snackbar
                          backgroundColor: Colors
                              .red, // Warna latar belakang snackbar (merah)
                        ),
                      );
                    }
                  },
                  label: const Text(
                    // Teks pada tombol
                    "Submit", // Isi teks
                    style: TextStyle(
                        fontSize: 18, color: Colors.white), // Gaya teks
                  ),
                  icon: const Center(
                    // Icon pada tombol
                    child: Icon(
                      // Icon sebagai tanda panah ke bawah
                      Icons.login, // Jenis icon (panah ke bawah)
                      color: Colors.white, // Warna icon (putih)
                      size: 30.0, // Ukuran icon
                      semanticLabel:
                          'Text to announce in accessibility modes', // Label aksesibilitas
                    ),
                  ),
                  width:
                      MediaQuery.of(context).size.width * 0.75, // Lebar tombol
                  radius: 10, // Radius tombol (bentuk sudut)
                  height: 50, // Tinggi tombol
                  buttonSize: 50, // Ukuran tombol
                  buttonColor: Colors.amber, // Warna tombol
                  backgroundColor: Colors.blue, // Warna latar belakang tombol
                  highlightedColor: Colors.white, // Warna saat tombol ditekan
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
