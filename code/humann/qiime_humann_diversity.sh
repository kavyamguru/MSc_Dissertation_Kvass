#!/bin/bash
# =============================================================================
# Compute α‐ and β‐diversity on HUMAnN3‐prepared tables in QIIME 2
# =============================================================================

set -e

# 1) Paths to prepared HUMAnN3 tables and metadata
PREP_DIR="/home/s2754638/Kvass_project/results/humann3/host/host_statq020/prepared_for_qiime"
PATH_RELAB="$PREP_DIR/merged_pathabundance_relab.tsv"
GF_RELAB="$PREP_DIR/merged_genefamilies_relab.tsv"
META="/home/s2754638/B269797/metadata/shotgun/shotgun_metadata.tsv"

# 2) Output directories
ALPHA_DIR="/home/s2754638/Kvass_project/results/humann3/host/host_statq020/qiime_alpha"
BETA_DIR="/home/s2754638/Kvass_project/results/humann3/host/host_statq020/qiime_beta"
mkdir -p "$ALPHA_DIR" "$BETA_DIR"

# 3) Import pathway table
echo "📥 Importing pathway table into QIIME2"
# Convert TSV → BIOM
biom convert \
  -i "$PATH_RELAB" \
  -o "$PREP_DIR/pathways.biom" \
  --table-type "Pathway table" \
  --to-hdf5

# Import BIOM → QZA
qiime tools import \
  --input-path "$PREP_DIR/pathways.biom" \
  --type 'FeatureTable[Frequency]' \
  --input-format BIOMV210Format \
  --output-path "$PREP_DIR/pathways.qza"

# 4) Import gene-family table
echo "📥 Importing gene-family table into QIIME2"
biom convert \
  -i "$GF_RELAB" \
  -o "$PREP_DIR/genefamilies.biom" \
  --table-type "Gene table" \
  --to-hdf5

qiime tools import \
  --input-path "$PREP_DIR/genefamilies.biom" \
  --type 'FeatureTable[Frequency]' \
  --input-format BIOMV210Format \
  --output-path "$PREP_DIR/genefamilies.qza"

# 5) α-Diversity (Observed & Shannon)
echo "📊 Computing α-diversity"
for FEATURE in pathways genefamilies; do
  for METRIC in observed_features shannon; do
    qiime diversity alpha \
      --i-table "$PREP_DIR/${FEATURE}.qza" \
      --p-metric $METRIC \
      --o-alpha-diversity "$ALPHA_DIR/${FEATURE}_${METRIC}.qza"
  done
done

# 6) α-group-significance with shotgun metadata columns
echo "📈 Running alpha-group-significance"
for FEATURE in pathways genefamilies; do
  for METRIC in observed_features shannon; do
    for FACTOR in Starter Sample_Type Formulation Inulin Ginger Sugar; do
      qiime diversity alpha-group-significance \
        --i-alpha-diversity "$ALPHA_DIR/${FEATURE}_${METRIC}.qza" \
        --m-metadata-file   "$META" \
        --o-visualization   "$ALPHA_DIR/${FEATURE}_${METRIC}_${FACTOR}.qzv"
    done
  done
done

# ─── 7) β-Diversity (Bray–Curtis PCoA) via relative-frequency ────────────────
echo "📐 Computing β-diversity (via relative-frequency)"

for FEATURE in pathways genefamilies; do
  # 7a) Relative-frequency normalization
  qiime feature-table relative-frequency \
    --i-table "$PREP_DIR/${FEATURE}.qza" \
    --o-relative-frequency-table "$BETA_DIR/${FEATURE}_relfreq.qza"

  # 7b) Bray–Curtis distance (use 'braycurtis')
  qiime diversity beta \
    --i-table "$BETA_DIR/${FEATURE}_relfreq.qza" \
    --p-metric braycurtis \
    --o-distance-matrix "$BETA_DIR/${FEATURE}_bray.qza"

  # 7c) PCoA
  qiime diversity pcoa \
    --i-distance-matrix "$BETA_DIR/${FEATURE}_bray.qza" \
    --o-pcoa "$BETA_DIR/${FEATURE}_pcoa.qza"

  # 7d) Emperor
  qiime emperor plot \
    --i-pcoa "$BETA_DIR/${FEATURE}_pcoa.qza" \
    --m-metadata-file "$META" \
    --o-visualization "$BETA_DIR/${FEATURE}_emperor.qzv"
done

echo "✅ QIIME2 functional α/β-diversity complete."

