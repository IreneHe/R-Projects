rm(list=ls(all=TRUE))

# load the test data
subject_test = read.table("UCI HAR Dataset/test/subject_test.txt")
X_test = read.table("UCI HAR Dataset/test/X_test.txt")
Y_test = read.table("UCI HAR Dataset/test/Y_test.txt")

# load the training data
subject_train = read.table("UCI HAR Dataset/train/subject_train.txt")
X_train = read.table("UCI HAR Dataset/train/X_train.txt")
Y_train = read.table("UCI HAR Dataset/train/Y_train.txt")

# load the label info
features <- read.table("UCI HAR Dataset/features.txt", col.names=c("featureId", "featureLabel"))
activities <- read.table("UCI HAR Dataset/activity_labels.txt", col.names=c("activityId", "activityLabel"))
activities$activityLabel <- gsub("_", "", as.character(activities$activityLabel))
includedFeatures <- grep("-mean\\(\\)|-std\\(\\)", features$featureLabel)

# Merges the training and the test sets to create one data set.
subject <- rbind(subject_test, subject_train)
names(subject) <- "subjectId"
X <- rbind(X_test, X_train)
X <- X[, includedFeatures]
names(X) <- gsub("\\(|\\)", "", features$featureLabel[includedFeatures])
Y <- rbind(Y_test, Y_train)
names(Y) = "activityId"
activity <- merge(Y, activities, by="activityId")$activityLabel


data <- cbind(subject, X, activity)
write.table(data, "merged_tidy_data.txt")

# Extracts only the measurements on the mean and standard deviation for each measurement.
library(data.table)
dataDT <- data.table(data)
calculatedData<- dataDT[, lapply(.SD, mean), by=c("subjectId", "activity")]
write.table(calculatedData, "calculated_tidy_data.txt")
