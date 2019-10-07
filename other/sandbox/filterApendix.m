%made on oct 4th to test filter head and tail appendix
clear all
clc
a = 'C:\Users\alberto-bortoni\Desktop\sandbox\better\russ\trial\russ3d_data_190709_t1\modifyCoordinateSystempApp.mat';
q = load(a);
q=q.modifyCoordinateSystem;
var=q;


%%
point = var.motion.bodyMotion.elbL(:,2);
ns = 10;
tim = -(ns-1):(ns);

%%
%head
ad = point(1:ns);
da = flip(ad);
da = -1*(da-ad(1))+ad(1);
da = da(1:end-1);


%tail
eq = point((end-ns+1):end,1);
qe = flip(eq);
qe = -1*(qe-eq(end))+eq(end);
qe = qe(2:end);

ns = ns-1;
xold = 1:length(point);
xnew = (1-ns):(ns+length(point));
y = [da;point;qe];
%%

plot(xold, (point-10));
hold on
axis equal
plot(xnew, y);

%% after filter
n = filter(hd,y);
zf = hd.states;
hd.persistentmemory = true;
hd.states = 1;
n = filter(hd,y);

plot(y)
hold on
plot(n)
hold off
