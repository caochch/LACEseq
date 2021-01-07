#!/usr/bin/perl
die "perl $0 Choi-Data-S1.mm9.formatted.gff\n" if(@ARGV != 1);
my $repeat_gene_gff=shift;

my $trans_id;
open(RGG,$repeat_gene_gff) || die;
while(my $line=<RGG>){
	chomp $line;
	my @sub=split/\s+/,$line;
	$trans_id++;
	print $sub[0],"\t",$sub[3],"\t",$sub[4],"\t";
	$sub[9]=~s/"//g;$sub[9]=~s/;//g;
	$sub[11]=~s/"//g;$sub[11]=~s/;//g;
	$sub[13]=~s/"//g;$sub[13]=~s/;//g;
	print "$trans_id#$sub[9]#$sub[11]#$sub[13]\t";
	print "255\t";
	print $sub[6],"\n";
}
	
