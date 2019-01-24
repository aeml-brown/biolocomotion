%% load data
clear all
close all
clc
load('C:\Users\alberto-bortoni\Desktop\sandbox\fistStudy\motionCsvToNodeStdMapApp.mat')
load('C:\Users\alberto-bortoni\Desktop\sandbox\fistStudy\bat22pts_old.mat')

%% start stuff
data =motionCsvToNodeStdMap.motionData;
dat = data;

tnames = data.Properties.VariableNames;

for i = 2 : length(tnames)
  dat.(tnames{i}) = dat.(tnames{i}) - dat.str;
end

% plot(dat.sampleNum,dat.str(:,1));
% hold on
% plot(dat.sampleNum,data.str(:,1));
% plot(dat.sampleNum,dat.(tnames{2})(:,1));
% plot(dat.sampleNum,data.(tnames{2})(:,1));


%% calculate lengths
clear len res tmp

len = table();
len.sampleNum = data.sampleNum;
tedges = createNodeStandard.conGraph.Edges.EndNodes;
tlinknames = createNodeStandard.conGraph.Edges.Name;
res = table();


for i = 1: size(tedges,1)
  tlen = dat.(tedges{i,1}) - dat.(tedges{i,2});
  len.(tlinknames{i}) = sqrt(tlen(:,1).^2 + tlen(:,2).^2 + tlen(:,3).^2);

  tmp.mean = mean(len.(tlinknames{i}));
  tmp.std = std(len.(tlinknames{i}));
  tmp.median = median(len.(tlinknames{i}));
  tmp.mode = mode(len.(tlinknames{i}));
  tmp.min = max(len.(tlinknames{i}));
  tmp.max = min(len.(tlinknames{i}));
  res.(tlinknames{i}) = [tmp.mean; tmp.std; tmp.median; tmp.mode; tmp.min; tmp.max];

end
res.Properties.RowNames = {'mean','std','median','mode', 'min', 'max'};