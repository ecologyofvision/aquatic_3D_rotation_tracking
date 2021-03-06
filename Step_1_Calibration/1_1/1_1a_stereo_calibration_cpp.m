%% STEREO_CALIBRATION_CPP
%  ilse.daly@bristol.ac.uk 

% NOTE: THIS MATLAB PROGRAM ASSUMES YOU ARE USING OUR C++ CODE TO FIND THE
% CALIBRATION PARAMETERS. THERE ARE ALTERNATIVE METHODS FOR STEREO CAMERA
% CALIBRATION IN MATLAB - for more details see: https://uk.mathworks.com/help/vision/single-and-stereo-camera-calibration.html

% Uses png images of chessboards in different poses from the left and
% right cameras to find the stereo calibration parameters. These are the
% parameters needed to convert pairs of 2D pixel coordinates into 3D 
% coordinates in the camera reference frame.

% USER INPUTS 
% codeDirectory     path to the folder containing the compiled (.exe c++ code)
% calDirectory      path to the folder containing the folder (name defined
%                   by the variable imagesFolder)with the images of the 
%                   calibration chessboard in multiple poses imaged in the
%                   left and right cameras. 
% imagesFolder      the name of the folder with the calibration images
% imageNameLeft     the base name of the images from the left camera - code 
%                   assumes that the basename is followed by two digits 
%                   (i.e. padded by zeros; cam1_01, cam1_02, ... , cam1_10)
% imageNameRight    the base name of the images from the right camera
% rwLeftImgName     the base name of the reference chessboard imaged by the
%                   left camera (used later to define the "real-world 
%                   coordinate system")
% rwRightImgName    the base name of the reference chessboard imaged by the
%                   right camera
% imageType         the imge format - we reccommend PNG due to higher
%                   quality
% imageList         the name of thr text file generated by this code that
%                   contains the list of the paths to the chessboard images 
%                   to be used for calibration
% chessImageList    similarly for the c

% RESULTS/OUTPUT
% stereoParameters.MAT -  a single MAT file in the calDirectory path
% containing the intrinsic and extrinsic parameters of the left and right
% cameras of a stereo pair for use in stereo reconstruction.
% 
% Intrinsic parameters:
% fc_left, fc_right - [2x1] - focal length of left,right camera in vertical and
%                             horizonal planes
% cc_left, cc_right -[2x1] - x- and y-components of the principal pt of left,
%                            right camera
% alpha_c_left, alpha_c_right -[1x1] - the left,right camera skew coefficient
% distortionLeft, distortionRight -[1x5] - the distortion matrix of left, right
%                                          cameras

% Extrinsic parameters:
% rotation -[3x3] - the rotation matrix needed to transform from the left camera
% reference frame into the right camera ref frame
% om -[3x1] - same as rotation, but in a different form
% translation -[3x1]- the translation matrix needed to transform from the left camera
% reference frame into the right camera ref frame

clc
close all
clear

addpath('Bouget_cam_cal_toolbox'); % add the functions taken from Bouget's Camera Calibration Toolbox (http://www.vision.caltech.edu/bouguetj/calib_doc/)

chessRows=7; % number of rows in the chessboard used during calibration
chessCols=10; % number of columns in the chessboard used during calibration

codeDirectory='/Users/id12253/Desktop/tracking_test_code/CPP/CppStereoCode';%'/home/id12253/Desktop/stereoCalCode'; % the location of the compiled openCV C++ calibration code
calDirectory='/Users/id12253/Desktop/tracking_test_code/test'; % the hdd folder with the cal images and the destination of the calibration info

imagesFolder='images'; % the name of the folder destination of the calibration images
imageNameLeft='cam1_'; % base name of the images from the left camera
imageNameRight='cam2_'; % base name of the images from the right camera
rwLeftImgName='cam1_rw';
rwRightImgName='cam2_rw';
imageType='png'; % image type e.g. 'png' or 'jpg'

imageList='list'; % the name of the text file containing the calDirectory list of chessboard images to be used for calibration

%% Initial Calibration (no user input)

% creates a text file containing the calDirectory list of all chessboard
% images for calibration, then runs the calibration stereo.exec though the
% system command. This will bring up each image with the detected
% chessboard corners for each image pair with a series of coloured points
% and lines corresponding. Click on the iamge and then hit enter to move 
% onto the next image or hit 'esc' to quit the program. If the
% corners haven't been successfully detected, the overlay on the image will
% show red points but no connecting lines. Additionally, sometimes the
% detected corners are false positive, and are not actually at the corners.
% MAKE A NOTE OF THE INDEX OF THE IMAGES WITH FAILED DETECTIONS AND ENTER
% IN 'remIms' IN THE NEXT SECTION. The name of the images will be printed
% in the MATLAB command window.

dLeft=dir(fullfile(calDirectory, imagesFolder,sprintf('%s*.%s',imageNameLeft,imageType)));
numImsLeft=length(dLeft(not([dLeft.isdir]))); % number of videos
dRight=dir(fullfile(calDirectory, imagesFolder,sprintf('%s*.%s',imageNameRight,imageType)));
numImsRight=length(dRight(not([dRight.isdir]))); % number of videos

dRWLeft=dir(fullfile(calDirectory, imagesFolder,sprintf('%s.%s',rwLeftImgName,imageType)));
numRWImsLeft=length(dRWLeft(not([dRWLeft.isdir]))); % number of videos
dRWRight=dir(fullfile(calDirectory, imagesFolder,sprintf('%s.%s',rwRightImgName,imageType)));
numRWImsRight=length(dRWRight(not([dRWRight.isdir]))); % number of videos

% checks if the folder 'cal' exists, and creates it if it doesn't
if exist(fullfile(calDirectory,'cal'))==0
    mkdir(fullfile(calDirectory,'cal'))
end

rows=chessRows-1; % the number of inner corners in the rows on each chessboard
columns=chessCols-1; % the number of inner corners in the columns on each chessboard

% Cheks a) how many images there are in the images folder and b) that there
% are the correct proportion of calibration image types
if numRWImsLeft==0
    error('ERROR! No Left Real-world image')
