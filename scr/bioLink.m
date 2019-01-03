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

  properties %TODO -- some of these should not be public
    name    = '';
    linkMode = {'symbolic'; 'constrained'; 'rigid'};%TODO -- is it best to do chars and init array bigger
    mass    = 0;
    massDis = 1; %TODO -- use symbolic toolbox to allow non uniform mass distr
    %syms xt xy xz
  end

%------------------------------------------------------------%
%                      CONSTRUCT                             %
%------------------------------------------------------------%
  methods
    function o = bioLink(tname)%TODO -- tmatrix is ignored if tlinkmode is symbolic.. ok?
      o.lD(o.lTAG, 'init constructor');
      if(nargin~=1)
        o.lE(o.lTAG, 'name must be provided');
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
        o.lE(o.lTAG, 'invalid name'); %TODO -- this should be inside a try and catch
      end
    end


    function o = set.mass(o, tmass)
      if (isnumeric(tmass) & size(tmass)==[1,1] & tmass>= 0)
        o.mass = tmass;
      else
        o.mass = 0;
        o.lE(o.lTAG, 'mass not valid, default to value 0');
      end
    end


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
