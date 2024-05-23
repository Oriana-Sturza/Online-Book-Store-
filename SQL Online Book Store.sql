-- Drop the database if it already exists

DROP DATABASE IF EXISTS OnlineBookstoreDB;


-- Create the database
CREATE DATABASE OnlineBookstoreDB;


-- Switch to the new database
USE OnlineBookstoreDB;


-- Table for authors
CREATE TABLE Authors (
    AuthorID INT NOT NULL PRIMARY KEY,
    Name VARCHAR(100) NOT NULL
);


-- Table for books
CREATE TABLE Books (
    BookID INT NOT NULL PRIMARY KEY,
    Title VARCHAR(255) NOT NULL,
    AuthorID INT,
    Genre VARCHAR(50),
    YearPublished INT,
    Price DECIMAL(10, 2),
    FOREIGN KEY (AuthorID) REFERENCES Authors(AuthorID)
);


-- Table for customers
CREATE TABLE Customers (
    CustomerID INT NOT NULL PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Email VARCHAR(255) NOT NULL,
    Address VARCHAR(255),
    PhoneNumber VARCHAR(20)
);


-- Table for orders
CREATE TABLE Orders (
    OrderID INT NOT NULL PRIMARY KEY,
    CustomerID INT,
    OrderDate DATE,
    TotalAmount DECIMAL(10, 2),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);


-- Table for order details
CREATE TABLE OrderDetails (
    OrderDetailID INT NOT NULL PRIMARY KEY,
    OrderID INT,
    BookID INT,
    Quantity INT,
    Price DECIMAL(10, 2),
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (BookID) REFERENCES Books(BookID)
);


-- Inserting Data

-- Insert authors
INSERT INTO Authors (AuthorID, Name) VALUES (1, 'J.K. Rowling');
INSERT INTO Authors (AuthorID, Name) VALUES (2, 'George R.R. Martin');
INSERT INTO Authors (AuthorID, Name) VALUES (3, 'J.R.R. Tolkien');

-- Insert books
INSERT INTO Books (BookID, Title, AuthorID, Genre, YearPublished, Price) VALUES (1, 'Harry Potter and the Philosophers Stone', 1, 'Fantasy', 1997, 10.99);
INSERT INTO Books (BookID, Title, AuthorID, Genre, YearPublished, Price) VALUES (2, 'A Game of Thrones', 2, 'Fantasy', 1996, 12.99);
INSERT INTO Books (BookID, Title, AuthorID, Genre, YearPublished, Price) VALUES (3, 'The Hobbit', 3, 'Fantasy', 1937, 8.99);

-- Insert customers
INSERT INTO Customers (CustomerID, Name, Email, Address, PhoneNumber) VALUES (1, 'Alice Johnson', 'alice@example.com', '123 Maple Street', '555-1234');
INSERT INTO Customers (CustomerID, Name, Email, Address, PhoneNumber) VALUES (2, 'Bob Smith', 'bob@example.com', '456 Oak Avenue', '555-5678');

-- Insert orders
INSERT INTO Orders (OrderID, CustomerID, OrderDate, TotalAmount) VALUES (1, 1, '2024-05-01', 23.97);
INSERT INTO Orders (OrderID, CustomerID, OrderDate, TotalAmount) VALUES (2, 2, '2024-05-02', 10.99);

-- Insert order details
INSERT INTO OrderDetails (OrderDetailID, OrderID, BookID, Quantity, Price) VALUES (1, 1, 1, 2, 21.98);
INSERT INTO OrderDetails (OrderDetailID, OrderID, BookID, Quantity, Price) VALUES (2, 1, 2, 1, 12.99);
INSERT INTO OrderDetails (OrderDetailID, OrderID, BookID, Quantity, Price) VALUES (3, 2, 3, 1, 8.99);


-- Querying Data

-- List all books with their authors
SELECT b.Title, a.Name AS Author, b.Genre, b.YearPublished, b.Price
FROM Books b
JOIN Authors a ON b.AuthorID = a.AuthorID;

-- List all customers and their total orders
SELECT c.Name, COUNT(o.OrderID) AS TotalOrders, SUM(o.TotalAmount) AS TotalSpent
FROM Customers c
LEFT JOIN Orders o ON c.CustomerID = o.CustomerID
GROUP BY c.CustomerID, c.Name;

-- Find the top selling books
SELECT b.Title, COUNT(od.BookID) AS TotalSales
FROM Books b
JOIN OrderDetails od ON b.BookID = od.BookID
GROUP BY b.BookID
ORDER BY TotalSales DESC
LIMIT 5;


-- Updating and Deleting Data

-- Update a book price
UPDATE Books
SET Price = 9.99
WHERE BookID = 1;

-- Delete a customer and all associated orders
DELETE FROM Customers
WHERE CustomerID = 2;



-- Additional Queries

-- List all orders along with the customer name, order date, total amount, and the number of items in each order

SELECT o.OrderID, c.Name AS CustomerName, o.OrderDate, o.TotalAmount, COUNT(od.BookID) AS NumberOfItems
FROM Orders o
JOIN Customers c ON o.CustomerID = c.CustomerID
JOIN OrderDetails od ON o.OrderID = od.OrderID
GROUP BY o.OrderID, c.Name, o.OrderDate, o.TotalAmount;

-- Find the total revenue generated from book sales for each author

SELECT a.Name AS AuthorName, SUM(od.Quantity * od.Price) AS TotalRevenue
FROM Authors a
JOIN Books b ON a.AuthorID = b.AuthorID
JOIN OrderDetails od ON b.BookID = od.BookID
GROUP BY a.AuthorID, a.Name;

-- List the top 3 customers who spent the most on their orders

SELECT c.Name AS CustomerName, SUM(o.TotalAmount) AS TotalSpent
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID
GROUP BY c.CustomerID
ORDER BY TotalSpent DESC
LIMIT 3;

-- Find the average price of books in each genre

SELECT Genre, AVG(Price) AS AveragePrice
FROM Books
GROUP BY Genre;

-- Identify books that have not been ordered yet

SELECT b.Title, a.Name AS Author
FROM Books b
LEFT JOIN OrderDetails od ON b.BookID = od.BookID
JOIN Authors a ON b.AuthorID = a.AuthorID
WHERE od.OrderID IS NULL;










