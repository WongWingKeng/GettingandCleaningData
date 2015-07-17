#clear all environment variables

rm(list=ls())

# function to cleanup obsolete data.tables
To_clear <-function(x){
        message("Clear obsolete objects...")
        rm(list=x,pos=1)
}

# check required library packages ####
packagelist<-c("data.table","plyr")
chkpkg<-function(pkgname){
        not.found <- pkgname[!(pkgname %in% installed.packages()[, "Package"])]
        if (length(not.found)) 
                install.packages(new.pkg)
}        
chkpkg(packagelist)

message("Loading packages...")
sapply(packagelist,require,character.only = TRUE)


message("Getting and cleaning Samsung Smartphone Dataset...")

# get current filepath, change if required
dirpath<-getwd()
message("\nWork with current directory?\n" ,"\"",dirpath,"\"")
response <- readline("Yes or No? ")
if(tolower(response) %in% c("n", "no")){
        dirpath <- readline("Please enter working directory: ")
        dirpath <- gsub("\\\\", "/", dirpath)
        message("Setting path to:\n\"", dirpath,"\"")
        setwd(dirpath)
}

# download, extract data file if one does not exist
if (!file.exists("UCI\ HAR\ Dataset")) {
        if (!file.exists("UCI\ HAR\ Dataset.zip")) {
                message("Downloading dataset from internet...")
                download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",
                               "UCI HAR Dataset.zip", method="auto",mode="wb")
        }
        message ("Extracting dataset zip file to local directory")
        unzip("UCI HAR Dataset.zip")
}


# setting file paths to extracted diretory
filepath<-file.path(dirpath,"UCI HAR Dataset")


# ********** Reading activities ***********

message("Reading activity label...")
dtactivityLabels<-read.table(file.path(filepath,"activity_labels.txt"))

message("Reading training activities...")
dtactivityTrain<-read.table(file.path(filepath,"/train/y_train.txt"))

message("Reading testing activities...")
dtactivityTest<-read.table(file.path(filepath,"/test/y_test.txt"))

message("Merging activities...")
dtactivity<-rbind(dtactivityTrain,dtactivityTest)

## use plyr's join to preseve order for further column binding
dtactivity<-join(dtactivity,dtactivityLabels, by="V1")


# ************* Reading subject ****************

message("Reading training subject...")
dtsubjectTrain<-read.table(file.path(filepath,"/train/subject_train.txt"))

message("Reading testing subject...")
dtsubjectTest<-read.table(file.path(filepath,"/test/subject_test.txt"))

message("Merging subjects...")
dtsubject<-rbind(dtsubjectTrain,dtsubjectTest)

message("Merging subject and activities...")
dtsubjectActivities<-cbind(dtsubject,dtactivity[,2])
setnames(dtsubjectActivities,c("Subject","Activity"))

# Cleanup obsolete objects
obsoleteDt<-c("dtactivityLabels","dtactivityTrain","dtactivityTest","dtactivity",
              "dtsubjectTrain","dtsubjectTest","dtsubject")
To_clear(obsoleteDt)

# ************* Reading features ****************

message("Reading features name...")
dtfeaturesNames<-read.table(file.path(filepath,"features.txt"))

message("Reading training features data...")
dtfeaturesTrain<-read.table(file.path(filepath,"/train/X_train.txt"))

message("Reading testing features data...")
dtfeaturesTest<-read.table(file.path(filepath,"/test/X_test.txt"))

message("Merging features...")
dtfeatures<-rbind(dtfeaturesTrain,dtfeaturesTest)

message("Merging features data and feature names label...")
names(dtfeatures)<-dtfeaturesNames[,2]


# ************* Merging tidy data *********************

message("Filtering Mean and Standard Deviation columns...")
dtFiltered<-dtfeatures[,grepl("mean|std",names(dtfeatures),ignore.case = FALSE)] 

message("Re-labeling...")
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

message("Merging tidy data set...")
dtTidy<-cbind(dtsubjectActivities,dtFiltered)

message("Writing \"tidy_alldata.txt\" file to current working directory...\n",getwd())
write.table(dtTidy,"tidy_alldata.txt",quote=FALSE,sep=" ",row.names = FALSE)


# Cleanup obsolete objects
obsoleteDt2<-c("dtsubjectActivities","dtfeaturesNames","dtfeaturesTrain","dtfeaturesTest","dtfeatures","dtFiltered")
To_clear(obsoleteDt2)


# creates a second, tidy data set with the average of each variable for each activity and each subject.
message("Preparing averaged tidy data set...")
dtTidy2<-ddply(dtTidy,.(Subject, Activity), numcolwise(mean))
names(dtTidy2)<-sub("^(TimeDomain|FrequencyDomain)(.*)", "Mean.Of.\\1\\2", names(dtTidy2))

message("Writing \"tidy_averaged_bySubjectActivity.txt\" file to current working directory...\n",getwd())
write.table(dtTidy2,"tidy_averaged_bySubjectActivity.txt",quote=FALSE,sep=" ",row.names = FALSE)

message("End processing...")

