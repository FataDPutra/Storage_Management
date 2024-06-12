// Mendefinisikan model CategoryResponseModel
class CategoryResponseModel {
  DataResponse? data; // Objek DataResponse, bisa bernilai null

  // Konstruktor CategoryResponseModel dengan parameter opsional
  CategoryResponseModel({this.data});

  // Konstruktor CategoryResponseModel.fromJson untuk mengonversi JSON menjadi objek CategoryResponseModel
  CategoryResponseModel.fromJson(Map<String, dynamic> json) {
    data = DataResponse.fromJson(json); // Membuat objek DataResponse dari JSON
  }

  // Metode toJson untuk mengonversi objek CategoryResponseModel menjadi JSON
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> dataMap =
        <String, dynamic>{}; // Membuat map kosong
    if (data != null) {
      dataMap['data'] =
          data!.toJson(); // Menambahkan objek DataResponse ke dalam map
    }
    return dataMap; // Mengembalikan map yang berisi data JSON
  }
}

// Mendefinisikan model DataResponse
class DataResponse {
  int? id; // ID kategori
  String? name; // Nama kategori
  String? createdAt; // Waktu pembuatan kategori
  String? updatedAt; // Waktu terakhir pembaruan kategori

  // Konstruktor DataResponse dengan parameter opsional
  DataResponse({this.id, this.name, this.createdAt, this.updatedAt});

  // Konstruktor DataResponse.fromJson untuk mengonversi JSON menjadi objek DataResponse
  DataResponse.fromJson(Map<String, dynamic> json) {
    // Mengambil nilai dari setiap kunci dalam JSON dan menyimpannya dalam properti yang sesuai
    id = json['id']; // ID kategori
    name = json['name']; // Nama kategori
    createdAt = json['createdAt']; // Waktu pembuatan kategori
    updatedAt = json['updatedAt']; // Waktu terakhir pembaruan kategori
  }

  // Metode toJson untuk mengonversi objek DataResponse menjadi JSON
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{}; // Membuat map kosong
    data['id'] = id; // Menambahkan ID kategori ke dalam map
    data['name'] = name; // Menambahkan nama kategori ke dalam map
    data['createdAt'] =
        createdAt; // Menambahkan waktu pembuatan kategori ke dalam map
    data['updatedAt'] =
        updatedAt; // Menambahkan waktu terakhir pembaruan kategori ke dalam map
    return data; // Mengembalikan map yang berisi data JSON
  }
}
