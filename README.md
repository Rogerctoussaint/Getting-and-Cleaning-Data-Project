# Getting and Cleaning Data Project
## Course Project
You should create one R script called run_analysis.R that does the following.

1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement.
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive variable names.
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each      subject.

## Files
run_analysis.R is a R script that runs everything and produces tidy_data.txt. The script downloads all required packages and data automatically if not already installed
The codebook contains information about the variables in the data

## Dependencies
run_analysis.R uses the packages data.table and reshape2, which the script will download and load automatically.
