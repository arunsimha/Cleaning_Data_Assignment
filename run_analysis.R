## run_analysis.R program does the following:
## 1 Merge the train and the test sets to create one data set.
## 2 Extract measurements on the mean and standard deviation for each measurement.
## 3 Use activity names to name the activities in the data se
## 4 Label the data set with descriptive variable names. 
## 5 Create an independent tidy data set with the average of each variable for each activity and each subject.
## Export the final tidy data file submission
##
## To run the script simply type > run_analysis
##


library(reshape2)

dataDir <- "C:/Users/Arun/Documents/project/"
dataFileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

## Uncomment block below if downloading file from internet during evaluation
#
#if (!file.exists(dataDir)) {
#  dir.create(dataDir)
#}
#if (!file.exists(paste(dataDir, "project.zip", sep=""))) {
#  download.file(dataFileURL, destfile = paste(dataDir, "project.zip", sep=""))
#}
#if (!file.exists(paste(dataDir, "UCI HAR Dataset/", sep=""))) {
#  unzip(paste(dataDir, "project.zip", sep=""), exdir=dataDir)
#}

getFeatureLabels <- function () {
    ## the function extracts the feature labels from the "features.txt" file
    ## these values will makeup the column names of the dataset
    ## the function edits the labels to be more descriptive according to Part 4 

    feature_labs <- as.character(read.table(paste(dataDir, "UCI HAR Dataset/features.txt", sep=""),header=F)$V2)
    feature_labs <- gsub("\\(", "", feature_labs)  #get rid of leading (
    feature_labs <- gsub("\\)", "", feature_labs) #get rid of leading )
    feature_labs <- gsub("\\,", "", feature_labs) #get rid of leading ,
    feature_labs <- gsub("-", "", feature_labs) #get rid of leading -
    return (feature_labs)
}

getActivityData <- function (dir) {
    ## argument is either "train" or "test" 
    ## the function reads the specific Activty file to grab the specified actvity code
    activity <- as.factor(read.table(paste(dataDir, "UCI HAR Dataset/", dir, "/y_", dir, ".txt", sep=""), header=F)$V1)

## the function translates the code to user-friendly name in activity_labels.txt
    activity_labels <- read.table(paste(dataDir, "UCI HAR Dataset/activity_labels.txt", sep="") ,header=F)

	## these values will makeup the column 'activity' of the dataset
    activity <- sapply(activity, function(y) activity_labels[y,2])
    return (activity)
}

getSubjectData <- function(dir) {
    ## argument is either "train" or "test" 
    ## the function reads the specific Subject file to grab the specific subject of the observation
    subjects <- as.character(read.table(paste(dataDir, "UCI HAR Dataset/", dir, "/subject_", dir,".txt", sep=""), header=F)$V1)
    return(as.numeric(subjects))
}

readDataFile <- function(dir) {
    ## argument is either "train" or "test" 
    ## the function reads the file into a data.frame, dataFile
    ## This function was created to separate reading the files from constructing the data.frame
    
    dataFile <- read.table(paste(dataDir, "UCI HAR Dataset/", dir, "/X_", dir,".txt", sep=""), header=F, colClasses="numeric")
    return(dataFile)
}    

getXData <- function(dir) {
    ## argument is either "train" or "test" 
    ## This function utilizes all functions to construct the data frame
    ## it calls the readDataFile() function to grab the core data
    ## then it cbinds the subject column with getSubjectData() and activity column with getActivityData() functions
    ## finally it sets the column names to the descriptive names using getFeatureLabels()
    
    XData <- readDataFile(dir)
    XData <- cbind(getSubjectData(dir), getActivityData(dir),XData)
    return(setNames(XData, c("subject", "activity", getFeatureLabels())))
}

## Part 1, Merge the train and the test sets to create one data set.
mergedData <- rbind(getXData("test"), getXData("train"))

## Parts 2, 3, 4: Extract only the measurements on the mean and standard deviation for each measurement.
## Use descriptive activity names  in the data set
## label the data set with descriptive variable names. 
tidyData <- mergedData[,grepl("subject|activity|mean|std", names(mergedData))]

# Upload with submission
# Write out the tidyData_part4.txt
write.csv(tidyData, paste(dataDir, "tidyData_part4.txt", sep=""), row.names=F)

## Part 5, Create a second, independent tidy data set with the average of each variable for each activity and each subject.
tidyMelt <- melt(tidyData, id=c(1:2), measure.vars=c(3:81))
averageTidyData<-dcast(tidyMelt, subject + activity ~ variable, mean)

# Upload with submission
# Write out the averageTidyData_part5.txt
write.csv(averageTidyData, paste(dataDir, "averageTidyData_part5.txt", sep=""), row.names=F)