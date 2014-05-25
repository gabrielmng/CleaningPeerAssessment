# Original data:

- [source](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip) 
- [description](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones)


## run_analysis.R

1. For each of the training and test datasets, 
    a. Read the `X` values
    b. Take a subset of the columns representing only the mean and standard deviation values and associate additional columns to represent activity IDs and subject IDs read from `y_<dataset>.txt` and `subject_<dataset>.txt` files respectively.
    c. Assign column names by manipulating the measurement names in `features.txt` to remove spaces and convert them to camel case.
2. Merge the datasets.
3. Associate an additional column with descriptive activity names.
4. Re cast the melted dataset with activity name and subject id as the only IDs and `mean` as the aggregator function.
5. Save the result as `tidy.txt`

