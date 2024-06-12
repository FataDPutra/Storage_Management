import 'dart:io'; // Mengimpor pustaka dart:io untuk mengelola file
import 'package:dio/dio.dart'; // Mengimpor pustaka dio untuk HTTP requests
import 'package:flutter/material.dart'; // Mengimpor pustaka Flutter Material
import 'package:image_picker/image_picker.dart'; // Mengimpor pustaka image_picker untuk memilih gambar dari galeri
import 'package:storage_management/models/product_model.dart'; // Mengimpor model ProductModel
import 'package:storage_management/models/product_response_model.dart'; // Mengimpor model ProductResponseModel

// Mendefinisikan kelas ProductProvider yang memperpanjang ChangeNotifier untuk manajemen state
class ProductProvider extends ChangeNotifier {
  final formKey = GlobalKey<FormState>(); // Key untuk form
  TextEditingController nameController =
      TextEditingController(); // Controller untuk input nama produk
  TextEditingController quantityController =
      TextEditingController(); // Controller untuk input jumlah produk
  TextEditingController categoryIdController =
      TextEditingController(); // Controller untuk input ID kategori
  TextEditingController imageController =
      TextEditingController(); // Controller untuk input URL gambar produk
  TextEditingController createdByController =
      TextEditingController(); // Controller untuk input siapa yang membuat produk
  TextEditingController updatedByController =
      TextEditingController(); // Controller untuk input siapa yang memperbarui produk
  TextEditingController createdAtController =
      TextEditingController(); // Controller untuk input kapan produk dibuat
  TextEditingController updatedAtController =
      TextEditingController(); // Controller untuk input kapan produk diperbarui
  File? selectedImage; // Variabel untuk menyimpan gambar yang dipilih

  List<Data>? listProduct; // List untuk menyimpan data produk
  var state = ProductState.initial; // State awal untuk produk
  var messageError = ''; // Variabel untuk menyimpan pesan error

  int idDataSelected = 0; // ID data yang dipilih

  // Fungsi untuk mendapatkan data produk dari server
  Future getProducts() async {
    state =
        ProductState.loading; // Set state menjadi loading saat mengambil data
    notifyListeners(); // Beritahu pendengar bahwa state telah berubah
    try {
      var response = await Dio().get(
          'http://10.0.2.2:3000/products/'); // Mengirim request GET ke server
      var result = ProductModel.fromJson(
          response.data); // Mengubah respon JSON menjadi objek ProductModel
      if (result.data!.isEmpty) {
        // Cek apakah data kosong
        state =
            ProductState.nodata; // Set state menjadi nodata jika data kosong
      } else {
        state = ProductState
            .success; // Set state menjadi success jika data tidak kosong
        listProduct = result.data; // Set listProduct dengan data yang didapat
      }
    } catch (e) {
      state =
          ProductState.error; // Set state menjadi error jika terjadi kesalahan
      messageError =
          'Failed to fetch products: $e'; // Set messageError dengan pesan kesalahan
    }
    notifyListeners(); // Beritahu pendengar bahwa state telah berubah
  }

  // Fungsi untuk menambahkan produk baru ke server
  Future insertProduct(BuildContext context) async {
    if (!formKey.currentState!.validate())
      return; // Validasi form, jika tidak valid maka return

    state =
        ProductState.loading; // Set state menjadi loading saat menambahkan data
    notifyListeners(); // Beritahu pendengar bahwa state telah berubah
    try {
      FormData formData = FormData.fromMap({
        "name": nameController.text, // Mengambil nilai dari nameController
        "quantity": int.tryParse(quantityController
            .text), // Mengambil nilai dari quantityController dan mengubahnya menjadi int
        "CategoryId": int.tryParse(categoryIdController
            .text), // Mengambil nilai dari categoryIdController dan mengubahnya menjadi int
        "url_gambar_product": selectedImage !=
                null // Jika gambar dipilih, maka gunakan file gambar
            ? await MultipartFile.fromFile(selectedImage!.path,
                filename: selectedImage!.path.split('/').last)
            : imageController.text
                    .isNotEmpty // Jika URL gambar tidak kosong, maka gunakan URL gambar
                ? imageController.text
                : null, // Jika tidak ada gambar dipilih atau URL gambar kosong, maka nilainya null
        "created_by": createdByController
            .text, // Mengambil nilai dari createdByController
        "updated_by": updatedByController
            .text, // Mengambil nilai dari updatedByController
      });
      await Dio().post('http://10.0.2.2:3000/products/add',
          data:
              formData); // Mengirim request POST ke server untuk menambahkan produk baru

      state = ProductState
          .success; // Set state menjadi success jika berhasil menambahkan produk
      Navigator.pop(context); // Kembali ke halaman sebelumnya
      resetControllers(); // Reset semua controller
      getProducts(); // Panggil getProducts untuk memperbarui daftar produk
    } catch (e) {
      state =
          ProductState.error; // Set state menjadi error jika terjadi kesalahan
      messageError =
          'Failed to add product: $e'; // Set messageError dengan pesan kesalahan
    }
    notifyListeners(); // Beritahu pendengar bahwa state telah berubah
  }

