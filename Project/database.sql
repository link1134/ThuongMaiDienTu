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
                                   AddressDetail NVARCHAR(255) NOT NULL,
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

--Carts: Mỗi User có 1 giỏ hàng duy nhất đang active
CREATE TABLE dbo.Carts (
                           CartId INT IDENTITY(1,1) PRIMARY KEY,
                           UserId INT NOT NULL UNIQUE, -- Đảm bảo quan hệ 1-1 giữa User và Cart hiện tại
                           CreatedAt DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
                           UpdatedAt DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
                           CONSTRAINT FK_Carts_Users FOREIGN KEY (UserId) REFERENCES dbo.Users(Id) ON DELETE CASCADE
);
GO

-- Bảng CartItems: Chứa các sản phẩm trong giỏ hàng
CREATE TABLE dbo.CartItems (
                               CartItemId INT IDENTITY(1,1) PRIMARY KEY,
                               CartId INT NOT NULL,
                               ListingId INT NOT NULL,
                               Quantity INT NOT NULL DEFAULT 1,
                               AddedAt DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
                               CONSTRAINT FK_CartItems_Carts FOREIGN KEY (CartId) REFERENCES dbo.Carts(CartId) ON DELETE CASCADE,
                               CONSTRAINT FK_CartItems_Listings FOREIGN KEY (ListingId) REFERENCES dbo.Listings(ListingId) ON DELETE CASCADE,
                               CONSTRAINT UQ_CartItems_Cart_Listing UNIQUE (CartId, ListingId), -- Tránh trùng lặp 1 sản phẩm trong 1 giỏ
                               CONSTRAINT CK_CartItems_Quantity CHECK (Quantity > 0)
);
GO
CREATE TABLE dbo.Orders (
                            OrderId INT IDENTITY(1,1) PRIMARY KEY,
                            UserId INT NOT NULL,
                            RecipientName NVARCHAR(100) NOT NULL,
                            PhoneNumber NVARCHAR(20) NOT NULL,
                            ShippingAddress NVARCHAR(500) NOT NULL,
                            ShippingFee DECIMAL(18,2) NOT NULL DEFAULT 0,
                            TotalAmount DECIMAL(18,2) NOT NULL,
                            PaymentMethod NVARCHAR(50) NOT NULL DEFAULT N'COD',
                            DeliveryMethod NVARCHAR(100) NOT NULL DEFAULT N'Vận chuyển nhanh',
                            Status NVARCHAR(30) NOT NULL DEFAULT N'Pending', -- Pending, Processing, Shipping, Completed, Cancelled
                            CreatedAt DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
                            UpdatedAt DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
                            CONSTRAINT FK_Orders_Users FOREIGN KEY (UserId) REFERENCES dbo.Users(Id)
);
GO

-- Bảng OrderDetails: Lưu từng chi tiết sản phẩm trong đơn hàng
CREATE TABLE dbo.OrderDetails (
                                  OrderDetailId INT IDENTITY(1,1) PRIMARY KEY,
                                  OrderId INT NOT NULL,
                                  ListingId INT NOT NULL,
                                  Quantity INT NOT NULL DEFAULT 1,
                                  Price DECIMAL(18,2) NOT NULL, -- Giá tại thời điểm mua
                                  CONSTRAINT FK_OrderDetails_Orders FOREIGN KEY (OrderId) REFERENCES dbo.Orders(OrderId) ON DELETE CASCADE,
                                  CONSTRAINT FK_OrderDetails_Listings FOREIGN KEY (ListingId) REFERENCES dbo.Listings(ListingId)
);
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