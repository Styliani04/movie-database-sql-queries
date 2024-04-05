
/*
"Βρες ποιο είδος ταινίας έχει το υψηλότερο μέσο όρο budget."
Output: Adventure  20407946,913729127
*/
SELECT TOP(1) genre.name, AVG(budget) AS average_budget
FROM genre LEFT OUTER JOIN hasGenre ON genre.id = hasGenre.genre_id 
JOIN movie ON movie.id = hasGenre.movie_id
GROUP BY genre.name
ORDER BY AVG(budget) DESC;

/*
"Βρες τις 5 ταινίες με τις καλύτερες κριτικές οι οποίες κυκλοφόρησαν το διάστημα 1990-2000 και έχουν πάνω απο 50 κριτικές, ταξινομημένες απο την "καλύτερη" στην "χειρότερη"."
Output: 
Sleepless in Seattle	1993-06-24	44,875	200
The Million Dollar Hotel	2000-02-09	44,87138263665595	311
The Thomas Crown Affair	1999-08-06	43,87096774193548	62
Once Were Warriors	1994-09-02	43,032786885245905	244
Hard Target	1993-08-20	42,77777777777778	54
*/
SELECT TOP(5) title, release_date, AVG(ratings.rating) AS review, COUNT(user_id) AS people_rated
FROM movie JOIN ratings ON movie.id = ratings.movie_id
WHERE year(release_date) BETWEEN 1990 AND 2000
GROUP BY movie_id, title, release_date
HAVING COUNT(user_id) > 50
ORDER BY review DESC;

/*
"Βρες ποιές ταινίες σχετίζονται με τον σεξισμό."
Output:
A Few Good Men
Anchorman: The Legend of Ron Burgundy
Catwoman
G.I. Jane
Giant
Just One of the Guys
Moolaad�
Road Trip
The Associate
The Handmaid's Tale
The Last Supper
Up!
*/
SELECT DISTINCT title
FROM movie JOIN HasKeyword ON movie.id = HasKeyword.Movie_ID
JOIN Keyword ON HasKeyword.Keyword_ID = Keyword.ID
WHERE Keyword.name = 'sexism';

/*
"Βρες σε πόσες ταινίες συμμετέχει ηθοποιός του οποίου το όνομα ξεκινάει με "George"."
Output: 1253
*/
SELECT COUNT(cid) AS George_found FROM movie_cast
WHERE name LIKE 'George%';

/*
"Βρες ποια ταινία έχει το μεγαλύτερο crew."
Output: 15 Minutes	338
*/
SELECT title, members
FROM(
    SELECT movie.id, movie.title, COUNT(person_id) AS members
    FROM movie 
    LEFT OUTER JOIN movie_crew ON movie.id = movie_crew.movie_id
    GROUP BY movie.id, movie.title
    ) AS max_crew
WHERE members = (
    SELECT MAX(member_count)
    FROM (
        SELECT movie_id, COUNT(person_id) AS member_count
        FROM movie_crew
        GROUP BY movie_id
    ) AS max_crew_count
);

/*
"Βρες ποια συλλογή ταινιών έχει τα περισσότερα είδη ταινιών".
Output: Pokémon Collection	45
*/
SELECT collection_name, genres
FROM (
    SELECT c.name AS collection_name, c.id, COUNT(genre.id) AS genres
    FROM belongsTocollection
    LEFT OUTER JOIN collection AS c ON c.id = belongsTocollection.collection_id
    JOIN movie ON movie.id = belongsTocollection.movie_id
    JOIN hasGenre ON movie.id = hasGenre.movie_id
    JOIN genre ON genre.id = hasGenre.genre_id
    GROUP BY c.name, c.id 
) AS min_genres
WHERE genres = (
    SELECT MAX(genres_count)
    FROM (
        SELECT belongsTocollection.collection_id, COUNT(genre.id) AS genres_count
        FROM belongsTocollection
        JOIN movie ON movie.id = belongsTocollection.movie_id
        JOIN hasGenre ON movie.id = hasGenre.movie_id
        JOIN genre ON genre.id = hasGenre.genre_id
        GROUP BY belongsTocollection.collection_id
    ) AS max_genres_count
);