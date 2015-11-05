#!/usr/bin/python

##
#	Use : To get selected sequence part
#	Require : preinstalled BioPython
#	Usage : python script.py <InputSeqFile> <selected_pfam> > <OutputFile>
##

import sys,csv,re
from Bio import SeqIO

###
# Argumants
###

if len(sys.argv) != 3:
	print "USAGE: \n \t python",sys.argv[0]," <SeqFile> <PFamFile> \n There must be 2 arguments",len(sys.argv)
	sys.exit()

seqfile=sys.argv[1]
pfamfile=sys.argv[2]

#~ Test
#~ print >> sys.stderr, filename

###
# Global Var
###

resultSeqIDs={}

###
# functions
###

def get_seq(seqID,start_cor,end_cor):
	for record in SeqIO.parse(seqfile, "fasta"):
		if record.id == seqID:
			seq = str(record.seq[start_cor-1:end_cor])
			formated = '\n'.join(seq[i:i+50] for i in range(0, len(seq), 50))
			seqID = record.id[0:record.id.index('|')]
			if seqID not in resultSeqIDs:
				resultSeqIDs[seqID] = 1
			else:
				resultSeqIDs[seqID] += 1
			
			return ">" + seqID + chr(resultSeqIDs[seqID]+96) + " " + str(start_cor)+ " " + str(end_cor) + " "+str(end_cor-start_cor+1) + "\n" + formated

def parse_pfam(pfamFile,domName):
	#init
	outContent=''
	#file line read
	f = open(pfamFile, 'r')
	line  = f.readline()
	while line:
		line = line.strip()
		if '#' not in line and len(line) :
			reader = re.split(r'\s+',line)
			if reader[5] == domName: # 5/6
				#test
				#~ print reader[0],reader[5],reader[1],reader[2]
				outContent+=get_seq(reader[0],int(reader[1]),int(reader[2]))+"\n"
		#file next line read
		line = f.readline()
	return outContent



#####
# Main
#####

print parse_pfam(pfamfile,'Glutaredoxin')
