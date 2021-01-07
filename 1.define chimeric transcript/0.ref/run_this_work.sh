1.Please download "gencode.vM1.annotation.gtf" from GENCODE database
2.Please download "Choi-Data-S1.gff" from the supplementary files for the article "Deficiency of microRNA miR-34a expands cell fate potential inpluripotent stem cells" (https://science.sciencemag.org/content/355/6325/eaag1927)


less -S gencode.vM1.annotation.gtf |grep -w "gene" |awk 'BEGIN{OFS="\t"}{print $1, $4-1, $5, $10"|"$14"|"$18, 0, $7}' |sed 's/"//g' |sed 's/;//g' >gencode.vM1.gene.bed

gtfToGenePred -ignoreGroupsWithoutExons gencode.vM1.annotation.gtf /dev/stdout |genePredToBed /dev/stdin gencode.vM1.annotation.bed

less -S gencode.vM1.annotation.gtf |grep -w "transcript" |awk 'BEGIN{OFS="\t"}{print $12, $10, $14, $18}' |sed 's/"//g' |sed 's/;//g' >trans2gene.txt

liftOver -gff Choi-Data-S1.gff mm10ToMm9.over.chain Choi-Data-S1.mm9.gff Choi-Data-S1.mm9.gff.unmap
perl str_to_int.pl Choi-Data-S1.mm9.gff > Choi-Data-S1.mm9.formatted.gff
perl extract_trans_bed.pl Choi-Data-S1.mm9.formatted.gff > repeat_element_trans.bed
less -S repeat_element_trans.bed |grep "#LTR/" >repeat_element_trans.LTR.bed

less -S gencode.vM1.annotation.gtf |grep -w "exon" |awk 'BEGIN{OFS="\t"}{print $1, $4-1, $5, "Exon", 0, $7}' |sortBed |mergeBed -s |awk 'BEGIN{OFS="\t"}{print $1, $2, $3, "Exon_"NR, 0, $4}' >gencode.vM1.exon.bed


