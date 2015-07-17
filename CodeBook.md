#Getting and Cleaning Data CodeBook

This file describes the data source used in the assignment, the data transformation process and the data dictionary/variables of the generated tidy data set.



##Table of Content

####A) Data Source
####B) Data Transformation  	
####C) Data Dictionary 
  
---   

## A) Data Source

The source data represent data collected from the accelerometer of a Samsung Galaxy S smartphone with test and training subjects wearing/holding the device and performing a sets of specific activities.

Source data can be ontained online
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

Further information on data source:
http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

 
8 raw data files from the source data repository are used to produce the tidy data set.

```
\UCI HAR Dataset  
	|_ activity_labels.txt  
	|_ features.txt  
	|_test
	    |_subject_test.txt
	    |_X_test.txt
	    |_y_test.txt
	|_train
	    |_subject_train.txt
	    |_X_train.txt
	    |_y_train.txt 


```

-  **activity_labels.txt** - activity type linking to y_train.txt and y_test.txt.  
- **features.txt** - features names linking to X_train.txt and X_test.txt.
- **subject_test.txt** - testing subjects' id.   
- **subject_train.txt** - training subjects' id.  
- **X_test.txt** - data measurements from testing sessions.
- **X_train.txt** - data measurements from training sessions.
- **y_test.txt** - testing activities by test subjects.  
- **y_train.txt** - training activities by training subjects.   


---
### B) Data Transformation

####To produce the final tidy data set, the raw data goes through the following transformation process

1) Reading the activity label and activity data sets.

```
dtactivityLabels<-read.table(file.path(filepath,"activity_labels.txt"))
dtactivityTrain<-read.table(file.path(filepath,"/train/y_train.txt"))
dtactivityTest<-read.table(file.path(filepath,"/test/y_test.txt"))
```

2) Merging the activitiy sets to activity labels.

```
dtactivity<-rbind(dtactivityTrain,dtactivityTest)
dtactivity<-join(dtactivity,dtactivityLabels, by="V1")
```

3) Reading the subject data sets.

```
dtsubjectTrain<-read.table(file.path(filepath,"/train/subject_train.txt"))
dtsubjectTest<-read.table(file.path(filepath,"/test/subject_test.txt"))
```

4) Merging the subjects to the activities set and assign appropriate variable labels.

```
dtsubject<-rbind(dtsubjectTrain,dtsubjectTest)
dtsubjectActivities<-cbind(dtsubject,dtactivity[,2])
setnames(dtsubjectActivities,c("Subject","Activity"))
```

5) Reading the features labels and features measurement sets.

```
dtfeaturesNames<-read.table(file.path(filepath,"features.txt"))
dtfeaturesTrain<-read.table(file.path(filepath,"/train/X_train.txt"))
dtfeaturesTest<-read.table(file.path(filepath,"/test/X_test.txt"))
```

6) Merging the features measurement sets to features label.

```
dtfeatures<-rbind(dtfeaturesTrain,dtfeaturesTest)
names(dtfeatures)<-dtfeaturesNames[,2]
```

7) Filter data set to only Mean and Standard Deviation measurements.

```
dtFiltered<-dtfeatures[,grepl("mean|std",names(dtfeatures),ignore.case = FALSE)] 
```

8) Re-labeling features with descriptive names.

