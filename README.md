# SQL Exploration - Popularity of Youtube Videos Data Analysis
Project Date: August 30, 2022

## Objective
An analysis was conducted on YouTube's data sets to understand the popularity of videos based on comments, views and likes. 
The datasets were collected from [Kaggle](https://www.kaggle.com/datasets/advaypatil/youtube-statistics).

## Technologies, Tools and Methods Used
- SQL (Microsoft SQL Server)
- Microsoft Excel
- Data Cleansing
- Data Analysis

## Analysis Summary
After performing a data cleanup in the Video Statistics table, the following analysis was derived:

Keyword Popularity Analysis: The associated keyword that contains most liked videos is "mrbeast" and "google" for the most viewed videos.
Average Sentiment Analysis: It can be seen that there is an average positive sentiment per video because the data is negatively skewed as the categories increase with the frequency increasing.

Sentiment Comparison Across Each YouTube Video Analysis: It is noticed that when there exists a high negative sentiment count for a video, the positive sentiment count is low. When there exists a high positive sentiment count, the negative sentiment count is low. When both the positive and negative sentiment count is low, the neutral sentiment count is high for the video.

Likes/Views Analysis: The number of likes from all views of each YouTube video falls into a percentage range of 0-21%.

Sentiment Count Analysis: The highest positive sentiment count is 20 comments. The highest negative sentiment count is 10 comments. The highest neutral sentiment count is 14 comments.

## Project Files
- YoutubeDataAnalysis.sql: Contains Cleanup, Dataset Descriptions and SQL Queries of Analysis
- comments.xlsx: Comments Table Dataset
- videos-stats.xlsx: VideoStats Table Dataset
