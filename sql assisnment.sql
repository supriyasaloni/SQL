-- Qustion 1. Explain the fundamental differences between DDL, DML, and DQL commands in SQL. Provide one example for each type of command.

-- Answer 
-- DDL(Data Definition Language) : Used to define or modify the structure of the database, such as creating or deleting tables.
-- Example : CREATE TABLE Students (ID INT, Name VARCHAR(50));

-- *DML(Data Manipulation Language) : Used to manage data within existing tables, such as adding or updating rows.
-- Example : INSERT INTO Students (ID, Name) VALUES (1, 'Alice'); 

-- DQL(Data Query Language) : Used specifically for fetching or retrieving data from the database.
-- Example : SELECT * FROM Students;

-- Question 2. What is the purpose of SQL constraints? Name and describe three common types of constraints, providing a simple scenario where each would be useful.

-- Answer
-- The purpose of constraints is to enforce rules on data in a table to ensure accuracy and reliability.

-- PRIMARY KEY : Uniquely identifies each record. Scenario: Ensuring every CustomerID is unique.

-- FOREIGN KEY : Maintains referential integrity between tables. Scenario: Linking an Order to a specific Customer.

-- NOT NULL : Ensures a column cannot have an empty value. Scenario: Requiring every product to have a ProductName.

-- Question 3. : Explain the difference between 'LIMIT' and 'OFFSET' clauses in SQL. How would you use them together to retrieve the third page of results, assuming each page has 10 records?

-- Answer 
-- LIMIT : Specifies the maximum number of rows to return .

-- OFFSET : Specifies how many rows to skip before starting to return rows.

-- Third Page Logic : To get the 3rd page with 10 records per page, you skip the first 20 records (Page 1 and 2).
-- SQL
SELECT * FROM table_name LIMIT 10 OFFSET 20;

-- Question 3. : What is a Common Table Expression (CTE) in SQL, and what are its main benefits? Provide a simple SQL example demonstrating its usage.

-- Answer 
-- A CTE is a temporary result set defined using the WITH clause that you can reference within a SELECT, INSERT, UPDATE, or DELETE statement.

-- Benefits : Improves readability, simplifies complex joins, and can be used for recursive queries.

-- Example : 
WITH Highstock AS (
SELECT ProductName, Price FROM Products WHERE StockQuantity > 100
)
SELECT * FROM HighStock;

-- Question 5. Describe the concept of SQL Normalization and its primary goals. Briefly explain the first three normal forms (1NF, 2NF, 3NF).

-- Answer 
-- Normalization is the process of organizing data to reduce redundancy and improve data integrity.

-- 1NF : Ensure each column contains atomic (indivisible) values and each record is unique.

-- 2NF : Must be in 1NF and all non-key attributes must be fully functional dependent on the primary key.

