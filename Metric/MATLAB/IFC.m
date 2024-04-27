%% START
clc
clear
close all
addpath(genpath('.\IFCVEC')); 
addpath(genpath('.\PyrTools')); 

input=imread("./Result/0.bmp");
output1=imread("./Result/1.bmp");
output2=imread("./Result/2.bmp");
output3=imread("./Result/3.bmp");

ifc1 = ifcvec(input, output1);
ifc2 = ifcvec(input, output2);
ifc3 = ifcvec(input, output3);

disp(ifc1)
disp(ifc2)
disp(ifc3)

rmpath(genpath('.\IFCVEC')); 
rmpath(genpath('.\PyrTools')); 

