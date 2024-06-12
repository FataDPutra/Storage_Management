"use strict";

const { Model } = require("sequelize"); // Mengimpor kelas Model dari Sequelize

module.exports = (sequelize, DataTypes) => {
  class User extends Model {
    /**
     * Helper method for defining associations.
     * This method is not a part of Sequelize lifecycle.
     * The `models/index` file will call this method automatically.
     */
    static associate(models) {
      // Mendefinisikan asosiasi antar model di sini (jika ada)
    }
  }

  // Inisialisasi model User dengan atribut-atributnya
  User.init(
    {
      username: DataTypes.STRING, // Nama pengguna, tipe data string
      password: DataTypes.STRING, // Kata sandi pengguna, tipe data string
      image: DataTypes.STRING, // Nama file gambar pengguna, tipe data string
    },
    {
      sequelize, // Instance Sequelize yang digunakan
      modelName: "User", // Nama model
    }
  );

  return User; // Mengembalikan model User yang telah didefinisikan
};
