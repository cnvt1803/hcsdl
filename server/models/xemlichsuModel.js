const connectDB = require("../config/dbConfig");

const XemLichSu = async (Sdt,startDay,endDay) => {
  try {
    const pool = await connectDB();
    const result = await pool.request()
      .input("SDT", Sdt)
      .input("start", startDay)
      .input("end", endDay)
      .query(`
        EXEC LichSuMuaHang 
        @SoDienThoai = @SDT, 
        @NgayBatDau = @start, 
        @NgayKetThuc = @end;
      `);

    if (!result.recordset || result.recordset.length === 0) {
      return { message: "Không có lịch sử mua hàng" }; 
    }

    return result.recordset;
  } catch (err) {
    console.error("Error executing stored procedure:", err);
    throw err;
  }
};
module.exports = { XemLichSu };