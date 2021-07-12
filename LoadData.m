function [HourlyData, EnsembleVectorPar] = LoadData(FileName,NumHours)
%%Function to load data from model

% Set Variables
Contents = ncinfo(FileName);

StartLat = 1;
StartLon = 1;
NumLat = 400;
NumLon = 700;

%%Pre-allocate output array memory
% the '-4' value is due to the analysis method resulting in fewer output
% values than the input array.
NumLocations = (NumLon - 4) * (NumLat - 4);
EnsembleVectorPar = zeros(NumLocations, NumHours); % pre-allocate memory

%%Model Data Loading
% Load each hour of the models to be processed
% Model 3 is ignored
for idxTime = 1:NumHours
    DataLayer = 1;
    for idx = [1, 2, 4, 5, 6, 7, 8]
        HourlyData(DataLayer,:,:) = ncread(FileName, Contents.Variables(idx).Name,...
            [StartLon, StartLat, idxTime], [NumLon, NumLat, 1]);
        DataLayer = DataLayer + 1;
    end
    fprintf('Loaded hour %i\n', idxTime)
end

