const categoryRoutes = require("express").Router(); // Mengimpor modul Router dari Express
const CategoryController = require("../controllers/CategoryController"); // Mengimpor CategoryController

// Menentukan rute-rute untuk kategori
categoryRoutes.get("/", CategoryController.getCategories); // Endpoint untuk mendapatkan semua kategori
categoryRoutes.get("/:id", CategoryController.getCategory); // Endpoint untuk mendapatkan satu kategori berdasarkan ID
categoryRoutes.post("/add", CategoryController.add); // Endpoint untuk menambahkan kategori baru
categoryRoutes.delete("/delete/:id", CategoryController.delete); // Endpoint untuk menghapus kategori berdasarkan ID
categoryRoutes.put("/update/:id", CategoryController.update); // Endpoint untuk memperbarui kategori berdasarkan ID

module.exports = categoryRoutes; // Mengekspor rute-rute kategori
