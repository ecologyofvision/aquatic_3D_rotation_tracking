%% DETERMINE_REF_FRAME
%  ilse.daly@bristol.ac.uk 

% REQUIRES THE INTRINSIC AND EXTRINSIC CALIBRATION PARAMETERS OF THE TWO
% CAMERAS IN THE STEREO PAIR ALONG WITH THE 2D PIXEL COORDINATES OF THE
% INNER CORNERS OF THE REFERENCE CHESSBOARD. THESE MAY BE REQUIRED BY ANY
% METHOD - NOT NECESSARILY BY THE PRIOR .M FILES THAT RELIED ON THE
% EXTERNAL C++ CODE.

% This code finds the rigid transform [estT] (the rotation and translation) that
% may be applied to convert the reference frame of the three dimensional
% coordinates obtained from stereo triangulation from the camera to the
% "real world". The real world refers to the coordinate system indicated by
% the positioning of the reference chessboard (whose 2D pixel coordinates
% are used as input). In other words, estT is the transorm required to
% convert the 3D coordinates of the reference chessboard in the camer
% reference frame to a horizontal grid of the same size with its bottom left corner on
% the origin

clc 
close all
clear

addpath('Bouget_cam_cal_toolbox'); % add the functions taken from Bouget's Camera Calibration Toolbox (http://www.vision.caltech.edu/bouguetj/calib_doc/)


calDirectory='/home/id12253/Documents/MATLAB/ForPapers/Data/pod1'; % the hdd folder with the cal images and the destination of the calibration info
chessRows=7; % number of rows in the chessboard used during calibration
chessCols=10; % number of columns in the chessboard used during calibration


chessPixelsName=fullfile(calDirectory, 'chessPixelCoords'); % the full file path to the stereoParameters.mat, which contains the results of the stereo calibration


load(chessPixelsName);

load(fullfile(calDirectory,'stereoParameters.mat'))

[refChessLeft,refChessRight] = stereo_triangulation(chessLeft, chessRight,om,translation,fc_left,cc_left,distortionLeft,alpha_c_left,fc_right,cc_right,distortionRight,alpha_c_right);

rows=chessRows-1; % the number of inner corners in the rows on each chessboard
columns=chessCols-1; % the number of inner corners in the columns on each chessboard

%% Right ref frame
figure
plot3(refChessRight(1,:),refChessRight(2,:),refChessRight(3,:),'b+')
title('Chessboard Pose in Right Camera Reference Frame')
xlabel('X')
ylabel('Y')
zlabel('Z')
grid on
hold on


%% Find the trandformation between the chessboard location in the right % camera reference frame and the ideal reference grid
[ G ] = generateReferenceGrid( columns, rows ); % the ideal reference grid
[estT] = estimateRigidTransform(G,refChessRight); % the rigid transformation between the two matrices
%%
% Add an extra dimension to the reference chessboard
refChessRight=[refChessRight;ones(1,length(refChessRight))];

referenceChess=estT*refChessRight;

figure, plot3(referenceChess(1,:), referenceChess(2,:), referenceChess(3,:),'b+')
ylabel('Y')
zlabel('Z')
grid on
title('Chessboard Pose in Real World Reference Frame')
% zlim([-10 10])

%% Find the three dimensional location of the left and right cameras in RW
[ camLeft, camRight ] = camera_coordinates( estT,  rotation, translation );

%%
save(sprintf('%s/estT',calDirectory),'estT')



