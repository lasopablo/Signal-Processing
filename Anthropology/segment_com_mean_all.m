Fs= 120;

cycles=diff(subj1.run_03.events.eRFSshifted);

cycles_frame=round(cycles*Fs);
cycle_norm=max(cycles_frame);

for i=1:length(subj1.run_03.events.eRFSshifted)-1

    start_f= round(subj1.run_03.events.eRFSshifted(i)*Fs);
    end_f= round(subj1.run_03.events.eRFSshifted(i+1)*Fs);

    com_TOT_segmented= resample(com_TOT.v03(start_f:end_f,:),cycle_norm,length(com_TOT.v03(start_f:end_f,:)));

    com_TOT_cycle.v03(i).cycle= filt_com(com_TOT_segmented,Fs);
end

% figure
v03_z_mean= mean([com_TOT_cycle.v03(1).cycle(:,3), com_TOT_cycle.v03(2).cycle(:,3)]')
v03_y_mean= mean([com_TOT_cycle.v03(1).cycle(:,2), com_TOT_cycle.v03(2).cycle(:,2)]')
plot(v03_z_mean,v03_y_mean)
xlabel('com_z [m]') 
ylabel('com_y [m]') 
title('Pelvis motion at vel03')
hold on
%%
Fs= 120;

cycles=diff(subj1.run_05.events.eRFSshifted);

cycles_frame=round(cycles*Fs);
cycle_norm=max(cycles_frame);

for i=1:length(subj1.run_05.events.eRFSshifted)-1

    start_f= round(subj1.run_05.events.eRFSshifted(i)*Fs);
    end_f= round(subj1.run_05.events.eRFSshifted(i+1)*Fs);

    com_TOT_segmented= resample(com_TOT.v05(start_f:end_f,:),cycle_norm,length(com_TOT.v05(start_f:end_f,:)));

    com_TOT_cycle.v05(i).cycle= filt_com(com_TOT_segmented,Fs);
end

% figure
v05_z_mean= mean([com_TOT_cycle.v05(1).cycle(:,3), com_TOT_cycle.v05(2).cycle(:,3)]')
v05_y_mean= mean([com_TOT_cycle.v05(1).cycle(:,2), com_TOT_cycle.v05(2).cycle(:,2)]')
plot(v05_z_mean,v05_y_mean)
xlabel('com_z [m]') 
ylabel('com_y [m]') 
%%
Fs= 120;

cycles=diff(subj1.run_06.events.eRFSshifted);

cycles_frame=round(cycles*Fs);
cycle_norm=max(cycles_frame);

for i=1:length(subj1.run_06.events.eRFSshifted)-1

    start_f= round(subj1.run_06.events.eRFSshifted(i)*Fs);
    end_f= round(subj1.run_06.events.eRFSshifted(i+1)*Fs);

    com_TOT_segmented= resample(com_TOT.v06(start_f:end_f,:),cycle_norm,length(com_TOT.v06(start_f:end_f,:)));

    com_TOT_cycle.v06(i).cycle= filt_com(com_TOT_segmented,Fs);
end

% figure
v06_z_mean= mean([com_TOT_cycle.v06(1).cycle(:,3), com_TOT_cycle.v06(2).cycle(:,3)]')
v06_y_mean= mean([com_TOT_cycle.v06(1).cycle(:,2), com_TOT_cycle.v06(2).cycle(:,2)]')
plot(v06_z_mean,v06_y_mean)
xlabel('com_z [m]') 
ylabel('com_y [m]') 
%%
title('Pelvis motion')
legend('vel03','vel05','vel06')