from Bio import SwissProt

for record in SwissProt.parse(open('../0_DB/uniprot_sprot.dat')):
	pid=record.accessions[0]
	seq=record.sequence
	print ">"+pid+"\n"+seq+"\n"