end

if numRWImsRight==0
    error('ERROR! No Left Real-world image')
end

if numImsLeft~=numImsRight
    error('ERROR! The number of left images does not equal the number of right images')
else
    numIms=numImsLeft-numRWImsLeft;
end

allIms=1:numIms; % array of image numbers
fileID = fopen(fullfile(calDirectory, sprintf('%s.txt',imageList)),'w'); % name of the text file

% populates the text file 'fileID' with the names and locations within the
% 'directory' of all the calibration images
for i=1:length(allIms)
    fprintf(fileID,'%s\n',fullfile(calDirectory,imagesFolder,sprintf('%s%02d.%s',imageNameLeft,allIms(i),imageType)));
    fprintf(fileID,'%s\n',fullfile(calDirectory,imagesFolder,sprintf('%s%02d.%s',imageNameRight,allIms(i),imageType)));
end
fclose(fileID); % closes the call to the text file

nameList=fullfile(calDirectory, sprintf('%s.txt',imageList)); % the full name and location of the image list text file
%% Initial Stereo Calibration
% Runs the compiled openCV C++ calibration code from 'codeDirectory' to
% find the calibration parameters and save them in .xml files in the 'cal'
% folder created in the 'directory' path at the beginnning of this section
% clear calDirectory
% calDirectory=info.caldir; % the hdd folder with the cal images and the destination of the calibration info

% calDirectory='/home/id12253/Documents/Labbook/Stomatopod/PodScan/Data/O_scyllarus/green_red/pod17';
system(sprintf('%s/stereo "%s" %s %d %d %d %d',codeDirectory,nameList,calDirectory,columns, rows,1,0.5))

%% Remove Any Bad Images (USER INPUT)
clc
remIms=[5]; % images to be removed from the list
allIms=1:numIms-1; % array of image numbers
allIms(remIms)=[]; % all usable images

N=6;% the number of images to include in the calibration - default as lenght(allIms), but can be any number less than this
if (length(allIms))<N
    n=length(allIms);
else
    n=N;

end

combs = nchoosek(allIms,n); %finds the combination of all images with the number of images to be included

%% Loop through all combinations of N images to find the best calibration set (no user input)

