IF DB_ID(N'MangaZ') IS NULL
    BEGIN
        CREATE DATABASE MangaZ;
    END
GO
USE MangaZ;
GO

IF OBJECT_ID(N'dbo.PasswordResetTokens', N'U') IS NOT NULL DROP TABLE dbo.PasswordResetTokens;
IF OBJECT_ID(N'dbo.EmailVerificationTokens', N'U') IS NOT NULL DROP TABLE dbo.EmailVerificationTokens;
IF OBJECT_ID(N'dbo.Users', N'U') IS NOT NULL DROP TABLE dbo.Users;
IF OBJECT_ID(N'dbo.ProductTypePublishers', N'U') IS NOT NULL DROP TABLE dbo.ProductTypePublishers;
IF OBJECT_ID(N'dbo.ProductTypePublisher', N'U') IS NOT NULL DROP TABLE dbo.ProductTypePublisher;
IF OBJECT_ID(N'dbo.ProductType', N'U') IS NOT NULL DROP TABLE dbo.ProductType;
IF OBJECT_ID(N'dbo.Publishers', N'U') IS NOT NULL DROP TABLE dbo.Publishers;
IF OBJECT_ID(N'dbo.ComicFormats', N'U') IS NOT NULL DROP TABLE dbo.ComicFormats;
IF OBJECT_ID(N'dbo.GradingStandards', N'U') IS NOT NULL DROP TABLE dbo.GradingStandards;
IF OBJECT_ID(N'dbo.Conditions', N'U') IS NOT NULL DROP TABLE dbo.Conditions;
GO
GO

CREATE TABLE dbo.Users (
                           Id INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_Users PRIMARY KEY,
                           Username NVARCHAR(50) NOT NULL CONSTRAINT UQ_Users_Username UNIQUE,
                           Email NVARCHAR(255) NOT NULL CONSTRAINT UQ_Users_Email UNIQUE,
                           Password NVARCHAR(255) NOT NULL,
                           FullName NVARCHAR(100) NULL,
                           EmailVerified BIT NOT NULL CONSTRAINT DF_Users_EmailVerified DEFAULT 0,
                           Enabled BIT NOT NULL CONSTRAINT DF_Users_Enabled DEFAULT 1,
                           CreatedAt DATETIME2 NOT NULL CONSTRAINT DF_Users_CreatedAt DEFAULT SYSDATETIME(),
						   AvatarUrl NVARCHAR(500) NULL,
							PhoneNumber NVARCHAR(20) NULL,
							DateOfBirth DATE NULL,
							Gender NVARCHAR(20) NULL,
							UpdatedAt DATETIME2 NULL,
							Role NVARCHAR(10) NOT NULL DEFAULT N'User'
);
ALTER TABLE Users
ADD CONSTRAINT CK_Users_Role
 CHECK (Role IN (N'Admin', N'User'));
GO
CREATE TABLE dbo.EmailVerificationTokens (
                                             Id INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_EmailVerificationTokens PRIMARY KEY,
                                             UserId INT NOT NULL,
                                             Token NVARCHAR(255) NOT NULL CONSTRAINT UQ_EmailVerificationTokens_Token UNIQUE,
                                             ExpiresAt DATETIME2 NOT NULL,
                                             CONSTRAINT FK_EmailVerificationTokens_Users FOREIGN KEY (UserId) REFERENCES dbo.Users(Id) ON DELETE CASCADE
);
GO
CREATE TABLE dbo.PasswordResetTokens (
                                         Id INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_PasswordResetTokens PRIMARY KEY,
                                         UserId INT NOT NULL,
                                         Token NVARCHAR(255) NOT NULL CONSTRAINT UQ_PasswordResetTokens_Token UNIQUE,
                                         ExpiresAt DATETIME2 NOT NULL,
                                         CONSTRAINT FK_PasswordResetTokens_Users FOREIGN KEY (UserId) REFERENCES dbo.Users(Id) ON DELETE CASCADE
);
GO
CREATE INDEX IX_EmailVerificationTokens_UserId ON dbo.EmailVerificationTokens(UserId);
CREATE INDEX IX_PasswordResetTokens_UserId ON dbo.PasswordResetTokens(UserId);
GO

