bedtools merge -i IgG.LACEseq.sort.bed > IgG.coverd_region.bed
bedtools intersect -a Ago2.LACEseq.sort.bed -b IgG.coverd_region.bed -v > Ago2.LACEseq.no_IgG.bed
bedtools merge -i Ago2.LACEseq.no_IgG.bed > Ago2.LACEseq.no_IgG.coverd_region.bed
perl find_cluster_seed.pl Ago2.LACEseq.no_IgG.coverd_region.bed Ago2.LACEseq.no_IgG.bed 200 0.01
perl filter_cluster.pl Ago2.LACEseq.no_IgG.cluster.bed 20 > Ago2.LACEseq.no_IgG.cluster.Cutoff20.bed
