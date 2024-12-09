const productModel = require("../models/productModel");

const getProducts = async (req, res) => {
  try {
    const products = await productModel.getProducts();  
    res.status(200).json(products);  
  } catch (error) {
    console.error("Error fetching products:", error); 
    res.status(500).json({ message: "Internal Server Error" });  
  }
};

module.exports = {
  getProducts
};
