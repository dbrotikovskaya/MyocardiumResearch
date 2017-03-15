function p = getFirstPoint(M, angle)

rp =  regionprops((M), 'Centroid');
cX = round(rp(1).Centroid(1));
cY = round(rp(1).Centroid(2));

sizeX = size(M, 2);
sizeY = size(M, 1);

if angle < 90
    x1 = cX;
    y1 = cY;
    xFin = sizeX;
else
    x1 = 1;
    y1 = 1;
    xFin = sizeX;
end

k = -double(tan(angle * pi /180));
b = double(y1) - double(x1 * k);
p = [-1, -1];
for x=x1:xFin
    y = round(x * k + b);
    if M(y, x)>0
        p = [x, y];
        break;
    elseif M(y+1, x)>0
        p = [x, y+1];
        break;
    elseif M(y-1, x)>0
        p = [x, y-1];
        break;
    end
end