# Human-Activity-Recognition
Getting and Cleaning Data: Week 04: Course Project

## Assignment: 
Given the project data provided at: 
  * https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

Create one R script called run_analysis.R that does the following:

 * Merges the training and the test sets to create one data set.
 * Extracts only the measurements on the mean and standard deviation for each measurement.
 * Uses descriptive activity names to name the activities in the data set
 * Appropriately labels the data set with descriptive variable names. 
 * Creates a second, independent tidy data set with the average of each variable for each activity and each subject.
 
## Given: 
 * The referenced zip file has been downloaded and unziped into a subdirectory "/UCI HAR Dataset/"
 * This can be accomplished outside of the "R" environment using common systems utility programs.

## Data:
 * CodeBook.MD - provides a detailed description of the files and processes and transformations involved.
 * run_analysis.R - an R script that performs the indicated analysis and transformations and then produces a new file "tidydataset.txt" 
 * UCI HAR Dataset - a subdirectory extracted from the source zip file referenced above, and residing on the local computer.
 * tidydataset.txt - new independent data set produced by "run_analysis.R" aggregated by activity and subject.
 
 * Note: "run_analysis.R" contains no function definitions, and must be "sourced" (source("run_analysis.R")) in order to execute the script.
 


