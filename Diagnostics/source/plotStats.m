function plotStats(root, pType, filename, stat, statname)
    path = 'results/plots/';
    for i=1:size(stat, 1) % for each statistic in array
        fig = figure
        subplot(3, 1, 1)
        plot(1:size(stat{i, 1}, 2), stat{i, 1}, 'r')
        axis([0 130 0 255])
        grid on
        grid minor
        title('Inner line')

        subplot(3, 1, 2)
        plot(1:size(stat{i, 2}, 2), stat{i, 2}, 'g')
        axis([0 130 0 255])
        grid on
        grid minor
        title('Middle line')

        subplot(3, 1, 3)
        plot(1:size(stat{i, 3}, 2), stat{i, 3}, 'b')
        axis([0 130 0 255])
        grid on
        grid minor
        title('Outer line')

        print(fig,strcat(root, path, pType, statname, int2str(i), '_', filename),'-dpdf');
    end
    
