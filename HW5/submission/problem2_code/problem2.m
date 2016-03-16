close all; clear all; clc;

titles = {'balloons', 'mountains', 'nature', 'ocean', 'polarlights'};

for i = 1:length(titles)
    for j = [10, 20, 50]
        EMPicture(char(titles(i)), j)
    end    
end

for i = 1:5
    EMPicture('polarlights', 20, strcat('polarlights',num2str(i)));
end
