run_analysis <- function() 
{
    # Checks if packages are installed, if not, installs and loads them
    if (!require("data.table"))
        install.packages("data.table")
    
    if (!require("reshape2"))
        install.packages("reshape2")
    require("data.table")
    require("reshape2")
    
    # Checks if the data has been downloaded already
    # If not, downloads and unzips the data
    file <- "GettingCleaningDataProject.zip"
    if (!file.exists(file))
        download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", destfile = file)
    if(!file.exists("UCI HAR Dataset"))
        unzip(file)
    
    # To be used when downloading individual data sets
    main_dir <- file.path(getwd(), "UCI HAR Dataset")
    
    # reads in the activity names and the feature names
    activity_names <- read.table(file.path(main_dir, "activity_labels.txt"), stringsAsFactors = FALSE)[,2]
    features <- read.table(file.path(main_dir, "features.txt"), stringsAsFactors = FALSE)[ ,2]
    
    # Finds the column numbers with mean and std labels
    mean_std_cols <- grep(".*mean.*|.*std.*", features)
    
    # Grabs the names of these columns
    mean_std_cols_names <- features[mean_std_cols]
    mean_std_cols_names <- gsub("mean", "Mean", mean_std_cols_names)
    mean_std_cols_names <- gsub("std", "Std", mean_std_cols_names)
    mean_std_cols_names <- gsub("[-()]","",mean_std_cols_names)
    
    # Creates paths to the train and test folders of data
    train_dir <- file.path(getwd(), "UCI HAR Dataset", "train")
    test_dir <- file.path(getwd(), "UCI HAR Dataset", "test")
    
    # First, creates the training data table
    train_sub <- read.table(file.path(train_dir, "subject_train.txt"))
    train_y <- read.table(file.path(train_dir, "y_train.txt"))
    train_y[,2] <- activity_names[train_y[,1]] # replaces the numbers with the correct activity names
    train_y <- train_y[, 2, drop = FALSE]
    train_x <- read.table(file.path(train_dir, "X_train.txt"))[, mean_std_cols]
    train_data <- cbind(train_sub, train_y, train_x)
    
    test_sub <- read.table(file.path(test_dir, "subject_test.txt"))
    test_y <- read.table(file.path(test_dir, "y_test.txt"))
    test_y[,2] <- activity_names[test_y[,1]]
    test_y <- test_y[, 2, drop = FALSE]
    test_x <- read.table(file.path(test_dir, "X_test.txt"))[, mean_std_cols]
    test_data <- cbind(test_sub, test_y, test_x)
    
    combined <- rbind(train_data, test_data)
    names(combined) <- c("subject_id", "activity", mean_std_cols_names) # names the columns
    
    # Makes factors of the variables to wrap up the summary table
    combined$subject_id <- factor(combined$subject_id)
    combined$activity <- factor(combined$activity)
    
    melted <- melt(combined, id = c("subject_id", "activity"))
    summary <- dcast(melted, subject_id + activity ~ variable, mean)
    
    write.table(summary, file = "tidy_data.txt", row.name = FALSE)
}
