function [Pxi] = gmmPROB(r,Mu, Sigma,Pi)
%
% Inputs -----------------------------------------------------------------
%   o r:  D x N array representing N datapoints of D dimensions.
%   o Mu:    D x K array representing the centers of the K GMM components.
%   o Sigma: D x D x K array representing the covariance matrices of the 
%            K GMM components.
%   o Pi: 1 x K array representing the initial prior probabilities 
%              of the K GMM components.

Pxi=zeros(1,length(r));% 1*N
for i=1:length(Pi)
    Pxi(1,:) = Pxi(1,:)+Pi(i)*gaussPDF(r, Mu(:,i), Sigma(:,:,i))';
end

end



