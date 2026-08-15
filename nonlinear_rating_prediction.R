# question 1 

library(readxl)
install.packages("rpart") 
library(rpart)
install.packages("rpart.plot")
library(rpart.plot)
install.packages("randomForest")
library(randomForest)
install.packages("caret")
install.packages("ggplot2")
library(ggplot2)
library(caret)

# 1a
library(readxl)
data <- read_excel("simulated_movie_recommendation_dataset_600_records.xlsx")
head(data)

#1b

str(data)
summary(data)

#1c
#c(i)

data$Genres <- as.factor(data$Genres)
str(data)

#c(ii)

colSums(is.na(data))

if (sum(is.na(data$Rating)) > 0) {
  data$Rating[is.na(data$Rating)] <- mean(data$Rating, na.rm = TRUE)
}

if (sum(is.na(data$ReleaseYear)) > 0) {
  data$ReleaseYear[is.na(data$ReleaseYear)] <- median(data$ReleaseYear, na.rm = TRUE)
}

colSums(is.na(data))

#c(iii)

# Boxplot to check for outliers in Rating
ggplot(data, aes(x = Rating)) + geom_boxplot()

# Boxplot for ReleaseYear
ggplot(data, aes(x = ReleaseYear)) + geom_boxplot()

Q1 <- quantile(data$Rating, 0.25)
Q3 <- quantile(data$Rating, 0.75)
IQR_value <- Q3 - Q1

lower_bound <- Q1 - 1.5 * IQR_value
upper_bound <- Q3 + 1.5 * IQR_value

# Filtering data to remove outliers
data <- data[data$Rating >= lower_bound & data$Rating <= upper_bound, ]

#1d

install.packages("caTools")
library(caTools)

# Set seed for reproducibility
set.seed(123)

# Split the data into 70% training and 30% validation
split <- sample.split(data$Rating, SplitRatio = 0.7)

training_set <- subset(data, split == TRUE)
validation_set <- subset(data, split == FALSE)

nrow(training_set)  # Should be ~70%
nrow(validation_set)  # Should be ~30%

#question 2
#2a

# Creating decision tree model
decision_tree_model <- rpart(Rating ~ MovieID + ReleaseYear, data = training_set)

rpart.plot(decision_tree_model, main = "Decision Tree for Rating Prediction", type = 3, extra = 101)

#2c

dt_predictions <- predict(decision_tree_model, newdata = validation_set)
print(dt_predictions)

#2d

dt_rmse <- sqrt(mean((dt_predictions - validation_set$Rating)^2))
dt_mae <- mean(abs(dt_predictions - validation_set$Rating))

# Print Evaluation Results
cat("Decision Tree RMSE:", dt_rmse, "\n")
cat("Decision Tree MAE:", dt_mae, "\n")


#2e

linear_model <- lm(Rating ~ MovieID + ReleaseYear, data = training_set)

linear_predictions <- predict(linear_model, newdata = validation_set)

linear_rmse <- sqrt(mean((linear_predictions - validation_set$Rating)^2))
linear_mae <- mean(abs(linear_predictions - validation_set$Rating))

cat("Linear Model RMSE:", linear_rmse, "\n")
cat("Linear Model MAE:", linear_mae, "\n")

