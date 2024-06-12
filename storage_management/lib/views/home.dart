import 'package:flutter/material.dart'; // Impor paket material dari Flutter
import 'package:giffy_dialog/giffy_dialog.dart'; // Impor paket giffy_dialog
import 'package:provider/provider.dart'; // Impor paket provider
import 'package:storage_management/views/edit_user_page.dart'; // Impor widget EditUserPage
import 'package:storage_management/views/product_page.dart'; // Impor widget ProductPage
import 'package:storage_management/views/category_page.dart'; // Impor widget CategoryPage
import 'package:storage_management/views/user_page.dart'; // Impor widget UserPage
import 'package:storage_management/providers/auth_provider.dart'; // Impor AuthProvider

class Home extends StatelessWidget {
  // Definisikan StatelessWidget bernama Home
  final int id; // Deklarasikan variabel integer id
  final String username; // Deklarasikan variabel string username
  final String image; // Deklarasikan variabel string image
  const Home(
      { // Konstruktor untuk widget Home
      super.key, // Panggil konstruktor superclass dengan parameter key
      required this.username, // Username merupakan parameter wajib
      required this.id, // Id merupakan parameter wajib
      required this.image // Image merupakan parameter wajib
      });

  @override
  Widget build(BuildContext context) {
    // Metode build untuk widget Home
    return MaterialApp(
      // Kembalikan widget MaterialApp
      theme: ThemeData(useMaterial3: true), // Atur data tema
      home: NavigationExample(
        // Atur properti home menjadi widget NavigationExample
        username: username, // Kirim username ke NavigationExample
        id: id, // Kirim id ke NavigationExample
        image: image, // Kirim image ke NavigationExample
      ),
    );
  }
}

class NavigationExample extends StatefulWidget {
  // Definisikan StatefulWidget bernama NavigationExample
  final String username; // Deklarasikan variabel string username
  final int id; // Deklarasikan variabel integer id
  final String image; // Deklarasikan variabel string image
  const NavigationExample(
      { // Konstruktor untuk widget NavigationExample
      super.key, // Panggil konstruktor superclass dengan parameter key
      required this.username, // Username merupakan parameter wajib
      required this.id, // Id merupakan parameter wajib
      required this.image // Image merupakan parameter wajib
      });

  @override
  State<NavigationExample> createState() =>
      _NavigationExampleState(); // Buat state untuk NavigationExample
}

class _NavigationExampleState extends State<NavigationExample> {
  // Definisikan kelas state untuk NavigationExample
  int currentPageIndex = 0; // Inisialisasi currentPageIndex menjadi 0

