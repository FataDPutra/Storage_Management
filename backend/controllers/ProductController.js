const { Product, User, Category } = require("../models"); // Mengimpor model Product, User, dan Category dari folder models
const fs = require("fs"); // Mengimpor modul fs untuk operasi file sistem
const path = require("path"); // Mengimpor modul path untuk bekerja dengan path file dan direktori
const { v4: uuidv4 } = require("uuid"); // Mengimpor fungsi uuidv4 untuk membuat UUID

class ProductController {
  // Mendefinisikan kelas ProductController
  static async getProducts(req, res) {
    // Metode statis untuk mendapatkan semua produk
    try {
      // Blok try untuk menangani eksekusi kode yang mungkin menghasilkan error
      let products = await Product.findAll({
        // Mengambil semua produk dari database
        include: [Category], // Menyertakan data kategori untuk setiap produk
        order: [["id", "asc"]], // Mengurutkan produk berdasarkan id secara ascending
      });

      res.json(products); // Mengirimkan respon dalam format JSON berisi data produk
    } catch (err) {
      // Blok catch untuk menangani error jika terjadi
      res.send(err); // Mengirimkan error sebagai respon
    }
  }

  static async getProduct(req, res) {
    // Metode statis untuk mendapatkan produk berdasarkan id
    const id = +req.params.id; // Mendapatkan id dari parameter request dan mengubahnya menjadi tipe number
    if (isNaN(id)) {
      // Memeriksa apakah id adalah angka
      return res.status(400).send("Invalid ID"); // Mengirimkan respon 400 jika id tidak valid
    }
    try {
      // Blok try untuk menangani eksekusi kode yang mungkin menghasilkan error
      let products = await Product.findOne({
        // Mencari satu produk berdasarkan id
        where: {
          id: id, // Kondisi pencarian berdasarkan id
        },
        include: [Category], // Menyertakan data kategori untuk produk tersebut
      });
      res.json(products); // Mengirimkan respon dalam format JSON berisi data produk
    } catch (err) {
      // Blok catch untuk menangani error jika terjadi
      res.send(err); // Mengirimkan error sebagai respon
    }
  }

  static async addPage(req, res) {
    // Metode statis untuk menampilkan halaman formulir penambahan produk
    try {
      // Blok try untuk menangani eksekusi kode yang mungkin menghasilkan error
      let users = await User.findAll({}); // Mengambil semua pengguna dari database
      let categories = await Category.findAll({}); // Mengambil semua kategori dari database
      res.render("products/formProduct", { users, categories }); // Merender halaman formProduct.ejs dengan data pengguna dan kategori
    } catch (err) {
      // Blok catch untuk menangani error jika terjadi
      res.send(err); // Mengirimkan error sebagai respon
    }
  }

  static async add(req, res) {
    // Metode statis untuk menambahkan produk baru
    try {
      // Blok try untuk menangani eksekusi kode yang mungkin menghasilkan error
      const { name, quantity, CategoryId, created_by, updated_by } = req.body; // Mendapatkan data produk dari body request
      const url_gambar_product = req.file; // Mendapatkan file gambar produk dari request

      // Generate nama file acak menggunakan UUID untuk gambar produk
      const randomFileName = uuidv4(); // Membuat UUID untuk nama file gambar
      let filePath = url_gambar_product ? `${randomFileName}.jpg` : null; // Tetapkan nama file acak untuk gambar produk jika ada

      // Simpan file gambar produk dengan nama file acak
      if (url_gambar_product) {
        // Jika ada gambar produk yang diunggah
        const tempPath = url_gambar_product.path; // Mendapatkan path sementara dari file gambar yang diunggah
        const targetPath = path.join(
          __dirname,
          "..",
          "public",
          "assets",
          "images",
          "products",
          randomFileName + ".jpg"
        ); // Menentukan path tujuan untuk menyimpan gambar produk
        fs.renameSync(tempPath, targetPath); // Memindahkan file gambar ke path tujuan
      } else {
        // Jika tidak ada gambar produk yang diunggah
        // Salin file default.png dengan nama acak ke lokasi yang dituju
        const defaultImagePath = path.join(
          __dirname,
          "..",
          "public",
          "assets",
          "images",
          "default.png"
        ); // Menentukan path dari gambar default
        const randomDefaultFileName = `default_${randomFileName}.jpg`; // Nama file default dengan UUID
        fs.copyFileSync(
          defaultImagePath,
          path.join(
            __dirname,
            "..",
            "public",
            "assets",
            "images",
            "products",
            randomDefaultFileName
          )
        ); // Menyalin file default ke lokasi tujuan dengan nama file acak
        filePath = randomDefaultFileName; // Menetapkan nama file default yang disalin
      }

      let resultProduct = await Product.create({
        // Membuat produk baru di database
        name,
        quantity,
        CategoryId,
        url_gambar_product: filePath, // Menyimpan path gambar produk
        created_by,
        updated_by,
      });

      res.json(resultProduct); // Mengirimkan respon dalam format JSON berisi data produk yang baru dibuat
    } catch (err) {
      // Blok catch untuk menangani error jika terjadi
      res.send(err); // Mengirimkan error sebagai respon
    }
  }

