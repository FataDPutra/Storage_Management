// Mendefinisikan model UserResponseModel
class UserResponseModel {
  DataResponse? data; // Objek DataResponse, bisa bernilai null

  // Konstruktor UserResponseModel dengan parameter opsional
  UserResponseModel({this.data});

  // Konstruktor UserResponseModel.fromJson untuk mengonversi JSON menjadi objek UserResponseModel
  UserResponseModel.fromJson(Map<String, dynamic> json) {
    data = DataResponse.fromJson(
        json); // Menginisialisasi objek DataResponse dari JSON
  }

  // Metode toJson untuk mengonversi objek UserResponseModel menjadi JSON
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> dataMap =
        <String, dynamic>{}; // Membuat map kosong
    if (data != null) {
      dataMap['data'] = data!
          .toJson(); // Menambahkan objek DataResponse ke dalam map jika tidak null
    }
    return dataMap; // Mengembalikan map yang berisi data JSON
  }
}

// Mendefinisikan model DataResponse
class DataResponse {
  int? id; // ID pengguna
  String? username; // Nama pengguna
  String? password; // Kata sandi pengguna
  String? image; // Gambar pengguna
  String? createdAt; // Waktu pembuatan pengguna
  String? updatedAt; // Waktu terakhir pembaruan pengguna

  // Konstruktor DataResponse dengan parameter opsional
  DataResponse({
    this.id,
    this.username,
    this.password,
    this.image,
    this.createdAt,
    this.updatedAt,
  });

  // Konstruktor DataResponse.fromJson untuk mengonversi JSON menjadi objek DataResponse
  DataResponse.fromJson(Map<String, dynamic> json) {
    // Mengambil nilai dari setiap kunci dalam JSON dan menyimpannya dalam properti yang sesuai
    id = json['id']; // ID pengguna
    username = json['username']; // Nama pengguna
    password = json['password']; // Kata sandi pengguna
    image = json['image']; // Gambar pengguna
    createdAt = json['createdAt']; // Waktu pembuatan pengguna
    updatedAt = json['updatedAt']; // Waktu terakhir pembaruan pengguna
  }

  // Metode toJson untuk mengonversi objek DataResponse menjadi JSON
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{}; // Membuat map kosong
    data['id'] = id; // Menambahkan ID pengguna ke dalam map
    data['username'] = username; // Menambahkan nama pengguna ke dalam map
    data['password'] = password; // Menambahkan kata sandi pengguna ke dalam map
    data['image'] = image; // Menambahkan gambar pengguna ke dalam map
    data['createdAt'] =
        createdAt; // Menambahkan waktu pembuatan pengguna ke dalam map
    data['updatedAt'] =
        updatedAt; // Menambahkan waktu terakhir pembaruan pengguna ke dalam map
    return data; // Mengembalikan map yang berisi data JSON
  }
}
