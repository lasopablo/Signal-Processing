%% C:\Users\pablo\OneDrive - Universidad Rey Juan Carlos\Biomedical Engineering URJC\3º curso\Asignaturas y Apuntes\Semester II\corso\[L] LABORATORIO di Bioingegneria\lab (MatLab)\2 - Physio
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%       Pablo Laso Mielgo        %
%  Physiology Signal Processing  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% CLEAR EVERYTHING
clear all
close all
clc
%%
% load('dati_P3_T0')
Patient= 3;
Session= 1;

save_flag=1
% global params
fs= 30; %30Hz --> acquisition freq rate
tc= 1/fs; % sampling rate

fontSize=14; %comfy

dati=load(strcat('dati_P',num2str(Patient),'_T',num2str(Session),'.mat'));
data=dati.dati;
clear dati

%% variables
gsr= data(:,1)*1e3; % --> MicroSiemens
heart_rate= data(:,2);
heart_rate_variability= data(:,3);
respiration_rate= data(:,4);
robot= data(:,5);

time= 0:tc:length(data)/fs;
time(end)= []; % make dimensions match each other
%% Figures
set(0,'DefaultFigureWindowStyle','docked')
[robot_baseline]= find(robot==1);

figure(1)
subplot(5,1,1)
plot(time, gsr, 'LineWidth',2,'Color',[.8 .3 .6]) % change vctor to change colors
hold on
xline(time(robot_baseline(1)),'LineWidth',5)
title('GSR')
xlim([0 time(end)])
ylabel('GSR [\muS]')
set(gca, 'FontSize',    fontSize) % dimension as defined in fontSize variable

subplot(5,1,2)
plot(time, heart_rate, 'LineWidth',2,'Color',[.8 .4 .4]) % change vctor to change colors
hold on
xline(time(robot_baseline(1)),'LineWidth',5)
title('Heart rate')
xlim([0 time(end)])
ylabel('HR [bpm]')
set(gca, 'FontSize', fontSize) % dimension as defined in fontSize variable

subplot(5,1,3)
plot(time, heart_rate_variability, 'LineWidth',2,'Color',[.8 .8 .4]) % change vctor to change colors
hold on
xline(time(robot_baseline(1)),'LineWidth',5)
title('Heart rate variability')
xlim([0 time(end)])
ylabel('HRV [ms]')
set(gca, 'FontSize', fontSize) % dimension as defined in fontSize variable

subplot(5,1,4)
plot(time, respiration_rate, 'LineWidth',2,'Color',[.5 .4 .4]) % change vctor to change colors
hold on
xline(time(robot_baseline(1)),'LineWidth',5)
title('Respiration rate')
xlim([0 time(end)])
xlabel('Time [s]')
ylabel('Motion [fsm]')
set(gca, 'FontSize', fontSize) % dimension as defined in fontSize variable

subplot(5,1,5)
plot(time, robot, 'LineWidth',2,'Color',[.3 .8 .8]) % change vctor to change colors
title('Robot motion')
xlim([0 time(end)])
xlabel('Time [s]')
ylabel('Motion [fsm]')
set(gca, 'FontSize', fontSize) % dimension as defined in fontSize variable
%% Extract GSR features
% Compute SCL and SCR

% butter filters but dephases + filtfilt rephase it back right
[b, a] = butter(4, 5/(fs/2),'low'); % butterworth order, sampling frequency;
gsr_filt= filtfilt(b, a, gsr); % gsr as input, filtered gsr as output;

% SCL (rest)
[b, a] = butter(4, 0.1/(fs/2),'low'); 
scl = filtfilt(b, a, gsr_filt); 

% SCR (effective variation from GSR)
[b, a] = butter(4, 0.1/(fs/2),'high'); 
scr = filtfilt(b, a, gsr_filt); 

