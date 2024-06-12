import 'package:flutter/material.dart'; // Mengimpor library Material dari Flutter
import 'package:provider/provider.dart'; // Mengimpor library Provider untuk manajemen state
import 'package:storage_management/providers/product_provider.dart'; // Mengimpor kelas ProductProvider untuk mengelola data produk
import 'package:storage_management/providers/category_provider.dart'; // Mengimpor kelas CategoryProvider untuk mengelola data kategori

class EditFormProduct extends StatefulWidget {
  // Mendefinisikan kelas EditFormProduct sebagai StatefulWidget
  final int id; // Variabel id produk
  final String username; // Variabel nama pengguna

  const EditFormProduct(
      {required this.id,
      required this.username,
      super.key}); // Konstruktor untuk kelas EditFormProduct

  @override
  State<EditFormProduct> createState() =>
      _EditFormProductState(); // Metode createState untuk membuat state dari EditFormProduct
}

class _EditFormProductState extends State<EditFormProduct> {
  // Mendefinisikan state dari EditFormProduct
  @override
  void initState() {
    // Metode initState yang dipanggil saat state diinisialisasi
    super.initState();
    _loadProductDetails(); // Memuat detail produk saat state diinisialisasi
  }

  Future<void> _loadProductDetails() async {
    // Metode async untuk memuat detail produk
    await context
        .read<ProductProvider>()
        .detailProduct(widget.id); // Mendapatkan detail produk
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
              'Are you sure you want to update this product?'), // Isi dialog
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
    var productProvider = context
        .watch<ProductProvider>(); // Membaca ProductProvider dari konteks
    String loggedInUsername =
        widget.username; // Mendapatkan nama pengguna dari widget

