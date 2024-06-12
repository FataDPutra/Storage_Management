import 'package:flutter/material.dart'; // Mengimpor paket Flutter Material
import 'package:dio/dio.dart'; // Mengimpor paket Dio untuk HTTP requests
import 'package:giffy_dialog/giffy_dialog.dart'; // Mengimpor paket Giffy Dialog untuk dialog animasi
import 'package:shared_preferences/shared_preferences.dart'; // Mengimpor paket SharedPreferences untuk penyimpanan data lokal
import 'package:storage_management/main.dart'; // Mengimpor file main.dart dari proyek
import 'package:storage_management/views/home.dart'; // Mengimpor file home.dart dari proyek
import 'package:storage_management/views/home_user.dart'; // Mengimpor file home_user.dart dari proyek
import 'package:storage_management/views/login_page.dart'; // Mengimpor file login_page.dart dari proyek

// Mendefinisikan kelas AuthProvider yang memperpanjang ChangeNotifier untuk manajemen state
class AuthProvider extends ChangeNotifier {
  late SharedPreferences
      _sharedPref; // Instance SharedPreferences untuk menyimpan data pengguna secara lokal
  final formKeyLogin = GlobalKey<FormState>(); // Key untuk form login
  final formKeyRegister = GlobalKey<FormState>(); // Key untuk form register
  TextEditingController usernameController =
      TextEditingController(); // Controller untuk input username
  TextEditingController passwordController =
      TextEditingController(); // Controller untuk input password

  var loginState = StateLogin.initial; // State awal untuk login
  var registerState = StateRegister.initial; // State awal untuk register
  var id = 0; // ID pengguna
  var username = ''; // Username pengguna
  var image = ''; // URL gambar pengguna
  var messageError = ''; // Pesan error
  bool obscurePassword = true; // State untuk visibilitas password

