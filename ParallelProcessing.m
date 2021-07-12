function [TimeTaken] = ParallelProcessing(FileName,HourlyData,NumHours,RadLat,RadLon,RadO3,EnsembleVectorPar,DataSize,Workers)
%% 1: Load Data

Lat = ncread(FileName, 'lat');
Lon = ncread(FileName, 'lon');

%% 4: Cycle through the hours and load all the models for each hour and record memory use
% We use an index named 'NumHour' in our loop
% The section 'parallel processing' will process the data location one
% after the other, reporting on the time involved.
tic
for idxTime = 1:NumHours   
    %% 6: Pre-process the data for parallel processing
    % This takes the 3D array of data [model, lat, lon] and generates the
    % data required to be processed at each location.
    % ## This process is defined by the customer ##
    % If you want to know the details, please ask, but this is not required
    % for the module or assessment.
    [Data2Process, LatLon] = PrepareData(HourlyData, Lat, Lon);
   
    
%% Parallel Analysis
    %% 7: Create the parallel pool and attache files for use
    PoolSize = Workers ; % define the number of processors to use in parallel
    if isempty(gcp('nocreate'))
        parpool('local',PoolSize);
    end
    poolobj = gcp;
    % attaching a file allows it to be available at each processor without
    % passing the file each time. This speeds up the process. For more
    % information, ask your tutor.
    addAttachedFiles(poolobj,{'EnsembleValue'});
    
%     %% 8: Parallel processing is difficult to monitor progress so we define a
%     % special function to create a wait bar which is updated after each
%     % process completes an analysis. The update function is defined at the
%     % end of this script. Each time a parallel process competes it runs the
%     % function to update the waitbar.
    DataQ = parallel.pool.DataQueue; % Create a variable in the parallel pool
%     
%     % Create a waitbar and handle top it:
    hWaitBar = waitbar(0, sprintf('Time period %i, Please wait ...', idxTime));
%     % Define the function to call when new data is received in the data queue
%     % 'DataQ'. See end of script for the function definition.
    afterEach(DataQ, @nUpdateWaitbar);
    N = size(Data2Process,1); % the total number of data to process
    p = 20; % offset so the waitbar shows some colour quickly.
    
    %% 9: The actual parallel processing!
    % Ensemble value is a function defined by the customer to calculate the
    % ensemble value at each location. Understanding this function is not
    % required for the module or the assessment, but it is the reason for
    % this being a 'big data' project due to the processing time (not the
    % pure volume of raw data alone).
    T4 = toc;
    parfor idx = 1: DataSize % size(Data2Process,1)
        [EnsembleVectorPar(idx, idxTime)] = EnsembleValue(Data2Process(idx,:,:,:), LatLon, RadLat, RadLon, RadO3);
        send(DataQ, idx);
    end
    
    close(hWaitBar); % close the wait bar
    
    T3(idxTime) = toc - T4; % record the parallel processing time for this hour of data
    fprintf('Parallel processing time for hour %i : %.1f s\n', idxTime, T3(idxTime))
    
end % end time loop
T2 = toc;
delete(gcp);

TimeTaken = sum(T3);

%% 10: Reshape ensemble values to Lat, lon, hour format
%EnsembleVectorPar = reshape(EnsembleVectorPar, 696, 396, []);
fprintf('Total processing time for %i workers = %.2f s\n', PoolSize, sum(T3));

%% 11: ### PROCESSING COMPLETE DATA NEEDS TO BE SAVED  ###

function nUpdateWaitbar(~) % nested function
    waitbar(p/N, hWaitBar,  sprintf('Hour %i, %.3f complete, %i out of %i', idxTime, p/N*100, p, N));
    p = p + 1;
end

end % end function