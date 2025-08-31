CREATE DATABASE ProjectAkhirGroup1
GO
USE ProjectAkhirGroup1
GO


--MsStaff
CREATE TABLE MsStaff(
StaffID CHAR(5) PRIMARY KEY CHECK (StaffID LIKE 'ST[0-9][0-9][0-9]'),
StaffName VARCHAR(255) NOT NULL,
StaffEmail VARCHAR(255) NOT NULL,
StaffGender VARCHAR(10) CHECK (StaffGender IN ('Female', 'Male')),
StaffDOB DATE CHECK (YEAR(StaffDOB) < 2000) NOT NULL,
StaffAddress VARCHAR(255) NOT NULL
)

--MsCustomer
CREATE TABLE MsCustomer (
CustomerID CHAR(5) PRIMARY KEY CHECK (CustomerID LIKE 'CU[0-9][0-9][0-9]'), 
CustomerName VARCHAR (255) NOT NULL,
CustomerGender VARCHAR (10) CHECK (CustomerGender IN ('Male','Female')),
CustomerEmail VARCHAR (255) NOT NULL,
CustomerDOB DATE CHECK (YEAR(CustomerDOB) < 2000),
CustomerAddress VARCHAR (255) NOT NULL
)

--MsVendor
CREATE TABLE MsVendor (
VendorID CHAR(5) PRIMARY KEY CHECK (VendorID LIKE 'VR[0-9][0-9][0-9]'), 
VendorName VARCHAR (255) NOT NULL,
VendorGender VARCHAR (10) CHECK (VendorGender IN ('Male','Female')),
VendorEmail VARCHAR (255) NOT NULL,
VendorDOB DATE NOT NULL,
VendorAddress VARCHAR (255) NOT NULL
)

--MsProductCategory
CREATE TABLE MsProductCategory (
ProductCategoryID CHAR (5) PRIMARY KEY CHECK (ProductCategoryID LIKE 'CT[0-9][0-9][0-9]'),
ProductCategoryName VARCHAR (255) CHECK (ProductCategoryName IN 
('Mobile Phones','Smartphones','Android Phones','IOS Devices',
'Budget Smartphones','Flagship Phones','Phone Accessories',
'Phone Cases','Wireless Earbuds','Mobile Phone Chargers'))
)

--MsProduct
CREATE TABLE MsProduct (
ProductID CHAR(5) PRIMARY KEY CHECK (ProductID LIKE 'PT[0-9][0-9][0-9]'),
ProductCategoryID CHAR (5) REFERENCES MsProductCategory(ProductCategoryID) ,
ProductName VARCHAR (255) CHECK (LEN (ProductName) > 10),
ProductPrice FLOAT CHECK (ProductPrice BETWEEN 1000 AND 2200),
ProductWeight INT NOT NULL
)

--PurchaseHeader
CREATE TABLE PurchaseHeader(
PurchaseID CHAR(5) PRIMARY KEY CHECK (PurchaseID LIKE 'PH[0-9][0-9][0-9]'),
StaffID CHAR(5),
VendorID CHAR(5),
PurchaseDate DATE NOT NULL,
FOREIGN KEY (StaffID) REFERENCES MsStaff(StaffID),
FOREIGN KEY (VendorID) REFERENCES MsVendor(VendorID)
)

--Purchase Detail
CREATE TABLE PurchaseDetail (
PurchaseID CHAR(5),
ProductID CHAR(5),
Quantity INT NOT NULL,
FOREIGN KEY (PurchaseID) REFERENCES PurchaseHeader(PurchaseID),
FOREIGN KEY (ProductID) REFERENCES MsProduct(ProductID),
PRIMARY KEY (PurchaseID, ProductID)
)

--SaleHeader
CREATE TABLE SaleHeader(
SaleID CHAR(5) PRIMARY KEY CHECK (SaleID LIKE 'SH[0-9][0-9][0-9]'),
StaffID CHAR(5),
CustomerID CHAR(5),
TransactionDate DATE NOT NULL,
FOREIGN KEY (StaffID) REFERENCES MsStaff(StaffID),
FOREIGN KEY (CustomerID) REFERENCES MsCustomer(CustomerID)
)

--SaleDetail
CREATE TABLE SaleDetail (
SaleID CHAR(5),
ProductID CHAR(5),
Quantity INT NOT NULL,
FOREIGN KEY (SaleID) REFERENCES SaleHeader(SaleID),
FOREIGN KEY (ProductID) REFERENCES MsProduct(ProductID),
PRIMARY KEY (SaleID, ProductID)
)

