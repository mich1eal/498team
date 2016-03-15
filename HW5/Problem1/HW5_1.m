clc
clear all
close all

V = 12375;  %number of unique words (K)
T = 30;     %number of topics/clusters (J)
D = 1500;   %number of documents/data points (I)

%load data. consists of:
%data: D x V
%C: output from k-means
load('fixed_data.mat');

%init W. value doesn't matter since it's computed in E-step
W = nan(D,T);

%init P and pi
% P = (rand(T,V));   %random init, but rows should be normalized
P = C;  %centers obtained from k-means (comes from fixed_data.mat)
P(P<0) = 0; %some values are slightly negative ~ -1e-18
P = diag(1./sum(P,2))*P;    %normalize

pies = (1/T)*ones(1,T); %vector init with all 1/30

%vector used to compute denominator of E-step
logAj = zeros(1,T);

%likelihood for termination
rel_likelihood = 1;
tolerance = 1e-6;
prev_likelihood = inf;
current_likelihood = 1;

% smooth_w = 0.0001;
smooth_w = 1/V;
smooth_P = 1/V;

display('Step: Relative Likelihood')
%%
count = 0;
%while change in likelihood is greater than tolerance
while(abs(rel_likelihood) > tolerance)
    
    %smooth normalize P rowise
    P(P<smooth_P) = smooth_P;
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
    W(W<smooth_w) = smooth_w;
    W = diag(1./sum(W,2))*W;    
    
    %do M step to get P and pi from w
    P = (data'*W)';
    pies = sum(W)/D;
    
    %compute change in likelihood
    rel_likelihood = abs((current_likelihood - prev_likelihood)/current_likelihood);
    prev_likelihood = current_likelihood;
    
    %display
    display([num2str(count) ': ' num2str(rel_likelihood)]);
    count = count+1;
    
end

%generate plot and create table called 'TA'
create_results;