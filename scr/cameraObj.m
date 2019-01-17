classdef cameraObj < biolocomotionMainVar & handle
% instructions
%
% CONSTRUCTOR:
%    function o = cameraOnj()
%

%------------------------------------------------------------%
%                      PROPERTIES                            %
%------------------------------------------------------------%

  properties(Access=public, Constant=true)
    transParam = struct('dlt','dlt','exin','exin');
  end

  properties(Access=private, Constant=true)
    lTAG = 'CameraObject Class:';
  end

  properties(Access=public, Constant=false) %TODO -- some of these should not be public
    % camera and camera object name
    name   = '';

    % either DLT or Extrinsic-Intrinsic parameters
    transType;

    % image size in pixels
    sensorSize   = [0; 0];

    % extrinsic parameters for camera transform
    translation = zeros(3,1);
    rotation    = zeros(3,3);

    % intrinsic parameters for camera transform
    % intr..Corr considers indexing (usually zero) and axis flipping (usually down) convensions
    % to work with matlab index of 1 and y is 'up' possitive"
    % axis corr gets multiplied, index is added to [R, t; 0, 0, 1] = intrMat
    intrMat       = zeros(3,3);
    intrAxisCorr  = [1, 1; 1, -1];
    intrIndexCorr = [1;1];

    % direct linear transformation vector
    dltParam    = zeros(11,1);

    % extra data such as camera model, etc. user defined
    metadata    = struct();
  end

%------------------------------------------------------------%
%                      CONSTRUCT                             %
%------------------------------------------------------------%
  methods
    function o = cameraObj(tname, ttransParam)
      o.lD(o.lTAG, 'init constructor');
      if(nargin~=2)
        o.lE(o.lTAG, 'name, and type of parameters need to be initialized');
      else
        o.name = tname;
        o.transType = ttransParam;
      end
    end

%------------------------------------------------------------%
%                     CLASS SETS                             %
%------------------------------------------------------------%
    % joint name should not be an empty string
    function o = set.name(o, tname)
      if (ischar(tname) & ndims(tname)==2 & size(tname,1)==1 & ~isempty(tname))
        o.name = tname;
        %TODO -- check that the name is different from the attached joint's name
      else
        o.lE(o.lTAG, 'invalid name'); %TODO -- this should be inside a try and catch
      end
    end
%------------------------------------------------------------%

    function o = set.transType(o, ttransParam)
      try
        o.transType = o.transParam.(ttransParam);
      catch
        o.lE(o.lTAG, 'invalid camera type');
      end
    end
%------------------------------------------------------------%

    function o = set.sensorSize(o, tsensorSize)
      if(size(tsensorSize)~=[2,1] & isnumeric(tsensorSize) & isreal(tsensorSize))
        o.lE(o.lTAG, 'image (sensor) size must be a 2 element column vector');
      else
        o.sensorSize = tsensorSize;
      end
    end
%------------------------------------------------------------%

    function o = set.translation(o, ttranslation)
      if(size(ttranslation)~=[3,1] & isnumeric(ttranslation) & isreal(ttranslation))
        o.lE(o.lTAG, 'translation must be a 3 element column vector');
      else
        o.translation = ttranslation;
      end
    end
%------------------------------------------------------------%

    function o = set.rotation(o, trotation)
      if(size(trotation)~=[3,3] & isnumeric(trotation) & isreal(trotation))
        o.lE(o.lTAG, 'rotation must be a 3-by-3 element matrix');
      else
        o.rotation = trotation;
      end
    end
%------------------------------------------------------------%

    function o = set.intrMat(o, tintrMat)
      if(size(tintrMat)~=[3,3] & isnumeric(tintrMat) & isreal(tintrMat))
        o.lE(o.lTAG, 'intrinsic matrix must be a 3-by-3 element matrix');
      else
        o.intrMat = tintrMat;
      end
    end
%------------------------------------------------------------%

    function o = set.intrAxisCorr(o, tintrAxisCorr)
      %TODO -- this needs more error correction to make sure that it is only 1 and -1 diagonal
      if(size(tintrAxisCorr)~=[2,2] & isnumeric(tintrAxisCorr) & isreal(tintrAxisCorr))
        o.lE(o.lTAG, 'intrinsic matrix axis correction must be a 2-by-2 element matrix');
      else
        o.intrAxisCorr = tintrAxisCorr;
      end
    end
