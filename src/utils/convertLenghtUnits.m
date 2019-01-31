function arrayOut = convertLenghtUnits(tinarray, tfrom, tto)
  % convertLenghtUnits Converts common units of lenght
  % - Fast and to the point, with float prescision
  % - It only accepts common units of biomechanics
  % - Inputs are case insensitive
  % - Acceptable inputs: m, cm, mm, um, in, ft.
  % INPUT: 
  %   - tinarray: numeric array of tfrom current units
  %   - tfrom:    a character array of valid unit name 
  %   - tto:      a character array of valid unit name
  % OUTPUT:
  %   - arrayOut: numeric array of tto current units
  % FUTURE WORK:
  %TODO -- accept input arg 'custom' and make third input a gain
  %TODO -- accept input argument to force reload of persistent vars

  %---------------- Function Handling -----------------%
  lTAG = 'convertLenghtUnits Function:';
  if(exist('biolocomotionMainVar', 'class')==8)
    fER = @(err) biolocomotionMainVar.lEE(lTAG, err);
  else
    fER = @(err) error([lTAG, ' ', err]);
  end
  
  %------------ Preallocated Fun Variables ------------%
  % will take time the first time the table is lodaded
  persistent tconvertTable;
  persistent tacceptableInputs;
  if(isempty(tconvertTable) && isempty(tacceptableInputs))
    try
      % get variable names just the first time this function is excecuted
      tconvertTable = readtable('.\res\unitConversionTable\unitConversionTable.xlsx','ReadRowNames',true);
      tacceptableInputs = tconvertTable.Properties.VariableNames;
    catch
      fER('Error loading the conversion table');
      clear('tconvertTable', 'tacceptableInputs');
    end
  end
  
  %-------------- Verify Function Input ---------------%
  if(~exist('tfrom', 'var') || ~exist('tto', 'var'))
    fER(['Conversion units for FROM and TO fields must be included: ' strjoin(tacceptableInputs, ', ')]);
  elseif(~strcmpi(tfrom,tacceptableInputs) & ~strcmpi(tto,tacceptableInputs))
    fER(['Input must be valid: ' strjoin(tacceptableInputs, ', ')]);
  elseif(isempty(tinarray))
    fER('Input array cannot be empty');
  elseif(~isnumeric(tinarray))
    fER('Input array must be numeric');
  end
  
  %------------- Function Implementation ---------------%
  % find index of to and from conversion
  tforminx = strcmpi(tacceptableInputs,tfrom);
  ttoindx  = strcmpi(tacceptableInputs,tto);
  % output array converted
  arrayOut = tinarray*tconvertTable{tforminx,ttoindx};
end

