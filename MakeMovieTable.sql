DROP TABLE IF EXISTS movies;
CREATE TABLE movies
(
   	movie_title TEXT,
   	title_year INTEGER,
   	director_name TEXT,
   	actor_1_name TEXT,
   	actor_2_name TEXT,
   	actor_3_name TEXT,
   	gross INTEGER,
   	budget INTEGER,
   	imdb_score NUMERIC(2,1),
   	PRIMARY KEY(movie_title, title_year)
);

\COPY movies FROM 'movies.csv' NULL '' DELIMITER ','; 