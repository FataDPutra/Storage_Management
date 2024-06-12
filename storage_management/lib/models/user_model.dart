// Mendefinisikan model UserModel
class UserModel {
  List<Data>? data; // List objek Data, bisa bernilai null

  // Konstruktor UserModel dengan parameter opsional
  UserModel({this.data});

  // Konstruktor UserModel.fromJson untuk mengonversi JSON menjadi objek UserModel
  UserModel.fromJson(List<dynamic> jsonList) {
    data = <Data>[]; // Membuat list kosong untuk menyimpan objek Data
    for (var v in jsonList) {
      data!.add(
          Data.fromJson(v)); // Menambahkan objek Data dari JSON ke dalam list
    }
  }

  // Metode toJson untuk mengonversi objek UserModel menjadi JSON
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> dataMap =
        <String, dynamic>{}; // Membuat map kosong
    if (data != null) {
      dataMap['data'] = data!
          .map((v) => v.toJson())
          .toList(); // Menambahkan list objek Data ke dalam map jika tidak null
    }
    return dataMap; // Mengembalikan map yang berisi data JSON
  }
}

// Mendefinisikan model Data
class Data {
  int? id; // ID pengguna
  String? username; // Nama pengguna
  String? password; // Kata sandi pengguna
  String? image; // Gambar pengguna
  String? createdAt; // Waktu pembuatan pengguna
  String? updatedAt; // Waktu terakhir pembaruan pengguna

  // Konstruktor Data dengan parameter opsional
  Data({
    this.id,
    this.username,
    this.password,
    this.image,
    this.createdAt,
    this.updatedAt,
  });

  // Konstruktor Data.fromJson untuk mengonversi JSON menjadi objek Data
  Data.fromJson(Map<String, dynamic> json) {
    // Mengambil nilai dari setiap kunci dalam JSON dan menyimpannya dalam properti yang sesuai
    id = json['id']; // ID pengguna
    username = json['username']; // Nama pengguna
    password = json['password']; // Kata sandi pengguna
    image = json['image']; // Gambar pengguna
    createdAt = json['createdAt']; // Waktu pembuatan pengguna
    updatedAt = json['updatedAt']; // Waktu terakhir pembaruan pengguna
  }

  // Metode toJson untuk mengonversi objek Data menjadi JSON
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
