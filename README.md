# Big Data Programming Project - 5011CEM

Program to analyze benefits of parallel processing over sequential processing of a big data file.

## Description

Program developed in MATLAB to analyze a .nc file. Checks the file for errors, loads it in chunks 
into memory and processes it sequentially and in parallel. In the end it records data of the time
taken in each step into a spreadsheet file.    

## Getting Started

### Dependencies

* MATLAB R2020a or newer
    * Toolboxes used:
        * Statistics and Machine Learning Toolbox. version 11.7
        * Parallel Computing Toolbox. version 7.2

### Installing and Usage

* Files to be analyzed should be on Model folder
* Spreadsheet file should be saved elsewhere before starting the program again

### Executing Program

* To start the program run the script Main.m on MATLAB
* To change the file to use, put the name of the file in the FileNane variable
* To customize the number of workers to use, modify NumWorkers array to the desired values

## Author

Joao Saavedra - 8965518
monteir4@uni.coventry.ac.uk