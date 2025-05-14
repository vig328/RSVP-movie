USE imdb;
select * from director_mapping;
select * from genre;
select * from movie;
select * from  names;
select * from ratings;
select * from role_mapping;
--  Find the data values in each table are.


/* To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movie' and 'genre' tables. */

-- Segment 1:

-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:

select count(movie_id) from director_mapping;
select count(movie_id) from genre;
select count(id) from movie;
select count(id) from names;
select count(movie_id) from ratings;
select count(movie_id) from role_mapping;

-- Q2. Which columns in the 'movie' table have null values?
-- Type your code below:
select * from movie;
select count(worlwide_gross_income) from movie where worlwide_gross_income=0
 UNION ALL
 select count(languages) from movie where languages=0
  UNION ALL
  select count(production_company) from movie where production_company=0;


-- Solution 1
select 
count(*)-count(country) as country_Null_cnt,
count(*)-count(worlwide_gross_income) as worlwide_gross_income_Null_cnt,
count(*)-count(languages) as languages_Null_cnt,
count(*)-count(production_company) as production_company_Null_cnt
from movie;


/* There are 20 nulls in country; 3724 nulls in worlwide_gross_income; 194 nulls in languages; 528 nulls in production_company.
   Notice that we do not need to check for null values in the 'id' column as it is a primary key.

-- As you can see, four columns of the 'movie' table have null values. Let's look at the movies released in each year. 

-- Q3. Find the total number of movies released in each year. How does the trend look month-wise? (Output expected)


/* Output format for the first part:

+---------------+-------------------+
| Year			|	number_of_movies|
+-------------------+----------------
|	2017		|	   2134			|
|	2018		|		.			|
|	2019		|		.			|
+---------------+-------------------+


Output format for the second part of the question:
+---------------+-------------------+
|	month_num	|	number_of_movies|
+---------------+----------------
|	  1			|	    134			|
|	  2			|	    231			|
|	  .			|		 .			|
+---------------+-------------------+ */

-- Type your code below:
select * from movie;
select year,count(title) as no_of_movie from movie group by year;
select month(date_published)  as month_num,count(title) from movie group by month_num order by  month_num ;


/* The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the
'movies' table. 
We know that USA and India produce a huge number of movies each year. Lets find the number of movies produced by USA
or India in the last year. */
  
-- Q4. How many movies were produced in the USA or India in the year 2019?
-- Type your code below:
select * from movie;
select country,year,count(title) as cnt_of_movie from movie where year=2019 and country in ('USA','India') group by country;


/* The query given above is a better solution as it takes into account rows having values with incorrect casing, for
example 'usA' or 'INDIA'. */



/* USA and India produced more than a thousand movies (you know the exact number!) in the year 2019.
Exploring the table 'genre' will be fun, too.
Let’s find out the different genres in the dataset. */

-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:
select * from genre;
select distinct genre from genre;


/* So, RSVP Movies plans to make a movie on one of these genres.
Now, don't you want to know in which genre were the highest number of movies produced?
Combining both the 'movie' and the 'genre' table can give us interesting insights. */

-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:
select * from movie;
select * from genre;

with cte as 
(
select m.title,genre,count(g.genre)as cnt from movie m inner join genre g 
on m.id=g.movie_id 
group by genre
) 
select genre,max(cnt) as cnt_of_genre from cte ;

-- Alternate better solution



/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/

-- Q7. How many movies belong to only one genre?
-- Type your code below:
select * from movie;
select * from genre;

with cte as
(
select m.id, m.title,count(g.genre) AS movies_with_one_genre ,genre from movie m inner join genre g 
on m.id=g.movie_id 
group by m.id
)
 select  count(movies_with_one_genre) as  movies_with_one_genre from cte where  movies_with_one_genre=1;




/* There are more than three thousand movies which have only one genre associated with them.
This is a significant number.
Now, let's find out the ideal duration for RSVP Movies’ next project.*/

-- Q8.What is the average duration of movies in each genre? 
-- (Note: The same movie can belong to multiple genres.)


