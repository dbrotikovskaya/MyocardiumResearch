function [pList2, dList2] = fillGaps(pList, dList)

startP = 1;
finalP = 360;
st = 0;
fin = 1;
while st < fin
    flag = 0;
    st = 0;
    fin = 0;
    for i=startP:finalP
        if dList(i, 1) == 0
            if flag==0
                st = i;
                flag = 1;
            else
                fin = i;
            end
        else
            if flag==1
                break;
            end
        end
    end
    
    if fin-st < 30 && fin > st
        for i=st:round((fin+st)/2)
            dList(i, :) = dList(st-1, :);
            pList{i} = pList{st-1};
        end
        for i=round((fin+st)/2)+1:fin
            dList(i, :) = dList(fin+1, :);
            pList{i} = pList{fin+1};
        end
    end
    startP = fin+1;
end

dList2 = dList;
pList2 = pList;