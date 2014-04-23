# Peer Assessments of Getting and Cleaning Data

## Set Working Directory

The dataset is under the **PeerAssessments** Directory.    


```r
setwd("E:/360yunpanGmail/study/openCourse/coursera/Getting and Cleaning Data/PeerAssessments")
```


## Read data

### Read train data

Two columns were added before the data set. The first column is the activity_labels, the second column is the subject who performed the activity. Its range is from 1 to 30. 


```r
train_data <- read.table("./UCI HAR Dataset/train/X_train.txt", header = FALSE)
train_labels <- read.table("./UCI HAR Dataset/train/y_train.txt", header = FALSE)
train_subjects <- read.table("./UCI HAR Dataset/train/subject_train.txt", header = FALSE)
train <- cbind(train_labels, train_subjects, train_data)
```


check the dimension information of train data set.   


```r
dim(train_data)
```

```
[1] 7352  561
```

```r
dim(train)
```

```
[1] 7352  563
```


### Read test data

Two columns were added before the data set. The first column is the activity_labels, the second column is the subject who performed the activity. Its range is from 1 to 30.     


```r
test_data <- read.table("./UCI HAR Dataset/test/X_test.txt", header = FALSE)
test_labels <- read.table("./UCI HAR Dataset/test/y_test.txt", header = FALSE)
test_subjects <- read.table("./UCI HAR Dataset/test/subject_test.txt", header = FALSE)
test <- cbind(test_labels, test_subjects, test_data)
```


check the dimension information of test data set. 


```r
dim(test_data)
```

```
[1] 2947  561
```

```r
dim(test)
```

```
[1] 2947  563
```


## Merges the training and the test sets to create one data set.


```r
all <- rbind(train, test)
```


check the dimension information of merged data set.


```r
dim(all)
```

```
[1] 10299   563
```


## Extracts only the measurements on the mean and standard deviation for each measurement. 

only the mean() and std() measurements were extracted.   

meanFreq() was not extracted!     


```r
features <- read.table("./UCI HAR Dataset/features.txt", header = FALSE)
columns <- features[(grepl("mean\\(\\)", features$V2) | grepl("std()", features$V2)), 
    ]
columns_num <- columns[, 1] + 2  # I have add two coluumns before the measurements
columns_num <- c(1, 2, columns_num)
result <- all[, columns_num]
```


check the information of extracted data set.   


```r
length(columns_num)
```

```
[1] 68
```

```r
dim(result)
```

```
[1] 10299    68
```


## Uses descriptive activity names to name the activities in the data set


```r
# I have add two coluumns before the measurements
columns_name <- c("activity_labels", "subjects", as.vector(columns[, 2]))
names(result) <- columns_name
```


## Appropriately labels the data set with descriptive activity names


```r
activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt", header = FALSE, 
    stringsAsFactors = FALSE)
renamer <- function(x, pattern, replace) {
    for (i in seq_along(pattern)) {
        x <- gsub(pattern[i], replace[i], x)
    }
    x
}
result$activity_labels = renamer(result$activity_labels, activity_labels[, 1], 
    activity_labels[, 2])
```


check the first five rows and columns of the results.    


```r
result[1:5, 1:5]
```

```
  activity_labels subjects tBodyAcc-mean()-X tBodyAcc-mean()-Y
1        STANDING        1            0.2886          -0.02029
2        STANDING        1            0.2784          -0.01641
3        STANDING        1            0.2797          -0.01947
4        STANDING        1            0.2792          -0.02620
5        STANDING        1            0.2766          -0.01657
  tBodyAcc-mean()-Z
1           -0.1329
2           -0.1235
3           -0.1135
4           -0.1233
5           -0.1154
```


## tidy data set with the average of each variable for each activity and each subject. 


```r
library(reshape2)
melted <- melt(result, id.vars = c("activity_labels", "subjects"), na.rm = TRUE)
tidy_data <- dcast(melted, subjects + activity_labels ~ variable, mean)
```


check the dimension information of the tidy data set.     


```r
dim(tidy_data)
```

```
[1] 180  68
```


check the first ten rows and five columns of the results.    


```r
tidy_data[1:10, 1:5]
```

```
   subjects    activity_labels tBodyAcc-mean()-X tBodyAcc-mean()-Y
1         1             LAYING            0.2216         -0.040514
2         1            SITTING            0.2612         -0.001308
3         1           STANDING            0.2789         -0.016138
4         1            WALKING            0.2773         -0.017384
5         1 WALKING_DOWNSTAIRS            0.2892         -0.009919
6         1   WALKING_UPSTAIRS            0.2555         -0.023953
7         2             LAYING            0.2814         -0.018159
8         2            SITTING            0.2771         -0.015688
9         2           STANDING            0.2779         -0.018421
10        2            WALKING            0.2764         -0.018595
   tBodyAcc-mean()-Z
1            -0.1132
2            -0.1045
3            -0.1106
4            -0.1111
5            -0.1076
6            -0.0973
7            -0.1072
8            -0.1092
9            -0.1059
10           -0.1055
```



## Write the result to a txt file


```r
write.table(tidy_data, file = "tidy_data.txt", quote = FALSE, row.names = FALSE)
```

