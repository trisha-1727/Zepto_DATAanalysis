# Zepto_DATAanalysis

## Zepto Data Analysis (SQL | PostgreSQL)
This project focuses on analyzing a Zepto product dataset (sourced from Kaggle) to uncover insights related to pricing, discounts, stock availability, and category-wise revenue using SQL.

### Dataset

* Source: Kaggle
* Contains product-level data including category, pricing (MRP & discounted price), discount percentage, stock availability, and quantity.
* Link: https://www.kaggle.com/datasets/palvinder2006/zepto-inventory-dataset/data?select=zepto_v2.csv

### Database Schema
```sql
CREATE TABLE zepto (
    sku_id SERIAL PRIMARY KEY,
    category VARCHAR(120),
    name VARCHAR(150) NOT NULL,
    mrp NUMERIC(8,2),
    discountPercent NUMERIC(5,2),
    availableQuantity INTEGER,
    discountedSellingPrice NUMERIC(8,2),
    weightInGms INTEGER,
    outOfStock BOOLEAN,
    quantity INTEGER
);
```

### Data Exploration
```sql
-- Total records
SELECT COUNT(*) FROM zepto;

-- Preview data
SELECT * FROM zepto LIMIT 10;

-- Check for null values
SELECT * FROM zepto 
WHERE name IS NULL OR category IS NULL OR mrp IS NULL 
OR discountPercent IS NULL OR availableQuantity IS NULL 
OR weightInGms IS NULL OR discountedSellingPrice IS NULL 
OR outOfStock IS NULL;

-- Unique categories
SELECT DISTINCT category FROM zepto;
```

### Data Cleaning
```sql
-- Identify invalid pricing
SELECT * FROM zepto 
WHERE mrp = 0 OR discountedSellingPrice = 0;

-- Remove invalid records
DELETE FROM zepto WHERE mrp = 0;

-- Convert paise to rupees
UPDATE zepto SET mrp = mrp / 100;
UPDATE zepto SET discountedSellingPrice = discountedSellingPrice / 100;
```

### Exploratory Analysis
```sql
-- Stock availability
SELECT COUNT(sku_id), outOfStock 
FROM zepto 
GROUP BY outOfStock;

-- Duplicate product names
SELECT name, COUNT(sku_id) AS "No of SKUs"
FROM zepto
GROUP BY name
HAVING COUNT(sku_id) > 1
ORDER BY COUNT(sku_id) DESC;

-- Top 10 highest discount products
SELECT DISTINCT name, mrp, discountPercent 
FROM zepto 
ORDER BY discountPercent DESC 
LIMIT 10;

-- High MRP products out of stock
SELECT DISTINCT name, mrp, outOfStock 
FROM zepto 
WHERE outOfStock IS TRUE AND mrp > 300
ORDER BY mrp DESC;
```

###  Business Insights
```sql
-- Estimated revenue by category
SELECT category,
SUM(discountedSellingPrice * availableQuantity) AS revenue
FROM zepto
GROUP BY category
ORDER BY revenue DESC;

-- High MRP but low discount products
SELECT DISTINCT name, mrp, discountPercent
FROM zepto
WHERE mrp > 500 AND discountPercent < 10;

-- Categories with highest average discounts
SELECT category, ROUND(AVG(discountPercent), 2) AS avg_discount
FROM zepto
GROUP BY category
ORDER BY avg_discount DESC
LIMIT 5;
```

### Key Insights
* Identified **top discounted products** to understand pricing strategies.
* Detected **high-value items that are out of stock**, indicating potential demand gaps.
* Estimated **category-wise revenue**, highlighting top-performing segments.
* Found **premium products with low discounts**, suggesting pricing optimization opportunities.
* Analyzed **average discount trends across categories**.

### Tech Stack
* SQL (PostgreSQL)
* Data Cleaning & EDA
* Kaggle Dataset
