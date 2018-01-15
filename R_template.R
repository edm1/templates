#!/usr/bin/env Rscript
#

library("tidyverse")

# Args
infile = ""

# Load data
df = read_tsv(infile)
head(df)
colnames(df)
