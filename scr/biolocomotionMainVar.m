classdef biolocomotionMainVar < handle

  properties (Access=protected, Constant=true)
    appName  = "biolocomotion";
    logDebug = true;
    logFile  = false;
  end

  methods (Access=protected)
    function lD(o, tag, msg)
      if(o.logDebug)
        disp("Debug: " + tag + msg);
      end
    end

    function lE(o, tag, msg)
      if(o.logDebug)
        disp("ERROR: " + tag + msg);
      end
    end
  end %methods


end
