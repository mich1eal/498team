clc
clear all
close all

V = 12375;  %number of unique words (K)
T = 30;     %number of topics/clusters (J)
D = 1500;   %number of documents/data points (I)

%load data. consists of:
%data: D x V
load('fixed_data.mat');

%init W. value doesn't matter since it's computed in E-step
W = nan(D,T);

%init P and pi
P = (rand(T,V));   %random init, but rows should be normalized
P = diag(1./sum(P,2))*P;

pies = (1/T)*ones(1,T); %vector init with all 1/30

%vector used to compute denominator of E-step
logAj = zeros(1,T);

%likelihood for termination
del_likelihood = 100;
tolerance = .0001;
prev_likelihood = inf;
current_likelihood = 1;
%%
count = 0;
%while change in likelihood is greater than tolerance
while(abs(del_likelihood/current_likelihood) > tolerance)
% for z=1:20
    
    count = count+1;
    display(num2str(current_likelihood));
    
    %Before using P, do smoothing and normalize rows
%     while(min(min(P)) < 0.0005)
%         P(P<0.0005) = 0.005;
%     end
    P = diag(1./sum(P,2))*P;    
    
    current_likelihood = 0;
    %do E step to get W from P and pi
    
    %for each document, compute Aj, Amax and then Y. Exponentiate to get
    %the corresponding row of W:(D x T)
    for i = 1:D
        logAj = log(pies) + data(i,:)*log(P)';
        logAmax = max(logAj);
        
        current_likelihood = current_likelihood + sum(logAj);
        
        log_diff = logAj - logAmax;
        log_third_term = log(sum(exp(log_diff)));
        
        logY = log_diff - log_third_term;
        
        W(i,:) = exp(logY);
    end
    
    %additive smoothing for W
    W(W<0.0001) = 0.0001;
    W = diag(1./sum(W,2))*W;    
    
    %do M step to get P and pi from w
    P = (data'*W)';
    pies = sum(W)/D;
    
    %compute change in likelihood
    del_likelihood = abs(current_likelihood - prev_likelihood);
    prev_likelihood = current_likelihood;
end

create_results;