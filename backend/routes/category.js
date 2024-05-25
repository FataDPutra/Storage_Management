const categoryRoutes = require("express").Router();
const CategoryController = require("../controllers/CategoryController");

categoryRoutes.get("/", CategoryController.getCategories);
categoryRoutes.post("/add", CategoryController.add);
// categoryRoutes.get("/add", CategoryController.addPage);
// categoryRoutes.get("/delete/:id", CategoryController.delete);
categoryRoutes.delete("/delete/:id", CategoryController.delete);
// categoryRoutes.post("/update/:id", CategoryController.update);
categoryRoutes.put("/update/:id", CategoryController.update);
// categoryRoutes.get("/update/:id", CategoryController.updatePage);

module.exports = categoryRoutes;
