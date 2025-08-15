#!/usr/bin/env bash
set -euo pipefail

# Navigate to the directory containing the final CPM tables
cd "$(dirname "$0")"/../../results/humann/raw   # adjust this path if needed

# Run the extractor
python ../../code/humann/scripts/extract_curated_final.py \
  --ko gf_ko_cpm.tsv \
  --uniref uniref_cpm_clean.tsv \
  --paths pathways_cpm_clean.tsv \
  --targets ../../data/humann/curated/final_curated_gene_list.tsv \
  --path-targets ../../data/humann/curated/curated_pathways.tsv \
  --outdir ../curated_hits/output_hits