```
names(dtFiltered)<-gsub("[[:punct:]]", "", names(dtFiltered)) 
names(dtFiltered)<-gsub("X$", ".forXdirection", names(dtFiltered))
names(dtFiltered)<-gsub("Y$", ".forYdirection", names(dtFiltered))
names(dtFiltered)<-gsub("Z$", ".forZdirection", names(dtFiltered))
names(dtFiltered)<-gsub("[a|A]cc", "Acceleration.", names(dtFiltered))
names(dtFiltered)<-gsub("[g|G]ravity", "Gravity.", names(dtFiltered))
names(dtFiltered)<-gsub("[g|G]yro", "Gyroscope.", names(dtFiltered))
names(dtFiltered)<-gsub("Body", "Body.", names(dtFiltered))
names(dtFiltered)<-gsub("Body.Body.", "Body.", names(dtFiltered))
names(dtFiltered)<-gsub("[M|m]ag", "Magnitude.", names(dtFiltered))
names(dtFiltered)<-gsub("JerkMagnitude", "Jerk.Magnitude", names(dtFiltered))
names(dtFiltered)<-gsub("Freq", "Frequency", names(dtFiltered)) 
names(dtFiltered)<-gsub("^t","TimeDomain.",names(dtFiltered))
names(dtFiltered)<-gsub("^f","FrequencyDomain.",names(dtFiltered))
names(dtFiltered)<-gsub("[M|m]ean", ".in.Mean", names(dtFiltered)) 
names(dtFiltered)<-gsub("[S|s]td", ".in.StandardDeviation", names(dtFiltered))
names(dtFiltered)<-gsub("\\.\\.",".", names(dtFiltered))
```

9) Merging the subjects, activities and features measurements

```
dtTidy<-cbind(dtsubjectActivities,dtFiltered)
```

10) Output initial tidy data set to current working directory

```
write.table(dtTidy,"tidy_alldata.txt",quote=FALSE,sep=" ",row.names = FALSE)
```


11) Calculate the average of all features measurements grouped by subject and activity type. 

```
dtTidy2<-ddply(dtTidy,.(Subject, Activity), numcolwise(mean))
```

12) Re-labelling with descriptive names.

```
names(dtTidy2)<-sub("^(TimeDomain|FrequencyDomain)(.*)", "Mean.Of.\\1\\2", names(dtTidy2))
```

13) Output the final averaged tidy data set to current working directory. 

```
write.table(dtTidy2,"tidy_averaged_bySubjectActivity.txt",quote=FALSE,sep=" ",row.names = FALSE)
```

---


### C) Data Dictionary

###Variables and Data 

```
Variable Name: Subject
Values:	Integer >   
		1..30
Sample : int  1 1 1 1 1 1 2 2 2 2 ...  
* Unique subject identifier assigned for each participant in the testing and training collection  
```

```
Variable Name: Activity
Values:	Factor > 
        WALKING   
        WALKING_UPSTAIRS  
        WALKING_DOWNSTAIRS  
        SITTING  
        STANDING  
        LAYING  
Sample : Factor w/ 6 levels "LAYING","SITTING",..  : 1 2 3 4 5 6 1 2 3 4 ...  
* Test subjects' activities during data collection 
```

