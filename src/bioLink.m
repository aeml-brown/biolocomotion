classdef bioLink < biolocomotionMainVar
% instructions
%
% CONSTRUCTOR:
%    function o = bioLink()
%

%------------------------------------------------------------%
%                      PROPERTIES                            %
%------------------------------------------------------------%

  properties(Access=private, Constant=true)
    lTAG = 'BioLink Class:';
  end

  properties(Access=public, Constant=true)
    % use this variable to create joints for this class
    linkTypes = struct('driven','driven','actuated','actuated');
  end

  properties (Access=public) %TODO -- some of these should not be public
    name    = '';
    ltype;
    linkMode = {'symbolic'; 'constrained'; 'rigid'};%TODO -- is it best to do in a struct
    mass    = 0;
    massDis = 1; %TODO -- use symbolic toolbox to allow non uniform mass distr
    %syms xt xy xz
  end

%------------------------------------------------------------%
%                      CONSTRUCT                             %
%------------------------------------------------------------%
  methods
    function o = bioLink(tname, tltype)%TODO -- tmatrix is ignored if tlinkmode is symbolic.. ok?
      o.lD(o.lTAG, 'init constructor');
      if(nargin~=2)
        o.lE(o.lTAG, 'Name and link type must be provided');
      else
      o.name = tname;
      o.ltype = tltype;
      end
    end

%------------------------------------------------------------%
%                     CLASS SETS                             %
%------------------------------------------------------------%
    % joint name should not be an empty string, it should be a valid var name
    function o = set.name(o, tname)
      if (isvarname(tname))
        o.name = tname;
        %TODO -- check that the name is different from the attached joint's name
      else
        o.lE(o.lTAG, 'invalid name'); %TODO -- this should be inside a try and catch
      end
    end
%------------------------------------------------------------%

    % joint type should come from the struct name public const var
    function o = set.ltype(o, tltype)
      %TODO -- use fieldnames() here
      if(any(strcmp({o.linkTypes.driven o.linkTypes.actuated},tltype)))
        o.ltype = tltype;
      else
        o.lE(o.lTAG, 'type does not match, use public class struct property linkTypes to create links');
      end
    end
%------------------------------------------------------------%

    function o = set.mass(o, tmass)
      if (isnumeric(tmass) & isscalar(tmass) & tmass>= 0)
        o.mass = tmass;
      else
        o.mass = 0;
        o.lE(o.lTAG, 'mass not valid, default to value 0');
      end
    end
%------------------------------------------------------------%

    function o = set.massDis(o, tmassDis) %TODO -- using scalar dim for now, this should be a function
      if (isnumeric(tmassDis) & size(tmassDis)==[1,1] & tmassDis>= 0)
        o.massDis = tmassDis;
      else
        o.massDis = 0;
        o.lE(o.lTAG, 'mass Distribution not valid, default to value 0');
      end
    end

%------------------------------------------------------------%
%                    CLASS FUNCTIONS                         %
%------------------------------------------------------------%

  end %methods
end %bioLinkClass
