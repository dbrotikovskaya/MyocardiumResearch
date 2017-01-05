% This is main file of algorithm

path = '../data/segmented/';
filename = 'all1.jpg';

I = imread(strcat(path, filename));
M = I(:, :, 1)>I(:, :, 2);

se = strel('disk',4);
se2 = strel('disk',2);

M = imdilate(imerode(M, se), se2);

imshow(M);