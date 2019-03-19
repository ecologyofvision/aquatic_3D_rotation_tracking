function [ P ] = get_rw_coords( markerName,coordsL,coordsR, stereoParam, estT,waterDepth,smoothingOn)

om=stereoParam.om;
rotation=stereoParam.rotation;
translation=stereoParam.translation;
fc_left=stereoParam.fc_left;
cc_left=stereoParam.cc_left;
distortionLeft=stereoParam.distortionLeft;
alpha_c_left=stereoParam.alpha_c_left;
fc_right=stereoParam.fc_right;
cc_right=stereoParam.cc_right;
distortionRight=stereoParam.distortionRight;
alpha_c_right=stereoParam.alpha_c_right;

dot1L=coordsL.(markerName);
dot1R=coordsR.(markerName);

if smoothingOn==1
    
    or=1;
    framLen=5;
    dot1L(1,:)=sgolayfilt(dot1L(1,:),or,framLen);
    dot1L(2,:)=sgolayfilt(dot1L(2,:),or,framLen);
    
    dot1R(1,:)=sgolayfilt(dot1R(1,:),or,framLen);
    dot1R(2,:)=sgolayfilt(dot1R(2,:),or,framLen);
end

[~,ptR] = stereo_triangulation(dot1L, dot1R,om,translation,fc_left,cc_left,distortionLeft,alpha_c_left,fc_right,cc_right,distortionRight,alpha_c_right);
[airChess,camLeft, camRight] = rw_coords( ptR, rotation, translation,estT );
[ x,y,z ] = refraction( airChess,camLeft, camRight,waterDepth );

P=[x;y;z];
end

