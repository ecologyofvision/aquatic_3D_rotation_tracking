function [ x,y,z ] = refraction( water,camLeft,camRight,waterDepth )

    % Set-up the problem
    A = camLeft(1); %x coordinate of left camera
    B = camLeft(3); %z coordinate of left camera
    
    D = camRight(1); %x coordinate of right camera
    E = camRight(3); %z coordinate of right camera
    

    
    for i=1:size(water,2)
        
        xi(i) = water(1,i); %apparent x value [water]
        yi(i) = water(2,i); %apparent y value [water]
        zi(i) = water(3,i); %apparent z value [water]
        
        [ x(i),z(i) ] = cor_ref( A,B,D,E,xi(i),zi(i),waterDepth ); %actual x,z
        [ y(i) ] = cor_ref( A,B,D,E,yi(i),zi(i),waterDepth ); %actual y
    end


end