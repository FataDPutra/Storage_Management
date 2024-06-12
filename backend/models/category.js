"use strict"; // Mengaktifkan mode ketat JavaScript untuk meningkatkan keamanan dan kinerja kode
const { Model } = require("sequelize"); // Mengimport kelas Model dari paket Sequelize
module.exports = (sequelize, DataTypes) => {
  // Mengekspor fungsi yang mendefinisikan model Category
  class Category extends Model {
    // Mendefinisikan kelas Category yang memperluas Model Sequelize
    /**
     * Metode bantu untuk mendefinisikan asosiasi.
     * Metode ini bukan bagian dari siklus hidup Sequelize.
     * File `models/index` akan memanggil metode ini secara otomatis.
     */
    static associate(models) {
      // Mendefinisikan asosiasi antara model Category dan model lain
      Category.hasMany(models.Product); // Mendefinisikan bahwa satu Category memiliki banyak Product
    }
  }
  Category.init(
    // Menginisialisasi model Category
    {
      name: DataTypes.STRING, // Mendefinisikan atribut name dengan tipe data STRING
    },
    {
      sequelize, // Menyediakan instance sequelize
      modelName: "Category", // Menentukan nama model
    }
  );
  return Category; // Mengembalikan model Category yang telah didefinisikan
};
