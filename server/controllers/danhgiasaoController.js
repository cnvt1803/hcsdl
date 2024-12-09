const Evaluate = require("../models/danhgiasaoModel");

const EvaluateProduct = async (req, res) => {
  try {
    const productname = req.query.productname ; 
    const data = await Evaluate.Evaluate(productname);

    
    if (data.message) {
      return res.status(404).json({ message: data.message });
    }

    res.status(200).json(data);
  } catch (error) {
    console.error("Error evaluating products:", error);
    res.status(500).json({ message: "Internal Server Error" });
  }
};

module.exports = { EvaluateProduct };
