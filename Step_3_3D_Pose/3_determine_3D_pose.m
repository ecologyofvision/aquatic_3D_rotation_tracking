close all
clear
clc

workingDir='/home/id12253/Documents/MATLAB/ForPapers/Data/pod1/';

% location of mat file with coordinates of all markers
saveNameLeftL=fullfile(workingDir,sprintf('dotCoords_%s%s','left','L'));
saveNameLeftR=fullfile(workingDir,sprintf('dotCoords_%s%s','left','R'));
saveNameRightL=fullfile(workingDir,sprintf('dotCoords_%s%s','right','L'));
saveNameRightR=fullfile(workingDir,sprintf('dotCoords_%s%s','right','R'));

% load in as a struct
coordsLeftL=load(saveNameLeftL); % left eye, left camera
coordsLeftR=load(saveNameLeftR); % left eye, right camera
coordsRightL=load(saveNameRightL); % left eye, left camera
coordsRightR=load(saveNameRightR); % left eye, right camera



stereoParam=load(fullfile(workingDir,'stereoParameters.mat'));
load(fullfile(workingDir,'estT.mat'))
load(fullfile(workingDir,'waterDepth.mat'))


%%
smoothingOn=1;


[ d1Left ] = get_rw_coords( 'dot1',coordsLeftL,coordsLeftR,stereoParam,estT,waterDepth,smoothingOn);
[ d2Left ] = get_rw_coords( 'dot2',coordsLeftL,coordsLeftR,stereoParam,estT,waterDepth,smoothingOn);
[ l1Left ] = get_rw_coords( 'line1',coordsLeftL,coordsLeftR,stereoParam,estT,waterDepth,smoothingOn);
[ l2Left ] = get_rw_coords( 'line2',coordsLeftL,coordsLeftR,stereoParam,estT,waterDepth,smoothingOn);

for i=1:length(d1Left(1,:))
    [yawLeft(i),pitchLeft(i),rollLeft(i)]=get_angles(d1Left(:,i),d2Left(:,i),l1Left(:,i),l2Left(:,i),'left');
end

figure, 
subplot(1,3,1),plot(yawLeft)
ylim([-90 0])
subplot(1,3,2),plot(pitchLeft)
ylim([-45 45])
subplot(1,3,3),plot(rollLeft)
ylim([-10 90])