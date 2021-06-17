--Simple way:
--SELECT AVG(rating) FROM ratings WHERE movie_id IN (SELECT id FROM movies WHERE year = 2012);
--Cryptic way:
SELECT AVG(rating) FROM ratings JOIN movies ON ratings.movie_id = movies.id WHERE movies.year = 2012;
