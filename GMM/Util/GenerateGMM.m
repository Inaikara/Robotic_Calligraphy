function [gm] = GenerateGMM(X, NumOfComponent)
    [Pi, Mu, Sigma] = EM_init_kmeans(X', NumOfComponent);
    [Pi, Mu, Sigma] = EM(X', Pi, Mu, Sigma);
    gm=gmdistribution(Mu', Sigma,Pi');
end

