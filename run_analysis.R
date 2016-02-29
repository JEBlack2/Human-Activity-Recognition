##
## Getting and Cleaning Data: Week 04: Course Project
## setwd("C:/JEB/educat/2015.DataScience/2016.02.GettingAndCleaningData/2016.02.GettingAndCleaningData.Week04")
##
## Assignment: 
##     Given the project data provided at: 
##     https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 
## 
## Create one R script called run_analysis.R that does the following.
##
## 1) Merges the training and the test sets to create one data set.
## 2) Extracts only the measurements on the mean and standard deviation for each measurement.
## 3) Uses descriptive activity names to name the activities in the data set
## 4) Appropriately labels the data set with descriptive variable names. 
## 5) and from he data set in step 4, 
##    create a second, independent tidy data set with the average of each variable 
##    for each activity and each subject.
##
## Given: 
##     The referenced zip file has been downloaded and unziped into a subdirectory "/UCI HAR Dataset/"
##     This can be accomplished outside of the "R" environment using common systems utility programs.
##

library(dplyr)
library(tidyr)

# Set the path for the working directory and data directory

setwd("C:/JEB/educat/2015.DataScience/2016.02.GettingAndCleaningData/2016.02.GettingAndCleaningData.Week04/")
dpath <- file.path(getwd(), "UCI HAR Dataset")

# Read the selected files and build tables
# Read the metadata listing the labels for activities and features

activity_labels <- read.table(file.path(dpath, "activity_labels.txt"), stringsAsFactors = FALSE)
feature_names <- read.table(file.path(dpath, "features.txt"), stringsAsFactors = FALSE)

# Read the Activity files:

y_test <- read.table(file.path(dpath,"test","y_test.txt"))
y_train <- read.table(file.path(dpath,"train","y_train.txt"))

# Read the Feature files:

X_test <- read.table(file.path(dpath,"test","X_test.txt"))
X_train <- read.table(file.path(dpath,"train","X_train.txt"))

# Read the Subject files:

subject_test <- read.table(file.path(dpath,"test","subject_test.txt"))
subject_train <- read.table(file.path(dpath,"train","subject_train.txt"))

# Merge the training and the test sets to create one data set.

# Concatenate the data tables by rows.
# Upon examination, we found the data tables to be uniform and mergeable.
# The order should not matter, so long as we are consistent.
# For this assignment, we'll go alphabetical; "test" and then "train."

activities <- rbind(y_test, y_train) 
features <- rbind(X_test, X_train)
subjects <- rbind(subject_test, subject_train)

# Now we have three tables:
# activities: (10299 x 1) (10299 observations of 1 varable)
# subjects: (10299 x 1)
# features: (10299 x 56)

# Use descriptive activity names to name the activities in the data set
# Next, give the variables better names:

names(activities) <- c("activity")
names(subjects) <- c("subject")
names(features) <- feature_names[[2]]

# Merge the table columns
# The next step is to combine them into a single "human activity" table (10299 x 58):

hadata <- cbind(activities, subjects, features)

# Extract the measurements on the mean and standard deviation for each measurement
# I understand this to subset the combined human activity table (hadata),
# such that only the columns involving a mean or a standard deviation remain for each observation.
# Of course the "activity" and "subject" column must remain, but many of the others may be elided.
# Get the names of all the features that have anything to do with means or standard deviations.

selectedFeatures <- feature_names$V2[grep("[Mm][Ee][Aa][Nn]|[Ss][Tt][Dd]",feature_names$V2)]

# Make a list of all the columns we want to keep in our data.

selectedColumns <-c("activity", "subject", as.character(selectedFeatures))

# Subset the human activity data according to the selected columns list.

hadata <-subset(hadata, select=selectedColumns)

# Now we're down to a human activity table that's only 10299 x 88.

# Appropriately label the data set with descriptive variable names.

# The merged human activity data set (hadata) currently contains rather cryptic abbreviated variable names (column headings).
# After a visual inspection of the data (head(hadata)), the following transformations were elected:
# 
#    * leading "t" => "time"
#    * leading "f" => "frequency"
#    * "Acc" => "Accelerometer"
#    * "BodyBody" => "Body"
#    * "Freq()" => "Frequency()"
#    * "Gyro" => "Gyroscope"
#    * "Mag" => "Magnitude"
#    * "()" => ""
#    * "-mean" => "_mean" # at eol
#    * "-mean-" => "_mean_"
#    * "-std" => "_stdv"  # at eol
#    * "-std-" => "_stdv_"

# Thus: 

names(hadata)<-gsub("^t", "time", names(hadata))
names(hadata)<-gsub("\\(t", "(time", names(hadata))
names(hadata)<-gsub("^f", "frequency", names(hadata))
names(hadata)<-gsub("\\(f", "(frequency", names(hadata))
 
names(hadata)<-gsub("Acc", "Accelerometer", names(hadata))
names(hadata)<-gsub("BodyBody", "Body", names(hadata))
names(hadata)<-gsub("Freq\\(\\)", "Frequency()", names(hadata))
names(hadata)<-gsub("Gyro", "Gyroscope", names(hadata))
names(hadata)<-gsub("Mag", "Magnitude", names(hadata))
 
names(hadata)<-gsub("\\(\\)", "", names(hadata))
names(hadata)<-gsub("-mean$", "_mean", names(hadata))
names(hadata)<-gsub("-mean-", "_mean_", names(hadata))
names(hadata)<-gsub("-std$", "_stdv", names(hadata))
names(hadata)<-gsub("-std-", "_stdv_", names(hadata))

# Create a second, independent tidy data set with the average of each variable for each activity and each subject.

hadata2<-aggregate(. ~activity + subject, hadata, mean)
hadata2<-hadata2[order(hadata2$activity,hadata2$subject),]
write.table(hadata2, file = "tidydataset.txt",row.name=FALSE, sep="\t")

