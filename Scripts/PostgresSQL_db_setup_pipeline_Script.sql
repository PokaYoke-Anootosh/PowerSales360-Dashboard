-- Creating dimension tables with Primary keys:


CREATE TABLE Customers_dim(
Customer_ID VARCHAR(9) PRIMARY KEY, 
Customer_Name TEXT NOT NULL,
Segment TEXT NOT NULL, 
City TEXT NOT NULL,
Postal_Code TEXT NOT NULL
);

CREATE TABLE Orders_dim(
Row_ID smallint UNIQUE NOT NULL, 
Order_ID TEXT PRIMARY KEY, 
Order_Date DATE NOT NULL,
Ship_Date DATE NOT NULL, 
Ship_Mode Text NOT NULL
);

CREATE TABLE Products_dim(
Product_ID VARCHAR(16) PRIMARY KEY, 
Category VARCHAR(15) NOT NULL, 
Sub_Category VARCHAR(14) NOT NULL, 
Product_Name TEXT NOT NULL 
);

CREATE TABLE Region_dim(
Country TEXT NOT NULL, 
State TEXT NOT NULL, 
City TEXT PRIMARY KEY, 
Postal_Code smallint NOT NULL, 
Region TEXT NOT NULL 
); 


--=================================================================
-- Correcting Table Column types : 


ALTER TABLE Region_dim
ALTER COLUMN Postal_Code TYPE TEXT ; 

ALTER TABLE Orders_dim
ALTER COLUMN Order_ID TYPE VARCHAR(15); 



-- ** Imported csv data tables in excel to each SQL dimension table created ** -- 


--=================================================================
-- Checking for the data imported in dimsension Tables: 

SELECT * FROM customers_dim; 

SELECT * FROM products_dim; 

SELECT * FROM orders_dim; 

SELECT * FROM region_dim; 


--=================================================================
-- Creating fact tables with foriegn key references: 

CREATE TABLE Salesdata_2015(
Row_ID INTEGER NOT NULL, 
Order_ID VARCHAR(15) NOT NULL, 
Order_Date DATE NOT NULL, 
Ship_Date DATE NOT NULL, 
Ship_Mode TEXT NOT NULL, 
Customer_ID VARCHAR(9) NOT NULL, 
Customer_Name TEXT NOT NULL, 
Segment TEXT NOT NULL, 
Country TEXT NOT NULL, 
City TEXT NOT NULL, 
State TEXT NOT NULL, 
Postal_Code TEXT NOT NULL, 
Region TEXT NOT NULL, 
Product_ID VARCHAR(16) NOT NULL,
Category VARCHAR(15) NOT NULL, 
Sub_Category VARCHAR(14) NOT NULL, 
Product_Name TEXT NOT NULL, 
Sales NUMERIC(10,2) NOT NULL
); 

CREATE TABLE Salesdata_2016(
Row_ID INTEGER NOT NULL, 
Order_ID VARCHAR(15) NOT NULL, 
Order_Date DATE NOT NULL, 
Ship_Date DATE NOT NULL, 
Ship_Mode TEXT NOT NULL, 
Customer_ID VARCHAR(9) NOT NULL, 
Customer_Name TEXT NOT NULL, 
Segment TEXT NOT NULL, 
Country TEXT NOT NULL, 
City TEXT NOT NULL, 
State TEXT NOT NULL, 
Postal_Code TEXT NOT NULL, 
Region TEXT NOT NULL, 
Product_ID VARCHAR(16) NOT NULL,
Category VARCHAR(15) NOT NULL, 
Sub_Category VARCHAR(14) NOT NULL, 
Product_Name TEXT NOT NULL, 
Sales NUMERIC(10,2) NOT NULL
); 

CREATE TABLE Salesdata_2017(
Row_ID INTEGER NOT NULL, 
Order_ID VARCHAR(15) NOT NULL, 
Order_Date DATE NOT NULL, 
Ship_Date DATE NOT NULL, 
Ship_Mode TEXT NOT NULL, 
Customer_ID VARCHAR(9) NOT NULL, 
Customer_Name TEXT NOT NULL, 
Segment TEXT NOT NULL, 
Country TEXT NOT NULL, 
City TEXT NOT NULL, 
State TEXT NOT NULL, 
Postal_Code TEXT NOT NULL, 
Region TEXT NOT NULL, 
Product_ID VARCHAR(16) NOT NULL,
Category VARCHAR(15) NOT NULL, 
Sub_Category VARCHAR(14) NOT NULL, 
Product_Name TEXT NOT NULL, 
Sales NUMERIC(10,2) NOT NULL
); 

CREATE TABLE Salesdata_2018(
Row_ID INTEGER NOT NULL, 
Order_ID VARCHAR(15) NOT NULL, 
Order_Date DATE NOT NULL, 
Ship_Date DATE NOT NULL, 
Ship_Mode TEXT NOT NULL, 
Customer_ID VARCHAR(9) NOT NULL, 
Customer_Name TEXT NOT NULL, 
Segment TEXT NOT NULL, 
Country TEXT NOT NULL, 
City TEXT NOT NULL, 
State TEXT NOT NULL, 
Postal_Code TEXT NOT NULL, 
Region TEXT NOT NULL, 
Product_ID VARCHAR(16) NOT NULL,
Category VARCHAR(15) NOT NULL, 
Sub_Category VARCHAR(14) NOT NULL, 
Product_Name TEXT NOT NULL, 
Sales NUMERIC(10,2) NOT NULL
); 



