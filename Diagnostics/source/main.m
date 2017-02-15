% This is main file of algorithm

root = '../data/';
path_i = 'initial/';
path_s = 'segmented/';
filename = 'all2';

I = imread(strcat(root, path_s, filename, '.png'));
II = imread(strcat(root, path_i, filename, '.jpg'));
M = I(:, :, 1)>I(:, :, 2);

M = imfill(M, 'holes');
rp = regionprops(M, 'Centroid', 'MajorAxisLength', 'MinorAxisLength', 'Orientation', 'PixelList');

cX = round(rp.Centroid(1));
cY = round(rp.Centroid(2));

sizeL = size(rp.PixelList, 1);
areas_unsorted = {};
dist_unsorted = {};
for i=1:sizeL
    p = rp.PixelList(i, :);
    alpha = round((atan2(cX-p(1), cY-p(2))*180/pi + 180) / 3) + 1;
    if size(areas_unsorted, 2) < alpha
        areas_unsorted{alpha} = [p];
        dist_unsorted{alpha} = [sqrt((p(2)-cY)^2 + (p(1)-cX)^2)];
    else
        areas_unsorted{alpha} = [areas_unsorted{alpha}; p];
        dist_unsorted{alpha} = [dist_unsorted{alpha}, sqrt((p(2)-cY)^2 + (p(1)-cX)^2)];
    end
end

flag = 0;
for i=1:size(areas_unsorted, 2)
    if size(areas_unsorted{i}, 1)<3
        if flag == 0
            flag = 1;
            st = i;
        else
            fin = i;
        end
    end
end

j = 1;
areas = {};
dist = {};
for i = cat(2, (st-1):-1:1, size(areas_unsorted, 2):-1:(fin+1))
    areas{j} = areas_unsorted{i};
    dist{j} = dist_unsorted{i};
    j = j+1;
end

m = 2;
lines = {};
for n=1:size(areas, 2)
    pl = areas{n};
    dl = dist{n};
    ql = quantile(dl, m);
    for i=1:(m+1)
        lines{n, i} = [];
    end
    for i=1:size(pl, 1)
        if dl(i)<ql(1)
            if size(lines{n, 1}, 2) == 0
                lines{n, 1} = [pl(i, :)];
            else
                lines{n, 1} = [lines{n, 1}; pl(i, :)];
            end
        end
        for j=2:size(ql, 2)
            if ql(j-1)<=dl(i) && dl(i)<ql(j)
                if size(lines{n, j}, 2) == 0
                    lines{n, j} = [pl(i, :)];
                else
                    lines{n, j} = [lines{n, j}; pl(i, :)];
                end
                break;    
            end
        end
        if dl(i)>=ql(m)
            if size(lines{n, m+1}, 2) == 0
                lines{n, m+1} = [pl(i, :)];
            else
                lines{n, m+1} = [lines{n, m+1}; pl(i, :)];
            end
        end
    end
end

generateResults(root, filename, II, lines, m+1, cX, cY, 0);