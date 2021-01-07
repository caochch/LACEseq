import sys

for line in open(sys.argv[1]):
    chrom, start, end, name, _, strand, cdsStart, cdsEnd, _, exon_num, exon_lengths, exon_starts = line.strip().split('\t')
    start, end = int(start), int(end)
    exon_lengths = list( map(int, exon_lengths.strip().split(',')[:-1]) )
    exon_starts = list( map(int, exon_starts.strip().split(',')[:-1]) )

    if strand == "+":
        end = start + exon_lengths[0]
    else:
        start = end - exon_lengths[-1]

    print(chrom, start, end, name, 0, strand, sep="\t")

