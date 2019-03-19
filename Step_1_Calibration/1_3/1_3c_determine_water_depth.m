% DETERMINE_WATER_DEPTH
%  ilse.daly@bristol.ac.uk 

% REQUIRES THE INTRINSIC AND EXTRINSIC CALIBRATION PARAMETERS OF THE TWO
% CAMERAS IN THE STEREO PAIR, THE 2D PIXEL COORDINATES OF THE
% INNER CORNERS OF THE REFERENCE CHESSBOARD IMAGED IN AIR AND WATER AND THE
% RIGID TRANSFORM THAT CONVERTS FROM THE CAMERA TO THE REAL WORLD REFERENCE
% FRAME. THESE VALUES MAY BE REQUIRED BY ANY METHOD - NOT NECESSARILY BY 
% THE PRIOR .M FILES THAT RELIED ON THE EXTERNAL C++ CODE.

% Takes the real-world three dimensional coordinates of a chessboard imaged
% by the stereo rig in the same pose in air and in water. Using the
% refraction correction algorithm, it calculates the depth of water. The
% water depth is saved as a .MAT file to be used later when converting
% pixel coordinates of markers imaged underwater to 3D real-world
% coordinates in order to obtain an object's rotational pose.

% Assumes the water depth during this calibration is the same as
% during the experiment.



clc
close all
clear

addpath('Bouget_cam_cal_toolbox'); % add the functions taken from Bouget's Camera Calibration Toolbox (http://www.vision.caltech.edu/bouguetj/calib_doc/)

calDirectory='/home/id12253/Documents/MATLAB/ForPapers/Data/pod1'; % the hdd folder with the cal images and the destination of the calibration info
chessRows=7; % number of rows in the chessboard used during calibration
chessCols=10; % number of columns in the chessboard used during calibration


airChessPixelsName=fullfile(calDirectory, 'airChessPixelCoords'); % the full file path to the stereoParameters.mat, which contains the results of the stereo calibration
waterChessPixelsName=fullfile(calDirectory, 'waterChessPixelCoords'); % the full file path to the stereoParameters.mat, which contains the results of the stereo calibration
%% Load in location of corners of air and water

load(airChessPixelsName);
load(waterChessPixelsName)
load(fullfile(calDirectory,'stereoParameters.mat'))
load(fullfile(calDirectory,'estT.mat'))


[airChessLeft,airChessRight] = stereo_triangulation(airChessLeft, airChessRight,om,translation,fc_left,cc_left,distortionLeft,alpha_c_left,fc_right,cc_right,distortionRight,alpha_c_right);

[airChess,camLeft, camRight] = rw_coords( airChessRight, rotation, translation,estT );


avDepthAir=mean(mean(airChess(3,:)));


[wChessLeft,wChessRight] = stereo_triangulation(waterChessLeft, waterChessRight,om,translation,fc_left,cc_left,distortionLeft,alpha_c_left,fc_right,cc_right,distortionRight,alpha_c_right);

[waterChess] = rw_coords( wChessRight, rotation, translation,estT );

%%
dep=1:.1:20;
diff=zeros(1,length(dep));
for i=1:length(dep)
    
    s=dep(i);
    [~,~,z ] = refraction( waterChess,camLeft, camRight,s );
    avDepthWater=mean(mean(z));
    diff(i)=abs(avDepthWater-avDepthAir);
end

figure, plot(dep,diff)
indDiff=find(diff==min(diff));

%% Fix water Depth
clc

waterDepth=dep(indDiff);

fprintf(sprintf('Water depth is %d',waterDepth))

[ x,y,z ] = refraction( waterChess,camLeft, camRight,waterDepth );


figure, plot3(airChess(1,:), airChess(2,:), airChess(3,:),'k+')
hold on
plot3(waterChess(1,:), waterChess(2,:), waterChess(3,:),'b+')
plot3(x,y,z,'r+')
xlabel('X')
ylabel('Y')
zlabel('Z')
grid on
title('Chessboard Pose in Real World Reference Frame')
zlim([-10 10])
legend('real world', 'water','corrected')

%%
waterDepthName=fullfile(calDirectory, 'waterDepth'); % the full file path to the stereoParameters.mat, which contains the results of the stereo calibration

save(waterDepthName,'waterDepth')

