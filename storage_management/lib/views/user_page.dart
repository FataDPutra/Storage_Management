import 'package:flutter/material.dart'; // Mengimpor library dari Flutter untuk pengembangan antarmuka pengguna.
import 'package:provider/provider.dart'; // Mengimpor library untuk menggunakan Provider, sebuah library state management.
import 'package:storage_management/providers/user_provider.dart'; // Mengimpor provider yang digunakan untuk mengelola data pengguna.
import 'package:storage_management/views/edit_user_page.dart'; // Mengimpor halaman untuk mengedit pengguna.
import 'package:storage_management/views/form_user_page.dart'; // Mengimpor halaman untuk membuat pengguna.

class UserPage extends StatefulWidget {
  // Mendefinisikan kelas UserPage sebagai StatefulWidget.
  final String username; // Variabel untuk menyimpan nama pengguna.
  const UserPage(
      {Key? key,
      required this.username}); // Konstruktor untuk menginisialisasi UserPage.

  @override
  State<UserPage> createState() => _UserPageState(); // Membuat state UserPage.
}

class _UserPageState extends State<UserPage> {
  // Mendefinisikan state untuk UserPage.
  @override
  void initState() {
    // Metode untuk inisialisasi state.
    super.initState();
    _loadData(); // Memuat data ketika halaman diinisialisasi.
  }

  void _loadData() {
    // Metode untuk memuat data pengguna.
    context
        .read<UserProvider>()
        .getUsers(); // Membaca provider untuk mendapatkan pengguna.
  }

  @override
  Widget build(BuildContext context) {
    // Metode untuk membangun antarmuka pengguna.
    return Scaffold(
      // Mengembalikan scaffold, kerangka dasar aplikasi.
      appBar: AppBar(
        // AppBar, bagian atas aplikasi.
        title: const Text('Daftar User'), // Judul AppBar.
        titleTextStyle: const TextStyle(
          // Gaya teks judul.
          fontWeight: FontWeight.bold,
          fontSize: 20,
          color: Colors.black,
        ),
        backgroundColor: Colors.grey[200], // Warna latar belakang AppBar.
        actions: [
          // Tombol aksi di sebelah kanan AppBar.
          IconButton(
            // Tombol ikon untuk menambahkan pengguna.
            icon: const Icon(Icons.add_box_rounded), // Ikon tambah.
            onPressed: () {
              context.read<UserProvider>().resetControllers();
              // Saat tombol ditekan.
              Navigator.push(
                // Navigasi ke halaman tambah pengguna.
                context,
                MaterialPageRoute(
                  builder: (context) => const FormUserPage(),
                ),
              ).then((_) => _loadData()); // Muat ulang data ketika kembali.
            },
          ),
        ],
      ),
      body: Consumer<UserProvider>(
        // Consumer untuk mendengarkan perubahan pada provider.
        builder: (context, userProvider, child) {
          // Membangun antarmuka berdasarkan state provider.
          return bodyData(context, userProvider.state, userProvider);
        },
      ),
      backgroundColor: const Color.fromARGB(
          255, 42, 98, 154), // Warna latar belakang halaman.
    );
  }