%------------------------------------------------------------%

    function o = set.intrIndexCorr(o, tintrIndexCorr)
      %TODO -- more error correction, this will always be 1 or 0? also both the same
      if(size(tintrIndexCorr)~=[2,1] & isnumeric(tintrIndexCorr) & isreal(tintrIndexCorr))
        o.lE(o.lTAG, 'intrinsic matrix index correction must be a 2 element column vector');
      else
        o.intrIndexCorr = tintrIndexCorr;
      end
    end
%------------------------------------------------------------%

    function o = set.dltParam(o, tdltParam)
      if(size(tdltParam)==size(o.dltParam) & isnumeric(tdltParam))
        o.dltParam = tdltParam;
      else
        o.lE(o.lTAG, 'DLT must be a row array of 11 numeric values');
      end
    end
%------------------------------------------------------------%

% set function for metadata is not needed, its an optional property
% and its behaviour for appending and rewritting data is not propper with a set func
% TODO -- probably a struct funcion will permit the use of this, but what is the point?
%    function o = set.metadata(o, tmetadata)
%        o.metadata = tmetadata;
%    end

%------------------------------------------------------------%
%                    CLASS FUNCTIONS                         %
%------------------------------------------------------------%

    function addMetadata(o, tmetadata, varargin)
      % force write options
      defaultWrite = 'y';
      forceWriteOptions = {'y','f','n'};
      forceWrite = {'y', 'f'};

      % do error checking for optional input forceWrite
      if(length(varargin)>1)
        o.lE(o.lTAG, 'too many input arguments');
      elseif(length(varargin)==0)
        twrite = defaultWrite;
      elseif(~ismember(varargin{1}, forceWriteOptions))
        o.lE(o.lTAG, ['optional third input forceWrite can only have the values ' strjoin(forceWriteOptions, ', ')]);
      else
      twrite = varargin{1};
      end

      % do error checking for tmetadata variable
      if(~isstruct(tmetadata) & length(tmetadata)~=1)
        o.lE(o.lTAG, 'the input argument must be a one dimensional struct');
      end

      % if the user wants to force write, then copy the values entirely
      if(ismember(twrite, forceWrite))
        o.metadata = tmetadata;

      % otherwise, just copy the values that are new
      else
        % get the field names that will be copied and the ones that are repeated
        tinfields = fieldnames(tmetadata);
        tcurfields = fieldnames(o.metadata);
        taddfields = tinfields(~contains(tinfields, tcurfields));
        tnoaddfields = tinfields(contains(tinfields, tcurfields));

        %copy the unique values
        for(tnewfield = taddfields)
          o.metadata.(char(tnewfield)) = tmetadata.(char(tnewfield));
        end

        % display a wargning for the values that will not be added because a copy of them already exist
        o.lW(o.lTAG, ['exsisting values found. Fields that wont be written: ' strjoin(tnoaddfields)]);
        end
    end
%------------------------------------------------------------%

    function addMetadataField(o, tdataname, tdata, varargin)
      % force write options
      defaultWrite = 'y';
      forceWriteOptions = {'y','f','n'};
      forceWrite = {'y', 'f'};

      % do error checking for optional input forceWrite
      if(length(varargin)>1)
        o.lE(o.lTAG, 'too many input arguments');
      elseif(length(varargin)==0)
        twrite = defaultWrite;
      elseif(~ismember(varargin{1}, forceWriteOptions))
        o.lE(o.lTAG, ['optional third input forceWrite can only have the values ' strjoin(forceWriteOptions, ', ')]);
      elseif(~isvarname(tdataname))
        o.lE(o.lTAG, 'the dataname field must be a valid matlab varialbe name');
      else
      twrite = varargin{1};
      end

      % do error checking for  tdata
      %TODO -- fill this if statement
      % if the user wants to force write, then copy the values entirely
      if(ismember(twrite, forceWrite))
        o.metadata.(tdataname) = tdata;

      % otherwise, just copy the values that are new
      else
        % check if the value does not exsist
        if(~ismember(tdataname, fieldnames(o.metadata)))
          o.metada.(tdataname) = tdata;
        else
        % display a message for the values that will not be added because a copy of them already exist
        o.lD(o.lTAG, ['exsisting values found. Fields that wont be written: ' tdataname]);
        end
      end
    end
%------------------------------------------------------------%

  end %methods
end %bioLinkClass
