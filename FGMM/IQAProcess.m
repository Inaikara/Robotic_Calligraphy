clc
clear
close all

input="./Result/03.png";
output="./Result/3.bmp";
img=imread(input);
img = imresize(img,[1000,1000]);
img=rgb2gray(img);
imwrite(img,output);