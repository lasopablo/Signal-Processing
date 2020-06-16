function out=filt_com(x,Fs) % signal, sampling freq

order=2;
cutoff=5;
[b,a]=butter(order,cutoff./(Fs/2)); % filt coeffs
out=filtfilt(b,a,x); 

end