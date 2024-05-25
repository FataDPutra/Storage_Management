const { Category } = require("../models");

class CategoryController {
  static async getCategories(req, res) {
    try {
      let categories = await Category.findAll({
        order: [["id", "asc"]],
      });
      //   res.render("categories/category", { categories });
      res.json(categories);
    } catch (err) {
      res.send(err);
    }
  }

  static addPage(req, res) {
    res.render("categories/formCategory.ejs");
  }

  static async add(req, res) {
    try {
      const { name } = req.body;
      let resultCategory = await Category.create({
        name,
      });
      res.json(resultCategory);
      //   res.redirect("/categories");
    } catch (err) {
      res.send(err);
    }
  }

  static async delete(req, res) {
    try {
      const id = +req.params.id;
      let resultCategory = await Category.destroy({
        where: {
          id,
        },
      });
      resultCategory === 1
        ? res.redirect("/categories")
        : res.send(`Category with ID ${id} has noot been deleted`);
    } catch (err) {
      res.send(err);
    }
  }

  static updatePage(req, res) {
    const id = +req.params.id;
    if (isNaN(id)) {
      return res.status(400).send("Invalid ID");
    }

    Category.findOne({
      where: {
        id: id,
      },
    })
      .then((categories) => {
        res.render("categories/editCategory", { categories });
      })
      .catch((err) => {
        res.send(err);
      });
  }

  static async update(req, res) {
    try {
      const id = +req.params.id;
      const { name } = req.body;
      let resultCategory = await Category.update(
        {
          name,
        },
        {
          where: {
            id,
          },
        }
      );
      // res.redirect("/categories");
      res.send(resultCategory);
    } catch (err) {
      res.send(err);
    }
    const { name } = req.body;
  }
}
module.exports = CategoryController;
