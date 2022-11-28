# Getting and cleaning data 

library(tidyverse)

# First getting all the correct files loaded into R
train <- read.table("C:\\Users\\Rob\\OneDrive\\Documents\\git stats lab\\get_and_clean\\getdata_projectfiles_UCI HAR Dataset\\UCI HAR Dataset\\train\\X_train.txt")
subjects_train <- read.table("C:\\Users\\Rob\\OneDrive\\Documents\\git stats lab\\get_and_clean\\getdata_projectfiles_UCI HAR Dataset\\UCI HAR Dataset\\train\\subject_train.txt")
test <- read.table("C:\\Users\\Rob\\OneDrive\\Documents\\git stats lab\\get_and_clean\\getdata_projectfiles_UCI HAR Dataset\\UCI HAR Dataset\\test\\X_test.txt")
subjects_test <- read.table("C:\\Users\\Rob\\OneDrive\\Documents\\git stats lab\\get_and_clean\\getdata_projectfiles_UCI HAR Dataset\\UCI HAR Dataset\\test\\subject_test.txt")


# Need to get the names of each column into data set
names_of_columns <- read.table("C:\\Users\\Rob\\OneDrive\\Documents\\git stats lab\\get_and_clean\\getdata_projectfiles_UCI HAR Dataset\\UCI HAR Dataset\\features.txt")

names_of_columns <- names_of_columns %>% 
  select(-V1)

names_of_columns <- t(names_of_columns)

colnames(train) <- names_of_columns
colnames(test) <- names_of_columns

# Getting the labels into r and merging with the larger train and test "x" files
train_y <- read.table("C:\\Users\\Rob\\OneDrive\\Documents\\git stats lab\\get_and_clean\\getdata_projectfiles_UCI HAR Dataset\\UCI HAR Dataset\\train\\y_train.txt")
test_y <-read.table("C:\\Users\\Rob\\OneDrive\\Documents\\git stats lab\\get_and_clean\\getdata_projectfiles_UCI HAR Dataset\\UCI HAR Dataset\\test\\y_test.txt")

# Renaming the subject if column so to not be confused when cbinding with the activity labels
subjects_train <- rename(subjects_train, subject_num = V1)

train2 <- cbind(train, train_y)

train_full <- cbind(subjects_train, train2)

# Creating the activity labels by turning it into a factor variable
train_full$V1 <- factor(train_full$V1, levels = c(1,2,3,4,5,6),
                        labels = c("WALKING", "WALKING_UPSTAIRS", "WALKING_DOWNSTAIRS", "SITTING", "STANDING", "LAYING"))

# Do all the same for the testing data 
subjects_test <- rename(subjects_test, subject_num = V1)

test2 <- cbind(test, test_y)

test_full <- cbind(subjects_test, test2)

test_full$V1 <- factor(test_full$V1, levels = c(1,2,3,4,5,6),
                        labels = c("WALKING", "WALKING_UPSTAIRS", "WALKING_DOWNSTAIRS", "SITTING", "STANDING", "LAYING"))

full_data <- rbind(train_full, test_full) # Merging to creating one data set is complete

# Selecting just the variables needed which are the mean and standard deviations 
full_data2 <- full_data %>% 
  select(1:7, 42:47, 82:87, 122:127, 162:167, 202:203, 215:216, 228:229, 241:242,
         254:255, 267:272, 295:297, 346:351, 374:376, 425:430, 453:455, 504:505,
         514, 517:518, 527, 530:531, 540, 543:544, 553, V1)

# Renaming the variables using rename 
full_data2 <- full_data2 %>% 
  rename(activities = 81)

### Creating a second tidy data set with the average of each variable. 

new_data <- full_data2 %>% 
  group_by(subject_num, activities) %>%
  summarize(subject_num = subject_num,
            activities = activities,
            across(c(254:255), mean))
  
new_data <- full_data2 %>% 
  group_by(subject_num, activities) %>% 
  summarise(across(everything(), list(mean = mean)))


write.csv(new_data, file = "tidydata_get_and_clean")

