function prob = AcaGaussPDF(Data, ~, Sigma,C,T,Q,i)
%
% This function computes the Probability Density Function (PDF) of a
% multivariate Gaussian represented by means and covariance matrix.
%
% Author:	Sylvain Calinon, 2009
%			http://programming-by-demonstration.org
%
% Inputs -----------------------------------------------------------------
%   o Data:  D x N array representing N datapoints of D dimensions.
%   o Mu:    D x K array representing the centers of the K GMM components.
%   o Sigma: D x D x K array representing the covariance matrices of the 
%            K GMM components.
% Outputs ----------------------------------------------------------------
%   o prob:  1 x N array representing the probabilities for the 
%            N datapoints.     

% 对点进行映射
NewData = Data2NewData(Data,C(i,:),T(i,:),Q(:,:,i));

% 方差
Sigma1=Sigma(1,1,i);
Sigma2=Sigma(2,2,i);

prob1=exp(-0.5*NewData(1,:).*NewData(1,:)/Sigma1) / sqrt((2*pi) * (abs(Sigma1)+realmin));
prob2=exp(-0.5*NewData(2,:).*NewData(2,:)/Sigma2) / sqrt((2*pi) * (abs(Sigma2)+realmin));

prob=(prob1.*prob2)';




