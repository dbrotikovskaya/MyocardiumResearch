function newM = affineTransform(myoM, testA, trainA, scale, endoP1, ncols, nrows, border)
% Apply affine transform (scale, rotate and shift) to mask.

% Get mask center.
rp = regionprops(myoM, 'Centroid','BoundingBox');
cX1 = round(rp(1).Centroid(1));
cY1 = round(rp(1).Centroid(2));

% Apply rotate ang scale transform to mask.
[srM, cX2, cY2] = rotateScaleTransform(imcrop(myoM, rp.BoundingBox), testA, trainA, scale);

% Place cropped scaled rotated mask th its initial center.
startX = cX1 - cX2 + border;
startY = cY1 - cY2 + border;
endX = startX+size(srM, 2);
endY = startY+size(srM, 1);
newM = zeros(nrows + 2*border, ncols + 2*border);
newM(startY+1:endY, startX+1:endX) = srM;

% Get position of myocardium inner center point.
myoP = getFirstPoint(newM, testA);

% Get axis shifts to match calculated myocardium center point with test
% mask endocardium main direction point.
dx = round(endoP1(1) - myoP(1) + border);
dy = round(endoP1(2) - myoP(2) + border);

% Recalculate position of rotated, scaled mask according to calculed axis
% shifts.
startX = cX1 - cX2 + dx + border;
startY = cY1 - cY2 + dy + border;
endX = startX+size(srM, 2);
endY = startY+size(srM, 1);

newM = zeros(nrows + 2*border, ncols + 2*border);
newM(startY+1:endY, startX+1:endX) = srM;