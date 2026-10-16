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
                                IsDeleted BIT NOT NULL CONSTRAINT DF_Categories_IsDeleted DEFAULT 0,
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
DELETE FROM dbo.CategoryPublisher;
DELETE FROM dbo.Categories;
DELETE FROM dbo.Publishers;
--Insert du lieu mau
INSERT INTO dbo.Publishers (PublisherCode, PublisherName, Country, Description, Website, FoundedYear, Status)
VALUES
    ('PUB-VN-01', N'NXB Kim Đồng', N'Việt Nam', N'Nhà xuất bản sách, truyện tranh hàng đầu Việt Nam dành cho thiếu nhi và giới trẻ.', 'https://nxbkimdong.com.vn', 1957, 1),
    ('PUB-VN-02', N'NXB Trẻ', N'Việt Nam', N'Đơn vị xuất bản uy tín với nhiều bộ manga bản quyền kinh điển.', 'https://nxbtre.com.vn', 1981, 1),
    ('PUB-VN-03', N'IPM', N'Việt Nam', N'Công ty truyền thông & xuất bản truyện tranh, light novel nổi tiếng.', 'https://ipm.vn', 2004, 1),
    ('PUB-VN-04', N'Nhã Nam', N'Việt Nam', N'Nhà xuất bản văn học, tiểu thuyết và manga chọn lọc.', 'https://nhanam.vn', 2005, 1),
    ('PUB-JP-01', N'Shueisha', N'Nhật Bản', N'Tập đoàn xuất bản sở hữu tạp chí Weekly Shōnen Jump và nhiều tựa manga siêu phẩm.', 'https://www.shueisha.co.jp', 1925, 1),
    ('PUB-JP-02', N'Kodansha', N'Nhật Bản', N'Nhà xuất bản lâu đời và lớn nhất Nhật Bản với Weekly Shōnen Magazine.', 'https://www.kodansha.co.jp', 1909, 1),
    ('PUB-JP-03', N'Shogakukan', N'Nhật Bản', N'NXB nổi tiếng sở hữu tạp chí Shōnen Sunday và các manga huyền thoại.', 'https://www.shogakukan.co.jp', 1922, 1),
    ('PUB-JP-04', N'Square Enix Gangan', N'Nhật Bản', N'Đơn vị phát hành manga qua thương hiệu Gangan Comics.', 'https://magazine.jp.square-enix.com', 1991, 1),
    ('PUB-JP-05', N'Kadokawa', N'Nhật Bản', N'Tập đoàn truyền thông, light novel và xuất bản manga hàng đầu Nhật Bản.', 'https://www.kadokawa.co.jp', 1945, 1),
    ('PUB-JP-06', N'Hakusensha', N'Nhật Bản', N'NXB chuyên các dòng manga Shojo và Josei nổi tiếng.', 'https://www.hakusensha.co.jp', 1973, 1);
GO

INSERT INTO dbo.Categories (CategoryCode, CategoryName, Description, ParentCategoryID, Status, IsDeleted)
VALUES
    ('CAT-SHN-01', N'Shonen Manga', N'Manga hướng tới đối tượng độc giả nam thiếu niên, tập trung vào hành động, tình bạn và sự nỗ lực.', NULL, 1, 0),
    ('CAT-SNN-02', N'Seinen Masterpieces', N'Manga dành cho nam giới trưởng thành, chủ đề sâu sắc, tâm lý và hiện thực.', NULL, 1, 0),
    ('CAT-SHJ-03', N'Shojo Vintage Classics', N'Manga dành cho nữ giới trẻ tuổi, tập trung vào tình cảm lãng mạn và mối quan hệ.', NULL, 1, 0),
    ('CAT-JOS-04', N'Josei Drama & Lifestyle', N'Manga dành cho phụ nữ trưởng thành, phản ánh cuộc sống thực tế, công việc và tình yêu.', NULL, 1, 0),
    ('CAT-ACT-05', N'Hành Động & Phiêu Lưu', N'Các bộ truyện với nhịp độ nhanh, chiến đấu gay cấn và hành trình khám phá thế giới.', NULL, 1, 0),
    ('CAT-FNT-06', N'Kỳ Ảo & Phép Thuật (Fantasy)', N'Thế giới phép thuật, rồng, quái vật và các yếu tố siêu nhiên huyền bí.', NULL, 1, 0),
    ('CAT-SCF-07', N'Viễn Tưởng & Mecha (Sci-Fi)', N'Chủ đề du hành không gian, người máy, công nghệ tương lai và dystopian.', NULL, 1, 0),
    ('CAT-SLO-08', N'Lát Cắt Cuộc Sống (Slice of Life)', N'Những câu chuyện nhẹ nhàng, đời thường, học đường và tình cảm gia đình.', NULL, 1, 0),
    ('CAT-ROM-09', N'Tình Cảm Lãng Mạn (Romance)', N'Chủ đề tình yêu ngọt ngào, những hiểu lầm hài hước và quá trình trưởng thành.', NULL, 1, 0),
    ('CAT-MYS-10', N'Trinh Thám & Bí Ẩn (Mystery)', N'Các vụ án hóc hiểm, suy luận tâm lý và giải mã những bí ẩn ly kỳ.', NULL, 1, 0),
    ('CAT-HRR-11', N'Kinh Dị & Giật Gân (Horror)', N'Yếu tố rùng rợn, giật gân, tâm lý tối sáng và thử thách lòng dũng cảm.', NULL, 1, 0),
    ('CAT-SPRT-12', N'Thể Thao & Đồng Đội (Sports)', N'Bóng đá, bóng rổ, cầu lông... đề cao tinh thần đồng đội và nỗ lực.', NULL, 1, 0),
    ('CAT-ISEK-13', N'Chuyển Sinh & Dị Giới (Isekai)', N'Nhân vật chính xuyên không/chuyển sinh sang thế giới mới với năng lực đặc biệt.', NULL, 1, 0),
    ('CAT-BOX-14', N'Boxset & Ấn Bản Đặc Biệt', N'Các bộ sưu tập trọn bộ trọn gói, bản giới hạn kèm quà tặng sưu tầm.', NULL, 1, 0),
    ('CAT-TST-15', N'Thể Loạt Tạm Ẩn Mẫu', N'Danh mục dùng để kiểm tra hiển thị trạng thái Tạm ẩn trên trang Admin.', NULL, 0, 0);
