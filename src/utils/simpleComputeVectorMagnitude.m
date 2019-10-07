function tableOut = simpleComputeVectorMagnitude(tableIn, nodeStd)
  % simpleComputeVectorMagnitude Computes magnitude of 3d data
  % - Fast and to the point, with float prescision
  % - It only accepts table data with 3 elements
  % - This assumes that there is no error in the origin of standard
  %   tracking. If there is error in the tracking of origin, then that
  %   error will be propagated to links. So use this with that caviat
  % INPUT:
  %   - tableIn: table of any size, columns must be named
  %         coumns must be of [x y z] triplets
  % OUTPUT:
  %   - tableOut: table with same col names and lenghts of links
  % FUTURE WORK:
  %TODO -- accept some form of error margin or correction for the origin tracking
  %TODO -- so that it does not get propagated. At least give some confidence interval
  %TODO -- check that the data in table is numeric
  %TODO -- accept entry on relative to origin?
  %TODO -- how is sample number removed? look at modifycoordinategui

  %---------------- Function Handling -----------------%
  lTAG = 'simpleComputeVectorMagnitude Function:';
  if(exist('biolocomotionMainVar', 'class')==8)
    fER = @(err) biolocomotionMainVar.lEE(lTAG, err);
  else
    fER = @(err) error([lTAG, ' ', err]);
  end

  %-------------- Verify Function Input ---------------%
  if(~exist('tableIn', 'var') | ~exist('nodeStd', 'var'))
    fER('Input table and node stadndard are necesary');
  elseif(~istable(tableIn))
    fER('Input must be a table');
  elseif(isempty(tableIn))
    fER('Input table can not be empty');
  elseif(~isa(nodeStd, 'bioLinkage'))
    fER('Input node standard should be of a bioLinkage type');
  end

  %---------------- Function Variables ----------------%
  % function output table
  tableOut = table();

  % name of all columns (points tracked)
  tnames = tableIn.Properties.VariableNames;

  % edges will match data from table, get node1_node2 and name
  tedges = nodeStd.graph.Edges.EndNodes;
  tlinknames = nodeStd.graph.Edges.Name;

  % make sure link lenghts are in body coordinate frame
  % this assumes that there is no error in the origin tracking
  torigin = tableIn.(nodeStd.graph.Nodes.Name{nodeStd.graph.Nodes.Origin});

  %------------- Function Implementation ---------------%
  % remove magnitude of body coordinate frame
  % ignore first column as it is the independent var
  %for i = 2 : length(tnames)
  %  tableIn.(tnames{i}) = tableIn.(tnames{i}) - torigin;
  %end

  % create dimension of table with independent variable
  tableOut.(tnames{1}) = tableIn.(tnames{1});

  % for every link in node standard compute lenghts
  for i = 1: size(tedges,1)
    tdist = tableIn.(tedges{i,2}) - tableIn.(tedges{i,1});
    tableOut.(tlinknames{i})  = sqrt(tdist(:,1).^2 + tdist(:,2).^2 + tdist(:,3).^2);
  end
end
