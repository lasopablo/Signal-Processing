
#####     PRODUCING, STORING, READING AND FILTERING A SOUND SINEWAVE     #####

import numpy as np

import wave

import struct

import matplotlib.pyplot as plt

# frequency is the number of times a wave repeats a second

frequency = 1000

num_samples = 48000 # length or time vector

# The sampling rate of the analog to digital convert

sampling_rate = 48000.0

# maximum value of signed 16 bit number is 32767 (2^15 – 1). (Because the left most bit is reserved for the sign, leaving 15 bits.
# We raise 2 to the power of 15 and then subtract one, as computers count from 0).
amplitude = 16000 # number <= 32767

file = "test.wav"

sine_wave = [np.sin(2 * np.pi * frequency * x/sampling_rate) for x in range(num_samples)]


nframes = num_samples

comptype = "NONE"

compname = "not compressed"

nchannels = 1

sampwidth = 2

wav_file = wave.open(file, 'w')

wav_file.setparams((nchannels, sampwidth, int(sampling_rate), nframes, comptype, compname))

# Struct is a Python library that takes our data and packs it as binary data. The h in the code means 16 bit number.

for s in sine_wave:
    wav_file.writeframes(struct.pack('h', int(s * amplitude))) # We are writing the sine_wave sample by sample

print('signal', file, 'stored!')

############################

frame_rate = 48000.0

infile = "test.wav"

num_samples = 48000

wav_file = wave.open(infile, 'r')

data = wav_file.readframes(num_samples)

wav_file.close() # file extracted

data = struct.unpack('{n}h'.format(n=num_samples), data) #unpack num_samples 16 bit words (remember the h means 16 bits).

data = np.array(data)

data_fft = np.fft.fft(data)

frequencies = np.abs(data_fft) # The numpy abs() function will take our complex signal and generate the real part of it.

'''num = 0
for f in frequencies:
    if f == max(frequencies):
        print(f, num)
    elif f != max(frequencies):
        num = num + 1
print('max freq:', num, 'Hz:',max(frequencies))'''

plt.subplot(2, 1, 1)
plt.plot(data[0:200])  # from 0 to x secs (note that sine must be defined in such interval)
plt.title("Original audio wave")


plt.subplot(2, 1, 2)
plt.plot(frequencies)
plt.title("Frequencies found")
plt.xlim(0, 1500)
plt.show()