require("dotenv").config();
const express = require("express");
const bodyParser = require("body-parser");
const cors = require("cors");
const productRouter = require("./routes/productRouter");
const danhgiasaoRouter = require("./routes/danhgiasaoRouter")
const xemlichsuRouter = require("./routes/xemlichsuRouter"); 
const tongChiTieuRouter = require("./routes/tongChiTieuRouter");
const doanhThuRouter = require("./routes/doanhThuRouter");
// Khởi tạo ứng dụng Express
const app = express();
const port = process.env.PORT || 5001;

// Cấu hình middlewares
app.use(bodyParser.json());
app.use(cors());

// Sử dụng các router
app.use("/database", productRouter);
app.use("/database",danhgiasaoRouter );
app.use("/database", xemlichsuRouter); 
app.use("/database", tongChiTieuRouter); 
app.use("/database", doanhThuRouter);
// Khởi động server
app.listen(port, () => {
  console.log(`Server running on http://localhost:${port}`);
});