% tries out all combination of 'N' decent images to find the set that give
% the most accurate calibration. You will not see any images of chessboards
% After running, a figure will appear plotting the error in calibration 
% with the combination index. MAKE A NOTE OF THE BEST PERFORMING INDEX
h = waitbar(0,'Computing all calibration parameters...');

for j=1:size(combs,1)
    selectedIms=combs(j,:);
    fileID = fopen(fullfile(calDirectory, sprintf('%s.txt',imageList)),'w'); % name of the text file
    
    % populates the text file 'fileID' with the names and locations within the
    % 'directory' of all the calibration images in each combination
    for i=1:length(selectedIms)
        fprintf(fileID,'%s\n',fullfile(calDirectory,imagesFolder,sprintf('%s%02d.%s',imageNameLeft,selectedIms(i),imageType)));
        fprintf(fileID,'%s\n',fullfile(calDirectory,imagesFolder,sprintf('%s%02d.%s',imageNameRight,selectedIms(i),imageType)));
    end
    fclose(fileID);
    
    
    nameList=sprintf('"%s/%s.txt"',calDirectory, imageList); % the full name and location of the image list text file

    % Runs the compiled openCV C++ calibration code from 'codeDirectory' to
    % find the calibration parameters and save them in .xml files in the 'cal'
    % folder created in the 'directory' path at the beginnning of this section
    system(sprintf('%s/stereo "%s" %s %d %d %d %d',codeDirectory,nameList,calDirectory,columns, rows,0,0.5))
    
    clc % clears the output from the stereo calibration program
    
    % Finds the error in the calibration
    errorFileID = fopen(sprintf('%s/averageError.txt',calDirectory),'r');
    
    calError = fscanf(errorFileID,'%f');
    fclose(errorFileID);
    
    e(j)=calError;
    waitbar(j/size(combs,1))
end
close(h)


e(e==0)=NaN;
% plots the error from each combination against its index 
figure, plot(e)
xlabel('Combination Index')
ylabel('Calibration Error')


[find(e==min(e)) min(e)]
%% Select the Best Combination of Images, Write to a File and Calibrate (USER INPUT)

% You'll be prompted to input the index of the combination with the
% smallest error. It will then rewrite the 'imageList' text file and rerun
% the calibration

prompt = 'Select best combination:';
bestImageIndex = input(prompt);
bestImageSelection=combs(bestImageIndex,:);

fileID = fopen(sprintf('%s/%s.txt',calDirectory, imageList'),'w'); % name of the text file

for i=1:length(bestImageSelection);
    fprintf(fileID,'%s\n',fullfile(calDirectory,imagesFolder,sprintf('%s%02d.%s',imageNameLeft,bestImageSelection(i),imageType)));
        fprintf(fileID,'%s\n',fullfile(calDirectory,imagesFolder,sprintf('%s%02d.%s',imageNameRight,bestImageSelection(i),imageType)));
end
fclose(fileID);

nameList=sprintf('"%s/%s.txt"',calDirectory, imageList);
system(sprintf('%s/stereo "%s" %s %d %d %d %d',codeDirectory,nameList,calDirectory,columns, rows,0,0.5))

clc

errorFileID = fopen(sprintf('%s/averageError.txt',calDirectory),'r');
calError = fscanf(errorFileID,'%f');
fclose(errorFileID);

fprintf(sprintf('calibration error = %d', calError))


if calError>=1
    error('Error: Calibration Error is too large. Rerun the calibration with a different set or subset of images. The results of this calibration will be deleted');
    delete(fullfile(irectory, 'cal','*.xml'));
elseif and(calError>0.5,calError<1)
    warning('Calibration error is quite large. Consider rerunning calibration with a defferent set or subset of images');
end
    
%% Convert from xml to matlab files

[ fc_left,cc_left, alpha_c_left,distortionLeft, fc_right, cc_right, alpha_c_right,distortionRight, rotation, translation, om ] = get_calibration_parameters( calDirectory );

calResultsName=fullfile(calDirectory, 'stereoParameters'); % the full file path to the stereoParameters.mat, which contains the results of the stereo calibration
save(calResultsName,'fc_left','cc_left', 'alpha_c_left','distortionLeft', 'fc_right', 'cc_right', 'alpha_c_right','distortionRight', 'rotation', 'translation', 'om');



