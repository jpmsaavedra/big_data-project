%% Main Script of the Program
% Script to automate testing of an .nc file and compare time taken for
% sequential processing and parallel processing, with different number 
% of workers.
 
clear all
close all


%% Parameters
FileName =  'Model\o3_surface_20180701000000.nc';

% Only used to test text and NaN errors handling
FileErrorText = 'TestFileText.nc';
FileErrorNan = 'TestFileNan.nc';   

NumWorkers = [2,3,4,5,6,7,8]; % Number of workers to test
TimeTakenTable = [];          % Table to store time taken


%% Main Program flow
% Test file for text errors and carry on with sequential and processing of
% data sequentially and in parallel, recording time taken in a spreadsheet

TicStart = tic;
%% Text test
% Test file for text errors on variables
[TextErrors] = TestText(FileName);
if TextErrors
    fprintf('Program Stopped.\n\n')
else
    fprintf('Proceeding with processing.\n\n')

    
    %% Sequential Processing of data
    % Call SequentialProcessing function, returning time taken
    [TimeTakenSeq] = SequentialProcessing(FileName);
    % Append time taken to table
    TimeTakenTable = [TimeTakenTable; 1, TimeTakenSeq];

    
    %% Parallel Processing of data
    % Loop trough every number of workers and do parallel processing of
    % data until there is no more workers to test
    for idxPool = 1: length(NumWorkers)
        Workers = NumWorkers(idxPool);
        % Call ParallelProcessing function, returning time taken
        [TimeTakenPara] = ParallelProcessing(FileName,Workers);
        % Append time taken for every number of workers to table
        TimeTakenTable = [TimeTakenTable; Workers, TimeTakenPara];
    end

    
    %% Record Time Taken
    % Write time taken data from table on a spreadsheet
    writematrix(TimeTakenTable,'TimeTaken.xls')       
end


%% End of program
% Show overall time taken
TocEnd = toc(TicStart);
fprintf('Complete Analysis finished in %.1f s\n', TocEnd);