import matplotlib.pyplot as plt
import matplotlib as mpl
import pandas as pd
import numpy as np

def enrich_plot(labels, pvals, counts, fig_file):
	axes1 = [0.60, 0.08, 0.35, 0.90] # for pathway and GO terms
	plt.rcdefaults()
	fig = plt.figure(figsize = (10,8))
	ax = fig.add_axes(axes1,frame_on=True)
	n = len(labels)
	if n > 20: # plot the top 20 items
		n = 20
		labels = labels[0:20]
		pvals = pvals[0:20]
	y_pos = np.arange(n)
	values = [-np.log10(x) for x in pvals]
	width = 0.4

	rec1 = ax.barh(y_pos, values, width, color = 'gray', alpha = 0.65, edgecolor='k')
	ax.set_ylim([-0.5,n - 0.5])
	# ax.set_yticks(y_pos+width/2)
	ax.set_yticks(y_pos)
	ax.set_yticklabels(labels)
	ax.invert_yaxis()  # labels read top-to-bottom
	ax.set_xlabel('Enrichment Score [-log10(p-value)]')
# 	plt.show()
	plt.savefig(fig_file, dpi = 600)
	plt.close()

enrich_plot(labels, pvals, counts, fig_file)