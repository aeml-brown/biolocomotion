function [X,Y,Z] = getWorldOrigin(obj)
  % getWorldOrigin designed for the perturbation experiments on summer
  % 2019. it takes the origin point which is the lower left corner (bat)
  % of the window so that can be 0,0,0
  % this function computes a unitary triad using the winTL as the Z axis
  % the winBR as the the X axis. making sure they are orthogonal and Y
  % which is the cross product of those two (the bat travels along world Y)
  % This code is built ad-hoc for what the gui passes down, but that is the
  % intention, so that gui remains general propose.
  %
  % INPUT:
  %   - obj: it is passed down by the gui and contains motion data
  %          and camera objects.
  % OUTPUT:
  %   - X, Y, Z: unitary vectors that mark the triad row vector
  %     based on current world [000] to translate, add new origin coord.
  % FUTURE WORK:
  %   -
  %

  %---------------- Function Handling -----------------%
  lTAG = 'getWorldOrigin:';
  if(exist('biolocomotionMainVar', 'class')==8)
    fER = @(err) biolocomotionMainVar.lEE(lTAG, err);
  else
    fER = @(err) error([lTAG, ' ', err]);
  end

  %-------------- Verify Function Input ---------------%
  % this is passed down by the gui, so no checking needed

  %---------------- Function Variables ----------------%
  % get the points in local var
  orig = obj.refPts.winBL;
  xax  = obj.refPts.winBR;
  zax  = obj.refPts.winTL;

  %------------- Function Implementation ---------------%
  X  = (xax-orig)/norm(xax-orig);
  tz = (zax-orig);
  ty = cross(tz,X);
  Y  = ty/norm(ty);
  tz = cross(X,Y);
  Z  = tz/norm(tz);
end

