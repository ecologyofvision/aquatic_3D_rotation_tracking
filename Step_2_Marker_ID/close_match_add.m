function [ ind,m,dD] = close_match_add( allCoords, newCoord )

D=zeros(1,50);

for k=1:50
    D(k)=dist_2point(allCoords(1:2,k),newCoord(1:2)); % euclidean distance
    if allCoords(1,k)==0
        D(k)=3000;
    end
end
dD=D;
m1=min(D);
ind1=find(D==m1);

D(ind1)=1000;
m2=min(D);
ind2=find(D==m2);

D(ind2)=1000;
m3=min(D);
ind3=find(D==m3);

D(ind3)=1000;
m4=min(D);
ind4=find(D==m4);

ind=[ind1(1) ind2(1) ind3(1) ind4(1)];
m=[m1,m2,m3,m4];
end