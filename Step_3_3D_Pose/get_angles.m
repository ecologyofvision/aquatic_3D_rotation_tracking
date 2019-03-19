function [ yaw, pitch, roll,cP1,cP2,cP3,cP4 ] = get_angles(p1,p2,p3,p4,e )
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here

    


yaw=atand((p4(2)-p3(2))/(p4(1)-p3(1)));


if length(e)==4
    for i=1:length(yaw)
        if yaw(i)<-55
            yaw(i)=abs(yaw(i));
        end
    end
else
    for i=1:length(yaw)
        if yaw(i)>55
            yaw(i)=-abs(yaw(i));
        end
    end
end


skewCor=[cosd(yaw) sind(yaw) 0 ; -sind(yaw) cosd(yaw) 0; 0 0 1];

cP1=skewCor*p1;
cP2=skewCor*p2;
cP3=skewCor*p3;
cP4=skewCor*p4;

pitch=atand((cP2(3)-cP1(3))/(cP2(2)-cP1(2)));
roll=atand((cP4(3)-cP3(3))/(cP4(1)-cP3(1)));
% 
% yawU=atand((cP4(2)-cP3(2))/(cP4(1)-p3(1)));
% pitchU=atand((p2(3)-p1(3))/(p2(2)-p1(2)));
% rollU=atand((p4(3)-p3(3))/(p4(1)-p3(1)));



end

