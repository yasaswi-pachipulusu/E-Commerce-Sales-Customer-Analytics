-- ============================================================
-- E-COMMERCE SALES & CUSTOMER ANALYTICS
-- SQL ANALYSIS PROJECT
-- Database: MySQL
-- ============================================================
-- Purpose:
--   1. Create the analytics database and core tables
--   2. Validate data quality and relationships
--   3. Perform descriptive and business analysis
--   4. Produce analysis suitable for Power BI reporting
-- ============================================================

create database ecommerce_analytics1;
USE ecommerce_analytics1;
SELECT DATABASE();
CREATE TABLE Customers (
    Customer_ID VARCHAR(20) PRIMARY KEY,
    Customer_Name VARCHAR(100),
    Gender VARCHAR(20),
    Age INT,
    City VARCHAR(50),
    State VARCHAR(50),
    Region VARCHAR(20),
    Customer_Segment VARCHAR(30),
    Registration_Date DATE
);
CREATE TABLE Products (
    Product_ID VARCHAR(20) PRIMARY KEY,
    Product_Name VARCHAR(150),
    Category VARCHAR(50),
    Sub_Category VARCHAR(50),
    Brand VARCHAR(50),
    Unit_Price DECIMAL(12,2),
    Cost_Price DECIMAL(12,2)
);
CREATE TABLE Orders (
    Order_ID VARCHAR(20),
    Order_Date DATE,
    Customer_ID VARCHAR(20),
    Product_ID VARCHAR(20),
    Quantity INT,
    Discount DECIMAL(5,2),
    Payment_Method VARCHAR(30),
    Order_Status VARCHAR(30),
    Sales DECIMAL(12,2),
    Profit DECIMAL(12,2)
);
CREATE TABLE Shipping (
    Order_ID VARCHAR(20),
    Ship_Date DATE,
    Delivery_Date DATE,
    Ship_Mode VARCHAR(30),
    Shipping_Cost DECIMAL(12,2)
);
show tables;
describe  customers;
USE ecommerce_analytics;

select count(*) from customers;
select count(*) from products;
select count(*) from orders;
select count(*) from shipping;

SELECT COUNT(*) AS matching_orders
FROM Orders o
INNER JOIN Shipping s
ON o.Order_ID = s.Order_ID;
SELECT s.Order_ID
FROM Shipping s
LEFT JOIN Orders o
ON s.Order_ID = o.Order_ID
WHERE o.Order_ID IS NULL;
SELECT o.Order_ID
FROM Orders o
LEFT JOIN Shipping s
ON o.Order_ID = s.Order_ID
WHERE s.Order_ID IS NULL;
SELECT Order_ID, COUNT(*) AS count
FROM Shipping
GROUP BY Order_ID
HAVING COUNT(*) > 1;

SELECT *
FROM Orders
WHERE Sales < 0;
SELECT *
FROM Orders
WHERE Quantity <= 0;
SELECT *
FROM Orders
WHERE Profit < 0;
SELECT
    MIN(Sales) AS minimum_sales,
    MAX(Sales) AS maximum_sales,
    AVG(Sales) AS average_sales,
    SUM(Sales) AS total_sales
FROM Orders;
SELECT
    MIN(Profit) AS minimum_profit,
    MAX(Profit) AS maximum_profit,
    AVG(Profit) AS average_profit,
    SUM(Profit) AS total_profit
FROM Orders;

SELECT
    SUM(Order_Date IS NULL) AS missing_order_dates
FROM Orders;

SELECT
    SUM(ship_Date IS NULL) AS missing_ship_dates
FROM shipping;

SELECT
    o.Order_ID,
    o.Order_Date,
    s.Ship_Date
FROM Orders o
JOIN Shipping s
ON o.Order_ID = s.Order_ID
WHERE s.Ship_Date < o.Order_Date;

SELECT
    AVG(DATEDIFF(s.Ship_Date, o.Order_Date)) AS average_shipping_days,
    MIN(DATEDIFF(s.Ship_Date, o.Order_Date)) AS minimum_shipping_days,
    MAX(DATEDIFF(s.Ship_Date, o.Order_Date)) AS maximum_shipping_days
FROM Orders o
JOIN Shipping s
ON o.Order_ID = s.Order_ID;

-- ============================================================
-- SECTION 4: OVERALL BUSINESS KPIs
-- ============================================================

