function [ dotLoc,X ,M] =get_dot_coords( frame,mask,coeff)

M(:,:,1)=uint8(mask).*frame(:,:,1);
M(:,:,2)=uint8(mask).*frame(:,:,2);
M(:,:,3)=uint8(mask).*frame(:,:,3);



X=adaptivethreshold(M,11,coeff,0);

labi=bwlabel(X);
ui=unique(labi);

if max(ui)>0
    
    for k=1:max(ui)
        di=labi==k;
        prop=regionprops(di,'BoundingBox');
        a1=prop.BoundingBox;
        a(k)=a1(3).*a1(4);
        
        if a(k)>100
            X(di>0)=0;
        end
    end
end
X=imfill(X,'holes');

lab=bwlabel(X);
u=unique(lab);

loc=zeros(2,50);



if max(u)>0
    dotLoc=zeros(2,max(u));
    for k=1:max(u)
        d=lab==k;       
        
        prop=regionprops(d,'Centroid','Eccentricity','MajorAxisLength','MinorAxisLength','Area','BoundingBox');
        
        loc(:,k)=cat(1,prop.Centroid);
        
        dotLoc(1,k)=(loc(1,k)./1);
        dotLoc(2,k)=(loc(2,k)./1);
           
    end
else
    dotLoc=zeros(2,1);
end


end

