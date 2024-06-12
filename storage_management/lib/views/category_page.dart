import 'package:flutter/material.dart'; // Mengimpor library Material dari Flutter
import 'package:provider/provider.dart'; // Mengimpor library Provider untuk manajemen state
import 'package:storage_management/providers/category_provider.dart'; // Mengimpor kelas CategoryProvider
import 'package:storage_management/views/edit_category_page.dart'; // Mengimpor kelas EditFormCategory
import 'package:storage_management/views/form_category_page.dart'; // Mengimpor kelas FormCategoryPage

class CategoryPage extends StatefulWidget {
  // Mendefinisikan StatefulWidget untuk Halaman Kategori
  final String username; // Variabel username bertipe String
  const CategoryPage({Key? key, required this.username})
      : super(key: key); // Konstruktor untuk kelas CategoryPage

  @override
  State<CategoryPage> createState() =>
      _CategoryPageState(); // Melakukan override metode createState untuk membuat instansi baru dari _CategoryPageState
}

class _CategoryPageState extends State<CategoryPage> {
  // Mendefinisikan kelas state _CategoryPageState yang meng-extend State<CategoryPage>
  @override
  void initState() {
    // Melakukan override metode initState untuk melakukan inisialisasi saat halaman diinisialisasi
    super.initState(); // Memanggil metode initState dari superclass
    _loadData(); // Memuat data ketika halaman diinisialisasi
  }

  void _loadData() {
    // Mendefinisikan metode untuk memuat data
    context
        .read<CategoryProvider>()
        .getCategories(); // Menggunakan Provider untuk mengakses CategoryProvider dan memanggil metode getCategories untuk memuat kategori
  }

  @override
  Widget build(BuildContext context) {
    // Melakukan override metode build untuk membangun UI
    return Scaffold(
      // Mengembalikan widget Scaffold
      appBar: AppBar(
        // Mengatur app bar
        title: const Text('Daftar Category'), // Mengatur judul app bar
        titleTextStyle: const TextStyle(
          // Mengatur gaya teks untuk judul
          fontWeight: FontWeight.bold, // Mengatur tebal huruf menjadi bold
          color: Colors.black, // Mengatur warna teks menjadi hitam
          fontSize: 20, // Mengatur ukuran huruf menjadi 20
        ),
        backgroundColor:
            Colors.grey[200], // Mengatur warna latar belakang app bar
        actions: [
          // Mendefinisikan tindakan untuk app bar
          IconButton(
            // Menambahkan tombol ikon untuk menambahkan kategori baru
            icon: const Icon(
                Icons.add_box_rounded), // Mengatur ikon menjadi add_box_rounded
            onPressed: () {
              // Mendefinisikan callback onPressed untuk tombol ikon
              context
                  .read<CategoryProvider>()
                  .nameController
                  .clear(); // Membersihkan pengontrol nama dari CategoryProvider
              Navigator.push(
                // Menavigasi ke FormCategoryPage saat tombol ditekan
                context,
                MaterialPageRoute(
                  builder: (context) => const FormCategoryPage(),
                ),
              ).then((_) =>
                  _loadData()); // Memuat ulang data setelah kembali dari FormCategoryPage
            },
          ),
        ],
      ),
      body: Consumer<CategoryProvider>(
        // Menggunakan widget Consumer untuk mendengarkan perubahan dalam CategoryProvider
        builder: (context, categoryProvider, child) {
          // Mendefinisikan fungsi pembangun untuk widget Consumer
          return bodyData(context, categoryProvider.state,
              categoryProvider); // Mengembalikan data tubuh berdasarkan status dari CategoryProvider
        },
      ),
      backgroundColor: const Color.fromARGB(
          255, 42, 98, 154), // Mengatur warna latar belakang scaffold
    );
  }

  Widget bodyData(
    // Mendefinisikan metode untuk membangun tubuh berdasarkan status
    BuildContext context, // Konteks widget
    CategoryState state, // Status kategori
    CategoryProvider categoryProvider, // Instansi CategoryProvider
  ) {
    switch (state) {
      // Switch statement berdasarkan status
      case CategoryState.success: // Jika berhasil memuat kategori
        var dataResult = categoryProvider
            .listCategory; // Mendapatkan daftar kategori dari CategoryProvider
        if (dataResult == null || dataResult.isEmpty) {
          // Memeriksa apakah daftar kosong
          return const Center(
            // Mengembalikan widget teks yang terpusat jika tidak ada data
            child: Text('No Data Category'),
          );
        }
        return Padding(
          // Mengembalikan ListView yang dipadatkan untuk menampilkan kategori
          padding: const EdgeInsets.all(10.0),
          child: ListView.builder(
            itemCount: dataResult.length,
            itemBuilder: (context, index) => Card(
              // Membangun sebuah kartu untuk setiap kategori
              color: const Color.fromARGB(255, 255, 218, 120),
              elevation: 4,
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            dataResult[index].name ?? '', // Nama kategori
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        InkWell(
                          onTap: () => Navigator.push(
                            // Menavigasi ke EditFormCategory ketika ikon edit ditekan
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditFormCategory(
                                id: dataResult[index].id ?? 0,
                              ),
                            ),
                          ).then((_) =>
                              _loadData()), // Memuat ulang data saat kembali dari EditFormCategory
                          child: const Icon(
                            Icons.edit,
                            color: Colors.blue, // Ikon edit
                          ),
                        ),
                        const SizedBox(width: 20),
                        InkWell(
                          onTap: () => _showDeleteConfirmationDialog(
                            // Menampilkan dialog konfirmasi penghapusan saat ikon hapus ditekan
                            context,
                            dataResult[index].id ?? 0,
                          ),
                          child: const Icon(
                            Icons.delete,
                            color: Colors.red, // Ikon hapus
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
      case CategoryState.nodata: // Jika tidak ada data kategori
        return const Center(
          child: Text('No Data Category'),
        );
      case CategoryState.error: // Jika terjadi kesalahan
        return Center(
          child: Text(
              categoryProvider.messageError), // Menampilkan pesan kesalahan
        );
      default: // Menampilkan indikator loading saat memuat data
        return const Center(child: CircularProgressIndicator());
    }
  }

  void _showDeleteConfirmationDialog(BuildContext context, int categoryId) {
    // Dialog konfirmasi penghapusan kategori
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Delete'),
          content: const Text('Are you sure you want to delete this category?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(); // Menutup dialog
              },
            ),
            TextButton(
              child: const Text('Delete'),
              onPressed: () {
                Navigator.of(context).pop(); // Menutup dialog
                _deleteCategory(context, categoryId); // Menghapus kategori
              },
            ),
          ],
        );
      },
    );
  }

  void _deleteCategory(BuildContext context, int categoryId) {
    // Menghapus kategori
    context
        .read<CategoryProvider>()
        .deleteCategory(context, categoryId)
        .then((_) {
      _loadData(); // Memuat ulang data setelah penghapusan berhasil
    });
  }
}