/* Output format:

+---------------+-------------------+
| genre			|	avg_duration	|
+-------------------+----------------
|	Thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
select * from movie;
select * from genre;

select g.genre as genre,round(avg(m.duration),2) as avg_duration from movie m inner join genre g 
on m.id=g.movie_id 
group by genre;


/* Note that using an outer join is important as we are dealing with a large number of null values. Using
   an inner join will slow down query processing. */


/* Now you know that movies of genre 'Drama' (produced highest in number in 2019) have an average duration of
106.77 mins.
Let's find where the movies of genre 'thriller' lie on the basis of number of movies.*/

-- Q9.What is the rank of the ‘thriller’ genre of movies among all the genres in terms of number of movies produced? 
-- (Hint: Use the rank function)


/* Output format:
+---------------+-------------------+---------------------+
|   genre		|	 movie_count	|		genre_rank    |	
+---------------+-------------------+---------------------+
|   drama		|	   2312			|			2		  |
+---------------+-------------------+---------------------+*/

-- Type your code below:
select * from movie;
select * from genre;

with genre_counts as 
( 
select count(m.title) as movie_counts,
g.genre as genre from movie m inner join genre g on m.id=g.movie_id
group by genre
), genres_name as
( 
select  genre,movie_counts,
 rank() over(order by movie_counts desc) as rnk
from genre_counts
) select genre,movie_counts, rnk from genres_name where genre='Thriller';




-- Thriller movies are in the top 3 among all genres in terms of the number of movies.


-- --------------------------------------------------------------------------------------------------------------
/* In the previous segment, you analysed the 'movie' and the 'genre' tables. 
   In this segment, you will analyse the 'ratings' table as well.
   To start with, let's get the minimum and maximum values of different columns in the table */

-- Segment 2:

-- Q10.  Find the minimum and maximum values for each column of the 'ratings' table except the movie_id column.

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
| min_avg_rating|	max_avg_rating	|	min_total_votes   |	max_total_votes 	 |min_median_rating|max_median_rating|
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
|		0		|			5		|	       177		  |	   2000	    		 |		0	       |	8			 |
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+*/

-- Type your code below:
select * from ratings;
select min(avg_rating) as min_avg_rating,max(avg_rating) as max_avg_rating,
min(total_votes) as min_total_votes ,max(total_votes) as max_total_vot,
min(median_rating) as min_median_rating,max(median_rating) as max_median_rating
from ratings;


/* So, the minimum and maximum values in each column of the ratings table are in the expected range. 
This implies there are no outliers in the table. 
Now, let’s find out the top 10 movies based on average rating. */

-- Q11. What are the top 10 movies based on average rating?

/* Output format:
+---------------+-------------------+---------------------+
|     title		|		avg_rating	|		movie_rank    |
+---------------+-------------------+---------------------+
|     Fan		|		9.6			|			5	  	  |
|	  .			|		 .			|			.		  |
|	  .			|		 .			|			.		  |
|	  .			|		 .			|			.		  |
+---------------+-------------------+---------------------+*/

-- Type your code below:
select * from ratings;
select * from movie;
select m.title as title,round(avg(avg_rating),1) as avg_rating,dense_rank() over(order by avg_rating desc) as movie_rank  
from movie m inner join ratings r on m.id=r.movie_id group by title order by  movie_rank  limit 10 ;

-- It's okay to use RANK() or DENSE_RANK() as well.

/* Do you find the movie 'Fan' in the top 10 movies with an average rating of 9.6? If not, please check your code
again.
So, now that you know the top 10 movies, do you think character actors and filler actors can be from these movies?
Summarising the ratings table based on the movie counts by median rating can give an excellent insight. */

-- Q12. Summarise the ratings table based on the movie counts by median ratings.

/* Output format:
+---------------+-------------------+
| median_rating	|	movie_count		|
+-------------------+----------------
|	1			|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */

-- Type your code below:
select * from ratings;
select * from movie;
select r.median_rating,count(m.id) as movie_count from ratings r inner join movie m on r.movie_id=m.id 
group by median_rating 
order by median_rating  asc ;

