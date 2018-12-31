classdef bioLinkage < biolocomotionMainVar & handle
% instructions
%
% CONSTRUCTOR:
%    function o = bioLinkage()
%

%------------------------------------------------------------%
%                      PROPERTIES                            %
%------------------------------------------------------------%

  properties(Access=private)
    lTAG = "BioLinkage Class: ";
  end

  properties %TODO -- some of these should not be public
    name    = '';
    joints;
    links;
    origin = bioJoint("body-origin");%TODO -- ideally there should be annother body class that defines origin and offset to first link
  end

%------------------------------------------------------------%
%                      CONSTRUCT                             %
%------------------------------------------------------------%
  methods
    function o = bioLinkage(tname)
      o.lD(o.lTAG, "init constructor");
      if(nargin~=1)
        o.lE(o.lTAG, "name, base joint, and mode need to be initialized");
        error("");
      end
      o.name = tname;
      
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
        o.lE(o.lTAG, "invalid name"); %TODO -- this should be inside a try and catch
      end
    end



%------------------------------------------------------------%
%                    CLASS FUNCTIONS                         %
%------------------------------------------------------------%

    function addJoints(o, varargin)
      for i = 1:nargin-1
        if(class(varargin{i})~='bioJoint')%TODO -- this trows error when not true because array is not of same size not only because it does not match the arg
          o.lE(o.lTAG, "this is not a bioJoint class object");
          error("");
        else
          o.joints = [o.joints; varargin{i}];
        end
      end
    end


    function addLinks(o, varargin)
      for i = 1:nargin-1
        if(class(varargin{i})~='bioLink')%TODO -- this trows error when not true because array is not of same size not only because it does not match the arg
          o.lE(o.lTAG, "this is not a bioLink class object");
          error("");
        else
          o.links = [o.links; varargin{i}];
        end
      end
    end


  end %methods
end %bioLinkClass
