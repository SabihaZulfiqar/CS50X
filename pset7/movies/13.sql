SELECT name FROM people
JOIN stars ON people.id = stars.person_id
JOIN movies ON stars.movie_id = movies.id
WHERE stars.movie_id IN
(SELECT movies.id FROM movies
JOIN stars ON movies.id = stars.movie_id
JOIN people ON stars.person_id = people.id
WHERE stars.person_id =
(SELECT people.id from people
WHERE people.name = "Kevin Bacon" AND people.birth = "1958"))
AND people.name != "Kevin Bacon";