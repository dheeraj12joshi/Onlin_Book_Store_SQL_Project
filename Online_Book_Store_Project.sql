-- Create Tables
DROP table if exists Books;
CREATE table books(
   book_id SERIAL PRIMARY KEY,
   title VARCHAR(100),
   author VARCHAR(100),
   genre VARCHAR(50),
   published_year INTEGER ,
   price NUMERIC (10,2),
   stock INTEGER
);

DROP TABLE if exists customer;
CREATE TABLE customer(
   customer_id SERIAL PRIMARY KEY,
   name VARCHAR(100),
   email VARCHAR(100),
   phone VARCHAR(15) ,
   city VARCHAR(50) ,
   country VARCHAR(150)
);

DROP TABLE if exists orders;
CREATE TABLE orders(
   order_id SERIAL PRIMARY KEY,
   customer_id INTEGER REFERENCES customer(customer_id),
   book_id INTEGER REFERENCES books(book_id),
   order_date DATE ,
   quantity INTEGER,
   total_amount NUMERIC(10,2) 
);

SELECT * FROM books;
SELECT * FROM customer;
SELECT * FROM orders;

-- BASIC QUARIES
-- 1) Retrieve all books in the "Fiction" genre:
SELECT * FROM books
WHERE genre = 'Fiction';

-- 2) Find books published after the year 1950:
SELECT * FROM books
WHERE published_year > 1950;

-- 3) List all customers from the Canada:
SELECT * FROM customer
WHERE country = 'Canada';

-- 4) Show orders placed in November 2023:
SELECT * FROM orders
WHERE order_date BETWEEN '2023-11-01' AND '2023-11-30';

-- 5) Retrieve the total stock of books available:
SELECT sum(stock) AS total_stocck
FROM books;

-- 6) Find the details of the most expensive book:
SELECT * FROM books
WHERE price = (
   SELECT max(price) FROM books
);
-- OR
SELECT * FROM books
ORDER BY price DESC
LIMIT 1;

-- 7) Show all customers who ordered more than 1 quantity of a book:
SELECT c.customer_id,c.name,c.email ,o.quantity
FROM customer c
INNER JOIN orders o 
ON c.customer_id = o.customer_id
WHERE o.quantity > 1;
 
-- 8) Retrieve all orders where the total amount exceeds $20:
SELECT * FROM orders
WHERE total_amount > 20;

-- 9) List all genres available in the Books table:
SELECT DISTINCT genre 
FROM books;

-- 10) Find the book with the lowest stock:
SELECT * FROM books
WHERE stock = (
      SELECT min(stock) FROM books
);

-- 11) Calculate the total revenue generated from all orders:
SELECT sum(total_amount) AS total_revenue 
FROM orders;

-- Advance Questions
-- 1) Retrieve the total number of books sold for each genre:
SELECT b.genre,sum(o.quantity) AS total_book_sold
FROM books b INNER JOIN orders o 
ON b.book_id = o.book_id
GROUP BY b.genre;

-- 2) Find the average price of books in the "Fantasy" genre:
SELECT genre,ROUND(avg(price),2)AS average_price FROM books
GROUP BY genre
HAVING genre= 'Fantasy';

-- 3) List customers names who have placed at least 2 orders:
SELECT c.name,o.customer_id,count(o.order_id) AS order_count
FROM customer c INNER JOIN orders o
ON c.customer_id = o.customer_id
GROUP BY c.name,o.customer_id
HAVING  count(o.order_id) >=2;

-- 4) Find the most frequently ordered book:
SELECT b.title,o.book_id,count(o.order_id) AS frequent_order
FROM books b INNER JOIN orders o
ON b.book_id = o.book_id
GROUP BY b.title,o.book_id
ORDER BY frequent_order DESC
limit 1;

-- 5) Show the top 3 most expensive books of 'Fantasy' Genre :
WITH top3 AS(
SELECT title,price,
DENSE_RANK() OVER( ORDER BY price DESC) AS expensive_books
FROM books
WHERE genre = 'Fantasy'
)
SELECT * FROM top3
WHERE expensive_books <=3;

-- OR
SELECT * FROM books
WHERE genre = 'Fantasy'
ORDER BY price DESC
LIMIT 3;

-- 6) Retrieve the total quantity of books sold by each author:
SELECT b.author,sum(o.quantity) AS total_Quantity
FROM books b INNER JOIN orders o
ON b.book_id = o.book_id
GROUP BY author;

-- 7) List the cities where customers who spent over $30 are located:
SELECT o.customer_id,c.name,c.city,sum(o.total_amount) AS amount_spend
FROM customer c INNER JOIN orders o
ON c.customer_id = o.customer_id
GROUP BY o.customer_id,c.name,c.city
HAVING sum(o.total_amount) > 30;

-- 8) Find the customer who spent the most on orders:
SELECT c.name,o.customer_id,sum(o.total_amount) AS total
FROM customer c INNER JOIN orders o
ON c.customer_id = o.customer_id
GROUP BY c.name,o.customer_id
ORDER BY total DESC
LIMIT 1;

-- 9) Calculate the stock remaining after fulfilling all orders
SELECT b.book_id,b.title,b.stock,(b.stock - COALESCE(sum(o.quantity),0)) AS remaning_stock
FROM books b INNER JOIN orders o
ON b.book_id = o.book_id
GROUP BY b.book_id,b.stock;





