function [RB,I] = dist_2point( red, blue )
RB= red-blue;
RB=RB.*RB;
RB=sum(RB);
RB=sqrt(RB);
I=[ 0 RB  ; 0 0; 0 0 ];
end

