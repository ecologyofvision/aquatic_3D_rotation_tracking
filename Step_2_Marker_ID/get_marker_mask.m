function [mask,tag] = get_marker_mask( frame, minT, maxT )
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


mask=tag(:,:,1)>0;
