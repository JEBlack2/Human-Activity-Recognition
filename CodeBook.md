
# CodeBook.md 

 * Assignment: Getting and Cleaning Data Course; Week 04 Project

## Purpose:

 * To demonstrate ability to collect, work with, and clean a data set.

## Review criteria:

   * The submitted data set is tidy.
   * The Github repo contains the required scripts.
   *  GitHub contains a code book that modifies and updates the available codebooks with the data to indicate all the variables and summaries calculated, along with units, and any other relevant information.
   * The README that explains the analysis files is clear and understandable.
   * The work submitted for this project is the work of the student who submitted it.

## Data Source:

One of the most exciting areas in all of data science right now is wearable computing.
   * Reference article at: http://www.insideactivitytracking.com/data-science-activity-tracking-and-the-battle-for-the-worlds-top-sports-brand

Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms to attract new users. 
The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone. 
A full description is available at the site where the data was originally obtained:
   * http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

The instructors have provided a compressed file containing the data for the project:
   * https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 


## Assignment: 

Create one R script called run_analysis.R that does the following:

   1. Merges the training and the test sets to create one data set.
   2. Extracts only the measurements on the mean and standard deviation for each measurement.
   3. Uses descriptive activity names to name the activities in the data set
   4. Appropriately labels the data set with descriptive variable names.
   5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.


## Prerequisites:

   * The data package has been downloaded and expanded into a local subdirectory named: "/UCI HAR Dataset"


## Explore the dataset:

   * >dpath <- file.path(getwd(), "UCI HAR Dataset")
   * > dpath
   * > [1] "C:/JEB/educat/2015.DataScience/2016.02.GettingAndCleaningData/2016.02.GettingAndCleaningData.Week04/UCI HAR Dataset"

### First Level:

   * > list.files(dpath)
   * > [1] "activity_labels.txt" "features.txt"        "features_info.txt"   "README.txt"         
   * > [5] "test"                "train"              

"test" and "train" are subdirectories containing the data under consideration.

From the "README.txt" file, we learn:
   * 'activity_labels.txt': Links the class labels with their activity name.
   * 'features.txt': List of all features.
   * 'features_info.txt': Shows information about the variables used on the feature vector.

#### "activity_labels.txt" 

   * Links the class labels with their activity name.

