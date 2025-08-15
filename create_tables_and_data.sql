CREATE DATABASE CarDealership;
USE CarDealership;

-- Customers
CREATE TABLE Customers (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    city VARCHAR(100),
    email VARCHAR(100) UNIQUE,
    phone VARCHAR(15)
);

-- Cars
CREATE TABLE Cars (
    car_id INT AUTO_INCREMENT PRIMARY KEY,
    brand VARCHAR(50) NOT NULL,
    model VARCHAR(50) NOT NULL,
    year INT NOT NULL,
    price DECIMAL(15,2) NOT NULL
);

-- Sales
CREATE TABLE Sales (
    sale_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    car_id INT NOT NULL,
    sale_date DATE NOT NULL,
    quantity INT NOT NULL DEFAULT 1,
    total_amount DECIMAL(15,2) NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id),
    FOREIGN KEY (car_id) REFERENCES Cars(car_id)
);

-- Seed Customers (20 realistic entries)
INSERT INTO Customers (name, city, email, phone) VALUES
('Aarav Sharma','Delhi','aarav.sharma@example.com','9876500001'),
('Priya Kapoor','Mumbai','priya.kapoor@example.com','9876500002'),
('Rahul Mehta','Bengaluru','rahul.mehta@example.com','9876500003'),
('Simran Kaur','Chandigarh','simran.kaur@example.com','9876500004'),
('Vikram Singh','Jaipur','vikram.singh@example.com','9876500005'),
('Neha Verma','Pune','neha.verma@example.com','9876500006'),
('Ananya Gupta','Hyderabad','ananya.gupta@example.com','9876500007'),
('Karan Malhotra','Ahmedabad','karan.malhotra@example.com','9876500008'),
('Ishita Nair','Kochi','ishita.nair@example.com','9876500009'),
('Rohan Desai','Surat','rohan.desai@example.com','9876500010'),
('Tanvi Rao','Nagpur','tanvi.rao@example.com','9876500011'),
('Aditya Joshi','Indore','aditya.joshi@example.com','9876500012'),
('Meera Iyer','Chennai','meera.iyer@example.com','9876500013'),
('Sahil Khan','Lucknow','sahil.khan@example.com','9876500014'),
('Diya Arora','Gurugram','diya.arora@example.com','9876500015'),
('Kabir Bhatia','Noida','kabir.bhatia@example.com','9876500016'),
('Aisha Sheikh','Bhopal','aisha.sheikh@example.com','9876500017'),
('Yash Patel','Vadodara','yash.patel@example.com','9876500018'),
('Pooja Chawla','Ludhiana','pooja.chawla@example.com','9876500019'),
('Arnav Kulkarni','Thane','arnav.kulkarni@example.com','9876500020');

-- Seed Cars (10 popular/premium models)
INSERT INTO Cars (brand, model, year, price) VALUES
('Toyota','Fortuner',2024,3500000.00),
('Hyundai','Creta',2025,1600000.00),
('Maruti','Swift',2023,1200000.00),
('BMW','X5',2024,9000000.00),
('Kia','Seltos',2025,1800000.00),
('Tata','Harrier',2024,2400000.00),
('Mercedes','GLS 450',2025,11200000.00),
('Audi','Q7',2024,8900000.00),
('Mahindra','XUV700',2024,2300000.00),
('Honda','City',2024,1500000.00);

-- Seed Sales (20 rows; IDs map to inserted customers/cars)
INSERT INTO Sales (customer_id, car_id, sale_date, quantity, total_amount) VALUES
(1, 1, '2025-06-29', 1, 3500000.00),
(2, 4, '2025-05-15', 1, 9000000.00),
(3, 2, '2025-04-10', 1, 1600000.00),
(4, 7, '2025-07-22', 1, 11200000.00),
(5, 8, '2025-07-05', 1, 8900000.00),
(6, 3, '2025-06-10', 1, 1200000.00),
(7, 5, '2025-06-12', 1, 1800000.00),
(8, 6, '2025-06-18', 1, 2400000.00),
(9, 9, '2025-06-25', 1, 2300000.00),
(10, 10, '2025-06-28', 1, 1500000.00),
(11, 2, '2025-07-01', 1, 1600000.00),
(12, 5, '2025-07-03', 1, 1800000.00),
(13, 1, '2025-07-06', 1, 3500000.00),
(14, 4, '2025-07-09', 1, 9000000.00),
(15, 3, '2025-07-11', 1, 1200000.00),
(16, 6, '2025-07-14', 1, 2400000.00),
(17, 8, '2025-07-18', 1, 8900000.00),
(18, 9, '2025-07-20', 1, 2300000.00),
(19, 7, '2025-07-23', 1, 11200000.00),
(20, 10, '2025-07-25', 1, 1500000.00);

USE CarDealership;
SELECT * FROM customers LIMIT 15;
SELECT * FROM sales LIMIT 15;

-- most selled car 
SELECT c.brand, c.model, COUNT(*) AS total_sales
FROM Sales s
JOIN Cars c ON s.car_id = c.car_id
GROUP BY c.brand, c.model
ORDER BY total_sales DESC
LIMIT 1;

-- highest grossing car
SELECT c.brand, c.model, SUM(s.total_amount) AS total_revenue
FROM Sales s
JOIN Cars c ON s.car_id = c.car_id
GROUP BY c.brand, c.model
ORDER BY total_revenue DESC
LIMIT 1;

-- average car price according to sales
SELECT ROUND(AVG(total_amount), 2) AS avg_sale_price
FROM Sales;

-- city wise sales

SELECT cu.city, SUM(s.total_amount) AS total_revenue, COUNT(*) AS cars_sold
FROM Sales s
JOIN Customers cu ON s.customer_id = cu.customer_id
GROUP BY cu.city
ORDER BY total_revenue DESC;

-- top 5 highest revenue car

SELECT c.brand, c.model, SUM(s.total_amount) AS total_revenue
FROM Sales s
JOIN Cars c ON s.car_id = c.car_id
GROUP BY c.brand, c.model
ORDER BY total_revenue DESC
LIMIT 5;

-- brand market share
SELECT c.brand,
       ROUND((COUNT(*) / (SELECT COUNT(*) FROM Sales)) * 100, 2) AS market_share_percentage
FROM Sales s
JOIN Cars c ON s.car_id = c.car_id
GROUP BY c.brand
ORDER BY market_share_percentage DESC;
