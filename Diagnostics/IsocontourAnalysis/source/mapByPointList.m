function [M, fM] = mapByPointList(lines, size)
    fM = zeros(size);
    for j=1:length(lines)
        m = zeros(size);
        plist = lines{j, 2};
        for i=1:length(plist)
            m(plist(i, 2), plist(i, 1)) = 1;
            fM(plist(i, 2), plist(i, 1)) = 1;
        end
        M(:, :, j) = m;
    end
end