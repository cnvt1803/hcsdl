const express = require("express");
const router = express.Router();
const doanhThuController = require("../controllers/doanhThuController");

router.get("/doanhthu", doanhThuController.TinhDoanhThuKH);

module.exports = router;
