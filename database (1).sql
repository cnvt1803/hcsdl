-- CREATE DATABASE DTB2
-- GO 
USE DTB2;
GO
-- Xóa tất cả các khóa ngoại
DECLARE @sql NVARCHAR(MAX) = N'';
SELECT @sql += 'ALTER TABLE [' + SCHEMA_NAME(schema_id) + '].[' + OBJECT_NAME(parent_object_id) + '] DROP CONSTRAINT [' + name + '];' + CHAR(13)
FROM sys.foreign_keys;
EXEC sp_executesql @sql;

GO -- Chia batch, cho phép khai báo lại biến @sql

-- Xóa tất cả các bảng
DECLARE @sql NVARCHAR(MAX) = N'';
SELECT @sql += 'DROP TABLE [' + SCHEMA_NAME(schema_id) + '].[' + name + '];' + CHAR(13)
FROM sys.objects
WHERE type = 'U'; -- 'U' đại diện cho User Table
EXEC sp_executesql @sql;
GO
-- Tạo bảng với NOT NULL cho tất cả các cột
CREATE TABLE Nha_Dieu_Hanh (
    Id_Nha_Dieu_Hanh VARCHAR(10) NOT NULL,
    CCCD VARCHAR(50) UNIQUE NOT NULL,
    Ngay_Sinh DATE NOT NULL,
    Ten_Dang_Nhap VARCHAR(50) UNIQUE NOT NULL,
    Ngay_Tao DATE NOT NULL,
    Ho VARCHAR(50) NOT NULL,
    Ten VARCHAR(50) NOT NULL,
    Email VARCHAR(100) NOT NULL,
    Gioi_Tinh TINYINT NOT NULL, -- 0: Nữ, 1: Nam
    Dia_Chi VARCHAR(MAX) NOT NULL,
    Sdt VARCHAR(15) NOT NULL,
    Mat_Khau VARCHAR(255) NOT NULL,
    Vai_Tro VARCHAR(50) NOT NULL,
    PRIMARY KEY (Id_Nha_Dieu_Hanh)
);
GO
-- Insert mock data into Nha_Dieu_Hanh


--CỬA HÀNG VÀ KHÁCH HÀNG CÓ KHÓA NGOẠI THAM CHIẾU TỚI KHÓA CHÍNH
--CỦA NGƯỜI DÙNG BÌNH THƯỜNG
CREATE TABLE Nguoi_Dung_Binh_Thuong (
    Id_Nguoi_Dung VARCHAR(10) NOT NULL,
    CCCD VARCHAR(50) UNIQUE NOT NULL,
    Ngay_Sinh DATE NOT NULL,
    Ten_Dang_Nhap VARCHAR(50) UNIQUE NOT NULL,
    Ngay_Tao DATE NOT NULL,
    Ho VARCHAR(50) NOT NULL,
    Ten VARCHAR(50) NOT NULL,
    Email VARCHAR(100) NOT NULL,
    Gioi_Tinh TINYINT NOT NULL, -- 0: Nữ, 1: Nam
    Dia_Chi VARCHAR(MAX) NOT NULL,
    Sdt VARCHAR(15) NOT NULL,
    Mat_Khau VARCHAR(255) NOT NULL,
	Vai_tro_nguoi_dung TINYINT NOT NULL,
    PRIMARY KEY (Id_Nguoi_Dung)
);

GO


CREATE TABLE Cua_Hang (
    Id_Nguoi_Dung_Binh_Thuong VARCHAR(10) NOT NULL,
    --Id_Nguoi_Dung VARCHAR(10)  NOT NULL,
    Ngay_Thanh_Lap DATE NOT NULL,
    Dia_Chi_Shop VARCHAR(MAX) NOT NULL,
    Ten_Cua_Shop VARCHAR(100) NOT NULL,
    So_Dien_Thoai VARCHAR(15) NOT NULL,
    Giay_Phep_Kinh_Doanh VARCHAR(255) NOT NULL,
    PRIMARY KEY (Id_Nguoi_Dung_Binh_Thuong),
    FOREIGN KEY (Id_Nguoi_Dung_Binh_Thuong) REFERENCES Nguoi_Dung_Binh_Thuong(Id_Nguoi_Dung)
);

GO

CREATE TABLE Shop_Loai (
    Id_Shop VARCHAR(10) NOT NULL,
    Loai_Shop VARCHAR(100) NOT NULL,
    PRIMARY KEY (Id_Shop, Loai_Shop),
    FOREIGN KEY (Id_Shop) REFERENCES Cua_Hang(Id_Nguoi_Dung_Binh_Thuong)
);

GO

CREATE TABLE Gio_Hang (
    Id_Gio_Hang VARCHAR(10)  NOT NULL,
    Ngay_cap_nhat DATE NOT NULL,
    PRIMARY KEY (Id_Gio_Hang)
);
GO

CREATE TABLE Khach_Hang (
    Id_Nguoi_Dung_Binh_Thuong VARCHAR(10)  NOT NULL,
    Id_Gio_Hang VARCHAR(10)  NOT NULL,
    PRIMARY KEY (Id_Nguoi_Dung_Binh_Thuong),
	FOREIGN KEY (Id_Nguoi_Dung_Binh_Thuong) REFERENCES Nguoi_Dung_Binh_Thuong(Id_Nguoi_Dung),
    FOREIGN KEY (Id_Gio_Hang) REFERENCES Gio_Hang(Id_Gio_Hang)
);


GO

CREATE TABLE San_Pham (
    Id_San_Pham VARCHAR(10)  NOT NULL,
    Id_Shop VARCHAR(10)  NOT NULL,
    Ten_San_Pham VARCHAR(255) NOT NULL,
    Loai VARCHAR(50) NOT NULL,
    So_Luong_da_ban INT NOT NULL,
	San_pham_co_san_trong_kho INT NOT NULL,
    Chinh_Sach_Doi_Tra VARCHAR(MAX) NOT NULL,
    --Trang_Thai VARCHAR(50) NOT NULL,
    Gia DECIMAL(18,2) NOT NULL,
    Mau_Sac VARCHAR(50) NOT NULL,
    Kich_Co VARCHAR(50) NOT NULL,
	Trangthai Varchar(50) ,
    --So_Luong_Qua_Tang_Kem INT NOT NULL,
    PRIMARY KEY (Id_San_Pham, Id_Shop),
    FOREIGN KEY (Id_Shop) REFERENCES Cua_Hang(Id_Nguoi_Dung_Binh_Thuong)
);
GO


CREATE TABLE Hinh_Anh_San_Pham (
    Id_San_Pham VARCHAR(10)  NOT NULL,
	Id_Shop VARCHAR(10)  NOT NULL,
    Hinh_Anh VARCHAR(400) NOT NULL,--link url
    PRIMARY KEY (Id_San_Pham, Id_Shop, Hinh_Anh),
    FOREIGN KEY (Id_San_Pham, Id_Shop) REFERENCES San_Pham(Id_San_Pham, Id_Shop)
);

GO

-- Chỗ tặng kèm hơi cấn cái số lượng
CREATE TABLE Tang_Kem (
    Id_San_Pham_Mua VARCHAR(10)  NOT NULL,
    Id_San_Pham_Tang VARCHAR(10)  NOT NULL,
	Id_Shop VARCHAR(10)  NOT NULL,
    So_Luong INT NOT NULL,
    PRIMARY KEY (Id_San_Pham_Mua, Id_San_Pham_Tang, Id_Shop),
    FOREIGN KEY (Id_San_Pham_Mua, Id_Shop) REFERENCES San_Pham(Id_San_Pham, Id_Shop),
    FOREIGN KEY (Id_San_Pham_Tang, Id_Shop) REFERENCES San_Pham(Id_San_Pham, Id_Shop)
);

GO


CREATE TABLE San_Pham_Trong_Gio_Hang (
    Id_Gio_Hang VARCHAR(10)  NOT NULL,
    Id_San_Pham VARCHAR(10)  NOT NULL,
	Id_Shop VARCHAR(10)  NOT NULL,
    So_Luong_San_Pham INT NOT NULL,
    PRIMARY KEY (Id_Gio_Hang, Id_San_Pham, Id_Shop),
    FOREIGN KEY (Id_Gio_Hang) REFERENCES Gio_Hang(Id_Gio_Hang),
    FOREIGN KEY (Id_San_Pham, Id_Shop) REFERENCES San_Pham(Id_San_Pham, Id_Shop)
);
 
GO

CREATE TABLE Tai_Xe (
    Id_Tai_Xe VARCHAR(10)  NOT NULL,
    CCCD VARCHAR(50) NOT NULL,
    So_Bang_Lai VARCHAR(50) NOT NULL,
    Que_Quan VARCHAR(255) NOT NULL,
    Ho_Ten VARCHAR(100) NOT NULL,
    Ngay_Sinh DATE NOT NULL,
    Gioi_Tinh TINYINT NOT NULL,
    Phuong_Tien VARCHAR(50) NOT NULL,
    PRIMARY KEY (Id_Tai_Xe)
);

GO

CREATE TABLE Don_Hang (
    Id_Don_Hang VARCHAR(10)  NOT NULL,
    Id_Tai_Xe VARCHAR(10)  NOT NULL,
    Id_Khach_Hang VARCHAR(10)  NOT NULL,
    Thoi_Gian_Van_Chuyen TIME NOT NULL,
    Phi_Van_Chuyen DECIMAL(18,2) NOT NULL,
    Dia_Chi_Giao_Hang VARCHAR(MAX) NOT NULL,
    Trang_Thai_Don_Hang VARCHAR(50) NOT NULL,
    PRIMARY KEY (Id_Don_Hang),
    FOREIGN KEY (Id_Tai_Xe) REFERENCES Tai_Xe(Id_Tai_Xe),
    FOREIGN KEY (Id_Khach_Hang) REFERENCES Nguoi_Dung_Binh_Thuong(Id_Nguoi_Dung)
);

