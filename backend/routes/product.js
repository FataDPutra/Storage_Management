const productRoutes = require("express").Router();
const ProductController = require("../controllers/ProductController");
const multer = require("multer");

const storage = multer.diskStorage({
  destination: function (req, file, cb) {
    cb(null, "public/assets/images/products");
  },
  filename: function (req, file, cb) {
    cb(null, file.originalname);
  },
});

const upload = multer({ storage: storage });

productRoutes.get("/", ProductController.getProducts); //READ

productRoutes.get("/add", ProductController.addPage); // CREATE PAGE

productRoutes.post(
  "/add",
  upload.single("url_gambar_product"),
  ProductController.add
); //CREATE

// productRoutes.get("/delete/:id", ProductController.delete);
productRoutes.delete("/delete/:id", ProductController.delete); // DELETE

productRoutes.get("/update/:id", ProductController.updatePage); // UPDATE PAGE
// productRoutes.post(
//   "/update/:id",
//   upload.single("url_gambar_product"),
//   ProductController.update
// );

productRoutes.put(
  "/update/:id",
  upload.single("url_gambar_product"),
  ProductController.update
); //UPDATE

module.exports = productRoutes;
