
#####     COMBINING TWO SINEWAVES, LEAVING ONE OUT AFTER FILTERING     #####

import numpy as np
import matplotlib.pyplot as plt

# frequency is the number of times a wave repeats a second

frequency = 1000

noisy_freq = 50

num_samples = 48000

# The sampling rate of the analog to digital convert
sampling_rate = 48000.0

#The main frequency is a 1000Hz, and we will add a noise of 50Hz to it.

sine_wave = [np.sin(2 * np.pi * frequency * x1 / sampling_rate) for x1 in range(num_samples)]
sine_noise = [np.sin(2 * np.pi * noisy_freq * x1 / sampling_rate) for x1 in range(num_samples)]

# Convert them to numpy arrays

sine_wave = np.array(sine_wave)
sine_noise = np.array(sine_noise)

combined_signal = sine_wave + sine_noise

#####  plotting
plt.subplot(3, 1, 1)
plt.title("Original sine wave")
plt.subplots_adjust(hspace=.5)
plt.plot(sine_wave[:500])

plt.subplot(3, 1, 2)
plt.title("Noisy wave")
plt.plot(sine_noise[:4000])

plt.subplot(3, 1, 3)
plt.title("Original + Noise")
plt.plot(combined_signal[:3000])
plt.show()

#####  fft
data_fft = np.fft.fft(combined_signal)
freq_fft = np.abs(data_fft[:len(data_fft)])
plt.plot(freq_fft)
plt.title('combined signal')
plt.xlim(0,1200)
plt.show()

#####  filtering

filtered_freq = []

index = 0
for f in freq_fft:
    if index > 950 and index < 1050: # freq to keep
        if f > 1:
            filtered_freq.append(f)
        else: # negligible
            filtered_freq.append(0)
    else: # unwanted
        filtered_freq.append(0)
    index += 1

#filtered_freq = [f if (950 < index < 1050 and f > 1) else 0 for index, f in enumerate(freq)] # replace for code above

plt.plot(filtered_freq)
plt.title("Filtered signal (FD) (1000Hz removed)")
plt.xlim(0, 1200)
plt.show()
plt.close()

# return to time Domain
recovered_signal = np.fft.ifft(filtered_freq)

# altogether:
plt.subplot(4, 1, 1)
plt.title("Original sine wave")
plt.subplots_adjust(hspace=.5)
plt.plot(sine_wave[:500])

plt.subplot(4, 1, 2)
plt.title("Noisy wave")
plt.plot(sine_noise[:4000])

plt.subplot(4, 1, 3)
plt.title("Original + Noise")
plt.plot(combined_signal[:3000])

plt.subplot(4, 1, 4)
plt.title('recovered signal (TD)')
plt.plot(recovered_signal[:500])
plt.show()