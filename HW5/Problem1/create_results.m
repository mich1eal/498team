% clc
% clear all
% close all
% 
% load('results_new.mat');

%graph showing probability with which topic is selected:
figure()
plot(pies);
grid on;
title('Probability with which topic is selected');
xlabel('Topic # (j)');
ylabel('Probability (\pi_j)');

%Produce table
%for every topic
TA = cell(30,10);
for j = 1:30
    %
    [p10s, ii] = sort(P(j,:),'descend');
    top10 = ii(1:10);
    
    for n = 1:10
        TA{j,n} = num2str(a2i{keep_inds(top10(n))});
    end 
end