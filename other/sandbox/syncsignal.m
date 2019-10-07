%[tfile, tpath] = uigetfile( 'Select any video', pwd);
%videoRaw = VideoReader(fullfile(tpath, tfile));
videoRaw = VideoReader('C:\Users\alberto-bortoni\Desktop\sandbox\videoLight.mp4');
currAxes = axes;
vidFrame = readFrame(videoRaw);
image(vidFrame, 'Parent', currAxes);
axis equal;
r1 = drawrectangle('Parent', currAxes, 'Rotatable', false, 'Color',[1 0 0]);

roi = r1.Position;
k=imcrop(vidFrame,roi);
imshow(k)

%%
%videoRaw = VideoReader(fullfile(tpath, tfile))
videoRaw.CurrentTime = 0;

sync = struct();
sync.time = [];
sync.light = [];
sync.signal = [];

while hasFrame(videoRaw)
    vidFrame = readFrame(videoRaw);
    k=imcrop(vidFrame,roi);
    sync.time  = [sync.time; videoRaw.CurrentTime];
    sync.light = [sync.light; mean(k(:))]; 
end


tmp=find(sync.light>((range(sync.light)/2)+min(sync.light)));
sync.signal = zeros(length(sync.light),1);
sync.signal(tmp) = 1;


plot(sync.time, sync.light);
hold on
plot(sync.time, 200*sync.signal);