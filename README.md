#Getting and Cleaning Data Course Project
  
  
## Overview


###Purpose: 
>**A)** To collect a data set  
>**B)** To clean up a data set  
>**C)** To prepare tidy data for further analysis

###Data Set Background

The data set used for this course assignment represent data collected from the accelerometers of a Samsung Galaxy S smartphone. Wearable computing is currently one of the most exciting area in data science as companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms to attract new users. This course assignment provides a glimpse into initial stage of collecting and cleaning data from these new development area.

###Data Source:
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

Further information on data source:   

http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 

---
  

## What you will find in the Github Repository:

- **`run_analysis.R`** : The complete R-code to run on the raw data set.

- **`tidy_alldata.txt`** : The initial cleaned data from the original data set using run_analysis.R. This file contains only the extraction of all the Mean and Standard Deviation measurements from the source data set.

- **`tidy_averaged_bySubjectActivity.txt`** : The second cleaned data set from using run_analysis.R. This file contains the averaged of each measurements grouped by  Subject and Activity of the first "tidy_alldata.txt" data set.

- **`CodeBook.md`** : The CodeBook provides description to the source data structure, data transformation process from raw to cleaned data and the data variables information (Data Dictionary). 

- **`README.md`** : Current file, explains the backrgound information and the usage of the script to generate the cleaned data.

---

## How to use the script

###Preparation

1. Download **`run_analysis.R`** source file from this Github repository.

2. Download the raw data source (reference the link on top) or allow the R script to downloand automatically during execution.

3. Place all required files into a target working folder on your local machine.

### Execution

***Note**: The R script was created and tested in Windows environment with R studio using R version 3.2.1. 

1. Startup R Studio.

2. Set your working directory to where you placed the R source file, raw data set. This will also be the default location to store the processed/output files.  
E.g.: setwd("c:/datascience/cleandata/")

3. Load and run the R script file.   
E.g. : source("< working_dir >/run_analsys.R")

4. The R script will check whether required R packages for data transformation are installed. It will trigger auto installation of packages if required. It then futher load these packages in the current R session. (packages: data.table, plyr)

5. Next, you will be prompted to confirm your working directory. You may choose to reset your working directory. Enter as required.

6. The R script will further checks whether the raw data files exist in the working directory. If it could not detect either the extracted directory or the source data zip file, it will attempt to re-download from the Internet. Upon download completion, it automatically unzip the source data zip file for further processing.

7. During the execution of the script. Status/action messages will be printed on the R session to indicates progress status and stages of the processing/transformation. 

Sample run as below:

```
> source("run_analysis.R")  
Loading packages...  
Loading required package: data.table  
data.table 1.9.4  For help type: ?data.table  
*** NB: by=.EACHI is now explicit. See README to restore previous behaviour.  
Loading required package: plyr  
Getting and cleaning Samsung Smartphone Dataset...  

Work with current directory?    
"C:/zzztemp/R_Resources/Class/03Getting and Cleaning Data/Assignment/tmp"  
Yes or No? y  
Reading activity label...  
Reading training activities...  
Reading testing activities...   
Merging activities...  
Reading training subject...  
Reading testing subject...  
Merging subjects...  
Merging subject and activities...  
Clear obsolete objects...  
Reading features name...  
Reading training features data...  
Reading testing features data...  
Merging features...  
Merging features data and feature names label...  
Filtering Mean and Standard Deviation columns...  
Re-labeling...  
Merging final data set...  
Writing "tidy_alldata.txt" file to current working directory...  
C:/zzztemp/R_Resources/Class/03Getting and Cleaning Data/Assignment/tmp  
Clear obsolete objects...  
Preparing averaged tidy data set...  
Writing "tidy_averaged_bySubjectActivity.txt" file to current working directory...  
C:/zzztemp/R_Resources/Class/03Getting and Cleaning Data/Assignment/tmp  
End processing... 
```



###Output
Upon execution completion of the **`run_analysis.R`** script, two cleaned data files will be generated as output. These files are named as **`tidy_alldata.txt`** and **`tidy_averaged_bySubjectActivity.txt`**. These files are stored in your specified working directory.


###References
For detailed description on the data dictionary and data transformation  process please reference **`CODEBOOK.md`**.

