import 'package:flutter/material.dart'; // Mengimpor pustaka Flutter Material
import 'package:dio/dio.dart'; // Mengimpor pustaka dio untuk HTTP requests
import 'package:image_picker/image_picker.dart'; // Mengimpor pustaka image_picker untuk memilih gambar dari galeri
import 'dart:io'; // Mengimpor pustaka dart:io untuk mengelola file

import 'package:storage_management/models/user_model.dart'; // Mengimpor model UserModel
import 'package:storage_management/models/user_response_model.dart'; // Mengimpor model UserResponseModel

// Mendefinisikan kelas UserProvider yang memperpanjang ChangeNotifier untuk manajemen state
class UserProvider extends ChangeNotifier {
  final formKey = GlobalKey<FormState>(); // Key untuk form
  TextEditingController usernameController =
      TextEditingController(); // Controller untuk input username
  TextEditingController passwordController =
      TextEditingController(); // Controller untuk input password
  TextEditingController imageController =
      TextEditingController(); // Controller untuk input URL gambar pengguna

  File? selectedImage; // Variabel untuk menyimpan gambar yang dipilih

  List<Data>? listUser; // List untuk menyimpan data pengguna
  var state = UserState.initial; // State awal untuk pengguna
  var messageError = ''; // Variabel untuk menyimpan pesan error

  int idDataSelected = 0; // ID data yang dipilih

  // Fungsi untuk mendapatkan data pengguna dari server
  Future getUsers() async {
    try {
      var response = await Dio()
          .get('http://10.0.2.2:3000/users/'); // Mengirim request GET ke server
      var result = UserModel.fromJson(
          response.data); // Mengubah respon JSON menjadi objek UserModel
      if (result.data!.isEmpty) {
        // Cek apakah data kosong
        state = UserState.nodata; // Set state menjadi nodata jika data kosong
      } else {
        state = UserState
            .success; // Set state menjadi success jika data tidak kosong
        listUser = result.data; // Set listUser dengan data yang didapat
      }
    } catch (e) {
      state = UserState.error; // Set state menjadi error jika terjadi kesalahan
      messageError = e.toString(); // Set messageError dengan pesan kesalahan
    }
    notifyListeners(); // Beritahu pendengar bahwa state telah berubah
  }

  // Fungsi untuk memeriksa ketersediaan username
  Future<bool> checkUsernameAvailability(String username) async {
    try {
      var response = await Dio().post(
        'http://10.0.2.2:3000/api/users/check', // Mengirim request POST ke server untuk memeriksa ketersediaan username
        data: {'username': username},
      );
      return !(response.data['exists'] ??
          false); // Kembalikan true jika username tidak tersedia
    } catch (e) {
      // Tangani eksepsi yang terjadi jika gagal memeriksa ketersediaan username
      print('Error checking username availability: $e');
      return false; // Kembalikan false secara default
    }
  }

  // Fungsi untuk menambahkan pengguna baru ke server
  Future insertUser(BuildContext context) async {
    if (passwordController.text.length < 8) {
      // Validasi password, jika kurang dari 8 karakter maka tampilkan pesan error
      showAlertError(context, 'Password harus memiliki minimal 8 karakter!');
      return;
    }

    // Periksa ketersediaan username sebelum menyimpan data
    bool usernameAvailable =
        await checkUsernameAvailability(usernameController.text);
    if (usernameAvailable) {
      // Jika username tidak tersedia, tampilkan pesan error
      showAlertError(
          context, 'Username sudah digunakan, silakan gunakan username lain.');
      return;
    }

    try {
      var requestModel = {
        "username":
            usernameController.text, // Mengambil nilai dari usernameController
        "password":
            passwordController.text, // Mengambil nilai dari passwordController
        "image": null // Set image ke null karena tidak ada gambar yang dipilih
      };
      await Dio().post(
        'http://10.0.2.2:3000/users/add', // Mengirim request POST ke server untuk menambahkan pengguna baru
        data: requestModel,
      );

      Navigator.pop(context); // Kembali ke halaman sebelumnya
      getUsers(); // Panggil getUsers untuk memperbarui daftar pengguna
    } catch (e) {
      // Tangani eksepsi yang terjadi
      print('Error: $e');
      // Set pesan error ke messageError di provider
      messageError = 'Terjadi kesalahan saat menyimpan data';
    }
    notifyListeners(); // Beritahu pendengar bahwa state telah berubah
  }