CREATE TABLE DeliveryAddresses (
                                   Id INT IDENTITY(1,1) PRIMARY KEY,
                                   UserId INT NOT NULL,
                                   RecipientName NVARCHAR(100) NOT NULL,
                                   PhoneNumber NVARCHAR(20) NOT NULL,
                                   ProvinceCode INT NULL,
                                   CityProvince NVARCHAR(100) NOT NULL,
                                   WardCode INT NULL,
                                   Ward NVARCHAR(100) NOT NULL,
                                   AddressDetail NVARCHAR(500) NOT NULL,
                                   IsDefault BIT NOT NULL DEFAULT 0,
                                   CONSTRAINT FK_DeliveryAddresses_Users
                                       FOREIGN KEY (UserId) REFERENCES Users(Id)
);


-- 1. Loai san pham
CREATE TABLE dbo.ProductType(
    ProductTypeId INT IDENTITY(1,1) PRIMARY KEY,
    ProductTypeName NVARCHAR(100) NOT NULL UNIQUE,
    Description NVARCHAR(500) NULL,
    IsActive BIT NOT NULL DEFAULT 1,
	CreatedAt DATETIME2 NOT NULL CONSTRAINT DF_ProductType_CreatedAt DEFAULT SYSDATETIME(),
	UpdatedAt DATETIME2 NULL,
);
GO

-- 2. Dinh nghia thuoc tinh
CREATE TABLE dbo.AttributeDefinitions (
    AttributeId INT IDENTITY(1,1) PRIMARY KEY,
    AttributeName NVARCHAR(100) NOT NULL,
    DataType VARCHAR(20) NOT NULL,
    Unit NVARCHAR(30) NULL,
    Description NVARCHAR(500) NULL,
    IsActive BIT NOT NULL DEFAULT 1,
    CONSTRAINT CK_AttributeDefinitions_DataType
        CHECK (DataType IN ('Text', 'Number', 'Boolean', 'Date'))
);
GO

-- 3. Thuoc tinh ap dung cho tung loai san pham
CREATE TABLE dbo.ProductTypeAttributes (
    ProductTypeId INT NOT NULL,
    AttributeId INT NOT NULL,
    IsRequired BIT NOT NULL DEFAULT 0,
    DisplayOrder INT NOT NULL DEFAULT 0,
    CONSTRAINT PK_ProductTypeAttributes
        PRIMARY KEY (ProductTypeId, AttributeId),
    CONSTRAINT FK_ProductTypeAttributes_ProductType
        FOREIGN KEY (ProductTypeId)
        REFERENCES dbo.ProductType(ProductTypeId),
    CONSTRAINT FK_ProductTypeAttributes_AttributeDefinitions
        FOREIGN KEY (AttributeId)
        REFERENCES dbo.AttributeDefinitions(AttributeId)
);
GO

-- 4. Bai dang san pham
CREATE TABLE dbo.Listings (
    ListingId INT IDENTITY(1,1) PRIMARY KEY,
    ListingCode VARCHAR(30) NOT NULL UNIQUE,
    SellerId INT NOT NULL,
    ProductTypeId INT NOT NULL,
    Title NVARCHAR(200) NOT NULL,
    Description NVARCHAR(MAX) NULL,
	ShortDescription NVARCHAR(500) NULL,
    Price DECIMAL(18,2) NULL,
    OriginalPrice DECIMAL(18,2) NULL,
    Quantity INT NOT NULL DEFAULT 1,
    ListingType VARCHAR(20) NOT NULL DEFAULT 'Sale',
    Status VARCHAR(20) NOT NULL DEFAULT 'Draft',
    CreatedAt DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
    UpdatedAt DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
    CONSTRAINT FK_Listings_Users
        FOREIGN KEY (SellerId)
        REFERENCES dbo.Users(Id),
    CONSTRAINT FK_Listings_ProductType
        FOREIGN KEY (ProductTypeId)
        REFERENCES dbo.ProductType(ProductTypeId),
    CONSTRAINT CK_Listings_Price
        CHECK (Price IS NULL OR Price >= 0),
    CONSTRAINT CK_Listings_OriginalPrice
        CHECK (OriginalPrice IS NULL OR OriginalPrice >= 0),
    CONSTRAINT CK_Listings_Quantity
        CHECK (Quantity > 0),
    CONSTRAINT CK_Listings_ListingType
        CHECK (ListingType IN ('Sale', 'Auction', 'Trade')),
    CONSTRAINT CK_Listings_Status
        CHECK (Status IN (
            'Draft',
            'Pending',
            'Active',
            'Rejected',
            'Hidden',
            'Sold',
            'Cancelled'
        ))
);
GO


