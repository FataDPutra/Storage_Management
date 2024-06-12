import 'package:flutter/material.dart'; // Mengimpor library Material dari Flutter
import 'package:provider/provider.dart'; // Mengimpor library Provider untuk manajemen state
import 'package:storage_management/providers/product_provider.dart'; // Mengimpor kelas ProductProvider untuk mengelola data produk

class DetailProductPage extends StatelessWidget {
  // Mendefinisikan kelas DetailProductPage sebagai StatelessWidget
  final int id; // Variabel id produk

  const DetailProductPage(
      {required this.id,
      super.key}); // Konstruktor untuk kelas DetailProductPage

  @override
  Widget build(BuildContext context) {
    // Metode build untuk membangun UI
    final productProvider =
        context.read<ProductProvider>(); // Membaca ProductProvider dari konteks

    return Scaffold(
      // Mengembalikan widget Scaffold
      appBar: AppBar(
        // AppBar untuk halaman detail produk
        title: const Text('Detail Product'), // Judul AppBar
        backgroundColor: Colors.amber, // Warna latar belakang AppBar
        leading: BackButton(
          // Tombol kembali pada AppBar
          onPressed: () => Navigator.pop(
              context), // Menggunakan Navigator untuk kembali ke halaman sebelumnya
        ),
      ),
      body: Container(
        // Container untuk body halaman
        color: const Color.fromARGB(
            255, 42, 98, 154), // Warna latar belakang container
        child: FutureBuilder(
          // FutureBuilder untuk menampilkan data produk yang akan datang
          future: productProvider.detailProduct(
              id), // Future untuk mendapatkan detail produk berdasarkan id
          builder: (context, snapshot) {
            // Pembangun UI berdasarkan status future
            if (snapshot.connectionState == ConnectionState.waiting) {
              // Jika sedang loading, tampilkan indikator loading
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              // Jika terjadi error, tampilkan pesan error
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              // Jika berhasil, tampilkan detail produk
              var product = productProvider.listProduct?.firstWhere((p) =>
                  p.id == id); // Mendapatkan detail produk berdasarkan id
              if (product == null) {
                // Jika produk tidak ditemukan, tampilkan pesan bahwa produk tidak ditemukan
                return const Center(child: Text('Product not found'));
              }
              return Padding(
                // Padding untuk konten
                padding: const EdgeInsets.all(16.0),
                child: ListView(
                  // ListView untuk menampilkan detail produk
                  children: [
                    product.urlGambarProduct != null // Jika ada gambar produk
                        ? Container(
                            // Tampilkan gambar produk
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            alignment: Alignment.center,
                            child: Image.network(
                              // Menampilkan gambar dari URL
                              'http://10.0.2.2:3000/assets/images/products/${product.urlGambarProduct}',
                              width: 250,
                              height: 250,
                            ),
                          )
                        : const SizedBox
                            .shrink(), // Jika tidak ada gambar, tidak menampilkan apa-apa
                    _buildDetailRow(
                        'ID',
                        product.id
                            .toString()), // Menampilkan baris detail untuk ID produk
                    _buildDetailRow(
                        'Name',
                        product.name ??
                            '-'), // Menampilkan baris detail untuk nama produk
                    _buildDetailRow(
                        'Quantity',
                        product.quantity
                            .toString()), // Menampilkan baris detail untuk kuantitas produk
                    _buildDetailRow(
                        'Category ID',
                        product.categoryId
                            .toString()), // Menampilkan baris detail untuk ID kategori produk
                    _buildDetailRow(
                        'Category',
                        product.category?.name ??
                            '-'), // Menampilkan baris detail untuk nama kategori produk
                    _buildDetailRow(
                        'Created By',
                        product.createdBy ??
                            '-'), // Menampilkan baris detail untuk pembuat produk
                    _buildDetailRow(
                        'Updated By',
                        product.updatedBy ??
                            '-'), // Menampilkan baris detail untuk pembuat pembaruan produk
                    _buildDetailRow(
                        'Created At',
                        product.createdAt ??
                            '-'), // Menampilkan baris detail untuk waktu pembuatan produk
                    _buildDetailRow(
                        'Updated At',
                        product.updatedAt ??
                            '-'), // Menampilkan baris detail untuk waktu pembaruan produk
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    // Metode untuk membangun baris detail
    return Padding(
      // Padding untuk baris detail
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        // Baris untuk menampilkan label dan nilai
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            // Menggunakan SizedBox untuk mengatur lebar label
            width: 100.0,
            child: Text(
              // Teks untuk label
              label,
              style: const TextStyle(
                // Gaya teks untuk label
                fontSize: 18,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(
              width:
                  16.0), // SizedBox untuk memberikan jarak antara label dan nilai
          Expanded(
            // Expanded untuk memastikan nilai mengambil sisa ruang yang tersedia
            child: Text(
              // Teks untuk nilai
              value,
              style: const TextStyle(
                  // Gaya teks untuk nilai
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
