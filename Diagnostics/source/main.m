% This is main file of algorithm

path = '../data/segmented/';
filename = 'norm.jpg';

I = imread(strcat(path, filename));
M = I(:, :, 1)>I(:, :, 2);

se = strel('disk',4);
se2 = strel('disk',2);

M = imdilate(imerode(M, se), se2);
rp = regionprops(M, 'Centroid', 'MajorAxisLength', 'MinorAxisLength', 'Orientation');
B = edge(M);

if rp.Orientation<0
    alpha = rp.Orientation + 90 + 30;
else
    alpha = rp.Orientation - 30;
end

cX = rp.Centroid(1);
cY = rp.Centroid(2);
minX = cX - (rp.MajorAxisLength/2)*cosd(alpha);

k = tand(180-alpha);
b = cY - k * cX;

imshow(B);

upPoints = [];
downPoints = []; 
for x = minX:5:cX
     midY = k * x + b;
     minY = midY - (rp.MinorAxisLength/2)*sind(90-alpha);
     maxY = midY + (rp.MinorAxisLength/2)*sind(90-alpha);
     k1 = tand(90-alpha);
     b1 = midY - k1*x;
     pl = [];
     for y = minY:cY
        x2 = (y - b1)/k1;
        if (B(floor(x2)-1, floor(y)-1)==1)
            pl = [pl, [x2, y]];
        end
     end
     downPoints = [downPoints, pl];
     
     pl = [];
     for y = cY:maxY
        x2 = (y - b1)/k1;
        if (B(floor(x2)-1, floor(y)-1)==1)
            pl = [pl, [x2, y]];
        end
     end
     upPoints = [upPoints, pl];
     line([(minY - b1)/k1, (maxY - b1)/k1], [minY, maxY]);
     h = animatedline([cX, x], [cY, y]);
     getpoints(h);
end

roundPoints = [];
for phi=(alpha+90): -10 : (alpha-90)
    pl = [];
    x = cX + (rp.MajorAxisLength*2/3)*cosd(phi);
    y = cY - (rp.MinorAxisLength*2/3)*sind(phi);
    k = (cY-y)/(cX-x);
    b = cY - k*cX;
    for y2 = cY:y
        x2 = (y2 - b)/k2;
        if (B(floor(x2)-1, floor(y2)-1)==1)
            pl = [pl, [x2, y2]];
        end
    end
    line([cX, x], [cY, y]);
    roundPoints = [roundPoints, pl];
end
