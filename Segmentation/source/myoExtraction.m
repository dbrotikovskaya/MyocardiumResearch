close all;
clear all;

options.correctEndo = true;
options.debug = false;

% Reading test image and saving its sizes. 
root = '../data/';
testFilename = '1';
I = imread(strcat(root, 'test/cropped/', testFilename, '.jpg'));
nrows = size(I,1);
ncols = size(I,2);

diffI = anisodiff2D(I(:,:,2), 10, 1/8, 50, 1);

if options.debug==true
    figure('Visible', 'off'); 
    imshow(diffI, []);
    print(strcat(root, 'results/', testFilename, '_anisodiff'), '-dpng');
end

% Applying kmeans clustering to get the most intensive area (inner part of 
% endocardium).
[testEndoM, heartM] = getEndoInnerPart(diffI, nrows, ncols, options.correctEndo);

% Getting endo angle of maximum axis, vector of main axis direction 
% and center of the mask.  
[testA, testEndoP1, testD1, testEndoP2, testD2, testEndoCX, testEndoCY] = getMaxAxis(testEndoM);

% Showing the direction of main axis.
if options.debug==true
    figure('Visible', 'off'); 
    hold on
    imshow(testEndoM); hold on
    line([testEndoCX, testEndoP1(1)], [testEndoCY, testEndoP1(2)]);
    line([testEndoCX, testEndoP2(1)], [testEndoCY, testEndoP2(2)]);
    print(strcat(root, 'results/', testFilename, '_testAxis'), '-dpng');
end

% Reading training file.
trainFileName = '3_3';
trainEndoMRGB = imread(strcat(root, 'train/endomasks/', trainFileName, '.png'));

% Getting binary training mask contour.
trainEndoM = imfill(trainEndoMRGB(:, :, 1)>trainEndoMRGB(:, :, 2), 'holes');
[trainA, trainEndoP1, trainD1, trainEndoP2, trainD2, trainEndoCX, trainEndoCY] = getMaxAxis(trainEndoM);

% Showing the direction of main axis.
if options.debug==true
    figure('Visible', 'off'); 
    hold on
    imshow(trainEndoM); hold on
    line([trainEndoCX, trainEndoP1(1)], [trainEndoCY, trainEndoP1(2)]);
    line([trainEndoCX, trainEndoP2(1)], [trainEndoCY, trainEndoP2(2)]);
    print(strcat(root, 'results/', testFilename, '_trainAxis'), '-dpng');
end

trainMyoMRGB = imread(strcat(root, 'train/masks/', trainFileName, '.png'));

% Getting binary training mask contour.
trainMyoM = imfill(trainMyoMRGB(:, :, 1)>trainMyoMRGB(:, :, 2), 'holes');


scale = [double(testD2/trainD2), double(testD1/trainD1)];

if options.debug==true
    I2 = I(:, :, 2);
    I2(edge(trainMyoM(1:size(I, 1), 1:size(I, 2))))=255;
    imwrite(I2, strcat('../data/results/', testFilename, '_trainMyoMask.png'));
end

newTrainMyoM = affineTransform(trainMyoM, testA, trainA, scale, testEndoP1, ncols, nrows);

se = strel('disk',30);
newTrainMyoM2 = imdilate(newTrainMyoM, se);

heartM2 = uint8(zeros(size(heartM, 1) + 40, size(heartM, 2) + 40));
heartM2(21:end-20, 21:end-20) = uint8(heartM);

if options.debug==true
    I2 = uint8(zeros(size(I, 1) + 40, size(I, 2) + 40));
    I2(21:end-20, 21:end-20) = uint8(I(:, :, 2));
    I2 = I2 .* uint8(newTrainMyoM2);
    I2(edge(heartM2))=255;
    imwrite(I2, strcat('../data/results/', testFilename, '_myoMaskDilated.png'));
end

heartM2 = getMaxCC(heartM2 .* uint8(newTrainMyoM2));

I2 = uint8(zeros(size(I, 1) + 40, size(I, 2) + 40));
I2(21:end-20, 21:end-20) = uint8(I(:, :, 2));
I2(edge(heartM2))=255;
imwrite(I2, strcat(root, 'results/final/', testFilename, '_final.png'));