
#####     SIMPLE SINE WAVE TRANSFORMED TO FREQUENCY DOMAIN     #####
# help from: https://stackoverflow.com/questions/55317667/frequency-domain-of-a-sine-wave-with-frequency-1000hz

import numpy as np

import matplotlib.pyplot as plt

sampling_rate = 48000
n = 48000
signal_freq= 2000


sine_wave = [100*np.sin(2 * np.pi * signal_freq * x/sampling_rate) for x in range(n)]

s= np.array(sine_wave)

t=np.arange(0,n/sampling_rate,1/sampling_rate)
plt.subplot(211)
plt.title('sine wave (may not be visible for human eye)')
plt.plot(t[:100],sine_wave[:100],'ro')

spectrum = 2/n*np.abs(np.fft.rfft(sine_wave))
frequencies = np.fft.rfftfreq(n, 1/sampling_rate)
plt.subplot(212)
plt.title('frequency domain')
plt.plot(frequencies,spectrum)
plt.show()

plt.subplot(211)
plt.title('sine wave')
plt.plot(t[:200],s[:200])

s_fft = np.fft.fft(s)/len(sine_wave)
frequencies = np.abs(s_fft)
plt.subplot(212)
plt.plot(frequencies[:int(sampling_rate/2)]) # else freq would be repeated as (2*sampling_rate-signal_freq)
plt.title('frequency spectrum')
plt.show()
