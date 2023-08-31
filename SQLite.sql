CREATE Table appleStore_description_combined AS

Select * FROM appleStore_description1

Union ALl

Select * FROM appleStore_description2

Union ALl

Select * FROM appleStore_description3

Union ALl

Select * FROM appleStore_description4

**EXPLORATORY DATA ANALYSIS**

--check the number of unique apps in both tablesAppleStore

Select count(DISTINCT id) as UniqueAppIDs
from AppleStore

select COUNT(DISTINCT id) As UniqueAppIDs
from appleStore_description_combined

-- Check for any missing values in key fields

select count(*) As MissingValues
from AppleStore
where track_name is null or user_rating is null or prime_genre is null

select count(*) As MissingValues
from appleStore_description_combined
where app_desc is null 

--find out the number of apps per genreAppleStore
SELECT prime_genre, count(*) as NumApps
from AppleStore
group by prime_genre
order by NumApps DESC

--Get an overview of the apps' ratingsAppleStore

select min(user_rating) as MinRating,
	   max(user_rating) as MaxRating,
       avg(user_rating) as AvgRating
from AppleStore 

** Data Analysis**

--Determine whether paid apps have higher ratings than free apps

Select Case 
			When price > 0 then 'Paid'
            else 'Free'
            End as App_Type,
            avg(user_rating) as Avg_rating
from AppleStore
group by App_Type

--Check if apps with more supported languages have higher ratings 

SELECT case 
			When lang_num < 10 then '<10 languages'
            when lang_num BETWEEN 10 and 30 then '10-30 languages'
            else '>30 languages' 
       end as language_bucket, 
       avg(user_rating) as Avg_Rating
From AppleStore
group by language_bucket
order by Avg_Rating desc 

-- check genre with low ratings 

SELECT prime_genre,
		avg(user_rating) as Avg_Rating
FROM AppleStore
group by prime_genre
order by Avg_Rating Asc 
Limit 5

-- check genres with high ratingsAppleStore

SELECT prime_genre,
		avg(user_rating) as Avg_Rating
FROM AppleStore
group by prime_genre
order by Avg_Rating DESC 
Limit 5

--check if there is a correlation between the length of the app description ad the user rating 

SELECT case 
			when length(b.app_desc) < 500 then 'Short'
            when length(b.app_desc) BETWEEN 500 and 1000 then 'Medium'
            else 'Long'
    end as description_length_bucket,
    avg(user_rating) AS average_rating

FROM 
	AppleStore as a
Join 
	appleStore_description_combined as b 

on 
	a.id = b.id
GROUP by description_length_bucket 
order by average_rating DESC 

--check the top rated apps for each genre 
SELECT
	prime_genre,
    track_name,
    user_rating
From ( 
  		SELECT
  		prime_genre,
  		track_name,
  		user_rating,
 	    RANK() OVER(Partition by prime_genre order by user_rating DESC, rating_count_tot DESC) as rank
  		From 
  		AppleStore
  	  ) as a 
 WHERE
 a.rank = 1
 


