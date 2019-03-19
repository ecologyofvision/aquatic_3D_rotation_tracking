function [ LocL,X,M ] = get_thr_pointers( L,mask,minX,minY,coeff,yCut )
if nargin<6
    yCut=1;
end

mask(1:yCut,:)=0;

M(:,:,1)=uint8(mask).*L(:,:,1);
M(:,:,2)=uint8(mask).*L(:,:,2);
M(:,:,3)=uint8(mask).*L(:,:,3);

X=adaptivethreshold(M,11,coeff,0);

% M1=uint8(mask).*L(:,:,1);
% M2=uint8(mask).*L(:,:,2);
% M3=uint8(mask).*L(:,:,3);

% K=(M1+M2+2*M3)/4;
% J=double(K);
% J(J==0)=[];
% 
% y=[mean(J) min(J) max(J)];
% th=y(1,2)+((y(1,1)-y(1,2))*coeff);
% o1=K<th;
% o2=K>0;
% o=o1+o2;
% X=o>1;

labi=bwlabel(X);
ui=unique(labi);

if max(ui)>0
    
    for k=1:max(ui)
        dLi=labi==k;
        propLi=regionprops(dLi,'BoundingBox');
        a1=propLi.BoundingBox;
        a(k)=a1(3).*a1(4);
        
        if a(k)>100
            X(dLi>0)=0;
        end
    end
end
X=imfill(X,'holes');

lab=bwlabel(X);
u=unique(lab);

locL=zeros(2,50);
LocL=zeros(5,50);
dot=zeros(2,50);
line=zeros(2,50);
ex=zeros(1,max(u));
crit=zeros(1,max(u));

if max(u)>0    
    for k=1:max(u)
        dL=lab==k;
        
       
        propL=regionprops(dL,'Centroid','Eccentricity','MajorAxisLength','MinorAxisLength','Area','BoundingBox');
        
        locL(:,k)=cat(1,propL.Centroid);
        LocL(4,k)=propL.Area;
        LocL(1,k)=(locL(1,k)./1)+minX;
        LocL(2,k)=(locL(2,k)./1)+minY;
        ex(k)=propL.MajorAxisLength;
        crit(k)=ex(k)+10*(propL.Eccentricity);
        
        b=propL.BoundingBox;
        
        
        a(k)=b(3).*b(4);
        LocL(5,k)=a(k);
        
        
    end
end

end