% MODIFICATION!! LITLE PARENTHESIS HERE %%%
parameter.original= [heart_rate,heart_rate_variability,respiration_rate,scl,scr]
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure(2) % just graphing 
findpeaks(scr,'MinPeakHeight', 3e-2, 'MinPeakDistance' ,25); % min thereholds 
% consider each 25 samples (sampling frequency)

peaks_scr= findpeaks(scr, 'MinPeakHeight',3e-2,'MinPeakDistance',25);
number_peaks_scr= length(peaks_scr); % number of peaks along your signal
title('SCR peaks')

peaks_scl= findpeaks(scr, 'MinPeakHeight',3e-2,'MinPeakDistance',25);
number_peaks_scl= length(peaks_scl); % number of peaks along your signal


figure(3)
subplot(2,1,1)
plot(time,scl, 'LineWidth',2,'Color',[.8 .3 .6])
title('GSR components')
xlabel('Time [s]')
ylabel('SCL [\muS]')
set(gca, 'FontSize', fontSize) 
subplot(2,1,2)
plot(time,scr, 'LineWidth',2,'Color',[.8 .3 .6])
xlabel('Time [s]')
ylabel('SCR [\muS]')
set(gca, 'FontSize', fontSize)
%take baseline allows you to know what may happen to patient before and 
%normalizing allows you to compare between different situations or patients


%% Computing physiological response

[robot_baseline]= find(robot==1); % time values where robot==1
robot_baseline(1) % starting point

% computing baseline
scl_baseline= mean(scl(1:robot_baseline(1)-1)); % from sample one, till robot starts 
scr_baseline= mean(scr(1:robot_baseline(1)-1));
heart_rate_baseline=mean(heart_rate(1:robot_baseline(1)-1));
heart_rate_variability_baseline=mean(heart_rate_variability(1:robot_baseline(1)-1));
respiration_rate_baseline=mean(respiration_rate(1:robot_baseline(1)-1));

% normalize wrt basline:
%each_sample=(each_sample-bsl/bsl)

HR_robot= heart_rate(robot==1);
HR_response= (HR_robot-heart_rate_baseline)/heart_rate_baseline;

HRV_robot= heart_rate_variability(robot==1);
HRV_response= (HRV_robot-heart_rate_variability_baseline)/heart_rate_variability_baseline;

RR_robot= respiration_rate(robot==1);
RR_response= (RR_robot-respiration_rate_baseline)/respiration_rate_baseline;

scl_robot= scl(robot==1);
SCL_response= (scl_robot-scl_baseline)/scl_baseline;

scr_robot= scr(robot==1);
SCR_response= (scr_robot-scr_baseline)/scr_baseline;



% struct parameter --> different physio params
parameter.name= {'hr' 'hrv' 'rr' 'grc_scr' 'grs_scl'};
parameter.baseline= [heart_rate_baseline, heart_rate_variability_baseline,...
    respiration_rate_baseline, scr_baseline, scl_baseline];

parameter.response= [HR_response,HRV_response,RR_response,SCR_response,SCL_response];

parameter.title= {'HR_resp' 'HRV_resp' 'RR_resp' 'SCR_resp' 'SCL_resp' 'SCR_peaks'};


parameter_time= 0:tc:length(time(robot==1))/fs;
parameter_time(end)= [];

% time during (robot==1)
test_seconds= length(time(robot==1))/fs;
test_minutes= fix(test_seconds/60); % fix --> integers

samples_minute= 60*fs; % sample per minute

for i=1:size(parameter.response,2) 
    figure()
    for j=1:test_minutes % iterate per minute --> find mean for each variable
        subplot(5,2,j)
        parameter.response_mean(j,i)=mean(parameter.response(1+(j-1)*(samples_minute):(j*samples_minute),i));
        % parameters from 1 to length of test
        laso_fft((parameter.response(1+(j-1)*(samples_minute):(j*samples_minute),i)),1000)
        title(parameter.name(i))
    end
    parameter.response_diff(:,i)= diff(parameter.response_mean(:,i)); %differente between instant i and mean
end