From the "README" file, we know that the experiments have been carried out with a group of 30 volunteers, 
each performing six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING).
These are the "activities."

   * >activity_labels <- read.table(file.path(dpath, "activity_labels.txt", stringsAsFactors = FALSE)

   * > str(activity_labels)
   * 'data.frame':	6 obs. of  2 variables:
   *  $ V1: int  1 2 3 4 5 6
   *  $ V2: chr  "WALKING" "WALKING_UPSTAIRS" "WALKING_DOWNSTAIRS" "SITTING" ...

It's small, let's look at the entire thing.

   * > activity_labels
   *   V1                 V2
   * 1  1            WALKING
   * 2  2   WALKING_UPSTAIRS
   * 3  3 WALKING_DOWNSTAIRS
   * 4  4            SITTING
   * 5  5           STANDING
   * 6  6             LAYING

And from the "tidy" rules, we know that all uppercase and underscores are undesireable, but we'll get that later.


#### "features.txt"

   * List of all features. Let's examine them.

   * features <- read.table(file.path(dpath, "features.txt"), stringsAsFactors = FALSE)

   * > str(features)
   * 'data.frame':	561 obs. of  2 variables:
   *  $ V1: int  1 2 3 4 5 6 7 8 9 10 ...
   *  $ V2: chr  "tBodyAcc-mean()-X" "tBodyAcc-mean()-Y" "tBodyAcc-mean()-Z" "tBodyAcc-std()-X" ...

Too many to list them all here; since we're only interested in means and standard deviations, 
we can sample "features.txt" for those and get something a bit more manageable.

   * fmeans <- grep("[Mm][Ee][Aa][Nn]", unique(features[,2]), value=TRUE)

   * > str(fmeans)
   *  chr [1:53] "tBodyAcc-mean()-X" "tBodyAcc-mean()-Y" "tBodyAcc-mean()-Z" ...

   * > head(fmeans, n=12)
   *  [1] "tBodyAcc-mean()-X"     "tBodyAcc-mean()-Y"     "tBodyAcc-mean()-Z"     "tGravityAcc-mean()-X" 
   *  [5] "tGravityAcc-mean()-Y"  "tGravityAcc-mean()-Z"  "tBodyAccJerk-mean()-X" "tBodyAccJerk-mean()-Y"
   *  [9] "tBodyAccJerk-mean()-Z" "tBodyGyro-mean()-X"    "tBodyGyro-mean()-Y"    "tBodyGyro-mean()-Z"   

   * > fstds <- grep("[Ss][Tt][Dd]", unique(features[,2]), value=TRUE)
   * > str(fstds)
   *  chr [1:33] "tBodyAcc-std()-X" "tBodyAcc-std()-Y" "tBodyAcc-std()-Z" ...

   * > head(fstds, n=12)
   *  [1] "tBodyAcc-std()-X"     "tBodyAcc-std()-Y"     "tBodyAcc-std()-Z"     "tGravityAcc-std()-X" 
   *  [5] "tGravityAcc-std()-Y"  "tGravityAcc-std()-Z"  "tBodyAccJerk-std()-X" "tBodyAccJerk-std()-Y"
   *  [9] "tBodyAccJerk-std()-Z" "tBodyGyro-std()-X"    "tBodyGyro-std()-Y"    "tBodyGyro-std()-Z"   

#### "features_info.txt"

   * Shows information about the variables used on the feature vector.

From the "README" file, we know that using an embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz, and that the obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data. 

The "features_info.txt" file contains additional details about the features, including:

   * The features selected for this database come from the accelerometer and gyroscope 3-axial raw signals tAcc-XYZ and tGyro-XYZ. 

   * Time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz. 
   * They were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. 

   * Similarly, the acceleration signal was separated into body and gravity acceleration signals (tBodyAcc-XYZ and tGravityAcc-XYZ) using another low pass Butterworth filter with a corner frequency of 0.3 Hz.

   * Subsequently, the body linear acceleration and angular velocity were derived in time to obtain Jerk signals (tBodyAccJerk-XYZ and tBodyGyroJerk-XYZ). Also the magnitude of these three-dimensional signals were calculated using the Euclidean norm (tBodyAccMag, tGravityAccMag, tBodyAccJerkMag, tBodyGyroMag, tBodyGyroJerkMag). 
   * Finally a Fast Fourier Transform (FFT) was applied to some of these signals producing fBodyAcc-XYZ, fBodyAccJerk-XYZ, fBodyGyro-XYZ, fBodyAccJerkMag, fBodyGyroMag, fBodyGyroJerkMag. (Note the 'f' to indicate frequency domain signals). 


These signals were used to estimate variables of the feature vector for each pattern:  
'-XYZ' is used to denote 3-axial signals in the X, Y and Z directions.

   * tBodyAcc-XYZ
   * tGravityAcc-XYZ
   * tBodyAccJerk-XYZ
   * tBodyGyro-XYZ
   * tBodyGyroJerk-XYZ
   * tBodyAccMag
   * tGravityAccMag
   * tBodyAccJerkMag
   * tBodyGyroMag
   * tBodyGyroJerkMag
   * fBodyAcc-XYZ
   * fBodyAccJerk-XYZ
   * fBodyGyro-XYZ
   * fBodyAccMag
   * fBodyAccJerkMag
   * fBodyGyroMag
   * fBodyGyroJerkMag

The set of variables that were estimated from these signals are: 

   * mean(): Mean value
   * std(): Standard deviation
   * mad(): Median absolute deviation 
   * max(): Largest value in array
   * min(): Smallest value in array
   * sma(): Signal magnitude area
   * energy(): Energy measure. Sum of the squares divided by the number of values. 
   * iqr(): Interquartile range 
   * entropy(): Signal entropy
   * arCoeff(): Autorregresion coefficients with Burg order equal to 4
   * correlation(): correlation coefficient between two signals
   * maxInds(): index of the frequency component with largest magnitude
   * meanFreq(): Weighted average of the frequency components to obtain a mean frequency
   * skewness(): skewness of the frequency domain signal 
   * kurtosis(): kurtosis of the frequency domain signal 
   * bandsEnergy(): Energy of a frequency interval within the 64 bins of the FFT of each window.
   * angle(): Angle between to vectors.

Additional vectors obtained by averaging the signals in a signal window sample. These are used on the angle() variable:

   * gravityMean
   * tBodyAccMean
   * tBodyAccJerkMean
   * tBodyGyroMean
   * tBodyGyroJerkMean

The complete list of variables of each feature vector is available in the 'features.txt' file previously examined.

### Second Level:

We already know that "test" and "train" are subdirectories containing the data under consideration.
Let's examine those subdirectories.  First the testing subdirectory:

   * > list.files(file.path(dpath,"test"))
   * [1] "Inertial Signals" "subject_test.txt" "X_test.txt"       "y_test.txt"  

Similarly, in the training subdirectory: 

   * > list.files(file.path(dpath,"train"))
   * [1] "Inertial Signals"  "subject_train.txt" "X_train.txt"       "y_train.txt"      


"Interial Signals," present at both levels is another subdirectory containing a large amount of raw test and training sample data respectively.
Since the "Inertial Signals" directories contain raw sensor data, and we are interested in the aggregated means and standard deviations,
we will not be working with those files at this time.

Let's examine the other files.

#### "test/subject_test.txt" 

   * > subject_test <- read.table(file.path(dpath,"test","subject_test.txt"))

   * > str(subject_test)
   * 'data.frame':	2947 obs. of  1 variable:
   *  $ V1: int  2 2 2 2 2 2 2 2 2 2 ...

That's not very interesting; let's see what's really there.

   * > unique(subject_test[[1]])
   * [1]  2  4  9 10 12 13 18 20 24

Let's check the other files.

#### "test/X_test.txt" 

   * The test data.

   * > X_test <- read.table(file.path(dpath,"test","X_test.txt"))
   
   * > str(X_test)
   * 'data.frame':	2947 obs. of  561 variables:
   *  $ V1  : num  0.257 0.286 0.275 0.27 0.275 ...
   *  $ V2  : num  -0.0233 -0.0132 -0.0261 -0.0326 -0.0278 ...
   *  $ V3  : num  -0.0147 -0.1191 -0.1182 -0.1175 -0.1295 ...
   *  $ V4  : num  -0.938 -0.975 -0.994 -0.995 -0.994 ...
   *  $ V5  : num  -0.92 -0.967 -0.97 -0.973 -0.967 ...
   *  $ V6  : num  -0.668 -0.945 -0.963 -0.967 -0.978 ...
   *  $ V7  : num  -0.953 -0.987 -0.994 -0.995 -0.994 ...
   *  $ V8  : num  -0.925 -0.968 -0.971 -0.974 -0.966 ...
   *  $ V9  : num  -0.674 -0.946 -0.963 -0.969 -0.977 ...
   *  $ V10 : num  -0.894 -0.894 -0.939 -0.939 -0.939 ...
   *  ...
   *  [list output truncated]

A bit too long and too wide to list here; but we know it's all numeric data.


#### "test/y_test.txt" 

   * The test labels.

   * > y_test <- read.table(file.path(dpath,"test","y_test.txt"))

   * > str(y_test)
   * 'data.frame':	2947 obs. of  1 variable:
   *  $ V1: int  5 5 5 5 5 5 5 5 5 5 ...

Again; not terribly interesting.  Let's take a closer look.

   * > unique(y_test[[1]])
   * [1] 5 4 6 1 3 2

It contains a list of the identifiers that line up with the observations in the "X_test" data file.


#### "train/subject_test.txt"

   * > subject_train <- read.table(file.path(dpath,"train","subject_train.txt"))

   * > str(subject_train)
   * 'data.frame':	7352 obs. of  1 variable:
   *  $ V1: int  1 1 1 1 1 1 1 1 1 1 ...


Again; not very interesting; take a closer look.

   * > unique(subject_train[[1]])
   * [1]  1  3  5  6  7  8 11 14 15 16 17 19 21 22 23 25 26 27 28 29 30

Now that's a bit more interesting. Especially when we recall that 
that "unique(subject_test)" was: "[1]  2  4  9 10 12 13 18 20 24" ...
It would appear that the two data sets would merge nicely without complications.
Let's check the other data.


#### "train/X_train.txt" 

   * The training data.

   * > X_train <- read.table(file.path(dpath,"train","X_train.txt"))

   * > str(X_train)

   * 'data.frame':	7352 obs. of  561 variables:
   *  $ V1  : num  0.289 0.278 0.28 0.279 0.277 ...
   *  $ V2  : num  -0.0203 -0.0164 -0.0195 -0.0262 -0.0166 ...
   *  $ V3  : num  -0.133 -0.124 -0.113 -0.123 -0.115 ...
   *  $ V4  : num  -0.995 -0.998 -0.995 -0.996 -0.998 ...
   *  $ V5  : num  -0.983 -0.975 -0.967 -0.983 -0.981 ...
   *  $ V6  : num  -0.914 -0.96 -0.979 -0.991 -0.99 ...
   *  $ V7  : num  -0.995 -0.999 -0.997 -0.997 -0.998 ...
   *  $ V8  : num  -0.983 -0.975 -0.964 -0.983 -0.98 ...
   *  $ V9  : num  -0.924 -0.958 -0.977 -0.989 -0.99 ...
   *  $ V10 : num  -0.935 -0.943 -0.939 -0.939 -0.942 ...
   *  $ V11 : num  -0.567 -0.558 -0.558 -0.576 -0.569 ...
   *  $ V12 : num  -0.744 -0.818 -0.818 -0.83 -0.825 ...
   *  ...
   *  [list output truncated]

Wow! This one is larger at 7352 observations as compared to 2947 in the "test" data.
However, both data sets have 561 variables, so they match up nicely and will merge nicely.

Again; too long and too wide to list here; but we know it's all numeric data.

So let's check out the traning labels file.

#### "train/y_train.txt" 

   * The training labels.

   * > y_train <- read.table(file.path(dpath,"train","y_train.txt"))

   * > str(y_train)

   * 'data.frame':	7352 obs. of  1 variable:
   *  $ V1: int  5 5 5 5 5 5 5 5 5 5 ...

Another uninteresting list of integers, albeit larger then the similar test data. 
Let's check to see how it compares with the test data.

   * > unique(y_train[[1]])
   * [1] 5 4 6 1 3 2

It contains a list of the identifiers that line up with the observations in the "X_train" data file.
And note that it matches nicely with "unique(y_test[[1]])" which was "[1] 5 4 6 1 3 2" ...

So far, everything looks like the "test" and the "training" data sets are uniform and suitable for merging.


## Perform the Assignment: Create "run_analysis.R"

### Obtain the Data

A prerequisite to the analysis was that the data were already downloaded and uncompressed into a local subdirectory named: "/UCI HAR Dataset."
This can be accomplished outside of the "R" environment using common systems utility programs.

### Load the "R" packages used.

   * library(dplyr)
   * library(tidyr)

### Set the working directory:

This works for me; your mileage may vary.

   * > setwd("C:/JEB/educat/2015.DataScience/2016.02.GettingAndCleaningData/2016.02.GettingAndCleaningData.Week04/")

And set the path for the data directory:

   * > dpath <- file.path(getwd(), "UCI HAR Dataset")


### Read the selected files and build tables

#### Read the metadata listing the labels for activities and features

   * > activity_labels <- read.table(file.path(dpath, "activity_labels.txt"), stringsAsFactors = FALSE)
   * > feature_names <- read.table(file.path(dpath, "features.txt"), stringsAsFactors = FALSE)

#### Read the Activity files:

   * > y_test <- read.table(file.path(dpath,"test","y_test.txt"))
   * > y_train <- read.table(file.path(dpath,"train","y_train.txt"))

#### Read the Feature files:

   * > X_test <- read.table(file.path(dpath,"test","X_test.txt"))
   * > X_train <- read.table(file.path(dpath,"train","X_train.txt"))

#### Read the Subject files:

   * > subject_test <- read.table(file.path(dpath,"test","subject_test.txt"))
   * > subject_train <- read.table(file.path(dpath,"train","subject_train.txt"))

### Merge the training and the test sets to create one data set.

#### Concatenate the data tables by rows.

Upon examination, we found the data tables to be uniform and mergeable.

The order should not matter, so long as we are consistent.
For this assignment, we'll go alphabetical; "test" and then "train."

   * > activities <- rbind(y_test, y_train) 
   * > features <- rbind(X_test, X_train)
   * > subjects <- rbind(subject_test, subject_train)

Now we have three tables:

   * activities: (10299 x 1) (10299 observations of 1 varable)
   * subjects: (10299 x 1)
   * features: (10299 x 56)

#### Use descriptive activity names to name the activities in the data set

Next, give the variables better names:

   * > names(activities) <- c("activity")
   * > names(subjects) <- c("subject")
   * > names(features) <- feature_names[[2]]

#### Merge the table columns

The next step is to combine them into a single "human activity" table (10299 x 58):

   * hadata <- cbind(activities, subjects, features)


### Extract the measurements on the mean and standard deviation for each measurement

I understand this to subset the combined human activity table (hadata),
such that only the columns involving a mean or a standard deviation remain for each observation.
Of course the "activity" and "subject" column must remain, but many of the others may be elided.

Get the names of all the features that have anything to do with means or standard deviations.

   * > selectedFeatures <- feature_names$V2[grep("[Mm][Ee][Aa][Nn]|[Ss][Tt][Dd]",feature_names$V2)]

Make a list of all the columns we want to keep in our data.

   * > selectedColumns <-c("activity", "subject", as.character(selectedFeatures))

Subset the human activity data according to the selected columns list.

  * > hadata <-subset(hadata, select=selectedColumns)

Now we're down to a human activity table that's only 10299 x 88.

  * > str(hadata)
  * 'data.frame':	10299 obs. of  88 variables:
  *  $ activity                            : int  5 5 5 5 5 5 5 5 5 5 ...
  *  $ subject                             : int  2 2 2 2 2 2 2 2 2 2 ...
  *  $ tBodyAcc-mean()-X                   : num  0.257 0.286 0.275 0.27 0.275 ...
  *  $ tBodyAcc-mean()-Y                   : num  -0.0233 -0.0132 -0.0261 -0.0326 -0.0278 ...
  *  ...


### Appropriately label the data set with descriptive variable names.

The merged human activity data set (hadata) currently contains rather cryptic abbreviated variable names (column headings).
After a visual inspection of the data (head(hadata)), the following transformations were elected:

   * leading "t" => "time"
   * leading "f" => "frequency"
   * "Acc" => "Accelerometer"
   * "BodyBody" => "Body"
   * "Freq()" => "Frequency()"
   * "Gyro" => "Gyroscope"
   * "Mag" => "Magnitude"
   * "()" => ""
   * "-mean" => "_mean"
   * "-mean-" => "_mean_"
   * "-std" => "_stdv"
   * "-std-" => "_stdv_"

Thus: 

   * names(hadata)<-gsub("^t", "time", names(hadata))
   * names(hadata)<-gsub("\\(t", "(time", names(hadata))
   * names(hadata)<-gsub("^f", "frequency", names(hadata))
   * names(hadata)<-gsub("\\(f", "(frequency", names(hadata))

   * names(hadata)<-gsub("Acc", "Accelerometer", names(hadata))
   * names(hadata)<-gsub("BodyBody", "Body", names(hadata))
   * names(hadata)<-gsub("Freq\\(\\)", "Frequency()", names(hadata))
   * names(hadata)<-gsub("Gyro", "Gyroscope", names(hadata))
   * names(hadata)<-gsub("Mag", "Magnitude", names(hadata))

   * names(hadata)<-gsub("\\(\\)", "", names(hadata))
   * names(hadata)<-gsub("-mean$", "_mean", names(hadata))
   * names(hadata)<-gsub("-mean-", "_mean_", names(hadata))
   * names(hadata)<-gsub("-std$", "_stdv", names(hadata))
   * names(hadata)<-gsub("-std-", "_stdv_", names(hadata))


### Create a second, independent tidy data set with the average of each variable for each activity and each subject.

   * hadata2<-aggregate(. ~activity + subject, hadata, mean)
   * hadata2<-hadata2[order(hadata2$activity,hadata2$subject),]
   * write.table(hadata2, file = "tidydataset.txt",row.name=FALSE, sep="\t")





