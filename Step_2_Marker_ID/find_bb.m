function [P]=find_bb(cc)


    cc=bwareaopen(cc,1000);
    cc=imfill(cc,'holes');
    prop=regionprops(cc,'BoundingBox');
    P=prop.BoundingBox;
end