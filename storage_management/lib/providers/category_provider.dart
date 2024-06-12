import 'package:dio/dio.dart'; // Mengimpor paket Dio untuk HTTP requests
import 'package:flutter/material.dart'; // Mengimpor paket Flutter Material
import 'package:storage_management/models/category_model.dart'; // Mengimpor model CategoryModel
import 'package:storage_management/models/category_response_model.dart'; // Mengimpor model CategoryResponseModel

// Mendefinisikan kelas CategoryProvider yang memperpanjang ChangeNotifier untuk manajemen state
class CategoryProvider extends ChangeNotifier {
  final formKey = GlobalKey<FormState>(); // Key untuk form
  TextEditingController nameController =
      TextEditingController(); // Controller untuk input nama kategori

  List<Data>? listCategory; // List untuk menyimpan data kategori
  var state = CategoryState.initial; // State awal untuk kategori
  var messageError = ''; // Variabel untuk menyimpan pesan error

  int idDataSelected = 0; // ID data yang dipilih

  // Fungsi untuk mendapatkan data kategori dari server
  Future getCategories() async {
    try {
      var response = await Dio().get(
          'http://10.0.2.2:3000/categories/'); // Mengirim request GET ke server
      var result = CategoryModel.fromJson(
          response.data); // Mengubah respon JSON menjadi objek CategoryModel
      if (result.data!.isEmpty) {
        // Cek apakah data kosong
        state =
            CategoryState.nodata; // Set state menjadi nodata jika data kosong
      } else {
        state = CategoryState
            .success; // Set state menjadi success jika data tidak kosong
        listCategory = result.data; // Set listCategory dengan data yang didapat
      }
    } catch (e) {
      state =
          CategoryState.error; // Set state menjadi error jika terjadi kesalahan
      messageError = e.toString(); // Set messageError dengan pesan kesalahan
    }
    notifyListeners(); // Beritahu pendengar bahwa state telah berubah
  }

  // Fungsi untuk menambahkan kategori baru ke server
  Future insertCategory(
    BuildContext context,
  ) async {
    try {
      var requestModel = {
        "name": nameController.text, // Mengambil nilai dari nameController
      };
      await Dio().post(
        'http://10.0.2.2:3000/categories/add', // Mengirim request POST ke server untuk menambahkan kategori baru
        data: requestModel,
      );
      nameController.clear(); // Bersihkan nameController
      Navigator.pop(context); // Kembali ke halaman sebelumnya
      getCategories(); // Panggil getCategories untuk memperbarui daftar kategori
    } catch (e) {
      messageError = e.toString(); // Set messageError dengan pesan kesalahan
    }
    notifyListeners(); // Beritahu pendengar bahwa state telah berubah
  }

  // Fungsi untuk mendapatkan detail kategori berdasarkan ID
  Future detailCategory(int id) async {
    try {
      messageError = ''; // Bersihkan messageError
      var response = await Dio().get(
          'http://10.0.2.2:3000/categories/$id'); // Mengirim request GET ke server untuk mendapatkan detail kategori
      var result = CategoryResponseModel.fromJson(response
          .data); // Mengubah respon JSON menjadi objek CategoryResponseModel
      idDataSelected = id; // Set idDataSelected dengan ID yang dipilih
      nameController.text =
          result.data!.name ?? '-'; // Set nameController dengan nama kategori
    } catch (e) {
      state =
          CategoryState.error; // Set state menjadi error jika terjadi kesalahan
      messageError = e.toString(); // Set messageError dengan pesan kesalahan
    }
    notifyListeners(); // Beritahu pendengar bahwa state telah berubah
  }

  // Fungsi untuk memperbarui kategori berdasarkan ID
  Future updateCategory(
    BuildContext context,
  ) async {
    try {
      var requestModel = {
        "id": idDataSelected, // Mengambil nilai idDataSelected
        "name": nameController.text, // Mengambil nilai dari nameController
      };
      await Dio().put(
          'http://10.0.2.2:3000/categories/update/$idDataSelected', // Mengirim request PUT ke server untuk memperbarui kategori
          data: requestModel);
      Navigator.pop(context); // Kembali ke halaman sebelumnya
      getCategories(); // Panggil getCategories untuk memperbarui daftar kategori
    } catch (e) {
      messageError = e.toString(); // Set messageError dengan pesan kesalahan
    }
    notifyListeners(); // Beritahu pendengar bahwa state telah berubah
  }

  // Fungsi untuk menghapus kategori berdasarkan ID
  Future deleteCategory(BuildContext context, int id) async {
    try {
      await Dio().delete(
          'http://10.0.2.2:3000/categories/delete/$id'); // Mengirim request DELETE ke server untuk menghapus kategori
      getCategories(); // Panggil getCategories untuk memperbarui daftar kategori
    } catch (e) {
      messageError = e.toString(); // Set messageError dengan pesan kesalahan
    }
    notifyListeners(); // Beritahu pendengar bahwa state telah berubah
  }
}

// Enum untuk merepresentasikan berbagai state untuk proses kategori
enum CategoryState {
  initial,
  loading,
  success,
  error,
  nodata
} // State untuk kategori
