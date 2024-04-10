function [gm,C,T,Q] = FEM(Data, gm0,C,T,Q)
%
% Expectation-Maximization estimation of GMM parameters.
% This source code is the implementation of the algorithms described in 
% Section 2.6.1, p.47 of the book "Robot Programming by Demonstration: A 
% Probabilistic Approach".
%
% Author:	Sylvain Calinon, 2009
%			http://programming-by-demonstration.org
%
% This function learns the parameters of a Gaussian Mixture Model 
% (GMM) using a recursive Expectation-Maximization (EM) algorithm, starting 
% from an initial estimation of the parameters.
%
%
% Inputs -----------------------------------------------------------------
%   o Data:    D x N array representing N datapoints of D dimensions.
%   o Priors0: 1 x K array representing the initial prior probabilities 
%              of the K GMM components.
%   o Mu0:     D x K array representing the initial centers of the K GMM 
%              components.
%   o Sigma0:  D x D x K array representing the initial covariance matrices 
%              of the K GMM components.
% Outputs ----------------------------------------------------------------
%   o Priors:  1 x K array representing the prior probabilities of the K GMM 
%              components.
%   o Mu:      D x K array representing the centers of the K GMM components.
%   o Sigma:   D x D x K array representing the covariance matrices of the 
%              K GMM components.
%
% This source code is given for free! However, I would be grateful if you refer 
% to the book (or corresponding article) in any academic publication that uses 
% this code or part of it. Here are the corresponding BibTex references: 
%
% @book{Calinon09book,
%   author="S. Calinon",
%   title="Robot Programming by Demonstration: A Probabilistic Approach",
%   publisher="EPFL/CRC Press",
%   year="2009",
%   note="EPFL Press ISBN 978-2-940222-31-5, CRC Press ISBN 978-1-4398-0867-2"
% }
%
% @article{Calinon07,
%   title="On Learning, Representing and Generalizing a Task in a Humanoid Robot",
%   author="S. Calinon and F. Guenter and A. Billard",
%   journal="IEEE Transactions on Systems, Man and Cybernetics, Part B",
%   year="2007",
%   volume="37",
%   number="2",
%   pages="286--298",
% }

%% Criterion to stop the EM iterative update
threshold_loglik = 1e-10;
threshold_curve = 1e-3;
threshold_prob=0.5;

%% Initialization of the parameters
[nbVar, nbData] = size(Data);
nbStates = size(gm0.Sigma,3);
loglik_old = -realmax;
nbStep = 0; %画图计数


Mu = gm0.mu';
Sigma = gm0.Sigma;
Priors = gm0.ComponentProportion;% alpha
Pxi=zeros([nbData,nbStates]);% p(x|theta)

