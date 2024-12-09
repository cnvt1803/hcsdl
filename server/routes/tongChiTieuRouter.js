const express = require("express");
const router = express.Router();
const tongChiTieuController = require("../controllers/tongChiTieuController");

// Định nghĩa route API GET /tongchitieukh
router.get("/tongchitieukh", tongChiTieuController.TinhTongChiTieuKH);

module.exports = router;