GO

CREATE TABLE San_Pham_Trong_Don_Hang (
    Id_Don_Hang VARCHAR(10)  NOT NULL,
    Id_San_Pham VARCHAR(10)  NOT NULL,
	Id_Shop VARCHAR(10)  NOT NULL,
    So_Luong_San_Pham INT NOT NULL,
    Gia_Luc_Dat DECIMAL(18,2) NOT NULL,
    PRIMARY KEY (Id_Don_Hang, Id_San_Pham, Id_Shop),
    FOREIGN KEY (Id_Don_Hang) REFERENCES Don_Hang(Id_Don_Hang),
    FOREIGN KEY (Id_San_Pham, Id_Shop) REFERENCES San_Pham(Id_San_Pham, Id_Shop)
);

GO


CREATE TABLE Goi (
    Id_Khach_Hang VARCHAR(10)  NOT NULL,
    Id_San_Pham VARCHAR(10)  NOT NULL,
	Id_Don_Hang VARCHAR(10)  NOT NULL,
	Id_Shop VARCHAR(10)  NOT NULL,
    Loi_Phan_Hoi TEXT NOT NULL,
    So_Sao INT NOT NULL,
    Ngay_Phan_Hoi DATE NOT NULL,
    PRIMARY KEY (Id_Khach_Hang, Id_San_Pham, Id_Shop),
    FOREIGN KEY (Id_Khach_Hang) REFERENCES Khach_Hang(Id_Nguoi_Dung_Binh_Thuong),
    FOREIGN KEY (Id_San_Pham, Id_Shop) REFERENCES San_Pham(Id_San_Pham, Id_Shop),
	FOREIGN KEY (Id_Don_Hang) REFERENCES Don_Hang(Id_Don_Hang)
);

GO


-- Viết trigger để tính tổng tiền, mock data hiện đang tính bằng query có SUM
CREATE TABLE Hoa_Don (
    Id_Hoa_Don VARCHAR(10)  NOT NULL,
    Id_Don_Hang VARCHAR(10)  NOT NULL,
    Tong_Tien DECIMAL(18,2) NOT NULL,
    Ngay_Giao_Dich DATE NOT NULL,
    Tinh_Trang_Thanh_Toan NVARCHAR(50) NOT NULL,
    Phuong_Thuc_Thanh_Toan NVARCHAR(50) NOT NULL,
    PRIMARY KEY (Id_Hoa_Don),
    FOREIGN KEY (Id_Don_Hang) REFERENCES Don_Hang(Id_Don_Hang)
);

GO

CREATE TABLE Danh_Gia_Nhan_Vien_Giao_Hang (
    Id_Khach_Hang VARCHAR(10)  NOT NULL,
    Id_Tai_Xe VARCHAR(10) NOT NULL,
    So_Sao INT NOT NULL, -- Giá trị từ 1 đến 5 sao
    Ngay_Danh_Gia DATE NOT NULL,
    PRIMARY KEY (Id_Khach_Hang, Id_Tai_Xe, Ngay_Danh_Gia),
    FOREIGN KEY (Id_Khach_Hang) REFERENCES Nguoi_Dung_Binh_Thuong(Id_Nguoi_Dung),
    FOREIGN KEY (Id_Tai_Xe) REFERENCES Tai_Xe(Id_Tai_Xe)
);


GO


CREATE TABLE Phieu_Giam_Gia (
    Id_Phieu_Giam_Gia VARCHAR(10)  NOT NULL,
    Id_Cua_Hang VARCHAR(10) NOT NULL,
    Id_Nguoi_Quan_Ly VARCHAR(10)  NOT NULL,
    So_Luong_Quan_Li_Cap INT NOT NULL,
    So_Luong_Shop_Cap INT NOT NULL,
    Gia_Tri_Giam_Gia DECIMAL(18,2) NOT NULL,
    Ten_Ma_Giam_Gia VARCHAR(100) NOT NULL,
    Ngay_Bat_Dau DATE NOT NULL,
    Ngay_Het_Han DATE NOT NULL,
    Phan_Tram_Giam_Gia INT NOT NULL,
	Loai_Ma_Giam_Gia VARCHAR(100) NOT NULL,
    PRIMARY KEY (Id_Phieu_Giam_Gia),
    FOREIGN KEY (Id_Cua_Hang) REFERENCES Cua_Hang(Id_Nguoi_Dung_Binh_Thuong),
    FOREIGN KEY (Id_Nguoi_Quan_Ly) REFERENCES Nha_Dieu_Hanh(Id_Nha_Dieu_Hanh)
);

GO

CREATE TABLE Ap_Dung (
    Id_Phieu_Giam_Gia VARCHAR(10)  NOT NULL,
    Id_Don_Hang VARCHAR(10)  NOT NULL,
    PRIMARY KEY (Id_Phieu_Giam_Gia, Id_Don_Hang),
    FOREIGN KEY (Id_Phieu_Giam_Gia) REFERENCES Phieu_Giam_Gia(Id_Phieu_Giam_Gia),
    FOREIGN KEY (Id_Don_Hang) REFERENCES Don_Hang(Id_Don_Hang)
);

GO


/*1 Điểm đánh giá sản phẩm khi khách hàng mua sẽ từ 0 đến 5 sao (0 ≤ x ≤ 5), khách hàng chỉ có thể
đánh giá sản phẩm đã mua và mỗi lần mua chỉ được đánh giá 1 lần duy nhất */
ALTER TABLE Goi
ADD CONSTRAINT CK_Goi_So_Sao CHECK (So_Sao >= 0 AND So_Sao <= 5);

ALTER TABLE Goi
ADD CONSTRAINT UQ_Goi UNIQUE (Id_Khach_Hang, Id_San_Pham, Id_Don_Hang);

