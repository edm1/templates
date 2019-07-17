#!/usr/bin/env Rscript
#

library("tidyverse")

# Load data
df = read_tsv(infile)
head(df)
colnames(df)

#
# Load jsonl ------------------------------------------------------------------
#

library("jsonlite")

# Function to load a single json lines file
read_json_lines = function (in_json) {
  in_con = file(in_json, open="r")
  data_part = as.tibble(stream_in(in_con))
  close(in_con)
  return(data_part)
}

# Test loading single
tbl = read_json_lines(in_path_single)

# Test loading multipart json
in_files = list.files(path=in_path, pattern = "*.json", full.names = T)
tbl = sapply(in_files, read_json_lines, simplify=FALSE) %>% 
  bind_rows(.id = "id")
