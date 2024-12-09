const { TinhTongChiTieu } = require("../models/tongChiTieuModel");

// Controller để xử lý yêu cầu tính tổng chi tiêu của khách hàng
const TinhTongChiTieuKH = async (req, res) => {
  try {
    const { Sdt_find, start_date, end_date } = req.query;

    if (!Sdt_find || !start_date || !end_date) {
      return res.status(400).json({
        message: "Thiếu thông tin bắt buộc: Sdt_find, start_date hoặc end_date",
      });
    }

    const data = await TinhTongChiTieu(Sdt_find, start_date, end_date);

    if (data.message) {
      return res.status(404).json({ message: data.message });
    }

    res.status(200).json(data);
  } catch (error) {
    console.error("Error calculating total expenses:", error);
    res.status(500).json({ message: "Internal Server Error" });
  }
};

module.exports = { TinhTongChiTieuKH };
