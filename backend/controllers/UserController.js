const { User } = require("../models"); // Import model User dari direktori models
const fs = require("fs"); // Import modul fs untuk operasi sistem file
const path = require("path"); // Import modul path untuk menangani dan mentransformasi jalur file
const { v4: uuidv4 } = require("uuid"); // Import modul uuid dan gunakan versi 4 untuk menghasilkan pengenal unik

class UserController {
  // Mendefinisikan kelas UserController
  static async getUsers(req, res) {
    // Mendefinisikan metode statis async untuk mendapatkan semua pengguna
    try {
      let users = await User.findAll({
        // Mengambil semua pengguna dari database
        order: [["id", "asc"]], // Mengurutkan pengguna berdasarkan ID secara ascending
      });
      //   res.render("users/brand", { users }); // Logika rendering untuk tampilan yang dikomentari
      res.json(users); // Mengirimkan pengguna dalam format JSON sebagai respons
    } catch (err) {
      res.send(err); // Mengirimkan respons error jika pengambilan pengguna gagal
    }
  }

  static async getUser(req, res) {
    // Mendefinisikan metode statis async untuk mendapatkan pengguna berdasarkan ID
    const id = +req.params.id; // Mengonversi parameter ID dari request menjadi angka
    if (isNaN(id)) {
      // Memeriksa apakah ID bukan angka
      return res.status(400).send("Invalid ID"); // Mengirimkan respons status 400 dan pesan error
    }
    try {
      let user = await User.findOne({
        // Mengambil satu pengguna berdasarkan ID
        where: {
          id: id, // Kondisi untuk mencocokkan ID pengguna
        },
      });
      res.json(user); // Mengirimkan pengguna dalam format JSON sebagai respons
    } catch (err) {
      res.send(err); // Typo: harusnya res.send(err) - Mengirimkan respons error jika pengambilan pengguna gagal
    }
  }

  static async checkUsername(req, res) {
    // Mendefinisikan metode statis async untuk memeriksa apakah username sudah ada
    const { username } = req.body; // Mendestruktur username dari body request

    try {
      let user = await User.findOne({
        // Mengambil pengguna berdasarkan username
        where: { username: username }, // Kondisi untuk mencocokkan username
      });

      if (user) {
        // Jika pengguna dengan username yang sama ditemukan
        res.json({ exists: true }); // Mengirimkan objek JSON yang menunjukkan bahwa username sudah ada
      } else {
        res.json({ exists: false }); // Mengirimkan objek JSON yang menunjukkan bahwa username tidak ada
      }
    } catch (err) {
      res.status(500).send("Internal Server Error"); // Mengirimkan status 500 dan pesan error jika terjadi kesalahan
    }
  }

  static async login(req, res) {
    // Mendefinisikan metode statis async untuk menangani login pengguna
    const { username, password } = req.body; // Mendestruktur username dan password dari body request

    if (!username || !password) {
      // Memeriksa apakah username atau password tidak ada
      return res.status(400).send("Username and password are required."); // Mengirimkan status 400 dan pesan error
    }

    try {
      let user = await User.findOne({
        // Mengambil pengguna berdasarkan username
        where: { username: username }, // Kondisi untuk mencocokkan username
      });

      if (!user) {
        // Jika pengguna tidak ditemukan
        return res.status(404).send("User not found."); // Mengirimkan status 404 dan pesan error
      }

      const passwordMatch = password === user.password; // Memeriksa apakah password yang diberikan cocok dengan password yang disimpan
      if (!passwordMatch) {
        // Jika password tidak cocok
        return res.status(401).send("Incorrect password."); // Mengirimkan status 401 dan pesan error
      }

      res.send(user); // Mengirimkan data pengguna jika login berhasil
    } catch (err) {
      res.status(500).send("Internal Server Error"); // Mengirimkan status 500 dan pesan error jika terjadi kesalahan
    }
  }

  static registerPage(req, res) {
    // Mendefinisikan metode statis untuk merender halaman pendaftaran
    res.render("users/formRegister"); // Merender tampilan formRegister
  }

