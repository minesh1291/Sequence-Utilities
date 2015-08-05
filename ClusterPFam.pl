#!/usr/bin/perl

##
#	Use : Count/Classify Proteins by their Domain Structure
#	Require : PFam Output File
#	Usage : perl ClusterPFam.pl <PFamFile> <Family/Domain/Repeat/All> <OutputFile>
##

use strict;
use warnings;

unless(@ARGV>=3){
	print "USAGE:\n\tperl $0 PfamFile Family/Domain/Repeat/All OutFilename\n";
	exit;
	}

my$fname=$ARGV[0];
my$class=$ARGV[1];
my$out_fname=$ARGV[2];

if(($class eq 'All') or ($class eq 'all')){
	$class='.';
	}

open(FH,$fname);
my@cont=<FH>;
close(FH);

my@words;
my%h;
my%uniq_Pfam;
my$PfamID;
my$Pfam;
my$SeqID;
my$FamDoRe;
my$famIn;

print STDERR "\nReading PFam File...\n";

foreach my$line (@cont){
	if($line=~/^(#|$)/){next;}
	@words=split(' ',$line);
	$SeqID=$words[0];
	$PfamID=$words[5];
	$Pfam=$words[6]; #edited
	$FamDoRe=$words[7];
	unless($FamDoRe=~/$class/){next;}
	$uniq_Pfam{$Pfam}=1;
	push(@{${$h{$SeqID}}[0]},$Pfam);
	}

my@SeqIDs=keys(%h);
my@Pfams=keys(%uniq_Pfam);
my$seq_cnt=scalar(@SeqIDs);

print STDERR  "\nTotal PFams:",scalar(@Pfams),"\n";
print STDERR  "\nTotal Sequences:",$seq_cnt,"\n";

############ counting max for tmp to sort

my$max=0;
foreach my$id(@SeqIDs){
 if($max<($#{${$h{$id}}[0]}+1)){
	 $max=($#{${$h{$id}}[0]}+1);
	 }
}

open(FH,">tmp");

foreach my$id(@SeqIDs){
	
	print FH join("\t",@{${$h{$id}}[0]}),"\t";
	
	for(my$i=1;$i<=$max-$#{${$h{$id}}[0]}-1;$i++){
		print FH "0\t";
		}
	
	print FH "$id\n";
	
	}
close(FH);

my$cmd="sort -k $max -n tmp > tmp.or";

system($cmd);

################### reading sorted tmp

open(FH,'tmp.or');
my@newCont=<FH>;
close(FH);

open(FH,">".$out_fname);

my@pre_words=split("\t",$newCont[0]);
my$cls_no=1;
my@mem_cnt; #member domains of each cluster = array of array_ref

print FH "\n##########\n# ";

foreach (@pre_words){
	unless( $_ =~ /^0$/ or ($_ eq $pre_words[$max]) ){								##correction1
		print FH $_," ";
		push(@{$mem_cnt[$cls_no-1]},$_);
		}else{ 
			last;
			}
	}
	print FH "\n##########\n\n";

	my$mem_C;
for(my$i=0;$i<=$#newCont;$i++){
	my$line=$newCont[$i];
	@words=split("\t",$line);
	my@w1=splice(@pre_words,0,$max);
	my@w2=splice(@words,0,$max);
	my$w1=join('',@w1);
	my$w2=join('',@w2);
	if($w1 eq $w2){
		print FH @words;
		}else{
			$cls_no++;
			print FH "\n##########\n# ";
			foreach(@w2){
				unless( $_ =~ /^0$/ ){ 		##correction not required
					print FH $_," ";
					}else{ 
						last;
						}
				}
			print FH "\n##########\n\n";
			print FH @words;
			}
	@pre_words=split("\t",$line);
	}
close(FH);


######################################
count_clust($out_fname,$out_fname.'_stat');
######################################
system("rm tmp tmp.or");
######################################

exit;

sub count_clust{
my$fname=shift@_;
my$fname_out=shift@_;
open(FH,$fname);
my@cont=<FH>;
close(FH);
my%h;
my$head;
foreach my$line(@cont){
	if($line=~/^# (.+)/){
		$head=$1;
		$h{$head}=0;
		}
	if($line=~/^\w/){
		$h{$head}++;
		}
	}
my@k=keys(%h);
@k=sort@k;
open(FHout,">".$fname_out);
foreach my $key(@k){
	print FHout $h{$key},"\t",$key,"\n";
	}
print FHout "\nNo of Clusters : ",$cls_no,"\n";
print FHout  "\nTotal PFams:",scalar(@Pfams),"\n";
print FHout  "\nTotal Sequences:",$seq_cnt,"\n";
close(FHout);

	}
