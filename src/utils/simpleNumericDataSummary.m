function tableOut = simpleNumericDataSummary(tableIn)
  % simpleNumericDataSummary Computes basic data summary
  % - With float prescision
  % - It only accepts table data with 1 numeric array per col
  % - this assumes that the provided table doe snot need to get
  %   normalized by origin.
  % INPUT:
  %   - tableIn: table of any size, columns must be named
  % OUTPUT:
  %   - tableOut: table with same col names and rows with summary data
  % FUTURE WORK:
  %   - verify that the data contained is all numeric

  %---------------- Function Handling -----------------%
  lTAG = 'simpleNumericDataSummary Function:';
  if(exist('biolocomotionMainVar', 'class')==8)
    fER = @(err) biolocomotionMainVar.lEE(lTAG, err);
  else
    fER = @(err) error([lTAG, ' ', err]);
  end

  %-------------- Verify Function Input ---------------%
  if(~exist('tableIn', 'var'))
    fER('Input table is necesary');
  elseif(~istable(tableIn))
    fER('Input must be a table');
  elseif(isempty(tableIn))
    fER('Input table can not be empty');
  end

  %---------------- Function Variables ----------------%
  % function output table
  tableOut = table();

  % name of all columns (points tracked)
  tnames = tableIn.Properties.VariableNames;

  %------------- Function Implementation ---------------%
  % for every link in node standard compute lenghts
  % this also includes the independent variable, kinda stupid
  %TODO -- does the independent variable belongs here?
  for i = 1: length(tnames)
    tmp = tableIn.(tnames{i});
    % compute basic descriptor for links in standard
    tableOut.(tnames{i}) = [mean(tmp); std(tmp); median(tmp); mode(tmp); min(tmp); max(tmp)];
  end
  % add row names with property
  tableOut.Properties.RowNames = {'mean','std','median','mode', 'min', 'max'};
end
