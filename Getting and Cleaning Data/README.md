# Getting And Cleaning Data - Course Project

## Introduction

This repo contains my course project to [Coursera](https://www.coursera.org) ["Getting And Cleaning Data"](https://class.coursera.org/getdata-002) course that is part of [Data Science](https://www.coursera.org/specialization/jhudatascience/1?utm_medium=listingPage) specialization.

There is just one script called `run_analysis.R`. It contains all code to do the following:

1. Download UCI HAR zip file to `data` dir
2. Read and merge data
3. Do some transformations
4. Write output data to a CSV file inside `data/output` dir

The `CodeBook.md` explains it more detailed.


## Run from command line

1. Clone this repo
2. Run the script:

       $ Rscript run_analysis.R

3. Look for the final dataset at `data/output/TidyData.txt`