INSERT INTO MsStaff (StaffID, StaffName, StaffEmail, StaffGender, StaffDOB, StaffAddress)
VALUES 
('ST001', 'Agus', 'agus@example.com', 'Male', '1999-07-15', 'Jl. Raya No. 10, Jakarta'),
('ST002', 'Dewi Rahayu', 'dewi.rahayu@example.com', 'Female', '1999-04-20', 'Jl. Merdeka No. 25, Surabaya'),
('ST003', 'Hendra Wijaya', 'hendra.wijaya@example.com', 'Male', '1985-11-08', 'Jl. Diponegoro No. 30, Bandung'),
('ST004', 'Sari Putri', 'sari.putri@example.com', 'Female', '1999-03-25', 'Jl. Sudirman No. 45, Yogyakarta'),
('ST005', 'Yudi Pratama', 'yudi.pratama@example.com', 'Male', '1994-09-18', 'Jl. Gatot Subroto No. 12, Semarang'),
('ST006', 'Rina Susanti', 'rina.susanti@example.com', 'Female', '1983-06-30', 'Jl. Ahmad Yani No. 8, Medan'),
('ST007', 'Doni Kusuma', 'doni.kusuma@example.com', 'Male', '1991-02-12', 'Jl. Surya Kencana No. 20, Malang'),
('ST008', 'Siti Hartati', 'siti.hartati@example.com', 'Female', '1987-08-05', 'Jl. Majapahit No. 15, Denpasar'),
('ST009', 'Rudi', 'rudi@example.com', 'Male', '1986-12-22', 'Jl. Pahlawan No. 30, Makassar'),
('ST010', 'Lina Widya', 'lina.widya@example.com', 'Female', '1999-10-08', 'Jl. Merak No. 35, Palembang')

INSERT INTO MsCustomer (CustomerID, CustomerName, CustomerGender, CustomerEmail, CustomerDOB, CustomerAddress)
VALUES 
('CU001', 'Dewi', 'Female', 'dewi@example.com', '1999-07-15', 'Jl. Merdeka No. 10, Jakarta'),
('CU002', 'Budi Santoso', 'Male', 'budi.santoso@example.com', '1988-04-20', 'Jl. Diponegoro No. 25, Surabaya'),
('CU003', 'Citra Purnama', 'Female', 'citra.purnama@example.com', '1992-11-08', 'Jl. Sudirman No. 30, Bandung'),
('CU004', 'Dharma Wijaya', 'Male', 'dharma.wijaya@example.com', '1999-03-25', 'Jl. Pahlawan No. 45, Yogyakarta'),
('CU005', 'Eka Putri', 'Female', 'eka.putri@example.com', '1994-09-18', 'Jl. Surya Kencana No. 12, Semarang'),
('CU006', 'Firman Susanto', 'Male', 'firman.susanto@example.com', '1983-06-30', 'Jl. Raya Barat No. 8, Medan'),
('CU007', 'Gita', 'Female', 'gita@example.com', '1991-02-12', 'Jl. Merak No. 20, Malang'),
('CU008', 'Hadi Pratama', 'Male', 'hadi.pratama@example.com', '1987-08-05', 'Jl. Majapahit No. 15, Denpasar'),
('CU009', 'Intan Sari', 'Female', 'intan.sari@example.com', '1986-12-22', 'Jl. Pahlawan No. 30, Makassar'),
('CU010', 'Joko Widodo', 'Male', 'joko.widodo@example.com', '1999-10-08', 'Jl. Gatot Subroto No. 35, Palembang')

INSERT INTO MsVendor (VendorID, VendorName, VendorGender, VendorEmail, VendorDOB, VendorAddress)
VALUES 
('VR001', 'Anwar Jaya', 'Male', 'anwar.jaya@example.com', '1985-03-15', 'Jl. Raya No. 10, Jakarta'),
('VR002', 'Dewi Wijaya', 'Female', 'dewi.wijaya@example.com', '1990-07-20', 'Jl. Diponegoro No. 25, Surabaya'),
('VR003', 'Hendra Setiawan', 'Male', 'hendra.setiawan@example.com', '1988-11-10', 'Jl. Sudirman No. 30, Bandung'),
('VR004', 'Sari', 'Female', 'sari@example.com', '1995-04-25', 'Jl. Pahlawan No. 45, Yogyakarta'),
('VR005', 'Yoga', 'Male', 'yoga@example.com', '1999-09-18', 'Jl. Gatot Subroto No. 12, Semarang'),
('VR006', 'Rina Susanti', 'Female', 'rina.susanti@example.com', '1987-06-30', 'Jl. Ahmad Yani No. 8, Medan'),
('VR007', 'Doni Kusuma', 'Male', 'doni.kusuma@example.com', '1983-02-12', 'Jl. Surya Kencana No. 20, Malang'),
('VR008', 'Siti Hartati', 'Female', 'siti.hartati@example.com', '1993-08-05', 'Jl. Majapahit No. 15, Denpasar'),
('VR009', 'Rudi Santoso', 'Male', 'rudi.santoso@example.com', '1999-12-22', 'Jl. Pahlawan No. 30, Makassar'),
('VR010', 'Lina', 'Female', 'lina@example.com', '1991-10-08', 'Jl. Merak No. 35, Palembang')

