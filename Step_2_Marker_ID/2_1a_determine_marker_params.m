% DETERMINE_MARKER PARAMETERS
%  ilse.daly@bristol.ac.uk 

% Establishes the parameters for thresholding first the background of the
% markers followed by the market dots themselves in order to track their 2D
% pixel coordinates.

% Users can define a region of interest of the image to speed up processing 
% and avoid additional noise

% RUN IN SECTIONS

close all
clear
clc

videoDir='/home/id12253/Documents/MATLAB/ForPapers/Data/pod1/';

leftVidBaseName='left/t13.avi';
leftVidName=fullfile(videoDir, leftVidBaseName);

rightVidBaseName='right/t13.avi';
rightVidName=fullfile(videoDir, rightVidBaseName);


L=VideoReader(leftVidName);
R=VideoReader(rightVidName);

numFramesL=round(L.FrameRate*L.Duration);
numFramesR=round(R.FrameRate*R.Duration);

if numFramesL>numFramesR
    numFrames=numFramesR;
else
    numFrames=numFramesL;
end

% Option to select only a region of interest of the image
roi=0; % if 1 - users click around the region of interest; if 0 whole image is used
nSelFrames=1; % number of frames to pull out and test the chosen parameters

%% Set up Region of Interest (optional) - select region of image containing object of interest

singleFrL=read(L,1);
singleFrR=read(R,1);
if roi==1
    [roiMaskL,~,~]=roipoly(singleFrL);
    [roiMaskR,~,~]=roipoly(singleFrR);
    close all
else
    roiMaskL=ones(size(singleFrL,1),size(singleFrL,2));
    roiMaskR=ones(size(singleFrR,1),size(singleFrR,2));
    
end
[ imRoiL ] = applyMask(roiMaskL,singleFrL);
[ imRoiR ] = applyMask(roiMaskR,singleFrR);


pairOfImages = [imRoiL,imRoiR];
imshow(pairOfImages);

%% Quick check to ensure the region of interest is correctly applied for all frames
close all
selectedFrames=round(linspace(1,numFrames,nSelFrames));
for i=selectedFrames
    fL=read(L,i);
    fR=read(R,i);
    
    [ imRoiL ] = applyMask(roiMaskL,fL);
    [ imRoiR ] = applyMask(roiMaskR,fR);
    
    
    pairOfImages = [imRoiL,imRoiR]; % or [I1;I2]
    imshow(pairOfImages);
    title(sprintf('Frame %d',i))
    pause(1)
    
end

close all

%% Parameters for thresholding the markers and the dots in the left camera
minTL=90; % minimum lab colourspace value
maxTL=150; % maximum lab colourspace value
tL=0.1; % local threshold set for adaptive thresholding

close all
selectedFrames=round(linspace(1,numFrames,nSelFrames));
for i=selectedFrames
    fL=read(L,i);
     [ imRoiL ] = applyMask(roiMaskL,fL);
    
    [maskL,tagL] = get_marker_mask( fL, minTL, maxTL);
    [ dotLocL,Xa] =get_dot_coords(imRoiL,maskL,tL);
    nDotsL=length(find(dotLocL(1,:)>0));
    
    imshow(fL)
    hold on
    for j=1:nDotsL
        plot(dotLocL(1,j),dotLocL(2,j),'+')
    end
    title(sprintf('Frame %d',i))
    pause(1)
end

%% Parameters for thresholding the markers and the dots in the right camera
minTR=90; % minimum lab colourspace value
maxTR=140; % maximum lab colourspace value
tR=0.1; % local threshold set for adaptive thresholding

close all

for i=selectedFrames
    fR=read(R,i);
    [ imRoiR ] = applyMask(roiMaskR,fR);
    [maskR,tagR] = get_marker_mask( imRoiR, minTR, maxTR);
    [ dotLocR,binaryDotsR] =get_dot_coords(fR,maskR,tR);
    nDotsR=length(find(dotLocR(1,:)>0));
    
    imshow(fR)
    hold on
    for j=1:nDotsR
        plot(dotLocR(1,j),dotLocR(2,j),'+')
    end
    title(sprintf('Right Frame %d',i))
    pause(1)
end
%% Saves the parameters
close all
clc

saveMarkerParamsName=fullfile(videoDir,'markerParams');
save(saveMarkerParamsName,'roiMaskL','minTL', 'maxTL','tL', 'roiMaskR','minTR', 'maxTR','tR');
