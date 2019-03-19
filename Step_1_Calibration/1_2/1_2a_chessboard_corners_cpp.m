%% CHESSBOARD_CORNERS_CPP
%  ilse.daly@bristol.ac.uk 

% NOTE: THIS MATLAB PROGRAM ASSUMES YOU ARE USING OUR C++ CODE TO FIND THE
% PIXEL VALUES OF THE INNER CORNERS OF THE CALIBRATION CHESSBOARDS. FOR
% ALTERNATIVE METHODS SEE: https://uk.mathworks.com/help/vision/single-and-stereo-camera-calibration.html

% Finds the pixel coordinates of the inner corners of a chessboard imaged
% concurrently by the left and right cameras of a stereo pair. These 2-D
% pixel coordinates are saved as a .MAT file.

clc
close all
clear 

addpath('Bouget_cam_cal_toolbox'); % add the functions taken from Bouget's Camera Calibration Toolbox (http://www.vision.caltech.edu/bouguetj/calib_doc/)

imageList='list'; % the name of the text file containing the calDirectory list of chessboard images to be used for calibration
chessImageList='chesslist'; % the name of the text file containing the directory list of the reference chessboard images

chessRows=7; % number of rows in the chessboard used during calibration
chessCols=10; % number of columns in the chessboard used during calibration

codeDirectory='/home/id12253/Documents/MyPapers/trackingMethod/Code/1_Calibration/CppStereoCode';%'/home/id12253/Desktop/stereoCalCode'; % the location of the compiled openCV C++ calibration code
calDirectory='/home/id12253/Documents/MATLAB/ForPapers/Data/pod1'; % the hdd folder with the cal images and the destination of the calibration info

imagesFolder='images'; % the name of the folder destination of the calibration images
rwLeftImgName='cam1_rw';
rwRightImgName='cam2_rw';


%calToolDirectory=info.calToolDir; % location of Bouget's Camera Calibration Toolbox for MATLAB



rows=chessRows-1; % the number of inner corners in the rows on each chessboard
columns=chessCols-1; % the number of inner corners in the columns on each chessboard

%addpath(genpath(calToolDirectory)) % add the CalibrationToolbox path to your working directory


%% Get the Pixel Locations of the Reference Chessboard Corners
chessFileID = fopen(sprintf('%s/%s.txt',calDirectory, chessImageList'),'w'); % name of the text file

fprintf(chessFileID,'%s\n',sprintf('%s/%s/%s.png',calDirectory,imagesFolder,rwLeftImgName));
fprintf(chessFileID,'%s\n',sprintf('%s/%s/%s.png',calDirectory,imagesFolder,rwRightImgName));
fclose(chessFileID);

name=sprintf('"%s/%s.txt"',calDirectory, chessImageList);
system(sprintf('%s/get_chess %s %s %d %d 0 %d %d',codeDirectory,name,calDirectory,columns,rows,1,0.5))

%% Rename to create a permament RW

movefile(sprintf('%s/cal/chess_left_rw.xml',calDirectory),sprintf('%s/cal/chess_left_RW.xml',calDirectory))
movefile(sprintf('%s/cal/chess_right_rw.xml',calDirectory),sprintf('%s/cal/chess_right_RW.xml',calDirectory))

%% Load the pixel locations of the reference chessboards and convert into three dimensions in the left (refChessLeft) and right (refChessRight) reference frames
[ chessLeft, chessRight ] = get_chessboard_points( calDirectory );

%% save pixel coordinates of left and right chessboards

chessPixelsName=fullfile(calDirectory, 'chessPixelCoords'); % the full file path to the stereoParameters.mat, which contains the results of the stereo calibration
save(chessPixelsName,'chessLeft', 'chessRight');