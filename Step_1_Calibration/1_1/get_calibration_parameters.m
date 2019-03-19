function [ fc_left,cc_left, alpha_c_left,distortionLeft, fc_right, cc_right, alpha_c_right,distortionRight, rotation, translation, om ] = get_calibration_parameters( folderLocation )

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Intrinsic Parameters Left Camera %

[ intLeft ] = xml2struct( sprintf('%s/cal/int_stereo_left_act.xml', folderLocation ));
intLeftString=intLeft.opencv_storage.int_stereo_left_act.data.Text;
intLeftString= textscan(intLeftString, '%s', 'delimiter', '\n');
intLeftString = char(intLeftString{1});
[ intrinsicLeft ] = block2line( intLeftString );

[ distLeft ] = xml2struct( sprintf('%s/cal/dist_stereo_left_act.xml', folderLocation ));
distLeftString=distLeft.opencv_storage.dist_stereo_left_act.data.Text;
distLeftString= textscan(distLeftString, '%s', 'delimiter', '\n');
distLeftString = char(distLeftString{1});
[ distortionLeft ] = block2line( distLeftString );

fc_left=[intrinsicLeft(1); intrinsicLeft(5)];
cc_left=[intrinsicLeft(3);intrinsicLeft(6)];
alpha_c_left=intrinsicLeft(2)/intrinsicLeft(1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Intrinsic Parameters Right Camera %

[ intRight ] = xml2struct( sprintf('%s/cal/int_stereo_right_act.xml', folderLocation ));
intRightString=intRight.opencv_storage.int_stereo_right_act.data.Text;
intRightString= textscan(intRightString, '%s', 'delimiter', '\n');
intRightString = char(intRightString{1});
[ intrinsicRight ] = block2line( intRightString );

[ distRight ] = xml2struct( sprintf('%s/cal/dist_stereo_right_act.xml', folderLocation ));
distRightString=distRight.opencv_storage.dist_stereo_right_act.data.Text;
distRightString= textscan(distRightString, '%s', 'delimiter', '\n');
distRightString = char(distRightString{1});
[ distortionRight ] = block2line( distRightString );

fc_right=[intrinsicRight(1); intrinsicRight(5)];
cc_right=[intrinsicRight(3);intrinsicRight(6)];
alpha_c_right=intrinsicRight(4)/intrinsicRight(1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Extrinsic Parameters %

[ rot ] = xml2struct( sprintf('%s/cal/Rotation_stereo_act.xml', folderLocation ));
rotString=rot.opencv_storage.Rotation_stereo_act.data.Text;
rotString= textscan(rotString, '%s', 'delimiter', '\n');
rotString = char(rotString{1});
[ rotationArray ] = block2line( rotString );

rotation=reshape(rotationArray,3,3);
rotation=rotation';
om=rodrigues(rotation); % convert [3x3 matrix] Rotation matrix to [3x1 matrix]

[ trans ] = xml2struct( sprintf('%s/cal/Translation_stereo_act.xml', folderLocation ));
transString=trans.opencv_storage.Translation_stereo_act.data.Text;
transString= textscan(transString, '%s', 'delimiter', '\n');
transString = char(transString{1});
[ translation ] = block2line( transString );
translation=translation';


end

