function list = displayDirRecursively(tdirectory, tparentDir)
  % ignore files that are redundant/pointless
  tignorefiles = {'.'; '..'; '.git'};
  
  % initialise list as an empty array and this directory
  list = {};
  ttop = dir(tdirectory);
  
  % append current directory with parent directory sent to funcion
  % unless it is the first call to this function
  if(~exist('tparentDir','var'))
    tparentDir = '';
  else
    % extract the contents to get path
    tcontents = struct2cell(ttop);
  
    % get the name of the current directory
    tdirname = char(tcontents(2,1));
    tmp = strfind(tdirname,'\');
    tparentDir = [tparentDir, '\', tdirname((tmp(end)+1):end)];
  end

  % get the name of the files and append the concatenated directory chain
  tfiles = struct2cell(ttop(~[ttop.isdir]));
  tfiles = tfiles(1,:)';
  tfiles = strcat(tparentDir, '\', tfiles);

  %get the names of all the directories in this chain to feed the for
  tdirectories = struct2cell(ttop([ttop.isdir]));
  tdirectories = tdirectories(1,:)';
  tdirectories = setdiff(tdirectories,tignorefiles);

  % first append the files found so far
  list = [list; tfiles];

  % then go into all the subdirectories and call this function recursively
  for i =1: length(tdirectories)
    result = displayDirRecursively(fullfile(tdirectory,tdirectories{i}),tparentDir);
    list = [list; result];
  end
end