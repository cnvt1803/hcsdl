const sql = require("mssql");

const sqlConfig = {
  user: "sa",
  password: "123456aA@$",
  server: "localhost",
  database: "DTB2",
  options: {
    encrypt: true,
    trustServerCertificate: true,
  },
};

const connectDB = async () => {
  try {
    return await sql.connect(sqlConfig);
  } catch (err) {
    console.error("Database connection error:", err);
    throw err;
  }
};

module.exports = connectDB;
