function [ roi ] = applyMask( mask, image )

roi=zeros(size(image));
for i=1:size(image,3)
    roi(:,:,i)=mask.*double(image(:,:,i));
end

roi=uint8(roi);