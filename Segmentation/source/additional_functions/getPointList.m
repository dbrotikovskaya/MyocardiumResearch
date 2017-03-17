function p = getPointList(M, angle)

M = logical(M);
rp =  regionprops(M, 'Centroid');
cX = round(rp.Centroid(1));
cY = round(rp.Centroid(2));

sizeX = size(M, 2);
sizeY = size(M, 1);

if angle > 90 && angle < 270
    x1 = cX;
    y1 = cY;
    dx = -1;
    xFin = 1;
else
    x1 = cX;
    y1 = cY;
    dx = 1;
    xFin = sizeX;
end

k = -double(tan(angle * pi /180));
b = double(y1) - double(x1 * k);
p = [];
in = false;
for x=x1:dx:max(xFin-1, 1)
    y = round(x * k + b);
    if y > 0 && y < sizeY
        if M(y, x) == ~in
            p = [p; x, y];
            in = ~in;
        end
    elseif y > 0 && y < sizeY
        if M(y+1, x) == ~in
            p = [p; x, y+1];
            in = ~in;
        end
    elseif y > 0 && y < sizeY+1
        if M(y-1, x) == ~in
            p = [p; x, y-1];
            in = ~in;
        end
    end
end