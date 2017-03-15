function [newM, cX, cY] = rotateScaleTransform(M, testAngle, trainAngle, scale)

M = imrotate(M, -trainAngle);
rp = regionprops(M, 'BoundingBox');
M = imcrop(M, rp.BoundingBox);

tform = affine2d([scale(2) 0 0; 0 scale(1) 0; 0 0 1]);
M = imwarp(M,tform);

M = imrotate(M, testAngle);
rp = regionprops(M, 'BoundingBox');
newM = imcrop(M, rp.BoundingBox);

rp = regionprops(newM, 'Centroid');
cX = round(rp(1).Centroid(1));
cY = round(rp(1).Centroid(2));