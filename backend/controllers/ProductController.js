const { Product, User, Category } = require("../models");
const fs = require("fs");
const path = require("path");

class ProductController {
  static async getProducts(req, res) {
    try {
      let products = await Product.findAll({
        include: [Category],
        order: [["id", "asc"]],
      });

      res.json(products);
      //   res.render("products/product", { products });
    } catch (err) {
      res.send(err);
    }
  }

  static async addPage(req, res) {
    try {
      let users = await User.findAll({});
      let categories = await Category.findAll({});
      res.render("products/formProduct", { users, categories });
    } catch (err) {
      res.send(err);
    }
  }

  static async add(req, res) {
    try {
      const { name, quantity, CategoryId, created_by, updated_by } = req.body;
      // const image = req.file;
      const url_gambar_product = req.file;
      let filePath = url_gambar_product ? url_gambar_product.filename : null;

      let resultProduct = await Product.create({
        name,
        quantity,
        CategoryId,
        url_gambar_product: filePath,
        created_by,
        updated_by,
      });
      // res.redirect("/products");
      res.json(resultProduct);
    } catch (err) {
      res.send(err);
    }
  }

  static async delete(req, res) {
    try {
      const id = +req.params.id;

      const product = await Product.findByPk(id);

      // Jika ada gambar, hapus gambar dan datanya
      // if (product.image) {
      if (product.url_gambar_product) {
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
          fs.unlinkSync(imagePath);
        }
      }

      // Hapus entri buah dari database
      let resultProduct = await Product.destroy({
        where: {
          id,
        },
      });

      resultProduct === 1
        ? res.redirect("/products")
        : res.send(`Product with ID ${id} has not been deleted`);
    } catch (err) {
      res.send(err);
    }
  }

  static async updatePage(req, res) {
    try {
      const id = +req.params.id;
      let products = await Product.findOne({
        where: {
          id: id,
        },
        include: [Category, User],
      });
      let users = await User.findAll({});
      let categories = await Category.findAll({});
      res.render("products/editProducts", { products, users, categories });
    } catch (err) {
      res.send(err);
    }
  }

  static async update(req, res) {
    try {
      const id = +req.params.id;
      const { name, quantity, CategoryId, created_by, updated_by } = req.body;
      let imagePath;

      if (req.file) {
        imagePath = req.file.filename;
        const product = await Product.findByPk(id);
        if (product.url_gambar_product) {
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
          );
        }
      } else {
        const product = await Product.findByPk(id);
        imagePath = product.url_gambar_product; // Maintain the current image path
      }

      let resultProduct = await Product.update(
        {
          name,
          quantity,
          CategoryId,
          url_gambar_product: imagePath,
          created_by,
          updated_by,
        },
        {
          where: {
            id,
          },
        }
      );
      res.send(resultProduct);
      // res.redirect("/products");
    } catch (err) {
      res.send(err);
    }
  }
}
module.exports = ProductController;
