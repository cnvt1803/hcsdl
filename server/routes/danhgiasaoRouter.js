const express = require("express");
const router = express.Router();
const evaluateController = require("../controllers/danhgiasaoController");

router.get("/EvaluateProduct", evaluateController.EvaluateProduct);

module.exports = router;
