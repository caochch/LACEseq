#!/usr/bin/perl
open(IN,"Choi-Data-S1.mm9.gff") || die;
while(my $line=<IN>){
	chomp $line;
	my @sub=split/\t/,$line;
	$sub[3]=int($sub[3]);
	$sub[4]=int($sub[4]);
	$new=join"\t",@sub;
	print $new,"\n"
}
	
