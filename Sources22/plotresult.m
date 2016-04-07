clc;clear all; close all;
load s3s1.mat
load s3s2.mat
load s3s3.mat
load s3s4.mat
load s3s5.mat
plot(X,Y,'^-',A,B,'*-',C,D,'o-',E,F,'g-',G,H,'b-')
title('The evolution of C_{11}component of the tangent and algorithmic constitutive operators')
xlabel('Time')
ylabel('C_{11} component of the tangent and algorithmic constitutive operators')
legend('\alpha=0','\alpha=0.25','\alpha=0.5','\alpha=0.75','\alpha=1')