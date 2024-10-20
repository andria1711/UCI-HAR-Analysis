# Read the data files
X_train <- read.table("UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt")
X_test <- read.table("UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt")
features <- read.table("UCI HAR Dataset/features.txt")
activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt")

# Merge the training and test sets to create one data set
X <- rbind(X_train, X_test)
y <- rbind(y_train, y_test)
subject <- rbind(subject_train, subject_test)


# Set the column names for X
colnames(X) <- features$V2

# Extract only the measurements on the mean and standard deviation
mean_std_indices <- grep("mean\\(\\)|std\\(\\)", features$V2)
X <- X[, mean_std_indices]


# Set the column names for y
colnames(y) <- "activity"
y$activity <- factor(y$activity, levels = activity_labels$V1, labels = activity_labels$V2)

# Set the column name for subject
colnames(subject) <- "subject"

# Combine all data into one data frame
data <- cbind(subject, y, X)


# Create a second, independent tidy data set with the average of each variable
tidy_data <- data %>%
  group_by(subject, activity) %>%
  summarise_all(mean)

# Write the tidy data set to a file
write.table(tidy_data, "tidy_data.txt", row.names = FALSE)

tidy_data <- read.table("tidy_data.txt", header = TRUE)  # Read the tidy data file
print(head(tidy_data))  # Print the first few rows of the tidy dataset
