#!/usr/bin/env Rscript
#

library(biomaRt)

listMarts(host="grch37.ensembl.org")

ensembl=useMart("ENSEMBL_MART_ENSEMBL", host="grch37.ensembl.org", path="/biomart/martservice")
#ensembl=useMart("ensembl")
ensembl = useDataset("hsapiens_gene_ensembl",mart=ensembl)

#att = listAttributes(ensembl)

# Get exons
gb <- getBM(attributes=c("external_gene_name",
                         "ensembl_gene_id",
                         'ensembl_exon_id',
                         "chromosome_name",
                         "exon_chrom_start",
                         "exon_chrom_end"),
            # filters ="ensembl_gene_id",
            # values=c("ENSG00000185527", "ENSG00000182612", "ENSG00000182446"),
            mart=ensembl)
head(gb)

# Make into bed format
bed = cbind(gb$chromosome_name,
            gb$exon_chrom_start - 1,
            gb$exon_chrom_end,
            paste0(gb$ensembl_gene_id, ";", gb$external_gene_name),
            "."
            )
head(bed)

# Sort
bed = bed[ order(bed[,1], bed[,2], bed[,3]), ]

# Write
write.table(bed, file="grch37_gene_exons.bed", sep="\t", row.names=F, col.names=F, quote=F)
