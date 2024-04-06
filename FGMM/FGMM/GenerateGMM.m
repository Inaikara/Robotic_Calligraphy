function [gm,C,T,Q] = GenerateGMM(X, NumOfComponent)
    C=zeros(NumOfComponent,2);
    T=zeros(NumOfComponent,2);
    Q=repmat(eye(2,2),[1,1,NumOfComponent]);
    [Pi, Mu, Sigma] = EM_init_kmeans(X', NumOfComponent);
    [Pi, Mu, Sigma] = EM(X', Pi, Mu, Sigma);
    gm=gmdistribution(Mu', Sigma,Pi');
end

