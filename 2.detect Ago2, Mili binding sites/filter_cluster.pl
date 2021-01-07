#!/usr/bin/perl
die "perl $0 raw.cluster.bed reads_perMillion_cutoff > filter.cluster.bed\n" if(@ARGV != 2);
my $raw_cluster=shift;
my $reads_num_perMillion_cutoff=shift;

open(RC,$raw_cluster) || die;
my $TotalReads_line=<RC>;
my $RPMCutoff_line=<RC>;
chomp $TotalReads_line;
my $total_reads_num=(split/\s+/,$TotalReads_line)[1];
while(my $line=<RC>){
	chomp $line;
	my @sub=split/\s+/,$line;
	my ($reads_num,$strand_ratio)=split/_/,$sub[4];
	my $reads_plus=$reads_num*(1+$strand_ratio)/2;
	my $reads_minus=$reads_num*(1-$strand_ratio)/2;
	$reads_plus+=0.2;	#repair the resolution of float calculation
	$reads_minus+=0.2;	#repair the resolution of float calculation
	#if($reads_plus < $total_reads_num*$reads_num_perMillion_cutoff and $reads_minus < $total_reads_num*$reads_num_perMillion_cutoff){
	if($reads_plus < $reads_num_perMillion_cutoff and $reads_minus < $reads_num_perMillion_cutoff){
		next;
	}
	else{
		print $line,"\n";
	}
}
