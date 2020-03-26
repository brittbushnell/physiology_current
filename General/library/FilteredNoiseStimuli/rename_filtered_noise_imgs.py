import os
import numpy as np

ind = 0
for scale in range(1,5):
	for orientation in range(1,17):
		for exemplar in range(1,11):
			os.system('cp filtered_noise_original/s%io%i_%i.png filtered_noise_renamed/%i.png' % (scale, orientation, exemplar, ind))
			ind += 1
