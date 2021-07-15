function [TimeTakenSeq] = SequentialProcessing(FileName)
%% Function to Analyze data sequentially
% Takes in FileName as file to be processed. Loops through each
% hour and first checks for NaN errors within that hour.
% If it finds a Nan error skips to the next hour, if all is good,
% loads data for that hour and processes it sequentially.
% In the end, returns the total time taken to process the file
% sequentially.

%% Parameters
Contents = ncinfo(FileName);

Lat = ncread(FileName, 'lat'); % load the latitude locations
Lon = ncread(FileName, 'lon'); % load the longitude locations

% Processing parameters provided by customer
RadLat = 30.2016;
RadLon = 24.8032;
RadO3 = 4.2653986e-08;

StartLat = 1; % latitude location to start loading
NumLat = 400; % number of latitude locations to load
StartLon = 1; % longitude location to start laoding
NumLon = 700; % number of longitude locations to load


%% Sequential Analysis
TicSec = tic;
% Loop through each hour
for NumHour = 1:25    
    %% Test hour for NaN errors. 
    % If present, skips hour, if no error is found, the flow continues.
    [NaNErrors] = TestNan(FileName,NumHour);
    if NaNErrors
        fprintf('Skipping Hour %i...\n\n', NumHour)
    else
        %% Data Loading to array HourlyData
        DataLayer = 1; % which 'layer' of the array to load the model data into
        for idx = [1, 2, 4, 5, 6, 7, 8] % model data to load
            % load the model data
            HourlyData(DataLayer,:,:) = ncread(FileName, Contents.Variables(idx).Name,...
                [StartLon, StartLat, NumHour], [NumLon, NumLat, 1]);
            DataLayer = DataLayer + 1; % step to the next 'layer'
        end


        %% Prepare Data
        % Method for processing data definied by the customer
        fprintf('Processing Hour %i\n', NumHour);
        [Data2Process, LatLon] = PrepareData(HourlyData, Lat, Lon);

        
        %% Check Memory usage for hour
        HourDataMem = whos('HourlyData').bytes/1000000;
        fprintf('Memory used for hour of data: %.3f MB\n', HourDataMem)
        

        %% Sequential Processing
        t1 = toc;
        t2 = t1;
        
        % step through each data location to process the data
        for idx = 1: size(Data2Process,1)

            % The analysis of the data creates an 'ensemble value' for each
            % location. This method is defined by customer.
            [EnsembleVector(idx, NumHour)] = EnsembleValue(Data2Process(idx,:,:,:), LatLon, RadLat, RadLon, RadO3);

            % To monitor the progress we will print out the status after every
            % 50 processes.
            if idx/50 == ceil( idx/50)
                tt = toc-t2;
                fprintf('Total %i of %i, last 50 in %.2f s  predicted time for all data %.1f s\n',...
                    idx, size(Data2Process,1), tt, size(Data2Process,1)/50*25*tt)
                t2 = toc;
            end
        end
        T2(NumHour) = toc - t1; % record the total processing time for this hour
        fprintf('Hour %i processed - %.2f s\n\n', NumHour, sum(T2));
        
        
    end
end


%% Record Time Taken
% Records total sequential processing time
TimeTakenSeq = toc(TicSec);
fprintf('Total time for sequential processing = %.2f s\n\n', TimeTakenSeq)


end