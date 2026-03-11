DROP TABLE IF EXISTS dbo.StockMovement;
DROP TABLE IF EXISTS dbo.Inventory;
DROP TABLE IF EXISTS dbo.OrderLine;
DROP TABLE IF EXISTS dbo.Orders;
DROP TABLE IF EXISTS dbo.Customer;
DROP TABLE IF EXISTS dbo.Product;
DROP TABLE IF EXISTS dbo.AuditLog;
GO

CREATE TABLE dbo.Customer (
  CustomerId   int IDENTITY PRIMARY KEY,
  FullName     varchar(80) NOT NULL,
  Email        varchar(120) NOT NULL UNIQUE,
  Status       varchar(20) NOT NULL DEFAULT 'active',
  CreatedAt    datetime2 NOT NULL DEFAULT sysdatetime()
);
GO

CREATE TABLE dbo.Product (
  ProductId    int IDENTITY PRIMARY KEY,
  SKU          varchar(20) NOT NULL UNIQUE,
  Name         varchar(80) NOT NULL,
  Price        decimal(10,2) NOT NULL,
  PriceSince   date NOT NULL,
  IsActive     bit NOT NULL DEFAULT 1
);
GO

CREATE TABLE dbo.Inventory (
  ProductId    int NOT NULL PRIMARY KEY,
  Stock        int NOT NULL,
  Capacity     int NOT NULL,
  CONSTRAINT FK_Inventory_Product FOREIGN KEY (ProductId) REFERENCES dbo.Product(ProductId)
);
GO

CREATE TABLE dbo.Orders (
  OrderId      int IDENTITY PRIMARY KEY,
  CustomerId   int NOT NULL,
  OrderDate    date NOT NULL DEFAULT cast(getdate() as date),
  Status       varchar(20) NOT NULL DEFAULT 'open',
  TotalAmount  decimal(10,2) NOT NULL DEFAULT 0,
  CONSTRAINT FK_Orders_Customer FOREIGN KEY (CustomerId) REFERENCES dbo.Customer(CustomerId)
);
GO

CREATE TABLE dbo.OrderLine (
  OrderId      int NOT NULL,
  OrderLineNo  int NOT NULL,
  ProductId    int NOT NULL,
  Qty          int NOT NULL,
  UnitPrice    decimal(10,2) NOT NULL,
  LineAmount   decimal(10,2) DEFAULT 0,
  CONSTRAINT PK_OrderLine PRIMARY KEY (OrderId, OrderLineNo),
  CONSTRAINT FK_OrderLine_Orders FOREIGN KEY (OrderId) REFERENCES dbo.Orders(OrderId),
  CONSTRAINT FK_OrderLine_Product FOREIGN KEY (ProductId) REFERENCES dbo.Product(ProductId)
);
GO

CREATE TABLE dbo.StockMovement (
  MoveId       int IDENTITY PRIMARY KEY,
  ProductId    int NOT NULL,
  MoveDate     datetime2 NOT NULL DEFAULT sysdatetime(),
  QtyChange    int NOT NULL,
  Reason       varchar(40) NOT NULL,
  RefOrderId   int NULL,
  CONSTRAINT FK_StockMovement_Product FOREIGN KEY (ProductId) REFERENCES dbo.Product(ProductId)
);
GO

CREATE TABLE dbo.AuditLog (
  AuditId      int IDENTITY PRIMARY KEY,
  EventTime    datetime2 NOT NULL DEFAULT sysdatetime(),
  Entity       varchar(30) NOT NULL,
  Action       varchar(10) NOT NULL,
  KeyInfo      varchar(100) NULL,
  Info         varchar(200) NULL
);
GO

INSERT INTO dbo.Customer (FullName, Email, Status) VALUES
('Anna Muster', 'anna@example.com', 'active'),
('Boris Beispiel', 'boris@example.com', 'active'),
('Clara Demo', 'clara@example.com', 'blocked'),
('David Test', 'david@example.com', 'active');
GO

INSERT INTO dbo.Product (SKU, Name, Price, PriceSince, IsActive) VALUES
('BK-001', 'SQL Basics', 29.90, '2025-01-01', 1),
('BK-002', 'Trigger Deep Dive', 39.90, '2025-02-01', 1),
('BK-003', 'Index Tuning', 49.90, '2025-03-01', 1),
('BK-004', 'Legacy Systems', 19.90, '2025-01-15', 0);
GO

INSERT INTO dbo.Inventory (ProductId, Stock, Capacity)
SELECT ProductId,
       CASE SKU
         WHEN 'BK-001' THEN 30
         WHEN 'BK-002' THEN 20
         WHEN 'BK-003' THEN 10
         WHEN 'BK-004' THEN 5
       END,
       CASE SKU
         WHEN 'BK-001' THEN 100
         WHEN 'BK-002' THEN 50
         WHEN 'BK-003' THEN 30
         WHEN 'BK-004' THEN 10
       END
FROM dbo.Product;
GO

INSERT INTO dbo.Orders (CustomerId, OrderDate, Status) VALUES
(1, '2026-02-10', 'open'),
(2, '2026-02-12', 'open');
GO

INSERT INTO dbo.OrderLine (OrderId, OrderLineNo, ProductId, Qty, UnitPrice) VALUES
(1, 1, 1, 2, 29.90),
(1, 2, 2, 1, 39.90);
GO

INSERT INTO dbo.OrderLine (OrderId, OrderLineNo, ProductId, Qty, UnitPrice) VALUES
(2, 1, 3, 1, 49.90);
GO

INSERT INTO dbo.StockMovement (ProductId, QtyChange, Reason, RefOrderId) VALUES
(1, -2, 'order', 1),
(2, -1, 'order', 1),
(3, -1, 'order', 2);
GO
