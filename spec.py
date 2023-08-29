from pylab import *
from scipy.io import wavfile 
import sys
import os
name = sys.argv[1]


(sr,sig) = wavfile.read(name)
N = sr
start = sr+500
x = arange(0,N/2)
bins = x*sr/N
win = hanning(N)
scal = N*sqrt(mean(win**2))
sig1 = sig[start:N+start]
window = fft(sig1*win/max(sig1))
mags = abs(window/scal)
spec = 20*log10(mags/max(mags))
plot(bins,spec[0:N//2], 'k-')
ylim(-60)
ylabel("magnitude (dB)", size=16)
xlabel("frequency (Hz)", size=16)
yticks()
xticks()
xlim(0,8000)
fign = os.path.splitext(name)[0]
savefig("%s.pdf" %  fign)
show()

