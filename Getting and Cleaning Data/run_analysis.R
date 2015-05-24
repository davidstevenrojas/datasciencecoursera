##loading require libraries
library(dplyr)
library(data.table)
library(tidyr)

##Notify user where operations will be performed
currentWD <- getwd()

cat("INFO:  All operation will be performed in this Working Directory: ",getwd())

##make sure there is a ./data folder inside the current working directory
if(!file.exists("./data")){
        dir.create("./data")
}

zipFileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

cat("INFO: Zip dataset will be downloaded from: ",zipFileUrl)
cat("Download may take some minutes to complete...")

if(!file.exists("./data/dataset.zip")){
        download.file(zipFileUrl,destfile = "./data/dataset.zip", method = "curl")  
}


##unzip the file in ./data
unzip(zipfile = "./data/dataset.zip",exdir = "./data")

##read the features which will contain row names for x_train and y_train data
features <- tbl_df(read.table(file = "./data/UCI HAR Dataset/features.txt",header = F))
featuresName <- features$V2

setnames(features, names(features), c("featureNum", "featureName"))
##create vector based on factors from "features" data table
vector <- as.vector(featuresName)

##read content from txt sources
activity_labels <- tbl_df(read.table(file = "./data/UCI HAR Dataset/activity_labels.txt", header = F, col.names = c("actId","actName")))
x_train <- tbl_df(read.table(file = "./data/UCI HAR Dataset/train/X_train.txt",header = F))
y_train <- tbl_df(read.table(file = "./data/UCI HAR Dataset/train/y_train.txt",header = F, col.names = c("actId")))
x_test <- tbl_df(read.table(file = "./data/UCI HAR Dataset/test/X_test.txt",header = F,col.names = vector))
y_test <- tbl_df(read.table(file = "./data/UCI HAR Dataset/test/y_test.txt",header = F, col.names = c("actId")))
subject_test <- tbl_df(read.table(file = "./data/UCI HAR Dataset/test/subject_test.txt",header = F,col.names = c("subject")))
subject_train <- tbl_df(read.table(file = "./data/UCI HAR Dataset/train//subject_train.txt",header = F, col.names = c("subject")))
##start merging data
##merging train and test subjects
all_subjects <- tbl_df(rbind(subject_train,subject_test))
##merging train and test activity data (y)
all_y <- tbl_df(rbind(y_train,y_test))
##merging train and test "feature vector" data (x)
all_x <- tbl_df(rbind(x_train, x_test))
colnames(all_x) <- features$featureName
##merging all subjects with activity data (y)
subjectActivities <- tbl_df(cbind(all_subjects,all_y))
##merging subject plus activities plus "feature vector" data
dataset <- tbl_df(cbind(subjectActivities, all_x))

##extract only the values associated to mean and std, also 
##adding subject and activity for further computation

meanStdFeatures <- grep("mean\\(\\)|std\\(\\)",features$featureName,value = T)
meanStdFeatures <- union(c("subject","actId"),meanStdFeatures)
datasetOnlyMeans <- dataset[,meanStdFeatures]

##Including actvity names
dataTable <- merge(activity_labels, datasetOnlyMeans , by="actId", all.x=TRUE)
##Computing mean for each variable by subject and activity name
dataTable<- aggregate(. ~ subject - actName, data = dataTable, mean) 
##Sorting by subject and activity name
dataTable<- tbl_df(arrange(dataTable,subject,actName))

##Labeling variable names with descriptive names

cat("INFO: Labeling with descriptive names.")

names(dataTable)<-gsub("std()", "SD", names(dataTable))
names(dataTable)<-gsub("mean()", "MEAN", names(dataTable))
names(dataTable)<-gsub("^t", "time", names(dataTable))
names(dataTable)<-gsub("^f", "frequency", names(dataTable))
names(dataTable)<-gsub("Acc", "Accelerometer", names(dataTable))
names(dataTable)<-gsub("Gyro", "Gyroscope", names(dataTable))
names(dataTable)<-gsub("Mag", "Magnitude", names(dataTable))
names(dataTable)<-gsub("BodyBody", "Body", names(dataTable))

##
if(!file.exists("./data/output")){
    dir.create("./data/output")    
}
cat("INFO: creating TidyData.txt to data/output")
write.table(dataTable, "./data/output/TidyData.txt", row.name=FALSE)
cat("INFO: Process completed")
