function [ dot1,dot2,line1,line2,c1,c2,L,dD1,dD2,dL1,dL2,In ] = sep_points_lite_i(fr,thrVal, allLocs,dotn1,dotn2,linen1,linen2,s,initialAssignment )

% fr = frame
% intialAssignment
 
if fr==initialAssignment
    dot1(1:5,1)=allLocs(1:5,s(1),1);
    dot2(1:5,1)=allLocs(1:5,s(2),1);
    line1(1:5,1)=allLocs(1:5,s(3),1);
    line2(1:5,1)=allLocs(1:5,s(4),1);
    
    In=[ 1 2 3 4];

    dD1=zeros(1,30);
    dD2=zeros(1,30);
    dL1=zeros(1,30);
    dL2=zeros(1,30);
    L=4;
    c1=0;
    c2=0;
else
    
    [ indD1(1,:),mD1(1,:),dD1(1,:) ] = close_match_add( allLocs(1:5,:), dotn1(1:5,1) );
    [ indD2(1,:),mD2(1,:),dD2(1,:) ] = close_match_add( allLocs(1:5,:), dotn2(1:5,1) );
    [ indL1(1,:),mL1(1,:),dL1(1,:) ] = close_match_add( allLocs(1:5,:), linen1(1:5,1) );
    [ indL2(1,:),mL2(1,:),dL2(1,:) ] = close_match_add( allLocs(1:5,:), linen2(1:5,1) );
    
    
    In=[indD1(1,1) indD2(1,1) indL1(1,1) indL2(1,1)];
    vals=[mD1(1,1) mD2(1,1) mL1(1,1) mL2(1,1)];
    
    un=length(unique(In));
    
    lt=allLocs(1,:,:);
    lt(lt==0)=[];
    L=length(lt);
    
    
    
    if and(un<4, L>3)
        a=dD1(1,:);
        b=dD2(1,:);
        c=dL1(1,:);
        d=dL2(1,:);
        
        c1=combvec(1:4,5:8);
        c2=combvec(9:12,13:16);
        C=combvec(c1,c2);
        
        C1=C(1,:);
        C2=C(2,:)-4;
        C3=C(3,:)-8;
        C4=C(4,:)-12;
        
        for k=1:length(C1)
            
            com(k,:)=[C1(k) C2(k) C3(k) C4(k)];
            com2(k,:)=[ indD1(1,C1(k)) indD2(1,C2(k)) indL1(1,C3(k)) indL2(1,C4(k))];
            u(k)=length(unique(com2(k,:)));
            if u(k)==4
                %                 s(k)=m
                s(k)=a(indD1(1,C1(k)))+b(indD2(1,C2(k)))+c(indL1(1,C3(k)))+d(indL2(1,C4(k)));
            else
                s(k)=100;
            end
        end
        
        minim=min(s);
        f=find(s==minim);
        
        cb=com(f,:);
        cb2=com2(f,:);
        
        
        
        if dD1(1,cb2(1))>11 %*
            dot1(1:5,1)= dotn1(1:5,1);
            c1=1;
        else
            dot1(1:5,1)=allLocs(1:5,cb2(1),1);
            c1=0;
        end
        
        if dD2(1,cb2(2))>11 %*
            dot2(1:5,1)= dotn2(1:5,1);
            c2=1;
        else
            dot2(1:5,1)=allLocs(1:5,cb2(2),1);
            c2=0;
        end
        
        
        if dL1(1,cb2(3))>11 %*
            line1(1:5,1)= linen1(1:5,1);
        else
            line1(1:5,1)=allLocs(1:5,cb2(3),1);
        end
        
        if dL2(1,cb2(4))>11 %*
            line2(1:5,1)= linen2(1:5,1);
        else
            line2(1:5,1)=allLocs(1:5,cb2(4),1);
        end
        
    else
        clear cb2
        cb2=In;
        cb=[mD1(1,1) mD2(1,1) mL1(1,1) mL2(1,1)];
        
        if mD1(1,1)>thrVal
            dot1(1:5,1)= dotn1(1:5,1);
            c1=1;
        else
            dot1(1:5,1)=allLocs(1:5,cb2(1),1);
            c1=0;
        end
        
        if mD2(1,1)>thrVal
            dot2(1:5,1)= dotn2(1:5,1);
            c2=1;
        else
            dot2(1:5,1)=allLocs(1:5,cb2(2),1);
            c2=0;
        end
        
        
        if mL1(1,1)>thrVal
            line1(1:5,1)= linen1(1:5,1);
        else
            line1(1:5,1)=allLocs(1:5,cb2(3),1);
        end
        
        if mL2(1,1)>thrVal
            line2(1:5,1)= linen2(1:5,1);
        else
            line2(1:5,1)=allLocs(1:5,cb2(4),1);
        end
        
    end
    
    if L==3
        if dot1(1:2,1)==dot2(1:2,1)
            if dD1(1,cb2(1))<dD2(1,cb2(2))
                dot2(1:5,1)=dotn2(1:5,1);
            else
                dot1(1:5,1)=dotn1(1:5,1);
            end
        elseif dot1(1:2,1)==line1(1:2,1)
            if dD1(1,cb2(1))<dL1(1,cb2(3))
                line1(1:5,1)=linen1(1:5,1);
            else
                dot1(1:5,1)=dotn1(1:5,1);
            end
        elseif dot1(1:2,1)==line2(1:2,1)
            if dD1(1,cb2(1))<dL2(1,cb2(4))
                line2(1:5,1)=linen2(1:5,1);
            else
                dot1(1:5,1)=dotn1(1:5,1);
            end
        elseif dot2(1:2,1)==line1(1:2,1)
            if mD2(1,cb2(2))<mL1(1,cb2(3))
                line1(1:5,1)=linen1(1:5,1);
            else
                dot2(1:5,1)=dotn2(1:5,1);
            end
        elseif dot2(1:2,1)==line2(1:2,1)
            if dD2(1,cb2(2))<dL2(1,cb2(4))
                line2(1:5,1)=linen2(1:5,1);
            else
                dot2(1:5,1)=dotn2(1:5,1);
            end
        elseif line1(1:2,1)==line2(1:2,1)
            if dL1(1,cb2(3))<dL2(1,cb2(4))
                line2(1:5,1)=linen2(1:5,1);
            else
                line1(1:5,1)=linen1(1:5,1);
            end
        end
    end
    
    if L<3
        dot1(1:5,1)=dotn1(1:5,1);
        dot2(1:5,1)=dotn2(1:5,1);
    line1(1:5,1)=linen1(1:5,1);
    line2(1:5,1)=linen2(1:5,1);
    end
end
 
 
 
end