INSERT INTO MsProductCategory (ProductCategoryID, ProductCategoryName)
VALUES
('CT001', 'Mobile Phones'),
('CT002', 'Smartphones'),
('CT003', 'Android Phones'),
('CT004', 'IOS Devices'),
('CT005', 'Budget Smartphones'),
('CT006', 'Flagship Phones'),
('CT007', 'Phone Accessories'),
('CT008', 'Phone Cases'),
('CT009', 'Wireless Earbuds'),
('CT010', 'Mobile Phone Chargers')

INSERT INTO MsProduct (ProductID, ProductCategoryID, ProductName, ProductPrice, ProductWeight)
VALUES 
('PT001', 'CT001', 'Samsung Galaxy A52', 1800.0, 180),
('PT002', 'CT002', 'iPhone SE Pro', 1500.0, 160),
('PT003', 'CT003', 'Google Pixel 5', 1100.0, 170),
('PT004', 'CT004', 'iPhone 12 Pro', 1800.0, 170),
('PT005', 'CT005', 'Xiaomi Redmi 9', 1000.0, 200),
('PT006', 'CT006', 'Samsung Galaxy S21 Ultra', 2200.0, 220),
('PT007', 'CT007', 'Anker PowerCore 10000mAh', 1000.0, 300),
('PT008', 'CT008', 'Spigen Tough Armor Case', 1200.0, 100),
('PT009', 'CT009', 'Apple AirPods Pro', 1900.0, 50),
('PT010', 'CT010', 'Anker Wireless Charger', 1000.0, 150),
('PT011', 'CT001', 'Xiaomi Redmi Note 10', 1050.0, 180),
('PT012', 'CT002', 'OnePlus Nord', 1400.0, 160),
('PT013', 'CT003', 'Samsung Galaxy S20 FE', 1150.0, 170),
('PT014', 'CT004', 'iPhone 11 Pro', 2200.0, 170),
('PT015', 'CT005', 'Realme 7 Pro', 1100.0, 200)

INSERT INTO PurchaseHeader (PurchaseID, StaffID, VendorID, PurchaseDate)
VALUES 
('PH001', 'ST001', 'VR010', '2023-01-20'),
('PH002', 'ST002', 'VR009', '2023-02-21'),
('PH003', 'ST003', 'VR008', '2023-03-22'),
('PH004', 'ST004', 'VR007', '2023-04-23'),
('PH005', 'ST005', 'VR006', '2023-05-24'),
('PH006', 'ST006', 'VR005', '2023-06-25'),
('PH007', 'ST007', 'VR004', '2023-07-26'),
('PH008', 'ST008', 'VR003', '2023-08-27'),
('PH009', 'ST009', 'VR002', '2023-09-28'),
('PH010', 'ST010', 'VR001', '2023-10-29'),
('PH011', 'ST001', 'VR001', '2024-12-01'),
('PH012', 'ST002', 'VR002', '2024-11-02'),
('PH013', 'ST003', 'VR003', '2024-10-03'),
('PH014', 'ST004', 'VR004', '2024-09-04'),
('PH015', 'ST005', 'VR005', '2024-08-05'),
('PH016', 'ST006', 'VR005', '2024-11-20'),
('PH017', 'ST007', 'VR004', '2024-12-21'),
('PH018', 'ST008', 'VR003', '2024-01-22'),
('PH019', 'ST009', 'VR002', '2024-02-23'),
('PH020', 'ST010', 'VR001', '2024-03-24'),
('PH021', 'ST001', 'VR002', '2024-03-24'),
('PH022', 'ST002', 'VR003', '2021-02-15'),
('PH023', 'ST003', 'VR004', '2023-03-24'),
('PH024', 'ST004', 'VR005', '2024-08-24'),
('PH025', 'ST005', 'VR001', '2023-03-22')