  @override
  Widget build(BuildContext context) {
    // Metode build untuk kelas state
    return Scaffold(
      // Kembalikan widget Scaffold
      appBar: AppBar(
        // Atur app bar
        title: const Text('Storage Management System'), // Atur judul
        titleTextStyle: const TextStyle(
            // Atur gaya untuk judul
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontSize: 20),
        backgroundColor: Colors.amber, // Atur warna latar belakang
        actions: [
          // Atur aksi untuk app bar
          IconButton(
            // Tambahkan IconButton untuk logout
            icon: const Icon(Icons.logout), // Atur ikon menjadi logout
            onPressed: () {
              // Atur fungsi onPressed
              _confirmLogout(context); // Panggil metode _confirmLogout
            },
          ),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        // Atur bottom navigation bar
        onDestinationSelected: (int index) {
          // Atur callback saat destinasi dipilih
          setState(() {
            // Atur state untuk memperbarui UI
            currentPageIndex = index; // Perbarui indeks halaman saat ini
          });
        },
        indicatorColor: Colors.amber, // Atur warna indikator
        selectedIndex: currentPageIndex, // Atur indeks terpilih
        destinations: [
          // Tentukan destinasi navigasi
          const NavigationDestination(
            // Destinasi untuk Produk
            selectedIcon: Icon(
              Icons.article,
              size: 35,
            ), // Ikona terpilih
            icon: Icon(
              Icons.article_outlined,
              size: 35,
            ), // Ikona
            label: 'Produk', // Label
          ),
          const NavigationDestination(
            // Destinasi untuk Kategori
            selectedIcon: Icon(
              Icons.category,
              size: 35,
            ), // Ikona terpilih
            icon: Icon(
              Icons.category_outlined,
              size: 35,
            ), // Ikona
            label: 'Kategori', // Label
          ),
          const NavigationDestination(
            // Destinasi untuk Pengguna
            selectedIcon: Icon(
              Icons.people_alt_rounded,
              size: 35,
            ), // Ikona terpilih
            icon: Icon(
              Icons.people_alt_outlined,
              size: 35,
            ), // Ikona
            label: 'Pengguna', // Label
          ),
          NavigationDestination(
            // Destinasi untuk profil pengguna
            selectedIcon: CircleAvatar(
              // Ikona terpilih (Gambar pengguna)
              radius: 17.5,
              backgroundImage: NetworkImage(
                  'http://10.0.2.2:3000/assets/images/users/${widget.image}'), // Atur gambar latar belakang
            ),
            icon: CircleAvatar(
              // Ikona (Gambar pengguna)
              radius: 17.5,
              backgroundImage: NetworkImage(
                  'http://10.0.2.2:3000/assets/images/users/${widget.image}'), // Atur gambar latar belakang
            ),
            label: widget.username, // Label (Username)
          ),
        ],
      ),
      body: [
        // Tentukan halaman untuk konten body
        ProductPage(
          // Halaman produk
          username: widget.username, // Kirim username
        ),
        CategoryPage(
          // Halaman kategori
          username: widget.username, // Kirim username
        ),
        UserPage(
          // Halaman pengguna
          username: widget.username, // Kirim username
        ),
        EditFormUser(
          // Halaman edit pengguna
          id: widget.id, // Kirim id
        ),
      ][currentPageIndex], // Tampilkan halaman berdasarkan indeks saat ini
    );
  }

  void _confirmLogout(BuildContext context) {
    // Metode untuk menampilkan dialog konfirmasi logout
    showDialog(
      // Tampilkan dialog
      context: context, // Atur konteks
      builder: (BuildContext context) {
        // Builder untuk dialog
        return GiffyDialog.image(
          // Kembalikan GiffyDialog dengan gambar
          Image.asset(
            // Atur asset gambar
            'lib/assets/gif/logout.gif', // Path asset
            fit: BoxFit.fill, // Atur gambar agar memenuhi ruang
            height: 250, // Atur tinggi
          ),
          title: const Text(
            // Atur judul dialog
            'Konfirmasi Logout', // Teks judul
            textAlign: TextAlign.center, // Rata tengah

            style: TextStyle(
                fontSize: 22.0, fontWeight: FontWeight.bold), // Gaya teks judul
          ),
          content: const Text(
            // Atur konten dialog
            'Apakah Anda yakin ingin keluar?', // Teks konten
            textAlign: TextAlign.center, // Rata tengah
          ),
          actions: [
            // Tentukan aksi untuk dialog
            TextButton(
              // Tombol Batal
              onPressed: () {
                // Callback saat tombol ditekan
                Navigator.pop(
                    context, 'CANCEL'); // Tutup dialog dengan 'CANCEL'
              },
              style: ButtonStyle(
                // Gaya tombol
                backgroundColor: MaterialStateProperty.all<Color>(
                    Colors.blue), // Atur warna latar belakang
              ),
              child: const Text(
                // Teks tombol
                'BATAL', // Teks
                style: TextStyle(color: Colors.white), // Warna teks
              ),
            ),
            TextButton(
              // Tombol Logout
              onPressed: () {
                // Callback saat tombol ditekan
                final authProvider = Provider.of<AuthProvider>(context,
                    listen: false); // Akses AuthProvider
                authProvider
                    .logout(context); // Panggil metode logout dari AuthProvider
              },
              style: ButtonStyle(
                // Gaya tombol
                backgroundColor: MaterialStateProperty.all<Color>(
                    Colors.red), // Atur warna latar belakang
              ),
              child: const Text(
                // Teks tombol
                'LOGOUT', // Teks
                textAlign: TextAlign.center, // Rata tengah
                style: TextStyle(
                  // Gaya teks tombol
                  color: Colors.white, // Warna teks
                  fontWeight: FontWeight.bold, // Bobot teks tebal
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
