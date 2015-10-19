#!/usr/bin/perl

##
#	Use : To Generate Similarity Matrix from Pair-wise Alignment Result (SRS Format) of multiple sequences
#	Require : Perl & Pair-wise Alignment Result (SRS Format)
#	Usage : perl Gen_Matrix.pl <InputSRSFile> > <OutputFile>
##

use strict;

my$fname=$ARGV[0];

open(FH,$fname) or die;
my@aln= <FH> ;
close(FH);

my%mat;
my$seq1;
my$seq2;
my$homology;

foreach my$line (@aln){
	
	if($line=~/# 1: (.*)$/){
		$seq1=$1;
		}
	elsif($line=~/# 2: (.*)$/){
		$seq2=$1;
		}
	elsif($line=~/# Similarity:.*\((.*?)%\)/){
		$homology=$1;
		$mat{$seq1}->{$seq2}=$homology;
		}
	
	}


my@labels = keys(%mat);
@labels = sort (@labels);

print "\t",join("\t",@labels);

foreach my$k1 (@labels){
	
	print "\n",$k1;
	
	foreach my$k2 (@labels){
	
	if(defined($mat{$k1}->{$k2})){
		print "\t",$mat{$k1}->{$k2};
		}else{
			print "\t0";
			}
		}
	
	}
