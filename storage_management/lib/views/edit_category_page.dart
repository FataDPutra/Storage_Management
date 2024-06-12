import 'package:flutter/material.dart'; // Mengimpor library Material dari Flutter
import 'package:provider/provider.dart'; // Mengimpor library Provider untuk manajemen state
import 'package:storage_management/providers/category_provider.dart'; // Mengimpor kelas CategoryProvider untuk mengelola data kategori

class EditFormCategory extends StatefulWidget {
  // Mendefinisikan kelas EditFormCategory sebagai StatefulWidget
  final int id; // Variabel id kategori

  const EditFormCategory(
      {required this.id,
      super.key}); // Konstruktor untuk kelas EditFormCategory

  @override
  State<EditFormCategory> createState() =>
      _EditFormCategoryState(); // Metode createState untuk membuat state dari EditFormCategory
}

class _EditFormCategoryState extends State<EditFormCategory> {
  // Mendefinisikan state dari EditFormCategory
  @override
  void initState() {
    // Metode initState yang dipanggil saat state diinisialisasi
    super.initState();
    context.read<CategoryProvider>().detailCategory(
        widget.id); // Mendapatkan detail kategori saat state diinisialisasi
  }

  void _showConfirmationDialog(BuildContext context, Function onConfirm) {
    // Metode untuk menampilkan dialog konfirmasi
    showDialog(
      // Menampilkan dialog
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          // AlertDialog untuk konfirmasi
          title: const Text('Confirm Update'), // Judul dialog
          content: const Text(
              'Are you sure you want to update this category?'), // Isi dialog
          actions: <Widget>[
            // Tombol aksi
            TextButton(
              // Tombol batal
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(); // Menutup dialog
              },
            ),
            TextButton(
              // Tombol update
              child: const Text('Update'),
              onPressed: () {
                Navigator.of(context).pop(); // Menutup dialog
                onConfirm(); // Memanggil fungsi onConfirm
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Metode untuk membangun UI
    var categoryProvider = context
        .watch<CategoryProvider>(); // Membaca CategoryProvider dari konteks

    return Scaffold(
      // Scaffold untuk tata letak halaman
      appBar: AppBar(
        // AppBar untuk halaman
        title: const Text('Edit Data Category'), // Judul AppBar
        backgroundColor: Colors.amber, // Warna latar belakang AppBar
        titleTextStyle: const TextStyle(
          // Gaya teks untuk judul AppBar
          fontWeight: FontWeight.bold,
          color: Colors.black,
          fontSize: 20,
        ),
      ),
      body: Container(
        // Container untuk body halaman
        color: const Color.fromARGB(
            255, 42, 98, 154), // Warna latar belakang container
        child: Padding(
          // Padding untuk konten
          padding: const EdgeInsets.all(16.0),
          child: Form(
            // Form untuk input data
            key: categoryProvider.formKey, // Kunci form
            child: ListView(
              // ListView untuk menampilkan elemen secara berurutan
              padding: const EdgeInsets.all(16.0),
              children: [
                const Text(
                  // Teks untuk label 'Name'
                  'Name',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                TextFormField(
                  // TextFormField untuk memasukkan nama kategori
                  controller: categoryProvider
                      .nameController, // Controller untuk nilai input
                  validator: (value) {
                    // Validator untuk validasi input
                    if (value!.isEmpty) {
                      // Jika nilai kosong, tampilkan pesan kesalahan
                      return 'Tolong isi field ini';
                    }
                    return null; // Jika valid, kembalikan null
                  },
                  decoration: const InputDecoration(
                    // Dekorasi untuk input field
                    focusedBorder: OutlineInputBorder(
                      // Border saat input field fokus
                      borderSide: BorderSide(
                        width: 2,
                        color: Colors.black,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    hintText: 'Enter name', // Hint text untuk input field
                    hintStyle: TextStyle(
                      color: Colors.white,
                    ),
                    filled:
                        true, // Mengisi input field dengan warna latar belakang
                    fillColor: Color.fromARGB(
                        255, 255, 236, 170), // Warna latar belakang input field
                    border: OutlineInputBorder(
                      // Border input field
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                  ),
                ),
                Text(categoryProvider
                    .messageError), // Menampilkan pesan kesalahan jika ada
                const SizedBox(
                    height:
                        10), // SizedBox untuk memberikan jarak antara tombol dan pesan kesalahan
                ElevatedButton(
                  // Tombol untuk mengupdate kategori
                  style: ElevatedButton.styleFrom(
                    // Gaya tombol
                    backgroundColor:
                        Colors.amber, // Warna latar belakang tombol
                    elevation: 5, // Ketinggian bayangan tombol
                  ),
                  onPressed: () {
                    // Aksi ketika tombol ditekan
                    if (categoryProvider.formKey.currentState!.validate()) {
                      // Validasi form sebelum mengupdate
                      _showConfirmationDialog(context, () {
                        // Menampilkan dialog konfirmasi sebelum mengupdate
                        categoryProvider.updateCategory(
                            context); // Memanggil metode updateCategory untuk mengupdate kategori
                      });
                    }
                  },
                  child: const Text(
                    // Teks di dalam tombol
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
