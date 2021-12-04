The run_analysis.R script prepares a tidied dataset

1. Load all untidied data into workspace

* raw_train <- train/X_train.txt: 7352 rows, 561 columns
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

* raw_all: 10299 rows, 561 columns
  * created by merging raw_train and raw_test using rbind() function
* subj_all: 10299 rows, 1 column
  * created by merging raw_train and raw_test using rbind() function
* act_all: 10299 rows, 1 column
  * created by merging raw_train and raw_test using rbind() function

3. Tidy up feature names and activity lables


* Column headers of raw_all replaced with feature names in features.txt
* These feature names are then tidied up to be a bit more descriptive:
  * All Acc in column’s name replaced by Accelerometer
  * All Gyro in column’s name replaced by Gyroscope
  * All BodyBody in column’s name replaced by Body
  * All Mag in column’s name replaced by Magnitude
  * All start with character f in column’s name replaced by Frequency
  * All start with character t in column’s name replaced by Time
  * Various other minor stylistic changes
* Numeric activity codes are replaced by the descriptive labels
  * WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING
* Column header of subj_all changes to "SubjectNumber"
* Column header of act_all changes to "ActivityDescription"

4. Combine everything into a tidy dataset
* cbind is used to combine raw_all, subj_all, act_all into a single dataframe

5. Extract only the measurements on the mean and standard deviation for each measurement
* Done using dplyr's "select" method

6. Creates a second, independent tidy data set with the average of each variable for each activity and each subject
* Done using dplyr's "groupby" and "summarize_all" methods
* All data is exported to to a file called TidiedData.csv

