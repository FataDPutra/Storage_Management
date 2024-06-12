const userRoutes = require("express").Router(); // Mengimpor modul Router dari Express
const UserController = require("../controllers/UserController"); // Mengimpor kontroler pengguna
const multer = require("multer"); // Mengimpor multer untuk menangani upload file

// Konfigurasi penyimpanan untuk multer
const storage = multer.diskStorage({
  destination: function (req, file, cb) {
    cb(null, "public/assets/images/users"); // Menentukan folder tujuan untuk menyimpan file
  },
  filename: function (req, file, cb) {
    cb(null, file.originalname); // Menentukan nama file yang disimpan sesuai dengan nama aslinya
  },
});

const upload = multer({ storage: storage }); // Menggunakan penyimpanan yang telah dikonfigurasi

// Definisi endpoint-endpoint untuk pengguna
userRoutes.get("/", UserController.getUsers); // Endpoint untuk membaca semua pengguna
userRoutes.get("/:id", UserController.getUser); // Endpoint untuk membaca pengguna berdasarkan ID
userRoutes.get("/add", UserController.registerPage); // Endpoint untuk menampilkan halaman tambah pengguna
userRoutes.post("/add", upload.single("image"), UserController.add); // Endpoint untuk menambahkan pengguna baru
userRoutes.post("/check", UserController.checkUsername); // Endpoint untuk memeriksa ketersediaan nama pengguna
userRoutes.post("/login", UserController.login); // Endpoint untuk proses login
userRoutes.delete("/delete/:id", UserController.delete); // Endpoint untuk menghapus pengguna berdasarkan ID
userRoutes.get("/update/:id", UserController.updatePage); // Endpoint untuk menampilkan halaman edit pengguna
userRoutes.put("/update/:id", upload.single("image"), UserController.update); // Endpoint untuk mengupdate pengguna berdasarkan ID

module.exports = userRoutes; // Mengekspor router pengguna
