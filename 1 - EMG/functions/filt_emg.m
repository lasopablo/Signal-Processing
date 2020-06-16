%% EMG filtering %%%%%%%%%%%%%%%%%%%%%%
% Fs = Sampling frequency           %%%
% signal to be filtered             %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function out=filt_emg(x,Fs);

x=double(x); 
order=4;
low_pass_cutoff=20;
high_pass_cutoff=350;

% butterworth
bpWn(1)=low_pass_cutoff/(Fs/2);
bpWn(2)=high_pass_cutoff/(Fs/2);
[bpB,bpA]= butter(order,bpWn,'bandpass');
filt_x=filtfilt(bpB,bpA,x);

% notch filter 
nWn(1)=(50-2)/(Fs/2);
nWn(2)=(50+2)/(Fs/2);
[nB,nA]= butter(order,nWn,'stop');
notch_x=filtfilt(nB,nA,x);

% rectify 
rect_x=abs(notch_x);

% envelope
cutoff_env=5/(Fs/2);
[b,a]= butter(order,cutoff_env); % LPF

out=filtfilt(b,a,rect_x);

end