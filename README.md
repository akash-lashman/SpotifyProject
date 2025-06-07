Objective:
Analyze and visualize Spotify track data by integrating platform performance (TikTok, YouTube, Shazam), ranking, and audio features to uncover drivers of popularity using Python, SQL, and Power BI.

❓ Key Questions & Insights
What drives Spotify popularity?
→ High danceability, low acousticness, and strong Shazam/TikTok activity correlate with top performance.

Does social media impact Spotify success?
→ Not directly. High engagement ≠ playlist placement.

Do recent tracks perform better?
→ Yes — most top tracks were released post-2020.

Which genres and moods dominate?
→ Electronic/Dance leads. BGM suits cheerful moods, vocals fit neutral/sad tones.

Are explicit tracks increasing?
→ Yes — especially post-2020, reflecting genre evolution.

🧰 Tools & Technologies Used
Python: Pandas, NumPy, Seaborn, Matplotlib, Scikit-learn
→ Data cleaning, EDA, imputation, feature engineering

SQL Server:
→ Joins, view creation, deduplication, aggregations

Power BI:
→ Data modeling, DAX, Power Query (M), slicers, visualizations

📂 Data Sources
Spotify2024.csv: Platform metrics (streams, playlists, TikTok, YouTube, rankings)

dataset.csv: Audio features (danceability, loudness, valence, metadata)

🔄 Pipeline Overview

Python Preprocessing
Cleaned nulls, timestamps, standardized types

Imputation:

Linear Regression for correlated metrics (e.g., Shazam ↔ Streams)

KNN and mean/mode for others

Feature engineering: mood categories, clean text fields

Visuals: correlation heatmaps, scatterplots

🛠️ SQL Operations
Merged datasets using joins + regex logic

Created modular views for slicers

Handled join mismatches & nulls with fallback methods

📊 Power BI Reporting
Star schema: final_trackdesc as fact table

Slicers: Genre, Year, Rank, Mode

DAX: Custom rank, updated score metrics

📈 Dashboard Overview
Popularity & Genre Trends
Explore top tracks, artists, and genres (2015–2024). Filter by rating, song length, key, mode, and explicitness to uncover genre-specific patterns.

Social Media & Engagement Insights
Visualize reach across Spotify, YouTube, TikTok, and Shazam. Analyze rankings, categorize recognition levels, and track viral trends over time.

Artist-Level Audio Analysis
Dive into artist traits such as popularity, instrumentalness, and danceability. Filter by type, mood, and mode; examine distributions of acousticness and loudness.


✅ Outcomes
Seamless ETL pipeline from raw CSVs to insights

Smart SQL views for faster Power BI filtering

Uncovered key audio and genre-based drivers of engagement

⚠️ Challenges & Solutions
Challenge: Social media fields had excessive missing values, making imputation complex. Solution: Correlation analysis guided imputation strategy—used linear regression where correlation was strong (e.g., with streams), and KNN for weaker ones.
🛠️ SQL Server
Challenge 1: Join mismatches due to inconsistent track, artist, and album strings. Solution: Cleaned with regex, LOWER (), and surrogate keys; used fallback LIKE joins.
Challenge 2: CTEs caused performance issues at scale. Solution: Modularized logic using temporary tables to reduce memory load.
📊 Power BI
Challenge 1: Merging TikTok and YouTube metrics was difficult due to scale difference. Solution: Used unpivot transformation and slicers for unified visual.
Challenge 2: Large, merged dataset made reports heavy. Solution: Used slicers, parameters, and calculated fields to guide user flow and isolate insights.
