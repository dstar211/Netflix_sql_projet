CREATE TABLE Netflix(
show_id VARCHAR(6),
type  VARCHAR(10),
title VARCHAR(150),
director VARCHAR(208),
casts  VARCHAR(1000),
country VARCHAR(150),
date_added VARCHAR(50),
release_year INT ,
rating VARCHAR(10) ,
duration VARCHAR(20),
listed_in VARCHAR(100),
description VARCHAR(250)

);
SELECT * FROM Netflix; 
drop table netflix

---  BUSINESS PROBLEMS

-----1 Count the number of the tv shows and movies

SELECT  type, COUNT(*) AS TOTAL_content 
FROM netflix
Group by type;

---- 2 find out the most common rating in movie and tv show  
SELECT  
type,
rating 
FROM
(
SELECT type, rating,
COUNT(*), rank() over (PARTITION BY type order by count(*) desc) AS RANKING
FROM netflix
GROUP BY 1,2 
) AS t1
where Ranking =1



---3 list of movies released in specifices year (e9. 2020)


 SELECT * FROM Netflix
 WHERE type = 'Movie' AND release_year = 2020  



---- 4.  The top  5 countries with the most netflix content 

SELECT  unnest (string_TO_array(country,',')) AS new_country ,
        COUNT(show_id) as total_content 
	    FROM netflix 
        GROUP BY 1
		order by 2  desc
		limit 5
		

------ 5 identify longest movie

 SELECT type, title ,duration FROM netflix
 WHERE type = 'Movie'
       AND 
	   duration =( SELECT MAX(duration) FROM netflix) 

--- 6 Find the movie / tv show by director 'Rajiv chilaka'?

SELECT * 
FROM netflix
WHERE director ILIKE '%Rajiv chilaka%'; --- CASE INSENSITIVE 

---7 List all the tv show more then 5 season 

SELECT 
* FROM Netflix 
WHERE type ='TV Show'
      AND 
	     split_part(duration,' ',1):: INTEGER  >=5

------8. Count number of  contant iteam with in  each genre 

	SELECT UNNEST (STRING_TO_ARRAY(listed_in ,',')) AS GENER,
	      COUNT(Show_id) AS total_contant
	FROM netflix
	GROUP BY GENER
	ORDER BY total_contant DESC;


	
/* 9. Find each year and the average number of content relased in india on netflix return
      Top 5 with highest avg contents relased */

SELECT 
      EXTRACT(year FROM TO_DATE(date_added,'Month DD,YYYY')) AS years,
	  COUNT(*) AS Yearly_content,
	  ROUND(
	  COUNT(*)::numeric /(SELECT count(*) FROM Netflix WHERE country='India'):: numeric * 100
	  ,2)AS avg_content_per_year
	  FROM Netflix
	  WHERE country='India'
	  GROUP BY 1
	  ORDER BY Yearly_content desc LIMIT 5 


/* 10  list all movies is documentry */

 SELECT *
 FROM netflix 
 WHERE   listed_in LIKE '%Documentaries%';


---- 11 find the show that director is null
SELECT *
FROM Netflix 
WHERE director is null;
	 

SELECT * FROM Netflix 
WHERE 
    Casts ILIKE '%Salman khan%' 
	AND 
	release_year > EXTRACT (YEAR FROM CURRENT_DATE) - 10


/*  12  Find the top 10 actors who have appeared in the highest number of movie produted 
    in the india */

SELECT
UNNEST(STRING_TO_ARRAY (casts,',')),
COUNT(*) AS TOTAL_CONTENT 
FROM Netflix
WHERE country ILIKE '%India%'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10



WITH NEW_TABLE
AS (
SELECT *, 
CASE 
WHEN   description LIKE '%kill%' OR
       description LIKE '%Violene%'  THEN 'BAD_MOVIE'
	   ELSE 'GOOD_MOVE'
	   END CATEGORY 
FROM NETFLIX 
)
 SELECT CATEGORY ,
       COUNT(*) AS TOTAL_CONTENT
	   FROM NEW_TABLE
	   GROUP BY CATEGORY;





/
SELECT  category, count(*) AS_TOTAL
FROM (
SELECT *, 
CASE 
WHEN   description LIKE '%kill%' OR
       description LIKE '%Violene%'  THEN 'BAD_MOVIE'
	   ELSE 'GOOD_MOVIE'
	   END CATEGORY 
FROM NETFLIX
) AS SUB
GROUP BY 1; 
