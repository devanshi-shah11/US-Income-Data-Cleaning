# US Household Data Exploration
USE USHouseholdIncome;

SELECT *
FROM ushouseholdincome_cleaned;

SELECT *
FROM ushouseholdincome_statistics;

SELECT State_Name, ALand, AWater
FROM ushouseholdincome_cleaned;

## ANALYSIS 1: Amount of Water and Land Area for different States sorted according to Land Area in Ascending Order
SELECT State_Name, SUM(ALand), SUM(AWater)
FROM ushouseholdincome_cleaned
GROUP BY State_Name
ORDER BY 2;

## ANALYSIS 2: TOP 10 States by Largest Land Area
SELECT State_Name, SUM(ALand), SUM(AWater)
FROM ushouseholdincome_cleaned
GROUP BY State_Name
ORDER BY 2 DESC
LIMIT 10;

## ANALYSIS 3: TOP 10 States by Largest Water Area
SELECT State_Name, SUM(ALand), SUM(AWater)
FROM ushouseholdincome_cleaned
GROUP BY State_Name
ORDER BY 3 DESC
LIMIT 10;

## Joining income data and statistics data
SELECT *
FROM ushouseholdincome_cleaned u
JOIN ushouseholdincome_statistics us
ON u.id = us.id;
    

SELECT u.State_Name, County, `Type`, `Primary`, Mean, Median
FROM ushouseholdincome_cleaned u
JOIN ushouseholdincome_statistics us
ON u.id = us.id
WHERE Mean <> 0;

# ANALYSIS 4 : States according to Lowest Avg Household Income for the entire household (TOP 10)
SELECT u.State_Name, ROUND(AVG(Mean),1), ROUND(AVG(Median),1)
FROM ushouseholdincome_cleaned u
JOIN ushouseholdincome_statistics us
ON u.id = us.id
WHERE Mean <> 0
GROUP BY u.State_Name
order by 2 
LIMIT 10;

## ANALYSIS 5: Highest Median Household Income according to States (Top 10)
SELECT u.State_Name,ROUND(AVG(Mean),1), ROUND(AVG(Median),1)
FROM ushouseholdincome_cleaned u
JOIN ushouseholdincome_statistics us
ON u.id = us.id
WHERE Mean <> 0
GROUP BY u.State_Name
order by 3 DESC
LIMIT 10;

## ANALYSIS 6: Top 20 Types of Households with Average Household Income 
SELECT `Type`, ROUND(AVG(Mean),1), ROUND(AVG(Median),1)
FROM ushouseholdincome_cleaned u
JOIN ushouseholdincome_statistics us
ON u.id = us.id
WHERE Mean <> 0
GROUP BY `Type`
order by 2 DESC
LIMIT 20;

## ANALYSIS 7: Top 20 Count of Types of Households with Average Household Income 
SELECT `Type`,COUNT(`Type`), ROUND(AVG(Mean),1), ROUND(AVG(Median),1)
FROM ushouseholdincome_cleaned u
JOIN ushouseholdincome_statistics us
ON u.id = us.id
WHERE Mean <> 0
GROUP BY `Type`
order by 2 DESC 
LIMIT 20;

## ANALYSIS 8 : Top 20 Average Household Income by Count of Tyoe of Household where type > 100
SELECT `Type`,COUNT(`Type`), ROUND(AVG(Mean),1), ROUND(AVG(Median),1)
FROM ushouseholdincome_cleaned u
JOIN ushouseholdincome_statistics us
ON u.id = us.id
WHERE Mean <> 0
GROUP BY `Type`
HAVING COUNT(`Type`) > 100
order by 3
LIMIT 20;


SELECT *
FROM ushouseholdincome_cleaned u
JOIN ushouseholdincome_statistics us
ON u.id = us.id;

## ANALYSIS 10 : States and Cities with the highest Average Household Income
SELECT u.State_Name, City, ROUND(AVG(Mean), 1), ROUND(AVG(Median),1)
FROM ushouseholdincome_cleaned u
JOIN ushouseholdincome_statistics us
ON u. id = us.id
GROUP BY u. State_Name, City
ORDER BY ROUND(AVG(Mean), 1) DESC
LIMIT 10;