%% EM fast matrix computation (see the commented code for a version 
%% involving one-by-one computation, which is easier to understand)
while 1
  %% E-step %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  for i=1:nbStates
    %Compute probability p(x|i)
    if abs(C(i,1))>=threshold_curve
        Pxi(:,i) = AcaGaussPDF(Data, Mu, Sigma,C,T,Q,i);
    else
        Pxi(:,i) = GaussPDF(Data, Mu(:,i), Sigma(:,:,i));
    end
  end
  %Compute posterior probability p(i|x)
  Pix_tmp = repmat(Priors,[nbData 1]).*Pxi;
  Pix = Pix_tmp ./ repmat(sum(Pix_tmp,2),[1 nbStates]);%w_it
  %Compute cumulated posterior probability
  E = sum(Pix);

  %% M-step %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  for i=1:nbStates
    
    %% Update the priors
    Priors(i) = E(i) / nbData;
    if abs(C(i,1))>=threshold_curve
        %% Updata the CQT
        idtmp=Pix(:,i)>=threshold_prob;
        [C(i,:),T(i,:),Q(:,:,i)] = PCA2LSFM(Data(:,idtmp)');
        NewData = Data2NewData(Data,C(i,:),T(i,:),Q(:,:,i));
        %% Update the centers
        Mu(:,i) = NewData*Pix(:,i) / E(i)+Q(:,:,i)'*[0,C(i,2)]'+T(i,:)';
        % Mu(:,i) = Data*Pix(:,i) / E(i);
        %% Update the covariance matrices
        Sigma(1,1,i)=abs(NewData(1,:).*NewData(1,:))*Pix(:,i) / E(i);
        Sigma(2,2,i)=abs(NewData(2,:).*NewData(2,:))*Pix(:,i) / E(i);
        % Sigma(1,1,i)=abs(NewData(1,:).*NewData(1,:))*Pxi(:,i) / nbData;
        % Sigma(2,2,i)=abs(NewData(2,:).*NewData(2,:))*Pxi(:,i) / nbData;
        Sigma(1,2,i)=0;
        Sigma(2,1,i)=0;
        % %% Add a tiny variance to avoid numerical instability
        % Sigma(:,:,i) = Sigma(:,:,i) + 1E-5.*diag(ones(nbVar,1));
    else
        %Update the centers
        Mu(:,i) = Data*Pix(:,i) / E(i);
        %Update the covariance matrices
        Data_tmp1 = Data - repmat(Mu(:,i),1,nbData);
        Sigma(:,:,i) = (repmat(Pix(:,i)',nbVar, 1) .* Data_tmp1*Data_tmp1') / E(i);
        % %% Add a tiny variance to avoid numerical instability
        % Sigma(:,:,i) = Sigma(:,:,i) + 1E-5.*diag(ones(nbVar,1));
    end
  end

    % %% Figure %%%%%%%%%%%%%%%%%%%%
    % nbStep = nbStep+1;
    % if nbStep>=20
    %     nbStep=0;
    %     gm=gmdistribution(Mu', Sigma,Priors');
    %     FEMPlot(Data,gm,C,T,Q);
    % end
  %% Stopping criterion %%%%%%%%%%%%%%%%%%%%
  for i=1:nbStates
    %Compute the new probability p(x|i)
    if abs(C(i,1))>=threshold_curve
        Pxi(:,i) = AcaGaussPDF(Data, Mu, Sigma,C,T,Q,i);
    else
        Pxi(:,i) = GaussPDF(Data, Mu(:,i), Sigma(:,:,i));
    end
  end

  %Compute the log likelihood
  F = Pxi*Priors';
  F(F<realmin) = realmin;
  loglik = mean(log(F));
  %% Stop the process depending on the increase of the log likelihood 
  if abs((loglik/loglik_old)-1) < threshold_loglik
    break;
  end
  loglik_old = loglik;

  %% 打印似然度  
  disp(loglik)
end

% %% EM slow one-by-one computation (better suited to understand the
% %% algorithm) 
% while 1
%   %% E-step %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   for i=1:nbStates
%     %Compute probability p(x|i)
%     Pxi(:,i) = gaussPDF(Data, Mu(:,i), Sigma(:,:,i));
%   end
%   %Compute posterior probability p(i|x)
%   for j=1:nbData
%     Pix(j,:) = (Priors.*Pxi(j,:))./(sum(Priors.*Pxi(j,:))+realmin);
%   end
%   %Compute cumulated posterior probability
%   E = sum(Pix);
%   %% M-step %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   for i=1:nbStates
%     %Update the priors
%     Priors(i) = E(i) / nbData;
%     %Update the centers
%     Mu(:,i) = Data*Pix(:,i) / E(i);
%     %Update the covariance matrices 
%     covtmp = zeros(nbVar,nbVar);
%     for j=1:nbData
%       covtmp = covtmp + (Data(:,j)-Mu(:,i))*(Data(:,j)-Mu(:,i))'.*Pix(j,i);
%     end
%     Sigma(:,:,i) = covtmp / E(i);
%   end
%   %% Stopping criterion %%%%%%%%%%%%%%%%%%%%
%   for i=1:nbStates
%     %Compute the new probability p(x|i)
%     Pxi(:,i) = gaussPDF(Data, Mu(:,i), Sigma(:,:,i));
%   end
%   %Compute the log likelihood
%   F = Pxi*Priors';
%   F(find(F<realmin)) = realmin;
%   loglik = mean(log(F));
%   %Stop the process depending on the increase of the log likelihood 
%   if abs((loglik/loglik_old)-1) < loglik_threshold
%     break;
%   end
%   loglik_old = loglik;
%   nbStep = nbStep+1;
% end

%% Add a tiny variance to avoid numerical instability
for i=1:nbStates
    if abs(C(i,1))>=threshold_curve    
      Sigma(:,:,i)=Q(:,:,i)'*Sigma(:,:,i)*Q(:,:,i);      
    else
    %Updata the CQT
    idtmp=Pix(:,i)>=threshold_prob;
    [C(i,:),T(i,:),Q(:,:,i)] = PCA2LSFM(Data(:,idtmp)');
    % Sigma(:,:,i)=Q(:,:,i)'*Sigma(:,:,i)*Q(:,:,i);
    end
end
Sigma(:,:,i) = Sigma(:,:,i) + 1E-5.*diag(ones(nbVar,1));
gm=gmdistribution(Mu', Sigma,Priors');
