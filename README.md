**Objective:**
Analyze and visualize Spotify track data by integrating platform performance (TikTok, YouTube, Shazam), ranking, and audio features to uncover drivers of popularity using Python, SQL, and Power BI.

❓** Key Questions & Insights**

1. What drives Spotify popularity?
→ High danceability, low acousticness, and strong Shazam/TikTok activity correlate with top performance.

2. Does social media impact Spotify success?
→ Not directly. High engagement ≠ playlist placement.

3. Do recent tracks perform better?
→ Yes — most top tracks were released post-2020.

4. Which genres and moods dominate?
→ Electronic/Dance leads. BGM suits cheerful moods, vocals fit neutral/sad tones.

5. Are explicit tracks increasing?
→ Yes — especially post-2020, reflecting genre evolution.

🧰 **Tools & Technologies Used**

* Python: Pandas, NumPy, Seaborn, Matplotlib, Scikit-learn
→ Data cleaning, EDA, imputation, feature engineering

* SQL Server:
→ Joins, view creation, deduplication, aggregations

* Power BI:
→ Data modeling, DAX, Power Query (M), slicers, visualizations

📂 **Data Sources**

Spotify2024.csv: Platform metrics (streams, playlists, TikTok, YouTube, rankings)

dataset.csv: Audio features (danceability, loudness, valence, metadata)

🔄 **Pipeline Overview**

**Python Preprocessing:** 

* Cleaned nulls, timestamps, standardized types

* Imputation: Linear Regression for correlated metrics (e.g., Shazam ↔ Streams), KNN and mean/mode for others

* Feature engineering: mood categories, clean text fields

* Visuals: correlation heatmaps, scatterplots

🛠️** SQL Operations**

* Merged datasets using joins + regex logic

* Created modular views for slicers

* Handled join mismatches & nulls with fallback methods

📊** Power BI Reporting**

* Star schema: final_trackdesc as fact table

* Slicers: Genre, Year, Rank, Mode

* DAX: Custom rank, updated score metrics

📈 **Dashboard Overview**

**Popularity & Genre Trends**
Explore top tracks, artists, and genres (2015–2024). Filter by rating, song length, key, mode, and explicitness to uncover genre-specific patterns.

**Social Media & Engagement Insights**
Visualize reach across Spotify, YouTube, TikTok, and Shazam. Analyze rankings, categorize recognition levels, and track viral trends over time.

**Artist-Level Audio Analysis**
Dive into artist traits such as popularity, instrumentalness, and danceability. Filter by type, mood, and mode; examine distributions of acousticness and loudness.


✅** Outcomes**

Seamless ETL pipeline from raw CSVs to insights

Smart SQL views for faster Power BI filtering

Uncovered key audio and genre-based drivers of engagement

⚠️** Challenges & Solutions**

1. Python – Imputing Sparse Social Data:
Some platform metrics like Shazam or TikTok data were missing for several tracks. To address this, I applied a hybrid imputation strategy — using linear regression when metrics were strongly correlated (e.g., Shazam and Streams), and KNN or mean/mode imputation for the rest.

2. SQL – Join Mismatches Due to Inconsistent Text:
When merging datasets, inconsistent text formatting caused join mismatches. I solved this by cleaning key fields with regex, creating surrogate keys, and using fallback LIKE logic when exact matches failed.

3. Power BI – Slow Performance with Large Dataset:
The Power BI dashboard initially had slow load times due to the volume of data. I improved performance by creating modular SQL views, applying filters and parameters, and designing the schema to support efficient slicers.


