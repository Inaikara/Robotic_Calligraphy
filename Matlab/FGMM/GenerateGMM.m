function [gm,C,T,Q] = GenerateGMM(X, NumOfComponent)
    %Initialize
    disp("EM算法开始");
    [gm,C,T,Q] = FEM_init_kmeans(X', NumOfComponent);
    [gm,C,T,Q] = FEM(X',gm,C,T,Q);
    disp("EM算法结束");
end

