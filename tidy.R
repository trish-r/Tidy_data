# 1. Merge training and test sets
train <- read.table("UCI HAR Dataset/train/X_train.txt")
test <- read.table("UCI HAR Dataset/test/X_test.txt")
merged_data <- rbind(train, test)

# 2. Extract mean and standard deviation measurements
features <- read.table("UCI HAR Dataset/features.txt")
mean_std_cols <- grep("-(mean|std)\\(\\)", features$V2)
data <- merged_data[, mean_std_cols]

# 3. Use descriptive activity names
activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt")
train_activities <- read.table("UCI HAR Dataset/train/y_train.txt")
test_activities <- read.table("UCI HAR Dataset/test/y_test.txt")
activities <- rbind(train_activities, test_activities)
activities <- activity_labels$V2[activities$V1]  # Assign descriptive names

# 4. Create the subjects vector for the merged dataset
train_subjects <- read.table("UCI HAR Dataset/train/subject_train.txt")
test_subjects <- read.table("UCI HAR Dataset/test/subject_test.txt")
subjects <- rbind(train_subjects, test_subjects)$V1

# 5. Label data set with descriptive variable names
names(data) <- make.names(features$V2[mean_std_cols])
data <- cbind(subjects, activity = activities, data)  # Combine subjects and activities with the data

# 6. Create tidy data set with averages
library(dplyr)
tidy_data <- data %>%
  group_by(subjects, activity) %>%
  summarize(across(everything(), ~ mean(.x, na.rm = TRUE)))

# 7. Write the tidy data to a text file
write.table(tidy_data, "C:\\Users\\TRISH\\OneDrive - BonGuides\\Desktop\\Coursera_Project\\Tidy\\tidy_data.txt", row.names = FALSE)
