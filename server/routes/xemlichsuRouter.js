const express = require("express");
const { LichSuMuaHang } = require("../controllers/xemlichsuController");
const router = express.Router();

router.get("/lichsu", LichSuMuaHang);

module.exports = router;