-- 5. Gia tri thuoc tinh cua tung bai dang
CREATE TABLE dbo.ListingAttributeValues (
    ListingId INT NOT NULL,
    AttributeId INT NOT NULL,
    ValueText NVARCHAR(MAX) NOT NULL,
    CONSTRAINT PK_ListingAttributeValues
        PRIMARY KEY (ListingId, AttributeId),
    CONSTRAINT FK_ListingAttributeValues_Listings
        FOREIGN KEY (ListingId)
        REFERENCES dbo.Listings(ListingId),
    CONSTRAINT FK_ListingAttributeValues_Attributes
        FOREIGN KEY (AttributeId)
        REFERENCES dbo.AttributeDefinitions(AttributeId)
);
GO

-- 6. Anh san pham
CREATE TABLE dbo.ListingImages (
    ImageId INT IDENTITY(1,1) PRIMARY KEY,
    ListingId INT NOT NULL,
    ImageUrl NVARCHAR(500) NOT NULL,
    DisplayOrder INT NOT NULL DEFAULT 0,
    IsPrimary BIT NOT NULL DEFAULT 0,
    CONSTRAINT FK_ListingImages_Listings
        FOREIGN KEY (ListingId)
        REFERENCES dbo.Listings(ListingId),
    CONSTRAINT CK_ListingImages_DisplayOrder
        CHECK (DisplayOrder >= 0)
);
GO

-- Index ho tro truy van danh sach bai dang
CREATE INDEX IX_Listings_ProductType_Status
    ON dbo.Listings(ProductTypeId, Status);
CREATE INDEX IX_Listings_Seller_CreatedAt
    ON dbo.Listings(SellerId, CreatedAt DESC);
CREATE INDEX IX_ListingAttributeValues_AttributeId
    ON dbo.ListingAttributeValues(AttributeId);
CREATE INDEX IX_ListingImages_ListingId
    ON dbo.ListingImages(ListingId);
GO
USE MangaZ;
GO

