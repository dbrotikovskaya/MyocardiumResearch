root = '../data/patient_sets/22_02/';

dirlist = dir(root);
for i = 1:length(dirlist)
    if strcmp(dirlist(i).name(1), '.') == 0
        localroot = strcat(root, dirlist(i).name, '/');
        locallist = dir(strcat(localroot, 'pictures/'));
        for j = 1:length(locallist)
            if strcmp(locallist(j).name(1), '.') == 0
                analyzeImage(localroot, locallist(j).name(1:length(locallist(j).name)-4));
            end
        end
    end
end