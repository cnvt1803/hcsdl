const { XemLichSu } = require("../models/xemlichsuModel"); // Import model XemLichSu

const LichSuMuaHang = async (req, res) => {
  try {
    const { Sdt, startDay, endDay } = req.query;

    if (!Sdt || !startDay || !endDay) {
      return res.status(400).json({
        message: "Thiếu thông tin bắt buộc: Sdt, startDay, hoặc endDay",
      });
    }

    const data = await XemLichSu(Sdt, startDay, endDay);

    if (!data || data.message) {
      return res.status(404).json({ message: data.message || "Không tìm thấy dữ liệu" });
    }

    res.status(200).json(data);
  } catch (error) {
    console.error("Error fetching purchase history:", error);
    res.status(500).json({ message: "Internal Server Error" });
  }
};

module.exports = { LichSuMuaHang };