-- 3NF : Must be in 2NF and have no transitive functional dependencies (non-key columns shouldn't depend on other non-key columns).

-- Question 6. Create a database named ECommerceDB and perform the following
-- tasks :

CREATE DATABASE ECommerceDatabase;

-- Create Tables
CREATE TABLE Category(
    CategoryID INT PRIMARY KEY,
	CategoryName VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE Customer (
   CustomerID INT PRIMARY KEY,
   CustomerName VARCHAR(100) NOT NULL,
   Email VARCHAR(100) UNIQUE,
   JoinDate DATE
);

CREATE TABLE Product (
   ProductID INT PRIMARY KEY,
   ProductName VARCHAR(100) NOT NULL UNIQUE,
   CategoryID INT,
   Price DECIMAL(10,2) NOT NULL,
   StockQuantity INT,
   FOREIGN KEY (CategoryID) REFERENCES Categories(CategoryID)
);

CREATE TABLE Orderss (
   OrderID INT PRIMARY KEY,
   CustomerID INT,
   OrderDate DATE NOT NULL,
   TotalAmount DECIMAL(10,2),
   FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

-- Insert Data
INSERT INTO Categories VALUES (1, 'Electronics'), (2, 'Books'), (3, 'Home Goods'), (4,'Apparel');

INSERT INTO Customer VALUES
(1, 'Alice Wonderland', 'alice@example.com', '2023-01-10'),
(2, 'Bob the Builder', 'bob@example.com', '2022-11-25'),
(3, 'Charlie Chaplin', 'charlie@example.com', '2023-03-01'),
(4, 'Diana Prince', 'diana@example.com', '2021-04-26');

INSERT INTO Product VALUES
(101, 'Laptop Pro',1,1200.00,50), 
(102, 'SQL Handbook',2,45.50,200),
(103, 'Smart Speaker',1,99.99,150), 
(104,'Coffee Maker',3,75.00,80),
(105, 'Novel: The Great SQL',2,25.00,120), 
(106,'Wireless Earbuds',1,150.00,100),
(107, 'Blender X',3,120.00,60),
(100, 'T-Shirt Casual',4,20.00,300);

INSERT INTO Orderss VALUES
(1001,1,'2023-04-26',1245.50),
(1002,2,'2023-10-12',99.99),
(1003,1,'2023-07-01',145.00),
(1004,3,'2023-01-14',150.00),
(1005,2,'2023-09-24',120.00),
(1006,1,'2023-06-19',20.00);

-- Question 7. Generate a report showing CustomerName, Email, and the TotalNumberofOrders for each customer. Include customers who have not placed any orders, in which case their TotalNumberofOrders should be 0. Order the results by CustomerName.

-- Answer 
SELECT c.CustomerName, c.Email, COUNT(o.OrderID) AS TotalNumberofOrders
FROM Customer c
LEFT JOIN Orderss o ON c.CustomerID = o.CustomerID
GROUP BY c.CustomerID, c.CustomerName, c.Email
ORDER BY c.CustomerName;

-- Question 8. Retrieve Product Information with Category: Write a SQL query to display the ProductName, Price, StockQuantity, and CategoryName for all products. Order the results by CategoryName and then ProductName alphabetically.

-- Answer 

SELECT p.ProductName, p.Price, p.StockQuantity, c.CategoryName
FROM Product p
JOIN Category c ON p.CategoryID = c.CategoryID
ORDER BY c.CategoryName ASC, p.ProductName ASC;

-- Question 9. Write a SQL query that uses a Common Table Expression (CTE) and a Window Function (specifically ROW_NUMBER() or RANK()) to display the CategoryName, ProductName, and Price for the top 2 most expensive products in each CategoryName.

-- Answer 
WITH RankedProducts AS (
    SELECT c.CategoryName, p.ProductName, p.Price,
           ROW_NUMBER() OVER(PARTITION BY c.CategoryName ORDER BY p.Price DESC) as RankNum
    FROM Product p
    JOIN Category c ON p.CategoryID = c.CategoryID
)
SELECT CategoryName, ProductName, Price
FROM RankedProducts
WHERE RankNum <= 2;

-- Question 10. You are hired as a data analyst by Sakila Video Rentals, a global movie rental company. The management team is looking to improve decision-making by analyzing existing customer, rental, and inventory data.
-- Using the Sakila database, answer the following business questions to support key strategic initiatives.
-- Tasks & Questions:
-- 1. Identify the top 5 customers based on the total amount they’ve spent. Include customer name, email, and total amount spent.
-- 2. Which 3 movie categories have the highest rental counts? Display the category name and number of times movies from that category were rented.
-- 3. Calculate how many films are available at each store and how many of those have never been rented.
-- 4. Show the total revenue per month for the year 2023 to analyze business seasonality.
-- 5. Identify customers who have rented more than 10 times in the last 6 months.

-- Answer 
show databases;
use sakila;
-- 1. Top 5 customers by spend

SELECT c.first_name, c.last_name, c.email, SUM(p.amount) AS total_spent
FROM customer c
JOIN Payment p ON c.customer_id = p.customer_id
GROUP BY c.customer_id
ORDER BY total_spent DESC
LIMIT 5;

-- 2. Top 3 movie categories by rental count
SELECT cat.name, COUNT(r.rental_id) AS rental_count
FROM category cat
JOIN film_category fc ON cat.category_id = fc.category_id
JOIN inventory i ON fc.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
GROUP BY cat.name
ORDER BY rental_count DESC
LIMIT 3;

-- 3. Films available per store vs never rented
SELECT i.store_id, 
       COUNT(DISTINCT i.film_id) AS available_films,
       SUM(CASE WHEN r.rental_id IS NULL THEN 1 ELSE 0 END) AS never_rented
FROM inventory i
LEFT JOIN rental r ON i.inventory_id = r.inventory_id
GROUP BY i.store_id;

-- 4. Monthly revenue for 2023 (Adjusted for Sakila date ranges if necessary)
SELECT 
    MONTHNAME(payment_date) AS Month,
    SUM(amount) AS Total_Revenue
FROM payment
WHERE YEAR(payment_date) = 2023
GROUP BY MONTH(payment_date), MONTHNAME(payment_date)
ORDER BY MONTH(payment_date);

-- 5. Customers with >10 rentals in last 6 months
SELECT c.first_name, c.last_name, COUNT(r.rental_id) as rental_count
FROM customer c
JOIN rental r ON c.customer_id = r.customer_id
WHERE r.rental_date >= CURRENT_DATE - INTERVAL 6 month
GROUP BY c.customer_id, c.first_name,c.last_name
HAVING COUNT(r.rental_id) > 10;

