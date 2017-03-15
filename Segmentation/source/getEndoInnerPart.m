function [endoMask, heartMask] = getEndoInnerPart(I, nrows, ncols, correctEndo)
% Applying kmeans clustering to get the most intensive and the biggest area 
%(inner part of endocardium).
 
filename = '1';

% Applying kmeans
ncolors = 4;
I_list = reshape(double(I),nrows*ncols,1);
c = [5; 80; 180];
[cluster_idx, cluster_center] = kmeans(I_list,ncolors);
pixel_labels = reshape(cluster_idx,nrows,ncols);

%figure('Visible', 'off'); 
%imshow(pixel_labels, []);
%print(strcat('../data/results/', filename, '_kmeans'), '-dpng');

% Getting a center of the cluster with highest intensity.
[m, max_center] = max(cluster_center);
[m, min_center] = min(cluster_center);
cluster_center(max_center) = NaN;

[m, i1] = max(cluster_center);
i2 = 10 - i1 - max_center - min_center;

% Getting a mask of these areas.
mostIntensiveAreas = pixel_labels == max_center;
intensiveAreas = pixel_labels == i1;
intensiveAreas = intensiveAreas + mostIntensiveAreas;
intensiveAreas = intensiveAreas > 0;

heartMask = (pixel_labels == i2);
heartMask = getMaxCC(heartMask);

%imwrite(heartMask, strcat('../data/results/', filename, '_heartMask.png'));

% Getting the biggest connected component on the mask of hight intensity
% areas.
endoMask = imfill(getMaxCC(mostIntensiveAreas), 'holes');

% Correcting the mask (optionally).
if correctEndo==true
    se = strel('disk',20);
    %endoMask = imdilate(getMaxCC(imerode(endoMask, se)), se);
    endoMask = imerode(imfill(imdilate(endoMask, se), 'holes'), se);
end

%imwrite(endoMask, strcat('../data/results/', filename, '_myoInnerPartMask.png'));