function newM = affineTransform(myoM, testA, trainA, scale, endoP1, ncols, nrows, border)

rp = regionprops(myoM, 'Centroid','BoundingBox');
cX1 = round(rp(1).Centroid(1));
cY1 = round(rp(1).Centroid(2));

[srM, cX2, cY2] = rotateScaleTransform(imcrop(myoM, rp.BoundingBox), testA, trainA, scale);

startX = cX1 - cX2 + border;
startY = cY1 - cY2 + border;
endX = startX+size(srM, 2);
endY = startY+size(srM, 1);

newM = zeros(nrows + 2*border, ncols + 2*border);
newM(startY+1:endY, startX+1:endX) = srM;

myoP = getFirstPoint(newM, testA);

dx = round(endoP1(1) - myoP(1) + border);
dy = round(endoP1(2) - myoP(2) + border);

startX = cX1 - cX2 + dx + border;
startY = cY1 - cY2 + dy + border;
endX = startX+size(srM, 2);
endY = startY+size(srM, 1);

newM = zeros(nrows + 2*border, ncols + 2*border);
newM(startY+1:endY, startX+1:endX) = srM;