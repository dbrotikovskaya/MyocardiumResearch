function newM = analyzeWidth(M, alpha)

M = logical(M);
rp = regionprops(M, 'Centroid');
cX = round(rp.Centroid(1));
cY = round(rp.Centroid(2));

dList = double(zeros(360, 2));
for angle = cat(2, 1:89, 91:269, 271:360)
    p = getPointList(M, angle);
    localDList = [];
    for i=1:round(size(p, 1)/2)
        d = sqrt((p(i, 2)-p(i+1, 2))^2 + (p(i, 1)-p(i+1, 1))^2);
        localDList = [localDList; d];
    end
    
    if size(p, 1)>0   
        [m, i] = max(localDList);
        i = 2 * (i-1) + 1;
        pList{angle} = [p(i, :), p(i+1, :)];
        dList(angle, 1) = sqrt((p(i, 2)-cY)^2 + (p(i, 1)-cX)^2);
        dList(angle, 2) = sqrt((p(i+1, 2)-cY)^2 + (p(i+1, 1)-cX)^2);
        ddist = (dList(angle, 2) - dList(angle, 1)) / 2;
        dList(angle, 1) = dList(angle, 1) - ddist;
        dList(angle, 2) = dList(angle, 2) + ddist;
    end
end

[pList, dList] = fillGaps(pList, dList);

newM = filterWidth(M, dList, pList, alpha);