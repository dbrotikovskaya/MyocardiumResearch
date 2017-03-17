function newM = filterWidth(M, dList, pList, alpha)

newM = zeros(size(M));
rp = regionprops(M, 'PixelList', 'Centroid');
sizeL = size(rp.PixelList, 1);
cX = round(rp.Centroid(1));
cY = round(rp.Centroid(2));

for i=1:sizeL
    p = rp.PixelList(i, :);
    angle = round(atan2(p(2)-cY, cX-p(1))*180/pi + 180);
    d = sqrt((p(2)-cY)^2 + (p(1)-cX)^2);
    if d >= dList(angle, 1) && d <= dList(angle, 2)
        newM(p(2), p(1)) = 255;
    end
end
