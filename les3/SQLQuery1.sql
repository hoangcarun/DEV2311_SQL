--1. Taoj csdl bằng lện T-SQL
-- syntax: CREATE DATABASE
--tạo csdl đơn giản
use master
Go
CREATE DATABASE DEV2311_SQL24_03
Go
--tạo csdl với các thuộc tính cơ bản
CREATE DATABASE DEV2311LM_SQL24_03
ON
(NAME = DEV2311LM_SQL24_03_DATA,
    FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL16.HOANG\MSSQL\DATA\DEV2311LM_SQL24_03_DATA.mdf',
    SIZE = 10,
    MAXSIZE = 50,
    FILEGROWTH = 5)
LOG ON
(NAME = DEV2311LM_SQL24_03_log,
    FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL16.HOANG\MSSQL\DATA\DEV2311LM_SQL24_03_log.ldf',
    SIZE = 5 MB,
    MAXSIZE = 25 MB,
    FILEGROWTH = 5 MB);
GO
--2.Tạo bảng và các dữ liệu ràng buộc trên bảng 
--các kiểu dữ liệu thường dùng
/* 
-- kiểu số : (số nguyên / số thực)
++ số nguyên : tinyint / smallInt/int / bigInt/
++ số thực : float / double/ decimal/ numeric/

--kiểu chuỗi: (non unicode / unicode/)
++non unicode: char / varchar/ text/
++ unicode : nchar/ nvarchar/ ntext
++ fixed length : char/ nchar
++dynamic length : varchar/ nvarchar

-- kiểu ngày giờ : samllDatetime/ datetime/date/time ...

-- kiểu logic: bit

--kiểu nhị phân : binary/ 
-- tham khảo thêm : keyword (datratype in sql sever)
*/
/*
các ràng buộc trên đữ liệu table (colum)
--null/not null
-- Duy nhất: primary key / unique / thuộc tính identity/ kiểu dữ liệu uniqueidentifier
-- tham chiếu (khoá ngoại): foreign key
--  ràng buộc miền giá trị (Domain): DataType / check constraint
-- Thuộc tính Default:
*Ràng buộc phức tạp: => trigger
*/
-- Tạo cấu trúc bảng dữ liệu 
--syntax: CREATE DATABASE
USE [DEV2311LM_SQL24_03]
GO
--2.1 tạo bảng đơn giản
CREATE TABLE TABLE1
(
COL1 INT,
COL2 VARCHAR(100)
)
GO
--2.2 TẠO BẢNG VỚI RÀNG BUỘC KHOÁ CHÍNH (primary key)
-- vattu( mavattu , tenvattu, dvtinh, phamtram
CREATE TABLE VATTU
(
MAVTU CHAR(4) CONSTRAINT PK_VATTU PRIMARY KEY,
TENVTU NVARCHAR(200) NOT NULL,
DVTINH NVARCHAR(20),
PHANTRAM REAL,
 
)
GO
--NOTE tạo bảng với dữ liệu khoá chính trên 2 hay nhiều cột
CREATE TABLE TABLE2
(
COL1 INT,
COL2 INT,
COL3 NVARCHAR (100),
CONSTRAINT PK_TABLE2 PRIMARY KEY (COL1,COL2)
)
GO
--2.3 TẠO bảng với ràng buộc khoá chính và dữ liệu tự động tăng (identity)
CREATE TABLE TABLE3
(
COL1 INT IDENTITY(1,1) CONSTRAINT PK_TABLE3 PRIMARY KEY,
COL2 NVARCHAR(100),
COL3 TINYINT 
)
GO
--2.4 TẠO bảng với ràng buộc duy nhất (unique)
-- NHACC( MANCC, TENNCC,DIACHI,DIENTHOAI)
--PK[MANCC]
--UQ[TENNCC]
--DF[DIACHI]='25 VU NGOC PHAN'
CREATE TABLE NHACC
(
MANCC CHAR(3) CONSTRAINT PK_NHACC PRIMARY KEY,
TENNCC NVARCHAR(200) CONSTRAINT UQ_NHACC_DIENTHOAI UNIQUE,
DIACHI NVARCHAR(250) CONSTRAINT UQ_NHACC_DIACHI DEFAULT ' 25 VU NGOC PHAN',
DIENTHOAI VARCHAR(50) NOT NULL CONSTRAINT UQ_NHACC_DIENTHAOI UNIQUE,
)
GO
--2.6 ràng buộc miền giá trị CHECK CONSTRAINT
-- CTDONDH(SODH,MAVT,SLDAT)
--PK[SODH,MAVTU]
--CK[SLDAT]>0
CREATE TABLE CTDONDH1
(
SODH CHAR(4),
MAVTU CHAR(4),
SLDAT TINYINT CONSTRAINT CK_CTDONDH_SLDAT CHECK (SLDAT>0 AND SLDAT<150),
CONSTRAINT PK_CTDONDH PRIMARY KEY (SODH, MAVTU),
)
GO
-- CÁCH 2 CỦA CTDONDH
CREATE TABLE CTDONDH
(
	SODH CHAR(4) CONSTRAINT FK_CTDONDH_SODH FOREIGN KEY REFERENCES DONDH,
	MAVTU CHAR(4),-- CONSTRAINT FK_CTDONDH_VATTU_SODH FOREIGN KEY REFERENCES VATTU
	SLDAT TINYINT CONSTRAINT CK_CTDONDH_SLDAT CHECK(SLDAT>0 AND SLDAT<150),
	CONSTRAINT PK_CTDONDH PRIMARY KEY(SODH, MAVTU),
	CONSTRAINT FK_CTDONDH_VATTU_MAVTU FOREIGN KEY (MAVTU) REFERENCES VATTU
		ON UPDATE CASCADE
		ON DELETE NO ACTION
)
GO
--2.7 DONHANG(SODH,NGAYDH,MANHACC)
--PK(SODH)
CREATE TABLE DONDH
(
SODH CHAR(4) CONSTRAINT CK_DONDH PRIMARY KEY ,
NGAYDH DATETIME,
MANHACC CHAR (3) NOT NULL,
)
GO
--2.8 PNHAP(SOPN,NGAYNHAP,SODH)
--PK[SOPN]
CREATE TABLE PNHAP
(
SOPN CHAR(4) CONSTRAINT CK_PNHAP PRIMARY KEY,
NGAYNHAP DATETIME ,
SODH CHAR(4) NOT NULL,
)
GO
--2.9 SỬA đổi bảng ĐONH
-- bổ sung khoá ngoại (MANHACC) tham chiếu đến bảng NHACC
--FK[MANHACC] ~ NHACC
--sửa đổi thêm ràng buộc:
ALTER TABLE DONDH
ADD CONSTRAINT FK_DONDH_NHACC FOREIGN KEY (MANHACC) REFERENCES NHACC(MANCC)
    ON UPDATE CASCADE
    ON DELETE NO ACTION
GO
--THÊM CỘT 
ALTER TABLE DONDH
  ADD TONGTRIGIA NUMERIC(18,2)
  GO
  --XOÁ CỘT 
  ALTER TABLE DONDH
    DROP COLUMN TONGTRIGIA
	GO
-- SỬA TÊN CỘT
EXEC sp_rename 'dbo.DONHANG.TONGTRIGIA','TONGTRIGIA','COLUMN';
--3.Làm việc với các câu lệnh DML (select,ínert,update,delete)
--3.1 select -> lọc / duyệt các bảng ghi từ nguồn dữ liệu
SELECT*FROM VATTU
GO
--3.2 INSERT
--THÊM MỘT HAY NHIỀU BẢN GHI VÀO BẢNG
-- SYNTAX(ĐƠN GIẢN)
--THÊM MỘT BẢN GHI VÀO BẢNG
INSERT VATTU(MAVTU,TENVTU,DVTINH,PHANTRAM)
VALUES('VT01',N'TỦ LẠNH LG201',N'CHIÊC',40)
GO
SELECT*FROM VATTU
GO
INSERT VATTU(MAVTU,TENVTU,DVTINH,PHANTRAM)
VALUES('VT02',N'TỦ LẠNH LG202',N'CHIÊC',40)
GO
/*
msg 213, level 16 , line 242
column name ỏ number ò supplied calues doé match table dèinition
*/
--ghi chú : 
-- ++cột identity -> mặc định không thực hiện thêm giá trị cho cột này
-- ++ cột có giá trị mặc định hoặc null: có thể không cần thêm giá trị
-- ++ mặc định : khi thêm giá trị trên cột khoá ngoại , thì giá trị đó phải tồn tại trên cột tham chiếu trên bảng 1 tương ứng
INSERT VATTU(MAVTU ,TENVTU, DVTINH, PHANTRAM) VALUES
('VT03',N'TỦ LẠNH LG202',N'CHIÊC',45),
('VT04',N'TỦ LẠNH LG202',N'CHIÊC',48),
('VT05',N'TỦ LẠNH LG202',N'CHIÊC',12),
('VT06',N'TỦ LẠNH LG202',N'CHIÊC',30)
GO
--INSERT SELECT
INSERT VATTU(MAVTU,TENVTU,DVTINH,PHANTRAM)
VALUES('VT07',N'TỦ LẠNH LG202',N'CHIÊC',40)

-------------------------------------------
--GHI CHÚ :
/*
  Dữ liệu chuỗi non unicode: đặt trong cặp nháy đơn ''
  Dữ liêun chuỗi uni code : đặt trong cặp nháy đơn N''
  Dữ liệu kiểu ngày :(mặc định) -> đặt trong cặp dấu nháy đơn '' , theo định dạng : mm/dd/yyyy 
  => set dateformat dmy?
*/
--3.3 update -> sửa đổi dữ liệu trên cột trong bảng
-- xoá cũ , thêm mới/
--syntax:
/*
update<table_name>[source]
set <column_name> = <giá trị> / [<column_source>] [,...]
[where <condition>]
*/
-- cập nhập cột PHANTRAM trong bảng vật tư , tăng lên 10
SELECT*FROM VATTU
UPDATE VATTU SET PHANTRAM = PHANTRAM + 10
GO
-- câph nhập cột phần trăm trong bảng vật tư , tỉ lệ phần trăm giảm đi 10 cho những vật tư có phần trăm >=50
UPDATE VATTU SET PHANTRAM = PHANTRAM - 10 WHERE PHANTRAM >=50
GO
--- 3.4 : XOÁ ( DELETE)
--SYNTAX: DELETE [FROM] <TABLE_NAME> [WHERE<CONDITION>]
DELETE VATTU WHERE MAVTU = 'VT06'
GO
--XOÁ CÁC BẢN GHI PHẦN TRĂM <50
DELETE VATTU WHERE PHANTRAM <50
GO
-- GHI CHÚ :
--KHI xoá dữ liệu trên bảng mà có liên kết đến bảng bên nhiều thì chú ý đến điều kiện tham chiếu ( ON DELETE NO ACTION)

--3.5 XOÁ SẠCH
--syntax : TRUNCATE TABLE <TABLE_NAME>
TRUNCATE TABLE VATTU
GO--Cannot truncate table 'VATTU' because it is being referenced by a FOREIGN KEY constraint.
TRUNCATE TABLE [dbo].[TABLE1] --XOÁ sạch bảng đấy