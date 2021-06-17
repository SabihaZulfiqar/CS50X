SELECT name FROM people
JOIN stars ON people.id = stars.person_id
JOIN movies ON stars.movie_id = movies.id
WHERE people.id = (SELECT stars.person_id WHERE stars.movie_id = (SELECT movies.id WHERE movies.title = "Toy Story"));