#!/usr/bin/python

##
#	Use : To make reverse compliment of multiple fasta 
#	Require : preinstalled BioPython
#	Usage : python Rev_Comp.py <InputFile> > <OutputFile>
##

import sys

file=sys.argv[1]

print >> sys.stderr, file 

from Bio import SeqIO
for record in SeqIO.parse(file, "fasta"):
    print ">"+record.id
    print record.seq.reverse_complement()
