create table zepto( sku_id SERIAL PRIMARY KEY,
category VARCHAR(120),
name VARCHAR(150) NOT NULL, 
mrp NUMERIC(8,2), 
discountPercent NUMERIC(5,2), 
availableQuantity INTEGER, 
discountedSellingPrice NUMERIC(8,2), 
weightInGms INTEGER, outOfStock BOOLEAN, 
quantity INTEGER);

--exploring the data
SELECT COUNT(*) FROM ZEPTO;

SELECT * FROM ZEPTO LIMIT 10; 

--null values: NO NULL VALS
SELECT * FROM ZEPTO WHERE name IS NULL 
OR category IS NULL OR mrp IS NULL 
OR discountPercent IS NULL
OR availableQuantity IS NULL
OR weightInGms IS NULL
OR discountedSellingPrice IS NULL
OR outOfStock IS NULL;

--Exploring categories of products: 14 TOTAL FOUND
SELECT DISTINCT(category) FROM ZEPTO;

--Checking product availability:
SELECT COUNT(sku_id), outOfStock FROM ZEPTO
GROUP BY outOfStock;

--product names present multiple times
SELECT name, COUNT(sku_id) as "No of SKUs" 
FROM ZEPTO
GROUP BY name
HAVING COUNT(sku_id) >1
ORDER BY count(sku_id) DESC;

--data cleaning
--product with price = 0
SELECT * FROM ZEPTO WHERE mrp = 0 
OR discountedSellingPrice = 0;

DELETE FROM ZEPTO WHERE mrp = 0;

--Converting mrp from paise to rupees
UPDATE ZEPTO SET mrp = mrp/100;
UPDATE ZEPTO SET discountedSellingPrice 
= discountedSellingPrice/100;

--top 10 best value products based on discount %
SELECT DISTINCT name, mrp, discountPercent 
FROM ZEPTO ORDER BY discountPercent DESC LIMIT 10;

--Products with high mrp but out of stock
SELECT DISTINCT name, mrp, outOfStock 
FROM ZEPTO WHERE outOfStock IS TRUE AND mrp>300
ORDER BY mrp DESC ;

--estimated revenue for each category
SELECT category,
SUM(discountedSellingPrice * availablequantity) as revenue
FROM ZEPTO GROUP BY category 
ORDER BY revenue DESC;

--products with high mrp(>500) but low discount(<10%)
SELECT DISTINCT name, mrp, discountPercent 
FROM ZEPTO
WHERE mrp>500 AND discountPercent<10

--categories with best avg discounts
SELECT category, ROUND(AVG(discountPercent),2) as 
avg_Discount FROM ZEPTO 
GROUP BY CATEGORY
ORDER BY avg_Discount DESC LIMIT 5;  


