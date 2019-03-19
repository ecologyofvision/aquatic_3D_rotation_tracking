function [ G ] = generateReferenceGrid( cols, rows )
% generates the coordinates of the reference grid, given the number of rows
% and columns (cols) of the chessboard used during calibration

G=zeros(3,rows*cols);

st=1:cols:((rows*cols)-cols)+1;
en=cols:cols:rows*cols;

for i=1:rows
    G(2,st(i):en(i))=ones(1,cols)*(i-1);
    G(1,st(i):en(i))=0:cols-1;
end

end

