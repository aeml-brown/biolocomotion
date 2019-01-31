function listComp = compressPathNmes(listExt)
<<<<<<< HEAD
  % compressPathNmes cmpresses the path that outputs from 
  % displayDirRecursively function such that:
  % /dir/to/my/local/directory, outputs:
  % /d/t/m/l/d/
  % INPUT: 
  %   - listExt: a cell array of characters of system paths
  %       it must contain at least one / indicator
  % OUTPUT:
  %   - listComp: a cell array of characters of system paths
  % FUTURE WORK:
  %TODO -- accept input arg 'lenght' and use it to control how many
  %TODO -- characters are displaied instead of default one
  %TODO -- make sure it works in any system
  %TODO -- if(isempty(tindex{1})) is not roubust

  %---------------- Function Handling -----------------%
  lTAG = 'compressPathNmes Function:';
  if(exist('biolocomotionMainVar', 'class')==8)
    fER = @(err) biolocomotionMainVar.lEE(lTAG, err);
  else
    fER = @(err) error([lTAG, ' ', err]);
  end
  
  %-------------- Verify Function Input ---------------%
  if(~iscellstr(listExt))
    fER('Input must be valid cell array of characters');
  elseif(size(listExt,2)~=1)
    fER('Input array must be a 1 column cell array');
  end
  
  %---------------- Function Variables ----------------%
  % start array empty to improve speed.
  listComp = cell(length(listExt),1);
  % find all the indices where \ is found
  tindex = strfind(listExt, '\');

  if(isempty(tindex{1}))
    fER('The list must contain at least one / or \ char to be a path');
  end
  
  %------------- Function Implementation ---------------%
=======
  %TODO -- i should accept a scalar to determine the lengt of \123
  % initialise as an empty cell array
  listComp = {};
  % find all the indices where \ is found
  %TODO -- this is different for other systems
  tindex = strfind(listExt, '\');
  
>>>>>>> 325b514e76b217d4054d622cdbf8fe0bd7b9f298
  % for every element of array 
  for i = 1: length(listExt)
    % get the information for this cell array
    tname = listExt{i};
    tinx  = tindex{i};
    
<<<<<<< HEAD
    % find all the \ and the next letter
    % if it is the last \ then get full name of element
    tfullnameindex = sort([tinx(1:(end-1)),tinx(1:(end-1))+1, (tinx(end):length(tname))]);
    
    % append to list
    listComp{i} = tname(tfullnameindex);
  end
end
=======
    % find all the \ and the next letter, if it is the last \ then get full
    % name of element
    tfullnameindex = sort([tinx(1:(end-1)),tinx(1:(end-1))+1, (tinx(end):length(tname))]);
    
    % append to list
    listComp = [listComp; tname(tfullnameindex)];
  end
end
>>>>>>> 325b514e76b217d4054d622cdbf8fe0bd7b9f298
