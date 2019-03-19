close all
clear
clc

videoDir='/home/id12253/Documents/MATLAB/ForPapers/Data/pod1/';

saveMarkerCoordsName=fullfile(videoDir,'markerCoords');

load(saveMarkerCoordsName)

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

%% Colour code markers for easy reference

col={'r+','g+' 'b+' 'm+' 'y+','c+','w+','k+','ro','go','bo' 'mo' 'yo','co','wo','ko','r*','g*','b*' 'm*' 'y*','r-','g-' 'b-' 'm-' 'y-','c-','r.','g.' 'b.' 'm.' 'y.','c.','w.','k.'};
%      1    2   3   4     5     6   7     8   9     10  11  12    13    14  15   16   17   18   19   20  21    22   23  24   25   26   35 %  28   29   30   31   32   33   34
f=1;

fL=read(L,f);
dotLocL=allDotLocL(:,:,f);
nDotsL=length(find(dotLocL(1,:)>0));

figure
subplot(1,2,1),imshow(fL)
hold on
for j=1:nDotsL
    plot(dotLocL(1,j),dotLocL(2,j),col{j})
end
title(sprintf('Left frame %d',f))

fR=read(R,f);
dotLocR=allDotLocR(:,:,f);
nDotsR=length(find(dotLocR(1,:)>0));
subplot(1,2,2),imshow(fR)
hold on
for j=1:nDotsR
    plot(dotLocR(1,j),dotLocR(2,j),col{j})
end
title(sprintf('Right frame %d',f))
