%% get clean data
clearvars -except here
mdata  = here.motionData;
nodest = here.nodeStd;

%% get unit vector on top of origin
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                     GLOBAL MOVEMENT                       %
%-----------------------------------------------------------%
% compute using local-frame magnitude
tmpvec = mdata.str - mdata.lmb; 
tmpmag = sqrt(tmpvec(:,1).^2 + tmpvec(:,2).^2 + tmpvec(:,3).^2);
ptz = tmpvec./tmpmag;
arrowscale = max(tmpmag)/2;
uvstr = ptz*arrowscale + mdata.str;

clear tmpmag tmpvec

%%

close all;
clc;
h = animatedline;

alldat = mdata.Variables;
tim    = alldat(:,1);
alldat = alldat(:,2:end);

maxx = max(alldat(:,1:3:end),[], 'all');
maxy = max(alldat(:,2:3:end),[], 'all');
maxz = max(alldat(:,3:3:end),[], 'all');

minx = min(alldat(:,1:3:end),[], 'all');
miny = min(alldat(:,2:3:end),[], 'all');
minz = min(alldat(:,3:3:end),[], 'all');

axis equal
set(gca, 'Xlim', [minx maxx], 'YLim', [miny maxy], 'ZLim', [minz maxz]);
view(125, 37);
hold on;

for k = 1:length(tim)
    %addpoints(h,mdata.str(k,1), mdata.str(k,2), mdata.str(k,3));
    hstr = scatter3(mdata.str(k,1), mdata.str(k,2), mdata.str(k,3), 'filled', 'MarkerFaceColor',[0 .75 .75]);
    hlmb = scatter3(mdata.lmb(k,1), mdata.lmb(k,2), mdata.lmb(k,3), 'filled', 'MarkerFaceColor',[.75 .75 0]);
    helbL = scatter3(mdata.elbL(k,1), mdata.elbL(k,2), mdata.elbL(k,3), 'filled', 'MarkerFaceColor',[.75 .75 0]);
    
    ar = arrow(mdata.str(k,:),uvstr(k,:),10);
    drawnow
    pause(0.01);
    
    delete(hstr);
    delete(hlmb);
    delete(helbL);
    delete(findall(gcf,'Tag','Arrow'))
end

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                     CENTERED ON STR                       %
%-----------------------------------------------------------%
close all;
clc;

cdata = table();
cdata.sampleNum = mdata.sampleNum;

for i =2: length(mdata.Properties.VariableNames)
  tchar = mdata.Properties.VariableNames{i};
  cdata.(tchar) = mdata.(tchar)-mdata.str; 
end

% compute using local-frame magnitude
tmpvec = cdata.str - cdata.lmb; 
tmpmag = sqrt(tmpvec(:,1).^2 + tmpvec(:,2).^2 + tmpvec(:,3).^2);
ptz = tmpvec./tmpmag;

pty = cross(cdata.elbL(:,:),cdata.lmb(:,:));
pty = pty./(sqrt(pty(:,1).^2 + pty(:,2).^2 + pty(:,3).^2));
ptx = cross(pty, ptz);
ptx = ptx./(sqrt(ptx(:,1).^2 + ptx(:,2).^2 + ptx(:,3).^2));

arrowscale = max(tmpmag)/2;
ptz = ptz*arrowscale;
pty = pty*arrowscale;
ptx = ptx*arrowscale;

clear tmpmag tmpvec

alldat = cdata.Variables;
tim    = alldat(:,1);
alldat = alldat(:,2:end);

maxx = max(alldat(:,1:3:end),[], 'all');
maxy = max(alldat(:,2:3:end),[], 'all');
maxz = max(alldat(:,3:3:end),[], 'all');

minx = min(alldat(:,1:3:end),[], 'all');
miny = min(alldat(:,2:3:end),[], 'all');
minz = min(alldat(:,3:3:end),[], 'all');




%%
close all;
clc;
h = figure;
axis equal
set(gca, 'Xlim', [minx maxx], 'YLim', [miny maxy], 'ZLim', [minz maxz]);
view(48, 18);
hold on;
movframe = struct('cdata',[],'colormap',[]);
%%
arrow([0 0 0],[arrowscale 0 0],10, 'FaceColor','b');
arrow([0 0 0],[0 arrowscale 0],10, 'FaceColor','b');
arrow([0 0 0],[0 0 arrowscale],10, 'FaceColor','b');

for k = 1:length(tim)
    %addpoints(h,mdata.str(k,1), mdata.str(k,2), mdata.str(k,3));
    hstr = scatter3(cdata.str(k,1), cdata.str(k,2), cdata.str(k,3), 'filled', 'MarkerFaceColor',[0 .75 .75]);
    hlmb = scatter3(cdata.lmb(k,1), cdata.lmb(k,2), cdata.lmb(k,3), 'filled', 'MarkerFaceColor',[.75 .75 0]);
    helbL = scatter3(cdata.elbL(k,1), cdata.elbL(k,2), cdata.elbL(k,3), 'filled', 'MarkerFaceColor',[.75 .75 0]);
    
%     arx = arrow(cdata.str(k,:),ptx(k,:),10);
%     ary = arrow(cdata.str(k,:),pty(k,:),10);
%     arz = arrow(cdata.str(k,:),ptz(k,:),10);
    
    arel = arrow(cdata.str(k,:),cdata.elbL(k,:),10);
    drawnow
    movframe(k) = getframe;
    %pause(0.01);
    
    %delete(hstr, hlmb, helbL, arx, ary, arz, arel);
    delete(hstr);
    delete(hlmb);
    delete(helbL);
    delete(arel);
end

%%
fig = figure;
movie(fig,movframe,2)