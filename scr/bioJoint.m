classdef bioJoint < biolocomotionMainVar
% This class defines a generic rotational only joint (3DoF).
% This is the lowermost abstraction of a full body.
% Joints attach to links to then create kinematic models.
% Joints are treated as point like objects in space.
% This class defines their properties in the following order:
%   Joint Name: As it will be refered to in the chain.
%               This name can be the same as the class object.
%   X-Y Limit :
%   X-Z Limit :
%   Y-Z Limit : This is the rotational limit of the plane in duplets.
%               [min, max] vector. Values are taken as Radians from 0~2PI.
%               A [0, 0]   init value will make this joint rigid in all DoF.
%               A [-pi, pi] init value will make this joint free in all DoF.
%
% User must provide the name. Limits are optional and their default values are [-pi, pi].
% All planes in all joints should be equal or contain 0, e.g. [-pi()/2, pi()/2] includes 0
% but [pi()/2, pi()] does not.
% The first element on this vector should be lower than the second.
% The axis of rotaion are not attached to any coorinate system and remain generic.
% Coordinate system constrains will be attached later in the construction of a body.
% The [0,0] position will be attached to the link's coordinate system
%
% CONSTRUCTOR:
%    function o = bioJoint(tname, txylim, txzlim, tyzlim)
%

%------------------------------------------------------------%
%                      PROPERTIES                            %
%------------------------------------------------------------%

  properties(Access=private)
    lTAG = "BioJoint Class: ";
  end

  properties
    name   = "default--changeme";%TODO -- this is looking for a string not a char, ok??
    xylim  = [-pi(), pi()];
    xzlim  = [-pi(), pi()];
    yzlim  = [-pi(), pi()];
  end

%------------------------------------------------------------%
%                      CONSTRUCT                             %
%------------------------------------------------------------%
  methods
    function o = bioJoint(tname, txylim, txzlim, tyzlim)
      o.lD(o.lTAG, "init constructor");
      if(nargin==0)
        o.lE(o.lTAG, "at least joint name should be entered"); %TODO -- error handing
      end
      if(nargin>4)
        o.lE(o.lTAG, "too many arguments"); %TODO -- error handling
      end
      if(nargin>=1)
        o.name  = tname;
      end
      if(nargin>=2)
        o.xylim = txylim;
      end
      if(nargin>=3)
        o.xzlim = txzlim;
      end
      if(nargin==4)
        o.yzlim = tyzlim;
      end
    end

%------------------------------------------------------------%
%                     CLASS SETS                             %
%------------------------------------------------------------%
    % joint name should not be an empty string
    function o = set.name(o, tname)
      if (isstring(tname) & ndims(tname)==2 & size(tname,1)==1 & tname~="")
        o.name = tname;
      else
        o.lE(o.lTAG, "invalid name"); %TODO -- this should be inside a try and catch
      end
    end

    function o = set.xylim(o, txylim)
      if (isnumeric(txylim) & size(txylim)==[1,2] & (txylim(1,1)>=-pi() & txylim(1,1)<=0) & (txylim(1,2)>=0 & txylim(1,2)<=pi())) %TODO -- do I need to include class(xxx)=='double' ??
        o.xylim = txylim;
      else
        o.lE(o.lTAG, "invalid range in xy plane"); %TODO -- this should be inside a try and catch
      end
    end

    function o = set.xzlim(o, txzlim)
      if (isnumeric(txzlim) & size(txzlim)==[1,2] & (txzlim(1,1)>=-pi() & txzlim(1,1)<=0) & (txzlim(1,2)>=0 & txzlim(1,2)<=pi())) %TODO -- do I need to include class(xxx)=='double' ??
        o.xzlim = txzlim;
      else
        o.lE(o.lTAG, "invalid range in xz plane"); %TODO -- this should be inside a try and catch
      end
    end

    function o = set.yzlim(o, tyzlim)
      if (isnumeric(tyzlim) & size(tyzlim)==[1,2] & (tyzlim(1,1)>=-pi() & tyzlim(1,1)<=0) & (tyzlim(1,2)>=0 & tyzlim(1,2)<=pi())) %TODO -- do I need to include class(xxx)=='double' ??
        o.yzlim = tyzlim;
      else
        o.lE(o.lTAG, "invalid range in yz plane"); %TODO -- this should be inside a try and catch
      end
    end

  end %methods


end %classdef
