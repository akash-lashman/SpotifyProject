# SpotifyProject
Objective: Analyze and visualize Spotify track data by integrating platform performance (TikTok, YouTube, Shazam), ranking, and audio features to uncover drivers of popularity using Python, SQL, and Power BI.
________________________________________
❓ Key Questions & Insights
•	What drives Spotify popularity?
→ High danceability, low acousticness, and strong Shazam/TikTok activity correlate with top performance.
•	Does social media impact Spotify success?
→ Not directly. High engagement ≠ playlist placement.
•	Do recent tracks perform better?
→ Yes — most top tracks were released post-2020.
•	Which genres and moods dominate?
→ Electronic/Dance leads. BGM suits cheerful moods, vocals fit neutral/sad tones.
•	Are explicit tracks increasing?
→ Yes — especially post-2020, reflecting genre evolution.
________________________________________
🧰 Tools & Technologies Used
•	Python: Pandas, NumPy, Seaborn, Matplotlib, Scikit-learn
→ For cleaning, EDA, imputation, and feature engineering
•	SQL Server:
→ Joins, view creation, deduplication, aggregations
•	Power BI:
→ Data modeling, DAX, Power Query (M), slicers, visuals
________________________________________
📂 Data Sources
•	Spotify2024.csv: Platform metrics (streams, playlist, TikTok, YouTube, rankings)
•	dataset.csv: Audio features (danceability, loudness, valence, metadata)
________________________________________
🔄 Pipeline Overview
🔍 Python Preprocessing
•	Cleaned nulls, timestamps, standardized types
•	Imputation:
o	Linear Regression for correlated metrics (e.g., Shazam ↔ Streams)
o	KNN and mean/mode for others
•	Feature engineering: mood category, clean text fields
•	Visuals: Correlation heatmaps, scatterplots
🛠️ SQL Operations
•	Merged cleaned datasets using joins & regex logic
•	Created modular views for Power BI slicers
•	Handled join mismatches & nulls post-merge
📊 Power BI Reporting
•	Star schema with final_trackdesc as fact table
•	Slicers: Genre, Year, Rank, Mode
•	DAX: Track rank, updated score
📊 Dashboard Overview
1.	Popularity & Genre Trends
Explore top tracks, artists, and genres from 2015–2024. View trends by rating, song length, key, mode, and explicitness. Filters allow deep dives into genre-specific performance and temporal patterns.
2.	Social media & Engagement Insights
Visualize Spotify, YouTube, TikTok, and Shazam reach. Track popularity rankings, categorize songs by recognition level, and analyze yearly trends in track releases and virality across platforms.
3.	Artist-Level Audio Analysis
Break down artists by popularity, instrumentalness, and danceability. Filter by song type, mood, mode, and explicitness. Includes acoustic and loudness distributions to uncover detailed audio traits.
________________________________________
📦 Deliverables
•	final_trackdesc (cleaned + joined dataset)
•	Python notebooks: EDA, imputation
•	SQL scripts: joins, views
•	Power BI dashboard: dynamic, filterable insights
________________________________________
✅ Outcomes
•	Seamless ETL pipeline from raw CSVs to insights
•	Smart SQL modular views for faster Power BI filtering
•	Uncovered key audio and genre-based drivers of engagement
________________________________________
⚠️ Challenges & Solutions
Area	Challenge	Solution
Python	Imputing sparse social data	Used correlation-based strategy (linear regression + KNN)
SQL	Join mismatches due to inconsistent text	Cleaned with regex, surrogate keys, fallback LIKE
Power BI	Large dataset → slow reports	Used parameters, slicers, and views to improve speed
