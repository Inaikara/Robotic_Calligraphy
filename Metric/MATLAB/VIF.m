%% START
clc
clear
close all
addpath(genpath('.\VIFVEC')); 
addpath(genpath('.\PyrTools'));

input=imread("./Result/0.bmp");
output1=imread("./Result/1.bmp");
output2=imread("./Result/2.bmp");
output3=imread("./Result/3.bmp");

vif1 = vifvec(input, output1);
vif2 = vifvec(input, output2);
vif3 = vifvec(input, output3);

disp(vif1)
disp(vif2)
disp(vif3)

rmpath(genpath('.\VIFVEC')); 
rmpath(genpath('.\PyrTools'));
