%% Main Script of the Program

clear all
close all

%% Data Files
FileName = 'o3_surface_20180701000000.nc';
FileErrorText = 'TestFileText.nc';
FileErrorNan = 'TestFileNan.nc';

%% Editable Variables 
NumHours = 25;
Data = [5, 50];
PoolValues = [1, 2, 3, 4];

RadLat = 30.2016;
RadLon = 24.8032;
RadO3 = 4.2653986e-08;

%% Program flow
%
[TextErrors] = TestText(FileName);
[NanErrors] = TestNan(FileName);
if TextErrors || NanErrors
    fprintf('Loading and proccessing of data stopped.\n')
else
    fprintf('Proceeding with loading and processing.\n')
    [HourlyData, EnsembleVectorPar] = LoadData(FileName,NumHours);
    %SequentialProcessing(FileName,HourlyData,NumHours,RadLat,RadLon,RadO3);
    
    GraphData = [];
    for idxData = 1: length(Data)
        DataSize = Data(idxData);
        for idxPool = 1: length(PoolValues)
            Workers = PoolValues(idxPool);
            [TimeTaken] = ParallelProcessing(FileName,HourlyData,NumHours,RadLat,RadLon,RadO3,EnsembleVectorPar,DataSize,Workers);
            GraphData = [GraphData; Workers, DataSize, TimeTaken];
        end
    end
    writematrix(GraphData,'GraphData.xls') 
end