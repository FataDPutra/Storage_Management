const route = require("express").Router(); // Mengimpor modul Router dari Express

// Endpoint sederhana untuk menyambut pengguna
route.get("/", (req, res) => {
  res.send("Hello World!");
});

// Mengimpor rute-rute dari berbagai modul
const userRoutes = require("./user"); // Mengimpor rute pengguna
const categoryRoutes = require("./category"); // Mengimpor rute kategori
const productRoutes = require("./product"); // Mengimpor rute produk

// Menggunakan rute-rute yang telah diimpor
route.use("/users", userRoutes); // Menggunakan rute pengguna di bawah endpoint '/users'
route.use("/products", productRoutes); // Menggunakan rute produk di bawah endpoint '/products'
route.use("/categories", categoryRoutes); // Menggunakan rute kategori di bawah endpoint '/categories'

module.exports = route; // Mengekspor router
