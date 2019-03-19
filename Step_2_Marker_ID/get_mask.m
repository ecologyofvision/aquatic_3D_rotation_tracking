function [tag, blueLeftMask,yellowLeftMask,blueRightMask,yellowRightMask ] = get_mask( frame, minT, maxT,x )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

colorTransform = makecform('srgb2lab');

% left
lab = applycform(frame, colorTransform);

b1=lab(:,:,2)<maxT;
b2=lab(:,:,1)>minT;
b3=b1+b2;
b=b3>1;
b=imfill(b,'holes');
b=imclearborder(b);
b=bwareaopen(b,500,8);

%figure, imshow(frame)
%figure, imshow(b)


for j=1:3
    tag(:,:,j)=frame(:,:,j).*uint8(b);
end

lab=bwlabel(b);
numLab=unique(lab);

if max(numLab)>0
    
    blueRightMask=zeros(size(frame,1),size(frame,2),max(numLab));
    blueLeftMask=zeros(size(frame,1),size(frame,2),max(numLab));
    yellowRightMask=zeros(size(frame,1),size(frame,2),max(numLab));
    yellowLeftMask=zeros(size(frame,1),size(frame,2),max(numLab));
    
    for i=1:max(numLab)
        d=lab==i;
        propL=regionprops(d,'Centroid','Eccentricity','BoundingBox');
        tagPosi(:,i)=cat(1,propL.Centroid);
        tagPos(1,i)=tagPosi(1,i);
        tagPos(2,i)=tagPosi(2,i);
        
        frame=find(d==1);
        [rowL,col]=ind2sub(size(lab),frame);
        coliL=impixel(tag, col, rowL);
        colR(i)=mean(coliL(:,1));
        colG(i)=mean(coliL(:,2));
        colB(i)=mean(coliL(:,3));
        
        A(i)= tagPos(1,i);
        
        sL(i)=sum(sum(d));
        d=double(d);
        
        col(i)=colB(i)-colR(i);
        
        
        
        if and(tagPos(1,i)>x, col(i)>-6)
            blueRightMask(:,:,i)=d.*1;
            blueLeftMask(:,:,i)=NaN.*d;
            yellowRightMask(:,:,i)=NaN.*d;
            yellowLeftMask(:,:,i)=NaN.*d;
        elseif and(tagPos(1,i)<x, col(i)>-6)
            blueRightMask(:,:,i)=NaN.*d;
            blueLeftMask(:,:,i)=d.*1;
            yellowRightMask(:,:,i)=NaN.*d;
            yellowLeftMask(:,:,i)=NaN.*d;
        elseif and(tagPos(1,i)>x, col(i)<-6)
            blueRightMask(:,:,i)=NaN.*d;
            blueLeftMask(:,:,i)=NaN.*d;
            yellowRightMask(:,:,i)=d.*1;
            yellowLeftMask(:,:,i)=NaN.*d;
        elseif and(tagPos(1,i)<x, col(i)<-6)
            blueRightMask(:,:,i)=NaN.*d;
            blueLeftMask(:,:,i)=NaN.*d;
            yellowRightMask(:,:,i)=NaN.*d;
            yellowLeftMask(:,:,i)=d.*1;
        else
            blueRightMask(:,:,i)=NaN.*d;
            blueLeftMask(:,:,i)=NaN.*d;
            yellowRightMask(:,:,i)=NaN.*d;
            yellowLeftMask(:,:,i)=d.*NaN;
            
        end
    end
    
    [blueRightMask ] = find_mask( blueRightMask );
    [blueLeftMask ] = find_mask( blueLeftMask );
    [yellowRightMask ] = find_mask( yellowRightMask );
    [yellowLeftMask ] = find_mask( yellowLeftMask );
    
else
    blueRightMask=zeros(size(frame,1),size(frame,2),1);
    blueLeftMask=zeros(size(frame,1),size(frame,2),1);
    yellowRightMask=zeros(size(frame,1),size(frame,2),1);
    yellowLeftMask=zeros(size(frame,1),size(frame,2),1);
end
end

