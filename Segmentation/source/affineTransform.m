function newM = affineTransform(myoM, testA, trainA, scale, endoP1, ncols, nrows)

rp = regionprops(myoM, 'Centroid','BoundingBox');
cX1 = round(rp(1).Centroid(1));
cY1 = round(rp(1).Centroid(2));

[srM, cX2, cY2] = rotateScaleTransform(imcrop(myoM, rp.BoundingBox), testA, trainA, scale);

startX = cX1 - cX2 + 20;
startY = cY1 - cY2 + 20;
endX = startX+size(srM, 2);
endY = startY+size(srM, 1);

newM = zeros(nrows + 40, ncols + 40);
newM(startY+1:endY, startX+1:endX) = srM;

%figure;
%imshow(newM);

myoP = getFirstPoint(newM, testA);

endoP1;
myoP;

dx = round(endoP1(1) - myoP(1) + 20);
dy = round(endoP1(2) - myoP(2) + 20);

startX = cX1 - cX2 + dx + 20;
startY = cY1 - cY2 + dy + 20;
endX = startX+size(srM, 2);
endY = startY+size(srM, 1);

newM = zeros(nrows + 40, ncols + 40);
newM(startY+1:endY, startX+1:endX) = srM;