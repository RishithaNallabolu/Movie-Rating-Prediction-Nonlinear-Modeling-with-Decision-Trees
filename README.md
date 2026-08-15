# Movie Rating Prediction — Nonlinear Modeling with Decision Trees

A follow-up to the movie recommendation project, focused on data preparation best practices and comparing a nonlinear model (decision tree) against a linear regression baseline for predicting movie ratings.

## Dataset

`simulated_movie_recommendation_dataset_600_records.xlsx` — 600 user movie-rating records with UserID, MovieID, Rating (1–5), Timestamp, Genres, and ReleaseYear.

## Project workflow

**1. Data loading and inspection**
Loaded the dataset and used `str()` and `summary()` to verify data types and get an initial sense of each variable's distribution.

**2. Data preparation**
- Converted `Genres` to a categorical factor variable.
- Checked for missing values in `Rating` and `ReleaseYear`. Where present, missing ratings were replaced with the column mean and missing release years with the column median — chosen over dropping rows, since removing records would lose otherwise-usable data, and mean/median imputation preserves the overall distribution without introducing extreme bias for a roughly symmetric numeric field.
- Checked for outliers in `Rating` and `ReleaseYear` using boxplots, then applied the IQR method (1.5× interquartile range) to identify and remove outlier ratings before modeling.

**3. Train/validation split**
Split the cleaned data into 70% training and 30% validation sets using stratified sampling on the target variable, to ensure the model is evaluated on data it hasn't seen.

**4. Modeling — Decision Tree**
Built a decision tree (`rpart`) predicting `Rating` from `MovieID` and `ReleaseYear`, trained only on the training set, then generated predictions on the held-out validation set.

**5. Model comparison**
Evaluated the decision tree using RMSE and MAE, then built a linear regression model on the same features and same train/validation split for a direct, apples-to-apples comparison between a nonlinear and a linear approach.

## Tools

R, rpart, rpart.plot, randomForest, caret, ggplot2, caTools

## Note on missing-value strategy

The assignment brief also raises an important related case worth noting: not every missing value should be treated the same way. If a dataset merge introduces NAs because a category genuinely doesn't apply — for example, a country with no Olympic medal record — replacing that NA with 0 would be correct, since the true value is "none," not "unknown." In this dataset, missing ratings and release years reflect genuinely missing information rather than a true zero, which is why mean/median imputation was used instead.
