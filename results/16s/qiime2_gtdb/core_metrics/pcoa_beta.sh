#!/usr/bin/env bash

# activate qiime2
#conda activate qiime2-2024.2   # adjust to your install

# make export dirs
mkdir -p figs/beta/{weighted,bray,unweighted,jaccard}

# export PCoA results (these contain the coordinates you’ll plot)
qiime tools export --input-path weighted_unifrac_pcoa_results.qza   --output-path figs/beta/weighted
qiime tools export --input-path bray_curtis_pcoa_results.qza        --output-path figs/beta/bray
qiime tools export --input-path unweighted_unifrac_pcoa_results.qza --output-path figs/beta/unweighted
qiime tools export --input-path jaccard_pcoa_results.qza            --output-path figs/beta/jaccard

# (optional) export distance matrices too, if you want them archived
qiime tools export --input-path weighted_unifrac_distance_matrix.qza   --output-path figs/beta/weighted
qiime tools export --input-path bray_curtis_distance_matrix.qza        --output-path figs/beta/bray