    return Scaffold(
      // Scaffold untuk tata letak halaman
      appBar: AppBar(
        // AppBar untuk halaman
        title: const Text('Edit Product'), // Judul AppBar
        backgroundColor: Colors.amber, // Warna latar belakang AppBar
      ),
      body: Builder(
        // Builder untuk membuat konteks baru
        builder: (context) {
          if (productProvider.state == ProductState.loading) {
            // Jika status produk sedang dimuat
            return const Center(
              // Menampilkan indikator loading di tengah layar
              child: CircularProgressIndicator(),
            );
          }

          if (productProvider.state == ProductState.error) {
            // Jika terjadi kesalahan saat memuat produk
            return Center(
              // Menampilkan pesan kesalahan di tengah layar
              child: Text(productProvider.messageError),
            );
          }

          if (productProvider.state == ProductState.success) {
            // Jika produk berhasil dimuat
            return Container(
              // Container untuk body halaman
              color: const Color.fromARGB(
                  255, 42, 98, 154), // Warna latar belakang container
              child: Padding(
                // Padding untuk konten
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  // Form untuk input data produk
                  key: productProvider.formKey, // Kunci form
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
                        // TextFormField untuk memasukkan nama produk
                        controller: productProvider
                            .nameController, // Controller untuk nilai input
                        validator: (value) {
                          // Validator untuk validasi input
                          if (value!.isEmpty) {
                            // Jika nilai kosong, tampilkan pesan kesalahan
                            return 'Please enter product name';
                          }
                          return null; // Jika valid, kembalikan null
                        },
                        decoration: const InputDecoration(
                          // Dekorasi untuk input field
                          focusedBorder: OutlineInputBorder(
                            // Border saat input field fokus
                            borderSide: BorderSide(
                              width: 2,
                              color: Color.fromARGB(255, 51, 58, 115),
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          hintText:
                              'Enter product name', // Hint text untuk input field
                          hintStyle: TextStyle(
                            // Gaya untuk hint text
                            color: Color.fromARGB(255, 101, 101, 101),
                          ),
                          filled:
                              true, // Mengisi input field dengan warna latar belakang
                          fillColor: Color.fromARGB(255, 255, 236,
                              170), // Warna latar belakang input field
                          border: OutlineInputBorder(
                            // Border input field
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          errorStyle: TextStyle(
                            // Gaya untuk pesan kesalahan
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(
                          height:
                              10), // SizedBox untuk memberikan jarak antara input field
                      const Text(
                        // Teks untuk label 'Quantity'
                        'Quantity',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      TextFormField(
                        // TextFormField untuk memasukkan jumlah produk
                        controller: productProvider
                            .quantityController, // Controller untuk nilai input
                        validator: (value) {
                          // Validator untuk validasi input
                          if (value!.isEmpty) {
                            // Jika nilai kosong, tampilkan pesan kesalahan
                            return 'Please enter product quantity';
                          }
                          return null; // Jika valid, kembalikan null
                        },
                        decoration: const InputDecoration(
                          // Dekorasi untuk input field
                          focusedBorder: OutlineInputBorder(
                            // Border saat input field fokus
                            borderSide: BorderSide(
                              width: 2,
                              color: Color.fromARGB(255, 51, 58, 115),
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          hintText:
                              'Enter product quantity', // Hint text untuk input field
                          hintStyle: TextStyle(
                            // Gaya untuk hint text
                            color: Color.fromARGB(255, 101, 101, 101),
                          ),
                          filled: true, //
                          fillColor: Color.fromARGB(255, 255, 236,
                              170), // Warna latar belakang input field
                          border: OutlineInputBorder(
                            // Border input field
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          errorStyle: TextStyle(
                            // Gaya untuk pesan kesalahan
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(
                          height:
                              10), // SizedBox untuk memberikan jarak antara input field
                      const Text(
                        // Teks untuk label 'Category'
                        'Category',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      DropdownButtonFormField<int>(
                        // DropdownButtonFormField untuk memilih kategori produk
                        value: int.tryParse(productProvider.categoryIdController
                            .text), // Nilai dropdown berdasarkan controller
                        items:
                            context // Item-item dropdown berdasarkan data kategori
                                    .watch<CategoryProvider>()
                                    .listCategory
                                    ?.map((category) {
                                  return DropdownMenuItem<int>(
                                    value:
                                        category.id ?? 0, // Nilai item dropdown
                                    child: Text(category.name ??
                                        ''), // Label item dropdown
                                  );
                                }).toList() ??
                                [], // Daftar item dropdown atau array kosong
                        onChanged: (value) {
                          // Ketika nilai dropdown berubah
                          setState(() {
                            // Mengatur state
                            productProvider.categoryIdController.text = value
                                .toString(); // Mengubah nilai controller kategori
                          });
                        },
                        decoration: const InputDecoration(
                          // Dekorasi untuk dropdown
                          filled:
                              true, // Mengisi dropdown dengan warna latar belakang
                          fillColor: Color.fromARGB(255, 255, 236,
                              170), // Warna latar belakang dropdown
                          border: OutlineInputBorder(
                            // Border dropdown
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                        ),
                      ),
                      const SizedBox(
                          height:
                              10), // SizedBox untuk memberikan jarak antara input field
                      const Text(
                        // Teks untuk label 'Image'
                        'Image',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      const SizedBox(
                          height:
                              10), // SizedBox untuk memberikan jarak antara input field
                      productProvider.selectedImage !=
                              null // Jika gambar terpilih
                          ? Image.file(productProvider
                              .selectedImage!) // Tampilkan gambar dari file terpilih
                          : productProvider.imageController.text
                                  .isNotEmpty // Jika URL gambar tersedia
                              ? Image.network(
                                  // Tampilkan gambar dari URL
                                  'http://10.0.2.2:3000/assets/images/products/${productProvider.imageController.text}',
                                  height: 250,
                                  width: 250,
                                )
                              : const Text(
                                  'No image selected.'), // Tampilkan teks jika tidak ada gambar yang terpilih
                      const SizedBox(
                          height:
                              10), // SizedBox untuk memberikan jarak antara input field
                      ElevatedButton(
                        // Tombol untuk memilih gambar
                        style: ElevatedButton.styleFrom(
                          // Gaya untuk tombol
                          backgroundColor: const Color.fromARGB(255, 255, 236,
                              170), // Warna latar belakang tombol
                          elevation: 5, // Elemen mengambang
                          shape: RoundedRectangleBorder(
                            // Bentuk tombol
                            borderRadius:
                                BorderRadius.circular(10), // Bentuk bulat
                          ),
                        ),
                        onPressed: () {
                          context
                              .read<ProductProvider>()
                              .pickImage(); // Panggil metode untuk memilih gambar
                        },
                        child: const Text(
                            'Pick Image'), // Teks untuk tombol memilih gambar
                      ),
                      const SizedBox(
                          height:
                              10), // SizedBox untuk memberikan jarak antara input field
                      ElevatedButton(
                        // Tombol untuk memperbarui produk
                        style: ElevatedButton.styleFrom(
                          // Gaya untuk tombol
                          backgroundColor:
                              Colors.amber, // Warna latar belakang tombol
                          elevation: 5, // Elemen mengambang
                          shape: RoundedRectangleBorder(
                            // Bentuk tombol
                            borderRadius:
                                BorderRadius.circular(10), // Bentuk bulat
                          ),
                        ),
                        onPressed: () {
                          if (productProvider.formKey.currentState!
                              .validate()) {
                            // Jika form valid
                            _showConfirmationDialog(context, () {
                              // Tampilkan dialog konfirmasi
                              productProvider.updatedByController.text =
                                  loggedInUsername; // Atur pengguna yang diperbarui
                              context.read<ProductProvider>().updateProduct(
                                  context); // Panggil metode untuk memperbarui produk
                            });
                          }
                        },
                        child: const Text(
                          // Teks untuk tombol memperbarui produk
                          "Update",
                          style: TextStyle(fontSize: 18, color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }

          return const SizedBox
              .shrink(); // Kembali SizedBox kosong jika tidak ada kecocokan status
        },
      ),
    );
  }
}
