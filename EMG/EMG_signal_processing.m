    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %       Pablo Laso Mielgo        %
    %     EMG signal processing      %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    %% treating EMG data 
    close all;
    clear all;
    clc;

    % add folders to seacrh path
    addpath('functions');

    % user chooses saving directory
    EMGdata.path='C:\Users\pablo\OneDrive - Universidad Rey Juan Carlos\Biomedical Engineering URJC\3º curso\Asignaturas y Apuntes\Semester II\corso\[L] LABORATORIO di Bioingegneria\lab (MatLab)\1 - EMG\EMG_Gruppo2'%this is just to quick check!! delete or comment for propper functioning
    %EMGdata.path = uigetdir('select directory to load');

    %% load data
    EMGdata.files = dir([EMGdata.path filesep '*.mat']);

    acq_num=length(EMGdata.files);

    for i = 1:acq_num
        EMGdata.trial(i).name=EMGdata.files(i).name;
        EMGdata.trial(i).raw_data = ...
            load([EMGdata.path filesep EMGdata.files(i).name]);
    end

    %% Elaborate data

    Fs=1111; %Hz
    total_range=10; %s

    for i=1:acq_num
        data_len=length(EMGdata.trial(i).raw_data.biceps);
        data_range=round(data_len/2-total_range/2*Fs) : ...
            round(data_len/2+total_range/2*Fs); 

        if strfind(EMGdata.trial(i).name, 'MVC')
            EMGdata.trial(i).cut_data.biceps...
                =EMGdata.trial(i).raw_data.biceps;
            EMGdata.trial(i).cut_data.triceps...
                =EMGdata.trial(i).raw_data.triceps;
            EMGdata.trial(i).cut_data.time...
                =EMGdata.trial(i).raw_data.time;

        else
            EMGdata.trial(i).cut_data.biceps...
                =EMGdata.trial(i).raw_data.biceps(data_range);
            EMGdata.trial(i).cut_data.triceps...
                =EMGdata.trial(i).raw_data.triceps(data_range);
            EMGdata.trial(i).cut_data.time...
                =linspace(0,total_range,total_range*Fs+1)';    
        end
    end

    % Filter

    for i= 1:acq_num

        EMGdata.trial(i).elab_data.biceps...
            =filt_emg(EMGdata.trial(i).cut_data.biceps,Fs);
        EMGdata.trial(i).elab_data.triceps...
            =filt_emg(EMGdata.trial(i).cut_data.triceps,Fs);
        EMGdata.trial(i).elab_data.time...
            =filt_emg(EMGdata.trial(i).cut_data.time,Fs);
    end

    % PLOT_ bicepts/triceps activty along time and envelope waveform
    subplot(2,1,1) % MVC (3 intervals)
    plot(EMGdata.trial(1).cut_data.time,...
        EMGdata.trial(1).cut_data.biceps,'linewidth',1)
    hold on % same figure
    plot(EMGdata.trial(1).cut_data.time,...
        EMGdata.trial(1).elab_data.biceps,'linewidth',3)
    xlabel('Time [s]')
    ylabel('Activity [mV]')
    legend('Biceps activty','Envelope signal')
    title('Biceps Activity')
    subplot(2,1,2)
    plot(EMGdata.trial(2).cut_data.time,...
        EMGdata.trial(2).cut_data.triceps,'linewidth',1)
    hold on % same figure
    plot(EMGdata.trial(2).cut_data.time,...
        EMGdata.trial(2).elab_data.triceps,'linewidth',3)
    xlabel('Time [s]')
    ylabel('Activity [mV]')
    legend('Triceps activty','Envelope signal')
    title('Triceps Activity')

    %%
    MVC_data_biceps= EMGdata.trial(1).elab_data.biceps; % for next steps
    MVC_data_triceps= EMGdata.trial(2).elab_data.triceps; % for next steps

    % input from user
    disp(' Instructions:')
    disp('1. Click the Data Cursor button on the toolbar of the generated figure.')
    disp('2. Click any point of your choice on the line in the figure.')
    disp('3. While pressing the Alt key, repeat step 3 as many times as you like until you have selected your desired set of points.')
    disp('4. Right-click (or control-click if you are on a Mac) anywhere on the figure, and select the "Export Cursor Data to Workspace..." option from the context menu.')
    disp('5. Write the variable name, "cursor_info_biceps", and click "OK".')
    disp('6. Type "cursor_info_biceps.DataIndex" at the MATLAB command prompt and hit "Enter".') 

    load('cursor_info_biceps.mat') % TRICK to check faster (Group 2 data)
    load('cursor_info_triceps.mat') % TRICK to check faster (Group 2 data)
    %input('select 6 points and save as: cursor_info_biceps >> ');
    % input('select 6 points and save as: cursor_info_triceps >> ');

    % store data SORTED
    data_index_biceps_sorted=sort([cursor_info_biceps.DataIndex]);
    data_index_triceps_sorted=sort([cursor_info_triceps.DataIndex]);

    MVC_biceps_1= MVC_data_biceps(data_index_biceps_sorted(1)...
        :data_index_biceps_sorted(2)); % take only from first click to second click
    MVC_biceps_2= MVC_data_biceps(data_index_biceps_sorted(3)...
        :data_index_biceps_sorted(4)); 
    MVC_biceps_3= MVC_data_biceps(data_index_biceps_sorted(5)...
        :data_index_biceps_sorted(6)); 
    data_index_biceps_sorted=sort([cursor_info_biceps.DataIndex]);

    MVC_triceps_1= MVC_data_triceps(data_index_triceps_sorted(1)...
        :data_index_triceps_sorted(2)); % take only from first click to second click
    MVC_triceps_2= MVC_data_triceps(data_index_triceps_sorted(3)...
        :data_index_triceps_sorted(4)); 
    MVC_triceps_3= MVC_data_triceps(data_index_triceps_sorted(5)...
        :data_index_triceps_sorted(6)); 

    MVC_biceps_max1=max(MVC_biceps_1);
    MVC_biceps_max2=max(MVC_biceps_2);
    MVC_biceps_max3=max(MVC_biceps_3);

    MVC_triceps_max1=max(MVC_triceps_1);
    MVC_triceps_max2=max(MVC_triceps_2);
    MVC_triceps_max3=max(MVC_triceps_3);

    MVC_biceps_max=min([MVC_biceps_max1 MVC_biceps_max2 MVC_biceps_max3]); % take the minimum from the three maximums, one for each subacq
    MVC_triceps_max=min([MVC_triceps_max1 MVC_triceps_max2 MVC_triceps_max3]); % take the minimum from the three maximums, one for each subacq
    MVC_thr=0.7; 

    % set a thershold for non-valid values, depedning on the min above
    MVC_biceps_thr1=mean(MVC_biceps_1(MVC_biceps_1>MVC_thr*MVC_biceps_max));
    MVC_biceps_thr2=mean(MVC_biceps_2(MVC_biceps_2>MVC_thr*MVC_biceps_max));
    MVC_biceps_thr3=mean(MVC_biceps_3(MVC_biceps_3>MVC_thr*MVC_biceps_max));

    MVC_biceps=mean([MVC_biceps_thr1 MVC_biceps_thr2 MVC_biceps_thr3]);

    MVC_triceps_thr1=mean(MVC_triceps_1(MVC_triceps_1>MVC_thr*MVC_triceps_max));
    MVC_triceps_thr2=mean(MVC_triceps_2(MVC_triceps_2>MVC_thr*MVC_triceps_max));
    MVC_triceps_thr3=mean(MVC_triceps_3(MVC_triceps_3>MVC_thr*MVC_triceps_max));

    MVC_triceps=mean([MVC_triceps_thr1 MVC_triceps_thr2 MVC_triceps_thr3]);

    % PLOT_ the three bicepts/triceps intervals:
    figure
    plot(MVC_biceps_1,'b','linewidth',2)
    hold on
    plot(MVC_biceps_2,'r','linewidth',2)
    plot(MVC_biceps_3,'g','linewidth',2)

    plot([0 max([length(MVC_biceps_1) length(MVC_biceps_2) ...
        length(MVC_biceps_3)])],[1  1]*MVC_biceps,'k--','linewidth',2)	
    xlim([0 max([length(MVC_biceps_1) length(MVC_biceps_2) length(MVC_biceps_3)])])
    xlabel('samples','FontSize',24)
    ylabel('Biceps Activity [mV]', 'FontSize',24)
    legend('1st contraction', '2nd contraction', '3rd contraction')
    title('Biceps Activity (MVC estimation)','FontSize',24)
    set(gca,'FontSize',24)

    figure 
    plot(MVC_triceps_1,'b','linewidth',2)
    hold on
    plot(MVC_triceps_2,'r','linewidth',2)
    plot(MVC_triceps_3,'g','linewidth',2)

    plot([0 max([length(MVC_triceps_1) length(MVC_triceps_2) ...
        length(MVC_triceps_3)])],[1  1]*MVC_triceps,'k--','linewidth',2)	
    xlim([0 max([length(MVC_triceps_1) length(MVC_triceps_2) length(MVC_triceps_3)])])
    xlabel('samples','FontSize',24)
    ylabel('Triceps Activity [mV]', 'FontSize',24)
    legend('1st contraction', '2nd contraction', '3rd contraction')
    title('Triceps Activity (MVC estimation)','FontSize',24)
    set(gca,'FontSize',24)

    for i=1:acq_num
        EMGdata.trial(i).norm_data.biceps...
            =EMGdata.trial(i).elab_data.biceps/MVC_biceps;
        EMGdata.trial(i).norm_data.triceps...
            =EMGdata.trial(i).elab_data.triceps/MVC_triceps;
        EMGdata.trial(i).norm_data.time...
            =EMGdata.trial(i).elab_data.time;
    end

    % PLOT_ biceps/tricpes in ALL patient configurations
    figure
    for i=3:acq_num % avoid first two MVC data
        subplot(4,4,i-2)

        plot(EMGdata.trial(i).norm_data.time,...
            EMGdata.trial(i).norm_data.biceps,'b','linewidth',2)
        hold on
        plot(EMGdata.trial(i).norm_data.time,...
            EMGdata.trial(i).norm_data.triceps,'r','linewidth',2)

        ylim([0 1])
        xlabel('time [s]','Fontsize',14)
        ylabel('EMG norm','Fontsize',14)

        title(strrep(EMGdata.trial(i).name,'.mat',''),...
            'interpreter','none','FontSize',18)

        set(gca,'FontSize',14)   

    end    
    legend('biceps','triceps') 

    %% PLOT_ Triceps MVC estimation 
    MVC_data_triceps=EMGdata.trial(2).elab_data.triceps;

    figure
    plot(MVC_data_triceps,'linewidth',2)
    xlabel('samples','Fontsize',24)
    ylabel('Triceps activity [mV]', 'Fontsize',24)
    title('triceps Activity (MVC estimation)','Fontsize',24)
    set(gca,'Fontsize',24)
    legend('biceps','tricpes')

    for i=1:acq_num
        EMGdata.trial(i).ave_data.biceps=mean(EMGdata.trial(i).norm_data.biceps);
        EMGdata.trial(i).ave_data.triceps=mean(EMGdata.trial(i).norm_data.triceps);
    end

    %% Calculating the load torque and muscle force
    Wsbj=72;
    Hsbj=1.8;

    for i=3:acq_num
        str_cut=strsplit(EMGdata.trial(i).name,'_');

        theta=str2num(strrep(str_cut{3},'.mat','')); %take angle from name description string and delete .mat

        if strcmp(str_cut{1},'seduto')
            sit=1;
        else
            sit=0;
        end

        if strcmp(str_cut{2},'load')
            load=1;
        else
            load=0;
        end
        % torque:
        EMGdata.trial(i).tau_c = calc_torque(Wsbj,Hsbj,deg2rad(theta),load,sit);
        % force:
        [EMGdata.trial(i).F1,EMGdata.trial(i).F2]=...
            calc_force(EMGdata.trial(i).ave_data.biceps,...
            EMGdata.trial(i).ave_data.triceps,...
            Hsbj,EMGdata.trial(i).tau_c,deg2rad(theta));
    end


disp('--')