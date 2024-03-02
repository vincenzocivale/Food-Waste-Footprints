-- Create the "food_dataset" table to store food waste data
CREATE TABLE food_dataset (
    m49_code integer,
    country text,
    region text,
    cpc_code text,
    commodity text,
    year integer,
    loss_percentage numeric,
    loss_percentage_original text,
    loss_quantity text,
    activity text,
    food_supply_stage text,
    treatment text,
    cause_of_loss text,
    sample_size text,
    method_data_collection text,
    reference text,
    url text,
    notes text
);
-- Calculate the quantity of wasted food each year according to the FAO dataset

COPY food_dataset (m49_code, country , region, cpc_code, commodity, year, loss_percentage, loss_percentage_original, loss_quantity, activity, food_supply_stage, treatment, cause_of_loss , sample_size, method_data_collection , reference , url, notes)
FROM 'C:\\Program Files\\PostgreSQL\\15\data\\ProgettoSQL\\Data.csv'
DELIMITER ',' 
CSV HEADER;

--SLIDE 3

-- Determine the number of analyzed countries for each year

SELECT year, SUM(CASE WHEN loss_quantity ~ '^[0-9.]+$' THEN CAST(loss_quantity AS DECIMAL) ELSE 0 END) AS total_loss
FROM food_dataset
GROUP BY year
ORDER BY year;

-- Per determinare il numero di Paesi analizzati per ciascun anno
SELECT year, COUNT(country)
FROM food_dataset
GROUP BY year
ORDER BY year ASC;
-- Note that there are only 26 data points for 2021, so the data for the year 2018 is considered

-- SLIDE 4

-- Select the most common 5 commodities
SELECT commodity, COUNT(commodity) AS food_count
FROM food_dataset
WHERE year = 2018
GROUP BY commodity
ORDER BY food_count DESC
LIMIT 5;


-- SLIDE 5

-- Determine the most and least virtuous countries in terms of food waste in 2018

-- Drop the "country_waste" table if it already exists
DROP TABLE IF EXISTS country_waste;

-- Create the "country_waste" table che tiene traccia della loss_percentage media di ciascun anno, secondo i dati del 2018
CREATE TABLE country_waste (
    country VARCHAR(255),
    avg_loss_percentage DECIMAL(10, 2),
	year INTEGER
);

INSERT INTO country_waste (year, country, avg_loss_percentage)
SELECT year, country, AVG(loss_percentage) AS avg_loss_percentage
FROM food_dataset
GROUP BY year, country;



-- Select the 5 countries with the highest loss percentage
SELECT country, avg_loss_percentage
FROM country_waste
WHERE year = 2018
ORDER BY avg_loss_percentage DESC
LIMIT 5;

-- Select the 5 countries with the lowest loss percentage
SELECT country, avg_loss_percentage
FROM country_waste
WHERE year = 2018
ORDER BY avg_loss_percentage ASC
LIMIT 5;


-- SLIDE 6  

-- Determine the most problematic food supply stage. It's observed that the Farm stage is the most critical.

SELECT food_supply_stage, COUNT(food_supply_stage)
FROM food_dataset
WHERE year = 2018
GROUP BY food_supply_stage
ORDER BY COUNT(food_supply_stage) DESC;





-- SLIDE 8

-- An example is being presented to illustrate how the historical demand for food products enables the prediction of future demand and aids in reducing overproduction and the resulting waste.

