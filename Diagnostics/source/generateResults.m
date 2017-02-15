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
    
    if pType == 1
        DCM = dicomread(strcat(root, path_dcm, filename, '.dcm'));
        metadata = dicominfo(strcat(root, path_dcm, filename, '.dcm'));
        in = metadata.(dicomlookup('0028', '1052'));
        sl = metadata.(dicomlookup('0028', '1053'));
    end
    
    map = II;
    for i=1:size(lines, 1)
        pv = 255 - mod(i, 2)*100;
        for j=1:size(lines, 2)
            pl = lines{i, j};
            if pType == 1
                pl2 = getPixs(DCM, sl, in, pl);
            else
                pl2 = getPixs(II, 1, 1, pl);
            end
            q = quantile(pl2, nOfQnt);
            means{j} = [means{j}, mean(pl2)];
            std_dev{j} = [std_dev{j}, std(pl2)];
            for k=1:nOfQnt
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
    
    plotStats(root, filename, means, '_means');
    plotStats(root, filename, std_dev, '_std_dev');
    plotStats(root, filename, qnl, '_quantile');
    
    logStats(root, filename, means, '_means');
    logStats(root, filename, std_dev, '_std_dev');
    logStats(root, filename, qnl, '_quantile');
end