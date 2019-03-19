function [ col ] = sel_thresh( frame )
% converts the video frame to the lab colourspace, allows the user to click
% on the regions of interest and returns the colour values of those pixels 
colorTransform = makecform('srgb2lab');
    lab = applycform(frame, colorTransform);

    [~,x,y]=roipoly(lab);
    close all
    col=impixel(frame,x,y);
   

end

