classdef biolocomotionMainVar < handle

  properties (Access=protected, Constant=true)
    appName  = 'biolocomotion';
    logDebug = false;
    logFile  = false;
    %TODO -- create error message with a struct
  end

  methods (Access=protected)
    function lD(o, tag, msg)
      if(o.logDebug)
        disp(['DEBUG: ' tag ' ' msg]);
      end
    end

    function lE(o, tag, msg)
      %TODO -- use errordlg? also make the print point to a better line of code error
      error(['ERROR: '  tag ' ' msg]);
      dbstack(1);
    end



    function lW(o, tag, msg)
      warning(['WARNING: '  tag ' ' msg]);
    end

  end %methods

  methods (Static)
  %TODO -- can this work for the class functions, if so then change instances of this in utils/
    function lEE(tag, msg)
      %TODO -- use errordlg? also make the print point to a better line of code error
      error(['ERROR: '  tag ' ' msg]);
     % dbstack(1);
    end

  end%public method


end