% plotting normalized values
figure % subplot implementation
for i=1:size(parameter.response,2)
%     figure(i+3)
    subplot(2,3,i)
    hold on
    plot(parameter_time, parameter.response(:,i),'LineWidth',3,'Color',[.8 .3 .6])
    title(parameter.title(i),'interpreter','none','LineWidth',3)
    xlabel('Time [s]')
    ylabel(parameter.title(i),'interpreter','none')
    set(gca,'FontSize',14)

    for j=1:test_minutes
        % horizontal line --> mean per minute.
        line([(parameter_time(1+(j-1)*(samples_minute))) parameter_time(j*samples_minute)],... % starting point ending point
            [parameter.response_mean(j,i) parameter.response_mean(j,i)], 'LineWidth',3,'Color',[0 1 0])
%       vertical line --> separate minute intervals.
        line([(samples_minute/fs)*j (samples_minute/fs)*j],[min(parameter.response(:,i)) max(parameter.response(:,i))]) % sample in j-th minute
    end
end

figure()
for i=1:size(parameter.response,2)
    subplot(5,1,i)
    bar(parameter.response_mean(:,i))
    xlim([0 length(parameter.response_mean)+1])
    ylabel(parameter.title{i},'interpreter','none')
    if (i==1)
        title('Mean of normalized parameters','FontSize',18)
    end
    if (i==size(parameter.response,2))
        xlabel('Time [min]')
    end
    set(gca,'FontSize',14)
end