-- It is a good practice to use the 'ORDER BY' clause.

/* Movies with a median rating of 7 are the highest in number. 
Now, let's find out the production house with which RSVP Movies should look to partner with for its next project.*/

-- Q13. Which production house has produced the most number of hit movies (average rating > 8)?

/* Output format:
+------------------+-------------------+----------------------+
|production_company|    movie_count	   |    prod_company_rank |
+------------------+-------------------+----------------------+
| The Archers	   |		1		   |			1	  	  |
+------------------+-------------------+----------------------+*/

-- Type your code below:
select * from movie;
select * from ratings;
with cte as
(
select m.production_company,count(m.id) as movie_count ,r.avg_rating from movie m inner join ratings r 
on m.id=r.movie_id 
group by m.id
)
 select production_company,movie_count,dense_rank() over(order by avg_rating  ) as   
prod_company_rank  from cte 
where avg_rating>8;


-- It's okay to use RANK() or DENSE_RANK() as well.
-- The answer can be either Dream Warrior Pictures or National Theatre Live or both.

-- Q14. How many movies released in each genre in March 2017 in the USA had more than 1,000 votes?

/* Output format:

+---------------+-------------------+
| genre			|	movie_count		|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */

-- Type your code below:
select * from ratings;
select * from genre;
select * from movie; 
with cte as
(
select m.id ,m.year,month(m.date_published) as month,m.country,
g.genre,r.total_votes from  movie m inner join genre g 
on m.id=g.movie_id
inner join ratings r 
using(movie_id) 
) 
select genre, count(id) as count  from cte 
where month='3' and year='2017' and total_votes>1000 and country ='USA'
 group by genre order by count desc;


-- Lets try analysing the 'imdb' database using a unique problem statement.

-- Q15. Find the movies in each genre that start with the characters ‘The’ and have an average rating > 8.

/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		genre	      |
+---------------+-------------------+---------------------+
| Theeran		|		8.3			|		Thriller	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/

-- Type your code below:
select * from movie;
select * from genre;
select * from ratings;
with cte as
(
 select m.title,r.avg_rating,g.genre from movie m inner join genre g
 on m.id=g.movie_id
 inner join ratings r
 using (movie_id)
 ) 
 select * from cte where title like "THE%" and avg_rating>8;



-- You should also try out the same for median rating and check whether the ‘median rating’ column gives any
-- significant insights.

-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?

-- Type your code below:
select * from movie;
select * from  ratings;
with cte as 
(
select  m.id,m.year,m.date_published,r.median_rating from movie m inner join ratings r
on m.id=r.movie_id
) 
select count(id) as count from cte 
where date_published between "2018-04-01" and "2019-04-01" 
and median_rating>8 ;




-- Now, let's see the popularity of movies in different languages.

-- Q17. Do Italian movies get more votes than  German  movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:
select * from movie;
select * from ratings;

select m.languages,sum(r.total_votes) as votes from movie m join ratings r on m.id=r.movie_id where languages ='German'
union all
select m.languages,sum(r.total_votes) as votes from movie m join ratings r on m.id=r.movie_id where languages ='Italian';

-- Answer is Yes






-- ----------------------------------------------------------------------------------------------------------------

/* Now that you have analysed the 'movie', 'genre' and 'ratings' tables, let us analyse another table - the 'names'
table. 
Let’s begin by searching for null values in the table. */

-- Segment 3:

-- Q18. Find the number of null values in each column of the 'names' table, except for the 'id' column.

/* Hint: You can find the number of null values for individual columns or follow below output format

+---------------+-------------------+---------------------+----------------------+
| name_nulls	|	height_nulls	|date_of_birth_nulls  |known_for_movies_nulls|
+---------------+-------------------+---------------------+----------------------+
|		0		|			123		|	       1234		  |	   12345	    	 |
+---------------+-------------------+---------------------+----------------------+*/

