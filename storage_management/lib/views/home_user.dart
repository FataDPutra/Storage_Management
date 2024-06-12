import 'package:flutter/material.dart'; // Import library Flutter untuk komponen UI
import 'package:giffy_dialog/giffy_dialog.dart'; // Import Giffy Dialog untuk dialog animasi
import 'package:provider/provider.dart'; // Import paket Provider untuk manajemen state
import 'package:storage_management/views/category_page.dart'; // Import view CategoryPage
import 'package:storage_management/views/edit_user_page.dart'; // Import view EditUserPage
import 'package:storage_management/views/product_page.dart'; // Import view ProductPage
import 'package:storage_management/providers/auth_provider.dart'; // Import AuthProvider

// Mendefinisikan widget stateless untuk halaman utama
class HomeUser extends StatelessWidget {
  final int id; // ID pengguna
  final String username; // Nama pengguna
  final String image; // URL gambar profil pengguna

  // Konstruktor untuk widget HomeUser
  const HomeUser({
    super.key,
    required this.username,
    required this.id,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    // Mengembalikan MaterialApp dengan tema dan widget NavigationExampleUser
    return MaterialApp(
      theme: ThemeData(useMaterial3: true), // Menetapkan tema untuk aplikasi
      home: NavigationExampleUser(
          username: username,
          id: id,
          image: image), // Mengatur NavigationExampleUser sebagai layar utama
    );
  }
}

// Mendefinisikan StatefulWidget untuk navigasi bar dan body
class NavigationExampleUser extends StatefulWidget {
  final String username; // Nama pengguna
  final int id; // ID pengguna
  final String image; // URL gambar profil pengguna

  // Konstruktor untuk widget NavigationExampleUser
  const NavigationExampleUser({
    super.key,
    required this.username,
    required this.id,
    required this.image,
  });

  @override
  State<NavigationExampleUser> createState() => _NavigationExampleUserState();
}

// Mendefinisikan state untuk widget NavigationExampleUser
class _NavigationExampleUserState extends State<NavigationExampleUser> {
  int currentPageIndex = 0; // Indeks halaman saat ini

  @override
  Widget build(BuildContext context) {
    // Mengembalikan widget Scaffold yang berisi app bar, bottom navigation bar, dan body
    return Scaffold(
      appBar: AppBar(
        // App bar dengan judul dan tombol logout
        title: const Text('Storage Management System'), // Judul aplikasi
        titleTextStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.black,
          fontSize: 20,
        ), // Gaya teks judul
        backgroundColor: Colors.amber, // Warna latar belakang app bar
        actions: [
          // Tombol logout
          IconButton(
            icon: const Icon(Icons.logout), // Ikon untuk logout
            onPressed: () {
              _confirmLogout(context); // Panggil fungsi untuk konfirmasi logout
            },
          ),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        // Bottom navigation bar untuk beralih antar halaman
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index; // Set indeks halaman saat ini
          });
        },
        indicatorColor: Colors.amber, // Warna indikator pilihan
        selectedIndex: currentPageIndex, // Indeks halaman yang dipilih
        destinations: [
          // Tentukan destinasi navigasi
          const NavigationDestination(
            selectedIcon: Icon(
              Icons.article,
              size: 35,
            ),
            icon: Icon(
              Icons.article_outlined,
              size: 35,
            ),
            label: 'Produk',
          ),
          const NavigationDestination(
            selectedIcon: Icon(
              Icons.category,
              size: 35,
            ),
            icon: Icon(
              Icons.category_outlined,
              size: 35,
            ),
            label: 'Kategori',
          ),
          NavigationDestination(
            selectedIcon: CircleAvatar(
              radius: 17.5,
              backgroundImage: NetworkImage(
                  'http://10.0.2.2:3000/assets/images/users/${widget.image}'),
            ),
            icon: CircleAvatar(
              radius: 17.5,
              backgroundImage: NetworkImage(
                  'http://10.0.2.2:3000/assets/images/users/${widget.image}'),
            ),
            label: widget.username,
          ),
        ],
      ),
      body: [
        // Tentukan halaman untuk body berdasarkan indeks halaman saat ini
        ProductPage(username: widget.username), // Halaman produk
        CategoryPage(username: widget.username), // Halaman kategori
        EditFormUser(id: widget.id), // Halaman edit pengguna
      ][currentPageIndex], // Dapatkan halaman saat ini berdasarkan indeks
    );
  }

  // Fungsi untuk menampilkan dialog konfirmasi logout
  void _confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return GiffyDialog.image(
          Image.asset(
            'lib/assets/gif/logout.gif',
            fit: BoxFit.fill,
            height: 250,
          ),
          title: const Text(
            'Konfirmasi Logout',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
          ),
          content: const Text(
            'Apakah Anda yakin ingin keluar?',
            textAlign: TextAlign.center,
          ),
          actions: [
            // Tombol Batal
            TextButton(
              onPressed: () {
                Navigator.pop(
                    context, 'CANCEL'); // Tutup dialog dengan tindakan batal
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                    Colors.blue), // Warna latar belakang tombol
              ),
              child: const Text(
                'BATAL', // Teks untuk tombol batal
                style: TextStyle(color: Colors.white), // Gaya teks
              ),
            ),
            // Tombol Logout
            TextButton(
              onPressed: () {
                final authProvider = Provider.of<AuthProvider>(context,
                    listen: false); // Dapatkan authProvider dari konteks
                authProvider
                    .logout(context); // Panggil fungsi logout dari authProvider
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                    Colors.red), // Warna latar belakang tombol
              ),
              child: const Text(
                'LOGOUT', // Teks untuk tombol logout
                textAlign: TextAlign.center, // Penyelarasan teks
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ), // Gaya teks
              ),
            ),
          ],
        );
      },
    );
  }
}
