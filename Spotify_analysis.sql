--Created a new database and using it
create database Spotify_project
use Spotify_project

--Flat files imported and viewed as table
select * from exported_data
select * from track_desc

-- Optional: Drop if it already exists
IF OBJECT_ID('tempdb..#distinct_tracks_clean') IS NOT NULL DROP TABLE #distinct_tracks_clean;

--Creating a temp distinct track_desc table
SELECT *
INTO #distinct_tracks_clean
FROM (
    SELECT *, ROW_NUMBER() OVER (PARTITION BY clean_track ORDER BY track_id) AS rn
    FROM track_desc
) t
WHERE rn = 1;
select * from #distinct_tracks_clean

--Joining the distinct_tracks_clean with exported_data where clean track matches and store it as temp table exact_matches - 1935 rows
select
	e.*,
	t.duration_ms,
    t.track_genre,
    t.danceability,
    t.[key] AS track_key,
    t.loudness,
    t.mode,
    t.acousticness,
    t.instrumentalness,
    t.valence
into #exact_matches
from exported_data e
left join #distinct_tracks_clean t
on UPPER(t.clean_track) = UPPER(e.clean_track)
select * from #exact_matches
where duration_ms is not null
order by All_Time_Rank asc

----Joining the exact_matches and distinct_track_cleans where first word of clean_track matches - 1684 rows
SELECT 
    e.clean_track,
    MAX(t.duration_ms) AS fb_duration_ms,
    MAX(t.track_genre) AS fb_track_genre,
    MAX(t.danceability) AS fb_danceability,
    MAX(t.[key]) AS fb_track_key,
    MAX(t.loudness) AS fb_loudness,
    MAX(CAST(t.mode AS INT)) AS fb_mode,
    MAX(t.acousticness) AS fb_acousticness,
    MAX(t.instrumentalness) AS fb_instrumentalness,
    MAX(t.valence) AS fb_valence
INTO #likewise_matches
FROM #exact_matches e
left join #distinct_tracks_clean t
on e.duration_ms IS NULL
and LEFT(UPPER(e.clean_track), CHARINDEX(' ', e.clean_track + ' ') - 1) =
    LEFT(UPPER(t.clean_track), CHARINDEX(' ', t.clean_track + ' ') - 1)
group by e.clean_track

select * from #likewise_matches
where fb_duration_ms is not null

--Joining both exact_matches and likewise_matches table - 3763 rows
select
    e.ISRC,
	e.all_time_rank,
	e.track_score,
	e.Spotify_Streams,
	e.Spotify_Playlist_Count,
	e.spotify_playlist_reach,
	e.youtube_views,
	e.youtube_likes,
	e.tiktok_likes,
	e.tiktok_views,
	e.shazam_counts,
	e.explicit_track,
	e.spotify_pop_category,
	e.release_year,
	e.clean_track,
	e.clean_album,
	e.clean_artist,
    COALESCE(e.duration_ms, f.fb_duration_ms) AS duration_ms,
    COALESCE(e.track_genre, f.fb_track_genre) AS track_genre,
    COALESCE(e.danceability, f.fb_danceability) AS danceability,
    COALESCE(e.track_key, f.fb_track_key) AS track_key,
    COALESCE(e.loudness, f.fb_loudness) AS loudness,
    COALESCE(e.mode, f.fb_mode) AS mode,
    COALESCE(e.acousticness, f.fb_acousticness) AS acousticness,
    COALESCE(e.instrumentalness, f.fb_instrumentalness) AS instrumentalness,
    COALESCE(e.valence, f.fb_valence) AS valence
into dbo.final_trackdesc
from #exact_matches e
left join #likewise_matches f 
on e.Clean_track = f.Clean_track

select * from final_trackdesc
where duration_ms is not null