--=================================================================
-- Correcting Table Column types : 

-- Blank Lines in Postal Code causing problems in Import. Hence, dropping NOT NULL Constraint 

ALTER TABLE Salesdata_2015 
ALTER COLUMN postal_code DROP NOT NULL; 

ALTER TABLE Salesdata_2016
ALTER COLUMN postal_code DROP NOT NULL; 

ALTER TABLE Salesdata_2017
ALTER COLUMN postal_code DROP NOT NULL; 

ALTER TABLE Salesdata_2018
ALTER COLUMN postal_code DROP NOT NULL; 



-- ** Imported csv data tables in excel to each SQL dimension table created ** -- 


--=================================================================
--Cleaning blank values in all Fact tables: 


UPDATE salesdata_2015
SET postal_code = '0' 
WHERE postal_code IS NULL OR postal_code = ' ' ; 

UPDATE salesdata_2016
SET postal_code = '0'
WHERE postal_code IS NULL OR postal_code = ' ' ; 

UPDATE salesdata_2017
SET postal_code = '0'
WHERE postal_code IS NULL OR postal_code = ' ' ; 

UPDATE salesdata_2018
SET postal_code = '0'
WHERE postal_code IS NULL OR postal_code = ' ' ; 


--=================================================================
--Creating Foreign Key References to dimension tables: 


ALTER TABLE salesdata_2015 
ADD CONSTRAINT fk_OrderID FOREIGN KEY (order_id) REFERENCES orders_dim(order_id),
ADD CONSTRAINT fk_CustID FOREIGN KEY (customer_id) REFERENCES customers_dim(customer_id), 
ADD CONSTRAINT fk_ProdID FOREIGN KEY (product_id) REFERENCES products_dim(product_id), 
ADD CONSTRAINT fk_City FOREIGN KEY (city) REFERENCES region_dim(city); 

ALTER TABLE salesdata_2016 
ADD CONSTRAINT fk_OrderID FOREIGN KEY (order_id) REFERENCES orders_dim(order_id),
ADD CONSTRAINT fk_CustID FOREIGN KEY (customer_id) REFERENCES customers_dim(customer_id), 
ADD CONSTRAINT fk_ProdID FOREIGN KEY (product_id) REFERENCES products_dim(product_id), 
ADD CONSTRAINT fk_City FOREIGN KEY (city) REFERENCES region_dim(city); 

ALTER TABLE salesdata_2017
ADD CONSTRAINT fk_OrderID FOREIGN KEY (order_id) REFERENCES orders_dim(order_id),
ADD CONSTRAINT fk_CustID FOREIGN KEY (customer_id) REFERENCES customers_dim(customer_id), 
ADD CONSTRAINT fk_ProdID FOREIGN KEY (product_id) REFERENCES products_dim(product_id), 
ADD CONSTRAINT fk_City FOREIGN KEY (city) REFERENCES region_dim(city); 

ALTER TABLE salesdata_2018 
ADD CONSTRAINT fk_OrderID FOREIGN KEY (order_id) REFERENCES orders_dim(order_id),
ADD CONSTRAINT fk_CustID FOREIGN KEY (customer_id) REFERENCES customers_dim(customer_id), 
ADD CONSTRAINT fk_ProdID FOREIGN KEY (product_id) REFERENCES products_dim(product_id), 
ADD CONSTRAINT fk_City FOREIGN KEY (city) REFERENCES region_dim(city); 



--=================================================================
-- Checking for the data imported in Fact Tables: 


SELECT * FROM Salesdata_2015; 

SELECT * FROM Salesdata_2016; 

SELECT * FROM Salesdata_2017; 

SELECT * FROM Salesdata_2018; 



--================================================================= 
--Creating one large Collated Fact dataset: 


CREATE TABLE Salesdata_Collated AS 
SELECT * FROM salesdata_2015 
UNION ALL 
SELECT * FROM salesdata_2016
UNION ALL
SELECT * FROM salesdata_2017
UNION ALL
SELECT * FROM salesdata_2018 
ORDER BY order_date; 


SELECT * FROM salesdata_collated; 


--**Dataset Created Successfully**-- 


--================================================================= 
--Creating Foreign Key relationships for salesdata_collated with dim tables: 

ALTER TABLE salesdata_collated
ADD CONSTRAINT fk_OrderID FOREIGN KEY (order_id) REFERENCES orders_dim(order_id),
ADD CONSTRAINT fk_CustID FOREIGN KEY (customer_id) REFERENCES customers_dim(customer_id), 
ADD CONSTRAINT fk_ProdID FOREIGN KEY (product_id) REFERENCES products_dim(product_id), 
ADD CONSTRAINT fk_City FOREIGN KEY (city) REFERENCES region_dim(city);
 


SELECT * FROM salesdata_collated; 


--**Star Schema created successfully**-- 

