function [newMatrix ] = rem_zeros(matrix )
% removes zeros

zInd=find(matrix(1,:)~=0);
newMatrix=matrix(:,zInd);

end

