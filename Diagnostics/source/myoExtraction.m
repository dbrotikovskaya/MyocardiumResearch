root = '../data/';
path_i = 'initial/';
filename = 'ryth';
I = imread(strcat(root, path_i, filename, '.jpg'));

nrows = size(I,1);
ncols = size(I,2);
ncolors = 3;
I_list = reshape(double(I(:, :, 2)),nrows*ncols,1);
c = [10; 100; 200];
[cluster_idx, cluster_center] = kmeans(I_list,ncolors,'MaxIter',3,'Start',c);
pixel_labels = reshape(cluster_idx,nrows,ncols);

[m, max_center] = max(cluster_center);
[m, min_center] = min(cluster_center);

endoM = pixel_labels == max_center;
heartM = pixel_labels ~= min_center;
endoM2 = getMaxCC(endoM);

se = strel('square',3);
endoM2 = imerode(imfill(imdilate(endoM2, se), 'holes'), se);

rp = regionprops(endoM2, 'Centroid');
cX = round(rp.Centroid(1));
cY = round(rp.Centroid(2));

heartM2 = imfill(imdilate(getCCbyPoint(imerode(heartM, se), cX, cY), se), 'holes');
M = heartM2 ~= endoM2;
M(cY, cX) = 255;

imshow(M);

