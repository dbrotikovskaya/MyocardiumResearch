function analyzeImage(root, filename, gradFlag, isomapFlag)
    % This is main file of algorithm

    path_i = 'pictures/';
    path_s = 'masks/';

    I = imread(strcat(root, path_s, filename, '.png'));
    II = imread(strcat(root, path_i, filename, '.jpg'));
    M = I(:, :, 1)>I(:, :, 2);
    
    M = imfill(M, 'holes');
    rp = regionprops(M,'BoundingBox');
    M = imcrop(M, rp.BoundingBox);
    II = imcrop(II, rp.BoundingBox);
    
    rp = regionprops(M, 'Centroid', 'PixelList');
    
    cX = round(rp.Centroid(1));
    cY = round(rp.Centroid(2));

    sizeL = size(rp.PixelList, 1);
    areas_unsorted = {};
    dist_unsorted = {};
    for i=1:sizeL
        p = rp.PixelList(i, :);
        alpha = round((atan2(cX-p(1), cY-p(2))*180/pi + 180) / 2) + 1;
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
    angleSize = uint8(size(areas, 2)/6);
    for i=1:7
        for j=1:m+1
            lines{i, j} = [];
        end
    end
    for n=1:size(areas, 2)
        n2 = uint8(n/angleSize)+1;
        pl = areas{n};
        dl = dist{n};
        ql = quantile(dl, m);
        if size(ql)>0
            ql(1) = (ql(1)+min(dl))/2;
            ql(2) = (max(dl)+ql(2))/2;
        end
        for i=1:size(pl, 1)
            if dl(i)<ql(1)
                if size(lines{n2, 1}, 2) == 0
                    lines{n2, 1} = pl(i, :);
                else
                    lines{n2, 1} = [lines{n2, 1}; pl(i, :)];
                end
            end
            for j=2:size(ql, 2)
                if ql(j-1)<=dl(i) && dl(i)<ql(j)
                    if size(lines{n2, j}, 2) == 0
                        lines{n2, j} = pl(i, :);
                    else
                        lines{n2, j} = [lines{n2, j}; pl(i, :)];
                    end
                    break;    
                end
            end
            if dl(i)>=ql(m)
                if size(lines{n2, m+1}, 2) == 0
                    lines{n2, m+1} = pl(i, :);
                else
                    lines{n2, m+1} = [lines{n2, m+1}; pl(i, :)];
                end
            end
        end
    end
    
    
    [M, fM] = mapByPointList(lines, size(M));    
    
    imwrite(II, strcat(root, 'results/cropped/', filename, '.png'));
    
    if gradFlag==1
        imwrite(gradient(double(II(:, :, 1).*uint8(fM(:, :, 1)))), strcat(root, 'results/gradient/', filename, '.png'));
    end
    
    if isomapFlag==1
        levels{1} = [30, 35, 40];
        levels{2} = [50, 55, 60];
        levels{3} = [65, 70, 75];
        levels{4} = [80, 85, 90];
        for k=1:length(levels)
            isoMap(root, filename, II, fM, k, levels{k});
        end
    end

end