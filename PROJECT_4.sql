-- Netflix Project
DROP TABLE IF EXISTS netflix;
CREATE TABLE  netflix
(
	show_id VARCHAR(10),
	type VARCHAR(10),
	title VARCHAR(150),
	director VARCHAR(210),
	casts VARCHAR(1000),
	country VARCHAR(150),
	date_added VARCHAR(150),
	release_year INT,
	rating VARCHAR(10),
	duration VARCHAR(15),
	listed_in VARCHAR(79),
	description VARCHAR(300)
);



select * from netflix

select 
	DISTINCT TYPE 
from netflix

-- 15 Business Problems & Solutions

-- 1. Count the number of Movies vs TV Shows
select type,
		count(*) as total_content
from netflix
group by type

-- 2. Find the most common rating for movies and TV shows


select * from (
select type,
		rating,
		COUNT(*) AS rating_count,
		ROW_NUMBER() OVER(PARTITION BY type ORDER BY COUNT(*) DESC) as ranks
from netflix
GROUP BY type, rating) as ranked
where ranks = 1




-- 3. List all movies released in a specific year (e.g., 2020)
select *
from netflix
where type = 'Movie' and release_year = 2020


-- 4. Find the top 5 countries with the most content on Netflix
select 
		UNNEST(STRING_TO_ARRAY(country,',')) as new_country,
		COUNT(show_id) as total_content
from netflix
group by 1
order by 2 DESC
LIMIT 5 

-- select 
-- 	UNNEST(STRING_TO_ARRAY(country,',')) as new_country
-- from netflix


-- 5. Identify the longest movie
select *
from netflix
where type = 'Movie'
		AND duration = (select max(duration) from netflix)




-- 6. Find content added in the last 5 years
 
select * 
from netflix
where 
	to_date(date_added, 'Month DD, YYYY') >= current_date - interval '5 years'

	
-- 7. Find all the movies/TV shows by director 'Rajiv Chilaka'!
select * from netflix
where director LIKE '%Rajiv Chilaka%'


-- 8. List all TV shows with more than 5 seasons
select * from netflix
where type = 'TV Show'	
		and SPLIT_PART(duration,' ', 1)::numeric > 5


-- 9. Count the number of content items in each genre
select
	UNNEST(STRING_TO_ARRAY(listed_in,',')) as genre,
	count(*) as total_content
from netflix
group by new_list




-- 10.Find each year and the average numbers of content release in India on netflix. 
-- return top 5 year with highest avg content release!
select * from netflix

select 	
	EXTRACT(YEAR FROM TO_DATE(date_added, 'Month DD, YYYY')) as year,
	COUNT(*) as yearly_content,
	ROUND(COUNT(*)::numeric / (SELECT COUNT(*) FROM netflix WHERE country='India') * 100,2) as avg_content_per_year
from netflix
where country = 'India'
group by 1


-- 11. List all movies that are documentaries
select *
from netflix
where 
 	listed_in ILIKE '%documentaries%'


-- 12. Find all content without a director
select * from netflix
where director IS NULL


-- 13. Find how many movies actor 'Salman Khan' appeared in last 10 years!
select * from netflix
where
	casts ILIKE '%Salman Khan%'
	AND 
	release_year >= extract(year from current_date) - 10

-- 14. Find the top 10 actors who have appeared in the highest number of movies 
-- produced in India.
select 
		UNNEST(STRING_TO_ARRAY(casts,',')) as new,
		count(*) as total
from netflix
where country ILIKE '%india%'
group by 1
order by total DESC
LIMIT 10

-- 15.
-- Categorize the content based on the presence of the keywords 'kill' and 'violence' in 
-- the description field. Label content containing these keywords as 'Bad' and all other 
-- content as 'Good'. Count how many items fall into each category.
with new_table as (
select *,
	CASE
		WHEN description ILIKE '%kill%' OR description ILIKE '%violence%' THEN 'Bad' 
		ELSE 'Good' 
	END category
from netflix) 

select category,
		count(*)
from new_table
group by 1




with ex1 as (
select *,
	case
		when description ILIKE '%kill%' OR description ILIKE '%violence%' then 'bad'
		else 'good'
	end category
from netflix)

select category,
		count(*) as total
from ex1
group by category






