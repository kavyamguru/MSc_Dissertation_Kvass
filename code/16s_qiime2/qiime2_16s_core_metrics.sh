#!/bin/bash

# =============================================================================
# Run QIIME2 Core Diversity Metrics on 16S Amplicon Data (B269797 structure)
# =============================================================================

# ----------- Variables -----------
# Base project directory (B269797 root)
BASE_DIR="$(dirname "$(dirname "$(dirname "$(realpath "$0")")")")"

# Input files based on B269797 structure
OUTDIR="$BASE_DIR/results/16s/qiime2_gtdb"
METADATA="$BASE_DIR/metadata/16s/16s_metadata.tsv"
TREE="$OUTDIR/phylo_tree/rooted-tree.qza"
TABLE="$OUTDIR/table.qza"

# Parameters
SAMPLING_DEPTH=49000
DIVERSITY_DIR="$OUTDIR/core_metrics"

# ----------- Remove Output Directory If It Exists -----------
if [ -d "$DIVERSITY_DIR" ]; then
  echo "⚠️ Directory already exists, removing: $DIVERSITY_DIR"
  rm -rf "$DIVERSITY_DIR"
fi

# ----------- Run Core Diversity Metrics -----------
qiime diversity core-metrics-phylogenetic \
  --i-phylogeny "$TREE" \
  --i-table "$TABLE" \
  --p-sampling-depth $SAMPLING_DEPTH \
  --m-metadata-file "$METADATA" \
  --output-dir "$DIVERSITY_DIR"

# ----------- Completion Message -----------
echo "✅ Diversity metrics saved to: $DIVERSITY_DIR"

