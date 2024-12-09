const express = require("express");
const router = express.Router();
const productController = require("../controllers/productController");

router.get("/product", productController.getProducts);  // Định nghĩa route API GET /product

module.exports = router;
