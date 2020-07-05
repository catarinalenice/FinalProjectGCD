download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", "project")

unzip("project")

setwd("/home/catarina/Área de Trabalho/FinalProject/UCI HAR Dataset")

features <- read.table("features.txt")
activity <- read.table("activity_labels.txt", stringsAsFactors = FALSE)

setwd("/home/catarina/Área de Trabalho/FinalProject/UCI HAR Dataset/test")

Y_test <- read.table("y_test.txt")
X_test <- read.table("X_test.txt")
Subject_test <- read.table("subject_test.txt")

setwd("/home/catarina/Área de Trabalho/FinalProject/UCI HAR Dataset/train")

Y_train <- read.table("y_train.txt")
X_train <- read.table("X_train.txt")
Subject_train <- read.table("subject_train.txt")

setwd("/home/catarina/Área de Trabalho/FinalProject")

X_full <- rbind(X_test, X_train)
Y_full <- rbind(Y_test, Y_train)
Subject_full <- rbind(Subject_test, Subject_train)

columns_measurements <- c(grep("std()", features$V2), grep("mean()", features$V2))

X_full <- X_full[,columns_measurements]
  
names(X_full) <- features$V2[columns_measurements]

names(Y_full)[1] <- "activities"

names(Subject_full)[1] <- "subject"

df <- cbind(Y_full,Subject_full, X_full)

df <- df %>% 
  mutate(activities = replace(activities, activities == 1, activity$V2[1])) %>% 
  mutate(activities = replace(activities, activities == 2, activity$V2[2])) %>% 
  mutate(activities = replace(activities, activities == 3, activity$V2[3])) %>% 
  mutate(activities = replace(activities, activities == 4, activity$V2[4])) %>% 
  mutate(activities = replace(activities, activities == 5, activity$V2[5])) %>% 
  mutate(activities = replace(activities, activities == 6, activity$V2[6]))

df_by_activity <- df %>% 
  group_by(subject,activities) %>% 
  summarise_all(list(mean))

write.table(df_by_activity, "df_by_activity", row.name=FALSE)
