classdef sandboxClass2
  %UNTITLED3 Summary of this class goes here
  %   Detailed explanation goes here
  
  properties
    linkage;
  end
  
  methods
    function obj = sandboxClass2(tlinkage)
      %UNTITLED3 Construct an instance of this class
      %   Detailed explanation goes here
      obj.linkage = tlinkage;
    end
    
    function outputArg = method1(obj,inputArg)
      %METHOD1 Summary of this method goes here
      %   Detailed explanation goes here
      outputArg = obj.Property1 + inputArg;
    end
  end
end

