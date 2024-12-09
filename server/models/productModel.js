const connectDB = require("../config/dbConfig");

const getProducts = async () => {
  const pool = await connectDB(); 
  const result = await pool.request().query(`
    SELECT *
    FROM San_Pham
  `);
  return result.recordset;  
};

module.exports = {
  getProducts
};
