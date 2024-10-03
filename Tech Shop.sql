CREATE DATABASE TechShop;
USE TechShop;

-- Create Customers Table
CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY IDENTITY(1,1), 
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Email VARCHAR(100),
    Phone VARCHAR(15),
    Address VARCHAR(255)
);

-- Insert records into Customers
INSERT INTO Customers (FirstName, LastName, Email, Phone, Address) 
VALUES 
('Ravi', 'Kumar', 'ravi.kumar@example.com', '9876543210', '12 MG Road, Bengaluru'),
('Priya', 'Sharma', 'priya.sharma@example.com', '9988776655', '24 Park Street, Kolkata'),
('Amit', 'Patel', 'amit.patel@example.com', '9123456789', '56 LBS Marg, Mumbai'),
('Sonal', 'Singh', 'sonal.singh@example.com', '9871234567', '89 Rajpath, New Delhi'),
('Arjun', 'Verma', 'arjun.verma@example.com', '9765432198', '102 Nehru Street, Chennai');

-- Create Products Table
CREATE TABLE Products (
    ProductID INT PRIMARY KEY IDENTITY(1,1),
    ProductName VARCHAR(100),
    Description TEXT,
    Price DECIMAL(10, 2)
);

-- Insert records into Products
INSERT INTO Products (ProductName, Description, Price)
VALUES 
('Laptop', 'High-performance laptop with Intel i7', 85000.00),
('Smartphone', 'Latest Android smartphone with AMOLED display', 45000.00),
('Tablet', '10-inch tablet with 128GB storage', 30000.00),
('Smartwatch', 'Smartwatch with heart rate monitor', 12000.00),
('Wireless Earbuds', 'Noise-cancelling wireless earbuds', 8000.00);

-- Create Orders Table
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY IDENTITY(1,1),  
    CustomerID INT,
    OrderDate DATE,
    TotalAmount DECIMAL(10, 2),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

-- Insert records into Orders
INSERT INTO Orders (CustomerID, OrderDate, TotalAmount)
VALUES 
(1, '2024-09-15', 85000.00),
(2, '2024-09-16', 45000.00),
(3, '2024-09-17', 30000.00),
(4, '2024-09-18', 12000.00),
(5, '2024-09-19', 8000.00);