  Widget bodyData(
    // Widget untuk membangun bagian isi dari halaman.
    BuildContext context,
    UserState state,
    UserProvider userProvider,
  ) {
    switch (state) {
      // Memeriksa status state provider.
      case UserState.success: // Jika berhasil mendapatkan data pengguna.
        var dataResult = userProvider.listUser; // Mendapatkan daftar pengguna.
        if (dataResult == null || dataResult.isEmpty) {
          // Jika tidak ada data pengguna.
          return const Center(
            // Tampilan tengah halaman.
            child: Text('No Data User'), // Teks tidak ada data pengguna.
          );
        }
        return Padding(
          // Padding untuk daftar pengguna.
          padding: const EdgeInsets.all(10.0),
          child: ListView.builder(
            // ListView untuk menampilkan daftar pengguna.
            itemCount: dataResult.length, // Jumlah item dalam daftar.
            itemBuilder: (context, index) => Card(
              // Membangun kartu untuk setiap pengguna.
              elevation: 4, // Efek bayangan kartu.
              color: const Color.fromARGB(
                  255, 255, 218, 120), // Warna latar belakang kartu.
              margin: const EdgeInsets.symmetric(
                  vertical: 8, horizontal: 16), // Margin kartu.
              shape: RoundedRectangleBorder(
                // Bentuk kartu.
                borderRadius: BorderRadius.circular(15),
              ),
              child: ListTile(
                // Isi kartu sebagai ListTile.
                contentPadding: const EdgeInsets.all(
                    16.0), // Padding konten dalam ListTile.
                leading: Container(
                  // Bagian kiri dengan gambar.
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    // Mendekorasi kontainer gambar.
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      // Gambar dari URL.
                      image: NetworkImage(
                        'http://10.0.2.2:3000/assets/images/users/${dataResult[index].image}',
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                title: Text(
                  // Judul dari pengguna.
                  dataResult[index].username ?? '',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.black87,
                  ),
                ),
                trailing: Row(
                  // Bagian kanan dengan tombol edit dan hapus.
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    InkWell(
                      // Tombol untuk mengedit pengguna.
                      onTap: () => Navigator.push(
                        // Navigasi ke halaman edit.
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditFormUser(
                            // Halaman edit pengguna.
                            id: dataResult[index].id ?? 0, // ID pengguna.
                          ),
                        ),
                      ).then((_) =>
                          _loadData()), // Muat ulang data ketika kembali.
                      child: const Icon(
                        // Ikon untuk tombol edit.
                        Icons.edit,
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(width: 20), // Spasi antara tombol.
                    InkWell(
                      // Tombol untuk menghapus pengguna.
                      onTap: () => _showDeleteConfirmationDialog(
                        // Tampilkan dialog konfirmasi hapus.
                        context,
                        dataResult[index].id ??
                            0, // ID pengguna yang akan dihapus.
                        userProvider,
                      ),
                      child: const Icon(
                        // Ikon untuk tombol hapus.
                        Icons.delete,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      case UserState.nodata: // Jika tidak ada data pengguna.
        return const Center(
          // Tampilan tengah halaman.
          child: Text('No Data User'), // Teks tidak ada data pengguna.
        );
      case UserState.error: // Jika terjadi kesalahan.
        return Center(
          // Tampilan tengah halaman.
          child:
              Text(userProvider.messageError), // Teks kesalahan dari provider.
        );
      default: // Saat status sedang memuat.
        return const Center(
            child:
                CircularProgressIndicator()); // Tampilkan indikator loading di tengah halaman.
    }
  }

  void _showDeleteConfirmationDialog(
    // Metode untuk menampilkan dialog konfirmasi penghapusan.
    BuildContext context,
    int userId,
    UserProvider userProvider,
  ) {
    showDialog(
      // Menampilkan dialog.
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          // Dialog alert untuk konfirmasi.
          title: const Text('Confirm Delete'), // Judul dialog.
          content: const Text(
              'Are you sure you want to delete this user?'), // Isi dialog.
          actions: <Widget>[
            // Aksi dalam dialog.
            TextButton(
              // Tombol untuk membatalkan penghapusan.
              child: const Text('Cancel'), // Teks tombol.
              onPressed: () {
                // Saat tombol ditekan.
                Navigator.of(context).pop(); // Tutup dialog.
              },
            ),
            TextButton(
              // Tombol untuk menghapus pengguna.
              child: const Text('Delete'), // Teks tombol.
              onPressed: () {
                // Saat tombol ditekan.
                Navigator.of(context).pop(); // Tutup dialog.
                _deleteUser(context, userId, userProvider); // Hapus pengguna.
              },
            ),
          ],
        );
      },
    );
  }

  void _deleteUser(
    // Metode untuk menghapus pengguna.
    BuildContext context,
    int userId,
    UserProvider userProvider,
  ) {
    userProvider.deleteUser(context, userId).then((_) {
      // Panggil metode untuk menghapus pengguna dari provider.
      _loadData(); // Muat ulang data setelah penghapusan berhasil.
    });
  }
}
