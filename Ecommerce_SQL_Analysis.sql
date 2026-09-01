-- Elevate Labs Task 3: SQL for Data Analysis
-- Author: Pragathi
-- Database: Ecommerce_SQL_Database

-- 1. CREATE TABLES
CREATE TABLE Customers (
    CustomerID INTEGER PRIMARY KEY,
    CustomerName TEXT,
    Email TEXT,
    City TEXT,
    Country TEXT
);

CREATE TABLE Products (
    ProductID INTEGER PRIMARY KEY,
    ProductName TEXT,
    Category TEXT,
    Price REAL
);

CREATE TABLE Orders (
    OrderID INTEGER PRIMARY KEY,
    CustomerID INTEGER,
    OrderDate TEXT,
    TotalAmount REAL,
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

CREATE TABLE Order_Items (
    ItemID INTEGER PRIMARY KEY,
    OrderID INTEGER,
    ProductID INTEGER,
    Quantity INTEGER,
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

-- 2. INSERT SAMPLE DATA
INSERT INTO Customers VALUES 
(1, 'Pragathi', 'pragathi@gmail.com', 'Hyderabad', 'India'),
(2, 'Rahul', 'rahul@gmail.com', 'Mumbai', 'India'),
(3, 'Anjali', 'anjali@gmail.com', 'Delhi', 'India'),
(4, 'Vikram', 'vikram@gmail.com', 'Bangalore', 'India'),
(5, 'Sneha', 'sneha@gmail.com', 'Chennai', 'India');

INSERT INTO Products VALUES
(101, 'Laptop', 'Electronics', 65000),
(102, 'Smartphone', 'Electronics', 30000),
(103, 'Headphones', 'Electronics', 2500),
(104, 'T-Shirt', 'Fashion', 1200),
(105, 'Shoes', 'Fashion', 3500);

INSERT INTO Orders VALUES
(1001, 1, '2024-01-15', 67500),
(1002, 2, '2024-02-10', 30000),
(1003, 1, '2024-03-05', 4700),
(1004, 3, '2024-03-20', 3500),
(1005, 4, '2024-04-01', 65000);

INSERT INTO Order_Items VALUES
(1, 1001, 101, 1),
(2, 1001, 103, 1),
(3, 1002, 102, 1),
(4, 1003, 103, 1),
(5, 1003, 104, 2),
(6, 1004, 105, 1),
(7, 1005, 101, 1);

-- 3. QUERIES

-- SELECT, WHERE, ORDER BY, GROUP BY
SELECT * FROM Customers WHERE Country = 'India';
SELECT * FROM Orders ORDER BY TotalAmount DESC;
SELECT CustomerID, COUNT(*) as TotalOrders FROM Orders GROUP BY CustomerID;

-- JOINS
SELECT C.CustomerName, O.OrderID, O.TotalAmount 
FROM Customers C INNER JOIN Orders O ON C.CustomerID = O.CustomerID;

SELECT C.CustomerName, O.OrderID 
FROM Customers C LEFT JOIN Orders O ON C.CustomerID = O.CustomerID;

SELECT C.CustomerName, P.ProductName, OI.Quantity
FROM Customers C
JOIN Orders O ON C.CustomerID = O.CustomerID
JOIN Order_Items OI ON O.OrderID = OI.OrderID
JOIN Products P ON OI.ProductID = P.ProductID;

-- Subqueries
SELECT * FROM Products WHERE Price > (SELECT AVG(Price) FROM Products);
SELECT CustomerName FROM Customers WHERE CustomerID IN 
(SELECT CustomerID FROM Orders WHERE TotalAmount > 50000);

-- Aggregate
SELECT SUM(TotalAmount) as TotalRevenue, AVG(TotalAmount) as AvgOrderValue FROM Orders;
SELECT P.Category, SUM(O.TotalAmount) as CategorySales
FROM Products P JOIN Order_Items OI ON P.ProductID = OI.ProductID
JOIN Orders O ON OI.OrderID = O.OrderID
GROUP BY P.Category;

-- VIEW
CREATE VIEW Customer_Spending AS
SELECT C.CustomerName, SUM(O.TotalAmount) as TotalSpent
FROM Customers C JOIN Orders O ON C.CustomerID = O.CustomerID
GROUP BY C.CustomerName;

SELECT * FROM Customer_Spending;

-- INDEXES
CREATE INDEX idx_customer ON Orders(CustomerID);
CREATE INDEX idx_product ON Order_Items(ProductID);

-- Avg revenue per user
SELECT AVG(TotalSpent) as AvgRevenuePerUser FROM Customer_Spending;

-- NULL handling
SELECT CustomerName, COALESCE(Email, 'No Email') as Email FROM Customers;
