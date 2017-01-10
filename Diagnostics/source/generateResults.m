function generateResults(root, filename, II, lines, nOfSectors, cX, cY)
    path = 'results/';
    nOdQnt = 3;
    for i=1:nOfSectors
        for j=1:nOdQnt
            qnl{i, j} = [];
        end
        means{i} = [];
        std_dev{i} = [];
    end

    GI = rgb2gray(II);
    map = II;
    for i=1:size(lines, 1)
        pv = 255 - mod(i, 2)*100;
        for j=1:size(lines, 2)
            pl = lines{i, j};
            pl2 = getPixs(GI, pl);
            q = quantile(pl2, nOdQnt);
            means{j} = [means{j}, mean(pl2)];
            std_dev{j} = [std_dev{j}, std(pl2)];
            for k=1:nOdQnt
                qnl{j, k} = [qnl{j, k}, q(k)];
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
    imshow(map);

end