-- Tạo cơ sở dữ liệu
CREATE DATABASE Lab2;
GO

-- Sử dụng cơ sở dữ liệu
USE Lab2;
GO

-- Khai báo và in biến Name
DECLARE @Name NVARCHAR(50);
SET @Name = 'Hoàng';
PRINT 'TÊN: ' + @Name;

-- Khai báo và in biến Age
DECLARE @Age NVARCHAR(20) = 21;
PRINT 'Age: ' + CAST(@Age AS NVARCHAR);

-- Tạo bảng Employee
CREATE TABLE Employee (
    ID CHAR(4) PRIMARY KEY,
    FullName NVARCHAR(35),
    Gender BIT,
    BirthDate DATE,
    Address NVARCHAR(250),
    Email VARCHAR(50),
    Salary FLOAT,
    Phone VARCHAR(20)
);
GO
-- Thêm cột Phone vào bảng Employee
ALTER TABLE Employee
ADD Phone1 VARCHAR(25);

-- Nhập vào tối thiểu 5 bản ghi
INSERT INTO Employee (ID, FullName, Gender, BirthDate, Address, Salary)
VALUES
('01', N'HOANG', 1, '2002-12-12', N'HANOI', 4000000),
('02', N'PHONG', 1, '2002-08-10', N'HANOI', 100000),
('03', N'HUY', 1, '2002-08-10', N'HANOI', 2000000),
('04', N'DUY', 1, '2002-08-10', N'HANOI', 2500000);
GO
-- Cập nhật dữ liệu cho cột Email và Phone
UPDATE Employee
SET Email = 'hoang@gmail.com', Phone = '123-456-7890'
WHERE ID = '01';

UPDATE Employee
SET Email = 'phong@gmail.com', Phone = '234-567-8901'
WHERE ID = '02';

UPDATE Employee
SET Email = 'huy@gmail.com', Phone = '345-678-9012'
WHERE ID = '03';

UPDATE Employee
SET Email = 'duy@gmail.com', Phone = '456-789-0123'
WHERE ID = '04';

SELECT*FROM Employee
GO
-- Đưa ra các nhân viên có lương > 2000000
SELECT * FROM Employee WHERE Salary > 2000000;

-- Đưa ra các nhân viên sinh nhật trong tháng này
DECLARE @CurrentMonth INT;
SET @CurrentMonth = MONTH(GETDATE());

SELECT * FROM Employee
WHERE MONTH(BirthDate) = @CurrentMonth;
GO


-- Đưa ra danh sách nhân viên kèm theo cột tuổi và cột Birthday
SELECT
    ID,
    FullName,
    Gender,
    BirthDate,
    Address,
    Email,
    Salary,
    Phone,
    DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age,
    CONVERT(VARCHAR, BirthDate, 103) AS BirthdayFormatted
FROM Employee;

-- Đưa ra những nhân viên có địa chỉ ở Hà Nội
SELECT * FROM Employee WHERE Address LIKE N'HANOI';

-- Sửa tên nhân viên có mã là '1' thành tên 'Phương'
UPDATE Employee
SET FullName = N'Phương'
WHERE ID = 01;

-- Xóa những nhân viên có tuổi > 50
DELETE FROM Employee WHERE DATEDIFF(YEAR, BirthDate, GETDATE()) > 50;

-- Tạo bảng mới và sao chép những nhân viên có tuổi > 50 sang bảng mới
SELECT *
INTO Employee_Over50
FROM Employee
WHERE DATEDIFF(YEAR, BirthDate, GETDATE()) > 50;

-- Đếm số nhân viên
SELECT COUNT(*) AS SoNhanVien FROM Employee;