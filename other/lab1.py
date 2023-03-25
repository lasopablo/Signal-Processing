#%matplotlib notebook
import numpy as np
import matplotlib.pyplot as plt

#Parameters definition
fs = 10e3 #sampling frequency fs
T = 1/fs #sampling period T
L = 10e3 #length L in number of samples
t = np.arange(L)*T #time vector t in secs (L values get divided by fs: note they will get 'reversed')


#Signal####################
#sinusoidal amplitudes
A1 = 0.7
A2 = 1
A3 = 0.5
#sinusoidal frequencies
f1 = 50 #Hz
f2 = 2*f1 #Hz
f3 = 2*f2 #HZ

s1 = np.sin(2*np.pi*f1*t)
s2 = np.sin(2*np.pi*f2*t)
s3 = np.sin(2*np.pi*f3*t)




s = s1 +s2 +s3


#plotting signal
plt.figure(0)
plt.plot(t, s) # signal to be plot
plt.title('signal: s')
plt.ylabel('amplitude')
plt.xlabel('time')
plt.grid(True, which='both')
#plt.axhline(y=0, color='r')

#using stem

#
def NextPowerOfTwo(number):
    # Returns next power of two following 'number'
    return int(np.ceil(np.log2(number)))


Lt = len(s)
print(Lt)
NFFT = 2**NextPowerOfTwo(Lt) #next power of 2 from length of y

#compute fft


sfft = np.fft.fft(s)

t = np.arange(256)
sp = np.fft.fft(np.sin(t))
freq = np.fft.fftfreq(t.shape[-1])
plt.figure(1)
plt.plot(freq, sp.real, freq, sp.imag) # sfft to be plot
plt.show()
plt.title('FFT of: s')
plt.ylabel('amplitude')
plt.xlabel('frequency (Hz)')
plt.grid(True, which='both')