  // Fungsi untuk mendapatkan detail produk berdasarkan ID
  Future detailProduct(int id) async {
    state = ProductState
        .loading; // Set state menjadi loading saat mengambil detail produk
    notifyListeners(); // Beritahu pendengar bahwa state telah berubah
    try {
      messageError = ''; // Bersihkan messageError
      var response = await Dio().get(
          'http://10.0.2.2:3000/products/$id'); // Mengirim request GET ke server untuk mendapatkan detail produk
      print(
          'Response data: ${response.data}'); // Menampilkan data respon di console
      var result = ProductResponseModel.fromJson({
        'data': response.data
      }); // Mengubah respon JSON menjadi objek ProductResponseModel
      if (result.data != null) {
        // Jika data produk ditemukan
        idDataSelected = id; // Set idDataSelected dengan ID yang dipilih
        nameController.text =
            result.data?.name ?? '-'; // Set nameController dengan nama produk
        quantityController.text = result.data?.quantity?.toString() ??
            '-'; // Set quantityController dengan jumlah produk
        categoryIdController.text = result.data?.categoryId?.toString() ??
            '-'; // Set categoryIdController dengan ID kategori
        imageController.text = result.data?.urlGambarProduct ??
            '-'; // Set imageController dengan URL gambar produk
        createdByController.text = result.data?.createdBy ??
            '-'; // Set createdByController dengan siapa yang membuat produk
        updatedByController.text = result.data?.updatedBy ??
            '-'; // Set updatedByController dengan siapa yang memperbarui produk
        createdAtController.text = result.data?.createdAt ??
            '-'; // Set createdAtController dengan kapan produk dibuat
        updatedAtController.text = result.data?.updatedAt ??
            '-'; // Set updatedAtController dengan kapan produk diperbarui
        state = ProductState
            .success; // Set state menjadi success jika berhasil mendapatkan detail produk
      } else {
        state = ProductState
            .error; // Set state menjadi error jika data produk tidak ditemukan
        messageError =
            'Product not found'; // Set messageError dengan pesan produk tidak ditemukan
      }
    } catch (e) {
      state =
          ProductState.error; // Set state menjadi error jika terjadi kesalahan
      messageError =
          'Failed to fetch product details: $e'; // Set messageError dengan pesan kesalahan
    }
    notifyListeners(); // Beritahu pendengar bahwa state telah berubah
  }

  // Fungsi untuk memperbarui produk berdasarkan ID
  Future updateProduct(BuildContext context) async {
    state =
        ProductState.loading; // Set state menjadi loading saat memperbarui data
    notifyListeners(); // Beritahu pendengar bahwa state telah berubah
    try {
      var requestModel = {
        "id": idDataSelected, // Mengambil nilai idDataSelected
        "name": nameController.text, // Mengambil nilai dari nameController
        "quantity": int.tryParse(quantityController
            .text), // Mengambil nilai dari quantityController dan mengubahnya menjadi int
        "CategoryId": int.tryParse(categoryIdController
            .text), // Mengambil nilai dari categoryIdController dan mengubahnya menjadi int
        "url_gambar_product":
            imageController.text, // Mengambil nilai dari imageController
        "created_by": createdByController
            .text, // Mengambil nilai dari createdByController
        "updated_by": updatedByController
            .text, // Mengambil nilai dari updatedByController
      };
      await Dio().put('http://10.0.2.2:3000/products/update/$idDataSelected',
          data:
              requestModel); // Mengirim request PUT ke server untuk memperbarui produk

      state = ProductState
          .success; // Set state menjadi success jika berhasil memperbarui produk
      Navigator.pop(context); // Kembali ke halaman sebelumnya
      resetControllers(); // Reset semua controller
      getProducts(); // Panggil getProducts untuk memperbarui daftar produk
    } catch (e) {
      state =
          ProductState.error; // Set state menjadi error jika terjadi kesalahan
      messageError =
          'Failed to update product: $e'; // Set messageError dengan pesan kesalahan
    }
    notifyListeners(); // Beritahu pendengar bahwa state telah berubah
  }

  // Fungsi untuk menghapus produk berdasarkan ID
  Future deleteProduct(BuildContext context, int id) async {
    try {
      await Dio().delete(
          'http://10.0.2.2:3000/products/delete/$id'); // Mengirim request DELETE ke server untuk menghapus produk
      getProducts(); // Panggil getProducts untuk memperbarui daftar produk
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

  // Fungsi untuk mereset semua controller
  void resetControllers() {
    nameController.clear(); // Bersihkan nameController
    quantityController.clear(); // Bersihkan quantityController
    categoryIdController.clear(); // Bersihkan categoryIdController
    imageController.clear(); // Bersihkan imageController
    createdByController.clear(); // Bersihkan createdByController
    updatedByController.clear(); // Bersihkan updatedByController
    createdAtController.clear(); // Bersihkan createdAtController
    updatedAtController.clear(); // Bersihkan updatedAtController
  }
}

// Enum untuk merepresentasikan berbagai state untuk proses produk
enum ProductState {
  initial,
  loading,
  success,
  error,
  nodata
} // State untuk produk
