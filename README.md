Project Overview

The RSVP Movie SQL project uses the IMDb movie dataset to help RSVP Movies decide:

# Which genres, directors, actors, and production companies they should work with.

# What kind of movies (duration, ratings, language, votes) they should target.

# Trends over years, months, and regions for movie releases.

The database has the following main tables:

# movie – Movie details like title, year, duration, languages, production company, release date.

# genre – Movie genres (one movie can have multiple genres).

# ratings – IMDb ratings (average, median, total votes).

# names – People involved in movies (actors, directors, etc.).

# director_mapping – Which director worked on which movie.

# role_mapping – Which actor/actress worked in which movie.

Main Analysis Steps

1. Data Understanding & Null Check
# Count the number of rows in each table.

# Identify columns in the movie table with null values (found missing values in country, worldwide gross income, languages, production company).

2. Movie Release Trends
# Year-wise & Month-wise movie count – Found which years/months have the highest movie releases (March has the highest releases).

# Movies produced in USA or India in 2019 – These two countries produced the most movies.

3. Genre Analysis
# Found unique genres and identified the most common genre (Drama).

# Counted how many movies belong to only one genre (~3000+ movies).

# Calculated average duration per genre (important for deciding movie length).

# Found rank of Thriller genre by number of movies (Top 3).

4. Ratings Analysis
# Checked min/max ratings to ensure data quality.

# Top 10 movies by average rating (Fan scored 9.6).

# Summarized movie counts by median rating (most movies have a median rating of 7).

# Found top production houses for hit movies (avg rating > 8).

# Filtered movies in March 2017 (USA, >1000 votes).

# Movies starting with "The" and rating > 8.

5. Language & Country Analysis 
# Compared Italian vs German movies in terms of votes.

# Found null values in names table (missing height, DOB, known_for_movies).

6. People Analysis
# Top 3 directors in top genres with avg rating > 8 (e.g., Russo Brothers).

# Top 2 actors with median rating ≥ 8 (Mohanlal included).

# Top 3 production houses globally by votes.

# Ranked Indian actors (≥5 movies) by weighted average ratings.

# Top 5 Hindi actresses (≥3 movies) ranked.

# Categorized Thriller movies into Superhit / Hit / One-time-watch / Flop.

7. Advanced Analytics
# Genre-wise running total & moving average of movie duration.

# Top 5 highest-grossing movies per year in top 3 genres.

# Top 2 production houses making multilingual hits (median rating ≥ 8).

# Top 3 actresses in drama genre with avg rating > 8.

# Top 9 directors with stats: number of movies, avg days between movies, avg rating, total votes, min/max rating, total duration.

Key Insights from the Project

# Genre Focus – Drama has the most production; Thriller is also highly popular.

# Star Power – Actors like Mohanlal and actresses like Kajal Aggarwal have strong ratings.

# Timing – March is peak movie release month.

# Geographic Strategy – USA & India dominate production volume.

# Language – Italian movies receive more votes than German movies.

# Business Partners – Marvel Studios and other top production houses dominate votes and hits.

# Movie Duration – Average around 105–110 minutes works best.

# Multilingual Strategy – Certain production companies excel in multilingual hits.
