-- !preview conn=DBI::dbConnect(RSQLite::SQLite())

-- movies_ratings.sql
-- Normalized schema for movie ratings
PRAGMA foreign_keys = ON;

DROP TABLE IF EXISTS rating;
DROP TABLE IF EXISTS person;
DROP TABLE IF EXISTS movie;

CREATE TABLE person (
  person_id INTEGER PRIMARY KEY,
  name TEXT NOT NULL UNIQUE
);

CREATE TABLE movie (
  movie_id INTEGER PRIMARY KEY,
  title TEXT NOT NULL,
  release_year INTEGER CHECK (release_year >= 1888)
);

CREATE TABLE rating (
  person_id INTEGER NOT NULL,
  movie_id INTEGER NOT NULL,
  rating INTEGER NOT NULL CHECK (rating BETWEEN 1 AND 5),
  rated_at TEXT DEFAULT (DATE('now')),
  PRIMARY KEY (person_id, movie_id),
  FOREIGN KEY (person_id) REFERENCES person(person_id) ON DELETE CASCADE,
  FOREIGN KEY (movie_id) REFERENCES movie(movie_id) ON DELETE CASCADE
);

-- People (at least five)
INSERT INTO person (person_id, name) VALUES
  (1, 'Haider'),
  (2, 'Sarim'),
  (3, 'Binte'),
  (4, 'Noori'),
  (5, 'Zara');

-- Six recent, popular movies (2023–2024)
INSERT INTO movie (movie_id, title, release_year) VALUES
  (1, 'Oppenheimer', 2023),
  (2, 'Barbie', 2023),
  (3, 'Dune: Part Two', 2024),
  (4, 'Inside Out 2', 2024),
  (5, 'Spider-Man: Across the Spider-Verse', 2023),
  (6, 'Godzilla Minus One', 2023);

-- Ratings: omit some rows to represent "has not seen" (missing data)
-- Haider rated all
INSERT INTO rating (person_id, movie_id, rating) VALUES
  (1,1,5), (1,2,3), (1,3,5), (1,4,4), (1,5,5), (1,6,4);

-- Sarim: missing Spider-Verse
INSERT INTO rating (person_id, movie_id, rating) VALUES
  (2,1,4), (2,2,5), (2,3,4), (2,4,5), (2,6,3);

-- Binte: missing Barbie and Godzilla
INSERT INTO rating (person_id, movie_id, rating) VALUES
  (3,1,5), (3,3,4), (3,4,3), (3,5,4);

-- Noori: missing Dune: Part Two
INSERT INTO rating (person_id, movie_id, rating) VALUES
  (4,1,3), (4,2,4), (4,4,5), (4,5,4), (4,6,4);

-- Zara: missing Inside Out 2
INSERT INTO rating (person_id, movie_id, rating) VALUES
  (5,1,4), (5,2,2), (5,3,5), (5,5,5), (5,6,5);

-- Sample analytics in pure SQL (optional)
-- Average rating per movie with number of raters
-- SELECT m.title, AVG(r.rating) AS avg_rating, COUNT(*) AS n_raters
-- FROM rating r JOIN movie m ON m.movie_id = r.movie_id
-- GROUP BY m.movie_id, m.title
-- ORDER BY avg_rating DESC, n_raters DESC;