-- The dataset on food demand collected from FAO (https://www.fao.org/faostat/en/#data/FBS) is being imported.
CREATE TABLE food_demand (
    Area_Code INT,
    Area_Code_M49 VARCHAR(255),
    Area VARCHAR(255),
    Item_Code INT,
    Item_Code_CPC VARCHAR(255),
    Item VARCHAR(255),
    Element_Code INT,
    Element VARCHAR(255),
    Unit VARCHAR(255),
    Y2010 FLOAT,
    Y2010F VARCHAR(255),
    Y2011 FLOAT,
    Y2011F VARCHAR(255),
    Y2012 FLOAT,
    Y2012F VARCHAR(255),
    Y2013 FLOAT,
    Y2013F VARCHAR(255),
    Y2014 FLOAT,
    Y2014F VARCHAR(255),
    Y2015 FLOAT,
    Y2015F VARCHAR(255),
    Y2016 FLOAT,
    Y2016F VARCHAR(255),
    Y2017 FLOAT,
    Y2017F VARCHAR(255),
    Y2018 FLOAT,
    Y2018F VARCHAR(255),
    Y2019 FLOAT,
    Y2019F VARCHAR(255),
    Y2020 FLOAT,
    Y2020F VARCHAR(255)
);

COPY food_demand 
FROM 'C:\\Program Files\\PostgreSQL\\15\\data\\ProgettoSQL\\FoodBalanceSheets_E_All_Data.csv' 
DELIMITER ',' CSV HEADER ENCODING 'ISO-8859-1';

-- The quantity of demand for 'Wheat and products' in Europe is determined for the years between 2010 and 2020. This approach can help create a model to forecast demand and avoid overproduction, which leads to wastage.
SELECT
    Item,
    Area,
    SUM(Y2010) ,
    SUM(Y2011) ,
    SUM(Y2012) ,
    SUM(Y2013),
    SUM(Y2014) ,
    SUM(Y2015),
    SUM(Y2016),
    SUM(Y2017),
    SUM(Y2018),
    SUM(Y2019),
    SUM(Y2020)
FROM
    food_demand
WHERE
    Item = 'Wheat and products'
    AND Area = 'Europe'
GROUP BY
    Item, Area;

-- SLIDE 9
 
-- The quantity of edible food considered as waste in the USA in 2018 is estimated, based on information from the article "Estimating Quantities and Types of Food Waste at the City Level" by Darby Hoover from the Natural Resources Defense Council (NRDC).

SELECT SUM(Y2018 * 0.57) AS saveable_food
FROM food_demand
WHERE Area = 'United States of America' AND Unit = '1000 tonnes';


-- SLIDE 10 


-- A table is created to store the minimum loss percentage for each year.

CREATE TABLE min_loss_percentage (
    year INTEGER,
    min_loss_percentage  numeric
);

INSERT INTO min_loss_percentage (year, min_loss_percentage)
SELECT year, MIN(avg_loss_percentage)
FROM country_waste
GROUP BY year;


DROP TABLE IF EXISTS yearly_wasted;

-- A table is created to store the actual wasted food quantity, calculated as the product of the sum of food and the actual loss percentage, as well as the quantity of wasted food if every nation had the lowest loss percentage for that year.
CREATE TABLE yearly_wasted (
	country text,
    year INTEGER,
    wasted_food  numeric,
	ideal_wasted_food numeric
);

INSERT INTO yearly_wasted(country, year, wasted_food, ideal_wasted_food)
SELECT country_waste.country, min_loss_percentage.year,
       (SUM(food_demand.Y2012) * country_waste.avg_loss_percentage) AS wasted_food,
       (SUM(food_demand.Y2012) * min_loss_percentage.min_loss_percentage) AS ideal_wasted_food
FROM country_waste
INNER JOIN food_demand ON country_waste.country = food_demand.Area
INNER JOIN min_loss_percentage ON country_waste.year = min_loss_percentage.year
WHERE country_waste.year = 2012 AND food_demand.Unit = '1000 tonnes'
GROUP BY country_waste.country, min_loss_percentage.year, min_loss_percentage.min_loss_percentage, country_waste.avg_loss_percentage;


INSERT INTO yearly_wasted(country, year, wasted_food, ideal_wasted_food)
SELECT country_waste.country, min_loss_percentage.year,
       (SUM(food_demand.Y2013) * country_waste.avg_loss_percentage) AS wasted_food,
       (SUM(food_demand.Y2013) * min_loss_percentage.min_loss_percentage) AS ideal_wasted_food
FROM country_waste
INNER JOIN food_demand ON country_waste.country = food_demand.Area
INNER JOIN min_loss_percentage ON country_waste.year = min_loss_percentage.year
WHERE country_waste.year = 2013 AND food_demand.Unit = '1000 tonnes'
GROUP BY country_waste.country, min_loss_percentage.year, min_loss_percentage.min_loss_percentage, country_waste.avg_loss_percentage;

INSERT INTO yearly_wasted(country, year, wasted_food, ideal_wasted_food)
SELECT country_waste.country, min_loss_percentage.year,
       (SUM(food_demand.Y2014) * country_waste.avg_loss_percentage) AS wasted_food,
       (SUM(food_demand.Y2014) * min_loss_percentage.min_loss_percentage) AS ideal_wasted_food
FROM country_waste
INNER JOIN food_demand ON country_waste.country = food_demand.Area
INNER JOIN min_loss_percentage ON country_waste.year = min_loss_percentage.year
WHERE country_waste.year = 2014 AND food_demand.Unit = '1000 tonnes'
GROUP BY country_waste.country, min_loss_percentage.year, min_loss_percentage.min_loss_percentage, country_waste.avg_loss_percentage;

INSERT INTO yearly_wasted(country, year, wasted_food, ideal_wasted_food)
SELECT country_waste.country, min_loss_percentage.year,
       (SUM(food_demand.Y2015) * country_waste.avg_loss_percentage) AS wasted_food,
       (SUM(food_demand.Y2015) * min_loss_percentage.min_loss_percentage) AS ideal_wasted_food
FROM country_waste
INNER JOIN food_demand ON country_waste.country = food_demand.Area
INNER JOIN min_loss_percentage ON country_waste.year = min_loss_percentage.year
WHERE country_waste.year = 2015 AND food_demand.Unit = '1000 tonnes'
GROUP BY country_waste.country, min_loss_percentage.year, min_loss_percentage.min_loss_percentage, country_waste.avg_loss_percentage;


INSERT INTO yearly_wasted(country, year, wasted_food, ideal_wasted_food)
SELECT country_waste.country, min_loss_percentage.year,
       (SUM(food_demand.Y2016) * country_waste.avg_loss_percentage) AS wasted_food,
       (SUM(food_demand.Y2016) * min_loss_percentage.min_loss_percentage) AS ideal_wasted_food
FROM country_waste
INNER JOIN food_demand ON country_waste.country = food_demand.Area
INNER JOIN min_loss_percentage ON country_waste.year = min_loss_percentage.year
WHERE country_waste.year = 2016 AND food_demand.Unit = '1000 tonnes'
GROUP BY country_waste.country, min_loss_percentage.year, min_loss_percentage.min_loss_percentage, country_waste.avg_loss_percentage;


INSERT INTO yearly_wasted(country, year, wasted_food, ideal_wasted_food)
SELECT country_waste.country, min_loss_percentage.year,
       (SUM(food_demand.Y2017) * country_waste.avg_loss_percentage) AS wasted_food,
       (SUM(food_demand.Y2017) * min_loss_percentage.min_loss_percentage) AS ideal_wasted_food
FROM country_waste
INNER JOIN food_demand ON country_waste.country = food_demand.Area
INNER JOIN min_loss_percentage ON country_waste.year = min_loss_percentage.year
WHERE country_waste.year = 2017 AND food_demand.Unit = '1000 tonnes'
GROUP BY country_waste.country, min_loss_percentage.year, min_loss_percentage.min_loss_percentage, country_waste.avg_loss_percentage;


INSERT INTO yearly_wasted(country, year, wasted_food, ideal_wasted_food)
SELECT country_waste.country, min_loss_percentage.year,
       (SUM(food_demand.Y2018) * country_waste.avg_loss_percentage) AS wasted_food,
       (SUM(food_demand.Y2018) * min_loss_percentage.min_loss_percentage) AS ideal_wasted_food
FROM country_waste
INNER JOIN food_demand ON country_waste.country = food_demand.Area
INNER JOIN min_loss_percentage ON country_waste.year = min_loss_percentage.year
WHERE country_waste.year = 2018 AND food_demand.Unit = '1000 tonnes'
GROUP BY country_waste.country, min_loss_percentage.year, min_loss_percentage.min_loss_percentage, country_waste.avg_loss_percentage;


INSERT INTO yearly_wasted(country, year, wasted_food, ideal_wasted_food)
SELECT country_waste.country, min_loss_percentage.year,
       (SUM(food_demand.Y2019) * country_waste.avg_loss_percentage) AS wasted_food,
       (SUM(food_demand.Y2019) * min_loss_percentage.min_loss_percentage) AS ideal_wasted_food
FROM country_waste
INNER JOIN food_demand ON country_waste.country = food_demand.Area
INNER JOIN min_loss_percentage ON country_waste.year = min_loss_percentage.year
WHERE country_waste.year = 2019 AND food_demand.Unit = '1000 tonnes'
GROUP BY country_waste.country, min_loss_percentage.year, min_loss_percentage.min_loss_percentage, country_waste.avg_loss_percentage;




-- The actual estimate of wasted food and the estimate of food that could have been wasted if each nation had the lowest loss percentage for the year are selected.
SELECT year, (SUM(wasted_food)) AS real_wasted, (SUM(ideal_wasted_food)) AS ideal_wasted 
FROM yearly_wasted 
GROUP BY year
ORDER BY year ASC;