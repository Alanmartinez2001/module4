###
# 1-- Merges the training and the test sets to create one data set.----
###
library(dplyr)

# Set wd and load datasets into a list.
setwd("D:/Ciencias de Datos en R/3 Getting and Cleaning Data/MODULO 4/UCI HAR Dataset/test")
test <-lapply(list.files(), read.table)
names(test) <- c("subject_test", "vars", "label_test")
setwd("D:/Ciencias de Datos en R/3 Getting and Cleaning Data/MODULO 4/UCI HAR Dataset/train")
train <-lapply(list.files(), read.table)
names(train) <- c("subject_train", "vars", "label_train")

# Form a dataframe of each element of the list (subject, variables and labels)
test_base<-data.frame(subject=unlist(test$subject_test, use.names = F), 
                      test[[2]], 
                      label=unlist(test$label_test, use.names = F))

train_base<-data.frame(subject=unlist(train$subject_train, use.names = F), 
                      train[[2]], 
                      label=unlist(train$label_train, use.names = F))
rm(test, train)

# We will add both individuals, since the sample was randomly partitioned into 
# two sets, where 70% of the volunteers was selected for generating the training 
# data and 30% the test data. 

completa <- merge(train_base, test_base, all = T)
rm(test_base, train_base)

###
# 2-- Extracts only the measurements on the mean and standard deviation for each ----
#     measurement. 
###

setwd("D:/Ciencias de Datos en R/3 Getting and Cleaning Data/MODULO 4/UCI HAR Dataset")

# Substract the variables than contain mean() or std()
columns<-read.table("features.txt")
mean_std<-completa[,grepl("mean\\(\\)|std\\(\\)", columns$V2)]
rm(completa)

###
# 3 -- Uses descriptive activity names to name the activities in the data set.
###
setwd("D:/Ciencias de Datos en R/3 Getting and Cleaning Data/MODULO 4/UCI HAR Dataset")

# Convertimos en factor a la columna label del dataframe anterior, y le ponemos
# las etiquetas que vienen en la base activity_labels
act <- read.table("activity_labels.txt")
mean_std$label <- factor(mean_std$label, levels = 1:6, labels = act$V2)

###
# 4 Appropriately labels the data set with descriptive variable names. 
###
# Extraemos los nombres de las variables del archivo features, y nos quedamos 
# solo con las media y desviación estandar. Despues seleccionamos solo los
# nombres de las variables que nos interesan, (todas excepto las variables de 
# sujeto y actividad) y las cambiamos por el nombre de la medida correspondiente

variab <- columns[grepl("mean\\(\\)|std\\(\\)", columns$V2), "V2"]
names(mean_std)[2:67] <- variab

###
# 5 From the data set in step 4, creates a second, independent tidy data set with 
### the average of each variable for each activity and each subject.

final <- mean_std %>%
    mutate(sub_act=paste(subject, label)) %>% # variable que contenga cada observación particular
    group_by(sub_act) %>% # agrupamos por la variable creada (individuo y actividad)
    summarize(across(2:67, mean, na.rm = TRUE)) # resumimos a traves de todas las variables 

write.table(final, row.names = F)
    