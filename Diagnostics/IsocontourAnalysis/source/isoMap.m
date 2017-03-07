function isoMap(root, filename, I, M, nOfLevels, llist)
    path = 'results/';
    M = uint8(M);
    figure('Visible', 'off'), imshow(I);
    hold on;
    [c, h] = contour(I(:, :, 2).*M, llist);
    hold on;
    ffn = strcat(root, path, 'levels/', int2str(nOfLevels), '_', filename, '.txt');
    print(strcat(root, path, 'maps/', int2str(nOfLevels), '_', filename), '-dpng');
    csvwrite(ffn, h.LevelList);
    
    sz = size(c, 2);
    i = 1;
    j = 1;
    while i < sz
        n = c(2, i);
        s(j).v = c(1, i);
        s(j).x = uint32(c(1, i+1:i+n));
        s(j).y = uint32(c(2, i+1:i+n));
        i = i + n + 1;
        j = j + 1;
    end
end