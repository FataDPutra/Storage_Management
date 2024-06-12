import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Import untuk menggunakan Provider
import 'package:storage_management/providers/product_provider.dart'; // Import model ProductProvider
import 'package:storage_management/providers/category_provider.dart'; // Import model CategoryProvider
import 'package:storage_management/views/edit_product_page.dart'; // Import halaman EditProductPage
import 'package:storage_management/views/form_product_page.dart'; // Import halaman FormProductPage
import 'package:storage_management/views/detail_product_page.dart'; // Import halaman DetailProductPage

class ProductPage extends StatefulWidget {
  final String? username; // Username dari pengguna
  const ProductPage({required this.username, super.key});

  @override
  State<ProductPage> createState() =>
      _ProductPageState(); // Membuat state untuk ProductPage
}

class _ProductPageState extends State<ProductPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData(); // Memuat data setelah widget selesai dibangun
    });
  }

  void _loadData() {
    context
        .read<ProductProvider>()
        .getProducts(); // Memuat daftar produk dari server
    context
        .read<CategoryProvider>()
        .getCategories(); // Memuat daftar kategori dari server
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Product'), // Judul halaman
        titleTextStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.black,
          fontSize: 20,
        ),
        backgroundColor: Colors.grey[200], // Warna latar belakang AppBar
        actions: [
          IconButton(
            icon: const Icon(
                Icons.add_box_rounded), // Tombol untuk menambah produk baru
            color: Colors.black,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FormProductPage(
                      username: widget.username ??
                          ''), // Pindah ke halaman FormProductPage untuk menambah produk baru
                ),
              ).then((_) =>
                  _loadData()); // Memuat data ketika kembali dari halaman FormProductPage
            },
          ),
        ],
      ),
      body: Consumer<ProductProvider>(
        builder: (context, productProvider, child) {
          return bodyData(
              context,
              productProvider
                  .state); // Menampilkan data berdasarkan state dari ProductProvider
        },
      ),
      backgroundColor: const Color.fromARGB(
          255, 42, 98, 154), // Warna latar belakang halaman
    );
  }

  Widget bodyData(BuildContext context, ProductState state) {
    switch (state) {
      case ProductState.success:
        var dataResult = context
            .watch<ProductProvider>()
            .listProduct; // Mendapatkan daftar produk dari ProductProvider
        if (dataResult == null || dataResult.isEmpty) {
          // Menampilkan pesan jika tidak ada produk yang ditemukan
          return const Center(
            child: Text('No Data Product'),
          );
        }
        return Padding(
          padding: const EdgeInsets.all(10.0),
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // Dua item per baris
              childAspectRatio:
                  0.7, // Ratio aspek untuk menyesuaikan konten kartu
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: dataResult.length, // Jumlah item dalam daftar produk
            itemBuilder: (context, index) => Card(
              elevation: 2,
              margin: const EdgeInsets.all(8),
              color: const Color.fromARGB(255, 255, 218,
                  120), // Set warna latar belakang kartu menjadi kuning
              child: InkWell(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailProductPage(
                      id: dataResult[index].id ??
                          0, // Mengirim ID produk ke halaman DetailProductPage
                    ),
                  ),
                ).then((_) =>
                    _loadData()), // Memuat data ketika kembali dari halaman DetailProductPage
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 120,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(
                            'http://10.0.2.2:3000/assets/images/products/${dataResult[index].urlGambarProduct}', // URL gambar produk
                          ),
                          fit: BoxFit.cover,
                        ),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(4),
                          topRight: Radius.circular(4),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            dataResult[index].name ?? '', // Nama produk
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${dataResult[index].quantity?.toString() ?? ''} - ${dataResult[index].category?.name ?? ''}', // Informasi jumlah dan kategori produk
                            style: const TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit,
                              color: Colors.blue), // Tombol edit produk
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditFormProduct(
                                id: dataResult[index].id ??
                                    0, // Mengirim ID produk ke halaman EditProductPage
                                username: widget.username ??
                                    '', // Mengirim username ke halaman EditProductPage
                              ),
                            ),
                          ).then((_) =>
                              _loadData()), // Memuat data ketika kembali dari halaman EditProductPage
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete,
                              color: Colors.red), // Tombol hapus produk
                          onPressed: () => _showDeleteConfirmationDialog(
                            context,
                            dataResult[index].id ??
                                0, // Mengirim ID produk ke dialog konfirmasi penghapusan
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      case ProductState.nodata:
        return const Center(
          child: Text(
              'No Data Product'), // Menampilkan pesan jika tidak ada data produk
        );
      case ProductState.error:
        return Center(
          child: Text(context
              .watch<ProductProvider>()
              .messageError), // Menampilkan pesan error jika terjadi kesalahan
        );
      default:
        return const Center(
            child:
                CircularProgressIndicator()); // Menampilkan indikator loading saat memuat data
    }
  }

  void _showDeleteConfirmationDialog(BuildContext context, int productId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
              'Confirm Delete'), // Judul dialog konfirmasi penghapusan
          content: const Text(
              'Are you sure you want to delete this product?'), // Isi dialog
          actions: <Widget>[
            TextButton(
              child:
                  const Text('Cancel'), // Tombol untuk membatalkan penghapusan
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Delete'), // Tombol untuk menghapus produk
              onPressed: () {
                Navigator.of(context).pop(); // Menutup dialog konfirmasi
                _deleteProduct(context, productId); // Menghapus produk
              },
            ),
          ],
        );
      },
    );
  }

  void _deleteProduct(BuildContext context, int productId) {
    context.read<ProductProvider>().deleteProduct(context, productId).then((_) {
      _loadData(); // Memuat data kembali setelah penghapusan berhasil
    });
  }
}
