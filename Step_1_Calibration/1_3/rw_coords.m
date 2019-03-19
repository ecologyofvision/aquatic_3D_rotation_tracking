function [realWorldPoints,rightCam,leftCam] = rw_coords( rwPointsS, rotation, translation,estT )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

rwPointsS=[rwPointsS;ones(1,length(rwPointsS))];
realWorldPoints=estT*rwPointsS;

% Set up the right and left camera position coordinates
rightCamQuat=[0;0;0;1];
leftCamLF=[0;0;0];
leftCamRF=rotation*leftCamLF+translation;
leftCamQuat=[leftCamRF;1];

% Find coordinates of L and R cameras in the specified real world
% coordinate system
rightCam=estT*rightCamQuat;
leftCam=estT*leftCamQuat;

% Correct z inversion
realWorldPoints(3,:)=-1*realWorldPoints(3,:);
rightCam(3,:)=-1*rightCam(3,:);
leftCam(3,:)=-1*leftCam(3,:);


end

