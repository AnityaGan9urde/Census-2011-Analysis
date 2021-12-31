-- NOTE: Select any of the below SQL queries and press Execute to see their respective output.

-- // Analyzing Census for the year 2011 //

SELECT * FROM new_schema.`census_2011`;

-- Selecting data with basic information about a region

SELECT `State Name`, `District name`, Population, Male, Female, Literate, Households
FROM census_2011;

-- ---
-- Looking at the total population for all the states and the gender divide within these states

SELECT `State Name`, 
		SUM(Population) AS `Total Population`, 
        ROUND((Male/Population)*100, 2) AS `Percentage of Male (in %)`, 
        ROUND((Female/Population)*100, 2) AS `Percentage of Female (in %)`
FROM census_2011
GROUP BY `State Name`
ORDER BY 2 DESC;

-- ---
-- Let's look at the districts with the highest population in each state (most likely its capital)

SELECT `State Name`, 
		`District name` AS `Most Populated District`, 
        MAX(Population) AS Population 
FROM census_2011
WHERE `District name` IN (SELECT `District name`
							FROM census_2011
                          WHERE Population IN (SELECT MAX(Population)
												FROM census_2011
                                               GROUP BY `State Name`))
GROUP BY 1;

-- ---
-- How the age distribution of the population looks like?
-- State wise distribution:

-- CREATE VIEW state_age_dist AS
SELECT `State Name`,
		SUM(Population) AS `Total Population`,
		(SUM(Age_Group_0_29)/SUM(Population))*100 AS `0_to_29 (%)`, 
		(SUM(Age_Group_30_49)/SUM(Population))*100 AS `30_to_49 (%)`, 
        (SUM(Age_Group_50)/SUM(Population))*100 AS `50_plus (%)`, 
        (SUM(`Age not stated`)/SUM(Population))*100 AS `NotMentioned(%)`
FROM census_2011
GROUP BY `State Name`;

-- ---
-- Age distribution for the entire country:

-- CREATE VIEW total_age_dist AS
SELECT	SUM(Population) AS `Total Population`,
		(SUM(Age_Group_0_29)/SUM(Population))*100 AS `0_to_29 (%)`, 
		(SUM(Age_Group_30_49)/SUM(Population))*100 AS `30_to_49 (%)`, 
        (SUM(Age_Group_50)/SUM(Population))*100 AS `50_plus (%)`, 
        (SUM(`Age not stated`)/SUM(Population))*100 AS `NotMentioned(%)`
FROM census_2011;

-- ---
-- How many people live in rural regions as compared to urban regions state wise?

-- CREATE VIEW state_rural_urban AS
SELECT `State Name`,
		SUM(Households) AS Households,
		(SUM(Rural_Households)/SUM(Households))*100 AS `Rural_households(%)`,
		(SUM(Urban_Households)/SUM(Households))*100 AS `Urban_households(%)`
FROM census_2011
GROUP BY 1
ORDER BY 2 DESC;

-- For the whole India:

-- CREATE VIEW total_rural_urban AS
SELECT SUM(Population) AS `Total Population`,
		(SUM(Rural_Households)/SUM(Households))*100 AS `Rural_households(%)`,
		(SUM(Urban_Households)/SUM(Households))*100 AS `Urban_households(%)`
FROM census_2011;
-- >> India has a 33% urban population (Source: Internet) which gets verified here when the above query is run.

-- ---
-- SEX Ratio as per states

-- CREATE VIEW state_sex_ratio AS
SELECT `State Name`,
		Male, Female,
		CAST((SUM(Female)/SUM(Male))*1000 AS UNSIGNED) AS `SEX Ratio`
FROM census_2011
GROUP BY 1
ORDER BY 4 DESC;
-- >> Southern and North Eastern States have the highest Sex Ratio.
-- >> Northern States and many UTs have the lowest.

-- SEX Ratio of India:

-- CREATE VIEW total_sex_ratio AS
SELECT SUM(Male), 
	   SUM(Female),
	   CAST((SUM(Female)/SUM(Male))*1000 AS UNSIGNED) AS `SEX Ratio`
FROM census_2011;
-- comes at 943 which is close to 940, the national average, as obtained from Google.

-- ---
-- Now, finally what is the literacy rate of each state

-- CREATE VIEW state_literacy AS
SELECT `State Name`,
		(SUM(Literate)/SUM(Population))*100 AS `Literate populace(%)`
FROM census_2011
GROUP BY 1
ORDER BY 2 DESC;

-- Male vs. Female Literacy

-- CREATE VIEW male_female_literacy AS
SELECT `State Name`,
		(SUM(Male_Literate)/SUM(Male))*100 AS `Male literacy(%)`,
		(SUM(Female_Literate)/SUM(Female))*100 AS `Female literacy(%)`
FROM census_2011
GROUP BY 1
ORDER BY 2 DESC;

-- ---
-- Other amenities at homes
-- CREATE VIEW amenities_at_home AS
SELECT 
	`State Name`,
	(SUM(Housholds_with_Electric_Lighting) / SUM(Households)) * 100 AS `Electricity(%)`,
	(SUM(Households_with_Computer) / SUM(Households)) * 100 AS `Computers(%)`,
	(SUM(Households_with_Internet) / SUM(Households)) * 100 AS `Internet(%)`
FROM
	census_2011
GROUP BY 1
ORDER BY 1 ASC;
-- ---
-- Visualized further using Tableau.

