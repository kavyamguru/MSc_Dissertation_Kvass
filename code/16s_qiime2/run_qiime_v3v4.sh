#!/bin/bash
set -euo pipefail

# ==============================
# 16S V3–V4 (PE250) – GTDB RS226
# End-to-end QIIME 2 workflow
# ==============================

# ---- Inputs (edit if paths differ) ----
MANIFEST="/home/s2754638/Kvass_project/metadata/manifest_16S_all.tsv"
METADATA="/home/s2754638/B269797/metadata/16s/16s_metadata.tsv"

# V3–V4 primers used for sequencing
PRIMER_F="CCTAYGGGRBGCASCAG"      # 341F (degenerate)
PRIMER_R="GGACTACNNGGGTATCTAAT"   # 805R (degenerate)

# GTDB reference artifacts
REF_DIR="$HOME/Kvass_project/data/reference/gtdb"
REF_SEQS="$REF_DIR/gtdb-r226-16S-seqs.qza"
REF_TAX="$REF_DIR/gtdb-r226-16S-tax.qza"

# ---- Outputs ----
OUTDIR="/home/s2754638/B269797/results/16s/qiime_v3v4_final"
EXPORT_DIR="$OUTDIR/exports"
PHY_DIR="$OUTDIR/phylo_tree"
mkdir -p "$OUTDIR" "$EXPORT_DIR" "$PHY_DIR" "$OUTDIR/tmp_mpl"
export MPLCONFIGDIR="$OUTDIR/tmp_mpl"   # silence Matplotlib cache warning

# ---- Threads ----
THREADS=64

echo "▶ Step 1: Import reads"
qiime tools import \
  --type 'SampleData[PairedEndSequencesWithQuality]' \
  --input-path "$MANIFEST" \
  --output-path "$OUTDIR/demux.qza" \
  --input-format PairedEndFastqManifestPhred33V2

echo "▶ Step 2: Summarize demux"
qiime demux summarize \
  --i-data "$OUTDIR/demux.qza" \
  --o-visualization "$OUTDIR/demux.qzv"

echo "▶ Step 3: Trim primers with cutadapt"
qiime cutadapt trim-paired \
  --i-demultiplexed-sequences "$OUTDIR/demux.qza" \
  --p-front-f "$PRIMER_F" \
  --p-front-r "$PRIMER_R" \
  --p-match-read-wildcards \
  --p-cores $THREADS \
  --o-trimmed-sequences "$OUTDIR/trimmed.qza" \
  --verbose

echo "▶ Step 4: Summarize trimmed reads"
qiime demux summarize \
  --i-data "$OUTDIR/trimmed.qza" \
  --o-visualization "$OUTDIR/trimmed.qzv"

echo "▶ Step 5: DADA2 denoise-paired (trunc: 231/227; pseudo-pooling)"
qiime dada2 denoise-paired \
  --i-demultiplexed-seqs "$OUTDIR/trimmed.qza" \
  --p-trunc-len-f 0 \
  --p-trunc-len-r 0 \
  --p-trim-left-f 0 \
  --p-trim-left-r 0 \
  --p-pooling-method pseudo \
  --p-n-threads $THREADS \
  --o-table "$OUTDIR/table.qza" \
  --o-representative-sequences "$OUTDIR/rep-seqs.qza" \
  --o-denoising-stats "$OUTDIR/dada2_stats.qza" \
  --verbose

qiime feature-table summarize \
  --i-table "$OUTDIR/table.qza" \
  --o-visualization "$OUTDIR/table.qzv"

qiime metadata tabulate \
  --m-input-file "$OUTDIR/dada2_stats.qza" \
  --o-visualization "$OUTDIR/dada2_stats.qzv"

# ---- Train GTDB V3–V4 classifier (extract correct window) ----
EXTRACTED="$OUTDIR/gtdb-r226-16S-v3v4-extracted.qza"
CLASSIFIER="$OUTDIR/gtdb-r226-v3v4-classifier.qza"