BEGIN TRY
    BEGIN TRANSACTION;

    DECLARE @SellerId INT;
    DECLARE @ProductTypeId INT;
    DECLARE @ListingId INT;

    -- 1. Tìm người bán có sẵn
    SELECT TOP 1 @SellerId = Id
    FROM dbo.Users
    ORDER BY Id;

    -- Nếu chưa có người dùng, tạo tài khoản mẫu
    IF @SellerId IS NULL
    BEGIN
        INSERT INTO dbo.Users
            (Username, Email, Password, FullName, EmailVerified, Enabled)
        VALUES
            (N'test_manga_seller',
             N'test_manga_seller@example.com',
             N'test-password-not-for-login',
             N'Người bán thử nghiệm',
             1,
             1);

        SET @SellerId = SCOPE_IDENTITY();
    END;

    -- 2. Tìm danh mục có sẵn
    SELECT TOP 1 @ProductTypeId = ProductTypeId
    FROM dbo.ProductType
    ORDER BY ProductTypeId;

    -- Nếu chưa có danh mục, tạo danh mục mẫu
    IF @ProductTypeId IS NULL
    BEGIN
        INSERT INTO dbo.ProductType
            (ProductTypeName, Description, IsActive)
        VALUES
            (N'Manga', N'Danh mục manga dùng để kiểm thử', 1);

        SET @ProductTypeId = SCOPE_IDENTITY();
    END;

    -- 3. Tìm bài đăng mẫu nếu đã tạo trước đó
    SELECT @ListingId = ListingId
    FROM dbo.Listings
    WHERE ListingCode = 'TEST-MANGA-001';

    -- Nếu chưa có thì tạo bài đăng
    IF @ListingId IS NULL
    BEGIN
        INSERT INTO dbo.Listings
        (
            ListingCode,
            SellerId,
            ProductTypeId,
            Title,
            Description,
            Price,
            OriginalPrice,
            Quantity,
            ListingType,
            Status
        )
        VALUES
        (
            'TEST-MANGA-001',
            @SellerId,
            @ProductTypeId,
            N'Chuyển Sinh Thành Slime - Tập 1',
            N'Manga còn đẹp, gáy sách nguyên vẹn, trang giấy sạch và không bị rách. Phù hợp cho người sưu tầm hoặc đọc giải trí.',
            65000,
            85000,
            5,
            'Sale',
            'Active'
        );

        SET @ListingId = SCOPE_IDENTITY();
    END;

    -- 4. Thêm ảnh mẫu nếu bài đăng chưa có ảnh
    IF NOT EXISTS (
        SELECT 1
        FROM dbo.ListingImages
        WHERE ListingId = @ListingId
    )
    BEGIN
        INSERT INTO dbo.ListingImages
            (ListingId, ImageUrl, DisplayOrder, IsPrimary)
        VALUES
            (@ListingId, N'/ThuongMaiDienTu/images/products/5Z6uRBNOaa6oUzQ3uD1XQLnvvQv.jpg', 0, 1),
			(@ListingId, N'/ThuongMaiDienTu/images/products/OIP.jpg', 1, 0),
			(@ListingId, N'/ThuongMaiDienTu/images/products/OIP (1).jpg', 2, 0);
    END;
    COMMIT TRANSACTION;
    -- Hiển thị ID để bạn mở trang chi tiết
    SELECT
        @ListingId AS ListingId,
        N'Chuyển Sinh Thành Slime - Tập 1' AS ProductTitle,
        N'http://localhost:8080/ThuongMaiDienTu/product-detail?id='
            + CAST(@ListingId AS NVARCHAR(20)) AS TestUrl;

END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION;

    THROW;
END CATCH;
GO


USE MangaZ;
GO

-- Lấy một người dùng có sẵn để làm người bán
DECLARE @SellerId INT;
DECLARE @ProductTypeId INT;

SELECT TOP 1 @SellerId = Id
FROM dbo.Users
ORDER BY Id;

SELECT TOP 1 @ProductTypeId = ProductTypeId
FROM dbo.ProductType
ORDER BY ProductTypeId;

-- Kiểm tra dữ liệu khóa ngoại
IF @SellerId IS NULL OR @ProductTypeId IS NULL
BEGIN
    THROW 50001,
        N'Cần có ít nhất một User và một ProductType trước khi thêm listing.',
        1;
END;

-- Dữ liệu mẫu và URL ảnh minh họa
DECLARE @Seed TABLE (
    ListingCode NVARCHAR(50),
    Title NVARCHAR(255),
    ShortDescription NVARCHAR(500),
    Description NVARCHAR(MAX),
    Price DECIMAL(18,2),
    OriginalPrice DECIMAL(18,2),
    Quantity INT,
    ListingType NVARCHAR(20),
    ImageUrl NVARCHAR(1000)
);

INSERT INTO @Seed VALUES

