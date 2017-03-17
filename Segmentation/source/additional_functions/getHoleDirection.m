function [alpha, p, d, cX, cY] = getHoleDirection(M)

rp = regionprops(M, 'Centroid', 'PixelList');
sizeL = size(rp.PixelList, 1);
cX = round(rp(1).Centroid(1));
cY = round(rp(1).Centroid(2));

pOnAngle = zeros(360, 1);
pList = zeros(360, 2);
dList = zeros(360, 1);
dList(:) = 1000;
for i=1:sizeL
    p = rp.PixelList(i, :);
    angle = round(atan2(p(2)-cY, cX-p(1))*180/pi + 180);
    if angle==360 angle = 0; end
    d = sqrt((p(2)-cY)^2 + (p(1)-cX)^2);
    pOnAngle(angle+1) = pOnAngle(angle+1) + 1;
    if d < dList(angle+1)
        dList(angle+1) = d;
        pList(angle+1, :) = p;
    end
end

flag = 0;
for i=1:size(pOnAngle, 1)
    if pOnAngle(i) == 0
        if flag == 0
            flag = 1;
            st = i;
        else
            fin = i;
        end
    end
end

alpha = round((st + fin)/2 - 180);
p = pList(alpha, :);
d = dList(angle+1);