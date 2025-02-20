--Creating Grocery_data Table--
DROP TABLE IF EXISTS Grocery_data;
CREATE TABLE Grocery_data (
Item_Fat_Content TEXT,
Item_Identifier	TEXT,
Item_Type TEXT,
Outlet_Establishment_Year INT,
Outlet_Identifier TEXT,
Outlet_Location_Type TEXT,
Outlet_Size TEXT,
Outlet_Type	TEXT,
Item_Visibility	FLOAT,
Item_Weight	FLOAT,
Total_Sales FLOAT,
Rating FLOAT
);

SELECT * FROM Grocery_data;
SELECT COUNT(*) FROM Grocery_data;

---Data Cleaning---
--1. 
UPDATE Grocery_data
SET Item_Fat_Content =
CASE 
   WHEN Item_Fat_Content IN ('LF', 'low fat') THEN 'Low Fat'
   WHEN Item_Fat_Content = 'reg' THEN 'Regular'
   ELSE Item_Fat_Content
END

SELECT DISTINCT(Item_Fat_Content) FROM Grocery_data;

-- DATA ANALYSIS FOR KPI REQUIREMENTS --

--1. Find Total Sales
CREATE VIEW Total_Sales AS
SELECT SUM(total_sales) AS Total_Sales
FROM Grocery_data;

SELECT * FROM Total_Sales;

--2. Find Average Sales
CREATE VIEW Average_Sales AS
SELECT ROUND(AVG(Total_Sales)::NUMERIC, 1) AS Avg_sales
FROM Grocery_data;

SELECT * FROM Average_Sales;

--3. Number of Items
CREATE VIEW No_of_Items AS
SELECT COUNT(*) AS No_of_Items
FROM Grocery_data;

SELECT * FROM No_of_Items;

--4. Total Sales of Low Fat Content Items
CREATE VIEW Total_LowFat_Sales AS
SELECT SUM(total_sales) AS Total_Low_Fat_Sales
FROM Grocery_data
WHERE Item_Fat_Content = 'Low Fat';

SELECT * FROM Total_LowFat_Sales;

--5. Total Sales of Establishment year 2022
CREATE VIEW Total_Sales_in_2022 AS
SELECT SUM(total_sales) AS Total_Sales
FROM Grocery_data
WHERE Outlet_Establishment_Year = 2022;

SELECT * FROM Total_Sales_in_2022;

--6. Find Average Rating
CREATE OR REPLACE VIEW Average_Rating AS 
SELECT ROUND(AVG(Rating)::NUMERIC, 2) AS Avg_Rating 
FROM Grocery_data;

SELECT * FROM Average_Rating;

-- DATA ANALYSIS FOR GRANULAR REQUIREMENTS --

--1. Total Sales and Average sales by Fat Content of specific Year
CREATE OR REPLACE VIEW Fat_Content_Details AS 
SELECT Item_Fat_Content,
	ROUND(SUM(Total_Sales)::NUMERIC, 2) AS Total_Sales,
	ROUND(AVG(Total_Sales)::NUMERIC, 1) AS Avg_Sales
FROM Grocery_data
WHERE Outlet_Establishment_Year = 2020
GROUP BY Item_Fat_Content
ORDER BY Total_Sales DESC;

SELECT * FROM Fat_Content_Details;

--2. Total Sales and Average Sales by Item Type of Specific Year
CREATE OR REPLACE VIEW Item_Type_Details AS 
SELECT Item_Type,
	ROUND(SUM(Total_Sales)::NUMERIC, 2) AS Total_Sales,
	ROUND(AVG(Total_Sales)::NUMERIC, 1) AS Avg_Sales
FROM Grocery_data
WHERE Outlet_Establishment_Year = 2020
GROUP BY Item_Type
ORDER BY Total_Sales DESC;

SELECT * FROM Item_Type_Details;

--3. Fat Content by Outlet for Total Sales 
CREATE OR REPLACE VIEW Outlet_Sales AS 
SELECT 
    Outlet_Location_Type,
    COALESCE(SUM(Total_Sales) FILTER (WHERE Item_Fat_Content = 'Low Fat'), 0) AS Low_Fat,
    COALESCE(SUM(Total_Sales) FILTER (WHERE Item_Fat_Content = 'Regular'), 0) AS Regular
FROM Grocery_data
GROUP BY Outlet_Location_Type
ORDER BY Outlet_Location_Type;


SELECT * FROM Outlet_Sales;

--4. Total Sales by Outlet Establishment
CREATE OR REPLACE VIEW Sales_by_Outlet_Establishment AS
SELECT Outlet_Establishment_Year, CAST(SUM(Total_Sales) AS DECIMAL(10,2)) AS Total_Sales
FROM Grocery_data
GROUP BY Outlet_Establishment_Year
ORDER BY Outlet_Establishment_Year;

SELECT * FROM Sales_by_Outlet_Establishment;

--5. All Metrics by Outlet Type
CREATE OR REPLACE VIEW Outlet_Metrics AS
SELECT Outlet_Type,
	ROUND(SUM(Total_Sales)::NUMERIC, 2) AS Total_Sales,
	ROUND(AVG(Total_Sales)::NUMERIC, 1) AS Avg_Sales,
	ROUND(AVG(Rating)::NUMERIC, 2) AS Avg_Rating
FROM Grocery_data
GROUP BY Outlet_Type
ORDER BY Total_Sales DESC;

SELECT * FROM Outlet_Metrics;

--END OF PROJECT--










































