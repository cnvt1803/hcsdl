const connectDB = require("../config/dbConfig");

const TinhTongChiTieu = async (Sdt_find, start_date, end_date) => {
  try {
    const pool = await connectDB(); 
    const result = await pool.request()
      .input("Sdt_find",  Sdt_find) 
      .input("start_date",  start_date) 
      .input("end_date",  end_date) 
      .query(`
        SELECT * FROM dbo.Tinh_Tong_Chi_Tieu_Cua_KH(@Sdt_find, @start_date, @end_date)
      `);

    if (!result.recordset || result.recordset.length === 0) {
      return { message: "Không có dữ liệu" }; 
    }
    return result.recordset;
  } catch (err) {
    console.error("Error executing SQL function:", err);
    throw err; // Ném lỗi nếu có lỗi xảy ra
  }
};

module.exports = { TinhTongChiTieu };
