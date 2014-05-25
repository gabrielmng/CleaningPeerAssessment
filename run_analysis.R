
#Merges the training and the test sets to create one data set.
#Extracts only the measurements on the mean and standard deviation for each measurement. 
#Uses descriptive activity names to name the activities in the data set
#Appropriately labels the data set with descriptive activity names. 
#Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 
#
# The pasta indicates the path where the data files can be found.
# The sarquivo indicates the file name suffix to be used to create the complete file name.
#
#

#Choose the UCI HAR Dataset directory
# setwd(choose.dir())
setwd("C:/Users/Helga/Documents/gabriel/cursos/UCI HAR Dataset")
readData <- function(sarquivo, pasta) {
  fpath <- file.path(pasta, paste0("y_", sarquivo, ".txt"))
  y_data <- read.table(fpath, header=F, col.names=c("ActivityID"))
  
  fpath <- file.path(pasta, paste0("subject_", sarquivo, ".txt"))
  subject_data <- read.table(fpath, header=F, col.names=c("SubjectID"))
  
  # read the column's names
  colunas <- read.table("features.txt", header=F, as.is=T, col.names=c("MeasureID", "MeasureName"))
  
  # read the X data file
  fpath <- file.path(pasta, paste0("X_", sarquivo, ".txt"))
  data <- read.table(fpath, header=F, col.names=colunas$MeasureName)
  
  subset_colunas <- grep(".*mean\\(\\)|.*std\\(\\)", colunas$MeasureName)
  data <- data[,subset_colunas]
  data$ActivityID <- y_data$ActivityID
  data$SubjectID <- subject_data$SubjectID
    
  data
}

lerteste <- function() {
  readData("test", "test")
}

lertreino <- function() {
  readData("train", "train")
}

# Merge data sets
mergeData <- function() {
  data <- rbind(lerteste(), lertreino())
  cnames <- colnames(data)
  cnames <- gsub("\\.+mean\\.+", cnames, replacement="Mean")
  cnames <- gsub("\\.+std\\.+", cnames, replacement="Std")
  colnames(data) <- cnames
  data
}

applyActivityLabel <- function(data) {
  activity_labels <- read.table("activity_labels.txt", header=F, as.is=T, col.names=c("ActivityID", "ActivityName"))
  activity_labels$ActivityName <- as.factor(activity_labels$ActivityName)
  data_labeled <- merge(data, activity_labels)
  data_labeled
}

getMergedLabeledData <- function() {
  applyActivityLabel(mergeData())
}


getTidyData <- function(merged_labeled_data) {
  library(reshape2)
  

  id_vars = c("ActivityID", "ActivityName", "SubjectID")
  measure_vars = setdiff(colnames(merged_labeled_data), id_vars)
  melted_data <- melt(merged_labeled_data, id=id_vars, measure.vars=measure_vars)
  

  dcast(melted_data, ActivityName + SubjectID ~ variable, mean)
}


createTidyDataFile <- function(arquivo) {
  tidy_data <- getTidyData(getMergedLabeledData())
  write.table(tidy_data, arquivo)
}

createTidyDataFile("tidy.txt")
