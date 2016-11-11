###  Fetch Genomics Sequence Using Coordinates In Biopython

from Bio import Entrez, SeqIO
Entrez.email = "A.N.Other@example.com"     # Always tell NCBI who you are
handle = Entrez.efetch(db="nucleotide", 
                       id="307603377", 
                       rettype="fasta", 
                       strand=1, 
                       seq_start=4000100, 
                       seq_stop=4000200)
record = SeqIO.read(handle, "fasta")
handle.close()
print record.seq

#db - database
#id - GI
#strand - what strand of DNA to show (1 = plus or 2 = minus)
#seq_start - show sequence starting from this base number
#seq_stop - show sequence ending on this base number
