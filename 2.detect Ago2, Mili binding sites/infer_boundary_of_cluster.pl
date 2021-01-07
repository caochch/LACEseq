#!/usr/bin/perl
die "perl $0 endosiRNA.cluster.intersect_reads.overlap all_reads_num reads_per_million_cutoff\n" if(@ARGV != 3);
my $endosiRNA_overlap_reads=shift;
my $all_reads_num=shift;
my $reads_num_perMillion_cutoff=shift;

my %endosiRNA_reads;
open(EOR,$endosiRNA_overlap_reads) || die;
while(my $line=<EOR>){
	chomp $line;
	my @sub=split/\s+/,$line;
	my $raw_cluster_id=$sub[0]."\t".$sub[1]."\t".$sub[2];
	if(exists $endosiRNA_reads{$raw_cluster_id}){
		$endosiRNA_reads{$raw_cluster_id}{$sub[8]}++; #reads
		if($sub[4] < $endosiRNA_reads{$raw_cluster_id}{2}){
			$endosiRNA_reads{$raw_cluster_id}{2}=$sub[4];
		}
		if($sub[5] > $endosiRNA_reads{$raw_cluster_id}{3}){
			$endosiRNA_reads{$raw_cluster_id}{3}=$sub[5];
		}
	}
	else{
		$endosiRNA_reads{$raw_cluster_id}{$sub[8]}=1;	#reads
		$endosiRNA_reads{$raw_cluster_id}{2}=$sub[4];
		$endosiRNA_reads{$raw_cluster_id}{3}=$sub[5];
	}
}

print "#TotalReads\t$all_reads_num\n";
print "#RPMCutoff\t$reads_num_perMillion_cutoff\n";

my $id_turn;
foreach my $raw_id (sort keys %endosiRNA_reads){
	my ($chr,$raw_start,$raw_end)=split/\s+/,$raw_id;
	my $start=$endosiRNA_reads{$raw_id}{2};
	my $end=$endosiRNA_reads{$raw_id}{3};
	my $len=$endosiRNA_reads{$raw_id}{3}-$endosiRNA_reads{$raw_id}{2};
	my $plus_reads=$endosiRNA_reads{$raw_id}{"+"}+0;
	my $minus_reads=$endosiRNA_reads{$raw_id}{"-"}+0;
	if($plus_reads < $reads_num_perMillion_cutoff*$all_reads_num and $minus_reads < $reads_num_perMillion_cutoff*$all_reads_num){
		next;
	}
	$id_turn++;
	my $total_reads=$minus_reads+$plus_reads;
	my $strand_ratio=($minus_reads-$plus_reads)/($minus_reads+$plus_reads);
	if($strand_ratio > 0){	#minus reads > plus reads; -> plus RNA
		print $chr,"\t",$endosiRNA_reads{$raw_id}{2},"\t",$endosiRNA_reads{$raw_id}{3},"\t","Cluster_$id_turn","\t",$total_reads,"_",$strand_ratio,"\t+\n";
	}
	else{
		print $chr,"\t",$endosiRNA_reads{$raw_id}{2},"\t",$endosiRNA_reads{$raw_id}{3},"\t","Cluster_$id_turn","\t",$total_reads,"_",$strand_ratio,"\t-\n";
	}
}
