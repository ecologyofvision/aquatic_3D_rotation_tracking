function [ x,y ] = cor_ref( A,B,D,E,xi,yi,s )
% function to correct refraction error

%A =  %x coordinate of left camera
%B =  %z coordinate of left camera

%D =  %x coordinate of right camera
%E =  %z coordinate of right camera

%xi =  %apparent x value [water]
%yi = %apparent z value [water]

%s = depth

nw=1.33; % refractive index of water

mL=(yi-B)/(xi-A);
signml=sign(mL);

mR=(E-yi)/(D-xi);
signmr=sign(mR);

a=(s-B+(mL*A))/mL;

d=(s-E+(mR*D))/mR;

thetaL=90-atand(abs(mL));
thetaR=90-atand(abs(mR));

phiL=asind(sind(thetaL)/nw);
phiR=asind(sind(thetaR)/nw);

mrL=signml*(tand(90-phiL));
mrR=signmr*(tand(90-phiR));

cL=s-mrL*a;
cR=s-mrR*d;

x=(cR-cL)/(mrL-mrR);
y=mrL*x+cL;

end