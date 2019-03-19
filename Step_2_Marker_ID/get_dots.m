function [ dotLoc,X ,M] =get_dots( frame,mask,coeff,cropMat)

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
dotLoc=zeros(5,50);
dot=zeros(2,50);
line=zeros(2,50);
ex=zeros(1,max(u));
crit=zeros(1,max(u));

if max(u)>0
    for k=1:max(u)
        d=lab==k;       
        
        prop=regionprops(d,'Centroid','Eccentricity','MajorAxisLength','MinorAxisLength','Area','BoundingBox');
        
        loc(:,k)=cat(1,prop.Centroid);
        dotLoc(4,k)=prop.Area;
        dotLoc(1,k)=(loc(1,k)./1)+cropMat(1)-1;
        dotLoc(2,k)=(loc(2,k)./1)+cropMat(2)-1;
        ex(k)=prop.MajorAxisLength;
        crit(k)=ex(k)+10*(prop.Eccentricity);
        
        b=prop.BoundingBox;
        
        a(k)=b(3).*b(4);
        dotLoc(5,k)=a(k);      
    end
end


end