INSERT INTO SaleHeader (SaleID, StaffID, CustomerID, TransactionDate)
VALUES
('SH001', 'ST001', 'CU001', '2024-02-21'),
('SH002', 'ST002', 'CU002', '2024-02-22'),
('SH003', 'ST003', 'CU003', '2024-02-23'),
('SH004', 'ST004', 'CU004', '2024-04-24'),
('SH005', 'ST005', 'CU005', '2023-04-25'),
('SH006', 'ST006', 'CU006', '2023-04-26'),
('SH007', 'ST007', 'CU007', '2023-04-27'),
('SH008', 'ST008', 'CU008', '2024-08-28'),
('SH009', 'ST009', 'CU009', '2024-09-29'),
('SH010', 'ST010', 'CU010', '2024-06-30'),
('SH011', 'ST001', 'CU001', '2024-07-02'),
('SH012', 'ST002', 'CU002', '2024-07-03'),
('SH013', 'ST003', 'CU003', '2024-10-04'),
('SH014', 'ST004', 'CU004', '2024-07-05'),
('SH015', 'ST005', 'CU005', '2024-08-06'),
('SH016', 'ST006', 'CU006', '2024-11-20'),
('SH017', 'ST007', 'CU007', '2024-12-21'),
('SH018', 'ST008', 'CU008', '2023-01-22'),
('SH019', 'ST009', 'CU009', '2023-02-23'),
('SH020', 'ST010', 'CU010', '2023-04-24'),
('SH021', 'ST001', 'CU001', '2023-04-22'),
('SH022', 'ST002', 'CU002', '2023-04-24'),
('SH023', 'ST003', 'CU003', '2023-04-24'),
('SH024', 'ST004', 'CU004', '2024-01-24'),
('SH025', 'ST005', 'CU005', '2023-03-24')

INSERT INTO PurchaseDetail (PurchaseID, ProductID, Quantity)
VALUES
('PH001', 'PT001', 6),
('PH002', 'PT002', 3),
('PH003', 'PT003', 3),
('PH004', 'PT004', 4),
('PH005', 'PT005', 2),
('PH006', 'PT006', 5),
('PH007', 'PT007', 3),
('PH008', 'PT008', 2),
('PH009', 'PT009', 6),
('PH010', 'PT010', 2),
('PH011', 'PT011', 3),
('PH012', 'PT012', 5),
('PH013', 'PT013', 4),
('PH014', 'PT014', 3),
('PH015', 'PT015', 2),
('PH016', 'PT001', 5),
('PH017', 'PT002', 2),
('PH018', 'PT003', 3),
('PH019', 'PT004', 5),
('PH020', 'PT005', 4),
('PH021', 'PT006', 5),
('PH022', 'PT007', 4),
('PH023', 'PT008', 2),
('PH024', 'PT009', 3),
('PH025', 'PT001', 3),
('PH025', 'PT002', 2),
('PH025', 'PT008', 1),
('PH001', 'PT011', 5),
('PH002', 'PT012', 6),
('PH003', 'PT013', 2),
('PH004', 'PT001', 7),
('PH005', 'PT002', 4),
('PH006', 'PT003', 7),
('PH007', 'PT008', 2),
('PH008', 'PT009', 4),
('PH009', 'PT004', 6),
('PH010', 'PT002', 5),
('PH011', 'PT015', 3),
('PH012', 'PT014', 6),
('PH013', 'PT012', 5),
('PH014', 'PT015', 4),
('PH015', 'PT006', 6)



INSERT INTO SaleDetail (SaleID, ProductID, Quantity)
VALUES
('SH001', 'PT001', 2),
('SH002', 'PT002', 3),
('SH003', 'PT003', 5),
('SH004', 'PT004', 4),
('SH005', 'PT005', 5),
('SH006', 'PT006', 7),
('SH007', 'PT007', 3),
('SH008', 'PT008', 2),
('SH009', 'PT009', 6),
('SH010', 'PT010', 2),
('SH011', 'PT011', 3),
('SH005', 'PT014', 6),
('SH012', 'PT012', 4),
('SH013', 'PT013', 2),
('SH014', 'PT014', 3),
('SH015', 'PT015', 2),
('SH016', 'PT001', 4),
('SH017', 'PT002', 2),
('SH018', 'PT003', 3),
('SH019', 'PT004', 6),
('SH020', 'PT005', 4),
('SH021', 'PT006', 3),
('SH022', 'PT007', 4),
('SH023', 'PT008', 3),
('SH024', 'PT009', 2),
('SH025', 'PT007', 5),
('SH025', 'PT006', 5),
('SH001', 'PT011', 5),
('SH002', 'PT012', 6),
('SH003', 'PT013', 2),
('SH004', 'PT001', 7),
('SH005', 'PT002', 4),
('SH006', 'PT003', 7),
('SH007', 'PT008', 2),
('SH008', 'PT009', 4),
('SH009', 'PT004', 6),
('SH010', 'PT002', 5),
('SH011', 'PT015', 3),
('SH012', 'PT014', 6),
('SH013', 'PT012', 5),
('SH014', 'PT015', 4),
('SH015', 'PT006', 6)

SELECT * FROM PurchaseHeader
SELECT * FROM PurchaseDetail
SELECT * FROM SaleHeader
SELECT * FROM SaleDetail
