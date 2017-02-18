function generateResults(root, filename, II, lines, nOfSectors, cX, cY, pType)
    path_res = 'results/maps/';
    path_dcm = 'dicom/';
    nOfQnt = 3;
    
    for i=1:nOfSectors
        for j=1:nOfQnt
            qnl{j, i} = [];
        end
        means{i} = [];
        std_dev{i} = [];
    end
    
    if strcmp(pType,'density/')==1
        DCM = dicomread(strcat(root, path_dcm, filename, '.dcm'));
        metadata = dicominfo(strcat(root, path_dcm, filename, '.dcm'));
        in = metadata.(dicomlookup('0028', '1052'));
        sl = metadata.(dicomlookup('0028', '1053'));
    end
    
    map = II;
    for i=1:size(lines, 1) % for all radial segments
        pv = 255 - mod(i, 2)*100;
        for j=1:size(lines, 2) % for all layers (inner, mid, outer)
            pl = lines{i, j};
            if strcmp(pType,'density/')==1
                pl2 = getPixs(DCM, sl, in, pl);
            else
                pl2 = getPixs(II, 1, 0, pl);
            end
            q = quantile(pl2, nOfQnt);
            means{j} = [means{j}, mean(pl2)];
            std_dev{j} = [std_dev{j}, std(pl2)];
            for k=1:nOfQnt % for each quantile
                qnl{k, j} = [qnl{k, j}, q(k)];
            end
            for k=1:size(pl, 1)
                x = pl(k, 1);
                y = pl(k, 2);
                map(y, x, :) = 0;
                map(y, x, j) = pv;
            end
        end
    end
    
    map(cY, cX, :) = 255;
    
    imwrite(map, strcat(root, path_res, filename,'.png'));
    
    plotStats(root, pType, filename, means, 'means');
    plotStats(root, pType, filename, std_dev, 'std_dev');
    plotStats(root, pType, filename, qnl, 'quantile');
    
    logStats(root, pType, filename, means, '_means');
    logStats(root, pType, filename, std_dev, '_std_dev');
    logStats(root, pType, filename, qnl, '_quantile');
end