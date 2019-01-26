function listComp = compressPathNmes(listExt)
  %TODO -- i should accept a scalar to determine the lengt of \123
  % initialise as an empty cell array
  listComp = {};
  % find all the indices where \ is found
  %TODO -- this is different for other systems
  tindex = strfind(listExt, '\');
  
  % for every element of array 
  for i = 1: length(listExt)
    % get the information for this cell array
    tname = listExt{i};
    tinx  = tindex{i};
    
    % find all the \ and the next letter, if it is the last \ then get full
    % name of element
    tfullnameindex = sort([tinx(1:(end-1)),tinx(1:(end-1))+1, (tinx(end):length(tname))]);
    
    % append to list
    listComp = [listComp; tname(tfullnameindex)];
  end
end