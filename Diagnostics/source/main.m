% This is main file of algorithm

path = '../data/segmented/';
filename = 'ryth.jpg';

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

for x=minX:20:cX
     midY = k * x + b;
     x, midY
end

imshow(B);
line([minX, cX], [k * minX + b, cY]);
