function [out] = smooth(W)
%Doesn't use the diag function which overflows memory

[n, ~] = size(W);

for i = 1:n
    W(i,:) = (1./sum(W(i,:),2)) * W(i,:);
end
out = W;
return 

