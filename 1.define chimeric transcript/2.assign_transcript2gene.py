import sys
import os

"""
python3 2.assign_transcript2gene.py <trans_id to gene_id> <annotated GENECODE transcript.bed> <assembly transcript.bed>
"""

trans2gene = { line.strip().split('\t')[0]:line.strip().split('\t')[1:] 
               for line in open(sys.argv[1]) }          #trans_id:[gene_id, gene_type, gene_name]
res = { line.strip().split('\t')[3]:line.strip() 
        for line in open(sys.argv[2]) }                 #trans_id:trans_model

newAssembly = {}                                        #trans_id:[trans_model, [gene_id, gene_type, gene_name], coverage ]
cmd = 'bedtools intersect -wa -wb -s -a ./sample_merged.bed -b ./0.ref/gencode.vM1.gene.bed |bedtools overlap -i stdin -cols 2,3,14,15'
for line in os.popen(cmd).read().strip().split('\n'):
    s = line.strip().split('\t')
    if not s[3] in newAssembly:
        newAssembly[s[3]] = ['\t'.join(s[:12]), s[15].split('|'), int(s[-1])]
    elif int(s[-1]) > newAssembly[s[3]][-1]:
        newAssembly[s[3]][1] = s[15].split('|')
        newAssembly[s[3]][2] = int(s[-1])

#add new to annotated
for trans_id in newAssembly:
    trans_model, corresponding_gene, cov = newAssembly[trans_id]
    if trans_id in res:
        if trans_model != res[trans_id]:
            new_id = trans_id + '#1'
            trans2gene[new_id] = trans2gene[trans_id]
            res[new_id] = trans_model
    else:
        trans2gene[trans_id] = newAssembly[trans_id][1]
        res[trans_id] = newAssembly[trans_id][0]

for trans in res:
    s = res[trans].split('\t')
    s[3] = trans+"|"+ '|'.join(trans2gene[s[3]])
    print('\t'.join(s))

    
            
    
    






