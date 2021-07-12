function [TextErrors] = TestText(FileName)
%% Script to examine NetCDF data formats and check for non-numeric values (chars only)

%% Define plain text variable types
DataTypes = {'NC_Byte', 'NC_Char', 'NC_Short', 'NC_Int', 'NC_Float', 'NC_Double'};

%% Test a file
TextErrors = 0;

Contents = ncinfo(FileName); % Store the file content information in a variable.
FileID = netcdf.open(FileName,'NC_NOWRITE'); % open file read only and create handle

for idx = 0:size(Contents.Variables,2)-1 % loop through each variable
    % read data type for each variable and store
    [~, datatype(idx+1), ~, ~] = netcdf.inqVar(FileID,idx);
end

%% display data types
DataInFile = DataTypes(datatype)'

%% find character data types
FindText = strcmp('NC_Char', DataInFile);

%% print results
fprintf('Testing file: %s\n', FileName)
if any(FindText)
    TextErrors = 1;
    fprintf('Error, text variables present.\n')
else
    fprintf('All data is numeric, continue analysis.\n')
end

end