---Filling numeric null values into mean
update final_trackdesc
set duration_ms = ISNULL(duration_ms, (select avg(duration_ms) from final_trackdesc)),
	danceability = ISNULL(danceability, (select avg(danceability) from final_trackdesc)),
	loudness = ISNULL(loudness, (select avg(loudness) from final_trackdesc)),
	acousticness = ISNULL(acousticness, (select avg(acousticness) from final_trackdesc)),
	instrumentalness = ISNULL(instrumentalness, (select avg(instrumentalness) from final_trackdesc)),
	valence = ISNULL(valence, (select avg(valence) from final_trackdesc))

---Filling categorical null values into mode
update final_trackdesc
set	track_genre = ISNULL(track_genre, 
	(select top 1 track_genre from final_trackdesc
	where track_genre is not null
	group by track_genre
	order by count(*) desc)),
	track_key = ISNULL(track_key, 
	(select top 1 track_key from final_trackdesc
	where track_key is not null
	group by track_key
	order by count(*) desc)),
	mode = ISNULL(mode, 
	(select top 1 mode from final_trackdesc
	where mode is not null
	group by mode
	order by count(*) desc))

--Exploratory data analysis

--Details of Top 10 songs
select top 10* from final_trackdesc
order by All_Time_Rank asc

--Descriptive Statistics for Numeric Columns
--explains all these below columns are in a range of 0-1
SELECT
    COUNT(*) AS total_rows,
    MIN(danceability) AS min_danceability,
    MAX(danceability) AS max_danceability,
    AVG(danceability) AS avg_danceability,
    STDEV(danceability) AS stddev_danceability,
    
    MIN(valence) AS min_valence,
    MAX(valence) AS max_valence,
    AVG(valence) AS avg_valence,
    STDEV(valence) AS stddev_valence,

    MIN(duration_ms) AS min_duration_ms,
    MAX(duration_ms) AS max_duration_ms,
    AVG(duration_ms) AS avg_duration_ms,
    STDEV(duration_ms) AS stddev_duration_ms,

    MIN(acousticness) AS min_acousticness,
    MAX(acousticness) AS max_acousticness,
    AVG(acousticness) AS avg_acousticness,
    STDEV(acousticness) AS stddev_acousticness
FROM dbo.final_trackdesc;

-- Total no of songs in each key and 11 trends top while others are in the range of 180-300 songs per key, except key 3.
create view trackkey_counts as 
select track_key, count(*) as key_values
from final_trackdesc
group by track_key

select * from trackkey_counts 
order by track_key

--Creating view mode counts where 1 mode has the most songs
create view mode_slicer as 
select mode, 
CASE when mode = 0 then 'minor'
when mode = 1then 'major'
end as mode_name,
count(*) as mode_values
from final_trackdesc
group by mode

select * from mode_slicer 

--Creating view explicit counts where 0 explciit has the most songs
create view explicit_slicer as 
select explicit_track, 
CASE when explicit_track = 0 then 'Implicit'
when explicit_track = 1 then 'Explicit'
end as explicit_name,
count(*) as explicit_values
from final_trackdesc
group by explicit_track

select * from explicit_slicer 

--list of track genre where world music is the highest contributor
--rock, elec(edm, idm, funk), tech, dance and pop category has lots of diff name which can be clubbed together
--children, kids, study can be clubbed
--salsa, jazz, opera, classical, samba as classics
--after clubbing anything less than 20 as others
select track_genre, count(*) as genre_songs
from final_trackdesc
group by track_genre
order by count(*) desc

-- so these are values which contains rock in it
SELECT track_genre, COUNT(*) AS genre_songs
FROM final_trackdesc
WHERE track_genre LIKE '%rock%'
GROUP BY track_genre
ORDER BY COUNT(*) DESC

SELECT track_genre, COUNT(*) AS genre_songs
FROM final_trackdesc
WHERE track_genre LIKE '%pop%'
GROUP BY track_genre
ORDER BY COUNT(*) DESC

SELECT track_genre, COUNT(*) AS genre_songs
FROM final_trackdesc
WHERE track_genre LIKE '%dance%'
GROUP BY track_genre
ORDER BY COUNT(*) DESC

SELECT track_genre, COUNT(*) AS genre_songs
FROM final_trackdesc
WHERE track_genre LIKE '%elec%'
GROUP BY track_genre
ORDER BY COUNT(*) DESC

