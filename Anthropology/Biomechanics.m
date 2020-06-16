%% C:\Users\pablo\OneDrive - Universidad Rey Juan Carlos\Biomedical Engineering URJC\3º curso\Asignaturas y Apuntes\Semester II\corso\[L] LABORATORIO di Bioingegneria\lab (MatLab)\3 - Anthropology
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%       Pablo Laso Mielgo        %
% Biomechanics Signal Processing %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%% clear
clear all, close all, clc;
%% load data
addpath('functions');
addpath('data_com_walking_subj1.mat');
load('data_com_walking_subj1.mat');

markers_data.v03=subj1.run_03.Markers; % take data for subject 1
markers_data.v05=subj1.run_05.Markers;
markers_data.v06=subj1.run_06.Markers;

markers.v03= adapt_marker_data(markers_data.v03);
markers.v05= adapt_marker_data(markers_data.v05);
markers.v06= adapt_marker_data(markers_data.v06);
%% define Variables:
M=92;
b.TA= 0.63; %thorax-abdomen
b.P= 0.27; %pelvis
b.T= 0.433;
b.S= 0.433;
b.F= 0.5; 
% mass: 
m.TA= 0.3550; 
m.P= 0.1420;
m.T= 0.1000;
m.S= 0.0465;
m.F= 0.145;
m.TOT= M;
%% Compute center of mass for subject 1: 

coms.v03.com_RT= calculate_com(markers.v03.RGT,markers.v03.RLE,b.T);
coms.v03.com_RS= calculate_com(markers.v03.RLE,markers.v03.RLM,b.S);
coms.v03.com_RF= calculate_com(markers.v03.RLM,markers.v03.RFM2,b.F);

coms.v03.com_LT= calculate_com(markers.v03.LGT,markers.v03.LLE,b.T);
coms.v03.com_LS= calculate_com(markers.v03.LLE,markers.v03.LLM,b.S);
coms.v03.com_LF= calculate_com(markers.v03.LLM,markers.v03.LFM2,b.F);

for i=1:length(markers.v03.RGT) % hypothesize --> point between L- and R- -GT:
    markers.v03.PEL(i,:)=mean([markers.v03.RGT(i,:);markers.v03.LGT(i,:)]);
    markers.v03.L4(i,:)=mean([markers.v03.C7(i,:)*0.3;markers.v03.PEL(i,:)*0.7]);
end

coms.v03.com_TA=calculate_com(markers.v03.C7,markers.v03.L4,b.TA);
coms.v03.com_P=calculate_com(markers.v03.L4,markers.v03.PEL,b.P);

%% v05

coms.v05.com_RT= calculate_com(markers.v05.RGT,markers.v05.RLE,b.T);
coms.v05.com_RS= calculate_com(markers.v05.RLE,markers.v05.RLM,b.S);
coms.v05.com_RF= calculate_com(markers.v05.RLM,markers.v05.RFM2,b.F);

coms.v05.com_LT= calculate_com(markers.v05.LGT,markers.v05.LLE,b.T);
coms.v05.com_LS= calculate_com(markers.v05.LLE,markers.v05.LLM,b.S);
coms.v05.com_LF= calculate_com(markers.v05.LLM,markers.v05.LFM2,b.F);

for i=1:length(markers.v05.RGT) % hypothesize --> point between L- and R- -GT:
    markers.v05.PEL(i,:)=mean([markers.v05.RGT(i,:);markers.v05.LGT(i,:)]);
    markers.v05.L4(i,:)=mean([markers.v05.C7(i,:)*0.3;markers.v05.PEL(i,:)*0.7]);
end

coms.v05.com_TA=calculate_com(markers.v05.C7,markers.v05.L4,b.TA);
coms.v05.com_P=calculate_com(markers.v05.L4,markers.v05.PEL,b.P);

%% v06

coms.v06.com_RT= calculate_com(markers.v06.RGT,markers.v06.RLE,b.T);
coms.v06.com_RS= calculate_com(markers.v06.RLE,markers.v06.RLM,b.S);
coms.v06.com_RF= calculate_com(markers.v06.RLM,markers.v06.RFM2,b.F);

coms.v06.com_LT= calculate_com(markers.v06.LGT,markers.v06.LLE,b.T);
coms.v06.com_LS= calculate_com(markers.v06.LLE,markers.v06.LLM,b.S);
coms.v06.com_LF= calculate_com(markers.v06.LLM,markers.v06.LFM2,b.F);

for i=1:length(markers.v06.RGT) % hypothesize --> point between L- and R- -GT:
    markers.v06.PEL(i,:)=mean([markers.v06.RGT(i,:);markers.v06.LGT(i,:)]);
    markers.v06.L4(i,:)=mean([markers.v06.C7(i,:)*0.3;markers.v06.PEL(i,:)*0.7]);
end

coms.v06.com_TA=calculate_com(markers.v06.C7,markers.v06.L4,b.TA);
coms.v06.com_P=calculate_com(markers.v06.L4,markers.v06.PEL,b.P);

%% TOTAL Center Of Mass
com_TOT.v03= calculate_total_com(coms.v03,m);
com_TOT.v05= calculate_total_com(coms.v05,m);
com_TOT.v06= calculate_total_com(coms.v06,m);

%% PLOT
% animate_walking(markers.v03,coms.v03,com_TOT.v03)
animate_walking(markers.v05,coms.v05,com_TOT.v05);
% animate_walking(markers.v06,coms.v06,com_TOT.v06)