-- Type your code below:
select * from names;
SELECT 
  COUNT(*) - COUNT(name) AS name_nulls,
  COUNT(*) - COUNT(height) AS height_nulls,
  COUNT(*) - COUNT(date_of_birth) AS date_of_birth_nulls ,
 count(*)-   count(known_for_movies) as known_for_movies_nulls
FROM names;
-- Solution 1

-- Solution 2

    
/* Answer: 0 nulls in name; 17335 nulls in height; 13413 nulls in date_of_birth; 15226 nulls in known_for_movies.
   There are no null values in the 'name' column. */ 


/* The director is the most important person in a movie crew. 
   Let’s find out the top three directors each in the top three genres who can be hired by RSVP Movies. */

-- Q19. Who are the top three directors in each of the top three genres whose movies have an average rating > 8?
-- (Hint: The top three genres would have the most number of movies with an average rating > 8.)

/* Output format:
+---------------+-------------------+
| director_name	|	movie_count		|
+---------------+-------------------|
|James Mangold	|		4			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */

-- Type your code below:
select * from director_mapping; 
select * from genre; -- 
select * from ratings; --
select * from names;
select * from movie;
select * from role_mapping;

with cte as
(
select d.name_id,n.name,r.avg_rating,g.genre from ratings r  join genre g
using (movie_id) join director_mapping d using(movie_id)
join names n on d.name_id=n.id
)
 select count(name_id),name from cte 
 where avg_rating>8 
 group by name 
 order by count(name_id) desc limit 3;


/* Joe Russo or Anthony Russo can be hired as the director for RSVP's next project. You may recall some of his movies like
 'Avengers: Infinity War' and 'Avengers: Endgame'
Now, let’s find out the top two actors.*/

-- Q20. Who are the top two actors whose movies have a median rating >= 8?

/* Output format:
+---------------+-------------------+
| actor_name	|	movie_count		|
+-------------------+----------------
|Christian Bale	|		10			|
|	.			|		.			|
+---------------+-------------------+ */

-- Type your code below:
select * from director_mapping; 
select * from genre; -- 
select * from ratings; --
select * from names;
select * from movie;
select * from role_mapping;

with cte as
(
select  ro.name_id,ro.category,n.name,r.median_rating,g.genre from ratings r  join genre g
using (movie_id) join   role_mapping ro using(movie_id)
join names n on ro.name_id=n.id
) 
select name,count(name_id) as movie_count from cte 
where median_rating>=8
group by name 
order by movie_count desc limit 2;


/* Did you find the actor 'Mohanlal' in the list? If no, please check your code again. 
RSVP Movies plans to partner with other global production houses. 
Let’s find out the top three production houses in the world.*/

-- Q21. Which are the top three production houses based on the number of votes received by their movies?

/* Output format:
+-------------------+-------------------+---------------------+
|production_company |   vote_count		|	prod_comp_rank    |
+-------------------+-------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|		.		      |
|	.				|		.			|		.		  	  |
+-------------------+-------------------+---------------------+*/

-- Type your code below:
select * from movie;
select * from ratings;
select m.production_company,r.total_votes,dense_rank() over() from movie m join ratings r 
on m.id=r.movie_id
order by total_votes desc limit 3;


/* Yes, Marvel Studios rules the movie world.
So, these are the top three production houses based on the number of votes received for the movies they have produced.

Since RSVP Movies is based out of Mumbai, India also wants to woo its local audience. 
RSVP Movies is looking to hire a few Indian actors for its upcoming project to give a regional feel. 
Let’s find who these actors could be. */

-- Q22. Rank actors with movies released in India based on their average ratings. Which actor is at the top of the
-- list?
-- Note: The actor should have acted in at least five Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes
-- should act as the tie breaker.)

/* Output format:
+---------------+---------------+---------------------+----------------------+-----------------+
| actor_name	|	total_votes	|	movie_count		  |	actor_avg_rating 	 |actor_rank	   |
+---------------+---------------+---------------------+----------------------+-----------------+
|	Yogi Babu	|		3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|		.		|	       .		  |	   .	    		 |		.	       |
|		.		|		.		|	       .		  |	   .	    		 |		.	       |
+---------------+---------------+---------------------+----------------------+-----------------+*/

