clc
clear
close all

figure(Color="white")
t=tiledlayout(2,2,TileSpacing='compact',Padding = 'compact');
nexttile
imshow("0.bmp")
title("Demonstration Image")
nexttile
imshow("1.bmp")
title("GMM")
nexttile
imshow("2.bmp")
title("GMM+PA")
nexttile
imshow("3.bmp")
title("FGMM+PA")