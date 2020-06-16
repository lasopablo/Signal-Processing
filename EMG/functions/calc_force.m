function [F1, F2] = calc_force(EMG_biceps,EMG_triceps,H_sbj,tau_c,theta) 
% elaborazione_emg.m complementary

a=0.03; %biceps insertion point
d=0.186*H_sbj; %biceps&triceps insertion distance from elbow
b=0.015; %triceps insertion distance from elbow

J= [a*d*sin(theta)/sqrt(a^2+d^2-2*a*d*cos(theta));
    -b*d*sin(theta)/sqrt(b^2+d^2+2*b*d*cos(theta))];

alpha= EMG_biceps/EMG_triceps;

% section 3.2 in paper
F2= tau_c/J(1)*alpha+J(2);
F1= alpha*F2;

