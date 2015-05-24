Getting and Cleaning Data (Coursera). Course Project Codebook
==============================================================
This document describes the code inside `run_analysis.R`.

## Original Data

There original data comes from the smartphone accelerometer and gyroscope 3-axial raw signals, 
which have been processed using various signal processing techniques to measurement vector consisting
of 561 features. For detailed description of the original dataset, please see `features_info.txt` in
the zipped dataset file.

[Zip data](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip)
[Description](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones)

## Conventions followed

Processing code and dataset variable naming follows the conventions described in 
[Google R Styde Guide](http://google-styleguide.googlecode.com/svn/trunk/Rguide.xml).

## Data sets

### Raw data set
Initial raw data set was created by filtering out using this regular expression `mean\\(\\)|std\\(\\)` which 
corresponds to all the mean and standard deviation from the original feature vector set.

This regular expression selects 66 features from the original data set.
Combined with subject identifiers `subject` and activity labels `id`, this makes up the
68 variables of the processed raw data set.

The training and test subsets of the original dataset were combined to produce final raw dataset.

### Tidy data set
Tidy data set contains the average of all feature standard deviation and mean values of the raw dataset. 
Original variable names were modified in the follonwing way:

1. Replaced `std()` with `SD`
2. Replaced `mean()` with `MEAN`
3. Replaced `^t` with `time`
4. Replaced `^f` with `frequency`
5. Replaced `Acc` with `Accelerometer`
6. Replaced `Gyro` with `Gyroscope`
7. Replaced `Mag` with `Magnitude`
8. Replaced `BodyBody` with `Body`

Tidy data set contains a set of 69 variables, which are the 68 variables extracted earlier plus the activity name.

#### Sample of renamed variables compared to original variable name

 Raw data            | Tidy data 
 --------------------|--------------
 `subject`           | `subject`
 `actName`           | `actName`
 `actId`             | `actId`
 `tBodyAcc-mean()-Y` | `timeBodyAccelerometer-MEAN()-Y`
 `tBodyAcc-mean()-Z` | `timeBodyAccelerometer-MEAN()-Z`
 `tBodyAcc-std()-X`  | `timeBodyAccelerometer-SD()-X`
 `tBodyAcc-std()-Y`  | `timeBodyAccelerometer-SD()-Y`
 `tBodyAcc-std()-Z`  | `timeBodyAccelerometer-SD()-Z`
 
 ## Downloading and loading data

* Downloads the UCI HAR zip file if it doesn't exist
* Reads the activity labels to `activity_labels`
* Reads the column names of data (a.k.a. features) to `features`
* Reads the test `data.frame` to `all_y`
* Reads the trainning `data.frame` to `all_x`

 ## Manipulating data
 
* Merges test data and trainning data to `dataset`
* Identifies the mean and std columns (plus Activity and Subject) to `datasetOnlyMeans`
* Extracts a new `data.frame` (called `dataTable`) with only those columns from `datasetOnlyMeans`.
* Added activity name to `dataTable` data.frame.
* Calculate the mean for each variable by subject and activity and it is stored in `dataTable` data.frame replacing its initial content.
* Sort the `dataTable` data.frame by subject and activity name.

 ## Writing final data to TidyData.txt
