%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%         DISPLAY NORMAL ARROW VECTOR IN ANIMATION          %
%-----------------------------------------------------------%

close all;
clear;
clc;
h = animatedline;

samples = 100;
tmp = linspace(-pi()/4,pi()/4,samples);
tmp2 = linspace(0, pi(), samples);
radi = 9;
hi = 5;
x = radi*sin(tmp);
xx = [x fliplr(x(1:end-1))]; 
y = radi*cos(tmp);
yy = [y fliplr(y(1:end-1))]; 
z = hi*sin(tmp2);
zz = [z fliplr(z(1:end-1))]; 

p0 = [0 0 0];
p1 = [0 0 0]; 
axis equal
set(gca, 'Xlim', [-9 9], 'YLim', [0 9], 'ZLim', [0 10]);
view(125, 37);
hold on;

for k = 1:length(xx)

    addpoints(h,xx(k),yy(k),zz(k));
    scatter3(xx(k),yy(k),zz(k));
    
    if(k>1)
      p1 = cross([xx(k) yy(k) zz(k)], [xx(k-1) yy(k-1) zz(k-1)]);
      p1 = 5*p1/norm(p1);
      delete(findall(gcf,'Tag','Arrow'))
      ar = arrow(p0,p1);
    end
    
    drawnow
    pause(0.02);
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                  TEMPORARILY ADD TO PATH                  %
%-----------------------------------------------------------%

% addpath(pwd);
% temp = [pwd  '\src'];
% addpath(genpath(temp));
% clear temp;





%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                  MAKES A TABLE FOR LINKS                  %
%-----------------------------------------------------------%
% %---------------------------------------------------------------------------%
% % pupulate the table with rows as Node Standard and columns as csv recordings
% % first get the values to name the columns and rows
% tcolsNames = transpose(app.csvData.textdata);
% %TODO -- stdNodeNames is kinda hardcoded, need a struct to have this names
% trowsNames = app.nodeStandard.stdNodeNames;
% 
% % initialize the table with empty values
% app.table_nodeAssign.Data = false(size(trowsNames,1), size(tcolsNames,1));
% 
% % allow user to modify table
% app.table_nodeAssign.ColumnEditable = true;
% 
% % make table a checkbox one
% tmpcell = cell(1, size(tcolsNames,1));
% tmpcell(1:end) = cellstr('logical');
% app.table_nodeAssign.ColumnFormat = tmpcell;
% 
% % include names of columns and rows
% app.table_nodeAssign.ColumnName = tcolsNames;
% app.table_nodeAssign.RowName    = trowsNames;
% 
% % format width and height to be the min for
% tcolsize = cell(1, size(tcolsNames,1));
% tcolsize(1:end) = num2cell(30);
% app.table_nodeAssign.ColumnWidth = tcolsize;
% 
% % display table
% app.table_nodeAssign.Visible = 'on';
% 
% % permit diagonal button to work now
% app.button_makeDiagonalTrue.Enable = 'on';

