root = '../data/norm/';

dirlist = dir(strcat(root, 'pictures/'));
for j = 1:length(dirlist)
    if strcmp(dirlist(j).name(1), '.') == 0
        analyzeImage(root, dirlist(j).name(1:length(dirlist(j).name)-4), 0, 0);
        dirlist(j).name(1:length(dirlist(j).name)-4)
    end
end