  static async delete(req, res) {
    // Metode statis untuk menghapus produk berdasarkan id
    try {
      // Blok try untuk menangani eksekusi kode yang mungkin menghasilkan error
      const id = +req.params.id; // Mendapatkan id dari parameter request dan mengubahnya menjadi tipe number

      const product = await Product.findByPk(id); // Mencari produk berdasarkan id

      // Jika ada gambar, hapus gambar dan datanya
      if (product.url_gambar_product) {
        // Jika produk memiliki gambar
        // Dapatkan path file gambar
        const imagePath = path.join(
          __dirname,
          "..",
          "public",
          "assets",
          "images",
          "products",
          product.url_gambar_product
        );

        // Hapus file gambar dari sistem file
        if (fs.existsSync(imagePath)) {
          // Memeriksa apakah file gambar ada
          fs.unlinkSync(imagePath); // Menghapus file gambar
        }
      }

      // Hapus entri produk dari database
      let resultProduct = await Product.destroy({
        // Menghapus produk dari database
        where: {
          id, // Kondisi penghapusan berdasarkan id
        },
      });

      resultProduct === 1 // Memeriksa apakah produk berhasil dihapus
        ? res.redirect("/products") // Mengarahkan ke halaman /products jika berhasil dihapus
        : res.send(`Product with ID ${id} has not been deleted`); // Mengirimkan pesan jika produk tidak ditemukan
    } catch (err) {
      // Blok catch untuk menangani error jika terjadi
      res.send(err); // Mengirimkan error sebagai respon
    }
  }

  static async updatePage(req, res) {
    // Metode statis untuk menampilkan halaman edit produk
    try {
      // Blok try untuk menangani eksekusi kode yang mungkin menghasilkan error
      const id = +req.params.id; // Mendapatkan id dari parameter request dan mengubahnya menjadi tipe number
      let products = await Product.findOne({
        // Mencari satu produk berdasarkan id
        where: {
          id: id, // Kondisi pencarian berdasarkan id
        },
        include: [Category, User], // Menyertakan data kategori dan pengguna untuk produk tersebut
      });
      let users = await User.findAll({}); // Mengambil semua pengguna dari database
      let categories = await Category.findAll({}); // Mengambil semua kategori dari database
      res.render("products/editProducts", { products, users, categories }); // Merender halaman editProducts dengan data produk, pengguna, dan kategori
    } catch (err) {
      // Blok catch untuk menangani error jika terjadi
      res.send(err); // Mengirimkan error sebagai respon
    }
  }

  static async update(req, res) {
    // Metode statis untuk mengupdate produk berdasarkan id
    try {
      // Blok try untuk menangani eksekusi kode yang mungkin menghasilkan error
      const id = +req.params.id; // Mendapatkan id dari parameter request dan mengubahnya menjadi tipe number
      const { name, quantity, CategoryId, created_by, updated_by } = req.body; // Mendapatkan data produk dari body request
      let imagePath;

      if (req.file) {
        // Jika ada file gambar produk yang diunggah
        // Generate nama file acak menggunakan UUID untuk gambar produk baru
        const randomFileName = uuidv4(); // Membuat UUID untuk nama file gambar baru
        imagePath = `${randomFileName}.jpg`; // Menetapkan nama file acak untuk gambar produk baru

        const product = await Product.findByPk(id); // Mencari produk berdasarkan id
        if (product.url_gambar_product) {
          // Jika produk memiliki gambar
          // Hapus file gambar produk lama
          fs.unlinkSync(
            path.join(
              __dirname,
              "..",
              "public",
              "assets",
              "images",
              "products",
              product.url_gambar_product
            )
          ); // Menghapus file gambar produk lama
        }

        // Simpan file gambar produk baru dengan nama file acak
        const tempPath = req.file.path; // Mendapatkan path sementara dari file gambar yang diunggah
        const targetPath = path.join(
          __dirname,
          "..",
          "public",
          "assets",
          "images",
          "products",
          randomFileName + ".jpg"
        ); // Menentukan path tujuan untuk menyimpan gambar produk
        fs.renameSync(tempPath, targetPath); // Memindahkan file gambar ke path tujuan
      } else {
        // Jika tidak ada file gambar produk yang diunggah
        const product = await Product.findByPk(id); // Mencari produk berdasarkan id
        imagePath = product.url_gambar_product; // Menetapkan path gambar produk yang ada
      }

      let resultProduct = await Product.update(
        // Mengupdate produk di database
        {
          name,
          quantity,
          CategoryId,
          url_gambar_product: imagePath, // Menyimpan path gambar produk
          created_by,
          updated_by,
        },
        {
          where: {
            id, // Kondisi pengupdatean berdasarkan id
          },
        }
      );

      res.send(resultProduct); // Mengirimkan respon berisi hasil pengupdatean
    } catch (err) {
      // Blok catch untuk menangani error jika terjadi
      res.send(err); // Mengirimkan error sebagai respon
    }
  }
}
module.exports = ProductController; // Mengekspor kelas ProductController
