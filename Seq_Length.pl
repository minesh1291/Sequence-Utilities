#!/usr/bin/perl

##
#	Use : To List Sequence Length from Fasta File
#	Require : Perl & Input Fasta File
#	Usage : perl Seq_Length.pl <InputFastaFile> > <OutputFile>
##

use strict;

my $in_seqs=$ARGV[0];

open(FH,$in_seqs)or die $!;
my @cont=<FH>;
close(FH);
chop(@cont);

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

my @key=keys(%h);

foreach my$k (@key){
	
	print $k,"\t", length( join('',@{$h{$k}})),"\n";
	
	}
