const userRoutes = require("express").Router();
const UserController = require("../controllers/UserController");
const multer = require("multer");

const storage = multer.diskStorage({
  destination: function (req, file, cb) {
    cb(null, "public/assets/images/users");
  },
  filename: function (req, file, cb) {
    cb(null, file.originalname);
  },
});

const upload = multer({ storage: storage });

userRoutes.get("/", UserController.getUsers);
userRoutes.get("/add", UserController.registerPage);
userRoutes.post("/add", upload.single("image"), UserController.add);
userRoutes.post("/login", UserController.login);
// userRoutes.get("/delete/:id", UserController.delete);
userRoutes.delete("/delete/:id", UserController.delete);
userRoutes.get("/update/:id", UserController.updatePage);
// userRoutes.post("/update/:id", upload.single("image"), UserController.update);
userRoutes.put("/update/:id", upload.single("image"), UserController.update);

module.exports = userRoutes;
