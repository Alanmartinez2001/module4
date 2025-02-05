# CodeBook: Description of Variables  

This study consists of a series of experiments conducted on a group of 30 individuals. Each person performed six activities using a smartphone, and various measurements were recorded. The results obtained were randomly divided into a test set and a training set.  

As stated in the documentation about the study, both datasets contain the following information for each observation:  

- Triaxial acceleration from the accelerometer (total acceleration) and the estimated body acceleration.  
- Triaxial Angular velocity from the gyroscope.  
- A 561-feature vector with time and frequency domain variables.  
- Its activity label.  
- An identifier of the subject who carried out the experiment.  

The file used to identify the subjects in both datasets, `train/subject_train.txt`, identifies in each row the subject who performed the activity for each window sample. It takes integer values from 1 to 30.  

The datasets containing the different measurements are `"test/X_test.txt"` and `"train/X_train.txt"`. Both contain 561 columns derived from all the variables generated in the study. The name of each column is found in the file `"features.txt"`.  

Regarding the categories, the `"activity_labels.txt"` file contains the name of the performed activity. Each dataset includes a vector that contains labels for each activity.  

| Dataset   | Variables | Type    |  
|-----------|----------|---------|  
| X_train(test).txt    | 561 measurements   | Continuous    |  
| subject_train(test).txt    | One variable with 30 subjects   | Discrete |  
| y_train(test)     | One variable with 6 categories  | Discrete  |  

In question one, the datasets containing the measured variables, as well as the subject and activity label datasets (test/train, subject, and label), were loaded. First, the three datasets (data, label, subject) corresponding to each sample (test and train) were merged. Then, both datasets, training and test, were combined into the dataframe `"completa"`.  

The resulting dataframe had the following composition:  

| Variable | Description | Type |  
|-----------|-------------|------|  
|subject    | Contains numbers corresponding to the individual | Discrete |  
|Columns 2 to 562| Contains the measurements | Continuous |  
|label| Contains the variable that identifies the activities | Discrete |  

Then, several modifications were made to the variables:  

- We kept only the variables that measured mean or standard deviation using the `"features.txt"` file. The resulting dataframe was `"mean_std"`.  
- We renamed the values in the `"label"` column, replacing the numbers with the corresponding activity names using the `"activity_labels.txt"` file.  
- We changed the column names for the measurement variables to reflect the name of the measurement.  
- Finally, we modified the dataframe to retain only one observation per row, consisting of a specific individual and activity. The values were summarized by computing the mean of each variable for each observation. The obtained dataframe was named `"final"`, and it has the following structure:  

| Variable | Description | Type |  
|-----------|-------------|------|  
|sub_act    | Observation containing the individual’s number and the performed activity | Character |  
|Measurements| Contains the measurements showing mean or standard deviation | Continuous |  
