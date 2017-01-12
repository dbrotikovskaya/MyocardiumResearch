function plotStats(root, filename, stat, statname)
    path = 'results/';
    for i=1:size(stat, 1)
        fig = figure
        subplot(3, 1, 1)
        plot(1:size(stat{i, 1}, 2), stat{i, 1}, 'r')
        grid on
        grid minor
        title('Inner line')

        subplot(3, 1, 2)
        plot(1:size(stat{i, 2}, 2), stat{i, 2}, 'g')
        grid on
        grid minor
        title('Middle line')

        subplot(3, 1, 3)
        plot(1:size(stat{i, 3}, 2), stat{i, 3}, 'b')
        grid on
        grid minor
        title('Outer line')

        print(fig,strcat(root, path, filename, statname,int2str(i)),'-dpdf');
    end
    
