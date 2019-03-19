% DETERMINE_MARKER_COORDS
%  ilse.daly@bristol.ac.uk 

% Tracks the 2D pixel location of the marker dots in the left and righ
% cameras based on the thresholding parameters established in the previous


close all
clear
clc

videoDir='/home/id12253/Documents/MATLAB/ForPapers/Data/pod1/';

leftVidBaseName='left/t13.avi';
leftVidName=fullfile(videoDir, leftVidBaseName);

rightVidBaseName='right/t13.avi';
rightVidName=fullfile(videoDir, rightVidBaseName);

load(fullfile(videoDir,'markerParams'));


L=VideoReader(leftVidName);
R=VideoReader(rightVidName);

numFramesL=round(L.FrameRate*L.Duration);
numFramesR=round(R.FrameRate*R.Duration);

if numFramesL>numFramesR
    numFrames=numFramesR;
else
    numFrames=numFramesL;
end

numFrames=100;

allDotLocL=zeros(2,50,numFrames);
allDotLocR=zeros(2,50,numFrames);

%% Parameters for finding the left dots


close all
for i=1:numFrames
    i
    fL=read(L,i);
     [ imRoiL ] = applyMask(roiMaskL,fL);    
    [maskL,tagL] = get_marker_mask( fL, minTL, maxTL);
    [ dotLocL,Xa] =get_dot_coords(imRoiL,maskL,tL);
    nDotsL=length(find(dotLocL(1,:)>0));
    allDotLocL(:,1:nDotsL,i)=dotLocL;
    
    fR=read(R,i);
    [ imRoiR ] = applyMask(roiMaskR,fR);
    [maskR,tagR] = get_marker_mask( imRoiR, minTR, maxTR);
    [ dotLocR,binaryDotsR] =get_dot_coords(fR,maskR,tR);
    nDotsR=length(find(dotLocR(1,:)>0));
    
    allDotLocR(:,1:nDotsR,i)=dotLocR;
end

%%
saveMarkerCoordsName=fullfile(videoDir,'markerCoords');
save(saveMarkerCoordsName,'allDotLocL','allDotLocR');