```
Variable Names: TimeDomain.Body.Acceleration.in.Mean.forXdirection
                TimeDomain.Body.Acceleration.in.Mean.forYdirection
                TimeDomain.Body.Acceleration.in.Mean.forZdirection
                TimeDomain.Body.Acceleration.in.StandardDeviation.forXdirection
                TimeDomain.Body.Acceleration.in.StandardDeviation.forYdirection
                TimeDomain.Body.Acceleration.in.StandardDeviation.forZdirection
                TimeDomain.Gravity.Acceleration.in.Mean.forXdirection
                TimeDomain.Gravity.Acceleration.in.Mean.forYdirection
                TimeDomain.Gravity.Acceleration.in.Mean.forZdirection
                TimeDomain.Gravity.Acceleration.in.StandardDeviation.forXdirection
                TimeDomain.Gravity.Acceleration.in.StandardDeviation.forYdirection
                TimeDomain.Gravity.Acceleration.in.StandardDeviation.forZdirection
                TimeDomain.Body.Acceleration.Jerk.in.Mean.forXdirection
                TimeDomain.Body.Acceleration.Jerk.in.Mean.forYdirection
                TimeDomain.Body.Acceleration.Jerk.in.Mean.forZdirection
                TimeDomain.Body.Acceleration.Jerk.in.StandardDeviation.forXdirection
                TimeDomain.Body.Acceleration.Jerk.in.StandardDeviation.forYdirection
                TimeDomain.Body.Acceleration.Jerk.in.StandardDeviation.forZdirection
                TimeDomain.Body.Gyroscope.in.Mean.forXdirection
                TimeDomain.Body.Gyroscope.in.Mean.forYdirection
                TimeDomain.Body.Gyroscope.in.Mean.forZdirection
                TimeDomain.Body.Gyroscope.in.StandardDeviation.forXdirection
                TimeDomain.Body.Gyroscope.in.StandardDeviation.forYdirection
                TimeDomain.Body.Gyroscope.in.StandardDeviation.forZdirection
                TimeDomain.Body.Gyroscope.Jerk.in.Mean.forXdirection
                TimeDomain.Body.Gyroscope.Jerk.in.Mean.forYdirection
                TimeDomain.Body.Gyroscope.Jerk.in.Mean.forZdirection
                TimeDomain.Body.Gyroscope.Jerk.in.StandardDeviation.forXdirection
                TimeDomain.Body.Gyroscope.Jerk.in.StandardDeviation.forYdirection
                TimeDomain.Body.Gyroscope.Jerk.in.StandardDeviation.forZdirection
                TimeDomain.Body.Acceleration.Magnitude.in.Mean
                TimeDomain.Body.Acceleration.Magnitude.in.StandardDeviation
                TimeDomain.Gravity.Acceleration.Magnitude.in.Mean
                TimeDomain.Gravity.Acceleration.Magnitude.in.StandardDeviation
                TimeDomain.Body.Acceleration.Jerk.Magnitude.in.Mean
                TimeDomain.Body.Acceleration.Jerk.Magnitude.in.StandardDeviation
                TimeDomain.Body.Gyroscope.Magnitude.in.Mean
                TimeDomain.Body.Gyroscope.Magnitude.in.StandardDeviation
                TimeDomain.Body.Gyroscope.Jerk.Magnitude.in.Mean
                TimeDomain.Body.Gyroscope.Jerk.Magnitude.in.StandardDeviation
                FrequencyDomain.Body.Acceleration.in.Mean.forXdirection
                FrequencyDomain.Body.Acceleration.in.Mean.forYdirection
                FrequencyDomain.Body.Acceleration.in.Mean.forZdirection
                FrequencyDomain.Body.Acceleration.in.StandardDeviation.forXdirection
                FrequencyDomain.Body.Acceleration.in.StandardDeviation.forYdirection
                FrequencyDomain.Body.Acceleration.in.StandardDeviation.forZdirection
                FrequencyDomain.Body.Acceleration.in.MeanFrequency.forXdirection
                FrequencyDomain.Body.Acceleration.in.MeanFrequency.forYdirection
                FrequencyDomain.Body.Acceleration.in.MeanFrequency.forZdirection
                FrequencyDomain.Body.Acceleration.Jerk.in.Mean.forXdirection
                FrequencyDomain.Body.Acceleration.Jerk.in.Mean.forYdirection
                FrequencyDomain.Body.Acceleration.Jerk.in.Mean.forZdirection
                FrequencyDomain.Body.Acceleration.Jerk.in.StandardDeviation.forXdirection
                FrequencyDomain.Body.Acceleration.Jerk.in.StandardDeviation.forYdirection
                FrequencyDomain.Body.Acceleration.Jerk.in.StandardDeviation.forZdirection
                FrequencyDomain.Body.Acceleration.Jerk.in.MeanFrequency.forXdirection
                FrequencyDomain.Body.Acceleration.Jerk.in.MeanFrequency.forYdirection
                FrequencyDomain.Body.Acceleration.Jerk.in.MeanFrequency.forZdirection
                FrequencyDomain.Body.Gyroscope.in.Mean.forXdirection
                FrequencyDomain.Body.Gyroscope.in.Mean.forYdirection
                FrequencyDomain.Body.Gyroscope.in.Mean.forZdirection
                FrequencyDomain.Body.Gyroscope.in.StandardDeviation.forXdirection
                FrequencyDomain.Body.Gyroscope.in.StandardDeviation.forYdirection
                FrequencyDomain.Body.Gyroscope.in.StandardDeviation.forZdirection
                FrequencyDomain.Body.Gyroscope.in.MeanFrequency.forXdirection
                FrequencyDomain.Body.Gyroscope.in.MeanFrequency.forYdirection
                FrequencyDomain.Body.Gyroscope.in.MeanFrequency.forZdirection
                FrequencyDomain.Body.Acceleration.Magnitude.in.Mean
                FrequencyDomain.Body.Acceleration.Magnitude.in.StandardDeviation
                FrequencyDomain.Body.Acceleration.Magnitude.in.MeanFrequency
                FrequencyDomain.Body.Acceleration.Jerk.Magnitude.in.Mean
                FrequencyDomain.Body.Acceleration.Jerk.Magnitude.in.StandardDeviation
                FrequencyDomain.Body.Acceleration.Jerk.Magnitude.in.MeanFrequency
                FrequencyDomain.Body.Gyroscope.Magnitude.in.Mean
                FrequencyDomain.Body.Gyroscope.Magnitude.in.StandardDeviation
                FrequencyDomain.Body.Gyroscope.Magnitude.in.MeanFrequency
                FrequencyDomain.Body.Gyroscope.Jerk.Magnitude.in.Mean
                FrequencyDomain.Body.Gyroscope.Jerk.Magnitude.in.StandardDeviation
                FrequencyDomain.Body.Gyroscope.Jerk.Magnitude.in.MeanFrequency
Values: Numeric floating point
Sample: num -0.995 -0.998 -0.995 -0.996 -0.998 ...

*All variables are Mean and Standard Deviation measurement of features collection from the accelerometer and
 gyroscope 3-axial raw signals.

* TimeDomain* - time domain signals captured at a constant rate of 50 Hz. Then filtered using a
 median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to
 remove noise.

* FrequencyDomain* - frequency domain signals calculated by applying Fast Fourier Transform (FFT)
  to the signals

*Body.Acceleration*, *Gravity.Acceleration* - accelerometer signal separated into body and
 gravity acceleration signals

* forX/Y/Zdirection - denote 3-axial signals in the X, Y and Z directions

*Body.AccelerationJerk*X/Y/Z*,  Body.Gyroscope.Jerk*X/Y/Z* - Jerk signal calculated through
 body linear acceleration and angular velocity deriving in time for 3-axial direction

*Body.Acceleration.Magnitude*, *Gravity.Acceleration.Magnitude*,
*Body.Acceleration.Jerk.Magnitude*, *Body.Gyroscope.Magnitude*, 
*Body.Gyroscope.Jerk.Magnitude* - magnitude of 3-dimensional signals calculated using Euclidean norm

*in.Mean - mean value

*in.MeanFrequency - Weighted average of the frequency components to obtain a mean frequency

*in.StandardDeviation - Standard deviation

* Content of ---- > "tidy_alldata.txt"

```