-- Create OrderDetails Table
CREATE TABLE OrderDetails (
    OrderDetailID INT PRIMARY KEY IDENTITY(1,1),  
    OrderID INT,
    ProductID INT,
    Quantity INT,
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

-- Insert records into OrderDetails
INSERT INTO OrderDetails (OrderID, ProductID, Quantity)
VALUES 
(1, 1, 1),  
(2, 2, 1),  
(3, 3, 1),  
(4, 4, 1),  
(5, 5, 1);  

-- Create Inventory Table
CREATE TABLE Inventory (
    InventoryID INT PRIMARY KEY IDENTITY(1,1), 
    ProductID INT,
    QuantityInStock INT,
    LastStockUpdate DATE,
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

-- Insert records into Inventory
INSERT INTO Inventory (ProductID, QuantityInStock, LastStockUpdate)
VALUES 
(1, 25, '2024-08-01'),  
(2, 50, '2024-08-01'), 
(3, 30, '2024-08-01'), 
(4, 100, '2024-08-01'),
(5, 200, '2024-08-01');


---Task-2

-- 1. Retrieve names and emails of all customers
SELECT FirstName, LastName, Email FROM Customers;

-- 2. List all orders with their order dates and corresponding customer names
SELECT Orders.OrderID, Orders.OrderDate, Customers.FirstName, Customers.LastName 
FROM Orders 
JOIN Customers ON Orders.CustomerID = Customers.CustomerID;

-- 3. Insert a new customer record into the "Customers" table
INSERT INTO Customers (FirstName, LastName, Email, Phone, Address)
VALUES ('New', 'Customer', 'newcustomer@example.com', '1234567890', '789 Maple St');

-- 4. Increase the prices of all products by 10%
UPDATE Products 
SET Price = Price * 1.10;

select *from Products;

--5. Delete a specific order and its associated order details (Order ID as a parameter)
DELETE FROM OrderDetails 
WHERE OrderID = 2;

-- Delete the order from Orders
DELETE FROM Orders 
WHERE OrderID = 2;

--6. Insert a new order into the "Orders" table
INSERT INTO Orders (CustomerID, OrderDate, TotalAmount)
VALUES (1, '2024-10-01', 1500.00);

--7. Update the contact information of a specific customer (Customer ID as a parameter)
UPDATE Customers 
SET Email = 'newemail@example.com', Address = '123 New Address St'
WHERE CustomerID = 1;
select*from Customers;

--8. Recalculate and update the total cost of each order based on prices and quantities in the "OrderDetails" table
UPDATE Orders
SET TotalAmount = (
    SELECT SUM(OrderDetails.Quantity * Products.Price)
    FROM OrderDetails
    JOIN Products ON OrderDetails.ProductID = Products.ProductID
    WHERE OrderDetails.OrderID = Orders.OrderID
);
--9. Delete all orders and associated order details for a specific customer (Customer ID as a parameter)
DELETE FROM OrderDetails
WHERE OrderID IN (SELECT OrderID FROM Orders WHERE CustomerID = 3);

-- Delete the orders from Orders table
DELETE FROM Orders 
WHERE CustomerID = 3;

--10. Insert a new electronic gadget product into the "Products" table
INSERT INTO Products (ProductName, Description, Price)
VALUES ('New Gadget', 'This is a description of the new gadget', 299.99);

--11. Update the status of a specific order (Order ID as a parameter)
ALTER TABLE Orders
ADD Status VARCHAR(20);

UPDATE Orders 
SET Status = 'Shipped' 
WHERE OrderID = 2;

--12. Calculate and update the number of orders placed by each customer
ALTER TABLE Customers 
ADD OrderCount INT DEFAULT 0;

-- Task-3
-- 1. Retrieve a list of all orders along with customer information for each order
SELECT Orders.OrderID, Orders.OrderDate, Customers.FirstName, Customers.LastName, Customers.Email, Customers.Phone
FROM Orders
JOIN Customers ON Orders.CustomerID = Customers.CustomerID;

-- 2. Find the total revenue generated by each electronic gadget product
SELECT Products.ProductName, SUM(OrderDetails.Quantity * Products.Price) AS TotalRevenue
FROM OrderDetails
JOIN Products ON OrderDetails.ProductID = Products.ProductID
GROUP BY Products.ProductName
ORDER BY TotalRevenue DESC;

-- 3. List all customers who have made at least one purchase (include names and contact information)
SELECT Customers.FirstName, Customers.LastName, Customers.Email, Customers.Phone
FROM Customers
JOIN Orders ON Customers.CustomerID = Orders.CustomerID
GROUP BY Customers.CustomerID, Customers.FirstName, Customers.LastName, Customers.Email, Customers.Phone;

-- 4. Find the most popular electronic gadget (the one with the highest total quantity ordered)
SELECT TOP 1 Products.ProductName, SUM(OrderDetails.Quantity) AS TotalQuantityOrdered
FROM OrderDetails
JOIN Products ON OrderDetails.ProductID = Products.ProductID
GROUP BY Products.ProductName
ORDER BY TotalQuantityOrdered DESC;


-- 5. Retrieve a list of electronic gadgets along with their corresponding categories
SELECT ProductName, Category
FROM Products;

-- 6. Calculate the average order value for each customer
SELECT Customers.FirstName, Customers.LastName, AVG(Orders.TotalAmount) AS AverageOrderValue
FROM Customers
JOIN Orders ON Customers.CustomerID = Orders.CustomerID
GROUP BY Customers.CustomerID, Customers.FirstName, Customers.LastName
ORDER BY AverageOrderValue DESC;

-- 7. Find the order with the highest total revenue (include order ID, customer info, and total revenue)
SELECT TOP 1 Orders.OrderID, Customers.FirstName, Customers.LastName, Orders.TotalAmount
FROM Orders
JOIN Customers ON Orders.CustomerID = Customers.CustomerID
ORDER BY Orders.TotalAmount DESC;

-- 8. List electronic gadgets and the number of times each product has been ordered

SELECT Products.ProductName, COUNT(OrderDetails.OrderDetailID) AS TimesOrdered
FROM OrderDetails
JOIN Products ON OrderDetails.ProductID = Products.ProductID
GROUP BY Products.ProductName
ORDER BY TimesOrdered DESC;

-- 9. Find customers who have purchased a specific electronic gadget product

SELECT Customers.FirstName, Customers.LastName, Customers.Email, Customers.Phone
FROM Customers
JOIN Orders ON Customers.CustomerID = Orders.CustomerID
JOIN OrderDetails ON Orders.OrderID = OrderDetails.OrderID
JOIN Products ON OrderDetails.ProductID = Products.ProductID
WHERE Products.ProductName = 'Phone'; 

-- 10. Calculate the total revenue generated by all orders placed within a specific time period

SELECT SUM(Orders.TotalAmount) AS TotalRevenue
FROM Orders
WHERE Orders.OrderDate BETWEEN '2024-09-01' AND '2024-09-30';  

--Task 4
-- 1. Find Customers Who Have Not Placed Any Orders
SELECT FirstName, LastName
FROM Customers
WHERE CustomerID NOT IN (SELECT CustomerID FROM Orders);

-- 2. Total Number of Products Available for Sale
SELECT COUNT(*) AS TotalProducts
FROM Products;

-- 3. Total Revenue Generated by TechShop
SELECT SUM(TotalAmount) AS TotalRevenue
FROM Orders;

-- 4. Average Quantity Ordered for Products in a Specific Category
DECLARE @CategoryName VARCHAR(100) = 'Electronics';  

SELECT AVG(OrderDetails.Quantity) AS AverageQuantityOrdered
FROM OrderDetails
JOIN Products ON OrderDetails.ProductID = Products.ProductID
WHERE Products.Category = 'Eceltronics';

-- 5. Total Revenue Generated by a Specific Customer
DECLARE @CustomerID INT = 1;  

SELECT SUM(Orders.TotalAmount) AS TotalRevenue
FROM Orders
WHERE CustomerID = @CustomerID;

-- 6. Customers Who Have Placed the Most Orders
SELECT Customers.FirstName, Customers.LastName, COUNT(Orders.OrderID) AS NumberOfOrders
FROM Customers
JOIN Orders ON Customers.CustomerID = Orders.CustomerID
GROUP BY Customers.FirstName, Customers.LastName
ORDER BY NumberOfOrders DESC;

-- 7. Most Popular Product Category (Highest Total Quantity Ordered)
SELECT TOP 1 Products.Category, SUM(OrderDetails.Quantity) AS TotalQuantityOrdered
FROM OrderDetails
JOIN Products ON OrderDetails.ProductID = Products.ProductID
GROUP BY Products.Category
ORDER BY TotalQuantityOrdered DESC;

-- 8. Customer Who Has Spent the Most Money on Electronic Gadgets
SELECT TOP 1 Customers.FirstName, Customers.LastName, SUM(Orders.TotalAmount) AS TotalSpending
FROM Orders
JOIN Customers ON Orders.CustomerID = Customers.CustomerID
GROUP BY Customers.FirstName, Customers.LastName
ORDER BY TotalSpending DESC;

-- 9. Average Order Value for All Customers
SELECT AVG(TotalAmount) AS AverageOrderValue
FROM Orders;

-- 10. Total Number of Orders Placed by Each Customer
SELECT Customers.FirstName, Customers.LastName, COUNT(Orders.OrderID) AS TotalOrders
FROM Customers
LEFT JOIN Orders ON Customers.CustomerID = Orders.CustomerID
GROUP BY Customers.FirstName, Customers.LastName;
