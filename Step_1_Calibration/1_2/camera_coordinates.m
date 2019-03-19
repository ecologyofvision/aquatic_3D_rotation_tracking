function [ camLeft, camRight ] = camera_coordinates( estT, rotation, translation)

% Finds the three dimensional location of the cameras in
% the real world reference frame




% Find the 3D coordinates of the centre of the left and right cameras (RW)
rightCamR=[0;0;0;1]; % right camera pose in right cam RF (quaternion)
leftCamL=[0;0;0]; % left camera pose in left cam RF (vector)
leftCamR=rotation*leftCamL+translation; % left camera pose in right cam RF (vector)
leftCamR=[leftCamR;1]; % left camera pose in right cam RF (quaternion)

camRight=estT*rightCamR; % right camera in real world reference frame 
camLeft=estT*leftCamR; % left camera in real world reference frame 

% correct the z inversion error
camRight(3,:)=-camRight(3,:);
camLeft(3,:)=-camLeft(3,:);

end
