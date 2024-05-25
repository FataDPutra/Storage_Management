const { User } = require("../models");
const fs = require("fs");
const path = require("path");
const user = require("../models/user");

class UserController {
  static async getUsers(req, res) {
    try {
      let users = await User.findAll({
        order: [["id", "asc"]],
      });
      //   res.render("users/brand", { users });
      res.json(users);
    } catch (err) {
      res.send(err);
    }
  }

  static async login(req, res) {
    const { username, password } = req.body;

    // Periksa apakah username dan password telah diberikan
    if (!username || !password) {
      return res.status(400).send("Username and password are required.");
    }

    try {
      // Cari pengguna berdasarkan username
      let user = await User.findOne({
        where: { username: username },
      });

      if (!user) {
        return res.status(404).send("User not found.");
      }

      // Periksa apakah password cocok
      const passwordMatch = password === user.password;
      if (!passwordMatch) {
        return res.status(401).send("Incorrect password.");
      }

      // Login berhasil, kirim data pengguna
      res.send(user);
    } catch (err) {
      res.status(500).send("Internal Server Error");
    }
  }

  static registerPage(req, res) {
    res.render("users/formRegister");
  }

  static async add(req, res) {
    try {
      const { username, password } = req.body;
      const image = req.file;
      let filePath = image ? image.filename : null;
      let resultUser = await User.create({
        username,
        password,
        image: filePath,
      });
      res.redirect("/users");
    } catch (err) {
      res.send(err);
    }
  }

  static async delete(req, res) {
    try {
      const id = +req.params.id;
      const user = await User.findByPk(id);

      // Jika ada gambar, hapus gambar dan datanya
      if (user.image) {
        // Dapatkan path file gambar
        const imagePath = path.join(
          __dirname,
          "..",
          "public",
          "assets",
          "images",
          "users",
          user.image
        );

        // Hapus file gambar dari sistem file
        if (fs.existsSync(imagePath)) {
          fs.unlinkSync(imagePath);
        }
      }

      // Hapus entri buah dari database
      let resultUser = await User.destroy({
        where: {
          id,
        },
      });

      resultUser === 1
        ? res.redirect("/users")
        : res.send(`User with ID ${id} has not been deleted`);
    } catch (err) {
      res.send(err);
    }
  }

  static updatePage(req, res) {
    const id = +req.params.id;
    if (isNaN(id)) {
      return res.status(400).send("Invalid ID");
    }
    User.findOne({
      where: {
        id: id,
      },
    })
      .then((users) => {
        res.render("users/editUser", { users });
      })
      .catch((err) => {
        res.send(err);
      });
  }

  static async update(req, res) {
    try {
      const id = +req.params.id;
      const { username, password } = req.body;
      let imagePath;

      if (req.file) {
        imagePath = req.file.filename;
        const user = await User.findByPk(id);
        if (user.image) {
          fs.unlinkSync(
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
      } else {
        const user = await User.findByPk(id);
        imagePath = user.image; // Maintain the current image path
      }

      let resultUser = await User.update(
        {
          username,
          password,
          image: imagePath,
        },
        {
          where: {
            id,
          },
        }
      );
      // res.redirect("/users");
      res.send(resultUser);
    } catch (err) {
      res.send(err);
    }
  }
}
module.exports = UserController;
