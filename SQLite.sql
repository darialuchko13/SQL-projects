Create Table applestore_description_combined AS

Select * from appleStore_description1
Union ALL
Select * from appleStore_description2
UNION all 
Select * from appleStore_description3
Union all 
Select * from appleStore_description4


-- Exloratory analysis--

-- check the number of unique apps in both tables AppleStore--

Select count (distinct id) as UniqueApsIDs
From AppleStore
Select count (distinct id) as UniqueApsIDs
From applestore_description_combined
Select Count (*)as MissingValues
From AppleStore
Where track_name is null or user_rating is null or prime_genre is null


Select Count (*)as MissingValues
From applestore_description_combined
Where app_desc is NULL


-- Find the number of apps per genreAppleStore--

Select prime_genre, Count(*) as NumApps
From AppleStore
GROUP by prime_genre
ORDER by NumApps DESC

-- Get an overview of the apps ratings

Select min(user_rating) as minrating,
	   max(user_rating) as maxrating,
       avg(user_rating) as avgrating
From AppleStore


--Determijne whether paid apps have higher ratings than free apps

Select CASE
		when price >0 Then 'paid'
        Else 'Free'
        End As AppType,
        avg(user_rating) as AvgRating
From AppleStore
Group By AppType


--Check if apps with more supported languages have higher ratings

Select CASE
			when lang_num <10 then '<10'
            When lang_num between 10 and 30 then '10-30 languages'
            Else '>30 languages'
            End As language_bucket,
            avg(user_rating) as AvgRating
From AppleStore
Group By language_bucket
Order by AvgRating DESC


-- Check genres with low ratings

Select prime_genre,
	   avg(user_rating) as AvgRating
From AppleStore
GROUP by prime_genre
ORDER by AvgRating
LIMIT 10


-- Check if there is a correlation between the lenght of the app description and the ratings


Select CASE
			when length (b.app_desc)<500 Then 'Short'
            When length (b.app_desc) between 500 and 1000 then 'Medium'
            Else 'Long'
            End As description_lengh_bucket,
            avg(user_rating) as AvgRating


From 
		AppleStore as a
JOIN
		applestore_description_combined as b
On 

		a.id=b.id
        
Group By description_lengh_bucket
order by AvgRating


--Check top-rated apps for each genre


Select 
	 prime_genre,
     track_name,
     user_rating
     
From (
  Select 
  prime_genre,
  track_name,
  user_rating,
  RANK() Over(Partition By prime_genre order by user_rating desc, rating_count_tot Desc) as Rank
  From 
  AppleStore
  )
  as a
  
  Where Rank = 1
  