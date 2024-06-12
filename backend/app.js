const dotenv = require("dotenv"); // Mengimpor dotenv untuk konfigurasi lingkungan
const express = require("express"); // Mengimpor express untuk membuat aplikasi web
const app = express(); // Membuat instance aplikasi Express
const port = process.env.PORT || 3000; // Menentukan port yang akan digunakan, dengan nilai default 3000 jika tidak tersedia di lingkungan
const cors = require("cors"); // Mengimpor cors untuk mengatasi masalah kebijakan lintasan lintasan lintas-situs
const routes = require("./routes"); // Mengimpor file routes

dotenv.config(); // Mengonfigurasi dotenv

// Middleware untuk mengizinkan aplikasi membaca JSON
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// Menggunakan file routes untuk menangani routing
app.use(routes);

// Menggunakan cors middleware
app.use(cors());

// Menyajikan file statis dari folder public
app.use(express.static("public"));

// Menyajikan file gambar produk dari folder public/assets/images/products
app.use(
  "/assets/images/products",
  express.static("public/assets/images/products")
);

// Menyajikan file gambar pengguna dari folder public/assets/images/users
app.use("/assets/images/users", express.static("public/assets/images/users"));

// Mendengarkan port yang ditentukan
app.listen(port, () => {
  console.log(`Example app listening on port ${port}`);
});