  // Fungsi untuk menangani proses registrasi
  Future<void> processRegister(BuildContext context) async {
    final Dio dio = Dio(); // Instance Dio untuk membuat HTTP requests
    const String checkUrl =
        'http://10.0.2.2:3000/users/check'; // URL untuk mengecek apakah username sudah ada
    const String registerUrl =
        'http://10.0.2.2:3000/users/add'; // URL untuk menambahkan pengguna baru
    final Map<String, dynamic> data = {
      'username':
          usernameController.text, // Mengambil nilai dari usernameController
      'password':
          passwordController.text, // Mengambil nilai dari passwordController
    };

    if (formKeyRegister.currentState!.validate()) {
      // Validasi form register
      if (passwordController.text.length < 8) {
        // Cek panjang password
        showAlertError(context,
            'Password harus memiliki minimal 8 karakter!'); // Tampilkan pesan error jika password kurang dari 8 karakter
        return;
      }
      try {
        // Cek apakah username sudah ada
        final responseCheck = await dio.post(checkUrl, data: data);
        if (responseCheck.statusCode == 200) {
          if (responseCheck.data['exists']) {
            showAlertError(context,
                'Username sudah digunakan, silakan gunakan username lain.'); // Tampilkan pesan error jika username sudah digunakan
            return;
          }
        }

        // Jika username belum digunakan, lanjutkan dengan registrasi
        final responseRegister = await dio.post(registerUrl, data: data);
        if (responseRegister.statusCode == 200) {
          username = usernameController.text; // Set username
          registerState =
              StateRegister.success; // Ubah state register menjadi success
          usernameController.clear(); // Bersihkan usernameController
          passwordController.clear(); // Bersihkan passwordController
          formKeyRegister.currentState?.reset(); // Reset form register
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return GiffyDialog.image(
                Image.asset(
                  'lib/assets/gif/register.gif', // Gambar animasi untuk dialog register berhasil
                  height: 250,
                  fit: BoxFit.cover,
                ),
                title: const Text(
                  'Register Berhasil', // Judul dialog
                  textAlign: TextAlign.center,
                ),
                content: Text(
                  'Anda berhasil Register dengan username: $username', // Pesan dialog
                  textAlign: TextAlign.center,
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      usernameController
                          .clear(); // Bersihkan usernameController
                      passwordController
                          .clear(); // Bersihkan passwordController
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const LoginPage()), // Navigasi ke halaman login
                      );
                    },
                    child: const Text('OK'),
                  ),
                ],
              );
            },
          );
        } else {
          registerState =
              StateRegister.error; // Ubah state register menjadi error
          messageError = responseRegister.data['message']; // Set pesan error
          showAlertError(context, messageError); // Tampilkan pesan error
        }
      } catch (error) {
        registerState =
            StateRegister.error; // Ubah state register menjadi error
        messageError = 'An error occurred: $error'; // Set pesan error
        showAlertError(context, messageError); // Tampilkan pesan error
      }
    } else {
      showAlertError(context,
          'Periksa Kelengkapan Data!'); // Tampilkan pesan error jika form tidak valid
    }
    notifyListeners(); // Beritahu pendengar bahwa state telah berubah
  }

  // Fungsi untuk menangani proses login
  Future<void> processLogin(BuildContext context) async {
    final Dio dio = Dio(); // Instance Dio untuk membuat HTTP requests
    const String url = 'http://10.0.2.2:3000/users/login'; // URL untuk login
    final Map<String, dynamic> data = {
      'username':
          usernameController.text, // Mengambil nilai dari usernameController
      'password':
          passwordController.text, // Mengambil nilai dari passwordController
    };

    if (formKeyLogin.currentState!.validate()) {
      // Validasi form login
      if (passwordController.text.length < 8) {
        // Cek panjang password
        showAlertError(context,
            'Password harus memiliki minimal 8 karakter!'); // Tampilkan pesan error jika password kurang dari 8 karakter
        return;
      }
      try {
        final response =
            await dio.post(url, data: data); // Kirim data login ke server
        if (response.statusCode == 200) {
          id = response.data['id']; // Set ID pengguna
          username = response.data['username']; // Set username
          image = response.data['image']; // Set URL gambar pengguna
          _sharedPref = await SharedPreferences
              .getInstance(); // Inisialisasi SharedPreferences
          await _sharedPref.setInt('id', id); // Simpan ID pengguna
          await _sharedPref.setString(
              'username', username); // Simpan username pengguna
          await _sharedPref.setString(
              'image', image); // Simpan URL gambar pengguna
          loginState = StateLogin.success; // Ubah state login menjadi success
          usernameController.clear(); // Bersihkan usernameController
          passwordController.clear(); // Bersihkan passwordController
          formKeyLogin.currentState?.reset(); // Reset form login
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return GiffyDialog.image(
                Image.asset(
                  'lib/assets/gif/login.gif', // Gambar animasi untuk dialog login berhasil
                  height: 250,
                  fit: BoxFit.cover,
                ),
                title: const Text(
                  'Login Berhasil', // Judul dialog
                  textAlign: TextAlign.center,
                ),
                content: Text(
                  'Hello !! ${_sharedPref.getString('username')}', // Pesan dialog
                  textAlign: TextAlign.center,
                ),
                actions: [
                  ElevatedButton(
                    style: const ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll<Color>(
                          Colors.orange), // Warna tombol
                    ),
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => (username == 'administrator')
                              ? Home(
                                  id: id,
                                  username: username,
                                  image:
                                      image) // Navigasi ke halaman Home jika username adalah administrator
                              : HomeUser(
                                  id: id,
                                  username: username,
                                  image:
                                      image), // Navigasi ke halaman HomeUser jika username bukan administrator
                        ),
                      );
                    },
                    child: const Text(
                      'OK',
                      style:
                          TextStyle(color: Colors.white), // Warna teks tombol
                    ),
                  ),
                ],
              );
            },
          );
        } else {
          loginState = StateLogin.error; // Ubah state login menjadi error
          messageError = _handleLoginError(
              response.statusCode); // Set pesan error berdasarkan status code
          showAlertError(context, messageError); // Tampilkan pesan error
        }
      } catch (error) {
        loginState = StateLogin.error; // Ubah state login menjadi error
        messageError = _handleLoginError(error); // Set pesan error
        showAlertError(context, messageError); // Tampilkan pesan error
      }
    } else {
      showAlertError(context,
          'Periksa Kelengkapan Data!'); // Tampilkan pesan error jika form tidak valid
    }
    notifyListeners(); // Beritahu pendengar bahwa state telah berubah
  }

  // Fungsi helper untuk menangani berbagai error login
  String _handleLoginError(dynamic error) {
    if (error is DioError) {
      // Cek apakah error adalah instance dari DioError
      if (error.response != null) {
        // Cek apakah ada respon dari server
        if (error.response!.statusCode == 401) {
          return 'Username atau password tidak sesuai'; // Pesan error untuk status code 401
        } else if (error.response!.statusCode == 404) {
          return 'Username tidak ditemukan'; // Pesan error untuk status code 404
        }
      }
    }
    return 'An error occurred: $error'; // Pesan error umum
  }

  // Fungsi untuk toggle visibilitas password
  void actionObscurePassword() {
    obscurePassword = !obscurePassword; // Toggle state visibilitas password
    notifyListeners(); // Beritahu pendengar bahwa state telah berubah
  }

  // Fungsi untuk menangani proses logout
  Future<void> logout(BuildContext context) async {
    _sharedPref =
        await SharedPreferences.getInstance(); // Inisialisasi SharedPreferences
    await _sharedPref.remove('id'); // Hapus ID pengguna
    await _sharedPref.remove('username'); // Hapus username pengguna
    await _sharedPref.remove('image'); // Hapus URL gambar pengguna

    // Navigasi ke halaman login dan bersihkan stack navigasi
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
          builder: (context) => const MyApp()), // Navigasi ke MyApp
      (route) => false,
    );
  }
}

// Enum untuk merepresentasikan berbagai state untuk proses login dan register
enum StateLogin { initial, success, error } // State untuk login

enum StateRegister { initial, success, error } // State untuk register

// Fungsi untuk menampilkan alert error
void showAlertError(BuildContext context, String message) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return GiffyDialog.image(
        backgroundColor: const Color.fromARGB(
            255, 223, 236, 246), // Warna latar belakang dialog
        Image.asset(
          'lib/assets/gif/error.gif', // Gambar animasi untuk dialog error
          height: 250,
          fit: BoxFit.cover,
        ),
        title: const Text(
          'Data Invalid !', // Judul dialog
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Text(
          message, // Pesan dialog
          textAlign: TextAlign.center,
        ),
        actions: [
          ElevatedButton(
            style: ButtonStyle(
              backgroundColor:
                  MaterialStateProperty.all<Color>(Colors.red), // Warna tombol
            ),
            onPressed: () {
              Navigator.pop(context); // Tutup dialog saat tombol OK ditekan
            },
            child: const Text(
              'OK',
              style: TextStyle(color: Colors.white), // Warna teks tombol
            ),
          )
        ],
      );
    },
  );
}
