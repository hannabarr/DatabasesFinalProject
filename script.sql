/*
 *  script.sql
 * 
 *  author: Harry Krantz
 *
 */


/*
 *	Create table, Rates, to hold a movie title, year, single actor name, first name, n increase rates
 *		Populate table with movie title, year, and actor name from Movies
 *		Populate table with first name only from actor name
 *	
 *	Crawl through Rates table
 *		Find name in BabyNames
 *		Get base count value(preceding year?)
 *		Get count for year of movie + n
 * 		Determine percentage increase for each year(maybe 5 years total)
 *		Save increase rates in rates table
 *
 *	Look in Rates table for potential names of interest, those with high increase rates
 *
 */

DROP TABLE IF EXISTS Rates;
CREATE TABLE Rates(
   id SERIAL NOT NULL,
   movie_title TEXT,
   movie_year INT,
   actor_name TEXT,
   first_name TEXT,
   year_1_rate FLOAT,
   year_2_rate FLOAT,
   year_3_rate FLOAT,
   year_4_rate FLOAT,
   year_5_rate FLOAT,
   PRIMARY KEY(id)
);


/*Insert movies and actors into rates table*/
INSERT INTO Rates (movie_title, movie_year, actor_name) SELECT movie_title, title_year, actor_1_name FROM Movies WHERE actor_1_name IS NOT NULL;
INSERT INTO Rates (movie_title, movie_year, actor_name) SELECT movie_title, title_year, actor_2_name FROM Movies WHERE actor_2_name IS NOT NULL;
INSERT INTO Rates (movie_title, movie_year, actor_name) SELECT movie_title, title_year, actor_3_name FROM Movies WHERE actor_3_name IS NOT NULL;


/*Parse actor names and get only first name*/
UPDATE Rates SET first_name = substring(actor_name from '^([^\s]+)');


/*Calculate name occurence growth rates for 5 years after movie is released*/
UPDATE Rates 
SET year_1_rate = CASE 
	(COALESCE(
		(SELECT count FROM BabyNames WHERE name = first_name AND year = (movie_year - 1) AND gender = 'M'), 0) + 
	COALESCE(
		(SELECT count FROM BabyNames WHERE name = first_name AND year = (movie_year - 1) AND gender = 'F'), 0)) 
	WHEN 0 THEN NULL 
	ELSE (
		(
			COALESCE((SELECT count FROM BabyNames WHERE name = first_name AND year = (movie_year + 0) AND gender = 'M'), 0) 
			+ COALESCE((SELECT count FROM BabyNames WHERE name = first_name AND year = (movie_year + 0) AND gender = 'F'), 0)
		)
		- 
		(
			COALESCE((SELECT count FROM BabyNames WHERE name = first_name AND year = (movie_year - 1) AND gender = 'M'), 0) 
			+ COALESCE((SELECT count FROM BabyNames WHERE name = first_name AND year = (movie_year - 1) AND gender = 'F'), 0))
		) 
	/ 
	(
		COALESCE((SELECT count FROM BabyNames WHERE name = first_name AND year = (movie_year - 1) AND gender = 'M'), 0) 
		+ COALESCE((SELECT count FROM BabyNames WHERE name = first_name AND year = (movie_year - 1) AND gender = 'F'), 0)
	) 
	END;











