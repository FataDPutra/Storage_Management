const dotenv = require("dotenv");
const express = require("express");
const app = express();
const port = process.env.PORT || 3000;
const cors = require("cors");
const routes = require("./routes");
// const path = require("path");

dotenv.config();
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

app.use(routes);

app.use(cors());

// app.set("view engine", "ejs");
// app.use("/assets/images/", express.static("public/assets/images/"));
// app.use(
//   "/assets/images/products",
//   express.static("public/assets/images/products")
// );
// app.use("/assets/images/users", express.static("public/assets/images/users"));
// app.use(express.static(path.join(__dirname, "public")));
// app.set("views", path.join(__dirname, "views"));

app.listen(port, () => {
  console.log(`Example app listening on port ${port}`);
});
