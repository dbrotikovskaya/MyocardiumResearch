root = '../data/';
path_i = 'segdata/';
filename = '1';
I = imread(strcat(root, path_i, filename, '.jpg'));

bX1 = 312;
bY1 = 324;
bX2 = 131;
bY2 = 296;

nrows = size(I,1);
ncols = size(I,2);
ncolors = 3;
I_list = reshape(double(I(:, :, 2)),nrows*ncols,1);
c = [5; 80; 180];
[cluster_idx, cluster_center] = kmeans(I_list,ncolors,'MaxIter',5);
pixel_labels = reshape(cluster_idx,nrows,ncols);

[m, max_center] = max(cluster_center);
[m, min_center] = min(cluster_center);

alpha1 = atan2(cX - bX1, cY - bY1)*180/pi + 360;
alpha2 = atan2(cX - bX2, cY - bY2)*180/pi + 360;

endoM = pixel_labels == max_center;
heartM = pixel_labels == 1;
endoM2 = getMaxCC(endoM);
heartM2 = getMaxCC(heartM);

se = strel('square',3);
endoM2 = imerode(imfill(imdilate(endoM2, se), 'holes'), se);

imshow(pixel_labels, []);