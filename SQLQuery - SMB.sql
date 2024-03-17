CREATE DATABASE SocialMediaB;
USE SocialMediaB;

SELECT *
FROM socialmedia;
-- Totals (Likes, Comments, Shares)

SELECT SUM (Likes_Reactions)AS TotalReaction, SUM (Comments)TotalComments, SUM (Shares_Retweets)AS TotalShare
FROM socialmedia

-- Create View to speed uu to reading and the results you need
CREATE VIEW Top_SM_Info
AS 
SELECT User_ID, Username, Account_Verification, Platform, Likes_Reactions, Comments, Shares_Retweets, Media_Type, Server_Post
FROM socialmedia
-- Top Engaging Platforms
SELECT Platform, Likes_Reactions, Comments, Shares_Retweets
FROM Top_SM_Info
ORDER BY Likes_Reactions DESC, Comments DESC, Shares_Retweets DESC;
-- Top Engaging By Media Type
SELECT Platform, Likes_Reactions, Comments, Shares_Retweets, Media_Type
FROM Top_SM_Info
ORDER BY Likes_Reactions DESC, Comments DESC, Shares_Retweets DESC;
-- Top Engaging By User Name
SELECT Platform, Account_Verification, Username, Likes_Reactions, Comments, Shares_Retweets, Media_Type, Server_Post
FROM Top_SM_Info
ORDER BY Likes_Reactions DESC, Comments DESC, Shares_Retweets DESC;


--Best Time + User_activity
SELECT TOP 10 
    Post_ID, 
    Post_Timestamp,
    User_Activity,
    Likes_Reactions, 
    Comments, 
    Shares_Retweets,
    Media_Type,
    Server_Post,
	Hashtags, Post_Text, Platform
FROM socialmedia
ORDER BY Likes_Reactions DESC, Comments DESC, Shares_Retweets DESC;
--------------------------------------------------------------------------
--------------------------------------------------------------------------
---- WebSite Analysis----------
--------------------------------------------------------------------------
--------------------------------------------------------------------------
SELECT *
FROM WebData

SELECT user_id, COUNT(*) AS Total_Users
FROM WebData2
GROUP BY user_id;
--Moving User to another table to uniqe count 
SElECT user_id
INTO Webdata2
FROM WebData
-- Remove id's duplicates
WITH CTE AS (
    SELECT 
        user_id,
        ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY (SELECT NULL)) AS RowNum
    FROM Webdata2
)
DELETE FROM CTE WHERE RowNum > 1;
-- Total Users
SELECT COUNT (user_id) AS Total_Users
FROM Webdata2
-- Total Viwe & Purchase & Cart
SELECT
  SUM(CASE WHEN event_type = 'view' THEN 1 ELSE 0 END) AS Total_Views,
  SUM(CASE WHEN event_type = 'purchase' THEN 1 ELSE 0 END) AS Total_Purchases,
  SUM(CASE WHEN event_type = 'cart' THEN 1 ELSE 0 END) AS Total_Carts
FROM WebData;
-- Top Purchasing products
SELECT
  user_id,
  product_id,
  COUNT(*) AS Total_Purchases, 
  price AS Total_Price,
  event_time
FROM WebData
WHERE event_type = 'Purchase'
GROUP BY user_id, product_id, price, event_time
ORDER BY price DESC;
-- Cart Users they didn't reach the buying stage
SELECT
  user_id,
  product_id,
  brand,
  COUNT(CASE WHEN event_type = 'Cart' THEN 1 ELSE NULL END) AS Total_Carts
FROM WebData
WHERE event_type IN ('Cart', 'Purchase')
GROUP BY user_id, product_id, brand
HAVING COUNT(CASE WHEN event_type = 'Purchase' THEN 1 ELSE NULL END) = 0;
--------------------------------------------------------------------------
--------------------------------------------------------------------------
---- ADS Analysis----------
--------------------------------------------------------------------------
--------------------------------------------------------------------------
--Total Of interest & Impression & Clics & Spent
SELECT SUM(interest) AS Total_Interest, SUM(Impressions) AS Total_Impressions, SUM(Clicks) AS Total_Clicks, SUM(Spent) AS Total_Spent,
SUM(Total_Conversion) AS Total_Conversion, SUM(Approved_Conversion) AS Total_Approved_Conversion
FROM Ads_data

-- Best ages by Clics AND Gender (interest & Impression)
SELECT age, gender, interest, Impressions, Clicks
FROM Ads_data
GROUP BY age, gender, interest, Impressions, Clicks
ORDER BY Clicks DESC;

--Total of Conversion and Approved & Not_Approved BY age, gender
SELECT
  age,
  gender,
  Total_Conversion,
  Approved_Conversion,
  (Total_Conversion - Approved_Conversion) AS Not_Approved_Conversion
FROM Ads_data
GROUP BY age, gender, Total_Conversion,
  Approved_Conversion
ORDER BY Total_Conversion DESC;








