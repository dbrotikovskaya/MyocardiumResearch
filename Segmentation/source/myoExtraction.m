close all;
clear all;

options.correctEndo = true;
options.debug = true;
options.border = 40;

% Reading test image and saving its sizes. 
root = '../data/';
testFilename = '10';
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

if options.debug == true
    size1 = max(size(I, 1), size(trainMyoM, 1));
    size2 = max(size(I, 2), size(trainMyoM, 2));
    
    trainMyoM2 = zeros(size1, size2);
    trainMyoM2(1:size(trainMyoM, 1), 1:size(trainMyoM, 2)) = uint8(trainMyoM);
    
    I2 = uint8(zeros(size1, size2));
    I2(1:size(I, 1), 1:size(I, 2)) = I(:, :, 2);
    I2(edge(trainMyoM2)) = 255;
    imwrite(I2, strcat('../data/results/', testFilename, '_trainMyoMask.png'));
end

newTrainMyoM = affineTransform(trainMyoM, testA, trainA, scale, testEndoP1, ncols, nrows, options.border);

se = strel('disk',30);
newTrainMyoM2 = imdilate(newTrainMyoM, se);

heartM2 = uint8(zeros(size(heartM, 1) + 2*options.border, size(heartM, 2) + 2*options.border));
heartM2(options.border+1:end-options.border, options.border+1:end-options.border) = uint8(heartM);

if options.debug==true
    I2 = uint8(zeros(size(I, 1) + 2*options.border, size(I, 2) + 2*options.border));
    I2(options.border+1:end-options.border, options.border+1:end-options.border) = uint8(I(:, :, 2));
    I2 = I2 .* uint8(newTrainMyoM2);
    I2(edge(heartM2))=255;
    imwrite(I2, strcat('../data/results/', testFilename, '_myoMaskDilated.png'));
end

heartM2 = getMaxCC(heartM2 .* uint8(newTrainMyoM2));

se = strel('disk',5);
heartM3 = imdilate(getMaxCC(imerode(heartM2, se)), se);

I2 = uint8(zeros(size(I, 1) + 2*options.border, size(I, 2) + 2*options.border));
I2(options.border+1:end-options.border, options.border+1:end-options.border) = uint8(I(:, :, 2));
I2(edge(heartM3))=255;
imwrite(I2, strcat(root, 'results/final/', testFilename, '_final.png'));