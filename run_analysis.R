library(dplyr)

## Part I: Process dataset
# Read in 561-feature vectors from X_train & X_test
df_train <- read.csv("UCI HAR Dataset/train/X_train.txt", sep = "", header = FALSE)
df_test <- read.csv("UCI HAR Dataset/test/X_test.txt", sep = "", header = FALSE)

# Merge training & test datasets
df_all <- rbind(df_train, df_test)

# Set descriptive feature names
feat_names <- readLines("UCI HAR Dataset/features.txt")
feat_names <- gsub("\\d*\\s(.*)", "\\1", feat_names)
names(df_all) <- feat_names

# Select only the measurements on the mean and standard deviation
df_all <- df_all %>% select(contains("mean"), contains("std"))

## Part II: Process activities
# Read in activity targets y_train & y_test
act_train <- read.csv("UCI HAR Dataset/train/y_train.txt", sep = "", header = FALSE)
act_test <- read.csv("UCI HAR Dataset/test/y_test.txt", sep = "", header = FALSE)

# Merge training & test targets
act_all <- rbind(act_train, act_test)
names(act_all) <- "ActivityDescription"

# Set descriptive activity names
act_names <- readLines("UCI HAR Dataset/activity_labels.txt")
act_names <- gsub("\\d\\s(.*)", "\\1", act_names)
act_all %>% mutate(Activity = act_names[Activity])

## Part III: Process subjects
# Read in subjects from train & test
subj_train <- read.csv("UCI HAR Dataset/train/subject_train.txt", sep = "", header = FALSE)
subj_test <- read.csv("UCI HAR Dataset/test/subject_test.txt", sep = "", header = FALSE)

# Merge training & test subjects
subj_all <- rbind(subj_train, subj_test)
names(subj_all) <- "SubjectNumber"

## Part IV: Combine into a single tidy dataset
df_tidy <- cbind(subj_all, act_all, df_all) 

# Tidy up variable names
names(df_tidy)<-gsub("Acc", "Accelerometer", names(df_tidy))
names(df_tidy)<-gsub("Gyro", "Gyroscope", names(df_tidy))
names(df_tidy)<-gsub("BodyBody", "Body", names(df_tidy))
names(df_tidy)<-gsub("Mag", "Magnitude", names(df_tidy))
names(df_tidy)<-gsub("^t", "Time", names(df_tidy))
names(df_tidy)<-gsub("^f", "Frequency", names(df_tidy))
names(df_tidy)<-gsub("tBody", "TimeBody", names(df_tidy))
names(df_tidy)<-gsub("-mean()", "Mean", names(df_tidy), ignore.case = TRUE)
names(df_tidy)<-gsub("-std()", "STD", names(df_tidy), ignore.case = TRUE)
names(df_tidy)<-gsub("-freq()", "Frequency", names(df_tidy), ignore.case = TRUE)
names(df_tidy)<-gsub("angle", "Angle", names(df_tidy))
names(df_tidy)<-gsub("gravity", "Gravity", names(df_tidy))

## Part V: Compute summary statistics by activity and subject
df_tidy %>% 
  group_by(ActivityDescription, SubjectNumber) %>%
  summarize_all(list(mean = mean))
