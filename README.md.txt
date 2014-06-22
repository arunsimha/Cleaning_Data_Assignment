## How to run the script
## Arun Simha


PRELIMINARY STEPS:
Example below illustrates a windows 8.1 64-bit machine.
Download the run_analysis.R script to a
local directory. 
In my case it is named C:/Users/Arun/Documents/project"
Edit dataDir appropriately. 
Uncomment the dowload.file lines if you are running this step.
I used a previously dowloaded and unzipped file.

Open RStudio (Version 0.98.507 in my case)
Type > install.packages("reshape2") if you do not have this package installed.
In RStudio, set working directory to the local directory above.

RUNNING PROGRAM:
Open run_analysis.R
Check Source on Save box
Hit the "Save" button.
This sources and runs the file

RESULTS:
Check that two files are produced in the local directory.
tidyData_part4
averageTidyData_part5 

Good luck
Arun