SELECT
    COUNT(DISTINCT Order_ID) AS total_orders,
    COUNT(DISTINCT Customer_ID) AS total_customers,
    COUNT(DISTINCT Product_ID) AS total_products,
    SUM(Sales) AS total_sales,
    SUM(Profit) AS total_profit,
    AVG(Sales) AS average_sales
FROM Orders;
-- ============================================================
-- SECTION 5: SALES & PROFIT BY CATEGORY
-- ============================================================

SELECT
    p.Category,
    SUM(o.Sales) AS total_sales,
    SUM(o.Profit) AS total_profit,
    SUM(o.Quantity) AS total_quantity,
    AVG(o.Sales) AS average_sales
FROM Orders o
JOIN Products p
    ON o.Product_ID = p.Product_ID
GROUP BY p.Category
ORDER BY total_sales DESC;

-- ============================================================
-- 5.3 SALES & PROFIT BY REGION
-- ============================================================

SELECT
    c.Region,
    SUM(o.Sales) AS total_sales,
    SUM(o.Profit) AS total_profit,
    SUM(o.Quantity) AS total_quantity
FROM Orders o
JOIN Customers c
    ON o.Customer_ID = c.Customer_ID
GROUP BY c.Region
ORDER BY total_sales DESC;

-- ============================================================
-- 5.4 TOP 10 PRODUCTS BY SALES
-- ============================================================

SELECT
    p.Product_ID,
    p.Product_Name,
    SUM(o.Sales) AS total_sales
FROM Orders o
JOIN Products p
    ON o.Product_ID = p.Product_ID
GROUP BY
    p.Product_ID,
    p.Product_Name
ORDER BY total_sales DESC
LIMIT 10;

-- ============================================================
-- 5.5 TOP 10 PRODUCTS BY PROFIT
-- ============================================================

SELECT
    p.Product_ID,
    p.Product_Name,
    SUM(o.Profit) AS total_profit
FROM Orders o
JOIN Products p
    ON o.Product_ID = p.Product_ID
GROUP BY
    p.Product_ID,
    p.Product_Name
ORDER BY total_profit DESC
LIMIT 10;

-- ============================================================
-- 5.6 BOTTOM 10 PRODUCTS BY PROFIT
-- ============================================================

SELECT
    p.Product_ID,
    p.Product_Name,
    SUM(o.Profit) AS total_profit
FROM Orders o
JOIN Products p
    ON o.Product_ID = p.Product_ID
GROUP BY
    p.Product_ID,
    p.Product_Name
ORDER BY total_profit ASC
LIMIT 10;

-- ============================================================
-- 5.7 SALES BY CUSTOMER
-- ============================================================

SELECT
    c.Customer_ID,
    c.Customer_Name,
    SUM(o.Sales) AS total_sales
FROM Orders o
JOIN Customers c
    ON o.Customer_ID = c.Customer_ID
GROUP BY
    c.Customer_ID,
    c.Customer_Name
ORDER BY total_sales DESC;

-- ============================================================
-- 5.8 TOP 10 CUSTOMERS
-- ============================================================

SELECT
    c.Customer_ID,
    c.Customer_Name,
    SUM(o.Sales) AS total_sales,
    SUM(o.Profit) AS total_profit
FROM Orders o
JOIN Customers c
    ON o.Customer_ID = c.Customer_ID
GROUP BY
    c.Customer_ID,
    c.Customer_Name
ORDER BY total_sales DESC
LIMIT 10;

-- ============================================================
-- 5.9 SALES BY CUSTOMER SEGMENT
-- ============================================================

SELECT
    c.Customer_Segment,
    SUM(o.Sales) AS total_sales,
    SUM(o.Quantity) AS total_quantity
FROM Orders o
JOIN Customers c
    ON o.Customer_ID = c.Customer_ID
GROUP BY c.Customer_Segment
ORDER BY total_sales DESC;

-- ============================================================
-- 5.10 PROFIT BY CUSTOMER SEGMENT
-- ============================================================

SELECT
    c.Customer_Segment,
    SUM(o.Profit) AS total_profit
FROM Orders o
JOIN Customers c
    ON o.Customer_ID = c.Customer_ID
GROUP BY c.Customer_Segment
ORDER BY total_profit DESC;

-- ============================================================
-- 5.11 SALES BY SHIP MODE
-- ============================================================

