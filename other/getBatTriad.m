function [X,Y,Z] = getBatTriad(obj)
  % getBatTriad is designed for the perturbation experiments on summer
  % 2019. it takes the bats STR point as the origin of orientation
  % and uses both shoulders to compute a triad to compute bat mechanics
  % where X runs laterally computed as the vector between shoulders
  % then transposed to str
  % Y is an orthogonal vector to X and in the plane formed by those 3 pts
  % Z is the cross product of X and Y projecting dorsally to the bat
  % This code is built ad-hoc for what the gui passes down, but that is the
  % intention, so that gui remains general propose.
  %
  % INPUT:
  %   - obj: it is passed down by the gui and contains motion data
  %          and camera objects.
  % OUTPUT:
  %   - X, Y, Z: unitary vectors that mark the triad for all frames
  %             these are col vectors. rows are trayectories at a time t+n
  % FUTURE WORK:
  %   -
  %

  %---------------- Function Handling -----------------%
  lTAG = 'getBatTriad: ';
  if(exist('biolocomotionMainVar', 'class')==8)
    fER = @(err) biolocomotionMainVar.lEE(lTAG, err);
  else
    fER = @(err) error([lTAG, ' ', err]);
  end

  %-------------- Verify Function Input ---------------%
  % this is passed down by the gui, so no checking needed

  %---------------- Function Variables ----------------%
  % get the points in local var
  orig = obj.motionData.str;
  shdR = obj.motionData.shdR;
  shdL = obj.motionData.shdL;

  %------------- Function Implementation ---------------%
  shd = (shdR-shdL);
  txn = arrayfun(@(trow) norm(shd(trow,:)), (1:size(shd,1)).');
  X   = shd./txn;
  tz  = cross((shdR-orig), (shdL-orig));
  tzn = arrayfun(@(trow) norm(tz(trow,:)), (1:size(tz,1)).');
  Z   = tz./tzn;
  ty  = cross(Z, X);
  tyn = arrayfun(@(trow) norm(ty(trow,:)), (1:size(ty,1)).');
  Y   = ty./tyn;
end
