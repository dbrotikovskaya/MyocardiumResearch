function logStats(root, pType, filename, stat, statname)
    path = strcat('results/logs/', pType);
    for i=1:size(stat, 1) % for each statistic in array
        ffn = strcat(root, path, filename, statname,int2str(i),'.txt');
        stat_matx = [];
        for j=1:size(stat{i, 1}, 2) % for each radial segment
             line = j;
             for z = 1:size(stat, 2) % for each layer (inner, mid, outer)
                line = [line, stat{i, z}(j)];
             end
             stat_matx = [stat_matx; line];
        end
        csvwrite(ffn, stat_matx);
    end