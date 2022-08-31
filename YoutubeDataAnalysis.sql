-- CLEAN UP: Removing Duplicates in VideoStats Table
WITH cte AS (
    SELECT 
         VideoStats.VideoId, 
		 VideoStats.VTitle,
        ROW_NUMBER() OVER (
            PARTITION BY 
                 VideoStats.VideoId,
				 VideoStats.VTitle
            ORDER BY 
                 VideoStats.VideoId,
				 VideoStats.VTitle
        ) row_num
     FROM 
        dbo.VideoStats
)
DELETE FROM cte
WHERE row_num > 1;


-- Selects All the Data to be Worked With

	-- Comments Data: dbo.Comments
	/*	CommentId: The Comment Identifier.
		VideoId: The Video Identifier.
		Comment: The comment text.
		Likes: The number of likes the comment received.
		Sentiment: The sentiment of the comment. A value of 0 represents a negative sentiment, 
					while values of 1 or 2 represent neutral and positive sentiments respectively.
	*/

	Select *
	From dbo.Comments
	Order By 1

	-- Videos Data: dbo.VideoStats
	/*	VId: The Sequential Video Identifier.
		VTitle: Video Title.
		VideoId: The Video Identifier.
		PublishedAt: The date the video was published in YYYY-MM-DD.
		Keyword: The keyword associated with the video.
		Likes: The number of likes the video received. If this value is -1, the likes are not publicly visible.
		Comments: The number of comments the video has. If this value is -1, the video creator has disabled comments.
		Views: The number of views the video got.
	*/

	Select *
	From dbo.VideoStats
	Order By 1

-- QUERIES AND ANALYSIS
-- Popularity of Videos Ordered by Highest Views to Lowest
	Select *
	From dbo.VideoStats
	Order By VideoStats.Views desc

-- Keyword Popularity Ordered by Most Likes to Lowest
	Select Keyword, COUNT(VId) as Videos, SUM(Likes) as TotalLikes, SUM(Views) as TotalViews
	From dbo.VideoStats
	Group By Keyword
	Order By TotalLikes desc

-- Keyword Popularity Ordered by Most Views to Lowest
	Select Keyword, COUNT(VId) as Videos, SUM(Likes) as TotalLikes, SUM(Views) as TotalViews
	From dbo.VideoStats
	Group By Keyword
	Order By TotalViews desc

-- Average Sentiment Per Video
	Create Table #sentiments
	(
		VidTitle nvarchar(255),
		AverageSentiment float
	);

	Insert Into #sentiments
	Select VideoStats.VTitle, SUM(Comments.Sentiment)/Count(Comments.Sentiment) as AverageSentiment
	From dbo.Comments
	JOIN dbo.VideoStats on VideoStats.VideoId = Comments.VideoId
	Group By VideoStats.VTitle
	Order By AverageSentiment asc;

	-- Frequency Histogram 
	Select '0.00 - 0.25' as Category, Count(AverageSentiment) as Frequency from #sentiments
	where AverageSentiment between 0 and 0.25
	Union
	Select '0.26 - 0.50' as Category, Count(AverageSentiment) as Frequency from #sentiments
	where AverageSentiment between 0.26 and 0.50
	Union
	Select '0.51 - 0.75' as Category, Count(AverageSentiment) as Frequency from #sentiments
	where AverageSentiment between 0.51 and 0.75
	Union
	Select '0.76 - 1.00' as Category, Count(AverageSentiment) as Frequency from #sentiments
	where AverageSentiment between 0.76 and 1.0
	Union
	Select '1.01 - 1.25' as Category, Count(AverageSentiment) as Frequency from #sentiments
	where AverageSentiment between 1.01 and 1.25
	Union
	Select '1.26 - 1.50' as Category, Count(AverageSentiment) as Frequency from #sentiments
	where AverageSentiment between 1.26 and 1.50
	Union
	Select '1.51 - 1.75' as Category, Count(AverageSentiment) as Frequency from #sentiments
	where AverageSentiment between 1.51 and 1.75
	Union
	Select '1.76 - 2.00' as Category, Count(AverageSentiment) as Frequency from #sentiments
	where AverageSentiment between 1.76 and 2.0