  static async add(req, res) {
    // Mendefinisikan metode statis async untuk menambahkan pengguna baru
    try {
      const { username, password } = req.body; // Mendestruktur username dan password dari body request
      const image = req.file; // Mendapatkan file yang diunggah dari request

      const randomFileName = uuidv4(); // Menghasilkan nama file acak menggunakan UUID

      const defaultImagePath = path.join(
        // Mendefinisikan path ke gambar default
        __dirname,
        "..",
        "public",
        "assets",
        "images",
        "default.png"
      );
      const randomDefaultFileName = `default_${randomFileName}.png`; // Mendefinisikan nama file acak untuk gambar default

      let filePath = image ? randomFileName : randomDefaultFileName; // Menetapkan path file berdasarkan apakah gambar diunggah atau tidak

      if (!image) {
        // Jika tidak ada gambar yang diunggah
        fs.copyFileSync(
          // Menyalin gambar default ke direktori pengguna dengan nama file acak
          defaultImagePath,
          path.join(
            __dirname,
            "..",
            "public",
            "assets",
            "images",
            "users",
            randomDefaultFileName
          )
        );
      } else {
        // Jika gambar diunggah
        const tempPath = image.path; // Mendapatkan path sementara dari gambar yang diunggah
        const targetPath = path.join(
          // Mendefinisikan path target untuk gambar yang diunggah
          __dirname,
          "..",
          "public",
          "assets",
          "images",
          "users",
          randomFileName
        );
        fs.renameSync(tempPath, targetPath); // Mengganti nama (memindahkan) gambar yang diunggah ke path target
      }

      let resultUser = await User.create({
        // Membuat pengguna baru di database
        username,
        password,
        image: filePath, // Menetapkan path file gambar untuk pengguna
      });
      // res.redirect("/users"); // Logika redirect yang dikomentari
      res.json(resultUser); // Mengirimkan pengguna yang dibuat dalam format JSON sebagai respons
    } catch (err) {
      res.send(err); // Mengirimkan respons error jika pembuatan pengguna gagal
    }
  }

  static async delete(req, res) {
    // Mendefinisikan metode statis async untuk menghapus pengguna
    try {
      const id = +req.params.id; // Mengonversi parameter ID dari request menjadi angka
      const user = await User.findByPk(id); // Menemukan pengguna berdasarkan primary key

      if (user.image) {
        // Jika pengguna memiliki gambar
        const imagePath = path.join(
          // Mendefinisikan path ke gambar pengguna
          __dirname,
          "..",
          "public",
          "assets",
          "images",
          "users",
          user.image
        );

        if (fs.existsSync(imagePath)) {
          // Memeriksa apakah file gambar ada
          fs.unlinkSync(imagePath); // Menghapus file gambar dari sistem file
        }
      }

      let resultUser = await User.destroy({
        // Menghapus pengguna dari database
        where: {
          id,
        },
      });

      resultUser === 1 // Memeriksa apakah penghapusan berhasil
        ? res.redirect("/users") // Redirect ke halaman pengguna jika berhasil
        : res.send(`User with ID ${id} has not been deleted`); // Mengirimkan pesan error jika tidak berhasil
    } catch (err) {
      res.send(err); // Mengirimkan respons error jika penghapusan pengguna gagal
    }
  }

  static updatePage(req, res) {
    // Mendefinisikan metode statis untuk merender halaman pembaruan pengguna
    const id = +req.params.id; // Mengonversi parameter ID dari request menjadi angka
    if (isNaN(id)) {
      // Memeriksa apakah ID bukan angka
      return res.status(400).send("Invalid ID"); // Mengirimkan respons status 400 dan pesan error
    }
    User.findOne({
      // Menemukan pengguna berdasarkan ID
      where: {
        id: id, // Kondisi untuk mencocokkan ID pengguna
      },
    })
      .then((user) => {
        res.render("users/editUser", { user }); // Merender tampilan editUser dengan data pengguna
      })
      .catch((err) => {
        res.send(err); // Mengirimkan respons error jika pengambilan pengguna gagal
      });
  }

  static async update(req, res) {
    // Mendefinisikan metode statis async untuk memperbarui pengguna
    try {
      const id = +req.params.id; // Mengonversi parameter ID dari request menjadi angka
      const { username, password } = req.body; // Mendestruktur username dan password dari body request
      let imagePath;

      if (req.file) {
        // Jika file gambar diunggah
        const randomFileName = uuidv4(); // Menghasilkan nama file acak menggunakan UUID
        imagePath = `${randomFileName}.jpg`; // Mendefinisikan path file gambar baru

        const user = await User.findByPk(id); // Menemukan pengguna berdasarkan primary key
        if (user.image) {
          // Jika pengguna sudah memiliki gambar
          fs.unlinkSync(
            // Menghapus file gambar lama
            path.join(
              __dirname,
              "..",
              "public",
              "assets",
              "images",
              "users",
              user.image
            )
          );
        }

        const tempPath = req.file.path; // Mendapatkan path sementara dari gambar yang diunggah
        const targetPath = path.join(
          // Mendefinisikan path target untuk gambar yang diunggah
          __dirname,
          "..",
          "public",
          "assets",
          "images",
          "users",
          imagePath
        );
        fs.renameSync(tempPath, targetPath); // Mengganti nama (memindahkan) gambar yang diunggah ke path target
      }

      let updatedUser = await User.update(
        // Memperbarui data pengguna di database
        {
          username,
          password,
          image: imagePath, // Menetapkan path file gambar untuk pengguna
        },
        {
          where: { id }, // Kondisi untuk mencocokkan ID pengguna
        }
      );
      res.json(updatedUser); // Mengirimkan pengguna yang diperbarui dalam format JSON sebagai respons
    } catch (err) {
      res.send(err); // Mengirimkan respons error jika pembaruan pengguna gagal
    }
  }
}

module.exports = UserController; // Mengekspor kelas UserController
