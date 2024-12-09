const connectDB = require("../config/dbConfig");

const Evaluate = async (productname) => {
  try {
    const pool = await connectDB();
    const result = await pool.request()
      .input("TenSanpham", productname)
      .query(`
        EXEC SodiemdanhgiaTheoTenSanpham 
        @TenSanpham = @TenSanpham;
      `);

    if (!result.recordset || result.recordset.length === 0) {
      return { message: "Không tìm thấy sản phẩm" }; 
    }

    return result.recordset;
  } catch (err) {
    console.error("Error executing stored procedure:", err);
    throw err;
  }
};

module.exports = { Evaluate };