  // Fungsi untuk mendapatkan detail pengguna berdasarkan ID
  Future detailUser(int id) async {
    try {
      messageError = ''; // Bersihkan messageError
      var response = await Dio().get(
          'http://10.0.2.2:3000/users/$id'); // Mengirim request GET ke server untuk mendapatkan detail pengguna
      var result = UserResponseModel.fromJson(response
          .data); // Mengubah respon JSON menjadi objek UserResponseModel
      idDataSelected = id; // Set idDataSelected dengan ID yang dipilih
      usernameController.text = result.data!.username ??
          '-'; // Set usernameController dengan username pengguna
      passwordController.text = result.data!.password ??
          '-'; // Set passwordController dengan password pengguna
      imageController.text = result.data!.image ??
          '-'; // Set imageController dengan URL gambar pengguna
    } catch (e) {
      state = UserState.error; // Set state menjadi error jika terjadi kesalahan
      messageError = e.toString(); // Set messageError dengan pesan kesalahan
    }
    notifyListeners(); // Beritahu pendengar bahwa state telah berubah
  }

  // Fungsi untuk memperbarui pengguna berdasarkan ID
  Future updateUser(BuildContext context) async {
    if (passwordController.text.length < 8) {
      // Validasi password, jika kurang dari 8 karakter maka tampilkan pesan error
      showAlertError(context, 'Password harus memiliki minimal 8 karakter!');
      return;
    }
    try {
      FormData formData = FormData.fromMap({
        "username":
            usernameController.text, // Mengambil nilai dari usernameController
        "password":
            passwordController.text, // Mengambil nilai dari passwordController
        "image": selectedImage !=
                null // Jika gambar dipilih, maka gunakan file gambar
            ? await MultipartFile.fromFile(selectedImage!.path,
                filename: selectedImage!.path.split('/').last)
            : imageController.text
                    .isNotEmpty // Jika URL gambar tidak kosong, maka gunakan URL gambar
                ? imageController.text
                : null, // Jika tidak ada gambar dipilih atau URL gambar kosong, maka nilainya null
      });

      await Dio().put(
        'http://10.0.2.2:3000/users/update/$idDataSelected', // Mengirim request PUT ke server untuk memperbarui pengguna
        data: formData,
      );

      if (Navigator.canPop(context)) {
        Navigator.pop(
            context); // Kembali ke halaman sebelumnya jika memungkinkan
      }
      getUsers(); // Panggil getUsers untuk memperbarui daftar pengguna
    } catch (e) {
      messageError = e.toString(); // Set messageError dengan pesan kesalahan
    }
    notifyListeners(); // Beritahu pendengar bahwa state telah berubah
  }

  // Fungsi untuk menghapus pengguna berdasarkan ID
  Future deleteUser(BuildContext context, int id) async {
    try {
      await Dio().delete(
          'http://10.0.2.2:3000/users/delete/$id'); // Mengirim request DELETE ke server untuk menghapus pengguna
      getUsers(); // Panggil getUsers untuk memperbarui daftar pengguna
    } catch (e) {
      messageError = e.toString(); // Set messageError dengan pesan kesalahan
    }
    notifyListeners(); // Beritahu pendengar bahwa state telah berubah
  }

  // Fungsi untuk memilih gambar dari galeri
  Future pickImage() async {
    final picker = ImagePicker(); // Membuat instance ImagePicker
    final pickedFile = await picker.pickImage(
        source: ImageSource.gallery); // Memilih gambar dari galeri
    if (pickedFile != null) {
      selectedImage =
          File(pickedFile.path); // Set selectedImage dengan file yang dipilih
      imageController.text =
          pickedFile.path; // Set imageController dengan path file yang dipilih
      notifyListeners(); // Beritahu pendengar bahwa state telah berubah
    }
  }

  void resetControllers() {
    usernameController.clear(); // Bersihkan usernameController
    passwordController.clear(); // Bersihkan passwordController
    imageController.clear(); // Bersihkan imageController
  }
}

// Enum untuk merepresentasikan berbagai state untuk proses pengguna
enum UserState {
  initial,
  loading,
  success,
  error,
  nodata
} // State untuk pengguna

// Fungsi untuk menampilkan dialog error
void showAlertError(BuildContext context, String message) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Error'), // Judul dialog
        content: Text(message), // Isi pesan error
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Menutup dialog saat tombol OK ditekan
            },
            child: const Text('OK'), // Teks tombol
          ),
        ],
      );
    },
  );
}