GO
CREATE TRIGGER TR_Goi_Insert
ON Goi
INSTEAD OF INSERT
AS
BEGIN
    SET NOCOUNT ON;

    -- Kiểm tra xem khách hàng có mua sản phẩm này trong đơn hàng này không
    IF EXISTS (
        SELECT 1
        FROM Inserted i
        LEFT JOIN Don_Hang dh ON i.Id_Don_Hang = dh.Id_Don_Hang
        LEFT JOIN San_Pham_Trong_Don_Hang spdh ON i.Id_Don_Hang = spdh.Id_Don_Hang AND i.Id_San_Pham = spdh.Id_San_Pham
        WHERE dh.Id_Khach_Hang <> i.Id_Khach_Hang OR spdh.Id_San_Pham IS NULL
    )
    BEGIN
        RAISERROR(N'Bạn chỉ có thể đánh giá sản phẩm đã mua', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END

    -- Chèn dữ liệu nếu vượt qua kiểm tra
    INSERT INTO Goi (Id_Khach_Hang, Id_San_Pham, Id_Don_Hang, Id_Shop, Loi_Phan_Hoi, So_Sao, Ngay_Phan_Hoi)
    SELECT Id_Khach_Hang, Id_San_Pham, Id_Don_Hang, Id_Shop, Loi_Phan_Hoi, So_Sao, Ngay_Phan_Hoi
    FROM Inserted;
END


/*3 Chỉ được áp dụng tối đa 4 loại voucher cho từng loại đơn hàng.    */
GO
CREATE TRIGGER trg_ApDung_Insert_Update
ON Ap_Dung
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    -- Kiểm tra số lượng phiếu giảm giá áp dụng cho từng đơn hàng
    IF EXISTS (
        SELECT Id_Don_Hang
        FROM (
            -- Lấy danh sách các đơn hàng bị ảnh hưởng
            SELECT Id_Don_Hang
            FROM Inserted
            UNION
            SELECT Id_Don_Hang
            FROM Deleted
        ) AS dh
        CROSS APPLY (
            -- Đếm tổng số phiếu giảm giá áp dụng cho từng đơn hàng
            SELECT COUNT(*) AS So_Luong_PGG
            FROM Ap_Dung
            WHERE Id_Don_Hang = dh.Id_Don_Hang
        ) AS pgg
        WHERE pgg.So_Luong_PGG > 4
    )
    BEGIN
        RAISERROR(N'Chỉ được áp dụng tối đa 4 phiếu', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END
END
GO
/*4 ID ban đầu chỉ có 10 ký tự ngẫu nhiên gồm số và chữ*/
ALTER TABLE Nha_Dieu_Hanh
ADD CONSTRAINT CK_Nha_Dieu_Hanh_Id_Format
CHECK (
    LEN(Id_Nha_Dieu_Hanh) = 10 AND
    Id_Nha_Dieu_Hanh LIKE '%[A-Za-z]%' AND
    Id_Nha_Dieu_Hanh LIKE '%[0-9]%' AND
    Id_Nha_Dieu_Hanh NOT LIKE '%[^A-Za-z0-9]%'
);

GO
ALTER TABLE Nguoi_Dung_Binh_Thuong
ADD CONSTRAINT CK_Nguoi_Dung_Id_Format
CHECK (
    LEN(Id_Nguoi_Dung) = 9 AND
    Id_Nguoi_Dung LIKE '%[A-Za-z]%' AND
    Id_Nguoi_Dung LIKE '%[0-9]%' AND
    Id_Nguoi_Dung NOT LIKE '%[^A-Za-z0-9]%'
);
GO

ALTER TABLE Cua_Hang
ADD CONSTRAINT CK_Nguoi_Dung_Binh_Thuong_Id_Format
CHECK (
    LEN(Id_Nguoi_Dung_Binh_Thuong) = 9 AND
    Id_Nguoi_Dung_Binh_Thuong LIKE '%[A-Za-z]%' AND
    Id_Nguoi_Dung_Binh_Thuong LIKE '%[0-9]%' AND
    Id_Nguoi_Dung_Binh_Thuong NOT LIKE '%[^A-Za-z0-9]%'
);


GO
INSERT INTO Nha_Dieu_Hanh (Id_Nha_Dieu_Hanh, CCCD, Ngay_Sinh, Ten_Dang_Nhap, Ngay_Tao, Ho, Ten, Email, Gioi_Tinh, Dia_Chi, Sdt, Mat_Khau, Vai_Tro)
VALUES
('NDH0000001', 'CCCD0001', '1985-01-15', 'admin01', '2024-01-01', 'Nguyen', 'Anh', 'admin01@example.com', 1, '123 Le Loi, Hanoi, Vietnam', '0912345678', 'pass12345', 'Admin'),
('NDH0000002', 'CCCD0002', '1990-02-20', 'admin02', '2024-02-01', 'Tran', 'Binh', 'admin02@example.com', 0, '456 Nguyen Trai, Da Nang, Vietnam', '0923456789', 'pass54321', 'Admin'),
('NDH0000003', 'CCCD0003', '1988-03-25', 'admin03', '2024-03-01', 'Le', 'Hoa', 'admin03@example.com', 1, '789 Hoang Sa, Ho Chi Minh City, Vietnam', '0934567890', 'pass67890', 'Admin'),
('NDH0000004', 'CCCD0004', '1992-04-10', 'admin04', '2024-04-01', 'Pham', 'Lan', 'admin04@example.com', 0, '101 Tran Hung Dao, Hai Phong, Vietnam', '0945678901', 'pass09876', 'Admin'),
('NDH0000005', 'CCCD0005', '1987-05-15', 'admin05', '2024-05-01', 'Hoang', 'Minh', 'admin05@example.com', 1, '123 Minh Khai, Hanoi, Vietnam', '0956789012', 'pass34567', 'Admin');


GO
-- Insert mock data into Nguoi_Dung_Binh_Thuong
-- 5 records đầu là CỬA HÀNG, 5 records sau là KHÁCH HÀNG
INSERT INTO Nguoi_Dung_Binh_Thuong (Id_Nguoi_Dung, CCCD, Ngay_Sinh, Ten_Dang_Nhap, Ngay_Tao, Ho, Ten, Email, Gioi_Tinh, Dia_Chi, Sdt, Mat_Khau, Vai_tro_nguoi_dung)
VALUES
('ND0000001', 'CCCD1001', '1995-01-12', 'user01', '2024-01-10', 'Nguyen', 'An', 'user01@example.com', 1, '123 Nguyen Hue, Hanoi, Vietnam', '0911111111', 'password123', 0), -- Cua_Hang
('ND0000002', 'CCCD1002', '1992-02-24', 'user02', '2024-01-15', 'Tran', 'Binh', 'user02@example.com', 0, '456 Le Loi, Da Nang, Vietnam', '0922222222', 'password234', 0), -- Cua_Hang
('ND0000003', 'CCCD1003', '1998-03-30', 'user03', '2024-01-20', 'Le', 'Cam', 'user03@example.com', 1, '789 Nguyen Trai, Ho Chi Minh City, Vietnam', '0933333333', 'password345', 0), -- Cua_Hang
('ND0000004', 'CCCD1004', '1990-04-18', 'user04', '2024-01-25', 'Pham', 'Duong', 'user04@example.com', 0, '101 Hoang Hoa Tham, Hai Phong, Vietnam', '0944444444', 'password456', 0), -- Cua_Hang
('ND0000005', 'CCCD1005', '1993-05-12', 'user05', '2024-01-30', 'Hoang', 'Minh', 'user05@example.com', 1, '123 Phan Dinh Phung, Hanoi, Vietnam', '0955555555', 'password567', 0), -- Cua_Hang
('ND0000006', 'CCCD1006', '1997-06-15', 'user06', '2024-02-01', 'Vu', 'Ngoc', 'user06@example.com', 0, '456 Tran Phu, Da Nang, Vietnam', '0966666666', 'password678', 1), -- Khach_Hang
('ND0000007', 'CCCD1007', '1996-07-10', 'user07', '2024-02-05', 'Nguyen', 'Phuong', 'user07@example.com', 1, '789 Le Thanh Ton, Ho Chi Minh City, Vietnam', '0977777777', 'password789', 1), -- Khach_Hang
('ND0000008', 'CCCD1008', '1991-08-25', 'user08', '2024-02-10', 'Truong', 'Son', 'user08@example.com', 0, '101 Hai Ba Trung, Hai Phong, Vietnam', '0988888888', 'password890', 1), -- Khach_Hang
('ND0000009', 'CCCD1009', '1994-09-20', 'user09', '2024-02-15', 'Phan', 'Thanh', 'user09@example.com', 1, '123 Bach Dang, Hanoi, Vietnam', '0999999999', 'password901', 1), -- Khach_Hang
('ND0000010', 'CCCD1010', '1999-10-10', 'user10', '2024-02-20', 'Nguyen', 'Khoa', 'user10@example.com', 0, '456 Vo Nguyen Giap, Da Nang, Vietnam', '0900000000', 'password012', 1), -- Khach_Hang
('ND0000011', 'CCCD1011', '1999-10-10', 'user11', '2024-02-20', 'Nguyen', 'Khoa', 'user11@example.com', 0, '456 Vo Nguyen Giap, Da Nang, Vietnam', '0900003000', 'password013', 1); -- Khach_Hang
GO

-- Insert mock data into Cua_Hang (limited to 5 records)
INSERT INTO Cua_Hang (Id_Nguoi_Dung_Binh_Thuong, Ngay_Thanh_Lap, Dia_Chi_Shop, Ten_Cua_Shop, So_Dien_Thoai, Giay_Phep_Kinh_Doanh)
VALUES
('ND0000001', '2021-03-15', '123 Nguyen Hue, Hanoi, Vietnam', 'Shop An Phat', '0911111111', 'GP1001'),
('ND0000002', '2020-05-20', '456 Le Loi, Da Nang, Vietnam', 'Binh Minh Store', '0922222222', 'GP1002'),
('ND0000003', '2019-07-10', '789 Nguyen Trai, Ho Chi Minh City, Vietnam', 'Cam Shop', '0933333333', 'GP1003'),
('ND0000004', '2022-01-05', '101 Hoang Hoa Tham, Hai Phong, Vietnam', 'Duong Fashion', '0944444444', 'GP1004'),
('ND0000005', '2018-09-12', '123 Phan Dinh Phung, Hanoi, Vietnam', 'Minh Mart', '0955555555', 'GP1005');
GO

INSERT INTO Shop_Loai (Id_Shop, Loai_Shop)
VALUES
('ND0000001', 'Electronics'),
('ND0000001', 'Appliances'),
('ND0000002', 'Clothing'),
('ND0000003', 'Beauty Products'),
('ND0000004', 'Fashion Accessories'),
('ND0000004', 'Footwear'),
('ND0000005', 'Groceries'),
('ND0000005', 'Home Essentials');
GO
INSERT INTO Gio_Hang (Id_Gio_Hang, Ngay_cap_nhat)
VALUES
    ('GH0000006', '2024-11-01'),
    ('GH0000007', '2024-11-02'),
    ('GH0000008', '2024-11-03'),
    ('GH0000009', '2024-11-04'),
    ('GH0000010', '2024-11-05'),
	('GH0000011', '2024-11-01');
GO
INSERT INTO Khach_Hang (Id_Nguoi_Dung_Binh_Thuong, Id_Gio_Hang)
VALUES
	
    ('ND0000006', 'GH0000006'),
    ('ND0000007', 'GH0000007'),
    ('ND0000008', 'GH0000008'),
    ('ND0000009', 'GH0000009'),
    ('ND0000010', 'GH0000010'),
	('ND0000011', 'GH0000011');


GO
INSERT INTO San_Pham (Id_San_Pham, Id_Shop, Ten_San_Pham, Loai, So_Luong_da_ban, San_pham_co_san_trong_kho, Chinh_Sach_Doi_Tra, Gia, Mau_Sac, Kich_Co,Trangthai)
VALUES
    -- Shop 1 (Id_Shop = ND0000001)
    ('SP0000001', 'ND0000001', 'T-Shirt Classic', 'Clothing', 120, 80, 'Return within 7 days', 199.99, 'Red', 'M',Null),
    ('SP0000002', 'ND0000001', 'Hoodie Comfort', 'Clothing', 200, 50, 'Exchange only within 10 days', 299.99, 'Blue', 'L', null),
    
    -- Shop 2 (Id_Shop = ND0000002)
    ('SP0000001', 'ND0000002', 'Wireless Headphones', 'Electronics', 300, 150, '1-year warranty, no returns', 1499.99, 'Black', 'One Size',null),
    ('SP0000002', 'ND0000002', 'Bluetooth Speaker', 'Electronics', 150, 80, '30-day return policy', 799.99, 'Gray', 'One Size',null),
    
    -- Shop 3 (Id_Shop = ND0000003)
    ('SP0000001', 'ND0000003', 'Yoga Mat', 'Fitness', 400, 200, 'Return within 15 days', 399.99, 'Green', 'Standard',null),
    ('SP0000002', 'ND0000003', 'Resistance Bands', 'Fitness', 100, 300, 'No returns or exchanges', 99.99, 'Yellow', 'Medium',null),
    
    -- Shop 4 (Id_Shop = ND0000004)
    ('SP0000001', 'ND0000004', 'Organic Honey', 'Food', 250, 100, 'Return within 3 days if unopened', 249.99, 'Amber', '500g',null),
    ('SP0000002', 'ND0000004', 'Almond Butter', 'Food', 180, 120, 'Return within 3 days if unopened', 299.99, 'Brown', '250g',null),
    
    -- Shop 5 (Id_Shop = ND0000005)
    ('SP0000001', 'ND0000005', 'Running Shoes', 'Footwear', 500, 80, 'Exchange within 7 days', 899.99, 'Gray', '42',null),
    ('SP0000002', 'ND0000005', 'Flip Flops', 'Footwear', 400, 150, 'No returns', 99.99, 'Blue', '40',null);
GO
INSERT INTO Hinh_Anh_San_Pham (Id_San_Pham, Id_Shop, Hinh_Anh)
VALUES
    -- Shop 1 (Id_Shop = ND0000001)
    ('SP0000001', 'ND0000001', 'https://example.com/images/SP0000001_image1.jpg'),
    ('SP0000002', 'ND0000001', 'https://example.com/images/SP0000002_image1.jpg'),
    
    -- Shop 2 (Id_Shop = ND0000002)
    ('SP0000001', 'ND0000002', 'https://example.com/images/SP0000001_image2.jpg'),
    ('SP0000002', 'ND0000002', 'https://example.com/images/SP0000002_image2.jpg'),
    
    -- Shop 3 (Id_Shop = ND0000003)
    ('SP0000001', 'ND0000003', 'https://example.com/images/SP0000001_image3.jpg'),
    ('SP0000002', 'ND0000003', 'https://example.com/images/SP0000002_image3.jpg'),
    
    -- Shop 4 (Id_Shop = ND0000004)
    ('SP0000001', 'ND0000004', 'https://example.com/images/SP0000001_image4.jpg'),
    ('SP0000002', 'ND0000004', 'https://example.com/images/SP0000002_image4.jpg'),
    
    -- Shop 5 (Id_Shop = ND0000005)
    ('SP0000001', 'ND0000005', 'https://example.com/images/SP0000001_image5.jpg'),
    ('SP0000002', 'ND0000005', 'https://example.com/images/SP0000002_image5.jpg');
GO
INSERT INTO Tang_Kem (Id_San_Pham_Mua, Id_San_Pham_Tang, Id_Shop, So_Luong)
VALUES
    -- Shop 1 (Id_Shop = ND0000001)
    ('SP0000001', 'SP0000002', 'ND0000001', 1), -- Buy SP0000001, get SP0000002 as a gift
    ('SP0000002', 'SP0000001', 'ND0000001', 1), -- Buy SP0000002, get SP0000001 as a gift

    -- Shop 2 (Id_Shop = ND0000002)
    ('SP0000001', 'SP0000002', 'ND0000002', 1), -- Buy SP0000001, get SP0000002 as a gift
    ('SP0000002', 'SP0000001', 'ND0000002', 1), -- Buy SP0000002, get SP0000001 as a gift

    -- Shop 3 (Id_Shop = ND0000003)
    ('SP0000001', 'SP0000002', 'ND0000003', 1), -- Buy SP0000001, get SP0000002 as a gift
    ('SP0000002', 'SP0000001', 'ND0000003', 1), -- Buy SP0000002, get SP0000001 as a gift

    -- Shop 4 (Id_Shop = ND0000004)
    ('SP0000001', 'SP0000002', 'ND0000004', 1), -- Buy SP0000001, get SP0000002 as a gift
    ('SP0000002', 'SP0000001', 'ND0000004', 1), -- Buy SP0000002, get SP0000001 as a gift

    -- Shop 5 (Id_Shop = ND0000005)
    ('SP0000001', 'SP0000002', 'ND0000005', 1), -- Buy SP0000001, get SP0000002 as a gift
    ('SP0000002', 'SP0000001', 'ND0000005', 1); -- Buy SP0000002, get SP0000001 as a gift

GO
INSERT INTO San_Pham_Trong_Gio_Hang (Id_Gio_Hang, Id_San_Pham, Id_Shop, So_Luong_San_Pham)
VALUES
    -- Customer 1 (Id_Gio_Hang = GH0000001)
    ('GH0000006', 'SP0000001', 'ND0000001', 2), -- Customer 1 adds 2 of SP0000001 from Shop 1
    ('GH0000006', 'SP0000002', 'ND0000001', 1); -- Customer 1 adds 1 of SP0000002 from Shop 1
GO
INSERT INTO San_Pham_Trong_Gio_Hang (Id_Gio_Hang, Id_San_Pham, Id_Shop, So_Luong_San_Pham)
VALUES
	    -- Customer 2 (Id_Gio_Hang = GH0000002)
    ('GH0000007', 'SP0000001', 'ND0000002', 3), -- Customer 2 adds 3 of SP0000003 from Shop 2
    ('GH0000007', 'SP0000002', 'ND0000002', 2); -- Customer 2 adds 2 of SP0000004 from Shop 2
GO
INSERT INTO San_Pham_Trong_Gio_Hang (Id_Gio_Hang, Id_San_Pham, Id_Shop, So_Luong_San_Pham)
VALUES
    -- Customer 3 (Id_Gio_Hang = GH0000003)
    ('GH0000008', 'SP0000001', 'ND0000003', 1), -- Customer 3 adds 1 of SP0000001 from Shop 3
    ('GH0000008', 'SP0000002', 'ND0000003', 2); -- Customer 3 adds 2 of SP0000002 from Shop 3
GO
INSERT INTO San_Pham_Trong_Gio_Hang (Id_Gio_Hang, Id_San_Pham, Id_Shop, So_Luong_San_Pham)
VALUES
    -- Customer 4 (Id_Gio_Hang = GH0000004)
    ('GH0000009', 'SP0000001', 'ND0000004', 1), -- Customer 4 adds 1 of SP0000005 from Shop 4
    ('GH0000009', 'SP0000002', 'ND0000004', 3); -- Customer 4 adds 3 of SP0000006 from Shop 4
GO
INSERT INTO San_Pham_Trong_Gio_Hang (Id_Gio_Hang, Id_San_Pham, Id_Shop, So_Luong_San_Pham)
VALUES
    -- Customer 5 (Id_Gio_Hang = GH0000005)
	('GH0000010', 'SP0000001', 'ND0000005', 4), -- Customer 5 adds 4 of SP0000001 from Shop 5
    ('GH0000010', 'SP0000002', 'ND0000005', 1); -- Customer 5 adds 1 of SP0000002 from Shop 5
GO   
INSERT INTO Tai_Xe (Id_Tai_Xe, CCCD, So_Bang_Lai, Que_Quan, Ho_Ten, Ngay_Sinh, Gioi_Tinh, Phuong_Tien)
VALUES
    ('TX0000001', 'CCCD123456789', 'BL123456', 'Hanoi, Vietnam', 'Nguyen Van A', '1985-03-15', 1, 'Car'),
    ('TX0000002', 'CCCD223456789', 'BL223456', 'HCMC, Vietnam', 'Tran Thi B', '1990-07-20', 0, 'Motorbike'),
    ('TX0000003', 'CCCD323456789', 'BL323456', 'Danang, Vietnam', 'Le Van C', '1988-12-01', 1, 'Truck'),
    ('TX0000004', 'CCCD423456789', 'BL423456', 'Hue, Vietnam', 'Pham Thi D', '1992-09-10', 0, 'Bicycle'),
    ('TX0000005', 'CCCD523456789', 'BL523456', 'Can Tho, Vietnam', 'Nguyen Van E', '1987-04-18', 1, 'Van'),
    ('TX0000006', 'CCCD623456789', 'BL623456', 'Haiphong, Vietnam', 'Do Thi F', '1995-11-25', 0, 'Motorbike'),
    ('TX0000007', 'CCCD723456789', 'BL723456', 'Quang Ninh, Vietnam', 'Hoang Van G', '1986-02-28', 1, 'Car'),
    ('TX0000008', 'CCCD823456789', 'BL823456', 'Nha Trang, Vietnam', 'Bui Thi H', '1991-06-14', 0, 'Truck'),
    ('TX0000009', 'CCCD923456789', 'BL923456', 'Vung Tau, Vietnam', 'Dang Van I', '1989-01-05', 1, 'Van'),
    ('TX0000010', 'CCCD103456789', 'BL103456', 'Bac Giang, Vietnam', 'Ngo Thi K', '1993-08-23', 0, 'Bicycle');
GO
INSERT INTO Don_Hang (Id_Don_Hang, Id_Tai_Xe, Id_Khach_Hang, Thoi_Gian_Van_Chuyen, Phi_Van_Chuyen, Dia_Chi_Giao_Hang, Trang_Thai_Don_Hang)
VALUES

('DH0000001', 'TX0000001', 'ND0000006', '02:30:00', 50000.00, '123 Nguyen Hue, Hanoi, Vietnam', 'Processing'),
('DH0000002', 'TX0000002', 'ND0000007', '01:45:00', 60000.00, '456 Le Loi, Da Nang, Vietnam', 'Shipped'),
('DH0000003', 'TX0000003', 'ND0000008', '03:00:00', 55000.00, '789 Nguyen Trai, Ho Chi Minh City, Vietnam', 'Delivered'),
('DH0000004', 'TX0000004', 'ND0000009', '01:20:00', 45000.00, '101 Hoang Hoa Tham, Hai Phong, Vietnam', 'Cancelled'),
('DH0000005', 'TX0000005', 'ND0000010', '02:15:00', 65000.00, '123 Phan Dinh Phung, Hanoi, Vietnam', 'Processing'),
('DH0000006', 'TX0000002', 'ND0000011', '01:45:00', 60000.00, '456 Le Loi, Da Nang, Vietnam', 'Shipped');
-- Giá lúc đặt cần có trigger tính lại giá sau khi áp dụng phiếu giảm giá
-- Mock data lấy tạm giá ban đầu của cửa hàng
GO
INSERT INTO San_Pham_Trong_Don_Hang (Id_Don_Hang, Id_San_Pham, Id_Shop, So_Luong_San_Pham, Gia_Luc_Dat)
VALUES

('DH0000001', 'SP0000001', 'ND0000001', 1, 199.99),
('DH0000001', 'SP0000002', 'ND0000001', 1, 299.99),
('DH0000002', 'SP0000001', 'ND0000002', 1, 1499.99),
('DH0000002', 'SP0000002', 'ND0000002', 1, 799.99),
('DH0000003', 'SP0000001', 'ND0000003', 1, 399.99),
('DH0000003', 'SP0000002', 'ND0000003', 1, 99.99),
('DH0000004', 'SP0000001', 'ND0000004', 1, 249.99),
('DH0000004', 'SP0000002', 'ND0000004', 1, 299.99),
('DH0000005', 'SP0000001', 'ND0000005', 1, 899.99),
('DH0000005', 'SP0000002', 'ND0000005', 2, 99.99),
('DH0000006', 'SP0000002', 'ND0000005', 2, 99.99);
GO
INSERT INTO Goi (Id_Khach_Hang, Id_San_Pham, Id_Shop, Id_Don_Hang, Loi_Phan_Hoi, So_Sao, Ngay_Phan_Hoi)
VALUES
 -- Feedback for Order 5 (DH0000006)

  
    -- Feedback for Order 1 (DH0000001)
    ('ND0000006', 'SP0000001', 'ND0000001', 'DH0000001', 'Product quality was great, but delivery took too long.', 3, '2024-11-20'),
    ('ND0000006', 'SP0000002', 'ND0000001', 'DH0000001', 'Packaging was not as expected, but the product was good.', 4, '2024-11-21'),

    -- Feedback for Order 2 (DH0000002)
    ('ND0000007', 'SP0000001', 'ND0000002', 'DH0000002', 'Fast delivery and excellent customer service.', 5, '2024-11-19'),
    ('ND0000007', 'SP0000002', 'ND0000002', 'DH0000002', 'Product was as expected, very satisfied with the purchase.', 5, '2024-11-19'),

    -- Feedback for Order 3 (DH0000003)
    ('ND0000008', 'SP0000001', 'ND0000003', 'DH0000003', 'The product was good, but the price was too high.', 3, '2024-11-18'),
    ('ND0000008', 'SP0000002', 'ND0000003', 'DH0000003', 'Nice product, though it arrived later than expected.', 4, '2024-11-18'),

    -- Feedback for Order 4 (DH0000004)
    ('ND0000009', 'SP0000001', 'ND0000004', 'DH0000004', 'Not happy with the product, it did not match the description.', 2, '2024-11-17'),
    ('ND0000009', 'SP0000002', 'ND0000004', 'DH0000004', 'Poor quality, will not buy again.', 1, '2024-11-17'),

    -- Feedback for Order 5 (DH0000005)
    ('ND0000010', 'SP0000001', 'ND0000005', 'DH0000005', 'Very happy with the product, excellent value for money.', 5, '2024-11-15'),
    ('ND0000010', 'SP0000002', 'ND0000005', 'DH0000005', 'The product is fine, but the delivery was delayed.', 4, '2024-11-15'),
	('ND0000011', 'SP0000002', 'ND0000005', 'DH0000006', 'The product is fine, but the delivery was delayed.', 2, '2024-11-15');
GO
INSERT INTO Hoa_Don (Id_Hoa_Don, Id_Don_Hang, Tong_Tien, Ngay_Giao_Dich, Tinh_Trang_Thanh_Toan, Phuong_Thuc_Thanh_Toan)
VALUES
  -- For Order DH0000005
    
    -- For Order DH0000001
    ('HD0000001', 'DH0000001', 
        (SELECT SUM(Gia_Luc_Dat * So_Luong_San_Pham) 
         FROM San_Pham_Trong_Don_Hang 
         WHERE Id_Don_Hang = 'DH0000001'), 
        '2024-11-20', 'Paid', 'Credit Card'),

    -- For Order DH0000002
    ('HD0000002', 'DH0000002', 
        (SELECT SUM(Gia_Luc_Dat * So_Luong_San_Pham) 
         FROM San_Pham_Trong_Don_Hang 
         WHERE Id_Don_Hang = 'DH0000002'), 
        '2024-11-19', 'Paid', 'Bank Transfer'),

    -- For Order DH0000003
    ('HD0000003', 'DH0000003', 
        (SELECT SUM(Gia_Luc_Dat * So_Luong_San_Pham) 
         FROM San_Pham_Trong_Don_Hang 
         WHERE Id_Don_Hang = 'DH0000003'), 
        '2024-11-18', 'Paid', 'PayPal'),

    -- For Order DH0000004
    ('HD0000004', 'DH0000004', 
        (SELECT SUM(Gia_Luc_Dat * So_Luong_San_Pham) 
         FROM San_Pham_Trong_Don_Hang 
         WHERE Id_Don_Hang = 'DH0000004'), 
        '2024-11-17', 'Paid', 'Credit Card'),

    -- For Order DH0000005
    ('HD0000005', 'DH0000005', 
        (SELECT SUM(Gia_Luc_Dat * So_Luong_San_Pham) 
         FROM San_Pham_Trong_Don_Hang 
         WHERE Id_Don_Hang = 'DH0000005'), 
        '2024-11-15', 'Paid', 'Cash on Delivery'),
		('HD0000006', 'DH0000006', 
        (SELECT SUM(Gia_Luc_Dat * So_Luong_San_Pham) 
         FROM San_Pham_Trong_Don_Hang 
         WHERE Id_Don_Hang = 'DH0000006'), 
        '2024-11-15', 'Paid', 'Cash on Delivery');
-- Chỉ có KHÁCH HÀNG mới đánh giá
-- Insert mock data into Danh_Gia_Nhan_Vien_Giao_Hang table (for users ND0000006 to ND0000010)

GO
INSERT INTO Danh_Gia_Nhan_Vien_Giao_Hang (Id_Khach_Hang, Id_Tai_Xe, So_Sao, Ngay_Danh_Gia)
VALUES
    ('ND0000006', 'TX0000001', 5, '2024-11-20'), -- Customer ND0000006 rates driver TX0000001 with 5 stars
    ('ND0000007', 'TX0000002', 4, '2024-11-18'), -- Customer ND0000007 rates driver TX0000002 with 4 stars
    ('ND0000008', 'TX0000003', 3, '2024-11-17'), -- Customer ND0000008 rates driver TX0000003 with 3 stars
    ('ND0000009', 'TX0000004', 5, '2024-11-15'), -- Customer ND0000009 rates driver TX0000004 with 5 stars
    ('ND0000010', 'TX0000005', 2, '2024-11-14'); -- Customer ND0000010 rates driver TX0000005 with 2 stars
-- Insert mock data into Phieu_Giam_Gia table with the new Loai_Ma_Giam_Gia attribute
-- Cái này chắc làm thêm cái trigger để kiểm tra xem cái loại phiếu giảm giá có khớp với cái loại sản phẩm

GO
INSERT INTO Phieu_Giam_Gia (Id_Phieu_Giam_Gia, Id_Cua_Hang, Id_Nguoi_Quan_Ly, So_Luong_Quan_Li_Cap, So_Luong_Shop_Cap, Gia_Tri_Giam_Gia, Ten_Ma_Giam_Gia, Ngay_Bat_Dau, Ngay_Het_Han, Phan_Tram_Giam_Gia, Loai_Ma_Giam_Gia)
VALUES
    ('PGG0000001', 'ND0000001', 'NDH0000001', 100, 500, 500000.00, 'SUMMER20', '2024-06-01', '2024-06-30', 20, 'Electronics'), -- Electronics category discount (20% off)
    ('PGG0000002', 'ND0000002', 'NDH0000001', 150, 1000, 1000000.00, 'WINTER30', '2024-12-01', '2024-12-31', 30, 'Clothing'), -- Clothing category discount (30% off)
    ('PGG0000003', 'ND0000003', 'NDH0000002', 200, 1200, 750000.00, 'FESTIVE15', '2024-11-01', '2024-11-15', 15, 'Furniture'), -- Furniture category discount (15% off)
    ('PGG0000004', 'ND0000004', 'NDH0000002', 50, 250, 250000.00, 'NEWYEAR10', '2025-01-01', '2025-01-15', 10, 'Home Appliances'), -- Home Appliances category discount (10% off)
    ('PGG0000005', 'ND0000005', 'NDH0000003', 120, 800, 400000.00, 'SPRING25', '2024-03-01', '2024-03-31', 25, 'Books'), -- Books category discount (25% off)
    ('PGG0000006', 'ND0000001', 'NDH0000003', 50, 250, 100000.00, 'FLASH50', '2024-07-01', '2024-07-07', 0, 'Electronics'), -- Flash Sale for Electronics category (fixed amount off)
    ('PGG0000007', 'ND0000002', 'NDH0000003', 300, 1500, 1500000.00, 'BOGO', '2024-12-01', '2024-12-15', 0, 'Clothing'); -- Buy-one-get-one-free offer for Clothing


GO
-- Bảng Áp dụng nhưng mà chưa có trigger áp giảm giá lên đơn hàng
INSERT INTO Ap_Dung (Id_Phieu_Giam_Gia, Id_Don_Hang)
VALUES
    ('PGG0000001', 'DH0000001'), -- Discount 'SUMMER20' applied to order 'DH0000001'
    ('PGG0000002', 'DH0000002'), -- Discount 'WINTER30' applied to order 'DH0000002'
    ('PGG0000003', 'DH0000003'), -- Discount 'FESTIVE15' applied to order 'DH0000003'
    ('PGG0000004', 'DH0000004'), -- Discount 'NEWYEAR10' applied to order 'DH0000004'
    ('PGG0000005', 'DH0000005'), -- Discount 'SPRING25' applied to order 'DH0000005'
    ('PGG0000006', 'DH0000001'), -- Discount 'FLASH50' applied to order 'DH0000001'
    ('PGG0000007', 'DH0000002'); -- Discount 'BOGO' applied to order 'DH0000002'

GO
--------------------------KIET---------------------------------------------------------------
-----------------TRIGGER 2.2 
-----------------TRIGGER 2.2.1 TÍNH TOÁN TỔNG GIÁ TRỊ CỦA ĐƠN HÀNG (DẪN XUẤT) SAU MỖI LẦN INSERT /UPDATE /DELETE hàng hóa vào Giỏ hàng
-------------------------------TRigger ở bảng San_Pham_Trong_Gio_Hang
CREATE TRIGGER update_cart_total_price
ON San_Pham_Trong_Gio_Hang
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    DECLARE @new_total_price DECIMAL(10, 2);
    DECLARE @Id_Gio_Hang VARCHAR(10);

    -- Lấy Id_Gio_Hang từ bảng inserted (trường hợp INSERT và UPDATE)
    IF EXISTS (SELECT 1 FROM inserted)
    BEGIN
        SELECT @Id_Gio_Hang = Id_Gio_Hang FROM inserted;
    END
    -- Lấy Id_Gio_Hang từ bảng deleted (trường hợp DELETE)
    ELSE IF EXISTS (SELECT 1 FROM deleted)
    BEGIN
        SELECT @Id_Gio_Hang = Id_Gio_Hang FROM deleted;
    END

    -- Tính tổng giá trị giỏ hàng sau khi thay đổi
    SELECT @new_total_price = SUM(sp.Gia * sph.So_Luong_San_Pham)
    FROM San_Pham_Trong_Gio_Hang sph
    JOIN San_Pham sp ON sph.Id_San_Pham = sp.Id_San_Pham AND sph.Id_Shop = sp.Id_Shop
    WHERE sph.Id_Gio_Hang = @Id_Gio_Hang;

    -- Trả về kết quả tổng giá trị của giỏ hàng (Total_Price) cho yêu cầu
    SELECT @Id_Gio_Hang AS Id_Gio_Hang, @new_total_price AS Total_Price;
END;
				

----------------------KIET --------------------------------------------------------------------------------------------------
-----------------TRIGGER 2.2.2 KIỂM TRA SỐ LƯỢNG HÀNG HÓA CỦA SP A THÊM VÀO GIỎ HÀNG CÓ BỊ VƯỢT NGƯỠNG TỒN KHO KO, CÓ QUĂNG LỖI 
-------------------------------TRigger ở bảng San_Pham_Trong_Gio_Hang
GO
CREATE TRIGGER trgg_Validate_Gio_Hang
ON San_Pham_Trong_Gio_Hang
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;

    -- Kiểm tra số lượng sản phẩm hợp lệ (không vượt quá tồn kho)
    IF EXISTS (
        SELECT 1
        FROM San_Pham SP
        JOIN INSERTED I 
            ON SP.Id_San_Pham = I.Id_San_Pham AND SP.Id_Shop = I.Id_Shop
        WHERE I.So_Luong_San_Pham > SP.San_pham_co_san_trong_kho 
    )
    BEGIN
        RAISERROR ('Số lượng sản phẩm vượt quá tồn kho!', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END;
END;
---------------TAO VIEW Để CHECK----------------------------------------
GO
CREATE VIEW v1_Gio_Hang_Tong_Gia_Tri AS
SELECT 
    GH.Id_Gio_Hang,
    SUM(SP.Gia * SPGH.So_Luong_San_Pham) AS Tong_Gia_Tri
FROM 
    Gio_Hang GH
LEFT JOIN 
    San_Pham_Trong_Gio_Hang SPGH ON GH.Id_Gio_Hang = SPGH.Id_Gio_Hang
LEFT JOIN 
    San_Pham SP ON SPGH.Id_San_Pham = SP.Id_San_Pham AND SPGH.Id_Shop = SP.Id_Shop
GROUP BY 
    GH.Id_Gio_Hang;


-------TEST ----TRIGGER 2.2.1 VA 2.2.2-------------------

---INSERT INTO San_Pham (Id_San_Pham, Id_Shop, Ten_San_Pham, Loai, So_Luong_da_ban, San_pham_co_san_trong_kho, Chinh_Sach_Doi_Tra, Gia, Mau_Sac, Kich_Co)
--VALUES
    -- Shop 1 (Id_Shop = ND0000001)
    --('SP0000005', 'ND0000001', 'T-Shirt KOREA', 'Clothing', 120, 80, 'Return within 7 days', 199.99, 'Red', 'M');

GO
SELECT * FROM v1_Gio_Hang_Tong_Gia_Tri;
GO
--DELETE FROM San_Pham_Trong_Gio_Hang
--WHERE Id_Gio_Hang = 'GH0000006' AND Id_San_Pham = 'SP0000005';

UPDATE San_Pham_Trong_Gio_Hang
SET So_Luong_San_Pham = 5
WHERE Id_Gio_Hang = 'GH0000011' AND Id_San_Pham = 'SP0000002';


--INSERT INTO San_Pham_Trong_Gio_Hang 
--VALUES
--('GH0000011', 'SP0000002', 'ND0000005', 20)-- Customer 1 adds 2 of SP0000001 from Shop 1

GO


--------------------------Thủ tục 2.1----------------------------------

--Tạo thủ tục kiểm tra tính validate của dữ liệu cần bổ sung.---Không trùng khóa chính và đảm bảo toàn vẹn tham chiếu
-----------Khi insert ---Kiểm tra có trùng MSP đã có hay không
DROP PROCEDURE IF EXISTS InsertSanPham; 
GO
CREATE PROCEDURE InsertSanPham
    @Id_San_Pham NVARCHAR(10),
    @Id_Shop NVARCHAR(10),
    @Ten_San_Pham NVARCHAR(255),
    @Loai NVARCHAR(50),
    @So_Luong_da_ban INT,
    @San_pham_co_san_trong_kho INT,
    @Chinh_Sach_Doi_Tra NVARCHAR(MAX),
    @Gia DECIMAL(18, 2),
    @Mau_Sac NVARCHAR(50),
    @Kich_Co NVARCHAR(50),
	@Anh VARCHAR(400)
AS
BEGIN
    BEGIN TRY
        -- Kiểm tra các trường NULL hoặc không hợp lệ
        IF @Id_San_Pham IS NULL OR LEN(@Id_San_Pham) = 0
        BEGIN
            RAISERROR ('Lỗi: Mã sản phẩm không được để trống.', 16, 1);
            RETURN;
        END; 

        IF @Id_Shop IS NULL OR LEN(@Id_Shop) = 0
        BEGIN
            RAISERROR ('Lỗi: Mã cửa hàng không được để trống.', 16, 1);
            RETURN;
        END;

        IF @Ten_San_Pham IS NULL OR LEN(@Ten_San_Pham) = 0
        BEGIN
            RAISERROR ('Lỗi: Tên sản phẩm không được để trống.', 16, 1);
            RETURN;
        END;

		IF @Anh IS NULL OR LEN(@Anh) = 0
        BEGIN
            RAISERROR ('Lỗi: Phải có ít nhất 1 ảnh của Sản phẩm', 16, 1);
            RETURN;
        END;

        IF @Loai IS NULL OR LEN(@Loai) = 0
        BEGIN
            RAISERROR ('Lỗi: Loại sản phẩm không được để trống.', 16, 1);
            RETURN;
        END;

        IF @So_Luong_da_ban IS NULL OR @So_Luong_da_ban < 0
        BEGIN
            RAISERROR ('Lỗi: Số lượng đã bán phải lớn hơn hoặc bằng 0.', 16, 1);
            RETURN;
        END;

        IF @San_pham_co_san_trong_kho IS NULL OR @San_pham_co_san_trong_kho < 0
        BEGIN
            RAISERROR ('Lỗi: Số lượng sản phẩm có sẵn trong kho phải lớn hơn hoặc bằng 0.', 16, 1);
            RETURN;
        END;

        IF @Chinh_Sach_Doi_Tra IS NULL OR LEN(@Chinh_Sach_Doi_Tra) = 0
        BEGIN
            RAISERROR ('Lỗi: Chính sách đổi trả không được để trống.', 16, 1);
            RETURN;
        END;

        IF @Gia IS NULL OR @Gia <= 0
        BEGIN
            RAISERROR ('Lỗi: Giá sản phẩm phải lớn hơn 0.', 16, 1);
            RETURN;
        END;

        IF @Mau_Sac IS NULL OR LEN(@Mau_Sac) = 0
        BEGIN
            RAISERROR ('Lỗi: Màu sắc sản phẩm không được để trống.', 16, 1);
            RETURN;
        END;

        IF @Kich_Co IS NULL OR LEN(@Kich_Co) = 0
        BEGIN
            RAISERROR ('Lỗi: Kích cỡ sản phẩm không được để trống.', 16, 1);
            RETURN;
        END;

        -- Kiểm tra tồn tại mã cửa hàng (ID Shop) trong bảng Cua_Hang
        IF NOT EXISTS (
            SELECT 1
            FROM Cua_Hang
            WHERE Id_Nguoi_Dung_Binh_Thuong = @Id_Shop
        )
        BEGIN
            RAISERROR ('Lỗi: Mã cửa hàng không tồn tại.', 16, 1);
            RETURN;
        END;

        -- Kiểm tra xem mã sản phẩm đã tồn tại chưa
        IF EXISTS (
            SELECT 1
            FROM San_Pham
            WHERE Id_San_Pham = @Id_San_Pham AND Id_Shop = @Id_Shop
        )
        BEGIN
            RAISERROR ('Lỗi: Mã sản phẩm đã tồn tại trong cửa hàng.', 16, 1);
            RETURN;
        END;

        -- Chèn dữ liệu nếu hợp lệ
        INSERT INTO San_Pham (
            Id_San_Pham, Id_Shop, Ten_San_Pham, Loai, So_Luong_da_ban, 
            San_pham_co_san_trong_kho, Chinh_Sach_Doi_Tra, Gia, Mau_Sac, Kich_Co
        )
        VALUES (
            @Id_San_Pham, @Id_Shop, @Ten_San_Pham, @Loai, @So_Luong_da_ban, 
            @San_pham_co_san_trong_kho, @Chinh_Sach_Doi_Tra, @Gia, @Mau_Sac, @Kich_Co
        );
		---Chèn ảnh sản phẩm
		INSERT INTO Hinh_Anh_San_Pham (
            Id_San_Pham, Id_Shop, Hinh_Anh
        )
        VALUES (
            @Id_San_Pham, @Id_Shop, @Anh);
        PRINT N'Thêm sản phẩm thành công!';
    END TRY
    BEGIN CATCH
        -- Bắt lỗi và hiển thị chi tiết
        PRINT N'Lỗi xảy ra khi thêm sản phẩm!';
        PRINT ERROR_MESSAGE();
    END CATCH
END;
-----------------------Test insert
EXEC InsertSanPham 
    @Id_San_Pham = N'SP0000008',
    @Id_Shop = N'ND0000001',
    @Ten_San_Pham = N'Giày thể thao',
    @Loai = N'Giày Dép',
    @So_Luong_da_ban = 10,
    @San_pham_co_san_trong_kho = 50,
    @Chinh_Sach_Doi_Tra = N'Đổi trả trong 15 ngày',
    @Gia = 500000,
    @Mau_Sac = N'Đen',
    @Kich_Co = N'42',
	@Anh='https://i.pinimg.com/736x/0a/a7/93/0aa793035bc13a90aca2ba628890dd59.jpg'
----------Khi updtae  ----Kiểm tra đã có mã SP đó không, dữ liệu trong trương muốn sửa ko được null

DROP PROCEDURE IF EXISTS UpdateSanPham;
GO
CREATE PROCEDURE UpdateSanPham
    @Id_San_Pham VARCHAR(10),
    @Id_Shop VARCHAR(10),
    @Ten_San_Pham VARCHAR(255),
    @Loai VARCHAR(50),
    @So_Luong_da_ban INT,
    @San_pham_co_san_trong_kho INT,
    @Chinh_Sach_Doi_Tra VARCHAR(MAX),
    @Gia DECIMAL(18,2),
    @Mau_Sac VARCHAR(50),
    @Kich_Co VARCHAR(50),
	@Trangthai VARCHAR(50)
AS
BEGIN
    -- Kiểm tra xem sản phẩm có tồn tại không
    IF NOT EXISTS (
        SELECT 1 
        FROM San_Pham 
        WHERE Id_San_Pham = @Id_San_Pham AND Id_Shop = @Id_Shop
    )
    BEGIN
        PRINT N'Sản phẩm không tồn tại để cập nhật!';
        RETURN;
    END;

    -- Kiểm tra các trường cần sửa không được NULL
    IF @Ten_San_Pham IS NULL  
	BEGIN 
		PRINT N'Tên sản phẩm không được để trống';
		return;
	END;
	
	IF @Loai IS NULL or LEN(@Loai) =0  
	BEGIN 
		PRINT N'Loại sản phẩm không được để trống';
		return;
	END;

	IF @Gia <0 
	BEGIN 
		PRINT N'Giá bán phải lớn hơn 0';
		return ;
	END;

    -- Thực hiện cập nhật dữ liệu
    UPDATE San_Pham
    SET 
        Ten_San_Pham = @Ten_San_Pham,
        Loai = @Loai,
        So_Luong_da_ban = @So_Luong_da_ban,
        San_pham_co_san_trong_kho = @San_pham_co_san_trong_kho,
        Chinh_Sach_Doi_Tra = @Chinh_Sach_Doi_Tra,
        Gia = @Gia,
        Mau_Sac = @Mau_Sac,
        Kich_Co = @Kich_Co,
		Trangthai = @Trangthai
    WHERE 
        Id_San_Pham = @Id_San_Pham AND Id_Shop = @Id_Shop;

    PRINT N'Cập nhật sản phẩm thành công!';
END;
----------------------test update--------------------
EXEC UpdateSanPham 
    @Id_San_Pham = 'SP0000001',
    @Id_Shop = 'ND0000002',
    @Ten_San_Pham = 'Áo Thun Cotton',
    @Loai = 'TSHIRT',
    @So_Luong_da_ban = 10,
    @San_pham_co_san_trong_kho = 90,
    @Chinh_Sach_Doi_Tra = 'Đổi trả trong 15 ngày',
    @Gia = 1,
    @Mau_Sac = 'Trắng',
    @Kich_Co = 'XL',
	@Trangthai = Null;

-----------Khi delete -------Kiểm tra có mã SP đó để xóa hay không 
DROP PROCEDURE IF EXISTS DeleteSanPham;
GO

CREATE PROCEDURE DeleteSanPham
    @Id_San_Pham VARCHAR(10),
    @Id_Shop VARCHAR(10)
AS
BEGIN
    SET NOCOUNT ON; -- Ngăn hiển thị thông báo ảnh hưởng số hàng.

    -- Kiểm tra xem sản phẩm có tồn tại trong bảng San_Pham không
    IF NOT EXISTS (
        SELECT 1 
        FROM San_Pham 
        WHERE Id_San_Pham = @Id_San_Pham AND Id_Shop = @Id_Shop
    )
    BEGIN
        PRINT N'Sản phẩm không tồn tại trong bảng San_Pham!';
        RETURN;
    END;

    -- Kiểm tra trạng thái hiện tại của sản phẩm
    IF EXISTS (
        SELECT 1 
        FROM San_Pham 
        WHERE Id_San_Pham = @Id_San_Pham AND Id_Shop = @Id_Shop AND Trangthai = 'deactive'
    )
    BEGIN
        PRINT N'Sản phẩm ngưng bán!';
        RETURN;
    END;

    -- Cập nhật trạng thái sản phẩm thành "deactive"
    UPDATE San_Pham
    SET Trangthai = 'deactive'
    WHERE Id_San_Pham = @Id_San_Pham AND Id_Shop = @Id_Shop;

    PRINT N'Sản phẩm ngưng bán!';
END;
GO
----tEST
EXEC DeleteSanPham @Id_San_Pham = 'SP0000001', @Id_Shop = 'ND0000002';


----2.3 --thủ tục liệt kê số sao của cùng 1 loại sản phẩm của các shop khác nhau
-------Nhập vào tên sản phẩm (hiển thị ko có nếu chưa có sp đó)
DROP PROCEDURE IF EXISTS SodiemdanhgiaTheoTenSanpham;
GO

CREATE PROCEDURE SodiemdanhgiaTheoTenSanpham
    @TenSanpham NVARCHAR(255) -- Tên sản phẩm
AS
BEGIN
    SET NOCOUNT ON; 

    -- Kiểm tra sự tồn tại của sản phẩm với tên đã cho
    IF NOT EXISTS (SELECT 1 FROM San_Pham WHERE Ten_San_Pham = @TenSanpham)
    BEGIN
        PRINT(N'Tên sản phẩm không tồn tại.');
        RETURN;
    END;
	--KIEM TRA SP CO LUOT DANH GIA HAY CHƯA
	
	IF NOT EXISTS (
		SELECT 1 
		FROM San_Pham SP
		JOIN Goi G ON SP.Id_San_Pham = G.Id_San_Pham
		WHERE SP.Ten_San_Pham = @TenSanpham
	)
	BEGIN
		-- Trả về thông tin sản phẩm với số lượt đánh giá và số sao là 0
		SELECT 
			SP.Id_Shop AS N'Mã Shop',
			CH.Ten_Cua_Shop AS N'Tên của hàng',
			SP.Id_San_Pham AS N'Mã sản phẩm',
			SP.Ten_San_Pham AS N'Tên sản phẩm',
			FORMAT(0, 'N2') AS N'Trung bình số sao đánh giá',
			0 AS N'Số lượt đánh giá'
		FROM San_Pham AS SP, Cua_Hang CH
		WHERE SP.Ten_San_Pham = @TenSanpham AND CH.Id_Nguoi_Dung_Binh_Thuong = SP.Id_Shop
    
		RETURN;
	END;

    -- Truy vấn thông tin đánh giá của các shop cho sản phẩm có tên này
    SELECT 
        SP.Id_Shop AS N'Mã Shop',
		CH.Ten_Cua_Shop AS N'Tên của hàng',
        SP.Id_San_Pham AS N'Mã sản phẩm',
        SP.Ten_San_Pham AS N'Tên sản phẩm',
        FORMAT(ROUND(AVG(CAST(G.So_Sao AS DECIMAL(10, 2))), 2), 'N2') AS N'Trung bình số sao đánh giá',
        COUNT(G.So_Sao) AS N'Số lượt đánh giá'
    FROM (San_Pham AS SP
    INNER JOIN Goi AS G ON SP.Id_San_Pham = G.Id_San_Pham) JOIN Cua_Hang AS CH ON G.Id_Shop = CH.Id_Nguoi_Dung_Binh_Thuong
    WHERE SP.Ten_San_Pham = @TenSanpham AND SP.Id_Shop=G.Id_Shop
    GROUP BY SP.Id_Shop, SP.Id_San_Pham, SP.Ten_San_Pham, CH.Ten_Cua_Shop
    ORDER BY AVG(CAST(G.So_Sao AS DECIMAL(10, 2))) DESC; -- Sắp xếp theo số sao trung bình giảm dần
END;
GO
----------------demo----------------
EXEC SodiemdanhgiaTheoTenSanpham 
    @TenSanpham = N'Giày th? thao';
GO

---Thủ tục xếp hạng sản phẩm bán theo giá cả--
CREATE PROCEDURE Xep_Hang_Shop_Ban_Chay
    @Ten_San_Pham NVARCHAR(255), -- Tên sản phẩm cần xếp hạng
    @StartDate DATE,             -- Ngày bắt đầu
    @EndDate DATE                -- Ngày kết thúc
AS
BEGIN
    SET NOCOUNT ON;
    SELECT 
        sp.Id_Shop AS ShopId,
        ch.Ten_Cua_Shop AS ShopName,
        SUM(spdh.So_Luong_San_Pham * spdh.Gia_Luc_Dat) AS TotalRevenue,
        SUM(spdh.So_Luong_San_Pham) AS TotalQuantitySold
    FROM 
        San_Pham_Trong_Don_Hang spdh
    INNER JOIN 
        San_Pham sp ON spdh.Id_San_Pham = sp.Id_San_Pham AND spdh.Id_Shop = sp.Id_Shop
    INNER JOIN 
        Cua_Hang ch ON sp.Id_Shop = ch.Id_Nguoi_Dung_Binh_Thuong
    INNER JOIN 
        Hoa_Don hd ON spdh.Id_Don_Hang = hd.Id_Don_Hang
    WHERE 
        sp.Ten_San_Pham = @Ten_San_Pham
        AND hd.Ngay_Giao_Dich BETWEEN @StartDate AND @EndDate
    GROUP BY 
        sp.Id_Shop, ch.Ten_Cua_Shop
    HAVING 
        SUM(spdh.So_Luong_San_Pham) > 0 -- Chỉ shop có bán sản phẩm
    ORDER BY 
        TotalRevenue DESC; 
END;
GO
EXEC Xep_Hang_Shop_Ban_Chay
    @Ten_San_Pham = N'T-Shirt Classic', 
    @StartDate = '2024-01-01', 
    @EndDate = '2024-12-31';
GO

----- 2.4 tính tổng chi tiêu ----
CREATE OR ALTER FUNCTION dbo.Tinh_Tong_Chi_Tieu_Cua_KH(
    @Sdt_find VARCHAR(15),
    @start_date DATE,
    @end_date DATE
)
RETURNS @KQ TABLE (
    Sdt VARCHAR(15),
    Ten NVARCHAR(100),
    Tong_Chi_Tieu DECIMAL(18, 2),
    Loai_Khach_Hang NVARCHAR(20)
)
AS
BEGIN
    -- Biến tạm để lưu kết quả tạm thời
    DECLARE @tong_chi_tieu DECIMAL(18, 2);
    DECLARE @ten NVARCHAR(100);
    DECLARE @cursor CURSOR;
    --Kiểm tra ngày tháng, điều kiện đầu vào
    IF (@start_date > @end_date OR @Sdt_find IS NULL OR @Sdt_find = '')
        RETURN;

    -- Sử dụng con trỏ để duyệt qua các hóa đơn
    SET @cursor = CURSOR FOR
        SELECT DISTINCT 
            ndbt.Sdt, 
            CONCAT(ndbt.Ho, ' ', ndbt.Ten) AS Ten,
            SUM(h.Tong_Tien) AS Tong_Chi_Tieu
        FROM
            Don_Hang d
        JOIN Hoa_Don h ON d.Id_Don_Hang = h.Id_Don_Hang
        JOIN Khach_Hang kh ON kh.Id_Nguoi_Dung_Binh_Thuong = d.Id_Khach_Hang
        JOIN Nguoi_Dung_Binh_Thuong ndbt ON ndbt.Id_Nguoi_Dung = kh.Id_Nguoi_Dung_Binh_Thuong
        WHERE ndbt.Sdt = @Sdt_find
          AND h.Ngay_Giao_Dich BETWEEN @start_date AND @end_date
        GROUP BY ndbt.Sdt, ndbt.Ho, ndbt.Ten;

    OPEN @cursor;
    FETCH NEXT FROM @cursor INTO @Sdt_find, @ten, @tong_chi_tieu;
    WHILE @@FETCH_STATUS = 0
    BEGIN
        DECLARE @loai_khach_hang NVARCHAR(20);
        -- Phân loại khách hàng dựa trên tổng chi tiêu
        IF @tong_chi_tieu < 3000000
            SET @loai_khach_hang = N'Đồng';
        ELSE IF @tong_chi_tieu < 5000000
            SET @loai_khach_hang = N'Bạc';
        ELSE IF @tong_chi_tieu < 75000000
            SET @loai_khach_hang = N'Vàng';
        ELSE
            SET @loai_khach_hang = N'Kim cương';

        INSERT INTO @KQ(Sdt, Ten, Tong_Chi_Tieu, Loai_Khach_Hang)
        VALUES (@Sdt_find, @ten, @tong_chi_tieu, @loai_khach_hang);
        FETCH NEXT FROM @cursor INTO @Sdt_find, @ten, @tong_chi_tieu;
    END;
    CLOSE @cursor;
    DEALLOCATE @cursor;
    RETURN;
END;
GO
----------------Demo------------------
SELECT * 
FROM Tinh_Tong_Chi_Tieu_Cua_KH('0966666666', '2024-01-01', '2024-12-31');

-----------Doanh thu cửa hàng---------
GO
CREATE FUNCTION Tinh_Doanh_Thu_Cua_Cua_Hang_Trong_Khoang_TG
(
    @Sdt_Cua_Hang VARCHAR(10), 
    @start_date DATE,          
    @end_date DATE              
)
RETURNS @KetQua TABLE
(
    So_Dien_Thoai VARCHAR(10), 
    Id_Shop VARCHAR(50),       
    Ten_Shop NVARCHAR(255),     
    Tong_Doanh_Thu NUMERIC(18, 2) 
)
AS
BEGIN
    DECLARE @doanh_thu NUMERIC(18, 2) = 0; 
    DECLARE @Tong_Tien NUMERIC(18, 2);     
    DECLARE @Id_Cua_Hang VARCHAR(50);      
    DECLARE @Ten_Cua_Hang NVARCHAR(255); 

    -- Kiểm tra tham số đầu vào
    IF (@Sdt_Cua_Hang IS NULL OR @Sdt_Cua_Hang = '' OR @start_date IS NULL OR @end_date IS NULL)
    BEGIN
        RETURN; 
    END

    -- Lấy thông tin shop (ID và Tên) dựa trên số điện thoại
    SELECT DISTINCT @Id_Cua_Hang = Id_Nguoi_Dung_Binh_Thuong, @Ten_Cua_Hang = Ten_Cua_Shop
    FROM Cua_Hang
    WHERE So_Dien_Thoai = @Sdt_Cua_Hang;

    IF (@Id_Cua_Hang IS NULL)
    BEGIN
        RETURN;
    END

    -- Khởi tạo con trỏ để lấy doanh thu từ bảng Don_Hang và Hoa_Don
    DECLARE doanh_thu_cursor CURSOR FOR
    SELECT h.Tong_Tien
    FROM San_Pham_Trong_Don_Hang d
    JOIN Hoa_Don h ON d.Id_Don_Hang = h.Id_Don_Hang
    WHERE d.Id_Shop = @Id_Cua_Hang
    AND h.Ngay_Giao_Dich BETWEEN @start_date AND @end_date;

    -- Mở con trỏ
    OPEN doanh_thu_cursor;

    -- Lặp qua các dòng dữ liệu và tính tổng doanh thu
    FETCH NEXT FROM doanh_thu_cursor INTO @Tong_Tien;
    WHILE @@FETCH_STATUS = 0
    BEGIN
        SET @doanh_thu = @doanh_thu + ISNULL(@Tong_Tien, 0);

        FETCH NEXT FROM doanh_thu_cursor INTO @Tong_Tien;
    END;

    CLOSE doanh_thu_cursor;
    DEALLOCATE doanh_thu_cursor;

    INSERT INTO @KetQua (So_Dien_Thoai, Id_Shop, Ten_Shop, Tong_Doanh_Thu)
    VALUES (@Sdt_Cua_Hang, @Id_Cua_Hang, @Ten_Cua_Hang, @doanh_thu);

    RETURN;
END;
GO
SELECT * 
FROM Tinh_Doanh_Thu_Cua_Cua_Hang_Trong_Khoang_TG('0911111111', '2024-01-01', '2024-12-31');
GO


CREATE PROCEDURE LichSuMuaHang
    @SoDienThoai NVARCHAR(15),      -- Số điện thoại của khách hàng
    @NgayBatDau DATE,               -- Ngày bắt đầu lọc
    @NgayKetThuc DATE               -- Ngày kết thúc lọc
AS
BEGIN
    -- Truy vấn lịch sử mua hàng
    SELECT 
        sp.Ten_San_Pham,
        dh.Trang_Thai_Don_Hang AS TrangThai,
        COUNT(dh.Id_Don_Hang) AS SoLuongDonHang,
        SUM(spd.So_Luong_San_Pham * spd.Gia_Luc_Dat) AS TongTienDaChi,
        MAX(hd.Ngay_Giao_Dich) AS NgayThanhToan
    FROM
        Khach_Hang kh
    INNER JOIN
        Nguoi_Dung_Binh_Thuong ndbt ON kh.Id_Nguoi_Dung_Binh_Thuong = ndbt.Id_Nguoi_Dung
    INNER JOIN 
        Don_Hang dh ON kh.Id_Nguoi_Dung_Binh_Thuong = dh.Id_Khach_Hang
    INNER JOIN 
        San_Pham_Trong_Don_Hang spd ON dh.Id_Don_Hang = spd.Id_Don_Hang
    INNER JOIN
        San_Pham sp ON spd.Id_San_Pham = sp.Id_San_Pham AND spd.Id_Shop = sp.Id_Shop
    INNER JOIN
        Hoa_Don hd ON hd.Id_Don_Hang = dh.Id_Don_Hang
    WHERE 
        ndbt.Sdt = @SoDienThoai
        AND hd.Ngay_Giao_Dich BETWEEN @NgayBatDau AND @NgayKetThuc
    GROUP BY 
        sp.Ten_San_Pham,
        dh.Trang_Thai_Don_Hang
    HAVING 
        COUNT(dh.Id_Don_Hang) > 0  -- Kiểm tra nếu có ít nhất 1 đơn hàng
    ORDER BY 
        NgayThanhToan DESC;  -- Sắp xếp theo ngày thanh toán giảm dần
END;
GO
EXEC LichSuMuaHang 
    @SoDienThoai = '0966666666', 
    @NgayBatDau = '2024-01-01', 
    @NgayKetThuc = '2024-12-31';
GO