GO

INSERT INTO dbo.CategoryPublisher (CategoryID, PublisherID)
VALUES
-- Shonen Manga (ID 1): Kim Đồng (1), Shueisha (5), Kodansha (6)
(1, 1), (1, 5), (1, 6),
-- Seinen Masterpieces (ID 2): NXB Trẻ (2), Kodansha (6), Hakusensha (10)
(2, 2), (2, 6), (2, 10),
-- Shojo Vintage Classics (ID 3): Kim Đồng (1), Hakusensha (10), Shogakukan (7)
(3, 1), (3, 7), (3, 10),
-- Josei Drama & Lifestyle (ID 4): NXB Trẻ (2), Hakusensha (10)
(4, 2), (4, 10),
-- Hành Động & Phiêu Lưu (ID 5): Kim Đồng (1), IPM (3), Shueisha (5), Square Enix (8)
(5, 1), (5, 3), (5, 5), (5, 8),
-- Kỳ Ảo & Phép Thuật (ID 6): IPM (3), Kadokawa (9), Square Enix (8)
(6, 3), (6, 8), (6, 9),
-- Viễn Tưởng & Mecha (ID 7): NXB Trẻ (2), Kodansha (6)
(7, 2), (7, 6),
-- Lát Cắt Cuộc Sống (ID 8): Kim Đồng (1), Nhã Nam (4), Shogakukan (7)
(8, 1), (8, 4), (8, 7),
-- Tình Cảm Lãng Mạn (ID 9): IPM (3), Hakusensha (10), Shueisha (5)
(9, 3), (9, 5), (9, 10),
-- Trinh Thám & Bí Ẩn (ID 10): NXB Trẻ (2), Nhã Nam (4), Shogakukan (7)
(10, 2), (10, 4), (10, 7),
-- Thể Thao & Đồng Đội (ID 12): Kim Đồng (1), Shueisha (5)
(12, 1), (12, 5),
-- Chuyển Sinh & Dị Giới (ID 13): IPM (3), Kadokawa (9)
(13, 3), (13, 9);
GO
CREATE TABLE DeliveryAddresses (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    UserId INT NOT NULL,
    RecipientName NVARCHAR(100) NOT NULL,
    PhoneNumber NVARCHAR(20) NOT NULL,
    CityProvince NVARCHAR(100) NOT NULL,
    Ward NVARCHAR(100) NOT NULL,
    AddressDetail NVARCHAR(255) NULL,
    IsDefault BIT NOT NULL DEFAULT 0,

    CONSTRAINT FK_DeliveryAddresses_Users
        FOREIGN KEY (UserId) REFERENCES Users(Id)
);
ALTER TABLE Users
ADD
    AvatarUrl NVARCHAR(500) NULL,
    PhoneNumber NVARCHAR(20) NULL,
    DateOfBirth DATE NULL,
    Gender NVARCHAR(20) NULL,
    UpdatedAt DATETIME2 NULL;
ALTER TABLE Users
ADD Role NVARCHAR(10) NOT NULL
    DEFAULT N'User';

ALTER TABLE Users
ADD CONSTRAINT CK_Users_Role
CHECK (Role IN (N'Admin', N'User'));