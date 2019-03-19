function [ chessLeft, chessRight ] = get_chessboard_points( folderLocation,medium )

if nargin<2
    medium='RW';
end

[ leftRW ] = xml2struct( sprintf('%s/cal/chess_left_%s.xml', folderLocation,medium ));
leftRWString=leftRW.opencv_storage.chess_left_rw.data.Text;

[ rightRW ] = xml2struct( sprintf('%s/cal/chess_right_%s.xml', folderLocation,medium ));
rightRWString=rightRW.opencv_storage.chess_right_rw.data.Text;



leftRWString= textscan(leftRWString, '%s', 'delimiter', '\n');
leftRWString = char(leftRWString{1});
[ allChessLeft ] = block2line( leftRWString );
chessLeft=reshape(allChessLeft,2,length(allChessLeft)/2);



rightRWString= textscan(rightRWString, '%s', 'delimiter', '\n');
rightRWString = char(rightRWString{1});
[ allChessRight ] = block2line( rightRWString );
chessRight=reshape(allChessRight,2,length(allChessRight)/2);


end

