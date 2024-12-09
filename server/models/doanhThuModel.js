const connectDB = require("../config/dbConfig"); 

const TinhDoanhThuCuaHang = async (Sdt_Cua_Hang, start_date, end_date) => {
  try {
    const pool = await connectDB(); 


    const result = await pool.request()
      .input("Sdt_Cua_Hang", Sdt_Cua_Hang) 
      .input("start_date", start_date)
      .input("end_date",  end_date) 
      .query(`
        SELECT * FROM Tinh_Doanh_Thu_Cua_Cua_Hang_Trong_Khoang_TG(@Sdt_Cua_Hang, @start_date, @end_date)
      `);

    // Kiểm tra nếu không có dữ liệu trả về
    if (!result.recordset || result.recordset.length === 0) {
      return { message: "Không có dữ liệu" }; 
    }

    // Trả về kết quả
    return result.recordset;
  } catch (err) {
    console.error("Error executing SQL function:", err);
    throw err; // Ném lỗi nếu có lỗi xảy ra
  }
};

module.exports = { TinhDoanhThuCuaHang };
