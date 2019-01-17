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
    name   = '';
    joints = struct();
    links  = struct();
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
      if (isvarname(tname))
        o.name = tname;
        %TODO -- check that the name is different from the attached joint's name
      else
        o.lE(o.lTAG, 'invalid name'); %TODO -- this should be inside a try and catch
      end
    end
%------------------------------------------------------------%

    function o = set.joints(o, tjoints)
      %TODO -- should the class biojoint have object class name as a variable? this is hardcoded
      if(~strcmp(class(tjoints), 'bioJoint'))
        o.lE(o.lTAG, 'this is not a bioJoint class object');
      else
        % add new joint, name the struct field in joints to be the same as the bioJoint declared name
        o.joints.(tjoints.name) = tjoints;
      end
    end
%------------------------------------------------------------%

    function o = set.links(o, tlinks)
      if(~strcmp(class(tlinks), 'bioLink'))
        o.lE(o.lTAG, 'this is not a bioLink class object');
      else
        % add new link, name the struct field in links to be the same as the bioLink declared name
        o.links.(tlinks.name) = tlinks;
      end
    end
%------------------------------------------------------------%

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
        if(~strcmp(class(varargin{i}), 'bioJoint'))%TODO -- i am error checking this twice, here and in set
          o.lE(o.lTAG, 'this is not a bioJoint class object');
        else
          % joints already declared as struct, set class handles name of new element in struct
          o.joints = varargin{i};
        end
      end
    end
%------------------------------------------------------------%

    function addLinks(o, varargin)
      for i = 1:nargin-1
        if(~strcmp(class(varargin{i}), 'bioLink'))
          o.lE(o.lTAG, 'this is not a bioLink class object');
        else
          % add new joint, name the struct field in joints to be the same as the bioJoint declared name
          o.links = varargin{i};
        end
      end
    end
%------------------------------------------------------------%

  end %methods
end %bioLinkClass
