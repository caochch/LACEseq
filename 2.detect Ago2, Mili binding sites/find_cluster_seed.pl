#!/usr/bin/perl
die "perl $0 <cover_region.bed> <map.bed> merge_distance cluster_reads_perMillion_cutoff\n" if(@ARGV != 4);
my $cover_region_bed=shift;
my $map_bed=shift;
my $merge_distance=shift;
my $cluster_reads_perMillion_cutoff=shift;

my $unique_reads_num;
open(UQ,">tmp_unique_reads.bed") || die;
open(MAP,$map_bed) || die;
while(my $line=<MAP>){
        chomp $line;
        my ($chr,$start,$end,$name,$score,$strand)=split/\s+/,$line;
        if($unique{$chr."\t".$start."\t".$end."\t".$strand}){
                next;
        }
        else{
                $unique{$chr."\t".$start."\t".$end."\t".$strand}=1;
                $unique_reads_num++;
                print UQ $line,"\n";
        }
}
close UQ;

$unique_reads_num=$unique_reads_num/1000000;

#related ouput file name
my $out_cluster=$map_bed;
$out_cluster=~s/.*\///;
$out_cluster=~s/bed$/cluster.bed/;

`bedtools merge -d $merge_distance -i $cover_region_bed > tmp.cover_region.merge.bed`;
`bedtools intersect -a tmp.cover_region.merge.bed -b tmp_unique_reads.bed -wa -wb > tmp.cover_region.merge.intersect_reads.overlap`;
`perl infer_boundary_of_cluster.pl tmp.cover_region.merge.intersect_reads.overlap $unique_reads_num $cluster_reads_perMillion_cutoff > $out_cluster`;
`rm -rf tmp.cover_region.merge.bed tmp.cover_region.merge.intersect_reads.overlap tmp_unique_reads.bed`;

