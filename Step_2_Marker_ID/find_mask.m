function [correctMask,n ] = find_mask( mask )
for j=1:size(mask,3)
    n(j)=nanmean(nanmean(mask(:,:,j)));
    
    nanmaski=mask(:,:,j);
    nanmaski(isnan(nanmaski))=0;
    nanmask(:,:,j)=nanmaski;
end
nN=isnan(n);
f=find(nN==0);
if length(f)==1
    correctMask=mask(:,:,f);
elseif and(length(f)>1,length(f)<3)
    for i=1:length(f)-1
        correctMask=mask(:,:,f(i))+mask(:,:,f(i+1));
    end
elseif length(f)>2
    correctMask=sum(nanmask,3);
else
    correctMask=mask(:,:,1);
end

end

