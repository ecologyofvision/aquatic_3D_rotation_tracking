function [ line ] = block2line( textBlock )
% 
s=size(textBlock,1);
string=zeros(s,10)*NaN;


for i=1:s-1
    at=str2num(textBlock(i+1,:));
    string(i,1:length(at))=at;
end

line=string';
line(isnan(line))=[];


end

