import matplotlib.pyplot as plt

def plot_boxplot(data, out_fig, data_labels, x_label, y_label, outlier):
	# input data is a list of arrays, each array correspond to a data_label
	fig = plt.figure(figsize = (8,5))
	ax = fig.add_axes([0.17, 0.17, 0.775, 0.775], frame_on = True)
	boxplots = ax.boxplot(data,
	           notch = True,
	           labels= data_labels, # xticks labels
	           widths = .7,
	           patch_artist=True,
	           showfliers = outlier, # outlier: True/Flase               
	           medianprops = dict(linestyle='-', linewidth=2, color='Yellow'),
	           boxprops = dict(linestyle='--', linewidth=2, color='Black', facecolor = 'blue', alpha = .4)
	          );

# 	boxplot1 = boxplots['boxes'][0]
# 	boxplot1.set_facecolor('red')

	plt.xlabel(x_label, fontsize = 20);
	plt.ylabel(y_label, fontsize = 20);
	plt.xticks(fontsize = 16);
	plt.yticks(fontsize = 16);
# 	plt.show()
	plt.savefig(out_fig, dpi = 600)