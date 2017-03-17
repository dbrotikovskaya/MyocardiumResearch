function [alpha, pAxis1, dAxis1, pAxis2, dAxis2, cX, cY] = getMaxAxis(M)
% Get direction of main axis, its length, corresponding point on the mask,
% lenth and point in the direction of second mask axis.

% Getting the center and pixel list of the area on the mask.
rp = regionprops(M, 'Centroid', 'PixelList');
sizeL = size(rp.PixelList, 1);
cX = round(rp(1).Centroid(1));
cY = round(rp(1).Centroid(2));

% Getting the most far from the center point (pAxis1)
% (its coordinates and distance and angle according to mask center). 
dAxis1 = -1;
pAxis1 = [0, 0];
alpha = -1;

maxVList = ones(360, 1)*(-1);
pList = zeros(360, 2);
for i=1:sizeL
    p = rp.PixelList(i, :);
    angle = round(atan2(p(2)-cY, cX-p(1))*180/pi + 180) + 1;
    if angle==361 angle = 1; end
    d = sqrt((p(2)-cY)^2 + (p(1)-cX)^2);
    if (angle <= 180) && (d > dAxis1)
        dAxis1 = d;
        pAxis1(:) = p;
        alpha = angle;
    end
    if (d > maxVList(angle))
        maxVList(angle) = d;
        pList(angle, :) = p;
    end
end

% Get most far point of second axis and its distance (pAxis2, dAxis2).
dAxis2 = maxVList(alpha + 90);
pAxis2 = pList(alpha + 90, :);

% Calculate full length on main and second axis.
dAxis1 = dAxis1 + maxVList(alpha + 180);

if alpha > 90
    dAxis2 = dAxis2 + maxVList(alpha - 90);
else
    dAxis2 = dAxis2 + maxVList(360 - (90 - alpha));
end
