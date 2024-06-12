// Mendefinisikan model CategoryModel
class CategoryModel {
  List<Data>? data; // List yang berisi objek Data, bisa bernilai null

  // Konstruktor CategoryModel dengan parameter opsional
  CategoryModel({this.data});

  // Konstruktor CategoryModel.fromJson untuk mengonversi JSON menjadi objek CategoryModel
  CategoryModel.fromJson(List<dynamic> jsonList) {
    data = <Data>[]; // Inisialisasi list data sebagai list kosong
    // Loop melalui setiap elemen dalam jsonList
    for (var v in jsonList) {
      // Membuat objek Data dari setiap elemen dalam jsonList dan menambahkannya ke dalam list data
      data!.add(Data.fromJson(v));
    }
  }

  // Metode toJson untuk mengonversi objek CategoryModel menjadi JSON
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> dataMap =
        <String, dynamic>{}; // Membuat map kosong
    if (data != null) {
      // Jika list data tidak kosong
      dataMap['data'] = data!
          .map((v) => v.toJson())
          .toList(); // Menambahkan list data ke dalam map
    }
    return dataMap; // Mengembalikan map yang berisi data JSON
  }
}

// Mendefinisikan model Data
class Data {
  int? id; // ID kategori
  String? name; // Nama kategori
  String? createdAt; // Waktu pembuatan kategori
  String? updatedAt; // Waktu terakhir pembaruan kategori

  // Konstruktor Data dengan parameter opsional
  Data({this.id, this.name, this.createdAt, this.updatedAt});

  // Konstruktor Data.fromJson untuk mengonversi JSON menjadi objek Data
  Data.fromJson(Map<String, dynamic> json) {
    // Mengambil nilai dari setiap kunci dalam JSON dan menyimpannya dalam properti yang sesuai
    id = json['id']; // ID kategori
    name = json['name']; // Nama kategori
    createdAt = json['createdAt']; // Waktu pembuatan kategori
    updatedAt = json['updatedAt']; // Waktu terakhir pembaruan kategori
  }

  // Metode toJson untuk mengonversi objek Data menjadi JSON
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
