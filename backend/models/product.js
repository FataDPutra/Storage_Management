"use strict";

const { Model } = require("sequelize"); // Mengimpor kelas Model dari Sequelize

module.exports = (sequelize, DataTypes) => {
  class Product extends Model {
    /**
     * Helper method for defining associations.
     * This method is not a part of Sequelize lifecycle.
     * The `models/index` file will call this method automatically.
     */
    static associate(models) {
      // Mendefinisikan asosiasi antar model di sini
      Product.belongsTo(models.Category, { foreignKey: "CategoryId" }); // Mendefinisikan bahwa Product memiliki relasi many-to-one dengan Category
    }
  }

  // Inisialisasi model Product dengan atribut-atributnya
  Product.init(
    {
      name: DataTypes.STRING, // Nama produk, tipe data string
      quantity: DataTypes.INTEGER, // Jumlah produk, tipe data integer
      CategoryId: DataTypes.INTEGER, // Kunci asing untuk kategori produk, tipe data integer
      url_gambar_product: DataTypes.STRING, // URL gambar produk, tipe data string
      created_by: DataTypes.STRING, // Nama pengguna yang membuat produk, tipe data string
      updated_by: DataTypes.STRING, // Nama pengguna yang memperbarui produk, tipe data string
    },
    {
      sequelize, // Instance Sequelize yang digunakan
      modelName: "Product", // Nama model
    }
  );

  return Product; // Mengembalikan model Product yang telah didefinisikan
};
