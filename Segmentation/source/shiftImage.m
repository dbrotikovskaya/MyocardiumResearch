function newMask = shiftImage(M, xShift, yShift)

newMask = zeros(size(M));

rp = regionprops(M, 'PixelList');
sizeL = size(rp.PixelList, 1);
for i=1:sizeL
    pX = min(max(rp.PixelList(i, 1)+xShift, 0), size(M, 1));
    pY = min(max(rp.PixelList(i, 2)+yShift, 0), size(M, 2));
    newMask(pY, pX) = 1;
end