if [[ ! -f "$CLASSIFIER" ]]; then
  echo "▶ Step 6: Extract GTDB V3–V4 window (380–550 bp)"
  qiime feature-classifier extract-reads \
    --i-sequences $REF_SEQS \
    --p-f-primer "$PRIMER_F" \
    --p-r-primer "$PRIMER_R" \
    --p-min-length 380 \
    --p-max-length 550 \
    --p-n-jobs $THREADS \
    --o-reads $EXTRACTED

  echo "▶ Step 7: Train Naive Bayes classifier (GTDB RS226, V3–V4)"
  qiime feature-classifier fit-classifier-naive-bayes \
    --i-reference-reads $EXTRACTED \
    --i-reference-taxonomy $REF_TAX \
    --o-classifier $CLASSIFIER
else
  echo "▶ Classifier exists, skipping training: $CLASSIFIER"
fi

echo "▶ Step 8: Classify features (n-jobs=$THREADS, confidence=0.2)"
qiime feature-classifier classify-sklearn \
  --i-classifier $CLASSIFIER \
  --i-reads "$OUTDIR/rep-seqs.qza" \
  --o-classification "$OUTDIR/taxonomy.qza" \
  --p-n-jobs $THREADS \
  --p-confidence 0.2 \
  --verbose

qiime metadata tabulate \
  --m-input-file "$OUTDIR/taxonomy.qza" \
  --o-visualization "$OUTDIR/taxonomy.qzv"

echo "▶ Step 9: Taxa barplot"
qiime taxa barplot \
  --i-table "$OUTDIR/table.qza" \
  --i-taxonomy "$OUTDIR/taxonomy.qza" \
  --m-metadata-file "$METADATA" \
  --o-visualization "$OUTDIR/taxa-barplot.qzv"

echo "▶ Step 10: Export raw table & taxonomy"
qiime tools export --input-path "$OUTDIR/table.qza" --output-path "$EXPORT_DIR"
biom convert -i "$EXPORT_DIR/feature-table.biom" -o "$EXPORT_DIR/feature-table.tsv" --to-tsv

qiime tools export --input-path "$OUTDIR/rep-seqs.qza" --output-path "$EXPORT_DIR"
qiime tools export --input-path "$OUTDIR/taxonomy.qza" --output-path "$EXPORT_DIR"

echo "▶ Step 11: Collapse to genus (L6) and phylum (L2) and export TSVs"
qiime taxa collapse \
  --i-table "$OUTDIR/table.qza" \
  --i-taxonomy "$OUTDIR/taxonomy.qza" \
  --p-level 6 \
  --o-collapsed-table "$OUTDIR/table_genus.qza"

qiime taxa collapse \
  --i-table "$OUTDIR/table.qza" \
  --i-taxonomy "$OUTDIR/taxonomy.qza" \
  --p-level 2 \
  --o-collapsed-table "$OUTDIR/table_phylum.qza"

mkdir -p "$EXPORT_DIR/collapsed"
qiime tools export --input-path "$OUTDIR/table_genus.qza"  --output-path "$EXPORT_DIR/collapsed/genus"
qiime tools export --input-path "$OUTDIR/table_phylum.qza" --output-path "$EXPORT_DIR/collapsed/phylum"
biom convert -i "$EXPORT_DIR/collapsed/genus/feature-table.biom"  -o "$EXPORT_DIR/collapsed/genus/table_genus.tsv"  --to-tsv
biom convert -i "$EXPORT_DIR/collapsed/phylum/feature-table.biom" -o "$EXPORT_DIR/collapsed/phylum/table_phylum.tsv" --to-tsv

echo "▶ Step 12: Build phylogenetic tree (optional but useful for UniFrac)"
qiime phylogeny align-to-tree-mafft-fasttree \
  --i-sequences "$OUTDIR/rep-seqs.qza" \
  --o-alignment "$PHY_DIR/aligned-rep-seqs.qza" \
  --o-masked-alignment "$PHY_DIR/masked-aligned-rep-seqs.qza" \
  --o-tree "$PHY_DIR/unrooted-tree.qza" \
  --o-rooted-tree "$PHY_DIR/rooted-tree.qza"

qiime tools export --input-path "$PHY_DIR/rooted-tree.qza" --output-path "$PHY_DIR/exported_tree"

echo "✅ Done. All outputs in: $OUTDIR"
echo "   - Exports (tables/taxonomy/rep-seqs): $EXPORT_DIR"
echo "   - Collapsed TSVs: $EXPORT_DIR/collapsed/{genus,phylum}"
echo "   - Visualizations: *.qzv (open in https://view.qiime2.org/)"
