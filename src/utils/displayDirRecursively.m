function list = displayDirRecursively(tdirectory)
  % displayDirRecursively get a system path and get all directories
  % recursively until 3 layers.
  % A hard limit of layers is important otherwise it will require much mem
  % INPUT: 
  %   - tdirectory: a character array system path
  % OUTPUT:
  %   - list: a cell array of characters of system paths
  % FUTURE WORK:
  %TODO -- accept third input to spesify how many layers deep
  %TODO -- prevent user to input tparentDir, detect who calls this fun

  %---------------- Function Handling -----------------%
  lTAG = 'compressPathNmes Function:';
  if(exist('biolocomotionMainVar', 'class')==8)
    fER = @(err) biolocomotionMainVar.lEE(lTAG, err);
  else
    fER = @(err) error([lTAG, err]);
  end
  
  %-------------- Verify Function Input ---------------%
  if(~ischar(tdirectory))
    fER('Input must be valid array of characters');
  elseif(size(tdirectory,1)~=1)
    fER('Input array must be a 1 row character array');
  end
  
  %---------------- Function Variables ----------------%
  % ignore files that are redundant/pointless
  tignorefilesnames = {'.git'};
  
  %------------- Function Implementation ---------------%
  % make a struct array of this dir and 3 deep subdirs
  ttop         = [dir(tdirectory); dir([tdirectory '\*\*\*'])];
  if(isempty(ttop))
    fER('this is not a valid directory it seems');
  end
  % get the files and directories from the struct above into a cell array
  tdirs        = arrayfun(@(tvar) tvar.folder((length(tdirectory)+1):end), ttop, 'UniformOutput', false);
  tfiles       = arrayfun(@(tvar) tvar.name, ttop, 'UniformOutput', false);
  % remove calls to directories
  tisnotdir    = arrayfun(@(tvar) (~tvar.isdir), ttop, 'UniformOutput', true);
  % ignore useless files
  tignorefiles = (~contains(tdirs,tignorefilesnames));
  % AND result of directories unwanted and directories themselves . and ..
  % append . in case one element is used to run a script
  list = fullfile('.', tdirs(tisnotdir&tignorefiles),tfiles(tisnotdir&tignorefiles));
end