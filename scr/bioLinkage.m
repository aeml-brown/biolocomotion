classdef bioLinkage < biolocomotionMainVar & handle
% instructions
%
% CONSTRUCTOR:
%    function o = bioLinkage()
%

%------------------------------------------------------------%
%                      PROPERTIES                            %
%------------------------------------------------------------%

  properties(Access=private, Constant=true)
    lTAG = 'BioLinkage Class:';
  end

  properties %TODO -- some of these should not be public
    name    = '';
    joints;
    links;
    adjMatrix;
    graph;
    standard;
  end

%------------------------------------------------------------%
%                      CONSTRUCT                             %
%------------------------------------------------------------%
  methods
    function o = bioLinkage(tname, torigin)
      o.lD(o.lTAG, 'init constructor');
      if(nargin~=2)
        o.lE(o.lTAG, 'name and origin joint need to be initialized');
      else
        o.name = tname;
        o.joints = torigin;
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

    function o = set.joints(o, tjoints)
      if(class(tjoints)~='bioJoint')%TODO -- this trows error when not true because array is not of same size not only because it does not match the arg
        o.lE(o.lTAG, 'this is not a bioJoint class object');
      else
        o.joints = tjoints;
      end
    end

    function o = set.links(o, tlinks)
      if(class(tlinks)~='bioLink')%TODO -- this trows error when not true because array is not of same size not only because it does not match the arg
        o.lE(o.lTAG, 'this is not a bioLink class object');
      else
        o.links = tlinks;
      end
    end

    function o = set.adjMatrix(o, tadjMatrix)
      %TODO -- i am not error cheking here for now. if using gui, this should be good
      o.adjMatrix = tadjMatrix;
    end

    function o = set.graph(o, tgraph)
      o.graph = tgraph;
    end

    function o = set.standard(o, tstandard)
      o.standard = tstandard;
    end

%------------------------------------------------------------%
%                    CLASS FUNCTIONS                         %
%------------------------------------------------------------%

    function addJoints(o, varargin)
      for i = 1:nargin-1
        if(class(varargin{i})~='bioJoint')%TODO -- this trows error when not true because array is not of same size not only because it does not match the arg
          o.lE(o.lTAG, 'this is not a bioJoint class object');
        else
          o.joints = [o.joints; varargin{i}];
        end
      end
    end


    function addLinks(o, varargin)
      for i = 1:nargin-1
        if(class(varargin{i})~='bioLink')%TODO -- this trows error when not true because array is not of same size not only because it does not match the arg
          o.lE(o.lTAG, 'this is not a bioLink class object');
        else
          o.links = [o.links; varargin{i}];
        end
      end
    end


  end %methods
end %bioLinkClass
