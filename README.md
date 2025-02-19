# Script Description
## Question #1: Merge the data

First, load the necessary datasets (subject, label and data) into a two different lists. We first have to set the wd in the file of test and train.

```r
library(dplyr)
library(base)
setwd("D:/Ciencias de Datos en R/3 Getting and Cleaning Data/MODULO 4/UCI HAR Dataset/test")
test <-lapply(list.files(), read.table)
names(test) <- c("subject_test", "vars", "label_test")
setwd("D:/Ciencias de Datos en R/3 Getting and Cleaning Data/MODULO 4/UCI HAR Dataset/train")
train <-lapply(list.files(), read.table)
names(train) <- c("subject_train", "vars", "label_train")
```

Then, make a data frame with each element of the list as a column, for test and train data respectively.

```r 
test_base<-data.frame(subject=unlist(test$subject_test, use.names = F), 
                      test[[2]], 
                      label=unlist(test$label_test, use.names = F))

train_base<-data.frame(subject=unlist(train$subject_train, use.names = F), 
                      train[[2]], 
                      label=unlist(train$label_train, use.names = F))
```

We will add both individuals, since the sample was randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data. We will use the merge command.

```r
completa <- merge(train_base, test_base, all = T)
```

## Question #2: mean() and std() vars

For extracting only the measurements on the mean and std for each measurement, we need to set the wd in the UCI HAR Dataset and load the file "features.txt" into a dataframe. This file contains all the measurements.

```r
setwd("D:/Ciencias de Datos en R/3 Getting and Cleaning Data/MODULO 4/UCI HAR Dataset")
columns<-read.table("features.txt")
```

Then we will use the function grepl. This will give TRUE values for observations where there is "mean()" or "std()" in the "columns" data frame, which we will use to subset the "completa" data frame by columns. The name of the new data frame is "mean_std"

```r
mean_std<-completa[,grepl("mean\\(\\)|std\\(\\)", columns$V2)]
```

## Question #3: Label activities

For label the activities, first we need to load the "activity_labels.txt" file. Then change the "label" column of the "mean_std" data frame to a factor variable and label each number as the corresponding activity using the "act" dataframe.

```r
setwd("D:/Ciencias de Datos en R/3 Getting and Cleaning Data/MODULO 4/UCI HAR Dataset")
act <- read.table("activity_labels.txt")
mean_std$label <- factor(mean_std$label, levels = 1:6, labels = act$V2)

```

## Question #4: Label variables

First, we will extract the names of the variables from the "columns" dataframe used in question #2. We again use the grepl function for extracting only the names that contain "mean()" or "std()", and saving it in the vector "variab". Then we subset the columns 2:67 of the mean_std dataframe and, using the names() function, rename these columns.

```r
variab <- columns[grepl("mean\\(\\)|std\\(\\)", columns$V2), "V2"]
names(mean_std)[2:67] <- variab
```

## Question #5: Final tidyset

We form a new variable, "sub_act", that contains a particular observation of a subject and an activity, and group the data using that variable. Then summarize computing the mean of the columns 2:67, using the function across. The resulting dataframe have one observation per row, which correspond to a subject performing one particular activity.
```r
final <- mean_std %>%
    mutate(sub_act=paste(subject, label)) %>% # variable que contenga cada observación particular
    group_by(sub_act) %>% # agrupamos por la variable creada (individuo y actividad)
    summarize(across(2:67, mean, na.rm = TRUE)) # resumimos a traves de todas las variables 
```

Finally, save the result as a text file.
```r
setwd("D:/Ciencias de Datos en R/3 Getting and Cleaning Data/MODULO 4")
write.table(final, "final_data.txt", row.names = FALSE)
```

