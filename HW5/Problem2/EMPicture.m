function[] = EMPicture(filename, clusters)
    tic
    dispStr = strcat({'Begining image '}, filename, {' with '},...
        num2str(clusters), {' clusters.'});

    display(char(dispStr(1)));
    
    % Load image
    [raw, ~] = imread(strcat('test_images/', filename,'.jpg'));
    [x, y, z] = size(raw);

    % Put into array of pixels, needs to be non-int in order for calculations
    % to work.
    data = double(reshape(raw, x*y, z));

    T = clusters; %V = number of cluster centers(K)
    %V = number of unique words (K)
    %D = number of documents/data points (I)
    [D, V] = size(data); 

    %init W. value doesn't matter since it's computed in E-step
    W = nan(D,T);

    %init P and pi
    P = (rand(T,V));   %random init, but rows should be normalized

    P(P<0) = 0; %some values are slightly negative ~ -1e-18
    % P = diag(1./sum(P,2))*P;    %normalize
    P = smooth(P);

    pies = (1/T)*ones(1,T); %vector init with all 1/T

    %vector used to compute denominator of E-step
    logAj = zeros(1,T);

    %likelihood for termination
    rel_likelihood = 1;
    tolerance = 1e-3;
    prev_likelihood = inf;
    current_likelihood = 1;

    smooth_P = .01;

    display('Step: Relative Likelihood')
    %%
    count = 0;
    %while change in likelihood is greater than tolerance
    while(abs(rel_likelihood) > tolerance)

        count = count+1;

        %smooth normalize P rowise
        P(P<smooth_P) = smooth_P;


        % replaces "P = diag(1./sum(P,2))*P;", which causes memory overflow

        % P = diag(1./sum(P,2))*P;
        P = smooth(P);

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

        %do M step to get P, pi, and mu from w
        P = (data'*W)';
        pies = sum(W)/D;

        %compute change in likelihood
        rel_likelihood = abs((current_likelihood - prev_likelihood)/current_likelihood);
        prev_likelihood = current_likelihood;

        %display
        display([num2str(count) ': ' num2str(rel_likelihood)]);
    end

    %get result catgories
    [~, rawOut] = max(W, [], 2);

    mu = zeros(T,V); %each row is a cluster, each row a pixel

    % probably could vectorize this
    for i = 1:T
        for j = 1:V
            mu(i,j) = dot(data(:,j), W(:,i))/sum(W(:,i));
        end
    end

    rawOut = mu(rawOut, :);

    out = reshape(uint8(rawOut), [x, y, z]);
    
    title = strcat('out/',filename, '_segmented', num2str(clusters),'.jpg');

    imwrite(out, title,'Quality', 100);
    toc

end
