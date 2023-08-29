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


fig,axs = plt.subplots(1,2,figsize=[8,3])

axs[0].plot(sig1[sr//110-200:3*sr//110-200]/max(abs(sig1)), color='k')
axs[1].plot(spec, color='k')

axs[0].set_ylim(-1.,1)
#axs[0,0].set_xlim(0,2.01)

axs[0].set_xlabel('time (samples)')
axs[0].set_ylabel('amplitude')



axs[1].set_ylim(-60,0)
axs[1].set_xlim(0,8000)
#axs[0].set_ylim(-90,0)


axs[1].set_xlabel('frequency (KHz)')
axs[1].set_ylabel('magnitude (dB)')

for i in (0,1):
      axs[i].grid()
plt.tight_layout()
fign = os.path.splitext(name)[0]
savefig("figs/%s.pdf" %  fign)
plt.show()


