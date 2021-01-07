bash 1.stringtie_work.sh

ls ./1.stringtie/*/*.gtf >sample.list
stringtie --merge -G /media/ibm_disk/work/database/Gencode.vM1/gencode.vM1.annotation.gtf -o sample_merged.gtf sample.list
gtfToGenePred sample_merged.gtf /dev/stdout |genePredToBed /dev/stdin sample_merged.bed

python3 2.assign_transcript2gene.py ./0.ref/trans2gene.txt ./0.ref/gencode.vM1.annotation.bed |sortBed >sample_merged_and_Genecode.bed

python3 3.extract_the_first_exon.py ./sample_merged_and_Genecode.bed |sortBed >sample_merged_and_Genecode.firstExon.bed

less -S sample_merged_and_Genecode.firstExon.bed |awk '{if($4~/^MSTRG/) print $0}' |bedtools intersect -a - -b ./0.ref/repeat_element_trans.LTR.bed -u >sample_merged_and_Genecode.firstExon.LTR-drived.bed



