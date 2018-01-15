#!/usr/bin/env bash
#

snakemake --jobs 100 --cluster-config cluster.json --cluster "python bsub.py"
