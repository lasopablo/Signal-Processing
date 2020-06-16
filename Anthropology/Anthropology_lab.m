%% C:\Users\pablo\OneDrive - Universidad Rey Juan Carlos\Biomedical Engineering URJC\3º curso\Asignaturas y Apuntes\Semester II\corso\[L] LABORATORIO di Bioingegneria\lab (MatLab)\3 - Anthropology
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%       Pablo Laso Mielgo        %
% Antropometry Signal Processing %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%% clear
clear all, close all, clc;
%% load data
% [subj_file subj_path]= uigetfile('*.csv'); % pop-up window
subj_path= 'C:\Users\pablo\OneDrive - Universidad Rey Juan Carlos\Biomedical Engineering URJC\3º curso\Asignaturas y Apuntes\Semester II\corso\[L] LABORATORIO di Bioingegneria\lab (MatLab)\3 - Anthropology\data_anthropometry\data_anthropometry' % trick
subj_file= 'data_subj.csv' % trick
% data_subj= readtable([subj_path subj_file]);
data_subj= readtable([subj_path filesep subj_file]); % trick
data_subj.Properties

H= data_subj{:,2}; % weird brackets to get vector, not table
M= data_subj{:,3};
l_1= data_subj{:,4}; 
l_2= data_subj{:,5};
l_g= data_subj{:,6};

% s_path= uigetdir;
s_path= 'C:\Users\pablo\OneDrive - Universidad Rey Juan Carlos\Biomedical Engineering URJC\3º curso\Asignaturas y Apuntes\Semester II\corso\[L] LABORATORIO di Bioingegneria\lab (MatLab)\3 - Anthropology\data_anthropometry\data_anthropometry\s'; %trick
s_files= dir([s_path filesep '*.csv']);
files_n= length(s_files);
for i=1:files_n
    s_table= readtable([s_path filesep s_files(i).name]);
    s(:,i)=s_table{:,2};
end
clear s_table

s1_path= 'C:\Users\pablo\OneDrive - Universidad Rey Juan Carlos\Biomedical Engineering URJC\3º curso\Asignaturas y Apuntes\Semester II\corso\[L] LABORATORIO di Bioingegneria\lab (MatLab)\3 - Anthropology\data_anthropometry\data_anthropometry\s1'; %trick
s1_files= dir([s1_path filesep '*.csv']);
files1_n= length(s1_files);
for i=1:files1_n
    s1_table= readtable([s1_path filesep s1_files(i).name]);
    s1(:,i)=s1_table{:,2};
end
clear s1_table

a_path= 'C:\Users\pablo\OneDrive - Universidad Rey Juan Carlos\Biomedical Engineering URJC\3º curso\Asignaturas y Apuntes\Semester II\corso\[L] LABORATORIO di Bioingegneria\lab (MatLab)\3 - Anthropology\data_anthropometry\data_anthropometry\a'; %trick
a_files= dir([a_path filesep '*.csv']);
filea_n= length(a_files);
for i=1:filea_n
    a_table= readtable([a_path filesep a_files(i).name]);
    a(:,i)=a_table{:,2};
end
clear a_table

%% math

% calculate M:
alpha_M= 0.061;
M_g= M*alpha_M;

% calculate b:
g=9.81;
l=2; 

s_mean= mean(s)';
s1_mean= mean(s1)';

W= M_g*g;
b= ((s_mean-s1_mean)*l./W);

figure
plot(s_mean,'-o');
xlabel('subject');
ylabel('s [N]');
title('patient data')
set(gca,'FontSize',24)

figure
bar(M) % mass from all subjects
xlabel('subject');
ylabel('Mass [Kg]');
title('patient data')
set(gca,'FontSize',24)


% I_p:
m=8;
a_mean= mean(a)';
l_p= m.*l_2.*(g./a_mean.*l_1-l_2);

% rho_p:
rho_p= sqrt(l_p./M_g);

fitfun= fittype(@(A,x) A*x); %cftool
rho_p_fit_c= fit(l_g,rho_p,fitfun);
rho_p_fit= rho_p_fit_c(1);

figure
plot(l_g,rho_p,'o')
hold on
plot(sort(l_g),sort(l_g)*rho_p_fit,'linewidth',2);
xlabel('l_g [m]','FontSize',24)
ylabel('\rho_p','FontSize',24)
title('\rho_p fit')
set(gca,'FontSize',24)

% rho_b:
l_b= l_p-M_g.*b.^2;
rho_b= sqrt(l_b./M_g);
rho_b_fit_c= fit(l_g,rho_b,fitfun);
rho_b_fit= rho_b_fit_c(1);

figure
plot(l_g,rho_b,'o')
hold on
plot(sort(l_g),sort(l_g)*rho_b_fit,'LineWidth',2)
xlabel('l_g [m]','FontSize',24)
ylabel('\rho_b','FontSize',24)
title('\rho_b fit')
set(gca,'FontSize',24)

% rho_d:
l_d= l_b+M_g.*(l_g-b).^2;
rho_d= sqrt(l_d./M_g);
rho_d_fit_c= fit(l_g,rho_d,fitfun);
rho_d_fit= rho_d_fit_c(1);

figure
plot(l_g,rho_d,'o')
hold on
plot(sort(l_g),sort(l_g)*rho_d_fit,'LineWidth',2)
xlabel('l_g [m]','FontSize',24)
ylabel('\rho_d','FontSize',24)
title('\rho_d fit')
set(gca,'FontSize',24)

