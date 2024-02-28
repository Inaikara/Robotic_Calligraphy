function [gm,C,T,Q] = GenerateGMM(X, NumOfComponent)
    [Pi, Mu, Sigma,C,T,Q] = FEM_init_kmeans(X', NumOfComponent);
    % [Pi, Mu, Sigma] = FEM(X', Pi, Mu, Sigma,C,T,Q);
    gm=gmdistribution(Mu', Sigma,Pi');
end

