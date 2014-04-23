setwd("E:/360yunpanGmail/study/openCourse/coursera/Getting and Cleaning Data/PeerAssessments")

train_data <- read.table("./UCI HAR Dataset/train/X_train.txt",header=FALSE)
train_labels <- read.table("./UCI HAR Dataset/train/y_train.txt",header=FALSE)
train_subjects <- read.table("./UCI HAR Dataset/train/subject_train.txt",header=FALSE)
train <- cbind(train_labels,train_subjects,train_data)

dim(train_data)
dim(train)

test_data <- read.table("./UCI HAR Dataset/test/X_test.txt",header=FALSE)
test_labels <- read.table("./UCI HAR Dataset/test/y_test.txt",header=FALSE)
test_subjects <- read.table("./UCI HAR Dataset/test/subject_test.txt",header=FALSE)
test <- cbind(test_labels,test_subjects,test_data)

dim(test_data)
dim(test)

all <- rbind(train,test)
dim(all)

features <- read.table("./UCI HAR Dataset/features.txt",header=FALSE)
columns <- features[(grepl("mean\\(\\)",features$V2) | grepl("std()",features$V2)),]
columns_num <- columns[,1]+2
columns_num <- c(1,2,columns_num)
result <- all[,columns_num]

length(columns_num)
dim(result)

columns_name <- c("activity_labels","subjects",as.vector(columns[,2]))
names(result) <- columns_name

activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt",header=FALSE,stringsAsFactors=FALSE)
renamer <- function(x, pattern, replace){
        for (i in seq_along(pattern)){
                x <- gsub(pattern[i], replace[i], x)
        }               
        x
}
result$activity_labels=renamer(result$activity_labels,activity_labels[,1],activity_labels[,2])

result[1:5,1:5]

library(reshape2)
melted <- melt(result,id.vars=c("activity_labels","subjects"),na.rm = TRUE)
tidy_data <- dcast(melted, subjects + activity_labels ~ variable, mean) 

dim(tidy_data)
tidy_data[1:10,1:5]

write.table(tidy_data,file="tidy_data.txt",quote=FALSE,row.names=FALSE)



