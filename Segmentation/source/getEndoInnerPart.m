function [endoMask, heartMask] = getEndoInnerPart(I, nrows, ncols, correctEndo)
% Applying kmeans clustering to get the most intensive and the biggest area 
%(inner part of endocardium, left venticle) and main contour of heart.
 
% Applying kmeans.
ncolors = 4;
I_list = reshape(double(I),nrows*ncols,1);
c = [5; 80; 180];
[cluster_idx, cluster_center] = kmeans(I_list,ncolors);
pixel_labels = reshape(cluster_idx,nrows,ncols);

% Getting a center of the cluster with highest intensity.
[m, max_center] = max(cluster_center);

% Gettint a center of the cluster with second lowest intensity.
[m, min_center] = min(cluster_center);
cluster_center(min_center) = NaN;
[m, i] = min(cluster_center);

% Getting a mask of most intensive areas.
mostIntensiveAreas = pixel_labels == max_center;

% Getting two biggest connected component on the mask of high intensity
% areas (blood cluster), getting more left CC.
endoMask = imfill(getMaxCC(mostIntensiveAreas), 'holes');

% Getting a mask of second unintensive areas (heart tissue cluster).
heartMask = (pixel_labels == i);
heartMask = getMaxCC(heartMask);

% Correcting the mask (optionally).
if correctEndo==true
    se = strel('disk',20);
    %endoMask = imdilate(getMaxCC(imerode(endoMask, se)), se);
    endoMask = imerode(imfill(imdilate(endoMask, se), 'holes'), se);
end