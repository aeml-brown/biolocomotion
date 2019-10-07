%% start
%sep 25 2019
%this was done to develop the modifycoordinatesystemgui
%var comes from the gui on changing coordiante systems
%read raw data make a backup

nvar = var;
tnames  = fieldnames(nvar.motion.refPts);
trefpts = zeros(length(tnames),3);
for(i = 1: length(tnames))
    trefpts(i,:) = nvar.motion.refPts.(tnames{i});
end
tmp2 = trefpts*10;
for(i = 1: length(tnames))
    nvar.motion.refPts.(tnames{i}) = tmp2(i,:);
end


%% make a world transformation

%put names remove sample number
tnamepts = nvar.motion.motionData.Properties.VariableNames(:);
tnamepts = tnamepts(~strcmp(motionCsvToNodeStdMapGui.csvDataRowNumberName,tnamepts));
tnameref = fieldnames(nvar.motion.refPts);
torigna = 'winBL';
tborigna = 'str';


%make world triads
[tx, ty, tz] = getWorldOrigin(nvar.motion);
torig        = nvar.motion.refPts.(torigna);
newbase      = [tx',ty',tz'];

% transform ref points
for(i = 1:length(tnameref))
  nvar.motion.refPts.(tnameref{i}) = (newbase\((nvar.motion.refPts.(tnameref{i})-torig)'))';
end

% transform bat points
for(k = 1: length(tnamepts))
  for(i = 1:size(nvar.motion.motionData,1))
    nvar.motion.motionData.(tnamepts{k})(i,:) = (newbase\((nvar.motion.motionData.(tnamepts{k})(i,:)-torig)'))';
  end
end

%new world origin
[tx, ty, tz] = getWorldOrigin(nvar.motion);
torig = nvar.motion.refPts.(torigna);



%% change bat points to bat origin

%get bat triads
[bx, by, bz] = getBatTriad(nvar.motion);
borig        = nvar.motion.motionData.(tborigna);
nvar.motion.bodyMotion = nvar.motion.motionData;

% transform bat points
for(k = 1: length(tnamepts))
  for(i = 1:size(nvar.motion.bodyMotion,1))
    batbase = [bx(i,:)',by(i,:)',bz(i,:)'];
    nvar.motion.bodyMotion.(tnamepts{k})(i,:) = (batbase\((nvar.motion.motionData.(tnamepts{k})(i,:)-borig(i,:))'))';
  end
end

%new world origin stays the same for world data in motionData
%bat local origin will be 000 at 3x3 identy triad



%% preanimation

clc;
h = figure;
scatter3(0,0,0,'filled');
axis equal
minxyz = [-300, -140, -250]; %min(newbat,[],[1 3]);
maxxyz = [ 450,  964.6974,  280]; %max(newbat,[],[1 3]);
set(gca, 'Xlim', [minxyz(1) maxxyz(1)], 'YLim', [minxyz(2) maxxyz(2)], 'ZLim', [minxyz(3) maxxyz(3)]);
xlabel('X')
ylabel('Y')
zlabel('Z')
view(29, 40);
hold on;

%plot window
dx = 0.1; dy = 0.1; dz = 0.1;
scale = 30;
twin = zeros(length(tnameref),3);
for(i = 1:length(tnameref))
  twin(i,:) = nvar.motion.refPts.(tnameref{i});
end
hwin  = scatter3(twin(:,1),twin(:,2),twin(:,3), 'filled');
hwin2 = text(twin(:,1)+dx, twin(:,2)+dy, twin(:,3)+dz, tnameref);
txs = scale*tx+torig;
tys = scale*ty+torig;
tzs = scale*tz+torig;
arrow(torig,txs, 2);
arrow(torig,tzs, 2);
arrow(torig,tys, 2);


%% animation 
%get bat triads
[bx, by, bz] = getBatTriad(nvar.motion);

for(i = 1: size(nvar.motion.motionData,1))
    
    tmp = zeros(length(tnamepts)-1,3); %because sample num
    
    for(k = 1: length(tnamepts)) 
      tmp(k,:) = nvar.motion.motionData.(tnamepts{k})(i,:);
    end
    
    hbat = scatter3(tmp(:,1),tmp(:,2),tmp(:,3), 'filled', 'MarkerFaceColor',[0 .75 .75]);
    tbat = text(tmp(:,1)+dx, tmp(:,2)+dy, tmp(:,3)+dz, tnamepts);
    
    %make bat tirads
    borig = nvar.motion.motionData.(tborigna)(i,:);
    bxs = scale*bx(i,:)+borig;
    bys = scale*by(i,:)+borig;
    bzs = scale*bz(i,:)+borig;
    arr1 = arrow(borig,bxs, 2);
    arr2 = arrow(borig,bzs, 2);
    arr3 = arrow(borig,bys, 2);
    
    drawnow
%     movframe(k) = getframe;
    %pause(0.1);
   
    delete(tbat);
    delete(hbat);
    delete(arr1);
    delete(arr2);
    delete(arr3);

end
hold off


%% just the bat

tall = nvar.motion.bodyMotion.Variables;
tall = tall(:,2:end);
bminx = min(tall(:,1:3:end), [], 'all');
bminy = min(tall(:,2:3:end), [], 'all');
bminz = min(tall(:,3:3:end), [], 'all');
bmaxx = max(tall(:,1:3:end), [], 'all');
bmaxy = max(tall(:,2:3:end), [], 'all');
bmaxz = max(tall(:,3:3:end), [], 'all');

clc;
h = figure;
scatter3(0,0,0,'filled');
axis equal
xlabel('X')
ylabel('Y')
zlabel('Z')
set(gca, 'Xlim', [bminx bmaxx], 'YLim', [bminy bmaxy], 'ZLim', [bminz bmaxz]);
view(7, 40.5);
hold on;
%%
for(i = 1: size(nvar.motion.bodyMotion,1))
    
    tmp = zeros(length(tnamepts)-1,3); %because sample num
    
    for(k = 1: length(tnamepts))
      tmp(k,:) = nvar.motion.bodyMotion.(tnamepts{k})(i,:);
    end
    
    hbat = scatter3(tmp(:,1),tmp(:,2),tmp(:,3), 'filled', 'MarkerFaceColor',[0 .75 .75]);
    tbat = text(tmp(:,1)+dx, tmp(:,2)+dy, tmp(:,3)+dz, tnamepts);
    
    drawnow
    delete(tbat);
    delete(hbat);
end
hold off;

%%
fig = figure;
movie(fig,movframe,2)

