%% Plotting graphs in Matlab
clear all
close all

%% Time Values
% 500
x500Vals = [1,2,3,4,5,6,7,8];
y500Vals = [156,158,115,93,82,79,75,68];

% 1000
x1000Vals = [1, 2, 3, 4, 5, 6, 7, 8];
y1000Vals = [309,295,212,162,135,124,119,112];

% 2500
x2500Vals = [1, 2, 3, 4, 5, 6, 7, 8];
y2500Vals = [893,825,568,432,347,293,261,248];

% All Data
xAllVals = [1, 5, 6, 7, 8];
yAllVals = [110000,36397,29699,25202,23983];


%% Show two plots on different y-axes
%% 500 data processed
figure(1)
yyaxis left
plot(x500Vals, y500Vals, '-c')
xlabel('Number of Processors')
ylabel('Processing time (s)')
title('Processing time vs number of processors')


%% All data processed
figure(1)
yyaxis right
plot(xAllVals, yAllVals, '-b')
xlabel('Number of Processors')
ylabel('Processing time (s)')
title('Processing time vs number of processors')


legend('500 Data', 'All Data')

   
%% Show multiple plots on same y-axis
%% Mean processing time

y500MeanVals = y500Vals / 500;
y1000MeanVals = y1000Vals / 1000;
y2500MeanVals = y2500Vals / 2500;
yAllMeanVals = yAllVals / 277804;

figure(2)
plot(x500Vals, y500MeanVals, '-c')
hold on
plot(x1000Vals, y1000MeanVals, '-r')
hold on
plot(x2500Vals, y2500MeanVals, '-g')
hold on
plot(xAllVals, yAllMeanVals, '-b')
xlabel('Number of Processors')
ylabel('Processing time (s)')
title('Mean Processing time vs number of processors')
legend('500 Data', '1,000 Data', '2,500 Data', 'All Data')