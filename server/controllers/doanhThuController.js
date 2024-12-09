const { TinhDoanhThuCuaHang } = require("../models/doanhThuModel");

const TinhDoanhThuKH = async (req, res) => {
  try {
    const { Sdt_Cua_Hang, start_date, end_date } = req.query; 

    if (!Sdt_Cua_Hang || !start_date || !end_date) {
      return res.status(400).json({
        message: "Thiếu thông tin bắt buộc: Sdt_Cua_Hang, start_date hoặc end_date",
      });
    }

    const data = await TinhDoanhThuCuaHang(Sdt_Cua_Hang, start_date, end_date);

    if (data.message) {
      return res.status(404).json({ message: data.message });
    }

    res.status(200).json(data);
  } catch (error) {
    console.error("Error calculating shop revenue:", error);
    res.status(500).json({ message: "Internal Server Error" });
  }
};

module.exports = { TinhDoanhThuKH };
