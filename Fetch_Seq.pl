#!/usr/bin/perl

##
#	Use : To Fetch Sequence by ID list from Fasta File
#	Require : Perl & Input Fasta File
#	Usage : perl Fetch_Seq.pl <InputFastaFile> <QueryIDsFile> > <OutputFastaFile>
##

use strict;

my $in_seqs=$ARGV[0];
my $query_ids = $ARGV[1];

open(FH,$in_seqs)or die $!;
my @cont=<FH>;
close(FH);
chop(@cont);


open(FH,$query_ids)or die $!;
my @ids=<FH>;
close(FH);
chomp @ids;

#	storing sequences

my %h;
my $header;

my@words;
foreach my $line(@cont){
	
		if($line=~/^>/){
			
			$header=substr($line,1);
			@words=split(/ |\|/,$header);
			$header=$words[0];
			
			}else{
			
				push(@{$h{$header}},$line);
				}
	}

foreach (@ids) {
  if (exists($h{$_})) {
    delete($h{$_});
    }
}


foreach my$k (keys(%h)){
	
	print '>'.$k,"\n", join("\n",@{$h{$k}}),"\n";
	
	}

