function [gm,C,T,Q] = GenerateFGMM(X, NumOfComponent)
    %Initialize
    [gm,C,T,Q] = FEM_init_kmeans(X', NumOfComponent);
    [gm,C,T,Q] = FEM(X',gm,C,T,Q);
end