for j=1:test_minutes
    % [peak value per minute, #sample for such peak]
    peaks_scr_minutes= findpeaks(scr_robot(1+(j-1)*(samples_minute):(j*samples_minute)), 'MinPeakHeight', 3e-2,'MinPeakDistance',25); 

    peaks_minutes_scr{j}=peaks_scr_minutes; % peaks per minute 
%     location_peaks_minutes_scr(j)= location_peaks_scr_minutes;
    number_peaks_minutes(j)=length(peaks_minutes_scr{j}); %how many peaks found per minute
end

figure % plot peaks
findpeaks(scr(robot==1),'MinPeakHeight', 3e-2,'MinPeakDistance',25)
xlabel('Samples')
ylabel('SCR peaks [\muS]')
title('SCR peaks')
set(gca,'FontSize',fontSize)

%% take indicators: stress, attention level, energy expenditure

% find how parameters vary:

for i=1:length(parameter.name)
    threshold(i)= max(parameter.response(:,i))/10; % take significant values
end

% if: VARIABLE increased wrt previous minute; then: assign parameter = 1:
for j=1:length(parameter.name)
    for i=1:length(parameter.response_diff) % iterate increment variation
        if (parameter.response_diff(i,j)>threshold(j))
            parameter.response_increment(i,j)=1;
        elseif (parameter.response_diff(i,j)<-threshold(j))
            parameter.response_increment(i,j)=-1;
        elseif  (parameter.response_diff(i,j)<=threshold(j)) && (parameter.response_diff(i,j)) >= -threshold(j)
            parameter.response_increment(i,j)=0;
        end
    end
end

% choose 1 if PEAKS increase; choose -1 if decrease:
k=length(parameter.name)+1;
for i=1:test_minutes-1 % iterate minutes
    if (number_peaks_minutes(i+1)>number_peaks_minutes(i)) 
        parameter.response_increment(i,k)=1;
    elseif (number_peaks_minutes(i+1)<number_peaks_minutes(i)) 
        parameter.response_increment(i,k)=-1;
    elseif (number_peaks_minutes(i+1)==number_peaks_minutes(i)) 
        parameter.response_increment(i,k)=0;
    end
end


% % idk what this is
% diff_peaks_scr= diff(number_peaks_minutes);
% k=size(parameter.response_increment,2)+1;
% for i=1:length(diff_peaks_scr)
%     if (diff_peaks_scr(i)>0)
%         parameters.response_increment(i,k)=1;
%     elseif (diff_peaks_scr(i)<0)
%         parameters.response_increment(i,k)=-1;
%     elseif (diff_peaks_scr(i)==0)
%         parameter.response_increment(i,k)=0;
%     end
% end


figure()
for i=1:size(parameter.response_increment,2)
    subplot(6,1,i)
    bar(parameter.response_increment(:,i));
    ylabel(parameter.title(i),'interpreter','none')
    if (i==1)
        title('Parameter increment','FontSize',18)
    end
    set(gca,'FontSize',14)
end
xlabel('Time [min]')

% each indicator is assigned a vector depedning on the THEORETICAL characteritics that
% define it (whether variables are high or low):
stress_theoretical= [1;-1;1;1;1];
attention_theoretical= [1;1;-1;1;1];
energy_expenditure_theoretical= [1;-1;1];

% EXPERIMENTAL variation values: %stored as 5-elements rows
parameter.psico= [parameter.response_increment(:,1), parameter.response_increment(:,2),...
    parameter.response_increment(:,3), parameter.response_increment(:,6), parameter.response_increment(:,5)];

% define vector: 
stress_real=zeros(1,length(parameter.psico));
for j=1:size(parameter.psico,1) 
    for i=1:size(parameter.psico,2) % if concide --> write those values
        verify_stress(j,i)= parameter.psico(j,i)==stress_theoretical(i); % Boolean
    end
    high_stress(j)=sum(verify_stress(j,:))>=3; % at least, 3 rules staisfied

    if sum(verify_stress(j,:))<1 % if little stress (one or less matches)
        stress_real(j)=-1; % assign NO value
    end
    if stress_real(j)==0 % previous IF was not entered 
        stress_real(j)=high_stress(j); 
    end
end
stress_tot= cumsum(stress_real);

attention_real=zeros(1,length(parameter.psico));
for j=1:size(parameter.psico,1)
    for i=1:size(parameter.psico,2)
        verify_attention(j,i)= parameter.psico(j,i)==attention_theoretical(i);
    end
    high_attention(j)=sum(verify_attention(j,:))>=3;    
    if sum(verify_attention(j,:))<1
        attention_real(j)=-1;
    end
    if attention_real(j)==0
        attention_real(j)=high_attention(j);
    end
end
attention_tot=cumsum(attention_real);

parameter.psico_energy= [parameter.response_increment(:,1), parameter.response_increment(:,2),...
    parameter.response_increment(:,3)]
  
energy_real=zeros(1,length(parameter.psico_energy));
for j=1:size(parameter.psico_energy,1)
    for i=1:size(parameter.psico_energy,2)
        verify_energy(j,i)= parameter.psico_energy(j,i)==energy_expenditure_theoretical(i);
    end
    high_energy(j)=sum(verify_energy(j,:))>=2;    
    if sum(verify_energy(j,:))<1
        energy_real(j)=-1;
    end
    if energy_real(j)==0
        energy_real(j)=high_energy(j);
    end
end
energy_tot=cumsum(energy_real);

%% PLOT and SAVE files: 
indicator.name= {'stress' 'attention' 'energy'};
indicator.value= [stress_tot; attention_tot; energy_tot];

figure
time_1=time(robot==1)
instant_1=time_1(1)/1000*12-1
for i=1:length(indicator.name)
    subplot(length(indicator.name),1,i)
    plot(indicator.value(i,:)*50,'LineWidth', 2)
    hold on
    for j=1:length(parameter.response(1,:))
        x=parameter.original(:,j);
        x=x(robot==1);
        plot(time_1/1000*12-(instant_1),x) %parameter.original(robot==1)(:,j)
        legend([indicator.name(i),parameter.name])
    end
    if i==1
        title('Physiological Status')
    end
    ylabel(indicator.name(i))
end
xlabel('Time [min]')

save 'indicator.mat' 'indicator';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%% END %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
disp('--------------------------------------')
disp('--------------- ENDED ----------------')
disp('--------------------------------------')