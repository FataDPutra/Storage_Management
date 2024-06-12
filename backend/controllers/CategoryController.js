const { Category } = require("../models"); // Mengimpor model Category dari folder models

class CategoryController {
  // Mendefinisikan kelas CategoryController
  static async getCategories(req, res) {
    // Metode statis untuk mendapatkan semua kategori
    try {
      // Blok try untuk menangani eksekusi kode yang mungkin menghasilkan error
      let categories = await Category.findAll({
        // Mengambil semua kategori dari database
        order: [["id", "asc"]], // Mengurutkan kategori berdasarkan id secara ascending
      });
      res.json(categories); // Mengirimkan respon dalam format JSON berisi data kategori
    } catch (err) {
      // Blok catch untuk menangani error jika terjadi
      res.send(err); // Mengirimkan error sebagai respon
    }
  }

  static addPage(req, res) {
    // Metode statis untuk menampilkan halaman formulir penambahan kategori
    res.render("categories/formCategory.ejs"); // Merender halaman formCategory.ejs
  }

  static async getCategory(req, res) {
    // Metode statis untuk mendapatkan kategori berdasarkan id
    const id = +req.params.id; // Mendapatkan id dari parameter request dan mengubahnya menjadi tipe number
    if (isNaN(id)) {
      // Memeriksa apakah id adalah angka
      return res.status(400).send("Invalid ID"); // Mengirimkan respon 400 jika id tidak valid
    }
    try {
      // Blok try untuk menangani eksekusi kode yang mungkin menghasilkan error
      let categories = await Category.findOne({
        // Mencari satu kategori berdasarkan id
        where: {
          id: id, // Kondisi pencarian berdasarkan id
        },
      });
      res.json(categories); // Mengirimkan respon dalam format JSON berisi data kategori
    } catch (err) {
      // Blok catch untuk menangani error jika terjadi
      res.send(err); // Mengirimkan error sebagai respon
    }
  }

  static async add(req, res) {
    // Metode statis untuk menambahkan kategori baru
    try {
      // Blok try untuk menangani eksekusi kode yang mungkin menghasilkan error
      const { name } = req.body; // Mendapatkan nama kategori dari body request
      let resultCategory = await Category.create({
        // Membuat kategori baru di database
        name, // Menyimpan nama kategori
      });
      res.json(resultCategory); // Mengirimkan respon dalam format JSON berisi data kategori yang baru dibuat
    } catch (err) {
      // Blok catch untuk menangani error jika terjadi
      res.send(err); // Mengirimkan error sebagai respon
    }
  }

  static async delete(req, res) {
    // Metode statis untuk menghapus kategori berdasarkan id
    try {
      // Blok try untuk menangani eksekusi kode yang mungkin menghasilkan error
      const id = +req.params.id; // Mendapatkan id dari parameter request dan mengubahnya menjadi tipe number
      let resultCategory = await Category.destroy({
        // Menghapus kategori dari database
        where: {
          id, // Kondisi penghapusan berdasarkan id
        },
      });
      resultCategory === 1 // Memeriksa apakah kategori berhasil dihapus
        ? res.redirect("/categories") // Mengarahkan ke halaman /categories jika berhasil dihapus
        : res.send(`Category with ID ${id} has not been deleted`); // Mengirimkan pesan jika kategori tidak ditemukan
    } catch (err) {
      // Blok catch untuk menangani error jika terjadi
      res.send(err); // Mengirimkan error sebagai respon
    }
  }

  static updatePage(req, res) {
    // Metode statis untuk menampilkan halaman edit kategori
    const id = +req.params.id; // Mendapatkan id dari parameter request dan mengubahnya menjadi tipe number
    if (isNaN(id)) {
      // Memeriksa apakah id adalah angka
      return res.status(400).send("Invalid ID"); // Mengirimkan respon 400 jika id tidak valid
    }

    Category.findOne({
      // Mencari satu kategori berdasarkan id
      where: {
        id: id, // Kondisi pencarian berdasarkan id
      },
    })
      .then((categories) => {
        // Jika berhasil menemukan kategori
        res.render("categories/editCategory", { categories }); // Merender halaman editCategory dengan data kategori
      })
      .catch((err) => {
        // Jika terjadi error
        res.send(err); // Mengirimkan error sebagai respon
      });
  }

  static async update(req, res) {
    // Metode statis untuk mengupdate kategori berdasarkan id
    try {
      // Blok try untuk menangani eksekusi kode yang mungkin menghasilkan error
      const id = +req.params.id; // Mendapatkan id dari parameter request dan mengubahnya menjadi tipe number
      const { name } = req.body; // Mendapatkan nama kategori dari body request
      let resultCategory = await Category.update(
        // Mengupdate kategori di database
        {
          name, // Menyimpan nama kategori
        },
        {
          where: {
            id, // Kondisi pengupdatean berdasarkan id
          },
        }
      );
      res.send(resultCategory); // Mengirimkan respon berisi hasil pengupdatean
    } catch (err) {
      // Blok catch untuk menangani error jika terjadi
      res.send(err); // Mengirimkan error sebagai respon
    }
    const { name } = req.body; // Baris ini seharusnya tidak diperlukan, karena sudah ada di atas
  }
}
module.exports = CategoryController; // Mengekspor kelas CategoryController