-- Percentage of Likes from Total Views of Each Youtube Video Ordered from Highest to Lowest Percentage
	Select VId, VTitle, Likes, Views, ((Likes/Views)*100) as LikePercentage
	From dbo.VideoStats
	Order By LikePercentage desc

-- Comparison of Video Positive, Neutral and Negative Likes, Only Includes Videos Having All Category Likes
	With cte_pos_comments(id, vtitle, positives) as
	(
		Select VideoStats.VideoId, VideoStats.VTitle, COUNT(Comments.Sentiment) as PositiveCount
		From dbo.VideoStats
		Inner Join dbo.Comments on Comments.VideoId = VideoStats.VideoId
		Where Comments.Sentiment = 2
		Group By VideoStats.VideoId, VideoStats.VTitle, VideoStats.Likes, VideoStats.Views
	), 	cte_neg_comments(id, vtitle, negatives) as
	(
		Select VideoStats.VideoId, VideoStats.VTitle, COUNT(Comments.Sentiment) as NegativeCount
		From dbo.VideoStats
		Inner Join dbo.Comments on Comments.VideoId = VideoStats.VideoId
		Where Comments.Sentiment = 0
		Group By VideoStats.VideoId, VideoStats.VTitle, VideoStats.Likes, VideoStats.Views
	), cte_neut_comments(id, vtitle, neutrals) as
	(
		Select VideoStats.VideoId, VideoStats.VTitle, COUNT(Comments.Sentiment) as NeutralCount
		From dbo.VideoStats
		Inner Join dbo.Comments on Comments.VideoId = VideoStats.VideoId
		Where Comments.Sentiment = 1
		Group By VideoStats.VideoId, VideoStats.VTitle, VideoStats.Likes, VideoStats.Views
	)
	Select neg.id, neg.vtitle, pos.positives as 'Positives', neut.neutrals as 'Neutrals', neg.negatives as 'Negatives'
	From cte_neg_comments as neg
	Full Join cte_pos_comments as pos on pos.id = neg.id
	Full Join cte_neut_comments as neut on neut.id = neg.id
	Where neg.id is not null and pos.id is not null and neut.id is not null
	Order By Positives desc

-- Number of Positive Comments Per Video Ordered by Highest Count to Lowest Count
	Select VideoStats.VideoId, VideoStats.VTitle, COUNT(Comments.Sentiment) as PositiveCount
	From dbo.VideoStats
	Inner Join dbo.Comments on Comments.VideoId = VideoStats.VideoId
	Where Comments.Sentiment = 2
	Group By VideoStats.VideoId, VideoStats.VTitle, VideoStats.Likes, VideoStats.Views
	Order By PositiveCount desc

	Select * from dbo.VideoStats
	inner join dbo.Comments on Comments.VideoId = VideoStats.VideoId
	where VideoStats.VideoId = '7eh4d6sabA0'

-- Number of Negative Comments Per Video Ordered by Highest Count to Lowest Count
	Select VideoStats.VideoId, VideoStats.VTitle, VideoStats.Likes, VideoStats.Views, COUNT(Comments.Sentiment) as NegativeCount
	From dbo.VideoStats
	Inner Join dbo.Comments on Comments.VideoId = VideoStats.VideoId
	Where Comments.Sentiment = 0
	Group By VideoStats.VideoId, VideoStats.VTitle, VideoStats.Likes, VideoStats.Views
	Order By NegativeCount desc

-- Number of Neutral Comments Per Video Ordered by Highest Count to Lowest Count
	Select VideoStats.VideoId, VideoStats.VTitle, VideoStats.Likes, VideoStats.Views, COUNT(Comments.Sentiment) as NeutralCount
	From dbo.VideoStats
	Inner Join dbo.Comments on Comments.VideoId = VideoStats.VideoId
	Where Comments.Sentiment = 1
	Group By VideoStats.VideoId, VideoStats.VTitle, VideoStats.Likes, VideoStats.Views
	Order By NeutralCount desc

-- Text Generation, Comments Starting with "Thank you"
	Select COUNT(CommentId) as CommentCount from dbo.Comments
	Where Comment like 'thank you%'

-- Further Analysis To Be Added: Predicting Video Likes from Comments Table Data

