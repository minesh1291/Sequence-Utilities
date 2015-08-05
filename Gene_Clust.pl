#!/usr/bin/perl

##
#	Use : To List Gene clusters/Operons from GFF File
#	Require : Perl & Input GeneGFF File
#	Usage : perl Gene_Clust.pl <GeneGFF> <OutputFile> <Gap>
##

use strict;

my$infile=$ARGV[0];
my$dist=$ARGV[2];	#eg. 100;

open(FHin,$infile) or die;
my@cont=<FHin>;
close(FHin);
chomp(@cont);

my@words;
my$pre_start=0;
my$pre_end=0;
my$pre_sign;
my$f=0;


my@out;
my$line_num=0;

foreach my$line (@cont){
	@words=split("\t",$line);
	
	if((($words[1]-$pre_end)>$dist) or ($words[3] ne $pre_sign)){
		if($f==1){
			$out[$line_num].="\n";
			$line_num++;
			}
		
		}
	$f=1;
	$out[$line_num].= $words[0]."\t".$words[3]."\t".$words[4]."\t".$words[6]."\t";
	
	$pre_start=$words[1];
	$pre_end=$words[2];
	$pre_sign=$words[3];
	}

my$cnt;
foreach my$l (@out){
	
	$cnt=()=$l=~m/\+|\-/g;
	
	if($cnt<2){$l='';}
	
	}

open(FHout,'>'.$ARGV[1])or die;
print FHout @out;
close(FHout);

