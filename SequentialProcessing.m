function [TimeTakenSeq] = SequentialProcessing(FileName,HourlyData,NumHours,RadLat,RadLon,RadO3,DataSize1)
%% Function to do sequential processing of model data

Lat = ncread(FileName, 'lat'); % load the latitude locations
Lon = ncread(FileName, 'lon'); % loadthe longitude locations

% The section 'sequential processing' will process the data location one
% after the other, reporting on the time involved.
tic
for idxTime = 1:NumHours % loop through each hour
    fprintf('Processing hour %i\n', idxTime)
    
    % We need to prepare our data for processing. This method is defined by
    % our customer. You are not required to understand this method, but you
    % can ask your module leader for more information if you wish.
    [Data2Process, LatLon] = PrepareData(HourlyData, Lat, Lon);
    
    %% Sequential analysis    
    t1 = toc;
    t2 = t1;
    for idx = 1: DataSize1 %size(Data2Process,1) % step through each data location to process the data
        
        % The analysis of the data creates an 'ensemble value' for each
        % location. This method is defined by
        % our customer. You are not required to understand this method, but you
        % can ask your module leader for more information if you wish.
        [EnsembleVector(idx, idxTime)] = EnsembleValue(Data2Process(idx,:,:,:), LatLon, RadLat, RadLon, RadO3);
        
        % To monitor the progress we will print out the status after every
        % 50 processes.
        if idx/50 == ceil( idx/50)
            tt = toc-t2;
            fprintf('Total %i of %i, last 50 in %.2f s  predicted time for all data %.1f s\n',...
                idx, size(Data2Process,1), tt, size(Data2Process,1)/50*25*tt)
            t2 = toc;
        end
    end
    T2(idxTime) = toc - t1; % record the total processing time for this hour
    fprintf('Processing hour %i - %.2f s\n\n', idxTime, sum(T2));
    
        
end
TimeTakenSeq = toc;

fprintf('Total time for sequential processing = %.2f s\n\n', TimeTakenSeq)
end