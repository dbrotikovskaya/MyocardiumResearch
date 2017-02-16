function isoMap(root, filename, I, M, nOfLevels)
    path = 'results/isocontours/maps/';
    M = uint8(M);
    figure, imshow(I);
    hold on;
    c = contour(I(:, :, 1).*M, nOfLevels);
    hold on;
    print(strcat(root, path, filename, '_', int2str(nOfLevels)), '-dpng');
    
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