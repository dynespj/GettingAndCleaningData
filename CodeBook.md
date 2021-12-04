The run_analysis.R script performs the data preparation and then followed by the 5 steps required as described in the course project’s definition.

1. Load all untidied data into workspace


*raw_train <- train/X_train.txt: 7352 rows, 561 columns
  * contains recorded sensor data in the train set
* raw_test <- test/X_test.txt: 2947 rows, 561 columns
  * contains recorded sensor data in the test set
* subj_train <- train/subject_train.txt: 7352 rows, 1 column
  * contains IDs of volunteers being observed in train set
* subj_test <- test/subject_test.txt: 2947 rows, 1 column
  * contains IDs of volunteers being observed in test set
* act_train <- train/y_train.txt: 7352 rows, 1 column
  * contains activity code labels of train set
* act_test <- test/y_test.txt: 2947 rows, 1 column
  * contains activity code labels of test set

2. Merge the training and the test sets to create one untidied data set

raw_all: 10299 rows, 561 columns
created by merging raw_train and raw_test using rbind() function
subj_all: 10299 rows, 1 column
created by merging raw_train and raw_test using rbind() function
act_all: 10299 rows, 1 column
created by merging raw_train and raw_test using rbind() function

3. Tidy up feature names and activity lables

* Uses descriptive activity names to name the activities in the data set
  Entire numbers in code column of the TidyData replaced with corresponding activity taken from second column of the activities variable

    Appropriately labels the data set with descriptive variable names
        code column in TidyData renamed into activities
        All Acc in column’s name replaced by Accelerometer
        All Gyro in column’s name replaced by Gyroscope
        All BodyBody in column’s name replaced by Body
        All Mag in column’s name replaced by Magnitude
        All start with character f in column’s name replaced by Frequency
        All start with character t in column’s name replaced by Time


# Part II : Merge data
raw_all <- rbind(raw_train, raw_test)
subj_all <- rbind(subj_train, subj_test)
act_all <- rbind(act_train, act_test)

# Part III: Tidy up variable names & values
feat_names <- readLines("UCI HAR Dataset/features.txt")
feat_names <- gsub("\\d*\\s(.*)", "\\1", feat_names)
names(raw_all) <- feat_names

names(raw_all) <- gsub("Acc", "Accelerometer", names(raw_all))
names(raw_all) <- gsub("Gyro", "Gyroscope", names(raw_all))
names(raw_all) <- gsub("BodyBody", "Body", names(raw_all))
names(raw_all) <- gsub("Mag", "Magnitude", names(raw_all))
names(raw_all) <- gsub("^t", "Time", names(raw_all))
names(raw_all) <- gsub("^f", "Frequency", names(raw_all))
names(raw_all) <- gsub("tBody", "TimeBody", names(raw_all))
names(raw_all) <- gsub("-mean()", "Mean", names(raw_all), ignore.case = TRUE)
names(raw_all) <- gsub("-std()", "STD", names(raw_all), ignore.case = TRUE)
names(raw_all) <- gsub("-freq()", "Frequency", names(raw_all), ignore.case = TRUE)
names(raw_all) <- gsub("angle", "Angle", names(raw_all))
names(raw_all) <- gsub("gravity", "Gravity", names(raw_all))

names(subj_all) <- "SubjectNumber"
names(act_all) <- "ActivityDescription"

act_names <- readLines("UCI HAR Dataset/activity_labels.txt")
act_names <- gsub("\\d\\s(.*)", "\\1", act_names)
act_all <- act_all %>% mutate(ActivityDescription = act_names[ActivityDescription])

# Part IV: Subset measurements on the mean and standard deviation
raw_all <- raw_all %>% select(contains("MEAN"), contains("STD"))

## Part V: Combine into a single tidy dataset
df_tidy <- cbind(subj_all, act_all, raw_all) 

## Part VI: Compute summary statistics by activity and subject
df_tidy %>% 
  group_by(ActivityDescription, SubjectNumber) %>%
  summarize_all(list(mean = mean))



    Extracts only the measurements on the mean and standard deviation for each measurement
        TidyData (10299 rows, 88 columns) is created by subsetting Merged_Data, selecting only columns: subject, code and the measurements on the mean and standard deviation (std) for each measurement

    Uses descriptive activity names to name the activities in the data set
        Entire numbers in code column of the TidyData replaced with corresponding activity taken from second column of the activities variable

    Appropriately labels the data set with descriptive variable names
        code column in TidyData renamed into activities
        All Acc in column’s name replaced by Accelerometer
        All Gyro in column’s name replaced by Gyroscope
        All BodyBody in column’s name replaced by Body
        All Mag in column’s name replaced by Magnitude
        All start with character f in column’s name replaced by Frequency
        All start with character t in column’s name replaced by Time

    From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject
        FinalData (180 rows, 88 columns) is created by sumarizing TidyData taking the means of each variable for each activity and each subject, after groupped by subject and activity.
        Export FinalData into FinalData.txt file.

