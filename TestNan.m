function [NaNErrors] = TestNan(FileName,NumHour)
%% Script to examine NetCDF and check for NaN values

%% Parameters
Contents = ncinfo(FileName); % Store the file content information in a variable.

StartLat = 1;
StartLon = 1;

NaNErrors = 0;


%% Load model layers to test     
for idxModel = 1:8
    Data(idxModel,:,:) = ncread(FileName, Contents.Variables(idxModel).Name,...
        [StartLat, StartLon, NumHour], [inf, inf, 1]);
end


%% Check for NaNs
% Check if any NaN value is present.
% Prints result and stores it in NaNErrors variable.
fprintf('Testing hour for NaNs...\n')
if any(isnan(Data), 'All')
    fprintf('NaNs present during hour %i\n', NumHour)
    NaNErrors = 1;
else
    fprintf('No NaNs present on hour %i!\n', NumHour)
end
    
end