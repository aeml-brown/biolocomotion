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
    jointSavePrefix = 'joint_';
    linkSavePrefix = 'link_';
  end


  properties(Access=public, Constant=false)
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

    function o = bioLinkage(tname)
      o.lD(o.lTAG, 'init constructor');
      if(nargin~=1)
        o.lE(o.lTAG, 'name for joint needs to be initialized');
      else
        o.name = tname;
      end
    end

  end%methods public constructor
%------------------------------------------------------------%
%                     CLASS SETS                             %
%------------------------------------------------------------%
  methods

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

  end%methods public sets

%------------------------------------------------------------%
%                    CLASS FUNCTIONS                         %
%------------------------------------------------------------%
  methods(Access=public)

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

  end%methods public funcions

%------------------------------------------------------------%
%                    SAVE CLASS OBJECT                       %
%------------------------------------------------------------%
  methods(Access=public)

    function s = saveobj(o)
      % save the class object in a 1D struture
      % use prefix to store class structures like joits and links
      s.name      = o.name;
      s.adjMatrix = o.adjMatrix;
      s.graph     = o.graph;
      s.standard  = o.standard;

      % decompose class joint structure one level with prefix
      tjointnames = fieldnames(o.joints);
      for i = 1:length(tjointnames)
        s.(['joint_' tjointnames{i}]) = o.joints.(tjointnames{i});
      end

      % decompose class liink structure one level with prefix
      tlinknames = fieldnames(o.links);
      for i = 1:length(tlinknames)
        s.(['link_' tlinknames{i}]) = o.links.(tlinknames{i});
      end
    end

  end%methods publc save
%------------------------------------------------------------%

  methods (Static)

    function o = loadobj(s)
      % create a temporary object of this class
      tobj = bioLinkage(s.name);

      % assign the properties of saved structure
      tobj.adjMatrix = s.adjMatrix;
      tobj.graph     = s.graph;
      tobj.standard  = s.standard;

      % take all the names in structure that have prefixes
      % then create a nested structure
      tnames  = fieldnames(s);

      tjoints = tnames(contains(tnames, tobj.jointSavePrefix));
      for i = 1:length(tjoints)
          tobj.addJoints(s.(tjoints{i}));
      end

      tlinks = tnames(contains(tnames, tobj.linkSavePrefix));
      for i = 1:length(tlinks)
          tobj.addLinks(s.(tlinks{i}));
      end

      % assign the created structure to the output of this load func
      o = tobj;
    end

  end%methods Static load
%------------------------------------------------------------%

end %bioLinkClass
