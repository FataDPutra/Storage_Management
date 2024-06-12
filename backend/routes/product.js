const productRoutes = require("express").Router(); // Mengimpor modul Router dari Express
const ProductController = require("../controllers/ProductController"); // Mengimpor kontroler produk
const multer = require("multer"); // Mengimpor multer untuk menangani upload file

// Konfigurasi penyimpanan untuk multer
const storage = multer.diskStorage({
  destination: function (req, file, cb) {
    cb(null, "public/assets/images/products"); // Menentukan folder tujuan untuk menyimpan file
  },
  filename: function (req, file, cb) {
    cb(null, file.originalname); // Menentukan nama file yang disimpan sesuai dengan nama aslinya
  },
});

const upload = multer({ storage: storage }); // Menggunakan penyimpanan yang telah dikonfigurasi

// Definisi endpoint-endpoint untuk produk
productRoutes.get("/", ProductController.getProducts); // Endpoint untuk membaca semua produk
productRoutes.get("/:id", ProductController.getProduct); // Endpoint untuk membaca produk berdasarkan ID

productRoutes.get("/add", ProductController.addPage); // Endpoint untuk menampilkan halaman tambah produk

productRoutes.post(
  "/add",
  upload.single("url_gambar_product"),
  ProductController.add
); // Endpoint untuk menambahkan produk baru

productRoutes.delete("/delete/:id", ProductController.delete); // Endpoint untuk menghapus produk berdasarkan ID

productRoutes.get("/update/:id", ProductController.updatePage); // Endpoint untuk menampilkan halaman edit produk

productRoutes.put(
  "/update/:id",
  upload.single("url_gambar_product"),
  ProductController.update
); // Endpoint untuk mengupdate produk berdasarkan ID

module.exports = productRoutes; // Mengekspor router produk
