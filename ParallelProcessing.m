function [TimeTakenPara] = ParallelProcessing(FileName, NumWorkers)
%% Function to Analyze data with multiple workers
% Takes in FileName as file to be processed. Loops through each
% hour and first checks for NaN errors within that hour.
% If it finds a Nan error skips to the next hour, if all is good,
% loads data for that hour and processes it sequentially.
% In the end, returns the total time taken to process the file.

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
NumHours = 25;% number of hours to process


%% Pre-allocate output array memory
% the '-4' value is due to the analysis method resulting in fewer output
% values than the input array.
NumLocations = (NumLon - 4) * (NumLat - 4);
EnsembleVectorPar = zeros(NumLocations, NumHours); % pre-allocate memory


%% Parallel Analysis
TicPara = tic;
% Loop through each hour
for idxTime = 1:25  
    %% Test hour for NaN errors. 
    % If present, skips hour, if no error is found, the flow continues.
    [NaNErrors] = TestNan(FileName,idxTime);
    if NaNErrors
        fprintf('Skipping Hour %i...\n\n', idxTime)
    else
        %% Data Loading to array HourlyData
        DataLayer = 1; % which 'layer' of the array to load the model data into
        for idx = [1, 2, 4, 5, 6, 7, 8] % model data to load
            % load the model data
            HourlyData(DataLayer,:,:) = ncread(FileName, Contents.Variables(idx).Name,...
                [StartLon, StartLat, idxTime], [NumLon, NumLat, 1]);
            DataLayer = DataLayer + 1; % step to the next 'layer'
        end


        %% Prepare Data
        % Method for processing data definied by the customer
        fprintf('Processing hour %i\n', idxTime)
        [Data2Process, LatLon] = PrepareData(HourlyData, Lat, Lon);


        %% Check Memory usage for hour
        HourDataMem = whos('HourlyData').bytes/1000000;
        fprintf('Memory used for hour of data: %.3f MB\n', HourDataMem)


        %% Parallel Processing
        % Create the parallel pool and attache files for use
        PoolSize = NumWorkers; % define the number of processors to use in parallel
        if isempty(gcp('nocreate'))
            parpool('OverDrive',PoolSize);
        end
        poolobj = gcp;
        addAttachedFiles(poolobj,{'EnsembleValue'});

        T4 = toc;
        % The actual parallel processing!
        % The analysis of the data creates an 'ensemble value' for each
        % location. This method is defined by customer.
        parfor idx = 1: 250%size(Data2Process,1)
            [EnsembleVectorPar(idx, idxTime)] = EnsembleValue(Data2Process(idx,:,:,:), LatLon, RadLat, RadLon, RadO3);
        end

        T3(idxTime) = toc - T4; % record the parallel processing time for this hour of data
        fprintf('Parallel processing time for hour %i : %.1f s\n\n', idxTime, T3(idxTime))
        
        
    end
end


%% Record Time Taken
% Records total sequential processing time
TimeTakenPara = toc(TicPara);
fprintf('Total processing time for %i workers = %.2f s\n\n', NumWorkers, TimeTakenPara);

delete(gcp);

%% Reshape ensemble values to Lat, lon, hour format
EnsembleVectorPar = reshape(EnsembleVectorPar, 696, 396, []);

end