(
    'TEST-MANGA-002',
    N'Doraemon tập 2 - còn đẹp',
    N'Truyện được bảo quản cẩn thận.',
    N'Doraemon tập 2, ruột sách sạch, gáy còn chắc chắn.',
    18000, 20000, 1, 'Sale',
    'https://picsum.photos/seed/mangaz02/400/600'
),
(
    'TEST-MANGA-003',
    N'Doraemon tuyển tập truyện ngắn',
    N'Tuyển tập truyện ngắn dành cho người sưu tầm.',
    N'Tuyển tập Doraemon, phù hợp để đọc giải trí hoặc bổ sung bộ sưu tập.',
    45000, 55000, 1, 'Sale',
    'https://picsum.photos/seed/mangaz03/400/600'
),
(
    'TEST-MANGA-004',
    N'One Piece tập 10',
    N'Truyện One Piece đã qua sử dụng.',
    N'Tập 10 của One Piece. Tình trạng tốt, có thể có dấu hiệu sử dụng nhẹ.',
    22000, 25000, 1, 'Sale',
    'https://picsum.photos/seed/mangaz04/400/600'
),
(
    'TEST-MANGA-005',
    N'One Piece tập 20 - đấu giá',
    N'Bài đăng đấu giá thử nghiệm.',
    N'Phiên đấu giá thử nghiệm cho One Piece tập 20. Thông tin giá dùng để kiểm tra giao diện.',
    30000, 35000, 1, 'Auction',
    'https://picsum.photos/seed/mangaz05/400/600'
),
(
    'TEST-MANGA-006',
    N'Naruto tập 5',
    N'Manga Naruto, tình trạng khá tốt.',
    N'Naruto tập 5. Bìa còn nguyên, các trang không bị thiếu.',
    20000, 25000, 1, 'Sale',
    'https://picsum.photos/seed/mangaz06/400/600'
),
(
    'TEST-MANGA-007',
    N'Naruto tập 10 - muốn trao đổi',
    N'Bài đăng trao đổi truyện.',
    N'Muốn trao đổi Naruto tập 10 với manga khác có tình trạng tương đương.',
    25000, 25000, 1, 'Trade',
    'https://picsum.photos/seed/mangaz07/400/600'
),
(
    'TEST-MANGA-008',
    N'Conan tập 15',
    N'Truyện trinh thám đã qua sử dụng.',
    N'Tập 15 của Thám tử lừng danh Conan. Sách được giữ gìn tương đối tốt.',
    18000, 22000, 1, 'Sale',
    'https://picsum.photos/seed/mangaz08/400/600'
),
(
    'TEST-MANGA-009',
    N'Bộ truyện Dragon Ball',
    N'Bộ truyện dành cho người yêu thích manga hành động.',
    N'Bài đăng bộ Dragon Ball để kiểm tra tìm kiếm các từ khóa khác nhau.',
    120000, 150000, 1, 'Sale',
    'https://picsum.photos/seed/mangaz09/400/600'
),
(
    'TEST-MANGA-010',
    N'Doraemon tập đặc biệt - đấu giá',
    N'Bài đăng đấu giá Doraemon.',
    N'Một bài đăng Doraemon khác để kiểm tra tìm kiếm nhiều kết quả cùng từ khóa.',
    40000, 45000, 1, 'Auction',
    'https://picsum.photos/seed/mangaz10/400/600'
);

-- Lưu ID của những listing vừa tạo
DECLARE @Inserted TABLE (
    ListingId INT,
    ListingCode NVARCHAR(50),
    ImageUrl NVARCHAR(1000)
);

INSERT INTO dbo.Listings (
    ListingCode,
    SellerId,
    ProductTypeId,
    Title,
    ShortDescription,
    Description,
    Price,
    OriginalPrice,
    Quantity,
    ListingType,
    Status
)
OUTPUT
    inserted.ListingId,
    inserted.ListingCode
INTO @Inserted (ListingId, ListingCode)
SELECT
    s.ListingCode,
    @SellerId,
    @ProductTypeId,
    s.Title,
    s.ShortDescription,
    s.Description,
    s.Price,
    s.OriginalPrice,
    s.Quantity,
    s.ListingType,
    'Active'
FROM @Seed s;

-- Gắn ảnh cho từng listing vừa tạo
UPDATE i
SET i.ImageUrl = s.ImageUrl
FROM @Inserted i
JOIN @Seed s ON s.ListingCode = i.ListingCode;

INSERT INTO dbo.ListingImages (
    ListingId,
    ImageUrl,
    DisplayOrder,
    IsPrimary
)
SELECT
    i.ListingId,
    i.ImageUrl,
    1,
    1
FROM @Inserted i;

-- Xem kết quả
SELECT
    l.ListingId,
    l.ListingCode,
    l.Title,
    l.Price,
    l.ListingType,
    l.Status,
    li.ImageUrl
FROM dbo.Listings l
JOIN @Inserted i ON i.ListingId = l.ListingId
LEFT JOIN dbo.ListingImages li
    ON li.ListingId = l.ListingId
    AND li.IsPrimary = 1
ORDER BY l.ListingId;
GO
