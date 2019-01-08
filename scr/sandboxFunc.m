function y = sandboxFunc(a)
  names = {'appName';
  'appVersion';
  'appAuthor';
  'conGraph';
  'graphPlot';
  'adjMatrix';
  'stdName';
  'image';
  'body';};


  for i = 1: length(names)
    y.(names{i}) = a+i;

  end

end


