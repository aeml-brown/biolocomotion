function [listFiles, listDirs] = displayDirRecursively(tdirectory, tlayers)
  % displayDirRecursively get a system path and get all directories
  % recursively until tlayers layers.
  % A hard limit of layers is important otherwise it will require much mem
  % INPUT: 
  %   - tdirectory: a character array system path
  % OUTPUT:
  %   - list: a cell array of characters of system paths
  % FUTURE WORK:
  %

  %---------------- Function Handling -----------------%
  lTAG = 'compressPathNmes Function:';
  if(exist('biolocomotionMainVar', 'class')==8)
    fER = @(err) biolocomotionMainVar.lEE(lTAG, err);
  else
    fER = @(err) error([lTAG, ' ', err]);
  end
  
  %-------------- Verify Function Input ---------------%
  if(~ischar(tdirectory))
    fER('Input must be valid array of characters');
  elseif(size(tdirectory,1)~=1)
    fER('Input array must be a 1 row character array');
  end
  
  if(~exist('tlayers', 'var')||~isscalar(tlayers))
    tlayers = 1;
  elseif(tlayers < 1)
    tlayers = 1;
  elseif(tlayers > 4)
    tlayers = 4;
  end
  
  %---------------- Function Variables ----------------%
  % ignore files that are redundant/pointless
  tignorefilesnames = {'.gitignore'};
  tignoredirsnames  = {'.git'};
  listFiles = [];
  listDirs  = [];
  
  %------------- Function Implementation ---------------%
  for(i = 1: tlayers)
    % start with one layer deep then repeat until tlayers
    twildcard = repmat('\*',1,i);
    % make a struct array of this dir and tlayers deep subdirs
    ttop = dir([tdirectory, twildcard]);
    if(isempty(ttop))
      fER('this is not a valid directory it seems');
    end
    % get the files and directories from the struct above into a cell array
    tdirs        = arrayfun(@(tvar) tvar.folder((length(tdirectory)+1):end), ttop, 'UniformOutput', false);
    tfiles       = arrayfun(@(tvar) tvar.name, ttop, 'UniformOutput', false);
    % remove calls to directories
    tisnotdir    = arrayfun(@(tvar) (~tvar.isdir), ttop, 'UniformOutput', true);
    % ignore useless files
    tignorefiles = (~contains(tfiles,tignorefilesnames));
    tignoredirs  = (~contains(tfiles,tignoredirsnames));
    % AND result of directories unwanted and directories themselves . and ..
    % append . in case one element is used to run a script
    listFiles = [listFiles; fullfile('.', tdirs(  tisnotdir &(tignorefiles&tignoredirs)),tfiles(  tisnotdir &(tignorefiles&tignoredirs)))];
    listDirs  = [listDirs ; fullfile('.', tdirs((~tisnotdir)&(tignorefiles&tignoredirs)),tfiles((~tisnotdir)&(tignorefiles&tignoredirs)))];
    % remove this dir . and parent dir .. recrusively
    listDirs  = listDirs(~contains(listDirs, {'\.', '\..'}));
  end
  % eliminate name repeats
  listDirs  = unique(listDirs);
  listFiles = unique(listFiles);
end
