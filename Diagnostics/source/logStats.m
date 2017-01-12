function logStats(root, filename, stat, statname)
    path = 'results/';
    for i=1:size(stat, 1)
        ffn = strcat(root, path, filename, statname,int2str(i),'.csv');
        stat_matx = [];
        for j=1:size(stat{i, 1}, 2)
             line = j;
             for z = 1:size(stat, 2)
                line = [line, stat{i, z}(j)];
             end
             stat_matx = [stat_matx; line];
        end
        csvwrite(ffn, stat_matx);
    end