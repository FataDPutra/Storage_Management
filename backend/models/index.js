"use strict";

const fs = require("fs"); // Mengimpor modul fs untuk operasi file sistem
const path = require("path"); // Mengimpor modul path untuk bekerja dengan path file dan direktori
const Sequelize = require("sequelize"); // Mengimpor modul Sequelize untuk ORM
const process = require("process"); // Mengimpor modul process untuk mengakses environment variables
const basename = path.basename(__filename); // Mendapatkan nama file dari path file saat ini
const env = process.env.NODE_ENV || "development"; // Mendapatkan environment saat ini atau menggunakan "development" jika tidak ada
const config = require(__dirname + "/../config/config.json")[env]; // Mengimpor konfigurasi database berdasarkan environment
const db = {}; // Objek yang akan menyimpan semua model Sequelize

let sequelize; // Variabel untuk menyimpan instance Sequelize

// Membuat koneksi Sequelize
if (config.use_env_variable) {
  // Jika menggunakan variabel lingkungan untuk koneksi database
  sequelize = new Sequelize(process.env[config.use_env_variable], config);
} else {
  // Jika menggunakan konfigurasi manual untuk koneksi database
  sequelize = new Sequelize(
    config.database,
    config.username,
    config.password,
    config
  );
}

// Membaca direktori model
fs.readdirSync(__dirname)
  .filter((file) => {
    // Memfilter file-file dalam direktori
    return (
      file.indexOf(".") !== 0 && // Mengabaikan file yang dimulai dengan titik (biasanya file tersembunyi)
      file !== basename && // Mengabaikan file ini sendiri
      file.slice(-3) === ".js" && // Memilih file dengan ekstensi .js
      file.indexOf(".test.js") === -1 // Mengabaikan file yang diakhiri dengan .test.js (file tes)
    );
  })
  .forEach((file) => {
    // Untuk setiap file yang dipilih
    const model = require(path.join(__dirname, file))(
      // Mengimpor model
      sequelize, // Meneruskan instance Sequelize
      Sequelize.DataTypes // Meneruskan tipe data Sequelize
    );
    db[model.name] = model; // Menyimpan model dalam objek db dengan nama model sebagai kuncinya
  });

// Menghubungkan model-model yang memiliki metode associate
Object.keys(db).forEach((modelName) => {
  if (db[modelName].associate) {
    db[modelName].associate(db);
  }
});

db.sequelize = sequelize; // Menambahkan instance Sequelize ke objek db
db.Sequelize = Sequelize; // Menambahkan kelas Sequelize ke objek db

module.exports = db; // Mengekspor objek db untuk digunakan dalam aplikasi
