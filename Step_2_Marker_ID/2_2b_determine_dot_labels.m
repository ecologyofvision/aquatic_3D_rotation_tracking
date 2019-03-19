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

numFrames=100;

thrVal=11;
camera='R'; % L or R
eye=2; % 1 (left) or 2 (right)

%%

for i=1:numFrames
    if camera=='L'
        fL=read(L,i);
        
       if eye==1  %left eye          
            A=[1 6 7 5 8];
        else % right eye
            A=[1 13 9 10 12];
        end
        
        [B,ind]=sort(A(:,1));
        sS=A(ind,2:5);
        numFrames=750;
        N=zeros(1,numFrames);
        S=zeros(numFrames,4);
        
        for u=1:length(B)-1
            N(B(u):(B(u+1))-1)=B(u);
            l=length(B(u):(B(u+1))-1);
            S(B(u):(B(u+1))-1,:)=repmat(sS(u,:),l,1);
        end
        N(max(B):numFrames)=max(B);
        
        lMax=length(max(B):numFrames);
        S(max(B):numFrames,:)=repmat(sS(size(sS,1),:),lMax,1);
        
        allDotL_temp=allDotLocL(:,:,i);
        allDotL=zeros(2,50);
        allDotL(1:2,:)=allDotL_temp;
        
        D=allDotL;
        
        
    else
        fR=read(R,i);
        
        if eye==1
            A=[1 7 8 6 9];
        else
            A=[1 14 10 11 12];
        end
        
        
        [B,ind]=sort(A(:,1));
        sS=A(ind,2:5);
        numFrames=750;
        N=zeros(1,numFrames);
        S=zeros(numFrames,4);
        
        for u=1:length(B)-1
            N(B(u):(B(u+1))-1)=B(u);
            l=length(B(u):(B(u+1))-1);
            S(B(u):(B(u+1))-1,:)=repmat(sS(u,:),l,1);
        end
        N(max(B):numFrames)=max(B);
        lMax=length(max(B):numFrames);
        S(max(B):numFrames,:)=repmat(sS(size(sS,1),:),lMax,1);
        
        
        allDotR_temp=allDotLocR(:,:,i);
        allDotR=zeros(5,50);
        allDotR(1:2,:)=allDotR_temp;
        
        D=allDotR;
        
    end
    
    if i==1
        [dot1(:,i),dot2(:,i), line1(:,i), line2(:,i)]=label_points(i,thrVal, D, [NaN;NaN;NaN],[NaN;NaN;NaN],[NaN;NaN;NaN],[NaN;NaN;NaN],S(i,:),N(i));
    else
        [dot1(:,i),dot2(:,i), line1(:,i), line2(:,i)]=label_points(i,thrVal, D, dot1(:,i-1),dot2(:,i-1), line1(:,i-1), line2(:,i-1),S(i,:),N(i));
    end
    i
    
end

for i=[]
    dot1(1:2,i)=[NaN;NaN];
    dot2(1:2,i)=[NaN;NaN];
    line1(1:2,i)=[NaN;NaN];
    line2(1:2,i)=[NaN;NaN];
end
%%

% close all
% frm=[1:10];
% 
% for ii=1:length(frm)
%     ii
%     i=frm(ii);
%     iR=i;
%     iL=i;
%     
%     if camera=='L'
%         frame=read(L,iL);
%     else
%         frame=read(R,iR);
%     end
%     imshow(frame)
%     hold on
%     plot(dot1(1,i), dot1(2,i), 'g+')
%     plot(dot2(1,i), dot2(2,i), 'm+')
%     plot(line1(1,i), line1(2,i), 'r+')
%     plot(line2(1,i), line2(2,i), 'b+')
%     title(sprintf('frame  %d',i))
%     pause(0.5)
% end

%%
close all
clc

if eye==1
    e='left';
else
    e='right';
end
name=sprintf('dotCoords_%s%s',e,camera);
saveName=fullfile(videoDir,name);
save(saveName,'dot1','dot2','line1','line2')
