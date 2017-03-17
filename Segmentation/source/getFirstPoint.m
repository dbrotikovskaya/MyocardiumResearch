function p = getFirstPoint(M, angle)
% Get nearest mask point in a given direction from mask center.

% Get mask center.
rp =  regionprops((M), 'Centroid');
cX = round(rp(1).Centroid(1));
cY = round(rp(1).Centroid(2));

% Calculate mask image size.
sizeX = size(M, 2);
sizeY = size(M, 1);

% Define search interval.
if angle < 90
    x1 = cX;
    y1 = cY;
    xFin = sizeX;
else
    x1 = 1;
    y1 = 1;
    xFin = sizeX;
end

% Calculate search line coefficients.
k = -double(tan(angle * pi /180));
b = double(y1) - double(x1 * k);

% Find first mask point on the search line.
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