SELECT track_genre, COUNT(*) AS genre_songs
FROM final_trackdesc
WHERE track_genre LIKE '%tech%'
GROUP BY track_genre
ORDER BY COUNT(*) DESC

---Updating the table based on above observations
update final_trackdesc
set track_genre = case
	when track_genre like '%rock%' then 'rock'
	when track_genre like '%pop%' then 'pop'
	when track_genre = 'trip-hop' then 'hip-hop'
	when track_genre like '%dance%' then 'dance'
	when track_genre like '%elec%' or track_genre in ('edm', 'idm') then 'electronic'
	when track_genre like '%tech%' then 'techno'
	when track_genre = 'funk' then 'punk'
	when track_genre in ('study', 'kids', 'children', 'disney', 'show-tunes') then 'kids'
	when track_genre in ('jazz', 'salsa', 'opera', 'classical') then 'classics'
	when track_genre in ('spanish', 'latino', 'latin') then 'latin'
	when track_genre in ('guitar', 'drum-and-bass', 'garage', 'piano') then 'acoustic'
	when track_genre in ('swedish' , 'british', 'brazil', 'anime', 'indie', 'french', 'turkish', 'tango') then 'exotic'
	when track_genre in ('sad', 'soul', 'sleep', 'breakfast', 'house', 'chill') then 'slowcore'
	when track_genre in (select track_genre from final_trackdesc
		group by track_genre
		having count(*)<25) then 'others'
	else track_genre
end;

--View table for list of genre and no of songs
create view genrelist_slicer as
select top 10 track_genre, count(*) as genre_songs
from final_trackdesc
where track_genre != 'others'
group by track_genre
order by count(*) desc

select * from genrelist_slicer


-- instrumentalness column is classified based on the values
with instrumentclass as (
select *,
	case when instrumentalness <0.05 then 'vocal'
		when instrumentalness >0.9 then 'BGM'
		else 'mixed'
		end as instrumental_type
from final_trackdesc
)
select instrumental_type, count(*) as track_count
from instrumentclass
group by instrumental_type

--Added a new column to insert values from duration_ms and categorised into three
alter table final_trackdesc add duration_type varchar(50)

WITH Percentiles AS (
    SELECT
        PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY duration_ms) over () AS Q1,
        PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY duration_ms) over() AS Q3
    FROM final_trackdesc
)
UPDATE final_trackdesc
SET duration_type = CASE
    WHEN duration_ms < (SELECT top 1 Q1 FROM Percentiles) THEN 'short song'
    WHEN duration_ms < (SELECT top 1  Q3 FROM Percentiles) THEN 'medium song'
    ELSE 'long song'
END;

--Creating a view table for duration_type
select duration_type, count(*) as duration_count 
from final_trackdesc
group by duration_type

-- type of acousticness based on value
with acousticness_type as (
select *,
	case when acousticness >0.75 then 'acoustic'
	when acousticness >0.25 then 'blend'
	else 'electronic'
	end as acoustic_type
from final_trackdesc
)
select acoustic_type, count(*) as acoustic_value
from acousticness_type
group by acoustic_type

--top_artistlist having max songs in this data
select top 20 clean_artist, count(*) as song_count
from final_trackdesc
group by clean_artist
order by count(*) desc

--Creating view table toprank_track having max songs in this data
create view topranktrack_slicer as 
select clean_track, all_time_rank
from final_trackdesc
where all_time_rank<11

select * from topranktrack_slicer
order by all_time_rank

--creating view release_yearlist having top hit songs
create view releaseyear_slicer as
select top 10release_year, count(*) as year_counts
from final_trackdesc
group by release_year
order by count(*) desc

select * from releaseyear_slicer
select * from final_trackdesc

--checking valence ratio in table
with valencetab as (
select *, case when valence < 0.4 then 'sad'
when valence <0.7 then 'chill'
else 'happy'
end as moodofsong
from final_trackdesc)
select moodofsong,
count(*) as totalsongs
from valencetab
group by moodofsong