```
Variable Names: Mean.Of.TimeDomain.Body.Acceleration.in.Mean.forXdirection
                Mean.Of.TimeDomain.Body.Acceleration.in.Mean.forYdirection
                Mean.Of.TimeDomain.Body.Acceleration.in.Mean.forZdirection
                Mean.Of.TimeDomain.Body.Acceleration.in.StandardDeviation.forXdirection
                Mean.Of.TimeDomain.Body.Acceleration.in.StandardDeviation.forYdirection
                Mean.Of.TimeDomain.Body.Acceleration.in.StandardDeviation.forZdirection
                Mean.Of.TimeDomain.Gravity.Acceleration.in.Mean.forXdirection
                Mean.Of.TimeDomain.Gravity.Acceleration.in.Mean.forYdirection
                Mean.Of.TimeDomain.Gravity.Acceleration.in.Mean.forZdirection
                Mean.Of.TimeDomain.Gravity.Acceleration.in.StandardDeviation.forXdirection
                Mean.Of.TimeDomain.Gravity.Acceleration.in.StandardDeviation.forYdirection
                Mean.Of.TimeDomain.Gravity.Acceleration.in.StandardDeviation.forZdirection
                Mean.Of.TimeDomain.Body.Acceleration.Jerk.in.Mean.forXdirection
                Mean.Of.TimeDomain.Body.Acceleration.Jerk.in.Mean.forYdirection
                Mean.Of.TimeDomain.Body.Acceleration.Jerk.in.Mean.forZdirection
                Mean.Of.TimeDomain.Body.Acceleration.Jerk.in.StandardDeviation.forXdirection
                Mean.Of.TimeDomain.Body.Acceleration.Jerk.in.StandardDeviation.forYdirection
                Mean.Of.TimeDomain.Body.Acceleration.Jerk.in.StandardDeviation.forZdirection
                Mean.Of.TimeDomain.Body.Gyroscope.in.Mean.forXdirection
                Mean.Of.TimeDomain.Body.Gyroscope.in.Mean.forYdirection
                Mean.Of.TimeDomain.Body.Gyroscope.in.Mean.forZdirection
                Mean.Of.TimeDomain.Body.Gyroscope.in.StandardDeviation.forXdirection
                Mean.Of.TimeDomain.Body.Gyroscope.in.StandardDeviation.forYdirection
                Mean.Of.TimeDomain.Body.Gyroscope.in.StandardDeviation.forZdirection
                Mean.Of.TimeDomain.Body.Gyroscope.Jerk.in.Mean.forXdirection
                Mean.Of.TimeDomain.Body.Gyroscope.Jerk.in.Mean.forYdirection
                Mean.Of.TimeDomain.Body.Gyroscope.Jerk.in.Mean.forZdirection
                Mean.Of.TimeDomain.Body.Gyroscope.Jerk.in.StandardDeviation.forXdirection
                Mean.Of.TimeDomain.Body.Gyroscope.Jerk.in.StandardDeviation.forYdirection
                Mean.Of.TimeDomain.Body.Gyroscope.Jerk.in.StandardDeviation.forZdirection
                Mean.Of.TimeDomain.Body.Acceleration.Magnitude.in.Mean
                Mean.Of.TimeDomain.Body.Acceleration.Magnitude.in.StandardDeviation
                Mean.Of.TimeDomain.Gravity.Acceleration.Magnitude.in.Mean
                Mean.Of.TimeDomain.Gravity.Acceleration.Magnitude.in.StandardDeviation
                Mean.Of.TimeDomain.Body.Acceleration.Jerk.Magnitude.in.Mean
                Mean.Of.TimeDomain.Body.Acceleration.Jerk.Magnitude.in.StandardDeviation
                Mean.Of.TimeDomain.Body.Gyroscope.Magnitude.in.Mean
                Mean.Of.TimeDomain.Body.Gyroscope.Magnitude.in.StandardDeviation
                Mean.Of.TimeDomain.Body.Gyroscope.Jerk.Magnitude.in.Mean
                Mean.Of.TimeDomain.Body.Gyroscope.Jerk.Magnitude.in.StandardDeviation
                Mean.Of.FrequencyDomain.Body.Acceleration.in.Mean.forXdirection
                Mean.Of.FrequencyDomain.Body.Acceleration.in.Mean.forYdirection
                Mean.Of.FrequencyDomain.Body.Acceleration.in.Mean.forZdirection
                Mean.Of.FrequencyDomain.Body.Acceleration.in.StandardDeviation.forXdirection
                Mean.Of.FrequencyDomain.Body.Acceleration.in.StandardDeviation.forYdirection
                Mean.Of.FrequencyDomain.Body.Acceleration.in.StandardDeviation.forZdirection
                Mean.Of.FrequencyDomain.Body.Acceleration.in.MeanFrequency.forXdirection
                Mean.Of.FrequencyDomain.Body.Acceleration.in.MeanFrequency.forYdirection
                Mean.Of.FrequencyDomain.Body.Acceleration.in.MeanFrequency.forZdirection
                Mean.Of.FrequencyDomain.Body.Acceleration.Jerk.in.Mean.forXdirection
                Mean.Of.FrequencyDomain.Body.Acceleration.Jerk.in.Mean.forYdirection
                Mean.Of.FrequencyDomain.Body.Acceleration.Jerk.in.Mean.forZdirection
                Mean.Of.FrequencyDomain.Body.Acceleration.Jerk.in.StandardDeviation.forXdirection
                Mean.Of.FrequencyDomain.Body.Acceleration.Jerk.in.StandardDeviation.forYdirection
                Mean.Of.FrequencyDomain.Body.Acceleration.Jerk.in.StandardDeviation.forZdirection
                Mean.Of.FrequencyDomain.Body.Acceleration.Jerk.in.MeanFrequency.forXdirection
                Mean.Of.FrequencyDomain.Body.Acceleration.Jerk.in.MeanFrequency.forYdirection
                Mean.Of.FrequencyDomain.Body.Acceleration.Jerk.in.MeanFrequency.forZdirection
                Mean.Of.FrequencyDomain.Body.Gyroscope.in.Mean.forXdirection
                Mean.Of.FrequencyDomain.Body.Gyroscope.in.Mean.forYdirection
                Mean.Of.FrequencyDomain.Body.Gyroscope.in.Mean.forZdirection
                Mean.Of.FrequencyDomain.Body.Gyroscope.in.StandardDeviation.forXdirection
                Mean.Of.FrequencyDomain.Body.Gyroscope.in.StandardDeviation.forYdirection
                Mean.Of.FrequencyDomain.Body.Gyroscope.in.StandardDeviation.forZdirection
                Mean.Of.FrequencyDomain.Body.Gyroscope.in.MeanFrequency.forXdirection
                Mean.Of.FrequencyDomain.Body.Gyroscope.in.MeanFrequency.forYdirection
                Mean.Of.FrequencyDomain.Body.Gyroscope.in.MeanFrequency.forZdirection
                Mean.Of.FrequencyDomain.Body.Acceleration.Magnitude.in.Mean
                Mean.Of.FrequencyDomain.Body.Acceleration.Magnitude.in.StandardDeviation
                Mean.Of.FrequencyDomain.Body.Acceleration.Magnitude.in.MeanFrequency
                Mean.Of.FrequencyDomain.Body.Acceleration.Jerk.Magnitude.in.Mean
                Mean.Of.FrequencyDomain.Body.Acceleration.Jerk.Magnitude.in.StandardDeviation
                Mean.Of.FrequencyDomain.Body.Acceleration.Jerk.Magnitude.in.MeanFrequency
                Mean.Of.FrequencyDomain.Body.Gyroscope.Magnitude.in.Mean
                Mean.Of.FrequencyDomain.Body.Gyroscope.Magnitude.in.StandardDeviation
                Mean.Of.FrequencyDomain.Body.Gyroscope.Magnitude.in.MeanFrequency
                Mean.Of.FrequencyDomain.Body.Gyroscope.Jerk.Magnitude.in.Mean
                Mean.Of.FrequencyDomain.Body.Gyroscope.Jerk.Magnitude.in.StandardDeviation
                Mean.Of.FrequencyDomain.Body.Gyroscope.Jerk.Magnitude.in.MeanFrequency
Values: Numeric floating point 
Sample: num -0.113 -0.105 -0.111 -0.111 -0.108 ...

* Mean.of* - calculated average of each variables from "tidy_alldata.txt" grouped by Subject and Activity.

* Content of ---- > "tidy_averaged_bySubjectActivity.txt"

```