-- Type your code below:
select * from movie;
select * from ratings;
select * from names;
select * from role_mapping;
with cte as 
(
select m.id,m.country,r.avg_rating,r.total_votes,n.name,ro.name_id,ro.category
from movie m join ratings r
on m.id=r.movie_id
join role_mapping ro using(movie_id)
join names n
on ro.name_id=n.id
) 
 select name as actor_name,sum(total_votes) as total_votes	, count(id) as movie_cnt,avg_rating as 	actor_avg_rating ,
dense_rank() over() as actor_rank from cte where country='India'  and category='actor' group by name
 order by total_votes desc limit 3;



-- Q23.Find the top five actresses in Hindi movies released in India based on their average ratings.
-- Note: The actresses should have acted in at least three Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes
-- should act as the tie breaker.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |	actress_avg_rating 	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Tabu		|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/

-- Type your code below:
select * from movie;
select * from ratings;
select * from names;
select * from role_mapping;
with cte as
(
select m.id,m.country,r.avg_rating,r.total_votes,n.name,ro.name_id,ro.category
from movie m join ratings r
on m.id=r.movie_id
join role_mapping ro using(movie_id)
join names n
on ro.name_id=n.id
) , cte2 as
(
select name as actor_name,sum(total_votes) as total_votes	, count(id) as movie_cnt,avg_rating as 	actor_avg_rating ,
dense_rank() over() as actor_rank from cte where country='India'  and category= 'actress'group by name
 order by total_votes desc 
 ) select * from cte2 where movie_cnt >=3
 order by total_votes desc limit 5;
 
-- Kajal Aggarwal tops the charts with an average rating of 7.7.


-- Now let us divide all the thriller movies in the following categories and find out their numbers.
/* Q24. Consider thriller movies having at least 25,000 votes. Classify them according to their average ratings in
   the following categories: 

			Rating > 8: Superhit
			Rating between 7 and 8: Hit
			Rating between 5 and 7: One-time-watch
			Rating < 5: Flop
--------------------------------------------------------------------------------------------*/

-- Type your code below:
select * from genre ;
select * from ratings;
with cte as 
(
select g.genre ,r.avg_rating from genre g join ratings r using(movie_id) where genre ='Thriller'
) 
select *, case when avg_rating>8 then 'superhit'
            when avg_rating between 5 and 7 then 'one time watch'
            else 'flop' end as ratings from cte
            order by avg_rating desc;

            


-- -----------------------------------------------------------------------------------------------------------

/* Until now, you have analysed various tables of the data set. 
Now, you will perform some tasks that will give you a broader understanding of the data in this segment. */

-- Segment 4:

-- Q25. What is the genre-wise running total and moving average of the average movie duration? 
-- (Note: You need to get the output according to the output format given below.)

/* Output format:
+---------------+-------------------+----------------------+----------------------+
| genre			|	avg_duration	|running_total_duration|moving_avg_duration   |
+---------------+-------------------+----------------------+----------------------+
|	comedy		|			145		|	       106.2	   |	   128.42	      |
|		.		|			.		|	       .		   |	   .	    	  |
|		.		|			.		|	       .		   |	   .	    	  |
|		.		|			.		|	       .		   |	   .	    	  |
+---------------+-------------------+----------------------+----------------------+*/

-- Type your code below:
select * from movie;
select * from genre ;
select * from ratings;
select g.genre,round(avg(m.duration),2) as avg_duration,
sum(duration) over(order by duration range between unbounded preceding and current row) as running_total_duration ,
sum(duration) over(order by duration range between current row and 1 following ) as moving_avg_duration 
from movie m join genre g on m.id=g.movie_id join ratings r using(movie_id) group by genre;


-- Rounding off is good to have and not a must have, the same thing applies to sorting.


-- Let us find the top 5 movies for each year with the top 3 genres.

