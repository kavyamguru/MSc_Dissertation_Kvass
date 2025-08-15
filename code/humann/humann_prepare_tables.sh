#!/bin/bash
# =============================================================================
# Prepare HUMAnN3 tables for QIIME 2 diversity analyses
# =============================================================================

# 1) Paths to your raw merged HUMAnN3 outputs (unstratified)
BASE_DIR="/home/s2754638/Kvass_project/results/humann3/host/host_statq020"
# Unstratified pathway table at the root
PATH_ABUND="$BASE_DIR/pa_abundance_unstratified.tsv"
# Merged gene‐family table at the root
GF_ABUND="$BASE_DIR/merged_genefamilies.tsv"

OUT_DIR="$BASE_DIR/prepared_for_qiime"
mkdir -p "$OUT_DIR"

# 2) Check input files
if [[ ! -f "$PATH_ABUND" ]]; then
  echo "❌ Pathway abundance file not found: $PATH_ABUND" >&2
  exit 1
fi
if [[ ! -f "$GF_ABUND" ]]; then
  echo "❌ Gene-family file not found: $GF_ABUND" >&2
  exit 1
fi

# 3) Renormalize to relative abundances
echo "🔄 Renormalizing pathway abundances to relative abundances"
humann_renorm_table \
  --input "$PATH_ABUND" \
  --output "$OUT_DIR/merged_pathabundance_relab.tsv" \
  --units relab

echo "🔄 Renormalizing gene-family abundances to relative abundances"
humann_renorm_table \
  --input "$GF_ABUND" \
  --output "$OUT_DIR/merged_genefamilies_relab.tsv" \
  --units relab

# 4) Remove leading “#” if present
sed -i 's/^#//' "$OUT_DIR/merged_pathabundance_relab.tsv"
sed -i 's/^#//' "$OUT_DIR/merged_genefamilies_relab.tsv"

echo "✅ HUMAnN3 tables prepared in: $OUT_DIR"

