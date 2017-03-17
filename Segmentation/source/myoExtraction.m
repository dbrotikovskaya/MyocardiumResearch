close all;
clear all;

options.correctEndo = true;
options.debug = true;
options.border = 50;

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
    print(strcat(root, 'results/anisodiff/', testFilename, '_anisodiff'), '-dpng');
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
    print(strcat(root, 'results/axis/', testFilename, '_testAxis'), '-dpng');
end

% Reading training file with endocardium mask.
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
    print(strcat(root, 'results/axis/', testFilename, '_trainAxis'), '-dpng');
end

% Reading training file with myocardium mask. 
trainMyoMRGB = imread(strcat(root, 'train/masks/', trainFileName, '.png'));

% Getting binary training mask contour.
trainMyoM = imfill(trainMyoMRGB(:, :, 1)>trainMyoMRGB(:, :, 2), 'holes');

% Calculating scale between test and training endocardium masks.
scale = [double(testD2/trainD2), double(testD1/trainD1)];

% Showing the initial form of training myocardium mask. 
if options.debug == true
    size1 = max(size(I, 1), size(trainMyoM, 1));
    size2 = max(size(I, 2), size(trainMyoM, 2));
    
    trainMyoM2 = zeros(size1, size2);
    trainMyoM2(1:size(trainMyoM, 1), 1:size(trainMyoM, 2)) = uint8(trainMyoM);
    
    MaskedI = uint8(zeros(size1, size2));
    MaskedI(1:size(I, 1), 1:size(I, 2)) = I(:, :, 2);
    MaskedI(edge(trainMyoM2)) = 255;
    imwrite(MaskedI, strcat('../data/results/initial_mask/', testFilename, '_trainMyoMask.png'));
end

% Applying affine transform (scale, rotation and shift of training myocardium
% to fit test file).
testMyoAreaM = affineTransform(trainMyoM, testA, trainA, scale, testEndoP1, ncols, nrows, options.border);

% Showing myocardium mask taken from affine transform.
if options.debug==true
    MaskedI = uint8(zeros(size(I, 1) + 2*options.border, size(I, 2) + 2*options.border));
    MaskedI(options.border+1:end-options.border, options.border+1:end-options.border) = uint8(I(:, :, 2));
    MaskedI(edge(testMyoAreaM))=255;
    imwrite(MaskedI, strcat('../data/results/affine_transform/', testFilename, '_myoMaskDilated.png'));
end

% Applying dilation to transformed myocardium mask to get myocardium area.
se = strel('disk',30);
testMyoAreaM = imdilate(testMyoAreaM, se);

% Enlarge initial heart mask to fit myocardium mask taken from affine
% transform.
heartBorderM = uint8(zeros(size(heartM, 1) + 2*options.border, size(heartM, 2) + 2*options.border));
heartBorderM(options.border+1:end-options.border, options.border+1:end-options.border) = uint8(heartM);

% Showing dilated myocardium mask taken from affine transform.
if options.debug==true
    MaskedI = uint8(zeros(size(I, 1) + 2*options.border, size(I, 2) + 2*options.border));
    MaskedI(options.border+1:end-options.border, options.border+1:end-options.border) = uint8(I(:, :, 2));
    MaskedI = MaskedI .* uint8(testMyoAreaM);
    MaskedI(edge(heartBorderM))=255;
    imwrite(MaskedI, strcat('../data/results/myo_contour_on_region/', testFilename, '_myoMaskDilated.png'));
end

% Get heart mask part that fits myocardium mask taken from affine transform.
testMyoM = getMaxCC(heartBorderM .* uint8(testMyoAreaM));

% Applying morphological opening to correct final myocardoum mask.
se = strel('disk',5);
testMyoM = imdilate(getMaxCC(imerode(testMyoM, se)), se);

% Showing masked initial image.
MaskedI = uint8(zeros(size(I, 1) + 2*options.border, size(I, 2) + 2*options.border));
MaskedI(options.border+1:end-options.border, options.border+1:end-options.border) = uint8(I(:, :, 2));
MaskedI(edge(testMyoM)) = 255;
imwrite(MaskedI, strcat(root, 'results/final/', testFilename, '_final.png'));