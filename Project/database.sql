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
IF OBJECT_ID(N'dbo.CategoryPublishers', N'U') IS NOT NULL DROP TABLE dbo.CategoryPublishers;
IF OBJECT_ID(N'dbo.CategoryPublisher', N'U') IS NOT NULL DROP TABLE dbo.CategoryPublisher;
IF OBJECT_ID(N'dbo.Categories', N'U') IS NOT NULL DROP TABLE dbo.Categories;
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
    CreatedAt DATETIME2 NOT NULL CONSTRAINT DF_Users_CreatedAt DEFAULT SYSDATETIME()
);
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
--BẢNG PUBLISHER - NHÀ XUẤT BẢN
CREATE TABLE dbo.Publishers (
                                PublisherID INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_Publishers PRIMARY KEY,
                                PublisherCode VARCHAR(20) NOT NULL CONSTRAINT UQ_Publishers_Code UNIQUE,
                                PublisherName NVARCHAR(150) NOT NULL,
                                Country NVARCHAR(100) NULL,
                                Description NVARCHAR(500) NULL,
                                Website VARCHAR(255) NULL,
                                LogoURL VARCHAR(500) NULL,
                                FoundedYear SMALLINT NULL,
                                Status BIT NOT NULL CONSTRAINT DF_Publishers_Status DEFAULT 1, -- 1: Hiển thị, 0: Ẩn
                                CreatedAt DATETIME2 NOT NULL CONSTRAINT DF_Publishers_CreatedAt DEFAULT SYSDATETIME(),
                                UpdatedAt DATETIME2 NULL
);
GO
INSERT INTO dbo.Publishers (PublisherCode, PublisherName, Country, Description, Website, FoundedYear, Status)
VALUES
    ('PUB-VN-01', N'NXB Kim Đồng', N'Việt Nam', N'Nhà xuất bản sách, truyện tranh hàng đầu Việt Nam.', 'https://nxbkimdong.com.vn', 1957, 1),
    ('PUB-VN-02', N'NXB Trẻ', N'Việt Nam', N'Đơn vị xuất bản uy tín với nhiều bộ manga bản quyền.', 'https://nxbtre.com.vn', 1981, 1),
    ('PUB-JP-01', N'Shueisha', N'Nhật Bản', N'Tập đoàn xuất bản sở hữu tạp chí Weekly Shōnen Jump.', 'https://www.shueisha.co.jp', 1925, 1),
    ('PUB-JP-02', N'Kodansha', N'Nhật Bản', N'Nhà xuất bản lớn nhất Nhật Bản.', 'https://www.kodansha.co.jp', 1909, 1),
    ('PUB-JP-03', N'Shogakukan', N'Nhật Bản', N'NXB sở hữu các tạp chí Shōnen Sunday, Big Comic.', 'https://www.shogakukan.co.jp', 1922, 1),
    ('PUB-JP-04', N'Square Enix Gangan', N'Nhật Bản', N'Đơn vị phát hành manga qua thương hiệu Gangan Comics.', 'https://magazine.jp.square-enix.com', 1991, 1),
    ('PUB-JP-05', N'Kadokawa', N'Nhật Bản', N'Tập đoàn truyền thông và xuất bản lớn của Nhật Bản.', 'https://www.kadokawa.co.jp', 1945, 1),
    ('PUB-JP-06', N'Hakusensha', N'Nhật Bản', N'NXB chuyên các dòng manga Shojo và Josei nổi tiếng.', 'https://www.hakusensha.co.jp', 1973, 1);
GO
--BẢNG CATEGORY - DANH MỤC THỂ LOẠI
CREATE TABLE dbo.Categories (
                                CategoryID INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_Categories PRIMARY KEY,
                                CategoryCode VARCHAR(20) NOT NULL CONSTRAINT UQ_Categories_Code UNIQUE,
                                CategoryName NVARCHAR(100) NOT NULL,
                                Description NVARCHAR(500) NULL,
                                ParentCategoryID INT NULL,
                                Status BIT NOT NULL CONSTRAINT DF_Categories_Status DEFAULT 1, -- 1: Hiển thị, 0: Ẩn
                                CreatedAt DATETIME2 NOT NULL CONSTRAINT DF_Categories_CreatedAt DEFAULT SYSDATETIME(),
                                UpdatedAt DATETIME2 NULL,
                                CONSTRAINT FK_Categories_Parent FOREIGN KEY (ParentCategoryID) REFERENCES dbo.Categories(CategoryID)
);
GO
--BẢNG CATEGORY_PUBLISHER
CREATE TABLE dbo.CategoryPublisher (
                                       CategoryID INT NOT NULL,
                                       PublisherID INT NOT NULL,
                                       CONSTRAINT PK_CategoryPublisher PRIMARY KEY (CategoryID, PublisherID),
                                       CONSTRAINT FK_CategoryPublisher_Categories FOREIGN KEY (CategoryID) REFERENCES dbo.Categories(CategoryID) ON DELETE CASCADE,
                                       CONSTRAINT FK_CategoryPublisher_Publishers FOREIGN KEY (PublisherID) REFERENCES dbo.Publishers(PublisherID) ON DELETE CASCADE
);
GO
-- Định dạng ấn phẩm (Tankobon, Boxset, Limited Edition...
CREATE TABLE dbo.ComicFormats (
                                  FormatID INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_ComicFormats PRIMARY KEY,
                                  FormatName NVARCHAR(100) NOT NULL,
                                  Description NVARCHAR(255) NULL,
                                  Status BIT NOT NULL DEFAULT 1
);
-- Tiêu chuẩn giám định CGC / CBCS
CREATE TABLE dbo.GradingStandards (
                                      StandardID INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_GradingStandards PRIMARY KEY,
                                      OrganizationName VARCHAR(50) NOT NULL, -- VD: CGC, CBCS
                                      GradeValue VARCHAR(20) NOT NULL,       -- VD: 9.8, 9.0
                                      Description NVARCHAR(255) NULL
);
-- Tình trạng truyện (Brand New, Like New, Used...)
CREATE TABLE dbo.Conditions (
                                ConditionID INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_Conditions PRIMARY KEY,
                                ConditionName NVARCHAR(100) NOT NULL,
                                Description NVARCHAR(255) NULL
);
GO