SELECT
    s.Ship_Mode,
    SUM(o.Sales) AS total_sales,
    SUM(o.Quantity) AS total_quantity
FROM Orders o
JOIN Shipping s
    ON o.Order_ID = s.Order_ID
GROUP BY s.Ship_Mode
ORDER BY total_sales DESC;

-- ============================================================
-- 5.12 PROFIT BY SHIP MODE
-- ============================================================

SELECT
    s.Ship_Mode,
    SUM(o.Profit) AS total_profit
FROM Orders o
JOIN Shipping s
    ON o.Order_ID = s.Order_ID
GROUP BY s.Ship_Mode
ORDER BY total_profit DESC;

-- ============================================================
-- 5.13 MONTHLY SALES
-- ============================================================

SELECT
    YEAR(o.Order_Date) AS order_year,
    MONTH(o.Order_Date) AS order_month,
    SUM(o.Sales) AS total_sales
FROM Orders o
GROUP BY
    YEAR(o.Order_Date),
    MONTH(o.Order_Date)
ORDER BY
    order_year,
    order_month;

-- ============================================================
-- 5.14 MONTHLY PROFIT
-- ============================================================

SELECT
    YEAR(o.Order_Date) AS order_year,
    MONTH(o.Order_Date) AS order_month,
    SUM(o.Profit) AS total_profit
FROM Orders o
GROUP BY
    YEAR(o.Order_Date),
    MONTH(o.Order_Date)
ORDER BY
    order_year,
    order_month;

-- ============================================================
-- 5.15 YEARLY SALES
-- ============================================================

SELECT
    YEAR(o.Order_Date) AS order_year,
    SUM(o.Sales) AS total_sales
FROM Orders o
GROUP BY YEAR(o.Order_Date)
ORDER BY order_year;

-- ============================================================
-- 5.16 YEARLY PROFIT
-- ============================================================

SELECT
    YEAR(o.Order_Date) AS order_year,
    SUM(o.Profit) AS total_profit
FROM Orders o
GROUP BY YEAR(o.Order_Date)
ORDER BY order_year;

-- ============================================================
-- 5.17 CATEGORY & SUBCATEGORY ANALYSIS
-- ============================================================

SELECT
    p.Category,
    p.Sub_Category,
    SUM(o.Sales) AS total_sales,
    SUM(o.Profit) AS total_profit,
    SUM(o.Quantity) AS total_quantity
FROM Orders o
JOIN Products p
    ON o.Product_ID = p.Product_ID
GROUP BY
    p.Category,
    p.Sub_Category
ORDER BY
    p.Category,
    total_sales DESC;

-- ============================================================
-- 5.18 MOST PROFITABLE CATEGORY
-- ============================================================

SELECT
    p.Category,
    SUM(o.Profit) AS total_profit
FROM Orders o
JOIN Products p
    ON o.Product_ID = p.Product_ID
GROUP BY p.Category
ORDER BY total_profit DESC
LIMIT 1;

-- ============================================================
-- 5.19 LOSS-MAKING PRODUCTS
-- ============================================================

SELECT
    p.Product_ID,
    p.Product_Name,
    SUM(o.Sales) AS total_sales,
    SUM(o.Profit) AS total_profit
FROM Orders o
JOIN Products p
    ON o.Product_ID = p.Product_ID
GROUP BY
    p.Product_ID,
    p.Product_Name
HAVING SUM(o.Profit) < 0
ORDER BY total_profit ASC;

-- ============================================================
-- 5.20 SHIPPING PERFORMANCE
-- ============================================================

SELECT
    s.Ship_Mode,
    COUNT(DISTINCT s.Order_ID) AS total_orders,
    AVG(DATEDIFF(s.Ship_Date, o.Order_Date)) AS avg_shipping_days,
    MIN(DATEDIFF(s.Ship_Date, o.Order_Date)) AS min_shipping_days,
    MAX(DATEDIFF(s.Ship_Date, o.Order_Date)) AS max_shipping_days
FROM Orders o
JOIN Shipping s
    ON o.Order_ID = s.Order_ID
GROUP BY s.Ship_Mode
ORDER BY avg_shipping_days;

-- ============================================================
-- END OF E-COMMERCE SALES & CUSTOMER ANALYTICS SQL PROJECT
-- ============================================================
