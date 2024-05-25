const route = require("express").Router();
// const HomeController = require("../controllers/HomeController");

route.get("/", (req, res) => {
  res.send("Hello World!");
});

// route.get("/", HomeController.show);

const userRoutes = require("./user");
const categoryRoutes = require("./category");
const productRoutes = require("./product");

route.use("/users", userRoutes);
route.use("/products", productRoutes);
route.use("/categories", categoryRoutes);

module.exports = route;