-- Q26. Which are the five highest-grossing movies in each year for each of the top three genres?
-- (Note: The top 3 genres would have the most number of movies.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| genre			|	year			|	movie_name		  |worldwide_gross_income|movie_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	comedy		|			2017	|	       indian	  |	   $103244842	     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/

-- Type your code below:
select * from movie;
select * from genre ;
select * from ratings;

-- Get the Top 3 Genres by Number of Movies
with cte1 as 
(
select count(m.id) as cnt ,g.genre from movie m join genre g on m.id=g.movie_id
group by id order by cnt desc limit 3
),cte2 as
( 
select  m.title,
        m.year,
        m.worlwide_gross_income,
        m.id,
        g.genre,
         RANK() OVER (PARTITION BY m.id, m.year ORDER BY m.worlwide_gross_income DESC) AS genre_rank
      from movie m join genre g on m.id=g.movie_id
      where g.genre in(select * from cte1)
) 
SELECT title, year, genre,worlwide_gross_income
FROM cte2
WHERE genre_rank <= 3
ORDER BY genre, year, worlwide_gross_income DESC;


-- Top 3 Genres based on most number of movies

/* Finally, let’s find out the names of the top two production houses that have produced the highest number of hits
   among multilingual movies.
   
Q27. What are the top two production houses that have produced the highest number of hits (median rating >= 8) among
multilingual movies? */

/* Output format:
+-------------------+-------------------+---------------------+
|production_company |movie_count		|		prod_comp_rank|
+-------------------+-------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/

-- Type your code below:
select * from movie;

select * from ratings;
with cte as
(
select m.production_company,m.id ,r.median_rating,count(id) as movie_count
from movie m join ratings r on m.id=r.movie_id group by production_company
)
 select production_company,movie_count,dense_rank() over( order by median_rating desc) as prod_comp_rank
from cte where median_rating>=8 
order by prod_comp_rank  limit 2;

-- Multilingual is the important piece in the above question. It was created using POSITION(',' IN languages)>0.
-- If there is a comma, that means the movie is of more than one language.


-- Q28. Who are the top 3 actresses based on the number of Super Hit movies (average rating > 8) in 'drama' genre?

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |actress_avg_rating	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Laura Dern	|			1016	|	       1		  |	   9.60			     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/

-- Type your code below:
select * from movie;
select * from ratings;
select * from names;
select * from role_mapping;
with cte as
(
select n.name,sum(r.total_votes) as Total_votes,count(movie_id) as movie_count,r.avg_rating as actress_avg_rating,ro.category
from ratings r join role_mapping ro using(movie_id)
join  names n on n.id=ro.name_id group by name
) 
select name as actress_name,Total_votes,movie_count,actress_avg_rating,
dense_rank() OVER(order by total_votes) AS actress_rank  from cte 
where actress_avg_rating>8 and category='actress'
order by total_votes limit 3;


/* Q29. Get the following details for top 9 directors (based on number of movies):

Director id
Name
Number of movies
Average inter movie duration in days
Average movie ratings
Total votes
Min rating
Max rating
Total movie duration

Format:
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
| director_id	|	director_name	|	number_of_movies  |	avg_inter_movie_days |	avg_rating	| total_votes  | min_rating	| max_rating | total_duration |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
|nm1777967		|	A.L. Vijay		|			5		  |	       177			 |	   5.65	    |	1754	   |	3.7		|	6.9		 |		613		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+

--------------------------------------------------------------------------------------------*/

-- Type your code below:
select * from director_mapping; --
select * from genre;
select * from movie; --
select * from  names; --
select * from ratings; --
select * from role_mapping;
select d.name_id as director_id,n.name as director_name,count(n.id) as number_of_movie,
round(avg(m.duration),2) as avg_inter_movie_days,r.avg_rating,r.total_votes,min(r.avg_rating) as min_rating,
max(avg_rating) as max_rating,sum(m.duration) as total_duration 
from movie m join ratings r on 
m.id=r.movie_id join director_mapping d 
using(movie_id) join names n
on d.name_id=n.id  
group by  director_name;


