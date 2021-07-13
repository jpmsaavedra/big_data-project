%% Main Script of the Program

clear all
close all

%% Data Files
FileName = 'Model\o3_surface_20180701000000.nc';
FileErrorText = 'TestFileText.nc';
FileErrorNan = 'TestFileNan.nc';

%% Editable Variables 
NumHours = 25;
Data = [2500, 5000, 10000]; %Size of data to process. Use size(Data2Process,1) to use all data
PoolValues = [2, 3, 4, 5, 6]; %Number of workers to use

%Costumer defined values
RadLat = 30.2016;
RadLon = 24.8032;
RadO3 = 4.2653986e-08;

%% Program flow
[TextErrors] = TestText(FileName);
[NanErrors] = TestNan(FileName);
if TextErrors || NanErrors
    fprintf('Loading and proccessing of data stopped.\n')
else
    fprintf('Proceeding with loading and processing.\n')
    [HourlyData, EnsembleVectorPar] = LoadData(FileName,NumHours);
    
    SeqGraphData = [];
    for idxData1 = 1: length(Data)
        DataSize1 = Data(idxData1);
        [TimeTakenSeq] = SequentialProcessing(FileName,HourlyData,NumHours,RadLat,RadLon,RadO3,DataSize1);
        SeqGraphData = [SeqGraphData; DataSize1, TimeTakenSeq];
    end
    writematrix(SeqGraphData,'SeqGraphData.xls')
    
    ParaGraphData = [];
    for idxData = 1: length(Data)
        DataSize = Data(idxData);
        for idxPool = 1: length(PoolValues)
            Workers = PoolValues(idxPool);
            [TimeTakenPara] = ParallelProcessing(FileName,HourlyData,NumHours,RadLat,RadLon,RadO3,EnsembleVectorPar,DataSize,Workers);
            ParaGraphData = [ParaGraphData; Workers, DataSize, TimeTakenPara];
        end
    end
    writematrix(ParaGraphData,'ParaGraphData.xls') 
end