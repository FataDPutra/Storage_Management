// Mendefinisikan model ProductResponseModel
class ProductResponseModel {
  DataResponse? data; // Objek DataResponse, bisa bernilai null

  // Konstruktor ProductResponseModel dengan parameter opsional
  ProductResponseModel({this.data});

  // Konstruktor ProductResponseModel.fromJson untuk mengonversi JSON menjadi objek ProductResponseModel
  ProductResponseModel.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null
        ? DataResponse.fromJson(json['data'])
        : null; // Mengambil objek DataResponse dari JSON jika tidak null
  }

  // Metode toJson untuk mengonversi objek ProductResponseModel menjadi JSON
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{}; // Membuat map kosong
    if (this.data != null) {
      data['data'] = this
          .data!
          .toJson(); // Menambahkan objek DataResponse ke dalam map jika tidak null
    }
    return data; // Mengembalikan map yang berisi data JSON
  }
}

// Mendefinisikan model DataResponse
class DataResponse {
  int? id; // ID produk
  String? name; // Nama produk
  int? quantity; // Jumlah produk
  int? categoryId; // ID kategori produk
  String? urlGambarProduct; // URL gambar produk
  String? createdBy; // Dibuat oleh
  String? updatedBy; // Diperbarui oleh
  String? createdAt; // Waktu pembuatan produk
  String? updatedAt; // Waktu terakhir pembaruan produk
  Category? category; // Objek Category, bisa bernilai null

  // Konstruktor DataResponse dengan parameter opsional
  DataResponse({
    this.id,
    this.name,
    this.quantity,
    this.categoryId,
    this.urlGambarProduct,
    this.createdBy,
    this.updatedBy,
    this.createdAt,
    this.updatedAt,
    this.category,
  });

  // Konstruktor DataResponse.fromJson untuk mengonversi JSON menjadi objek DataResponse
  DataResponse.fromJson(Map<String, dynamic> json) {
    // Mengambil nilai dari setiap kunci dalam JSON dan menyimpannya dalam properti yang sesuai
    id = json['id']; // ID produk
    name = json['name']; // Nama produk
    quantity = json['quantity']; // Jumlah produk
    categoryId = json['CategoryId']; // ID kategori produk
    urlGambarProduct = json['url_gambar_product']; // URL gambar produk
    createdBy = json['created_by']; // Dibuat oleh
    updatedBy = json['updated_by']; // Diperbarui oleh
    createdAt = json['createdAt']; // Waktu pembuatan produk
    updatedAt = json['updatedAt']; // Waktu terakhir pembaruan produk
    category = json['Category'] != null
        ? Category.fromJson(json['Category'])
        : null; // Objek Category, bisa bernilai null
  }

  // Metode toJson untuk mengonversi objek DataResponse menjadi JSON
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{}; // Membuat map kosong
    data['id'] = id; // Menambahkan ID produk ke dalam map
    data['name'] = name; // Menambahkan nama produk ke dalam map
    data['quantity'] = quantity; // Menambahkan jumlah produk ke dalam map
    data['CategoryId'] =
        categoryId; // Menambahkan ID kategori produk ke dalam map
    data['url_gambar_product'] =
        urlGambarProduct; // Menambahkan URL gambar produk ke dalam map
    data['created_by'] =
        createdBy; // Menambahkan informasi pembuat ke dalam map
    data['updated_by'] =
        updatedBy; // Menambahkan informasi yang memperbarui ke dalam map
    data['createdAt'] =
        createdAt; // Menambahkan waktu pembuatan produk ke dalam map
    data['updatedAt'] =
        updatedAt; // Menambahkan waktu terakhir pembaruan produk ke dalam map
    if (category != null) {
      data['Category'] = category!
          .toJson(); // Menambahkan objek Category ke dalam map jika tidak null
    }
    return data; // Mengembalikan map yang berisi data JSON
  }
}

// Mendefinisikan model Category
class Category {
  int? id; // ID kategori
  String? name; // Nama kategori
  String? createdAt; // Waktu pembuatan kategori
  String? updatedAt; // Waktu terakhir pembaruan kategori

  // Konstruktor Category dengan parameter opsional
  Category({this.id, this.name, this.createdAt, this.updatedAt});

  // Konstruktor Category.fromJson untuk mengonversi JSON menjadi objek Category
  Category.fromJson(Map<String, dynamic> json) {
    // Mengambil nilai dari setiap kunci dalam JSON dan menyimpannya dalam properti yang sesuai
    id = json['id']; // ID kategori
    name = json['name']; // Nama kategori
    createdAt = json['createdAt']; // Waktu pembuatan kategori
    updatedAt = json['updatedAt']; // Waktu terakhir pembaruan kategori
  }

  // Metode toJson untuk mengonversi objek Category menjadi JSON
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
