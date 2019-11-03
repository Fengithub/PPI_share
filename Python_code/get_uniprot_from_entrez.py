"""
gene ID mapping, convert Entrez ID to Uniprot ID
"""
# https://pypi.org/project/mygene/

import mygene
import pandas as pd 
mg = mygene.MyGeneInfo()

def get_unip(in_file, out_file):
	df = pd.read_csv(in_file, sep = '\t')
	entrez_ids = df['Entrez_Gene'].tolist()
	unips = []
	for entrez_id in entrez_ids:
		unip_tmp = mg.getgene(entrez_id, 'uniprot')
		if not unip_tmp:
			unips.append('NA')
		elif 'uniprot' in unip_tmp and unip_tmp['uniprot'] and 'Swiss-Prot' in unip_tmp['uniprot']:
			unip = unip_tmp['uniprot']['Swiss-Prot']
			if type(unip) == list:
				unip = unip[0]
			unips.append(unip)
		elif 'uniprot' in unip_tmp and unip_tmp['uniprot'] and 'TrEMBL' in unip_tmp['uniprot']:
			unip = unip_tmp['uniprot']['TrEMBL']
			if type(unip) == list:
				unip = unip[0]
			unips.append(unip)
		else:
			unips.append('NA')
	
	df.insert(4, 'Uniprot_ID', unips, True)
	df.to_csv(out_file, sep = '\t', index = False)