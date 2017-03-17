function [newM, cX, cY] = rotateScaleTransform(M, testAngle, trainAngle, scale)
% Apply rotate and scale transform to mask M.

% Rotate mask to bring mask main axis into horizontal position. 
M = imrotate(M, -trainAngle);
rp = regionprops(M, 'BoundingBox');
M = imcrop(M, rp.BoundingBox);

% Scale mask to fit test image.
tform = affine2d([scale(2) 0 0; 0 scale(1) 0; 0 0 1]);
M = imwarp(M,tform);

% Rotate mask to fit test image.
M = imrotate(M, testAngle);
rp = regionprops(M, 'BoundingBox');
newM = imcrop(M, rp.BoundingBox);

% Get result mask center.
rp = regionprops(newM, 'Centroid');
cX = round(rp(1).Centroid(1));
cY = round(rp(1).Centroid(2));