library(dplyr)

## Part I: Load all data
raw_train <- read.csv("UCI HAR Dataset/train/X_train.txt", sep = "", header = FALSE)
raw_test <- read.csv("UCI HAR Dataset/test/X_test.txt", sep = "", header = FALSE)
subj_train <- read.csv("UCI HAR Dataset/train/subject_train.txt", sep = "", header = FALSE)
subj_test <- read.csv("UCI HAR Dataset/test/subject_test.txt", sep = "", header = FALSE)
act_train <- read.csv("UCI HAR Dataset/train/y_train.txt", sep = "", header = FALSE)
act_test <- read.csv("UCI HAR Dataset/test/y_test.txt", sep = "", header = FALSE)

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

## Export tidied data
write.table(df_tidy, "all_tidied.txt", row.names = FALSE)
